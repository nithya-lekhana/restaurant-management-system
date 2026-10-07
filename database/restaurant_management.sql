CREATE DATABASE  IF NOT EXISTS `restaurant_management` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `restaurant_management`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: restaurant_management
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `available_tables_view`
--

DROP TABLE IF EXISTS `available_tables_view`;
/*!50001 DROP VIEW IF EXISTS `available_tables_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `available_tables_view` AS SELECT 
 1 AS `table_id`,
 1 AS `area_name`,
 1 AS `table_number`,
 1 AS `capacity`,
 1 AS `table_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `bill_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `discount_id` int DEFAULT NULL,
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL,
  `bill_status` varchar(20) NOT NULL DEFAULT 'OPEN',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `closed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`bill_id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `fk_bill_discount` (`discount_id`),
  CONSTRAINT `fk_bill_discount` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`discount_id`),
  CONSTRAINT `fk_bill_order` FOREIGN KEY (`order_id`) REFERENCES `food_order` (`order_id`),
  CONSTRAINT `chk_bill_discount` CHECK ((`discount_amount` >= 0)),
  CONSTRAINT `chk_bill_status` CHECK ((`bill_status` in (_cp850'OPEN',_cp850'CLOSED',_cp850'CANCELLED'))),
  CONSTRAINT `chk_bill_subtotal` CHECK ((`subtotal` >= 0)),
  CONSTRAINT `chk_bill_tax` CHECK ((`tax_amount` >= 0)),
  CONSTRAINT `chk_bill_total` CHECK ((`total_amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (1,1,940.00,1,94.00,47.00,893.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(2,2,860.00,NULL,0.00,43.00,903.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(3,3,1355.00,2,203.25,67.75,1219.50,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(4,4,1340.00,NULL,0.00,67.00,1407.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(5,5,1180.00,3,236.00,59.00,1003.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(6,6,1500.00,NULL,0.00,75.00,1575.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(7,7,1080.00,4,200.00,54.00,934.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(8,8,940.00,NULL,0.00,47.00,987.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(9,9,640.00,NULL,0.00,32.00,672.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(10,10,710.00,NULL,0.00,35.50,745.50,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(11,11,1320.00,NULL,0.00,66.00,1386.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(12,12,1760.00,NULL,0.00,88.00,1848.00,'CLOSED','2026-10-06 18:29:38','2026-10-06 18:30:35'),(16,14,480.00,NULL,0.00,24.00,504.00,'CLOSED','2026-10-07 09:29:53','2026-10-07 09:30:31');
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validate_bill_discount` BEFORE INSERT ON `bill` FOR EACH ROW BEGIN
    DECLARE discount_active BOOLEAN;

    IF NEW.discount_id IS NOT NULL THEN

        SELECT is_active
        INTO discount_active
        FROM discount
        WHERE discount_id = NEW.discount_id;

        IF discount_active = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot apply an inactive discount';
        END IF;

    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevent_closed_bill_update` BEFORE UPDATE ON `bill` FOR EACH ROW BEGIN
    IF OLD.bill_status = 'CLOSED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Closed bills cannot be modified';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevent_closed_bill_delete` BEFORE DELETE ON `bill` FOR EACH ROW BEGIN
    IF OLD.bill_status = 'CLOSED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Closed bills cannot be deleted';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Rahul Sharma','9876500001','rahul.sharma@gmail.com','2026-10-06 18:16:47'),(2,'Ananya Rao','9876500002','ananya.rao@gmail.com','2026-10-06 18:16:47'),(3,'Arjun Reddy','9876500003','arjun.reddy@gmail.com','2026-10-06 18:16:47'),(4,'Priya Nair','9876500004','priya.nair@gmail.com','2026-10-06 18:16:47'),(5,'Karan Mehta','9876500005','karan.mehta@gmail.com','2026-10-06 18:16:47'),(6,'Sneha Kapoor','9876500006','sneha.kapoor@gmail.com','2026-10-06 18:16:47'),(7,'Vikram Singh','9876500007','vikram.singh@gmail.com','2026-10-06 18:16:47'),(8,'Ishita Verma','9876500008','ishita.verma@gmail.com','2026-10-06 18:16:47'),(9,'Rohan Gupta','9876500009','rohan.gupta@gmail.com','2026-10-06 18:16:47'),(10,'Meera Iyer','9876500010','meera.iyer@gmail.com','2026-10-06 18:16:47'),(11,'Aditya Rao','9876500011','aditya.rao@gmail.com','2026-10-06 18:16:47'),(12,'Kavya Reddy','9876500012','kavya.reddy@gmail.com','2026-10-06 18:16:47'),(13,'Siddharth Jain','9876500013','siddharth.jain@gmail.com','2026-10-06 18:16:47'),(14,'Pooja Sharma','9876500014','pooja.sharma@gmail.com','2026-10-06 18:16:47'),(15,'Nikhil Kumar','9876500015','nikhil.kumar@gmail.com','2026-10-06 18:16:47');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dining_area`
--

DROP TABLE IF EXISTS `dining_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dining_area` (
  `area_id` int NOT NULL AUTO_INCREMENT,
  `area_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`area_id`),
  UNIQUE KEY `area_name` (`area_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dining_area`
--

LOCK TABLES `dining_area` WRITE;
/*!40000 ALTER TABLE `dining_area` DISABLE KEYS */;
INSERT INTO `dining_area` VALUES (1,'Main Hall','Indoor dining area'),(2,'Outdoor','Garden and outdoor seating'),(3,'Family Section','Dedicated family dining area'),(4,'VIP Section','Premium private dining area');
/*!40000 ALTER TABLE `dining_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount` (
  `discount_id` int NOT NULL AUTO_INCREMENT,
  `discount_name` varchar(100) NOT NULL,
  `discount_type` varchar(20) NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `max_discount` decimal(10,2) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `authorized_by` varchar(100) NOT NULL,
  PRIMARY KEY (`discount_id`),
  UNIQUE KEY `discount_name` (`discount_name`),
  CONSTRAINT `chk_discount_type` CHECK ((`discount_type` in (_cp850'PERCENTAGE',_cp850'FIXED'))),
  CONSTRAINT `chk_discount_value` CHECK ((`discount_value` > 0)),
  CONSTRAINT `chk_max_discount` CHECK (((`max_discount` is null) or (`max_discount` > 0)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount`
--

LOCK TABLES `discount` WRITE;
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
INSERT INTO `discount` VALUES (1,'Student Discount','PERCENTAGE',10.00,300.00,1,'Restaurant Manager'),(2,'Weekend Offer','PERCENTAGE',15.00,500.00,1,'Restaurant Manager'),(3,'Festival Discount','PERCENTAGE',20.00,750.00,1,'Restaurant Manager'),(4,'Flat 200 Offer','FIXED',200.00,NULL,1,'Restaurant Manager');
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order`
--

DROP TABLE IF EXISTS `food_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int NOT NULL,
  `waiter_id` int NOT NULL,
  `order_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_status` varchar(20) NOT NULL DEFAULT 'PLACED',
  PRIMARY KEY (`order_id`),
  KEY `fk_order_reservation` (`reservation_id`),
  KEY `fk_order_waiter` (`waiter_id`),
  KEY `idx_order_status` (`order_status`),
  KEY `idx_order_time` (`order_time`),
  CONSTRAINT `fk_order_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`reservation_id`),
  CONSTRAINT `fk_order_waiter` FOREIGN KEY (`waiter_id`) REFERENCES `waiter` (`waiter_id`),
  CONSTRAINT `chk_order_status` CHECK ((`order_status` in (_utf8mb4'PLACED',_utf8mb4'PREPARING',_utf8mb4'READY',_utf8mb4'SERVED',_utf8mb4'CANCELLED')))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order`
--

LOCK TABLES `food_order` WRITE;
/*!40000 ALTER TABLE `food_order` DISABLE KEYS */;
INSERT INTO `food_order` VALUES (1,1,1,'2026-10-06 18:28:32','SERVED'),(2,2,2,'2026-10-06 18:28:32','SERVED'),(3,3,3,'2026-10-06 18:28:32','SERVED'),(4,4,4,'2026-10-06 18:28:32','SERVED'),(5,5,1,'2026-10-06 18:28:32','SERVED'),(6,6,2,'2026-10-06 18:28:32','SERVED'),(7,7,3,'2026-10-06 18:28:32','READY'),(8,8,4,'2026-10-06 18:28:32','PREPARING'),(9,9,5,'2026-10-06 18:28:32','SERVED'),(10,10,1,'2026-10-06 18:28:32','SERVED'),(11,11,2,'2026-10-06 18:28:32','SERVED'),(12,12,3,'2026-10-06 18:28:32','SERVED'),(13,15,4,'2026-10-06 18:28:32','PREPARING'),(14,15,4,'2026-10-07 09:00:22','SERVED');
/*!40000 ALTER TABLE `food_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `kitchen_performance_view`
--

DROP TABLE IF EXISTS `kitchen_performance_view`;
/*!50001 DROP VIEW IF EXISTS `kitchen_performance_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `kitchen_performance_view` AS SELECT 
 1 AS `ticket_id`,
 1 AS `order_id`,
 1 AS `item_name`,
 1 AS `kitchen_status`,
 1 AS `received_at`,
 1 AS `started_at`,
 1 AS `ready_at`,
 1 AS `preparation_time_minutes`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `kitchen_ticket`
--

DROP TABLE IF EXISTS `kitchen_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kitchen_ticket` (
  `ticket_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `order_item_id` int NOT NULL,
  `received_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `started_at` timestamp NULL DEFAULT NULL,
  `ready_at` timestamp NULL DEFAULT NULL,
  `kitchen_status` varchar(20) NOT NULL DEFAULT 'RECEIVED',
  PRIMARY KEY (`ticket_id`),
  KEY `fk_ticket_order` (`order_id`),
  KEY `fk_ticket_order_item` (`order_item_id`),
  KEY `idx_kitchen_status` (`kitchen_status`),
  CONSTRAINT `fk_ticket_order` FOREIGN KEY (`order_id`) REFERENCES `food_order` (`order_id`),
  CONSTRAINT `fk_ticket_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`order_item_id`),
  CONSTRAINT `chk_kitchen_status` CHECK ((`kitchen_status` in (_utf8mb4'RECEIVED',_utf8mb4'PREPARING',_utf8mb4'READY',_utf8mb4'CANCELLED')))
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kitchen_ticket`
--

LOCK TABLES `kitchen_ticket` WRITE;
/*!40000 ALTER TABLE `kitchen_ticket` DISABLE KEYS */;
INSERT INTO `kitchen_ticket` VALUES (1,13,43,'2026-10-06 18:29:30',NULL,NULL,'RECEIVED'),(2,13,44,'2026-10-06 18:29:30',NULL,NULL,'RECEIVED'),(3,13,45,'2026-10-06 18:29:30',NULL,NULL,'RECEIVED'),(4,8,26,'2026-10-06 18:09:22','2026-10-06 18:14:22',NULL,'PREPARING'),(5,8,27,'2026-10-06 18:09:22','2026-10-06 18:14:22',NULL,'PREPARING'),(6,8,28,'2026-10-06 18:09:22','2026-10-06 18:14:22',NULL,'PREPARING'),(7,7,23,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(8,7,24,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(9,7,25,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(10,1,1,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(11,1,2,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(12,1,3,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(13,2,4,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(14,2,5,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(15,2,6,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(16,2,7,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(17,3,8,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(18,3,9,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(19,3,10,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(20,3,11,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(21,4,12,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(22,4,13,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(23,4,14,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(24,4,15,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(25,5,16,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(26,5,17,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(27,5,18,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(28,5,19,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(29,6,20,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(30,6,21,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(31,6,22,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(32,9,29,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(33,9,30,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(34,9,31,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(35,10,32,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(36,10,33,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(37,10,34,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(38,10,35,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(39,11,36,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(40,11,37,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(41,11,38,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(42,12,39,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(43,12,40,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(44,12,41,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(45,12,42,'2026-10-06 17:44:18','2026-10-06 17:49:18','2026-10-06 18:04:18','READY'),(64,14,46,'2026-10-07 09:00:22','2026-10-07 09:06:43','2026-10-07 09:06:55','READY'),(65,14,47,'2026-10-07 09:00:22','2026-10-07 09:06:43','2026-10-07 09:06:55','READY');
/*!40000 ALTER TABLE `kitchen_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_item`
--

DROP TABLE IF EXISTS `menu_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_item` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `item_name` (`item_name`),
  KEY `idx_menu_category` (`category`),
  CONSTRAINT `chk_menu_price` CHECK ((`price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_item`
--

LOCK TABLES `menu_item` WRITE;
/*!40000 ALTER TABLE `menu_item` DISABLE KEYS */;
INSERT INTO `menu_item` VALUES (1,'Paneer Tikka','STARTER','Grilled cottage cheese with spices',220.00,1),(2,'Chicken Tikka','STARTER','Grilled chicken pieces',280.00,1),(3,'Veg Spring Rolls','STARTER','Crispy vegetable spring rolls',180.00,1),(4,'Chicken 65','STARTER','Spicy fried chicken',260.00,1),(5,'Paneer Butter Masala','MAIN COURSE','Paneer cooked in creamy tomato gravy',240.00,1),(6,'Chicken Biryani','MAIN COURSE','Hyderabadi style chicken biryani',320.00,1),(7,'Mutton Biryani','MAIN COURSE','Traditional mutton biryani',380.00,1),(8,'Veg Biryani','MAIN COURSE','Fragrant vegetable biryani',240.00,1),(9,'Butter Naan','BREAD','Soft naan with butter',60.00,1),(10,'Garlic Naan','BREAD','Naan topped with garlic',80.00,1),(11,'Tandoori Roti','BREAD','Traditional tandoori roti',45.00,1),(12,'Veg Fried Rice','RICE','Chinese style vegetable fried rice',190.00,1),(13,'Chicken Fried Rice','RICE','Chicken fried rice',240.00,1),(14,'Fresh Lime Soda','BEVERAGE','Refreshing lime soda',90.00,1),(15,'Mango Lassi','BEVERAGE','Fresh mango yogurt drink',120.00,1),(16,'Cold Coffee','BEVERAGE','Chilled creamy coffee',140.00,1),(17,'Gulab Jamun','DESSERT','Two pieces of gulab jamun',100.00,1),(18,'Brownie with Ice Cream','DESSERT','Warm brownie served with ice cream',180.00,1);
/*!40000 ALTER TABLE `menu_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `order_details_view`
--

DROP TABLE IF EXISTS `order_details_view`;
/*!50001 DROP VIEW IF EXISTS `order_details_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `order_details_view` AS SELECT 
 1 AS `order_id`,
 1 AS `customer_name`,
 1 AS `waiter_name`,
 1 AS `item_name`,
 1 AS `category`,
 1 AS `quantity`,
 1 AS `unit_price`,
 1 AS `item_total`,
 1 AS `order_time`,
 1 AS `order_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `special_instruction` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  UNIQUE KEY `uq_order_item` (`order_id`,`item_id`),
  KEY `fk_order_item_menu` (`item_id`),
  CONSTRAINT `fk_order_item_menu` FOREIGN KEY (`item_id`) REFERENCES `menu_item` (`item_id`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `food_order` (`order_id`),
  CONSTRAINT `chk_order_quantity` CHECK ((`quantity` > 0)),
  CONSTRAINT `chk_order_unit_price` CHECK ((`unit_price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,1,6,2,320.00,'Medium spicy'),(2,1,9,2,60.00,NULL),(3,1,14,2,90.00,'Less ice'),(4,2,1,1,220.00,NULL),(5,2,5,1,240.00,'Less spicy'),(6,2,10,2,80.00,NULL),(7,2,15,2,120.00,NULL),(8,3,2,2,280.00,NULL),(9,3,7,1,380.00,NULL),(10,3,11,3,45.00,NULL),(11,3,16,2,140.00,NULL),(12,4,4,1,260.00,NULL),(13,4,6,2,320.00,NULL),(14,4,9,4,60.00,NULL),(15,4,17,2,100.00,NULL),(16,5,3,2,180.00,NULL),(17,5,5,2,240.00,NULL),(18,5,10,2,80.00,NULL),(19,5,14,2,90.00,NULL),(20,6,6,3,320.00,NULL),(21,6,9,3,60.00,NULL),(22,6,15,3,120.00,NULL),(23,7,1,2,220.00,NULL),(24,7,8,2,240.00,NULL),(25,7,10,2,80.00,NULL),(26,8,2,1,280.00,NULL),(27,8,13,2,240.00,NULL),(28,8,14,2,90.00,NULL),(29,9,6,1,320.00,NULL),(30,9,9,2,60.00,NULL),(31,9,17,2,100.00,NULL),(32,10,5,1,240.00,NULL),(33,10,8,1,240.00,NULL),(34,10,11,2,45.00,NULL),(35,10,16,1,140.00,NULL),(36,11,7,2,380.00,NULL),(37,11,10,4,80.00,NULL),(38,11,15,2,120.00,NULL),(39,12,4,2,260.00,NULL),(40,12,6,2,320.00,NULL),(41,12,9,4,60.00,NULL),(42,12,18,2,180.00,NULL),(43,13,1,1,220.00,NULL),(44,13,6,2,320.00,NULL),(45,13,14,2,90.00,NULL),(46,14,4,1,260.00,NULL),(47,14,1,1,220.00,NULL);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_status` varchar(20) NOT NULL DEFAULT 'SUCCESS',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `transaction_reference` (`transaction_reference`),
  KEY `idx_payment_bill` (`bill_id`),
  CONSTRAINT `fk_payment_bill` FOREIGN KEY (`bill_id`) REFERENCES `bill` (`bill_id`),
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` > 0)),
  CONSTRAINT `chk_payment_method` CHECK ((`payment_method` in (_utf8mb4'CASH',_utf8mb4'CARD',_utf8mb4'UPI'))),
  CONSTRAINT `chk_payment_status` CHECK ((`payment_status` in (_utf8mb4'PENDING',_utf8mb4'SUCCESS',_utf8mb4'FAILED')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,'CASH',893.00,'SUCCESS','TXN-00001','2026-10-06 18:30:22'),(2,2,'CARD',903.00,'SUCCESS','TXN-00002','2026-10-06 18:30:22'),(3,3,'UPI',1219.50,'SUCCESS','TXN-00003','2026-10-06 18:30:22'),(4,4,'CASH',1407.00,'SUCCESS','TXN-00004','2026-10-06 18:30:22'),(5,5,'CARD',1003.00,'SUCCESS','TXN-00005','2026-10-06 18:30:22'),(6,6,'UPI',1575.00,'SUCCESS','TXN-00006','2026-10-06 18:30:22'),(7,7,'CASH',934.00,'SUCCESS','TXN-00007','2026-10-06 18:30:22'),(8,8,'CARD',987.00,'SUCCESS','TXN-00008','2026-10-06 18:30:22'),(9,9,'UPI',672.00,'SUCCESS','TXN-00009','2026-10-06 18:30:22'),(10,10,'CASH',745.50,'SUCCESS','TXN-00010','2026-10-06 18:30:22'),(11,11,'CARD',1386.00,'SUCCESS','TXN-00011','2026-10-06 18:30:22'),(12,12,'UPI',1848.00,'SUCCESS','TXN-00012','2026-10-06 18:30:22'),(16,16,'CASH',504.00,'SUCCESS',NULL,'2026-10-07 09:30:31');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validate_payment_amount` BEFORE INSERT ON `payment` FOR EACH ROW BEGIN
    DECLARE bill_total DECIMAL(10,2);

    SELECT total_amount
    INTO bill_total
    FROM bill
    WHERE bill_id = NEW.bill_id;

    IF NEW.amount > bill_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount cannot exceed bill total';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `table_id` int NOT NULL,
  `reservation_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `guest_count` int NOT NULL,
  `reservation_status` varchar(20) NOT NULL DEFAULT 'CONFIRMED',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reservation_id`),
  KEY `fk_reservation_customer` (`customer_id`),
  KEY `idx_reservation_date` (`reservation_date`),
  KEY `idx_reservation_table_date` (`table_id`,`reservation_date`),
  CONSTRAINT `fk_reservation_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `fk_reservation_table` FOREIGN KEY (`table_id`) REFERENCES `restaurant_table` (`table_id`),
  CONSTRAINT `chk_guest_count` CHECK ((`guest_count` > 0)),
  CONSTRAINT `chk_reservation_status` CHECK ((`reservation_status` in (_utf8mb4'CONFIRMED',_utf8mb4'SEATED',_utf8mb4'COMPLETED',_utf8mb4'CANCELLED',_utf8mb4'NO_SHOW'))),
  CONSTRAINT `chk_reservation_time` CHECK ((`start_time` < `end_time`))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,1,3,'2026-10-10','18:00:00','19:30:00',4,'CONFIRMED','2026-10-06 18:17:57'),(2,2,5,'2026-10-10','19:00:00','20:30:00',5,'CONFIRMED','2026-10-06 18:17:57'),(3,3,8,'2026-10-10','19:30:00','21:00:00',3,'CONFIRMED','2026-10-06 18:17:57'),(4,4,11,'2026-10-10','20:00:00','21:30:00',4,'CONFIRMED','2026-10-06 18:17:57'),(5,5,4,'2026-10-11','18:30:00','20:00:00',4,'CONFIRMED','2026-10-06 18:17:57'),(6,6,6,'2026-10-11','19:00:00','20:30:00',6,'CONFIRMED','2026-10-06 18:17:57'),(7,7,9,'2026-10-11','20:00:00','21:30:00',4,'SEATED','2026-10-06 18:17:57'),(8,8,12,'2026-10-11','20:30:00','22:00:00',5,'SEATED','2026-10-06 18:17:57'),(9,9,1,'2026-10-12','18:00:00','19:30:00',2,'COMPLETED','2026-10-06 18:17:57'),(10,10,7,'2026-10-12','18:30:00','20:00:00',2,'COMPLETED','2026-10-06 18:17:57'),(11,11,13,'2026-10-12','19:00:00','21:00:00',7,'COMPLETED','2026-10-06 18:17:57'),(12,12,15,'2026-10-12','20:00:00','22:00:00',5,'COMPLETED','2026-10-06 18:17:57'),(13,13,2,'2026-10-13','18:00:00','19:30:00',2,'CANCELLED','2026-10-06 18:17:57'),(14,14,10,'2026-10-13','19:00:00','20:30:00',6,'NO_SHOW','2026-10-06 18:17:57'),(15,15,16,'2026-10-13','20:00:00','22:00:00',8,'COMPLETED','2026-10-06 18:17:57'),(16,1,16,'2026-10-20','19:00:00','20:00:00',4,'COMPLETED','2026-10-06 20:01:55'),(17,4,10,'2026-10-07','13:00:00','14:00:00',6,'COMPLETED','2026-10-07 07:19:22');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_guest_count_before_reservation` BEFORE INSERT ON `reservation` FOR EACH ROW BEGIN
    DECLARE table_capacity INT;

    SELECT capacity
    INTO table_capacity
    FROM restaurant_table
    WHERE table_id = NEW.table_id;

    IF NEW.guest_count > table_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Guest count exceeds table capacity';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevent_reservation_overlap` BEFORE INSERT ON `reservation` FOR EACH ROW BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*)
    INTO conflict_count
    FROM reservation
    WHERE table_id = NEW.table_id
      AND reservation_date = NEW.reservation_date
      AND reservation_status NOT IN ('CANCELLED', 'NO_SHOW')
      AND NEW.start_time < end_time
      AND NEW.end_time > start_time;

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation overlaps with an existing reservation';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `reservation_details_view`
--

DROP TABLE IF EXISTS `reservation_details_view`;
/*!50001 DROP VIEW IF EXISTS `reservation_details_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `reservation_details_view` AS SELECT 
 1 AS `reservation_id`,
 1 AS `customer_name`,
 1 AS `phone`,
 1 AS `email`,
 1 AS `table_number`,
 1 AS `area_name`,
 1 AS `capacity`,
 1 AS `reservation_date`,
 1 AS `start_time`,
 1 AS `end_time`,
 1 AS `guest_count`,
 1 AS `reservation_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `restaurant_table`
--

DROP TABLE IF EXISTS `restaurant_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_table` (
  `table_id` int NOT NULL AUTO_INCREMENT,
  `area_id` int NOT NULL,
  `table_number` varchar(20) NOT NULL,
  `capacity` int NOT NULL,
  `table_status` varchar(20) NOT NULL DEFAULT 'AVAILABLE',
  PRIMARY KEY (`table_id`),
  UNIQUE KEY `uq_table_number` (`area_id`,`table_number`),
  KEY `idx_table_status` (`table_status`),
  CONSTRAINT `fk_table_area` FOREIGN KEY (`area_id`) REFERENCES `dining_area` (`area_id`),
  CONSTRAINT `chk_table_capacity` CHECK ((`capacity` > 0)),
  CONSTRAINT `chk_table_status` CHECK ((`table_status` in (_utf8mb4'AVAILABLE',_utf8mb4'OCCUPIED',_utf8mb4'RESERVED',_utf8mb4'MAINTENANCE')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_table`
--

LOCK TABLES `restaurant_table` WRITE;
/*!40000 ALTER TABLE `restaurant_table` DISABLE KEYS */;
INSERT INTO `restaurant_table` VALUES (1,1,'T01',2,'AVAILABLE'),(2,1,'T02',2,'AVAILABLE'),(3,1,'T03',4,'AVAILABLE'),(4,1,'T04',4,'AVAILABLE'),(5,1,'T05',6,'AVAILABLE'),(6,1,'T06',6,'AVAILABLE'),(7,2,'T07',2,'AVAILABLE'),(8,2,'T08',4,'AVAILABLE'),(9,2,'T09',4,'AVAILABLE'),(10,2,'T10',6,'AVAILABLE'),(11,3,'T11',4,'AVAILABLE'),(12,3,'T12',6,'AVAILABLE'),(13,3,'T13',8,'AVAILABLE'),(14,3,'T14',8,'AVAILABLE'),(15,4,'T15',6,'AVAILABLE'),(16,4,'T16',10,'AVAILABLE');
/*!40000 ALTER TABLE `restaurant_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `revenue_report_view`
--

DROP TABLE IF EXISTS `revenue_report_view`;
/*!50001 DROP VIEW IF EXISTS `revenue_report_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `revenue_report_view` AS SELECT 
 1 AS `bill_id`,
 1 AS `order_id`,
 1 AS `reservation_date`,
 1 AS `subtotal`,
 1 AS `discount_amount`,
 1 AS `tax_amount`,
 1 AS `total_amount`,
 1 AS `bill_status`,
 1 AS `closed_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `sales_report_view`
--

DROP TABLE IF EXISTS `sales_report_view`;
/*!50001 DROP VIEW IF EXISTS `sales_report_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sales_report_view` AS SELECT 
 1 AS `item_id`,
 1 AS `item_name`,
 1 AS `category`,
 1 AS `total_quantity_sold`,
 1 AS `total_sales`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `waiter`
--

DROP TABLE IF EXISTS `waiter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waiter` (
  `waiter_id` int NOT NULL AUTO_INCREMENT,
  `waiter_name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `shift` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`waiter_id`),
  UNIQUE KEY `phone` (`phone`),
  CONSTRAINT `chk_waiter_shift` CHECK ((`shift` in (_cp850'MORNING',_cp850'EVENING',_cp850'NIGHT'))),
  CONSTRAINT `chk_waiter_status` CHECK ((`status` in (_cp850'ACTIVE',_cp850'INACTIVE')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waiter`
--

LOCK TABLES `waiter` WRITE;
/*!40000 ALTER TABLE `waiter` DISABLE KEYS */;
INSERT INTO `waiter` VALUES (1,'Ravi Kumar','9886500001','MORNING','ACTIVE'),(2,'Sneha Rao','9886500002','EVENING','ACTIVE'),(3,'Arjun Patel','9886500003','EVENING','ACTIVE'),(4,'Neha Sharma','9886500004','NIGHT','ACTIVE'),(5,'Manoj Reddy','9886500005','MORNING','ACTIVE');
/*!40000 ALTER TABLE `waiter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `waiter_performance_view`
--

DROP TABLE IF EXISTS `waiter_performance_view`;
/*!50001 DROP VIEW IF EXISTS `waiter_performance_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `waiter_performance_view` AS SELECT 
 1 AS `waiter_id`,
 1 AS `waiter_name`,
 1 AS `total_orders`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `available_tables_view`
--

/*!50001 DROP VIEW IF EXISTS `available_tables_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `available_tables_view` AS select `rt`.`table_id` AS `table_id`,`da`.`area_name` AS `area_name`,`rt`.`table_number` AS `table_number`,`rt`.`capacity` AS `capacity`,`rt`.`table_status` AS `table_status` from (`restaurant_table` `rt` join `dining_area` `da` on((`rt`.`area_id` = `da`.`area_id`))) where (`rt`.`table_status` = 'AVAILABLE') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `kitchen_performance_view`
--

/*!50001 DROP VIEW IF EXISTS `kitchen_performance_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `kitchen_performance_view` AS select `kt`.`ticket_id` AS `ticket_id`,`fo`.`order_id` AS `order_id`,`mi`.`item_name` AS `item_name`,`kt`.`kitchen_status` AS `kitchen_status`,`kt`.`received_at` AS `received_at`,`kt`.`started_at` AS `started_at`,`kt`.`ready_at` AS `ready_at`,(case when (`kt`.`ready_at` is not null) then timestampdiff(MINUTE,`kt`.`received_at`,`kt`.`ready_at`) else NULL end) AS `preparation_time_minutes` from (((`kitchen_ticket` `kt` join `order_item` `oi` on((`kt`.`order_item_id` = `oi`.`order_item_id`))) join `menu_item` `mi` on((`oi`.`item_id` = `mi`.`item_id`))) join `food_order` `fo` on((`kt`.`order_id` = `fo`.`order_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `order_details_view`
--

/*!50001 DROP VIEW IF EXISTS `order_details_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `order_details_view` AS select `fo`.`order_id` AS `order_id`,`c`.`customer_name` AS `customer_name`,`w`.`waiter_name` AS `waiter_name`,`mi`.`item_name` AS `item_name`,`mi`.`category` AS `category`,`oi`.`quantity` AS `quantity`,`oi`.`unit_price` AS `unit_price`,(`oi`.`quantity` * `oi`.`unit_price`) AS `item_total`,`fo`.`order_time` AS `order_time`,`fo`.`order_status` AS `order_status` from (((((`food_order` `fo` join `reservation` `r` on((`fo`.`reservation_id` = `r`.`reservation_id`))) join `customer` `c` on((`r`.`customer_id` = `c`.`customer_id`))) join `waiter` `w` on((`fo`.`waiter_id` = `w`.`waiter_id`))) join `order_item` `oi` on((`fo`.`order_id` = `oi`.`order_id`))) join `menu_item` `mi` on((`oi`.`item_id` = `mi`.`item_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `reservation_details_view`
--

/*!50001 DROP VIEW IF EXISTS `reservation_details_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `reservation_details_view` AS select `r`.`reservation_id` AS `reservation_id`,`c`.`customer_name` AS `customer_name`,`c`.`phone` AS `phone`,`c`.`email` AS `email`,`rt`.`table_number` AS `table_number`,`da`.`area_name` AS `area_name`,`rt`.`capacity` AS `capacity`,`r`.`reservation_date` AS `reservation_date`,`r`.`start_time` AS `start_time`,`r`.`end_time` AS `end_time`,`r`.`guest_count` AS `guest_count`,`r`.`reservation_status` AS `reservation_status` from (((`reservation` `r` join `customer` `c` on((`r`.`customer_id` = `c`.`customer_id`))) join `restaurant_table` `rt` on((`r`.`table_id` = `rt`.`table_id`))) join `dining_area` `da` on((`rt`.`area_id` = `da`.`area_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `revenue_report_view`
--

/*!50001 DROP VIEW IF EXISTS `revenue_report_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `revenue_report_view` AS select `b`.`bill_id` AS `bill_id`,`b`.`order_id` AS `order_id`,`r`.`reservation_date` AS `reservation_date`,`b`.`subtotal` AS `subtotal`,`b`.`discount_amount` AS `discount_amount`,`b`.`tax_amount` AS `tax_amount`,`b`.`total_amount` AS `total_amount`,`b`.`bill_status` AS `bill_status`,`b`.`closed_at` AS `closed_at` from ((`bill` `b` join `food_order` `fo` on((`b`.`order_id` = `fo`.`order_id`))) join `reservation` `r` on((`fo`.`reservation_id` = `r`.`reservation_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `sales_report_view`
--

/*!50001 DROP VIEW IF EXISTS `sales_report_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `sales_report_view` AS select `mi`.`item_id` AS `item_id`,`mi`.`item_name` AS `item_name`,`mi`.`category` AS `category`,sum(`oi`.`quantity`) AS `total_quantity_sold`,sum((`oi`.`quantity` * `oi`.`unit_price`)) AS `total_sales` from (`order_item` `oi` join `menu_item` `mi` on((`oi`.`item_id` = `mi`.`item_id`))) group by `mi`.`item_id`,`mi`.`item_name`,`mi`.`category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `waiter_performance_view`
--

/*!50001 DROP VIEW IF EXISTS `waiter_performance_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `waiter_performance_view` AS select `w`.`waiter_id` AS `waiter_id`,`w`.`waiter_name` AS `waiter_name`,count(distinct `fo`.`order_id`) AS `total_orders`,coalesce(sum(`b`.`total_amount`),0) AS `total_revenue` from ((`waiter` `w` left join `food_order` `fo` on((`w`.`waiter_id` = `fo`.`waiter_id`))) left join `bill` `b` on((`fo`.`order_id` = `b`.`order_id`))) group by `w`.`waiter_id`,`w`.`waiter_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-07 15:47:37
