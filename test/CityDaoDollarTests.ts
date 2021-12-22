import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { City } from "../typechain-types/City";
import { CitizenNFT } from "../typechain-types/CitizenNFT";
import { Console } from "console";

describe("CityDaoDollar Contract", function () {
  let cityDaoDollar: City;
  let citizenNFT: CitizenNFT;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];

  beforeEach(async () => {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    citizenNFT = (await (
      await ethers.getContractFactory("CitizenNFT")
    ).deploy(addr1.address, 1)) as CitizenNFT;

    cityDaoDollar = (await (
      await ethers.getContractFactory("city")
    ).deploy(citizenNFT.address)) as City;
  });
  it("Should initialize with no supply", async function () {
    expect(await cityDaoDollar.totalSupply()).to.equal(0);
  });
  it("Shouldnt allow minting if caller unapproved for tokens", async function () {
    try {
      await cityDaoDollar.mint(owner.address, 1, 1);
    } catch (error) {
      return;
    }
    expect(false).to.equal(true);
    //await expect(await mint.wait()).to.be.reverted;
  });
  it("mint creates 1000 tokens for one locked nft", async function () {
    await citizenNFT.initialCitizenship();
    await citizenNFT.reserveCitizenships(1000);
    await citizenNFT.setApprovalForAll(citizenNFT.address, true);
    await citizenNFT.connect(addr2).onlineApplicationForCitizenship(1, {
      value: ethers.utils.parseEther("0.25"),
    });
    await citizenNFT
      .connect(addr2)
      .setApprovalForAll(cityDaoDollar.address, true);

    await cityDaoDollar.connect(addr2).mint(addr2.address, 42, 1);

    expect(
      await cityDaoDollar.connect(addr2).balanceOf(addr2.address)
    ).to.equal(1000);
  });
});
