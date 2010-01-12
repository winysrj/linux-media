Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.blasberg-computer.de ([85.159.11.3]:42779 "EHLO
	mail.blasberg-computer.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296Ab0ALVmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 16:42:22 -0500
Received: from [192.168.0.195] (ip-88-153-49-64.unitymediagroup.de [88.153.49.64])
	by mail.blasberg-computer.de (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id o0CJEY9e027687
	for <linux-media@vger.kernel.org>; Tue, 12 Jan 2010 20:14:34 +0100
Message-ID: <4B4CE912.1000906@von-eitzen.de>
Date: Tue, 12 Jan 2010 22:26:42 +0100
From: Hagen von Eitzen <hagen@von-eitzen.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: VL4-DVB compilation issue not covered by Daily Automated
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,
as suggested by http://www.linuxtv.org/wiki/index.php/Bug_Report I 
report several warnings and errors not yet covered in latest 
http://www.xs4all.nl/~hverkuil/logs/Monday.log I get when compiling.
(The purpose of my experiments was trying to find out something about 
"0ccd:00a5 TerraTec Electronic GmbH")

Regards
Hagen


$ uname -a
Linux hagen-shuttle 2.6.31-15-generic #50-Ubuntu SMP Tue Nov 10 14:53:52 
UTC 2009 x86_64 GNU/Linux
$ sudo apt-get install mercurial linux-headers-$(uname -r) build-essential
$ hg clone http://linuxtv.org/hg/v4l-dvb
$ cd v4l-dvb/
$ make
<snip>
CC [M]  /v4l-dvb/v4l/et61x251_core.o        
/v4l-dvb/v4l/et61x251_core.c: In function 
'et61x251_ioctl_v4l2':                       
/v4l-dvb/v4l/et61x251_core.c:2500: warning: the frame size of 1408 bytes 
is larger than 1024 bytes
CC [M]  
/v4l-dvb/v4l/et61x251_tas5130d1b.o                                                     

CC [M]  
/v4l-dvb/v4l/firedtv-avc.o                                                             

CC [M]  
/v4l-dvb/v4l/firedtv-ci.o                                                              

CC [M]  
/v4l-dvb/v4l/firedtv-dvb.o                                                             

CC [M]  
/v4l-dvb/v4l/firedtv-fe.o                                                              

CC [M]  
/v4l-dvb/v4l/firedtv-1394.o                                                            

/v4l-dvb/v4l/firedtv-1394.c:21:17: error: dma.h: No such file or 
directory                        /v4l-dvb/v4l/firedtv-1394.c:22:21: 
error: csr1212.h: No such file or directory                    
/v4l-dvb/v4l/firedtv-1394.c:23:23: error: highlevel.h: No such file or 
directory                  /v4l-dvb/v4l/firedtv-1394.c:24:19: error: 
hosts.h: No such file or directory                      
/v4l-dvb/v4l/firedtv-1394.c:25:22: error: ieee1394.h: No such file or 
directory                   /v4l-dvb/v4l/firedtv-1394.c:26:17: error: 
iso.h: No such file or directory                        
/v4l-dvb/v4l/firedtv-1394.c:27:21: error: nodemgr.h: No such file or 
directory                    /v4l-dvb/v4l/firedtv-1394.c:40: warning: 
'struct hpsb_iso' declared inside parameter list         
/v4l-dvb/v4l/firedtv-1394.c:40: warning: its scope is only this 
definition or declaration, which is probably not what you want
/v4l-dvb/v4l/firedtv-1394.c: In function 
'rawiso_activity_cb':                                                               

/v4l-dvb/v4l/firedtv-1394.c:56: error: dereferencing pointer to 
incomplete type                                               
/v4l-dvb/v4l/firedtv-1394.c:57: error: implicit declaration of function 
'hpsb_iso_n_ready'                                    
/v4l-dvb/v4l/firedtv-1394.c:64: error: dereferencing pointer to 
incomplete type                                               
/v4l-dvb/v4l/firedtv-1394.c:65: error: implicit declaration of function 
'dma_region_i'                                        
/v4l-dvb/v4l/firedtv-1394.c:65: error: dereferencing pointer to 
incomplete type                                               
/v4l-dvb/v4l/firedtv-1394.c:65: error: expected expression before 
'unsigned'                                                  
/v4l-dvb/v4l/firedtv-1394.c:66: warning: assignment makes pointer from 
integer without a cast                                 
/v4l-dvb/v4l/firedtv-1394.c:67: error: dereferencing pointer to 
incomplete type                                               
/v4l-dvb/v4l/firedtv-1394.c:71: error: dereferencing pointer to 
incomplete type                                               
/v4l-dvb/v4l/firedtv-1394.c:85: error: implicit declaration of function 
'hpsb_iso_recv_release_packets'                       
/v4l-dvb/v4l/firedtv-1394.c: In function 
'node_of':                                                                          

/v4l-dvb/v4l/firedtv-1394.c:90: error: dereferencing pointer to 
incomplete type                                               
/v4l-dvb/v4l/firedtv-1394.c:90: warning: type defaults to 'int' in 
declaration of '__mptr'                                    
/v4l-dvb/v4l/firedtv-1394.c:90: warning: initialization from 
incompatible pointer type                                        
/v4l-dvb/v4l/firedtv-1394.c:90: error: invalid use of undefined type 
'struct unit_directory'                                  
/v4l-dvb/v4l/firedtv-1394.c: In function 
'node_lock':                                                                        

/v4l-dvb/v4l/firedtv-1394.c:97: error: implicit declaration of function 
'hpsb_node_lock'                                      
/v4l-dvb/v4l/firedtv-1394.c:97: error: 'EXTCODE_COMPARE_SWAP' undeclared 
(first use in this function)                         
/v4l-dvb/v4l/firedtv-1394.c:97: error: (Each undeclared identifier is 
reported only once                                      
/v4l-dvb/v4l/firedtv-1394.c:97: error: for each function it appears 
in.)                                                      
/v4l-dvb/v4l/firedtv-1394.c:98: error: 'quadlet_t' undeclared (first use 
in this function)                                    
/v4l-dvb/v4l/firedtv-1394.c:98: error: expected expression before ')' 
token                                                   
/v4l-dvb/v4l/firedtv-1394.c: In function 
'node_read':                                                                        

/v4l-dvb/v4l/firedtv-1394.c:106: error: implicit declaration of function 
'hpsb_node_read'                                     
/v4l-dvb/v4l/firedtv-1394.c: In function 
'node_write':                                                                       

/v4l-dvb/v4l/firedtv-1394.c:111: error: implicit declaration of function 
'hpsb_node_write'                                    
/v4l-dvb/v4l/firedtv-1394.c: In function 
'start_iso':                                                                        

/v4l-dvb/v4l/firedtv-1394.c:122: error: implicit declaration of function 
'hpsb_iso_recv_init'                                 
/v4l-dvb/v4l/firedtv-1394.c:122: error: dereferencing pointer to 
incomplete type                                              
/v4l-dvb/v4l/firedtv-1394.c:124: error: 'HPSB_ISO_DMA_DEFAULT' 
undeclared (first use in this function)                        
/v4l-dvb/v4l/firedtv-1394.c:126: warning: assignment makes pointer from 
integer without a cast                                
/v4l-dvb/v4l/firedtv-1394.c:133: error: implicit declaration of function 
'hpsb_iso_recv_start'                                
/v4l-dvb/v4l/firedtv-1394.c:136: error: implicit declaration of function 
'hpsb_iso_shutdown'                                  
/v4l-dvb/v4l/firedtv-1394.c: In function 
'stop_iso':                                                                         

/v4l-dvb/v4l/firedtv-1394.c:147: error: implicit declaration of function 
'hpsb_iso_stop'                                      
/v4l-dvb/v4l/firedtv-1394.c: At top 
level:                                                                                   

/v4l-dvb/v4l/firedtv-1394.c:162: warning: 'struct hpsb_host' declared 
inside parameter list                                   
/v4l-dvb/v4l/firedtv-1394.c: In function 'fcp_request':
/v4l-dvb/v4l/firedtv-1394.c:175: error: dereferencing pointer to 
incomplete type
/v4l-dvb/v4l/firedtv-1394.c:176: error: dereferencing pointer to 
incomplete type
/v4l-dvb/v4l/firedtv-1394.c: In function 'node_probe':
/v4l-dvb/v4l/firedtv-1394.c:190: error: dereferencing pointer to 
incomplete type
/v4l-dvb/v4l/firedtv-1394.c:190: warning: type defaults to 'int' in 
declaration of '__mptr'
/v4l-dvb/v4l/firedtv-1394.c:190: warning: initialization from 
incompatible pointer type
/v4l-dvb/v4l/firedtv-1394.c:190: error: invalid use of undefined type 
'struct unit_directory'
/v4l-dvb/v4l/firedtv-1394.c:195: error: dereferencing pointer to 
incomplete type
/v4l-dvb/v4l/firedtv-1394.c:195: error: 'quadlet_t' undeclared (first 
use in this function)
/v4l-dvb/v4l/firedtv-1394.c:196: error: implicit declaration of function 
'CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA'
/v4l-dvb/v4l/firedtv-1394.c:196: error: dereferencing pointer to 
incomplete type
/v4l-dvb/v4l/firedtv-1394.c:196: warning: assignment makes pointer from 
integer without a cast
/v4l-dvb/v4l/firedtv-1394.c: At top level:
/v4l-dvb/v4l/firedtv-1394.c:252: warning: 'struct unit_directory' 
declared inside parameter list
/v4l-dvb/v4l/firedtv-1394.c: In function 'node_update':
/v4l-dvb/v4l/firedtv-1394.c:254: error: dereferencing pointer to 
incomplete type
/v4l-dvb/v4l/firedtv-1394.c: At top level:
/v4l-dvb/v4l/firedtv-1394.c:262: error: variable 'fdtv_driver' has 
initializer but incomplete type
/v4l-dvb/v4l/firedtv-1394.c:263: error: unknown field 'name' specified 
in initializer
/v4l-dvb/v4l/firedtv-1394.c:263: warning: excess elements in struct 
initializer
/v4l-dvb/v4l/firedtv-1394.c:263: warning: (near initialization for 
'fdtv_driver')
/v4l-dvb/v4l/firedtv-1394.c:264: error: unknown field 'id_table' 
specified in initializer
/v4l-dvb/v4l/firedtv-1394.c:264: warning: excess elements in struct 
initializer
/v4l-dvb/v4l/firedtv-1394.c:264: warning: (near initialization for 
'fdtv_driver')
/v4l-dvb/v4l/firedtv-1394.c:265: error: unknown field 'update' specified 
in initializer
/v4l-dvb/v4l/firedtv-1394.c:265: warning: excess elements in struct 
initializer
/v4l-dvb/v4l/firedtv-1394.c:265: warning: (near initialization for 
'fdtv_driver')
/v4l-dvb/v4l/firedtv-1394.c:266: error: unknown field 'driver' specified 
in initializer
/v4l-dvb/v4l/firedtv-1394.c:266: error: extra brace group at end of 
initializer
/v4l-dvb/v4l/firedtv-1394.c:266: error: (near initialization for 
'fdtv_driver')
/v4l-dvb/v4l/firedtv-1394.c:269: warning: excess elements in struct 
initializer
/v4l-dvb/v4l/firedtv-1394.c:269: warning: (near initialization for 
'fdtv_driver')
/v4l-dvb/v4l/firedtv-1394.c:272: error: variable 'fdtv_highlevel' has 
initializer but incomplete type
/v4l-dvb/v4l/firedtv-1394.c:273: error: unknown field 'name' specified 
in initializer
/v4l-dvb/v4l/firedtv-1394.c:273: warning: excess elements in struct 
initializer
/v4l-dvb/v4l/firedtv-1394.c:273: warning: (near initialization for 
'fdtv_highlevel')
/v4l-dvb/v4l/firedtv-1394.c:274: error: unknown field 'fcp_request' 
specified in initializer
/v4l-dvb/v4l/firedtv-1394.c:274: warning: excess elements in struct 
initializer
/v4l-dvb/v4l/firedtv-1394.c:274: warning: (near initialization for 
'fdtv_highlevel')
/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_init':
/v4l-dvb/v4l/firedtv-1394.c:281: error: implicit declaration of function 
'hpsb_register_highlevel'
/v4l-dvb/v4l/firedtv-1394.c:282: error: implicit declaration of function 
'hpsb_register_protocol'
/v4l-dvb/v4l/firedtv-1394.c:285: error: implicit declaration of function 
'hpsb_unregister_highlevel'
/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_exit':
/v4l-dvb/v4l/firedtv-1394.c:292: error: implicit declaration of function 
'hpsb_unregister_protocol'
make[3]: *** [/v4l-dvb/v4l/firedtv-1394.o] Error 1
make[2]: *** [_module_/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-15-generic'
make[1]: *** [default] Fehler 2

