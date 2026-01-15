CREATE DATABASE nw_realite;
SELECT * FROM leases;
SELECT * FROM locations;
SELECT * FROM units;
SELECT * FROM tenants;
SELECT * FROM properties;
#Removing -ve rent
UPDATE leases 
SET rent_per_month = ABS(rent_per_month)
WHERE rent_per_month<0;

#Properties with occupancy below 80%
#Total Arrears Per Location
#Top 3 properties by collection efficiency
#Invalid/dirty leases (negative rent or invalid dates)
#Tenants with 2 or more units
