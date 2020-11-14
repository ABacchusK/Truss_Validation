# Truss_Validation
Initialization and Calculation of failure load

Code requires a simple truss design that meets the criteria M = 2J - 3, where M is number of members, J is number of joints. Truss must be referenced by a drawing indicating positions of each joint, with clearly-labeled member specifiers. Truss must be positioned such that one joint is on a roller, and one joint acts as a pin.

Initialization creates: 
Connection matrix of J rows and M columns, indicating which joints are connected to which members
Position vectors, indicating location (in inches) of joints relative to a user-specified origin
Load vector, with a default value of 1 oz force at a user-specified joint

Calculation returns:
Matrix A, populated by coefficients of the force for respective member tension at each joint
Vector T, containing loads of each member and reaction forces at respective joints
Member lengths, based on position of joints in model

Output contains:
Member forces, tension and compression
Buckling load, based on a 200-student sample of buckling tests for acryllic bars
A diagram of the truss, including the member that will fail in red
