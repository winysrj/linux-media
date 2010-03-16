Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:37804 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121Ab0CPSTT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 14:19:19 -0400
Received: from kabelnet-199-166.juropnet.hu ([91.147.199.166])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NrbMH-0005Fz-NT
	for linux-media@vger.kernel.org; Tue, 16 Mar 2010 19:19:16 +0100
Message-ID: <4B9FCCE5.7000204@mailbox.hu>
Date: Tue, 16 Mar 2010 19:24:37 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B463AC6.2000901@mailbox.hu>	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com>	 <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com>	 <4B7C84F3.4080708@redhat.com>	 <829197381002171611u7fcc8caeuea98e047164ae55@mail.gmail.com>	 <4B9D23DD.8080401@mailbox.hu> <829197381003142115v6b10a328n30eadeef64b87c8@mail.gmail.com>
In-Reply-To: <829197381003142115v6b10a328n30eadeef64b87c8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2010 05:15 AM, Devin Heitmueller wrote:

> I've done essentially no analysis into the tuning performance of the
> current driver - validating different frequency ranges and modulation
> types or bandwidths.  I've done no testing of tuning lock time,
> minimal application validation

Well, so far it definitely seems usable and not apparently worse
than on Windows. If more developers can test and review it, then it
is more likely that any issues can be found and fixed or improved.

> and no effort toward making sure the power management works.

I did implement power management (by writing to register 8, and
setting a flag that forces resetting the tuner and reloading all
firmware data on the next use), although it is disabled by default
for the cards that I added support for (it is apparently not used
on Windows, either).

> I'll try to go through my tree and see if I can get something upstream
> this week which you could build on.

I think adding xc4000.c/h and the few changes shown at the end of this
post to incorporate XC4000 as a tuner type should be enough. Did you
review the changes I made to the XC4000 driver ? Is there something
that is unneeded or should be done differently ? Do you have a fixed
firmware file, or are the ones I created usable ?

> Once that is done, you will need to break up your huge patch into a series
> of small incremental patches (with proper descriptions for the changes),
> since there is no way a single patch is going to be accepted upstream
> which has all of your changes.

OK. Should I also create patches for any of the unrelated cx88
fixes/changes ?

> Also, you should *not* be submitting board profiles that are
> completely unvalidated.  I saw your email on Feb 19th, where you
> dumped out a list of tuners that you think might *possibly* work.  You
> should only submit board definitions for devices that either you have
> tested or you have gotten a user to test.  It is far worse to have
> broken code in there (creating the illusion of a product being
> supported), then for there to be no support at all.  When users
> complain about a particular board not working, you can work with them
> to get it supported.

Of the additional boards, 107d:6f38 (WinFast DTV1800 H with XC4000 tuner
instead of XC3028) has been reported by one user to work in analog mode,
while DVB was untested. Is that enough to keep the board profile ?
I have 107d:6f42 (DTV2000 H Plus), and tested it extensively in analog
and FM radio mode; another user tested DVB-T, and reported it to work
well (I have got no information about details like bandwidth used,
though). As far as I know, the only difference between the above two
cards that is relevant to drivers is that the latter has an additional
GPIO for selecting the antenna/cable RF input.
I have no problems with removing the various TV2000 XP Global revisions
from the patches, as I do not even know if anyone actually has one of
those cards.

------------------------------------------------------------------------

diff -r -d -N -U4
v4l-dvb-7a58d924fb04.old/linux/drivers/media/common/tuners/Kconfig
v4l-dvb-7a58d924fb04/linux/drivers/media/common/tuners/Kconfig
--- v4l-dvb-7a58d924fb04.old/linux/drivers/media/common/tuners/Kconfig
2010-03-10 03:00:59.000000000 +0100
+++ v4l-dvb-7a58d924fb04/linux/drivers/media/common/tuners/Kconfig
2010-03-10 17:12:02.000000000 +0100
@@ -22,8 +22,9 @@
 	default VIDEO_MEDIA && I2C
 	depends on VIDEO_MEDIA && I2C
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMISE
@@ -150,8 +151,17 @@
 	  A driver for the silicon tuner XC5000 from Xceive.
 	  This device is only used inside a SiP called together with a
 	  demodulator for now.

+config MEDIA_TUNER_XC4000
+	tristate "Xceive XC4000 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  A driver for the silicon tuner XC4000 from Xceive.
+	  This device is only used inside a SiP called together with a
+	  demodulator for now.
+
 config MEDIA_TUNER_MXL5005S
 	tristate "MaxLinear MSL5005S silicon tuner"
 	depends on VIDEO_MEDIA && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
