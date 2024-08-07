--Top 10 selling Video Games of ALl TIME
SELECT Name,
        Platform,
        Year_of_Release,NA_sales,
        EU_sales,
        JP_sales,
        other_sales,
        Global_sales 
FROM sales
ORDER BY global_sales DESC LIMIT 10;




--Years that video game critics loved
SELECT c.Name,
        c.Platform,
        c.Year_of_Release,
        c.Critic_Count,
        c.Critic_Score,
        s.global_sales 
FROM sales s 
JOIN critics c 
ON s.Name = c.Name 
WHERE c.Critic_Score <>''  
AND c.Year_of_Release<>'N/A' 
GROUP BY(c.Year_of_Release) 
ORDER BY Critic_Score DESC LIMIT 10;




--Was 1982 really that great?

SELECT
    G.Year_of_Release,
    ROUND(AVG(R.Critic_Score), 2) AS avg_critic_score,
    COUNT(G.Name) AS num_games
FROM sales AS G
INNER JOIN critics AS R
ON G.Name = R.Name
GROUP BY G.Year_of_Release
HAVING COUNT(G.Name) > 4
ORDER BY avg_critic_score DESC
LIMIT 10;



--Years video game players loved

SELECT
    u.Year_of_Release,
    ROUND(AVG(u.User_Score), 2) AS avg_user_score,
    COUNT(u.Name) AS num_games
FROM user AS u
GROUP BY u.Year_of_Release
HAVING COUNT(u.Name) > 4
ORDER BY avg_user_score DESC
LIMIT 10;



--Years that both players and critics loved

WITH user_scores AS (
    SELECT
        u.Year_of_Release,
        ROUND(AVG(u.User_Score), 2) AS avg_user_score,
        COUNT(u.Name) AS num_games
    FROM user AS u
    GROUP BY u.Year_of_Release
    HAVING COUNT(u.Name) > 4
),
critic_scores AS (
    SELECT
        c.Year_of_Release,
        ROUND(AVG(c.Critic_Score), 2) AS avg_critic_score,
        COUNT(c.Name) AS num_games
    FROM critics AS c
    GROUP BY c.Year_of_Release
    HAVING COUNT(c.Name) > 4
)
SELECT
    us.Year_of_Release,
    us.avg_user_score,
    cs.avg_critic_score,
    us.num_games
FROM user_scores us
JOIN critic_scores cs ON us.Year_of_Release = cs.Year_of_Release
ORDER BY us.avg_user_score DESC, cs.avg_critic_score DESC
LIMIT 10;



--Sales in the best video game years

WITH user_scores AS (
    SELECT
        u.Year_of_Release,
        ROUND(AVG(u.User_Score), 2) AS avg_user_score,
        COUNT(u.Name) AS num_games
    FROM user AS u
    GROUP BY u.Year_of_Release
    HAVING COUNT(u.Name) > 4
),
critic_scores AS (
    SELECT
        c.Year_of_Release,
        ROUND(AVG(c.Critic_Score), 2) AS avg_critic_score,
        COUNT(c.Name) AS num_games
    FROM critics AS c
    GROUP BY c.Year_of_Release
    HAVING COUNT(c.Name) > 4
)
SELECT
    g.Year_of_Release AS year,
    SUM(g.Global_Sales) AS total_games_sold
FROM user_scores us
JOIN critic_scores cs ON us.Year_of_Release = cs.Year_of_Release
JOIN sales g ON us.Year_of_Release = g.Year_of_Release
GROUP BY g.Year_of_Release
ORDER BY total_games_sold DESC
LIMIT 5;
