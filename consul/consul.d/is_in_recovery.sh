# postgres=# SELECT pg_is_in_recovery();
#  pg_is_in_recovery 
# -------------------
#  t
# (1 row)

# postgres=# SELECT pg_promote();
#  pg_promote 
# ------------
#  t
# (1 row)

# postgres=# SELECT pg_is_in_recovery();
#  pg_is_in_recovery 
# -------------------
#  f
# (1 row)
