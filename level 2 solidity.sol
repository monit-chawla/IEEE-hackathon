// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArticleManager {
    struct Article {
        uint256 id;
        string title;
        string content;
        address author;
    }

    struct User {
        uint256 id;
        address userAddress;
        uint256[] articleIds;
    }

    mapping(address => User) public users;
    mapping(uint256 => Article) public articles;
    uint256 public userCount;
    uint256 public articleCount;

    event UserRegistered(address indexed userAddress, uint256 userId);
    event ArticleAdded(address indexed author, uint256 articleId, string title);
    event ArticleUpdated(address indexed author, uint256 articleId, string newTitle);
    event ArticleDeleted(address indexed author, uint256 articleId);

    function registerUser() public {
        userCount++;
        users[msg.sender] = User(userCount, msg.sender, new uint256[](0));
        emit UserRegistered(msg.sender, userCount);
    }

    function addArticle(string memory title, string memory content) public {
        articleCount++;
        articles[articleCount] = Article(articleCount, title, content, msg.sender);
        users[msg.sender].articleIds.push(articleCount);
        emit ArticleAdded(msg.sender, articleCount, title);
    }

    function updateArticle(uint256 articleId, string memory newTitle) public {
        Article storage article = articles[articleId];
        require(msg.sender == article.author, "You can only update your own articles");
        article.title = newTitle;
        emit ArticleUpdated(msg.sender, articleId, newTitle);
    }

    function deleteArticle(uint256 articleId) public {
        Article storage article = articles[articleId];
        require(msg.sender == article.author, "You can only delete your own articles");
        delete articles[articleId];
        for (uint i = 0; i < users[msg.sender].articleIds.length; i++) {
            if (users[msg.sender].articleIds[i] == articleId) {
                delete users[msg.sender].articleIds[i];
                break;
            }
        }
        emit ArticleDeleted(msg.sender, articleId);
    }
}