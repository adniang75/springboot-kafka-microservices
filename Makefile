# Makefile to manage tasks for building, running, and testing the application

# Colors for echo messages
GREEN=\033[0;32m
RESET=\033[0m

# Variables
ORDER_SERVICE = order-service
STOCK_SERVICE = stock-service
EMAIL_SERVICE = email-service
BASE_DOMAINS  = base-domains

# Define the list of services
SERVICES = $(ORDER_SERVICE) $(STOCK_SERVICE) $(EMAIL_SERVICE) $(BASE_DOMAINS)


run-zookeeper:
	zookeeper-server-start /opt/homebrew/etc/kafka/zookeeper.properties
	@echo "$(GREEN)🏗️ Zookeeper started successfully!$(RESET)"

run-kafka:
	kafka-server-start /opt/homebrew/etc/kafka/server.properties
	@echo "$(GREEN)🏗️ Kafka started successfully!$(RESET)"

clean:
	for service in $(SERVICES); do \
  		(cd $$service && mvn clean); \
	done
	@echo "$(GREEN)🧹 Cleaned successfully!$(RESET)"

compile: clean
	for service in $(SERVICES); do \
  		(cd $$service && mvn compile); \
	done
	@echo "$(GREEN)🛠️ Microservices compiled successfully!$(RESET)"

package: clean
	mvn package
	@echo "$(GREEN)📦 Microservices packaged successfully!$(RESET)"

test: clean
	for service in $(SERVICES); do \
  		(cd $$service && mvn package); \
	done
	@echo "$(GREEN)✅ Tests executed successfully!$(RESET)"

install: clean
	for service in $(SERVICES); do \
  		(cd $$service && mvn install); \
	done
	@echo "$(GREEN)✅ Install executed successfully!$(RESET)"

run-producer:
	mvn spring-boot:run -pl kafka-producer-wikimedia

run-console-producer:
	kafka-console-consumer --topic wikimedia_recentchange --from-beginning --bootstrap-server macbook-pro.home:9092 | jq .

run-consumer:
	mvn spring-boot:run -pl kafka-consumer-database

# Declare targets as phony labels to avoid conflicts with real file names 🎭
.PHONY: run-zookeeper run-kafka clean compile package test install run-producer run-console-producer run-consumer

# Default target that displays help on using the Makefile 📚
help:
	@echo "Usage: make [command]"
	@echo ""
	@echo "Commands:"
	@echo "  make run-zookeeper  		- Starts Zookeeper"
	@echo "  make run-kafka       		- Starts Kafka"
	@echo "  make clean           		- Cleans all projects"
	@echo "  make compile         		- Compiles all microservices"
	@echo "  make package         		- Packages all microservices"
	@echo "  make test            		- Executes tests on all microservices"
	@echo "  make run-producer    		- Runs the Kafka producer"
	@echo "  make run-console-producer 	- Runs the Kafka producer"
	@echo "  make run-consumer    		- Runs the Kafka consumer"
	@echo "  make help            		- Displays this help screen"
