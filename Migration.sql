create database if not exists Migration;
use Migration;

-- MySQL to PostgreSQL Migration Script


#!/bin/bash

# Variables
MYSQL_HOST="localhost"
MYSQL_USER="your_mysql_user"
MYSQL_PASSWORD="your_mysql_password"
MYSQL_DB="your_mysql_database"

PG_HOST="localhost"
PG_USER="your_pg_user"
PG_PASSWORD="your_pg_password"
PG_DB="your_pg_database"

# Step 1: Export MySQL Data
echo "Exporting data from MySQL..."
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB --compatible=postgresql --no-create-info > data.sql
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB --no-data --skip-comments --compatible=postgresql > schema.sql

# Step 2: Convert MySQL Schema to PostgreSQL Schema (Manual adjustments might be needed)
echo "Converting MySQL schema to PostgreSQL schema..."
sed -i 's/`//g' schema.sql  # Remove backticks
sed -i 's/AUTO_INCREMENT/SERIAL/g' schema.sql  # Replace auto_increment with SERIAL
sed -i 's/ENGINE=[^ ]*//g' schema.sql  # Remove ENGINE clauses

# Step 3: Import Schema into PostgreSQL
echo "Importing schema into PostgreSQL..."
PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -d $PG_DB -f schema.sql

# Step 4: Import Data into PostgreSQL
echo "Importing data into PostgreSQL..."
PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -d $PG_DB -f data.sql

echo "Migration completed successfully!"



-- Steps to Use the Script

-- 1.Replace placeholders (your_mysql_user, your_mysql_password, etc.) with your database credentials.

-- 2.Save the script as migrate.sh and make it executable:
chmod +x migrate.sh

-- 3.Run the script:
./migrate.sh



