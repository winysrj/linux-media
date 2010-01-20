Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.106.220.46.78.clients.your-server.de ([78.46.220.106]:44280
	"EHLO mail.vanguard.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0AUABX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 19:01:23 -0500
Date: Thu, 21 Jan 2010 01:53:33 +0200 (EET)
From: Beepo / Vanguard <beepo@vanguard.fi>
To: "Igor M. Liplianin" <liplianin@me.by>,
	linux-media <linux-media@vger.kernel.org>
Message-ID: <9953378.9331264031613604.JavaMail.root@mail.vanguard.fi>
In-Reply-To: <16387496.9311264031520239.JavaMail.root@mail.vanguard.fi>
Subject: s2-liplianin does not compile
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have trouble compiling:

description	DVB-S(S2) drivers for Linux
owner	Igor M. Liplianin
last change	Sun, 17 Jan 2010 22:48:15 +0200

Linux tv-desktop 2.6.31-17-generic #54-Ubuntu SMP Thu Dec 10 17:01:44 UTC 2009 x86_64 GNU/Linux

tv@tv-desktop:~$ gcc --version
gcc (Ubuntu 4.4.1-4ubuntu9) 4.4.1

 CC [M]  /home/tv/s2-liplianin/v4l/firedtv-1394.o
/home/tv/s2-liplianin/v4l/firedtv-1394.c:21:17: error: dma.h: No such file or directory
/home/tv/s2-liplianin/v4l/firedtv-1394.c:22:21: error: csr1212.h: No such file or directory
/home/tv/s2-liplianin/v4l/firedtv-1394.c:23:23: error: highlevel.h: No such file or directory
/home/tv/s2-liplianin/v4l/firedtv-1394.c:24:19: error: hosts.h: No such file or directory
/home/tv/s2-liplianin/v4l/firedtv-1394.c:25:22: error: ieee1394.h: No such file or directory
/home/tv/s2-liplianin/v4l/firedtv-1394.c:26:17: error: iso.h: No such file or directory
/home/tv/s2-liplianin/v4l/firedtv-1394.c:27:21: error: nodemgr.h: No such file or directory
/home/tv/s2-liplianin/v4l/firedtv-1394.c:40: warning: 'struct hpsb_iso' declared inside parameter list
/home/tv/s2-liplianin/v4l/firedtv-1394.c:40: warning: its scope is only this definition or declaration, which is probably not what you want
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'rawiso_activity_cb':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:56: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:57: error: implicit declaration of function 'hpsb_iso_n_ready'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:64: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:65: error: implicit declaration of function 'dma_region_i'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:65: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:65: error: expected expression before 'unsigned'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:66: warning: assignment makes pointer from integer without a cast
/home/tv/s2-liplianin/v4l/firedtv-1394.c:67: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:71: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:85: error: implicit declaration of function 'hpsb_iso_recv_release_packets'
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'node_of':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:90: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:90: warning: type defaults to 'int' in declaration of '__mptr'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:90: warning: initialization from incompatible pointer type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:90: error: invalid use of undefined type 'struct unit_directory'
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'node_lock':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:97: error: implicit declaration of function 'hpsb_node_lock'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:97: error: 'EXTCODE_COMPARE_SWAP' undeclared (first use in this function)
/home/tv/s2-liplianin/v4l/firedtv-1394.c:97: error: (Each undeclared identifier is reported only once
/home/tv/s2-liplianin/v4l/firedtv-1394.c:97: error: for each function it appears in.)
/home/tv/s2-liplianin/v4l/firedtv-1394.c:98: error: 'quadlet_t' undeclared (first use in this function)
/home/tv/s2-liplianin/v4l/firedtv-1394.c:98: error: expected expression before ')' token
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'node_read':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:106: error: implicit declaration of function 'hpsb_node_read'
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'node_write':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:111: error: implicit declaration of function 'hpsb_node_write'
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'start_iso':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:122: error: implicit declaration of function 'hpsb_iso_recv_init'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:122: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:124: error: 'HPSB_ISO_DMA_DEFAULT' undeclared (first use in this function)
/home/tv/s2-liplianin/v4l/firedtv-1394.c:126: warning: assignment makes pointer from integer without a cast
/home/tv/s2-liplianin/v4l/firedtv-1394.c:133: error: implicit declaration of function 'hpsb_iso_recv_start'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:136: error: implicit declaration of function 'hpsb_iso_shutdown'
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'stop_iso':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:147: error: implicit declaration of function 'hpsb_iso_stop'
/home/tv/s2-liplianin/v4l/firedtv-1394.c: At top level:
/home/tv/s2-liplianin/v4l/firedtv-1394.c:162: warning: 'struct hpsb_host' declared inside parameter list
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'fcp_request':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:175: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:176: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'node_probe':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:190: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:190: warning: type defaults to 'int' in declaration of '__mptr'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:190: warning: initialization from incompatible pointer type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:190: error: invalid use of undefined type 'struct unit_directory'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:195: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:196: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:197: error: implicit declaration of function 'CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:197: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:197: warning: assignment makes pointer from integer without a cast
/home/tv/s2-liplianin/v4l/firedtv-1394.c: At top level:
/home/tv/s2-liplianin/v4l/firedtv-1394.c:256: warning: 'struct unit_directory' declared inside parameter list
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'node_update':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:258: error: dereferencing pointer to incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c: At top level:
/home/tv/s2-liplianin/v4l/firedtv-1394.c:266: error: variable 'fdtv_driver' has initializer but incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:267: error: unknown field 'name' specified in initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:267: warning: excess elements in struct initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:267: warning: (near initialization for 'fdtv_driver')
/home/tv/s2-liplianin/v4l/firedtv-1394.c:268: error: unknown field 'id_table' specified in initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:268: warning: excess elements in struct initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:268: warning: (near initialization for 'fdtv_driver')
/home/tv/s2-liplianin/v4l/firedtv-1394.c:269: error: unknown field 'update' specified in initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:269: warning: excess elements in struct initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:269: warning: (near initialization for 'fdtv_driver')
/home/tv/s2-liplianin/v4l/firedtv-1394.c:270: error: unknown field 'driver' specified in initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:270: error: extra brace group at end of initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:270: error: (near initialization for 'fdtv_driver')
/home/tv/s2-liplianin/v4l/firedtv-1394.c:273: warning: excess elements in struct initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:273: warning: (near initialization for 'fdtv_driver')
/home/tv/s2-liplianin/v4l/firedtv-1394.c:276: error: variable 'fdtv_highlevel' has initializer but incomplete type
/home/tv/s2-liplianin/v4l/firedtv-1394.c:277: error: unknown field 'name' specified in initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:277: warning: excess elements in struct initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:277: warning: (near initialization for 'fdtv_highlevel')
/home/tv/s2-liplianin/v4l/firedtv-1394.c:278: error: unknown field 'fcp_request' specified in initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:278: warning: excess elements in struct initializer
/home/tv/s2-liplianin/v4l/firedtv-1394.c:278: warning: (near initialization for 'fdtv_highlevel')
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'fdtv_1394_init':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:285: error: implicit declaration of function 'hpsb_register_highlevel'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:286: error: implicit declaration of function 'hpsb_register_protocol'
/home/tv/s2-liplianin/v4l/firedtv-1394.c:289: error: implicit declaration of function 'hpsb_unregister_highlevel'
/home/tv/s2-liplianin/v4l/firedtv-1394.c: In function 'fdtv_1394_exit':
/home/tv/s2-liplianin/v4l/firedtv-1394.c:296: error: implicit declaration of function 'hpsb_unregister_protocol'
make[3]: *** [/home/tv/s2-liplianin/v4l/firedtv-1394.o] Error 1
make[2]: *** [_module_/home/tv/s2-liplianin/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-17-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/tv/s2-liplianin/v4l'
make: *** [all] Error 2
tv@tv-desktop:~/s2-liplianin$ 
