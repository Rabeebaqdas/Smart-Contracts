//SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IERC4907 {

    event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);

    function setUser(uint256 tokenId, address user, uint64 expires) external;

    function userOf(uint256 tokenId) external view returns(address);


    function userExpires(uint256 tokenId) external view returns(uint256);

}

contract ERC4907 is ERC721,IERC4907 {
    struct UserInfo 
    {
        address user;   
        uint64 expires; //time
    }

    mapping (uint256  => UserInfo) internal _users;

    constructor()ERC721("Tokens","MyToken"){}

    function mint(uint256 tokenId) public {
        _mint(msg.sender,tokenId);
    }

    function setUser(uint256 tokenId, address user, uint64 expires) public virtual override{
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC4907: transfer caller is not owner nor approved");
        UserInfo storage info =  _users[tokenId];
        require(info.user==address(0),"nft already on Rent"); 
        info.user = user;
        info.expires = uint64(block.timestamp + expires);
        emit UpdateUser(tokenId, user, expires);
    }

    function userOf(uint256 tokenId) public view virtual override returns(address){
        if( uint256(_users[tokenId].expires) >=  block.timestamp){
            return  _users[tokenId].user;
        }
        else{
            return address(0);
        }
    }

    function userExpires(uint256 tokenId) public view virtual override returns(uint256){
        if( uint256(_users[tokenId].expires) >=  block.timestamp){
            return _users[tokenId].expires;
        }
        else{
            return 0;
        }
    }


    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        super._beforeTokenTransfer(from, to, tokenId,1);

        if (from != to && _users[tokenId].user != address(0)) {
            delete _users[tokenId];
            emit UpdateUser(tokenId, address(0), 0);
        }
    }
} 