diff -r -d -N -U4
v4l-dvb-7a58d924fb04.old/linux/drivers/media/common/tuners/Makefile
v4l-dvb-7a58d924fb04/linux/drivers/media/common/tuners/Makefile
--- v4l-dvb-7a58d924fb04.old/linux/drivers/media/common/tuners/Makefile
2010-03-10 03:00:59.000000000 +0100
+++ v4l-dvb-7a58d924fb04/linux/drivers/media/common/tuners/Makefile
2010-03-10 17:12:02.000000000 +0100
@@ -15,8 +15,9 @@
 obj-$(CONFIG_MEDIA_TUNER_TDA9887) += tda9887.o
 obj-$(CONFIG_MEDIA_TUNER_TDA827X) += tda827x.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18271) += tda18271.o
 obj-$(CONFIG_MEDIA_TUNER_XC5000) += xc5000.o
+obj-$(CONFIG_MEDIA_TUNER_XC4000) += xc4000.o
 obj-$(CONFIG_MEDIA_TUNER_MT2060) += mt2060.o
 obj-$(CONFIG_MEDIA_TUNER_MT2266) += mt2266.o
 obj-$(CONFIG_MEDIA_TUNER_QT1010) += qt1010.o
 obj-$(CONFIG_MEDIA_TUNER_MT2131) += mt2131.o
diff -r -d -N -U4
v4l-dvb-7a58d924fb04.old/linux/drivers/media/common/tuners/tuner-types.c
v4l-dvb-7a58d924fb04/linux/drivers/media/common/tuners/tuner-types.c
---
v4l-dvb-7a58d924fb04.old/linux/drivers/media/common/tuners/tuner-types.c	2010-03-10
03:00:59.000000000 +0100
+++
v4l-dvb-7a58d924fb04/linux/drivers/media/common/tuners/tuner-types.c
2010-03-10 17:12:02.000000000 +0100
@@ -1778,8 +1778,12 @@
 	[TUNER_XC5000] = { /* Xceive 5000 */
 		.name   = "Xceive 5000 tuner",
 		/* see xc5000.c for details */
 	},
+	[TUNER_XC4000] = { /* Xceive 4000 */
+		.name   = "Xceive 4000 tuner",
+		/* see xc4000.c for details */
+	},
 	[TUNER_TCL_MF02GIP_5N] = { /* TCL tuner MF02GIP-5N-E */
 		.name   = "TCL tuner MF02GIP-5N-E",
 		.params = tuner_tcl_mf02gip_5n_params,
 		.count  = ARRAY_SIZE(tuner_tcl_mf02gip_5n_params),
diff -r -d -N -U4
v4l-dvb-7a58d924fb04.old/linux/drivers/media/video/tuner-core.c
v4l-dvb-7a58d924fb04/linux/drivers/media/video/tuner-core.c
--- v4l-dvb-7a58d924fb04.old/linux/drivers/media/video/tuner-core.c
2010-03-10 03:00:59.000000000 +0100
+++ v4l-dvb-7a58d924fb04/linux/drivers/media/video/tuner-core.c
2010-03-10 17:12:02.000000000 +0100
@@ -29,8 +29,9 @@
 #include "tuner-xc2028.h"
 #include "tuner-simple.h"
 #include "tda9887.h"
 #include "xc5000.h"
+#include "xc4000.h"
 #include "tda18271.h"

 #define UNSET (-1U)

@@ -324,8 +325,9 @@
 	}
 }

 static struct xc5000_config xc5000_cfg;
+static struct xc4000_config xc4000_cfg;

 static void set_type(struct i2c_client *c, unsigned int type,
 		     unsigned int new_mode_mask, unsigned int new_config,
 		     int (*tuner_callback) (void *dev, int component, int cmd, int arg))
@@ -437,8 +439,21 @@
 			goto attach_failed;
 		tune_now = 0;
 		break;
 	}
+	case TUNER_XC4000:
+	{
+		/* card_type and if_khz will be set when the digital
+		   dvb_attach() occurs */
+		xc4000_cfg.card_type	  = XC4000_CARD_WINFAST_CX88;
+		xc4000_cfg.i2c_address	  = t->i2c->addr;
+		xc4000_cfg.if_khz	  = 0;
+		if (!dvb_attach(xc4000_attach,
+				&t->fe, t->i2c->adapter, &xc4000_cfg))
+			goto attach_failed;
+		tune_now = 0;
+		break;
+	}
 	case TUNER_NXP_TDA18271:
 	{
 		struct tda18271_config cfg = {
 			.config = t->config,
diff -r -d -N -U4 v4l-dvb-7a58d924fb04.old/linux/include/media/tuner.h
v4l-dvb-7a58d924fb04/linux/include/media/tuner.h
--- v4l-dvb-7a58d924fb04.old/linux/include/media/tuner.h	2010-03-10
03:00:59.000000000 +0100
+++ v4l-dvb-7a58d924fb04/linux/include/media/tuner.h	2010-03-10
17:12:02.000000000 +0100
@@ -129,8 +129,9 @@
 #define TUNER_PARTSNIC_PTI_5NF05	81
 #define TUNER_PHILIPS_CU1216L           82
 #define TUNER_NXP_TDA18271		83
 #define TUNER_SONY_BTF_PXN01Z		84
+#define TUNER_XC4000			85	/* Xceive Silicon Tuner */

 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)
 #define TDA9887_PORT1_INACTIVE 		(1<<1)
