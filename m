Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASAa7kH021276
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 05:36:07 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASAZrCT016824
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 05:35:53 -0500
Received: by fk-out-0910.google.com with SMTP id e30so1348371fke.3
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 02:35:52 -0800 (PST)
Message-ID: <3500cb490811280235o77f37588s2bcb60cc1bffb15f@mail.gmail.com>
Date: Fri, 28 Nov 2008 11:35:52 +0100
From: MR <raketomet@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Pinnacle 73e - can not suddenly compile v4l-dvb
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

Hi, I had a working 73e on OpenSuse 10.3 - using your guideline
http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_nano_Stick_(73e) - till
I recently updated to the 2.26.22.19 (x86_64) (also distribution kernel).
Now it does not compile with new and even previous one (2.26.22.18-0.2). I
have this older kernel, kernel-sources for it, kernel headers. I can
download sources doing hg clone http://linuxtv.org/hg/v4l-dvb and hg update
-C 4501, but make does not finish successfully::
64U:~/v4l-dvb # make
make -C /root/v4l-dvb/v4l
make[1]: Entering directory `/root/v4l-dvb/v4l'
No version yet.
scripts/make_makefile.pl /lib/modules/2.6.22.18-0.2-default/build
Creating Makefile.media.
Preparing to compile for kernel version 2.6.22
VIDEO_PLANB requires version 2.6.99
VIDEO_ZR36120 requires version 2.6.99
RADIO_MIROPCM20: /lib/modules/2.6.22.18-0.2-default/build/sound/oss/aci.h is
missing.

***WARNING:*** You do not have the full kernel sources installed.
This does not prevent you from building the v4l-dvb tree if you have the
kernel headers, but the full kernel source is required in order to use
make menuconfig / xconfig / qconfig.

If you are experiencing problems building the v4l-dvb tree, please try
building against a vanilla kernel before reporting a bug.

Vanilla kernels are available at http://kernel.org.
On most distros, this will compile a newly downloaded kernel:

cp /boot/config-`uname -r` /.config
cd
make all modules_install install

Please see your distro's web site for instructions to build a new kernel.

VIDEO_MEYE: Required kernel opt 'SONYPI' is not present
RADIO_ZOLTRIX: Required kernel opt 'ISA' is not present
RADIO_GEMTEK: Required kernel opt 'ISA' is not present
RADIO_RTRACK2: Required kernel opt 'ISA' is not present
VIDEO_M32R_AR: Required kernel opt 'M32R' is not present
VIDEO_M32R_AR_M64278: Required kernel opt 'VIDEO_M32R_AR' is not present
RADIO_SF16FMI: Required kernel opt 'ISA' is not present
RADIO_AZTECH: Required kernel opt 'ISA' is not present
RADIO_TERRATEC: Required kernel opt 'ISA' is not present
RADIO_TRUST: Required kernel opt 'ISA' is not present
RADIO_CADET: Required kernel opt 'ISA' is not present
VIDEO_VINO: Required kernel opt 'I2C_ALGO_SGI' is not present
VIDEO_PMS: Required kernel opt 'ISA' is not present
RADIO_MIROPCM20_RDS: Required kernel opt 'RADIO_MIROPCM20' is not present
VIDEO_ZR36120: Required kernel opt 'BROKEN' is not present
RADIO_TYPHOON: Required kernel opt 'ISA' is not present
RADIO_SF16FMR2: Required kernel opt 'ISA' is not present
VIDEO_PLANB: Required kernel opt 'PPC_PMAC' is not present
VIDEO_PLANB: Required kernel opt 'BROKEN' is not present
RADIO_RTRACK: Required kernel opt 'ISA' is not present
./scripts/make_myconfig.pl
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make[1]: Entering directory `/root/v4l-dvb/v4l'
creating symbolic links...
echo srcdir
srcdir
make -C /lib/modules/2.6.22.18-0.2-default/build SUBDIRS=/root/v4l-dvb/v4l
modules
make[2]: Entering directory
`/usr/src/linux-2.6.22.18-0.2-obj/x86_64/default'
make -C ../../../linux-2.6.22.18-0.2
O=../linux-2.6.22.18-0.2-obj/x86_64/default modules
CC [M] /root/v4l-dvb/v4l/flexcop-pci.o
In file included from /root/v4l-dvb/v4l/compat.h:13,
from /root/v4l-dvb/v4l/flexcop-common.h:12,
from /root/v4l-dvb/v4l/flexcop-pci.c:10:
/root/v4l-dvb/v4l/config-compat.h:4:26: error: linux/config.h: No such file
or directory
/root/v4l-dvb/v4l/flexcop-pci.c: In function 'flexcop_pci_irq_check_work':
/root/v4l-dvb/v4l/flexcop-pci.c:119: warning: passing argument 1 of
'schedule_delayed_work' from incompatible pointer type
/root/v4l-dvb/v4l/flexcop-pci.c: In function 'flexcop_pci_stream_control':
/root/v4l-dvb/v4l/flexcop-pci.c:222: warning: passing argument 1 of
'schedule_delayed_work' from incompatible pointer type
/root/v4l-dvb/v4l/flexcop-pci.c:225: warning: passing argument 1 of
'cancel_delayed_work' from incompatible pointer type
/root/v4l-dvb/v4l/flexcop-pci.c: In function 'flexcop_pci_init':
/root/v4l-dvb/v4l/flexcop-pci.c:297: warning: passing argument 2 of
'request_irq' from incompatible pointer type
/root/v4l-dvb/v4l/flexcop-pci.c:374:71: error: macro "INIT_WORK" passed 3
arguments, but takes just 2
/root/v4l-dvb/v4l/flexcop-pci.c: In function 'flexcop_pci_probe':
/root/v4l-dvb/v4l/flexcop-pci.c:374: error: 'INIT_WORK' undeclared (first
use in this function)
/root/v4l-dvb/v4l/flexcop-pci.c:374: error: (Each undeclared identifier is
reported only once
/root/v4l-dvb/v4l/flexcop-pci.c:374: error: for each function it appears
in.)
make[5]: *** [/root/v4l-dvb/v4l/flexcop-pci.o] Error 1
make[4]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[3]: *** [modules] Error 2
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.22.18-0.2-obj/x86_64/default'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2
64U:~/v4l-dvb #

What changed during a month or two? What should I try?

Thanks

Miro
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
