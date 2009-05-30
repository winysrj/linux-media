Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f225.google.com ([209.85.219.225])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <laserer@gmail.com>) id 1MAL5J-0006LZ-Ol
	for linux-dvb@linuxtv.org; Sat, 30 May 2009 11:42:38 +0200
Received: by ewy25 with SMTP id 25so3975865ewy.17
	for <linux-dvb@linuxtv.org>; Sat, 30 May 2009 02:42:04 -0700 (PDT)
Message-ID: <4A20FF6A.2000505@gmail.com>
Date: Sat, 30 May 2009 11:42:02 +0200
From: Thomas Leitner <laserer@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] s2-liplianin - Source won't compile under Ubuntu 9.04
 64bit (Kernel 2.6.28-11)
Reply-To: linux-media@vger.kernel.org
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



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
