Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([119.147.10.224]:49509 "HELO smtpbg65.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752163AbZH3QGG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 12:06:06 -0400
Subject: Re: [PATCH] [Updated] em28xx: Add entry for GADMEI UTV330+ and
 related IR keymap
From: Shine Liu <shinel@foxmail.com>
To: dougsland@redhat.com, mchehab@redhat.com
Cc: dheitmueller@kernellabs.com, linux-media@vger.kernel.org
In-Reply-To: <1251647815.1388.28.camel@sl>
References: <1251647815.1388.28.camel@sl>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 00:05:56 +0800
Message-Id: <1251648356.1388.33.camel@sl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-08-30 at 23:56 +0800, Shine Liu wrote:
> Several days ago, I posted a patch named "em28xx: Add entry for GADMEI
> UTV330+ and related IR codec" and this patch has been merged into
> http://linuxtv.org/hg/~dougsland/v4l-dvb/rev/93337af98bcb but not
> included in Mauro's tree yet.
> 
> The patch added a section in ir-keymap which can be used by GADMEI 3xx
> series cards. But it includes some KEY_[A-Z] keys known by Tvtime. I
> updated this patch to use the standard media key definition recommanded
> by Mauro.
> 
> Sorry for the defect patch posted last week.
> 
> Regards,
> 
> Shine
> 

Updated IR keymap coding sytle.



Signed-off-by: Shine Liu <shinel@foxmail.com>

--- a/drivers/media/video/em28xx/em28xx-cards.c	2009-08-14 06:43:34.000000000 +0800
+++ b/drivers/media/video/em28xx/em28xx-cards.c	2009-08-21 01:31:23.000000000 +0800
@@ -558,6 +558,27 @@
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
+	[EM2861_BOARD_GADMEI_UTV330PLUS] = {
+		.name         = "Gadmei UTV330+",
+		.tuner_type   = TUNER_TNF_5335MF,
+		.tda9887_conf = TDA9887_PRESENT,
+		.ir_codes     = ir_codes_gadmei_rm008z,
+		.decoder      = EM28XX_SAA711X,
+		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
+		.input        = { {
+			.type     = EM28XX_VMUX_TELEVISION,
+			.vmux     = SAA7115_COMPOSITE2,
+			.amux     = EM28XX_AMUX_VIDEO,
+		}, {
+			.type     = EM28XX_VMUX_COMPOSITE1,
+			.vmux     = SAA7115_COMPOSITE0,
+			.amux     = EM28XX_AMUX_LINE_IN,
+		}, {
+			.type     = EM28XX_VMUX_SVIDEO,
+			.vmux     = SAA7115_SVIDEO3,
+			.amux     = EM28XX_AMUX_LINE_IN,
+		} },
+	},
 	[EM2860_BOARD_TERRATEC_HYBRID_XS] = {
 		.name         = "Terratec Cinergy A Hybrid XS",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
@@ -1665,6 +1686,7 @@
 	{0xf51200e3, EM2800_BOARD_VGEAR_POCKETTV, TUNER_LG_PAL_NEW_TAPC},
 	{0x1ba50080, EM2860_BOARD_SAA711X_REFERENCE_DESIGN, TUNER_ABSENT},
 	{0xc51200e3, EM2820_BOARD_GADMEI_TVR200, TUNER_LG_PAL_NEW_TAPC},
+	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
 };
 
 /* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
--- a/drivers/media/video/em28xx/em28xx.h	2009-08-14 06:43:34.000000000 +0800
+++ b/drivers/media/video/em28xx/em28xx.h	2009-08-21 01:32:16.000000000 +0800
@@ -108,6 +108,7 @@
 #define EM2882_BOARD_KWORLD_ATSC_315U		  69
 #define EM2882_BOARD_EVGA_INDTUBE		  70
 #define EM2820_BOARD_SILVERCREST_WEBCAM           71
+#define EM2861_BOARD_GADMEI_UTV330PLUS           72
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
--- a/drivers/media/common/ir-keymaps.c	2009-08-14 06:43:34.000000000 +0800
+++ b/drivers/media/common/ir-keymaps.c	2009-08-21 01:38:25.000000000 +0800
@@ -2773,3 +2773,46 @@
 	[0x13] = KEY_CAMERA,
 };
 EXPORT_SYMBOL_GPL(ir_codes_evga_indtube);
+
+/* GADMEI UTV330+ RM008Z remote
+   Shine Liu <shinel@foxmail.com> 
+ */
+IR_KEYTAB_TYPE ir_codes_gadmei_rm008z[IR_KEYTAB_SIZE] = {
+	[0x14] = KEY_ESC,		/* POWER OFF */
+	[0x0c] = KEY_MUTE,		/* MUTE */
+
+	[0x18] = KEY_TV,		/* TV */
+	[0x0e] = KEY_VIDEO,		/* AV */
+	[0x0b] = KEY_AUDIO,		/* SV */
+	[0x0f] = KEY_RADIO,		/* FM */
+
+	[0x00] = KEY_1,
+	[0x01] = KEY_2,
+	[0x02] = KEY_3,
+	[0x03] = KEY_4,
+	[0x04] = KEY_5,
+	[0x05] = KEY_6,
+	[0x06] = KEY_7,
+	[0x07] = KEY_8,
+	[0x08] = KEY_9,
+	[0x09] = KEY_0,
+	[0x0a] = KEY_INFO,		/* OSD */
+	[0x1c] = KEY_BACKSPACE,		/* LAST */
+
+	[0x0d] = KEY_PLAY,		/* PLAY */
+	[0x1e] = KEY_CAMERA,		/* SNAPSHOT */
+	[0x1a] = KEY_RECORD,		/* RECORD */
+	[0x17] = KEY_STOP,		/* STOP */
+
+	[0x1f] = KEY_UP,		/* UP */
+	[0x44] = KEY_DOWN,		/* DOWN */
+	[0x46] = KEY_TAB,		/* BACK */
+	[0x4a] = KEY_ZOOM,		/* FULLSECREEN */
+	
+	[0x10] = KEY_RIGHT,		/* VOLUMEUP */
+	[0x11] = KEY_LEFT,		/* VOLUMEDOWN */
+	[0x12] = KEY_UP,		/* CHANNELUP */
+	[0x13] = KEY_DOWN,		/* CHANNELDOWN */
+	[0x15] = KEY_ENTER,		/* OK */
+};
+EXPORT_SYMBOL_GPL(ir_codes_gadmei_rm008z);
--- a/include/media/ir-common.h	2009-08-14 06:43:34.000000000 +0800
+++ b/include/media/ir-common.h	2009-08-21 01:41:01.000000000 +0800
@@ -163,6 +163,7 @@
 extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_evga_indtube[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_gadmei_rm008z[IR_KEYTAB_SIZE];
 
 #endif
 
--- a/Documentation/video4linux/CARDLIST.em28xx	2009-08-14 06:43:34.000000000 +0800
+++ b/Documentation/video4linux/CARDLIST.em28xx	2009-08-21 01:45:35.000000000 +0800
@@ -67,3 +67,4 @@
  69 -> KWorld ATSC 315U HDTV TV Box             (em2882)        [eb1a:a313]
  70 -> Evga inDtube                             (em2882)
  71 -> Silvercrest Webcam 1.3mpix               (em2820/em2840)
+ 72 -> Gadmei UTV330+                           (em2861)



