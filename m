Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian.lammers@gmail.com>) id 1LKX4k-0004kx-EI
	for linux-dvb@linuxtv.org; Wed, 07 Jan 2009 12:59:56 +0100
Received: by bwz11 with SMTP id 11so18302344bwz.17
	for <linux-dvb@linuxtv.org>; Wed, 07 Jan 2009 03:59:20 -0800 (PST)
Message-ID: <4964989C.6000506@gmail.com>
Date: Wed, 07 Jan 2009 12:57:16 +0100
From: Christian Lammers <christian.lammers@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Compiling mantis driver on 2.6.28
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

i'm new to this mailinglist, so 'Hello' to all :)

My first problem, cause of bleeding edge hardware, intels gem, hdmi,
experimental xorg and so on, i've problems to compile the mantis driver
from http://jusst.de/hg/mantis on 2.6.28.

I'm getting the following:

Kernel build directory is /lib/modules/2.6.28/build
make -C /lib/modules/2.6.28/build
SUBDIRS=/usr/src/mantis-303b1d29d735/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.28'
  CC [M]  /usr/src/mantis-303b1d29d735/v4l/dvbdev.o
/usr/src/mantis-303b1d29d735/v4l/dvbdev.c: In function
'dvb_register_device':
/usr/src/mantis-303b1d29d735/v4l/dvbdev.c:246: error: implicit
declaration of function 'device_create_drvdata'
/usr/src/mantis-303b1d29d735/v4l/dvbdev.c:248: warning: assignment makes
pointer from integer without a cast
make[3]: *** [/usr/src/mantis-303b1d29d735/v4l/dvbdev.o] Error 1
make[2]: *** [_module_/usr/src/mantis-303b1d29d735/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.28'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/mantis-303b1d29d735/v4l'
make: *** [all] Error 2


Someone else with these problems?

If only compiling the mantis driver, when changing the .config file in
the v4l subdir i'm getting the following:

 CC [M]  /usr/src/mantis-303b1d29d735/v4l/mantis_vp1041.o
  CC [M]  /usr/src/mantis-303b1d29d735/v4l/mantis_vp2033.o
  CC [M]  /usr/src/mantis-303b1d29d735/v4l/mantis_vp2040.o
  CC [M]  /usr/src/mantis-303b1d29d735/v4l/mantis_vp3030.o
  LD [M]  /usr/src/mantis-303b1d29d735/v4l/mantis.o
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "mb86a16_attach" [/usr/src/mantis-303b1d29d735/v4l/mantis.ko]
undefined!
WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  CC      /usr/src/mantis-303b1d29d735/v4l/mantis.mod.o
  LD [M]  /usr/src/mantis-303b1d29d735/v4l/mantis.ko
make[1]: Leaving directory `/usr/src/linux-2.6.28'
./scripts/rmmod.pl check
found 1 modules

Is there a patch or something else to get this driver working on 2.6.28

Thanks in advance,

Christian

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
