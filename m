Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n74.bullet.mail.sp1.yahoo.com ([98.136.44.186])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KepCi-0001Hi-6n
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 12:51:45 +0200
Date: Sun, 14 Sep 2008 03:51:08 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <391631.73780.qm@web46111.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: free_beer_for_all@yahoo.com
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

--- On Sun, 9/14/08, Markus Rechberger <mrechberger@gmail.com> wrote:

> >>> (Also to be noted is that, some BSD chaps also have shown interest in

Does BSD == NetBSD here?  Or are there other developments
as well that I'm not aware of?


> As for the em28xx driver I agreed with pushing all my code

Do you want to have patches for your repository, like the
following (just an example, based on the NetBSD SOC source)

--- em2880-dvb.c-LINUX  2008-09-03 06:47:08.000000000 +0200
+++ em2880-dvb.c        2008-09-14 12:35:49.000000000 +0200
@@ -18,6 +18,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#if defined(__linux__)
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -29,6 +30,7 @@
 #include <linux/dvb/frontend.h>
 #include <linux/usb.h>
 #include <linux/version.h>
+#endif
 
 #include "em28xx.h"
 
@@ -60,9 +62,11 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr
 #define xc3028_offset_atsc 1750000;
 
 
+#if defined(__linux__)
 MODULE_DESCRIPTION("Empiatech em2880 DVB-T extension");
 MODULE_AUTHOR("Markus Rechberger <mrechberger@gmail.com>");
 MODULE_LICENSE("GPL");
+#endif
 
 
 DRX3973DData_t DRX3973DData_g = {
@@ -209,7 +213,11 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "em2880-dvb debug level (default off)");
 
 #define dprintk(lvl, fmt, args...) if (debug >= lvl) do {\
+#if defined(__linux__)
        printk(fmt, ##args); } while (0)
+#elif defined(__NetBSD__)
+       printf(fmt, ##args); } while (0)
+#endif
 
 
 static int em2880_set_alternate(struct em2880_dvb *dvb_dev);


I think I've found something to play with...  (waits patiently
for kernel panic, to have an excuse to reboot)


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
