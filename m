Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.250.18.140] (helo=tv-numeric.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1LHwiD-0001ox-D7
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 09:45:58 +0100
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: "'BOUWSMA Barry'" <freebeer.bouwsma@gmail.com>,
	<linux-dvb@linuxtv.org>
Date: Wed, 31 Dec 2008 09:45:22 +0100
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAKD9Q4NAVr0+H0MAg3L7x3gEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0812302027170.29535@ybpnyubfg.ybpnyqbznva>
Subject: [linux-dvb] RE :  Compile error,
	bug in compat.h with kernel 2.6.27.9 ?
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


De : BOUWSMA Barry [mailto:freebeer.bouwsma@gmail.com] 
> 
> On Tue, 30 Dec 2008, Thierry Lelegard wrote:
> 
> > OK, looking into the source RPM for the latest Fedora 10 update
> > kernel (kernel-2.6.27.9-159.fc10.src.rpm), it appears that
> > the definition of pci_ioremap_bar in pci.h was introduced by
> > linux-2.6.27.7-alsa-driver-fixups.patch
> > 
> > I assume that this is a Fedora-specific patch (or more 
> generally Red Hat),
> > back-porting 2.6.28 stuff.
> 
> There may be hope for a dirty hack...
> 
> As part of this, I also see
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -644,6 +644,7 @@ struct input_absinfo {
>  #define SW_RADIO               SW_RFKILL_ALL   /* deprecated */
>  #define SW_MICROPHONE_INSERT   0x04  /* set = inserted */
>  #define SW_DOCK                        0x05  /* set = 
> plugged into dock */
> +#define SW_LINEOUT_INSERT      0x06  /* set = plugged into dock 
> */
> 
> which is not yet in my latest 2.6.28 git kernel...
> 
> These both seem to be present since -r1.1 through HEAD,
> so I would guess you can special-case this check into
> a 2.6.27 version test.

Good idea. After some more checks, it seems reasonable. I consequently
propose the following patch:

====[CUT HERE]====
--- v4l-dvb.1/v4l/compat.h	2008-12-31 09:16:32.000000000 +0100
+++ v4l-dvb.2/v4l/compat.h	2008-12-31 09:30:08.000000000 +0100
@@ -31,6 +31,11 @@
 #include <linux/i2c.h>
 #endif
 
+/* To validate cpp test before pci_ioremap_bar */
+#if LINUX_VERSION_CODE == KERNEL_VERSION(2, 6, 27)
+#include <linux/input.h>
+#endif
+
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)
 #define set_freezable()
 #define cancel_delayed_work_sync cancel_rearming_delayed_work
@@ -268,7 +273,7 @@
 })
 #endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 27) || (LINUX_VERSION_CODE == KERNEL_VERSION(2, 6, 27) && !defined
(SW_LINEOUT_INSERT))
 #define snd_BUG_ON(cond)	WARN((cond), "BUG? (%s)\n", __stringify(cond))
 
 #define pci_ioremap_bar(pci, a)				\
====[CUT HERE]====

Quite dirty indeed, but isn't it the exact purpose of the compat.h file,
being the dirty glue to compile latest kernel code inside older kernels ?

I think this would help all Fedora users to have this little path committed
into the linuxtv.org repository.

Thanks Barry for your idea.
-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
