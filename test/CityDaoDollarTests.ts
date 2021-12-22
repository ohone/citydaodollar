import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { City } from "../typechain-types/City";
import { CitizenNFT } from "../typechain-types/CitizenNFT";
import { BaseContract } from "@ethersproject/contracts";

async function InitializeContract<T extends BaseContract>(
  name: string,
  ...args: any[]
): Promise<T> {
  return (await (await ethers.getContractFactory(name)).deploy(...args)) as T;
}

describe("deployment", function () {
  let cityDaoDollar: City;
  let citizenNFT: CitizenNFT;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];

  beforeEach(async () => {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    citizenNFT = await InitializeContract<CitizenNFT>(
      "CitizenNFT",
      addr1.address,
      1
    );
    cityDaoDollar = await InitializeContract<City>("city", citizenNFT.address);
  });

  it("Should initialize with no supply", async function () {
    expect(await cityDaoDollar.totalSupply()).to.equal(0);
  });

  it("owner should have no balance", async function () {
    expect(await cityDaoDollar.balanceOf(owner.address)).to.equal(0);
  });

  it("arbitrary address should have no balance", async function () {
    expect(await cityDaoDollar.balanceOf(addr1.address)).to.equal(0);
  });
});

async function TransferCitizenTo(
  recipient: SignerWithAddress,
  nftContract: CitizenNFT
): Promise<void> {
  await nftContract.connect(recipient).onlineApplicationForCitizenship(1, {
    value: ethers.utils.parseEther("0.25"),
  });
}

describe("minting", function () {
  let cityDaoDollar: City;
  let citizenNFT: CitizenNFT;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();

    citizenNFT = await InitializeContract<CitizenNFT>(
      "CitizenNFT",
      addr1.address,
      1
    );
    cityDaoDollar = await InitializeContract<City>("city", citizenNFT.address);
    await citizenNFT.initialCitizenship();
    await citizenNFT.reserveCitizenships(1000);
    await TransferCitizenTo(addr2, citizenNFT);
    await citizenNFT
      .connect(addr2)
      .setApprovalForAll(cityDaoDollar.address, true);
  });

  it("increases address token balance by 1000", async function () {
    await cityDaoDollar.connect(addr2).mint(addr2.address, 0, 1);

    expect(
      await cityDaoDollar.connect(addr2).balanceOf(addr2.address)
    ).to.equal(1000);
  });

  it("transfers ownership of citizen to contract", async function () {
    await cityDaoDollar.connect(addr2).mint(addr2.address, 42, 1);

    expect(await citizenNFT.balanceOf(addr2.address, 42)).to.equal(0);
    expect(await citizenNFT.balanceOf(cityDaoDollar.address, 42)).to.equal(1);
  });

  it("increases supply by 1000", async function () {
    await cityDaoDollar.connect(addr2).mint(addr2.address, 42, 1);

    expect(await cityDaoDollar.totalSupply()).to.equal(1000);
  });
});

describe("burning", function () {
  let cityDaoDollar: City;
  let citizenNFT: CitizenNFT;
  let owner: SignerWithAddress;
  let thirdParty: SignerWithAddress;
  let nftOwner: SignerWithAddress;

  beforeEach(async () => {
    [owner, thirdParty, nftOwner] = await ethers.getSigners();

    citizenNFT = await InitializeContract<CitizenNFT>(
      "CitizenNFT",
      thirdParty.address,
      1
    );
    cityDaoDollar = await InitializeContract<City>("city", citizenNFT.address);
    await citizenNFT.initialCitizenship();
    await citizenNFT.reserveCitizenships(1000);

    await TransferCitizenTo(nftOwner, citizenNFT);
    await citizenNFT
      .connect(nftOwner)
      .setApprovalForAll(cityDaoDollar.address, true);

    await cityDaoDollar.connect(nftOwner).mint(nftOwner.address, 42, 1);
  });

  it("reduces burned address token balance by 1000", async function () {
    const initialBalance = await cityDaoDollar.balanceOf(nftOwner.address);

    await cityDaoDollar
      .connect(nftOwner)
      .burn(nftOwner.address, nftOwner.address, 1);

    const postBurnBalance = await cityDaoDollar
      .connect(nftOwner)
      .balanceOf(nftOwner.address);

    expect(postBurnBalance).to.equal(initialBalance.sub(1000));
  });

  it("decreases supply by 1000", async function () {
    const initialSupply = await cityDaoDollar.totalSupply();

    await cityDaoDollar
      .connect(nftOwner)
      .burn(nftOwner.address, nftOwner.address, 1);

    const postBurnSupply = await cityDaoDollar.totalSupply();

    expect(postBurnSupply).to.equal(initialSupply.sub(1000));
  });

  it("transfers ownership of citizen to `to` address", async function () {
    await cityDaoDollar
      .connect(nftOwner)
      .burn(nftOwner.address, thirdParty.address, 1);

    expect(await citizenNFT.balanceOf(thirdParty.address, 42)).to.equal(1);
  });
});
