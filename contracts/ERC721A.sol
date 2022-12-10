// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "erc721a/contracts/ERC721A.sol";

contract MyNFT is ERC721A {
    uint256 token_count;
    uint256 _value;
    string public baseURI;
    address payable public owner;
    //white list bool
    mapping(address => bool) public whiteList;
    //events
    event NFTMinted(
        string minted
    );
    
    event NFTTransferred(
        string transferred
    );
    event NFTWhiteListed(
        string whiteListed
    );
    event NFTWhiteListRemoved(
        string whiteListRemoved
    );
    //constructor
    constructor
    (
        string memory name,
        string memory symbol,
        string memory _baseURI,
        uint256 value
    )
    ERC721A(name, symbol)
    {
        _value = value;
        owner = payable(msg.sender);
        baseURI = _baseURI;
        token_count = 0;
    }
    //@dev onlyWHitelisted pelople modifier
    modifier OnlyWhiteListed() {
        require(whiteList[msg.sender] == true, "you need to be white listed");
        _;
    }
    //@dev modifier onlyOwner
    modifier onlyOwner(){
        require(owner == msg.sender, "you need to be the project owner");
        _;
    }
    //@dev minting function
    function mint(uint256 quantity) public payable OnlyWhiteListed {
        require(msg.value == _value);
        token_count += 1;
        _mint(msg.sender, quantity);
        emit NFTMinted("NFT minted");
    }
    //@dev white listing function
    function whiteListAddress(address _address) public onlyOwner {
        whiteList[_address] = true;
        emit NFTWhiteListed("NFT white listed");
    }
    //@dev remove white list address
    function removeWhiteListAddress(address _address) public OnlyWhiteListed {
        whiteList[_address] = false;
        emit NFTWhiteListRemoved("NFT white list removed");
    }

    // @dev See {IERC721Metadata-tokenURI}
      function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return
        baseURI;
    }
}

