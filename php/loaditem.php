<?php
include_once("dbconnect.php");

$sqlloaditem ="SELECT * FROM tbl_item ORDER BY dateadded DESC";
$result = $conn->query($sqlloaditem);

if($result ->num_rows >0)
    {$response["item"] = array();
     while ($row = $result -> fetch_assoc())
        {$itemList = array();
         $itemList[id] = $row['id'];
         $itemList[image] = $row['image'];
         $itemList[name] = $row['name'];
         $itemList[price] = $row['price'];
         array_push($response["item"], $itemList);
        }
     echo json_encode($response);
    }
else
    {echo "failed";
    }
    
?>