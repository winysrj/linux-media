Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9I82rk013577
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 13:08:02 -0500
Received: from proxy1.bredband.net (proxy1.bredband.net [195.54.101.71])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9I7C7c024169
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 13:07:13 -0500
Received: from ironport2.bredband.com (195.54.101.122) by proxy1.bredband.net
	(7.3.127) id 48DC49FD00D7773C for video4linux-list@redhat.com;
	Sun, 9 Nov 2008 19:07:12 +0100
Message-ID: <491726CF.4050008@home.se>
Date: Sun, 09 Nov 2008 19:07:11 +0100
From: Andreas Lunderhage <lunderhage@home.se>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Failing to build em28xx-new
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I fail to build the em28xx-new driver due to missing files.

dmxdev.h, dvb_demux.h, dvb_net.h and dvb_frontend.h.

Where are these files? I have searched the whole repository of Ubuntu
8.10 and only found them one time in a package that did seem to be too
old for use with this code.

My question is: How do you build em28xx-new in Ubuntu 8.10?

BR
/Lunderhage

I attach the output of trying to build this module:

lunderhage@Lunsectop:~/em28xx-new$ ./build.sh build
rm -rf Module.symvers;
make -C /lib/modules/`if [ -d /lib/modules/2.6.21.4-eeepc ]; then echo
2.6.21.4-eeepc; else uname -r; fi`/build SUBDIRS=`pwd` modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
CC [M] /home/lunderhage/em28xx-new/em2880-dvb.o
In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:33:
/home/lunderhage/em28xx-new/em28xx.h:32:20: error: dmxdev.h: No such
file or directory
/home/lunderhage/em28xx-new/em28xx.h:33:23: error: dvb_demux.h: No such
file or directory
/home/lunderhage/em28xx-new/em28xx.h:34:21: error: dvb_net.h: No such
file or directory
/home/lunderhage/em28xx-new/em28xx.h:35:26: error: dvb_frontend.h: No
such file or directory
In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:33:
/home/lunderhage/em28xx-new/em28xx.h:553: error: field ‘demux’ has
incomplete type
/home/lunderhage/em28xx-new/em28xx.h:561: error: field ‘adapter’ has
incomplete type
/home/lunderhage/em28xx-new/em28xx.h:564: error: field ‘dmxdev’ has
incomplete type
/home/lunderhage/em28xx-new/em28xx.h:566: error: field ‘dvbnet’ has
incomplete type
In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:40:
/home/lunderhage/em28xx-new/mt352/mt352.h: In function ‘mt352_write’:
/home/lunderhage/em28xx-new/mt352/mt352.h:68: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/mt352/mt352.h:69: error: dereferencing
pointer to incomplete type
In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:42:
/home/lunderhage/em28xx-new/drx3973d/drx3973d_demod.h: At top level:
/home/lunderhage/em28xx-new/drx3973d/drx3973d_demod.h:9: error: field
‘frontend’ has incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:48:22: error: lgdt330x.h: No
such file or directory
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em2880_complete_irq’:
/home/lunderhage/em28xx-new/em2880-dvb.c:256: error: implicit
declaration of function ‘dvb_dmx_swfilter’
/home/lunderhage/em28xx-new/em2880-dvb.c: At top level:
/home/lunderhage/em28xx-new/em2880-dvb.c:365: warning: ‘struct
dvb_demux_feed’ declared inside parameter list
/home/lunderhage/em28xx-new/em2880-dvb.c:365: warning: its scope is only
this definition or declaration, which is probably not what you want
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em2880_start_feed’:
/home/lunderhage/em28xx-new/em2880-dvb.c:367: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:368: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: At top level:
/home/lunderhage/em28xx-new/em2880-dvb.c:382: warning: ‘struct
dvb_demux_feed’ declared inside parameter list
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em2880_stop_feed’:
/home/lunderhage/em28xx-new/em2880-dvb.c:384: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:385: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em28xx_ts_bus_ctrl’:
/home/lunderhage/em28xx-new/em2880-dvb.c:411: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘mt352_pinnacle_init’:
/home/lunderhage/em28xx-new/em2880-dvb.c:462: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: At top level:
/home/lunderhage/em28xx-new/em2880-dvb.c:488: error: variable
‘em2880_lgdt3303_dev’ has initializer but incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:489: error: unknown field
‘demod_address’ specified in initializer
/home/lunderhage/em28xx-new/em2880-dvb.c:489: warning: excess elements
in struct initializer
/home/lunderhage/em28xx-new/em2880-dvb.c:489: warning: (near
initialization for ‘em2880_lgdt3303_dev’)
/home/lunderhage/em28xx-new/em2880-dvb.c:490: error: unknown field
‘demod_chip’ specified in initializer
/home/lunderhage/em28xx-new/em2880-dvb.c:490: error: ‘LGDT3303’
undeclared here (not in a function)
/home/lunderhage/em28xx-new/em2880-dvb.c:491: warning: excess elements
in struct initializer
/home/lunderhage/em28xx-new/em2880-dvb.c:491: warning: (near
initialization for ‘em2880_lgdt3303_dev’)
/home/lunderhage/em28xx-new/em2880-dvb.c: In function
‘kworld355u_i2c_gate_ctrl’:
/home/lunderhage/em28xx-new/em2880-dvb.c:505: error: field ‘frontend’
has incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:511: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em28xx_set_params’:
/home/lunderhage/em28xx-new/em2880-dvb.c:525: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:534: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function
‘em28xx_get_frequency’:
/home/lunderhage/em28xx-new/em2880-dvb.c:652: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function
‘em28xx_get_bandwidth’:
/home/lunderhage/em28xx-new/em2880-dvb.c:659: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em28xx_dvb_init’:
/home/lunderhage/em28xx-new/em2880-dvb.c:667: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em28xx_s921_init’:
/home/lunderhage/em28xx-new/em2880-dvb.c:723: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em28xx_zl10353_init’:
/home/lunderhage/em28xx-new/em2880-dvb.c:740: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function
‘em28xx_zl10353_sleep’:
/home/lunderhage/em28xx-new/em2880-dvb.c:785: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em28xx_dvb_sleep’:
/home/lunderhage/em28xx-new/em2880-dvb.c:797: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em2880_dvb_init’:
/home/lunderhage/em28xx-new/em2880-dvb.c:866: error: implicit
declaration of function ‘dvb_attach’
/home/lunderhage/em28xx-new/em2880-dvb.c:870: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:889: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:892: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:897: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:903: error: ‘lgdt330x_attach’
undeclared (first use in this function)
/home/lunderhage/em28xx-new/em2880-dvb.c:903: error: (Each undeclared
identifier is reported only once
/home/lunderhage/em28xx-new/em2880-dvb.c:903: error: for each function
it appears in.)
/home/lunderhage/em28xx-new/em2880-dvb.c:904: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:913: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:918: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:924: warning: assignment makes
pointer from integer without a cast
/home/lunderhage/em28xx-new/em2880-dvb.c:927: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:928: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:929: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:950: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:951: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:953: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:955: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:959: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:961: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:970: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:984: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:986: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:987: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:1005: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c:1008: error: implicit
declaration of function ‘dvb_register_adapter’
/home/lunderhage/em28xx-new/em2880-dvb.c:1026: error: implicit
declaration of function ‘dvb_register_frontend’
/home/lunderhage/em28xx-new/em2880-dvb.c:1033: error: ‘DMX_TS_FILTERING’
undeclared (first use in this function)
/home/lunderhage/em28xx-new/em2880-dvb.c:1034: error:
‘DMX_SECTION_FILTERING’ undeclared (first use in this function)
/home/lunderhage/em28xx-new/em2880-dvb.c:1035: error:
‘DMX_MEMORY_BASED_FILTERING’ undeclared (first use in this function)
/home/lunderhage/em28xx-new/em2880-dvb.c:1037: error: implicit
declaration of function ‘dvb_dmx_init’
/home/lunderhage/em28xx-new/em2880-dvb.c:1048: error: implicit
declaration of function ‘dvb_dmxdev_init’
/home/lunderhage/em28xx-new/em2880-dvb.c:1052: error: implicit
declaration of function ‘dvb_dmxdev_release’
/home/lunderhage/em28xx-new/em2880-dvb.c:1063: error: implicit
declaration of function ‘dvb_net_init’
/home/lunderhage/em28xx-new/em2880-dvb.c:1063: error: dereferencing
pointer to incomplete type
/home/lunderhage/em28xx-new/em2880-dvb.c: In function ‘em2880_dvb_fini’:
/home/lunderhage/em28xx-new/em2880-dvb.c:1083: error: implicit
declaration of function ‘dvb_net_release’
/home/lunderhage/em28xx-new/em2880-dvb.c:1084: error: implicit
declaration of function ‘dvb_unregister_frontend’
/home/lunderhage/em28xx-new/em2880-dvb.c:1085: error: implicit
declaration of function ‘dvb_frontend_detach’
/home/lunderhage/em28xx-new/em2880-dvb.c:1089: error: implicit
declaration of function ‘dvb_dmx_release’
/home/lunderhage/em28xx-new/em2880-dvb.c:1091: error: implicit
declaration of function ‘dvb_unregister_adapter’
make[2]: *** [/home/lunderhage/em28xx-new/em2880-dvb.o] Error 1
make[1]: *** [_module_/home/lunderhage/em28xx-new] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic'
make: *** [default] Error 2
lunderhage@Lunsectop:~/em28xx-new$

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
