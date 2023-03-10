library(xml2)
library(tibble)

nmap_xml_file <- "data/nmap_example.xml"


nmap_data <- xml2::read_xml(nmap_xml_file)


hosts_data <- xml2::xml_find_all(nmap_data, "//host")


df_list <- list()


for (i in 1:length(hosts_data)) {
  
  host_data <- hosts_data[i]
  host_ip_address <- xml2::xml_text(xml2::xml_find_first(host_data, "address[@addrtype='ipv4']/@addr"))
  
  hostname <- xml2::xml_text(xml2::xml_find_first(host_data, "hostnames/hostname/@name"))
  
  open_ports_data <- xml2::xml_find_all(host_data, "ports/port[state]")
  open_ports <- sapply(open_ports_data, function(x) {
    xml2::xml_text(xml2::xml_find_first(x, "@portid"))
  })
  
  service <- c()
  status <- xml2::xml_text(xml2::xml_find_all(host_data, "ports/port/state/@state"))
  
  for(j in 1:length(open_ports)){
    base_str <- "ports/port[@portid = 'replace me']//service"
    replace <- open_ports[j]
    xml_port_string <- str_replace(base_str, "replace me", replace)
    services_data <- xml2::xml_find_all(host_data, xml_port_string)
    name <- xml2::xml_text(xml2::xml_find_first(services_data, "@name"))
    
    if(length(name) == 0){open_service[j] == "NA"}
    else{
      service[j] <- name
      
    }
  }
  
  host_df <- tibble::data_frame(
    host = rep(host_ip_address, length(open_ports)),
    hostname = rep(hostname, length(open_ports)),
    port = open_ports,
    status = status,
    service = service
  )
  
  df_list[[i]] <- host_df
}

print(df_list)