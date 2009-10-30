Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <andreas.breitbach@gmail.com>) id 1N3xTV-0004I2-Jg
	for linux-dvb@linuxtv.org; Fri, 30 Oct 2009 20:49:30 +0100
Received: by bwz27 with SMTP id 27so4909139bwz.1
	for <linux-dvb@linuxtv.org>; Fri, 30 Oct 2009 12:48:56 -0700 (PDT)
From: Andreas Breitbach <andreas.breitbach@gmail.com>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="=-QVjltIn92w0T/az8kHUl"
Date: Fri, 30 Oct 2009 20:48:52 +0100
Message-ID: <1256932132.3563.12.camel@andy-laptop>
Mime-Version: 1.0
Subject: [linux-dvb] Possible error in firedtv-1394.o?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-QVjltIn92w0T/az8kHUl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello all.

I subscribed to this mailing list to report a possible error in the
above mentioned module. For your better understanding, some details
about my situation: I upgraded yesterday from Jaunty(Ubuntu) to the new
Karmic. I had a "0ccd:0069 TerraTec Electronic GmbH Cinergy T XE DVB-T
Receiver"(lsusb output), which worked with the drivers avaible from
http://linuxtv.org/hg/~anttip/. After the upgrade, I tried to compile
and install the modules necessary for the stick by entering "make all".
It compiles til reaching firedtv-1394.o, I attached the output, which
complains about this specific module.
As I'm not a programmer, but rather a normal user who clued together how
to get this stick working once, I fear I can not be of much help in
debugging. Nonetheless, I'd be very interested in knowing about the
status of this and when my TV will be back working(or how I could
circumvent this error).

TIA,

Andy

--=-QVjltIn92w0T/az8kHUl
Content-Disposition: attachment; filename="log.txt"
Content-Type: text/plain; name="log.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/home/andy/Desktop/af9015-32bba41e7337/v4l/et61x251_core.c: In function 'et61x251_ioctl_v4l2':
/home/andy/Desktop/af9015-32bba41e7337/v4l/et61x251_core.c:2491: warning: the frame size of 1256 bytes is larger than 1024 bytes
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:21:17: error: dma.h: No such file or directory
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:22:21: error: csr1212.h: No such file or directory
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:23:23: error: highlevel.h: No such file or directory
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:24:19: error: hosts.h: No such file or directory
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:25:22: error: ieee1394.h: No such file or directory
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:26:17: error: iso.h: No such file or directory
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:27:21: error: nodemgr.h: No such file or directory
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:37: warning: 'struct hpsb_iso' declared inside parameter list
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:37: warning: its scope is only this definition or declaration, which is probably not what you want
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'rawiso_activity_cb':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:53: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:54: error: implicit declaration of function 'hpsb_iso_n_ready'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:61: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:62: error: implicit declaration of function 'dma_region_i'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:62: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:62: error: expected expression before 'unsigned'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:63: warning: assignment makes pointer from integer without a cast
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:64: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:68: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:82: error: implicit declaration of function 'hpsb_iso_recv_release_packets'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'node_of':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:87: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:87: warning: type defaults to 'int' in declaration of '__mptr'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:87: warning: initialization from incompatible pointer type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:87: error: invalid use of undefined type 'struct unit_directory'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'node_lock':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:92: error: implicit declaration of function 'hpsb_node_lock'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:92: error: 'EXTCODE_COMPARE_SWAP' undeclared (first use in this function)
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:92: error: (Each undeclared identifier is reported only once
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:92: error: for each function it appears in.)
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:93: error: 'quadlet_t' undeclared (first use in this function)
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:93: error: expected ')' before 'arg'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'node_read':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:98: error: implicit declaration of function 'hpsb_node_read'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'node_write':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:103: error: implicit declaration of function 'hpsb_node_write'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'start_iso':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:114: error: implicit declaration of function 'hpsb_iso_recv_init'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:114: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:116: error: 'HPSB_ISO_DMA_DEFAULT' undeclared (first use in this function)
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:118: warning: assignment makes pointer from integer without a cast
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:125: error: implicit declaration of function 'hpsb_iso_recv_start'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:128: error: implicit declaration of function 'hpsb_iso_shutdown'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'stop_iso':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:139: error: implicit declaration of function 'hpsb_iso_stop'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: At top level:
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:154: warning: 'struct hpsb_host' declared inside parameter list
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'fcp_request':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:167: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:168: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'node_probe':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:182: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:182: warning: type defaults to 'int' in declaration of '__mptr'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:182: warning: initialization from incompatible pointer type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:182: error: invalid use of undefined type 'struct unit_directory'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:187: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:187: error: 'quadlet_t' undeclared (first use in this function)
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:188: error: implicit declaration of function 'CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:188: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:188: warning: assignment makes pointer from integer without a cast
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: At top level:
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:243: warning: 'struct unit_directory' declared inside parameter list
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'node_update':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:245: error: dereferencing pointer to incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: At top level:
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:253: error: variable 'fdtv_driver' has initializer but incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:254: error: unknown field 'name' specified in initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:254: warning: excess elements in struct initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:254: warning: (near initialization for 'fdtv_driver')
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:255: error: unknown field 'update' specified in initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:255: warning: excess elements in struct initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:255: warning: (near initialization for 'fdtv_driver')
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:256: error: unknown field 'driver' specified in initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:256: error: extra brace group at end of initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:256: error: (near initialization for 'fdtv_driver')
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:259: warning: excess elements in struct initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:259: warning: (near initialization for 'fdtv_driver')
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:262: error: variable 'fdtv_highlevel' has initializer but incomplete type
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:263: error: unknown field 'name' specified in initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:263: warning: excess elements in struct initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:263: warning: (near initialization for 'fdtv_highlevel')
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:264: error: unknown field 'fcp_request' specified in initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:264: warning: excess elements in struct initializer
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:264: warning: (near initialization for 'fdtv_highlevel')
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'fdtv_1394_init':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:271: error: implicit declaration of function 'hpsb_register_highlevel'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:272: error: invalid use of undefined type 'struct hpsb_protocol_driver'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:273: error: implicit declaration of function 'hpsb_register_protocol'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:276: error: implicit declaration of function 'hpsb_unregister_highlevel'
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c: In function 'fdtv_1394_exit':
/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.c:283: error: implicit declaration of function 'hpsb_unregister_protocol'
make[3]: *** [/home/andy/Desktop/af9015-32bba41e7337/v4l/firedtv-1394.o] Error 1
make[2]: *** [_module_/home/andy/Desktop/af9015-32bba41e7337/v4l] Error 2
make[1]: *** [default] Fehler 2
make: *** [all] Fehler 2

--=-QVjltIn92w0T/az8kHUl
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-QVjltIn92w0T/az8kHUl--
