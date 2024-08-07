--Top 10 selling Video Games of ALl TIME
select Name,Platform,Year_of_Release,NA_sales,EU_sales,JP_sales,other_sales,Global_sales from sales order by global_sales desc limit 10;
        --to find the years of Top 10 selling Video Games of ALl TIME
With CTE as (select Name,Platform,Year_of_Release,NA_sales,EU_sales,JP_sales,other_sales,Global_sales from sales order by global_sales desc limit 10)
select Name,Platform,Year_of_Release,NA_sales,EU_sales,JP_sales,other_sales,Global_sales from CTE order by Year_of_Release;




--Years that video game critics loved
select c.Name,c.Platform,c.Year_of_Release,c.Critic_Count,c.Critic_Score,s.global_sales from sales s join critics c on s.Name = c.Name where c.Critic_Score <>''  and c.Year_of_Release<>'N/A' group by(c.Year_of_Release) order by Critic_Score desc limit 10;



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
    year, 
    SUM(games_sold) AS total_games_sold;


  

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
Limit 5;
