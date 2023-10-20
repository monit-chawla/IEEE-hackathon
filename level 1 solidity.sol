// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArticleManagementSystem {
    struct Article {
        uint256 id;
        address author;
        string title;
        string content;
        uint256 timestamp;
    }

    Article[] public articles;
    mapping(address => uint256[]) authorArticles;

    function createArticle(string memory _title, string memory _content) public {
        uint256 articleId = articles.length;
        articles.push(Article(articleId, msg.sender, _title, _content, block.timestamp));
        authorArticles[msg.sender].push(articleId);
    }

    function readArticle(uint256 _articleId) public view returns (uint256, address, string memory, string memory, uint256) {
        require(_articleId < articles.length, "Article does not exist.");
        Article storage article = articles[_articleId];
        return (article.id, article.author, article.title, article.content, article.timestamp);
    }

    function updateArticle(uint256 _articleId, string memory _content) public {
        require(_articleId < articles.length, "Article does not exist.");
        Article storage article = articles[_articleId];
        require(msg.sender == article.author, "Only the author can update the article.");
        article.content = _content;
    }

    function deleteArticle(uint256 _articleId) public {
        require(_articleId < articles.length, "Article does not exist.");
        Article storage article = articles[_articleId];
        require(msg.sender == article.author, "Only the author can delete the article.");
        delete articles[_articleId];
        uint256[] storage authorArticleIds = authorArticles[msg.sender];
        for (uint i = 0; i < authorArticleIds.length; i++) {
            if (authorArticleIds[i] == _articleId) {
                authorArticleIds[i] = authorArticleIds[authorArticleIds.length - 1];
                authorArticleIds.pop();
                break;
            }
        }
    }
}