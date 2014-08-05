/* gates table */ 


create table gates ( 
/* primary key */
gatesid serial primary key, 
/* references road layer */
roadfk integer, 
/* references tract gate accesses */
tractfk integer, 
/* who owns the gate: owned, leased, permitted */ 
ownershipfk integer, 
/* who has access to the gate: would include hunt clubs, loggers, etc */ 
accessfk,
/* type of gate */ 
gatetypefk, 
/* combination if it is a combination lock */
combination varchar(50), 
/* key number if keyed gate */ 
keynumber varchar(24),
/* edit date and time */
edit_date timstamp, 
edit_user varchar(24)
);  
 
