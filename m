Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail0.scram.de ([78.47.204.202] helo=mail.scram.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jochen@scram.de>) id 1Jod4T-0005Ah-0x
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 13:23:32 +0200
Message-ID: <480F1BFF.7000907@scram.de>
Date: Wed, 23 Apr 2008 13:22:39 +0200
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAXUecTuyghkSp+E+0SVbs1QEAAAAA@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAXUecTuyghkSp+E+0SVbs1QEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE :  Terratec Cinergy T USB XE Rev 2, any update ?
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

Hi Thierry,

> Which "Terratec driver" are you refering to ?
> 
> Is this a Terratec-provided driver ?
> 
> As I mentioned in my original post, the one at
> ftp://ftp.terratec.net/Receiver/Cinergy_T_USB_XE/Update/Cinergy_T_USB_XE_MKII_Drv_Linux.zip
> does not compile _at_all_ and this is not (or not only) a matter of kernel
> version. There are many semantic errors that no C compiler would accept
> (except maybe the K&R from the 70's). I started to fix the errors but when
> I realized how bad it was, my trust in this code dropped and I gave up.

I compiled this with gcc 4.2.3. This is what i did:

cd /tmp
wget ftp://ftp.terratec.net/Receiver/Cinergy_T_USB_XE/Update/Cinergy_T_USB_XE_MKII_Drv_Linux.zip
unzip Cinergy_T_USB_XE_MKII_Drv_Linux.zip
mv Cinergy\ T\ USB\ XE\ MKII/Fedora\ Core\ Release\ 6 dvb_cinergy
hg clone http://linuxtv.org/hg/~anttip/af9015
cd dvb_cinergy/
cp /tmp/af9015/linux/drivers/media/dvb/dvb-core/*.c .
cp /tmp/af9015/linux/drivers/media/dvb/dvb-core/*.h .
cp /tmp/af9015/linux/drivers/media/dvb/dvb-usb/*.c .
cp /tmp/af9015/linux/drivers/media/dvb/dvb-usb/*.h .
cp /tmp/af9015/linux/include/linux/dvb/dmx.h .
patch -p1 < /tmp/cinergy.patch
make

This is the patch (minor header adjusting):

diff -ruN a/dmxdev.h b/dmxdev.h
--- a/dmxdev.h	2008-04-23 12:52:39.000000000 +0200
+++ b/dmxdev.h	2008-04-22 14:00:26.000000000 +0200
@@ -35,7 +35,7 @@
 #include <linux/mutex.h>
 #endif
 
-#include <linux/dvb/dmx.h>
+#include "dmx.h"
 
 #include "dvbdev.h"
 #include "demux.h"
diff -ruN a/dvb_frontend.c b/dvb_frontend.c
--- a/dvb_frontend.c	2008-04-23 12:52:36.000000000 +0200
+++ b/dvb_frontend.c	2008-04-22 14:01:22.000000000 +0200
@@ -25,6 +25,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
+#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
diff -ruN a/dvb_frontend.h b/dvb_frontend.h
--- a/dvb_frontend.h	2008-04-23 12:52:39.000000000 +0200
+++ b/dvb_frontend.h	2008-04-22 13:55:02.000000000 +0200
@@ -28,6 +28,7 @@
 #ifndef _DVB_FRONTEND_H_
 #define _DVB_FRONTEND_H_
 
+#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/ioctl.h>

Thanks,
Jochen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
