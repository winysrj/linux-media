Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:51363 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZE3Jpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2009 05:45:47 -0400
Received: by ewy24 with SMTP id 24so6782672ewy.37
        for <linux-media@vger.kernel.org>; Sat, 30 May 2009 02:45:47 -0700 (PDT)
Message-ID: <4A21004A.9000900@gmail.com>
Date: Sat, 30 May 2009 11:45:46 +0200
From: Thomas Leitner <laserer@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: s2-liplianin - Source won't compile under Ubuntu 9.04 64bit (Kernel
 2.6.28-11)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear linuxtv Community, following problem:

I'm owner of a Technotrend TT-connect S2 3650CI DVB-S2 USB Receiver for
about 6 months. On my old system (Ubuntu 8.04.2 32bit), the tutorial on
the linuxtv-wiki
(http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI)
worked perfectly for me. But on my new System (Ubuntu 9.04 64bit, Kernel
2.6.28, complete fresh install, NO Upgrade!), I am unable to compile the
source in the tutorial (S2API - Part). One Problem seems to be the so
called dvbdev.c Source - file, which seems to distinguish by Precompiler
between Kernel < 2.6.26 and Kernel >= 2.6.26. At this point, compilation
aborts:

CC [M] /home/user/technotrend/s2-liplianin/v4l/dvbdev.o
/home/user/technotrend/s2-liplianin/v4l/dvbdev.c: In function
'dvb_register_device':
/home/user/technotrend/s2-liplianin/v4l/dvbdev.c:246: error: implicit
declaration of function 'device_create_drvdata'
/home/user/technotrend/s2-liplianin/v4l/dvbdev.c:248: warning:
assignment makes pointer from integer without a cast
make[3]: *** [/home/user/technotrend/s2-liplianin/v4l/dvbdev.o] Error 1
make[2]: *** [_module_/home/user/technotrend/s2-liplianin/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-11-generic'
make[1]: *** [default] Fehler 2
make[1]: Verlasse Verzeichnis '/home/user/technotrend/s2-liplianin/v4l'
make: *** [all] Fehler 2

If I remove this if-statement to compile only the source for the older
kernel-versions, then compilation succeeds. But when I try to insert the
kernel modules, it says:

insmod: error inserting 'dvb-usb-pctv452e.ko': -1 Unknown symbol in module

Maybe that this is just the result of my editing of the dvbdev.c -
source - file, or this is an additional bug in the pctv452e source file.


Any suggestions how to solve this problem?


Kind regards

P.S.: I sent this email to linux-dvb@linuxtv.org first, but got a 
message, that this ML is deprecated.

