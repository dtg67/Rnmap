library(tidyverse)

# Read in the nmap output as a string
nmap_output <- "Nmap scan report for G3100.mynetworksettings.com (192.168.1.1)
Host is up (0.0010s latency).
Not shown: 65525 closed tcp ports (conn-refused), 2 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
53/tcp    open  domain
80/tcp    open  http
443/tcp   open  https
4577/tcp  open  unknown
4578/tcp  open  unknown
34194/tcp open  unknown
52009/tcp open  unknown
54172/tcp open  unknown"

# Extract the relevant information and store it in a data frame
nmap_df <- nmap_output %>% 
  # Split the string into lines
  strsplit("\n") %>% 
  # Extract the lines containing port information
  .[[1]] %>% .[grepl("^[0-9]", .)] %>% 
  # Split each line into columns
  strsplit("[ \t]+") %>% 
  # Store the columns in a data frame
  as.data.frame() %>% 
  # Rename the columns
  setNames(c("port", "state", "service"))

# Print the resulting data frame
print(nmap_df)