Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3925 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab2GASwq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 14:52:46 -0400
Date: Sun, 1 Jul 2012 20:52:43 +0200
Message-ID: <4FC4F2520000DE77@mta-nl-7.mail.tiscali.sys>
In-Reply-To: <4FC4F2480000D990@mta-nl-1.mail.tiscali.sys>
From: cedric.dewijs@telfort.nl
Subject: Betr: RE: dib0700 can't enable debug messages
To: "Olivier GRENIE" <olivier.grenie@parrot.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>-- Oorspronkelijk bericht --
>Date: Sat, 30 Jun 2012 12:42:29 +0200
>From: cedric.dewijs@telfort.nl
>Subject: Betr: RE: dib0700 can't enable debug messages
>To: "Olivier GRENIE" <olivier.grenie@parrot.com>,
> "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
>
>
>
>>-- Oorspronkelijk bericht --
>>From: Olivier GRENIE <olivier.grenie@parrot.com>
>>To: "cedric.dewijs@telfort.nl" <cedric.dewijs@telfort.nl>,
>>	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
>>Date: Fri, 29 Jun 2012 15:25:00 +0100
>>Subject: RE: dib0700 can't enable debug messages
>>
>>
>>Hello,
>>did you enable the DVB USB debugging (CONFIG_DVB_USB_DEBUG) in your kernel
>>configuration?
>>
Hi Olivier,

I see in the INSTALL file make xconfig needs the full kernel source. I have
fiddled around some with symlinks, but I can't get make xconfig to work:


In the media_build directory I have first created a symlink to the freshly
downloaded kernel source:
$ ls -l
scripts -> /home/cedric/downloads/linux-3.4.3/scripts/

Then I issued the following command:
$ make xconfig
make -C /storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l xconfig
make[1]: Entering directory `/storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l'
make -C /lib/modules/3.3.7-1-ARCH/build -f /storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l/Makefile.kernel
config-targets=1 mixed-targets=0 dot-config=0 SRCDIR=/lib/modules/3.3.7-1-ARCH/build
v4l-qconf
make[2]: Entering directory `/usr/src/linux-3.3.7-1-ARCH'
  HOSTCC  scripts/basic/fixdep
scripts/basic/fixdep.c:433:1: fatal error: opening dependency file scripts/basic/.fixdep.d:
Permission denied
compilation terminated.
make[3]: *** [scripts/basic/fixdep] Error 1
make[2]: *** [scripts_basic] Error 2
make[2]: Leaving directory `/usr/src/linux-3.3.7-1-ARCH'
make[1]: *** [/lib/modules/3.3.7-1-ARCH/build/scripts/kconfig/qconf] Error
2
make[1]: Leaving directory `/storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l'
make: *** [xconfig] Error 2

The directory scripts/basic/.fixdep.d is not present:
$ ls -lA scripts/basic/
total 20
-rw-r--r-- 1 cedric cedric 10782 Jun 17 20:21 fixdep.c
-rw-r--r-- 1 cedric cedric     7 Jun 17 20:21 .gitignore
-rw-r--r-- 1 cedric cedric   671 Jun 17 20:21 Makefile

Next I goto my kernel directory, and run make xconfig from here:
$ cd downloads/linux-3.4.3
[cedric@cedric linux-3.4.3]$ make xconfig
  HOSTCC  scripts/basic/fixdep
  CHECK   qt
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
/usr/bin/moc -i scripts/kconfig/qconf.h -o scripts/kconfig/qconf.moc
  HOSTCXX scripts/kconfig/qconf.o
  HOSTLD  scripts/kconfig/qconf
scripts/kconfig/qconf Kconfig
#
# using defaults found in arch/x86/configs/x86_64_defconfig
#

and now back in the media-build directory I run make xconfig again:
$ cd tmp/linuxtv-mediabuild/media_build/
[cedric@cedric media_build]$ make xconfig
make -C /storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l xconfig
make[1]: Entering directory `/storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l'
make -C /lib/modules/3.3.7-1-ARCH/build -f /storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l/Makefile.kernel
config-targets=1 mixed-targets=0 dot-config=0 SRCDIR=/lib/modules/3.3.7-1-ARCH/build
v4l-qconf
make[2]: Entering directory `/usr/src/linux-3.3.7-1-ARCH'
  HOSTCC  scripts/basic/fixdep
scripts/basic/fixdep.c:433:1: fatal error: opening dependency file scripts/basic/.fixdep.d:
Permission denied
compilation terminated.
make[3]: *** [scripts/basic/fixdep] Error 1
make[2]: *** [scripts_basic] Error 2
make[2]: Leaving directory `/usr/src/linux-3.3.7-1-ARCH'
make[1]: *** [/lib/modules/3.3.7-1-ARCH/build/scripts/kconfig/qconf] Error
2
make[1]: Leaving directory `/storage/home/cedric/tmp/linuxtv-mediabuild/media_build/v4l'
make: *** [xconfig] Error 2

I don't have the directory .fixdep.d:
$ ls -lA scripts/basic/
total 40
-rwxr-xr-x 1 cedric cedric 14561 Jul  1 20:45 fixdep
-rw-r--r-- 1 cedric cedric 10782 Jun 17 20:21 fixdep.c
-rw-r--r-- 1 cedric cedric  2836 Jul  1 20:45 .fixdep.cmd
-rw-r--r-- 1 cedric cedric     7 Jun 17 20:21 .gitignore
-rw-r--r-- 1 cedric cedric   671 Jun 17 20:21 Makefile

What did I miss?
Best regards,
Cedric


       



