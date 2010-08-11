Return-path: <mchehab@pedra>
Received: from web35805.mail.mud.yahoo.com ([66.163.179.174]:48106 "HELO
	web35805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752902Ab0HKJKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 05:10:50 -0400
Message-ID: <425100.71304.qm@web35805.mail.mud.yahoo.com>
Date: Wed, 11 Aug 2010 02:10:49 -0700 (PDT)
From: Sicoe Alexandru Dan <sicoe_alex@yahoo.com>
Subject: Error Building the V4L-DVB drivers from source
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,
 My name is Alex and I recently tried to install the v4l drivers on my machine.
 Environment:
    Ubuntu release 10.04(lucid)
    Kernel Linux 2.6.32-24-generic
    GNOME 2.30.2
    
 I followed the steps given on the wiki  at:
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers


 using Mercurial to get the source code

When I get to the "Building/Compiling the Modules" stage where I need to call 
"make" in the /v4l-dvb/ folder, the whole process begins and a lot of files are 
generated but after a few 
minutes I get this:
_________________________________________________________________________________________


make -C /home/v4l-dvb/v4l 
make[1]: Entering directory `/home/v4l-dvb/v4l'
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/home/v4l-dvb/v4l/firmware'
make[2]: Leaving directory `/home/v4l-dvb/v4l/firmware'
make -C firmware
make[2]: Entering directory `/home/v4l-dvb/v4l/firmware'
make[2]: Nothing to be done for `default'.
make[2]: Leaving directory `/home/v4l-dvb/v4l/firmware'
Kernel build  directory is /lib/modules/2.6.32-24-generic/build
make -C /lib/modules/2.6.32-24-generic/build SUBDIRS=/home/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.32-24-generic'
  CC [M]  /home/v4l-dvb/v4l/firedtv-1394.o
/home/v4l-dvb/v4l/firedtv-1394.c:22:17: error: dma.h: No such file or directory
/home/v4l-dvb/v4l/firedtv-1394.c:23:21: error: csr1212.h: No such file or 
directory
/home/v4l-dvb/v4l/firedtv-1394.c:24:23: error: highlevel.h: No such file or 
directory
/home/v4l-dvb/v4l/firedtv-1394.c:25:19: error: hosts.h: No such file or 
directory
/home/v4l-dvb/v4l/firedtv-1394.c:26:22: error: ieee1394.h: No such file or 
directory
/home/v4l-dvb/v4l/firedtv-1394.c:27:17: error: iso.h: No such file or directory
/home/v4l-dvb/v4l/firedtv-1394.c:28:21: error: nodemgr.h: No such file or  
directory
/home/v4l-dvb/v4l/firedtv-1394.c:41: warning: 'struct hpsb_iso' declared inside 
parameter list
/home/v4l-dvb/v4l/firedtv-1394.c:41: warning: its scope is only this definition 
or declaration, which is probably not what you want
/home/v4l-dvb/v4l/firedtv-1394.c: In function  'rawiso_activity_cb':
/home/v4l-dvb/v4l/firedtv-1394.c:57: error: dereferencing pointer to incomplete 
type
/home/v4l-dvb/v4l/firedtv-1394.c:58: error: implicit declaration of function 
'hpsb_iso_n_ready'
/home/v4l-dvb/v4l/firedtv-1394.c:65: error: dereferencing pointer to incomplete 
type
/home/v4l-dvb/v4l/firedtv-1394.c:66: error: implicit declaration of function 
'dma_region_i'
/home/v4l-dvb/v4l/firedtv-1394.c:66: error: dereferencing pointer to incomplete 
type
/home/v4l-dvb/v4l/firedtv-1394.c:66: error: expected expression before 
'unsigned'
/home/v4l-dvb/v4l/firedtv-1394.c:68: error: dereferencing pointer to incomplete 
type
/home/v4l-dvb/v4l/firedtv-1394.c:72: error: dereferencing pointer to incomplete 
type
/home/v4l-dvb/v4l/firedtv-1394.c:86: error: implicit declaration of function 
'hpsb_iso_recv_release_packets'
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'node_of':
/home/v4l-dvb/v4l/firedtv-1394.c:91: error:  dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c:91: warning: type defaults to 'int' in 
declaration of '__mptr'
/home/v4l-dvb/v4l/firedtv-1394.c:91: warning: initialization from incompatible 
pointer type
/home/v4l-dvb/v4l/firedtv-1394.c:91: error: invalid use of undefined type 
'struct unit_directory'
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'node_lock':
/home/v4l-dvb/v4l/firedtv-1394.c:96: error: 'quadlet_t' undeclared (first use in 

this function)
/home/v4l-dvb/v4l/firedtv-1394.c:96: error: (Each undeclared identifier is 
reported only once
/home/v4l-dvb/v4l/firedtv-1394.c:96: error: for each function it appears in.)
/home/v4l-dvb/v4l/firedtv-1394.c:96: error: 'd' undeclared (first use in this 
function)
/home/v4l-dvb/v4l/firedtv-1394.c:97: warning: ISO C90 forbids mixed declarations 

and code
/home/v4l-dvb/v4l/firedtv-1394.c:99: error: implicit declaration of function  
'hpsb_node_lock'
/home/v4l-dvb/v4l/firedtv-1394.c:100: error: 'EXTCODE_COMPARE_SWAP' undeclared 
(first use in this function)
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'node_read':
/home/v4l-dvb/v4l/firedtv-1394.c:108: error: implicit declaration of function 
'hpsb_node_read'
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'node_write':
/home/v4l-dvb/v4l/firedtv-1394.c:113: error: implicit declaration of function 
'hpsb_node_write'
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'start_iso':
/home/v4l-dvb/v4l/firedtv-1394.c:124: error: implicit declaration of function 
'hpsb_iso_recv_init'
/home/v4l-dvb/v4l/firedtv-1394.c:124: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c:126: error: 'HPSB_ISO_DMA_DEFAULT' undeclared 
(first use in this function)
/home/v4l-dvb/v4l/firedtv-1394.c:135: error: implicit declaration of function 
'hpsb_iso_recv_start'
/home/v4l-dvb/v4l/firedtv-1394.c:138: error:  implicit declaration of function 
'hpsb_iso_shutdown'
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'stop_iso':
/home/v4l-dvb/v4l/firedtv-1394.c:149: error: implicit declaration of function 
'hpsb_iso_stop'
/home/v4l-dvb/v4l/firedtv-1394.c: At top level:
/home/v4l-dvb/v4l/firedtv-1394.c:164: warning: 'struct hpsb_host' declared 
inside parameter list
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'fcp_request':
/home/v4l-dvb/v4l/firedtv-1394.c:177: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c:178: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'node_probe':
/home/v4l-dvb/v4l/firedtv-1394.c:192: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c:192: warning: type defaults to 'int' in 
declaration of '__mptr'
/home/v4l-dvb/v4l/firedtv-1394.c:192: warning: initialization from incompatible 
pointer  type
/home/v4l-dvb/v4l/firedtv-1394.c:192: error: invalid use of undefined type 
'struct unit_directory'
/home/v4l-dvb/v4l/firedtv-1394.c:197: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c:198: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c:199: error: implicit declaration of function 
'CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA'
/home/v4l-dvb/v4l/firedtv-1394.c:199: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c: At top level:
/home/v4l-dvb/v4l/firedtv-1394.c:258: warning: 'struct unit_directory' declared 
inside parameter list
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'node_update':
/home/v4l-dvb/v4l/firedtv-1394.c:260: error: dereferencing pointer to incomplete 

type
/home/v4l-dvb/v4l/firedtv-1394.c: At top level:
/home/v4l-dvb/v4l/firedtv-1394.c:268: error: variable 'fdtv_driver' has 
initializer but incomplete  type
/home/v4l-dvb/v4l/firedtv-1394.c:269: error: unknown field 'name' specified in 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:269: warning: excess elements in struct 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:269: warning: (near initialization for 
'fdtv_driver')
/home/v4l-dvb/v4l/firedtv-1394.c:270: error: unknown field 'id_table' specified 
in initializer
/home/v4l-dvb/v4l/firedtv-1394.c:270: warning: excess elements in struct 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:270: warning: (near initialization for 
'fdtv_driver')
/home/v4l-dvb/v4l/firedtv-1394.c:271: error: unknown field 'update' specified in 

initializer
/home/v4l-dvb/v4l/firedtv-1394.c:271: warning: excess elements in struct 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:271: warning: (near initialization for 
'fdtv_driver')
/home/v4l-dvb/v4l/firedtv-1394.c:272: error: unknown field 'driver' specified in 

initializer
/home/v4l-dvb/v4l/firedtv-1394.c:272:  error: extra brace group at end of 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:272: error: (near initialization for 
'fdtv_driver')
/home/v4l-dvb/v4l/firedtv-1394.c:275: warning: excess elements in struct 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:275: warning: (near initialization for 
'fdtv_driver')
/home/v4l-dvb/v4l/firedtv-1394.c:278: error: variable 'fdtv_highlevel' has 
initializer but incomplete type
/home/v4l-dvb/v4l/firedtv-1394.c:279: error: unknown field 'name' specified in 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:279: warning: excess elements in struct 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:279: warning: (near initialization for 
'fdtv_highlevel')
/home/v4l-dvb/v4l/firedtv-1394.c:280: error: unknown field 'fcp_request' 
specified in initializer
/home/v4l-dvb/v4l/firedtv-1394.c:280: warning: excess elements in struct 
initializer
/home/v4l-dvb/v4l/firedtv-1394.c:280: warning: (near initialization for  
'fdtv_highlevel')
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_init':
/home/v4l-dvb/v4l/firedtv-1394.c:287: error: implicit declaration of function 
'hpsb_register_highlevel'
/home/v4l-dvb/v4l/firedtv-1394.c:288: error: implicit declaration of function 
'hpsb_register_protocol'
/home/v4l-dvb/v4l/firedtv-1394.c:291: error: implicit declaration of function 
'hpsb_unregister_highlevel'
/home/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_exit':
/home/v4l-dvb/v4l/firedtv-1394.c:298: error: implicit declaration of function 
'hpsb_unregister_protocol'
make[3]: *** [/home/v4l-dvb/v4l/firedtv-1394.o] Error 1
make[2]: *** [_module_/home/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-24-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/v4l-dvb/v4l'
make: *** [all] Error  2
_________________________________________________________________________________________



The first error seems to be because it cannot find dma.h

Is this a bug or am I doing something wrong?

Thank you,
Alex


      
