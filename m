Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58591 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab0E2PtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 11:49:20 -0400
Received: by fxm10 with SMTP id 10so1401186fxm.19
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 08:49:18 -0700 (PDT)
Subject: Re: [PATCH] TechnoTrend TT-budget T-3000
From: Vadim Catana <vadim.catana@gmail.com>
Reply-To: vadim.catana@gmail.com
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4BFBF5A7.6070703@redhat.com>
References: <1273172404.2154.26.camel@xxx>  <4BFBF5A7.6070703@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 18:49:16 +0300
Message-ID: <1275148156.1874.12.camel@xxx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-05-25 at 13:07 -0300, Mauro Carvalho Chehab wrote:
> Vadim Catana wrote:
> > Hi,
> > 
> > This patch adds support for TechnoTrend TT-budget T-3000
> > DVB-T card.
> 
> Please send your Signed-off-by together with the patch. Also,
> send just one copy of the patch, not line-wrapped, otherwise, it
> will fail when trying to apply on my tree.
> 
> Cheers,
> Mauro.


Resending the patch that adds support for
TechnoTrend TT-budget T-3000 DVB-T card.


Signed-off-by: Vadim Catana <vadim.catana@gmail.com>



diff -r 304cfde05b3f linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat May 29 18:19:17 2010 +0300
@@ -5467,6 +5467,30 @@
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_TECHNOTREND_BUDGET_T3000] = {
+		.name           = "TechoTrend TT-budget T-3000",
+		.tuner_type     = TUNER_PHILIPS_TD1316,
+		.audio_clock    = 0x00187de7,
+		.radio_type     = UNSET,
+		.tuner_addr     = 0x63,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs = {{
+			.name   = name_tv,
+			.vmux   = 3,
+			.amux   = TV,
+			.tv     = 1,
+		}, {
+			.name   = name_comp1,
+			.vmux   = 0,
+			.amux   = LINE2,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE2,
+		} },
+	},
 
 };
 
@@ -6624,6 +6648,12 @@
 		.subdevice    = 0x6655,
 		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x13c2,
+		.subdevice    = 0x2804,
+		.driver_data  = SAA7134_BOARD_TECHNOTREND_BUDGET_T3000,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7349,6 +7379,7 @@
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
 	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
+	case SAA7134_BOARD_TECHNOTREND_BUDGET_T3000:
 	{
 
 		/* The Philips EUROPA based hybrid boards have the tuner
diff -r 304cfde05b3f linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat May 29 18:19:17 2010 +0300
@@ -482,6 +482,17 @@
 	.request_firmware = philips_tda1004x_request_firmware
 };
 
+static struct tda1004x_config technotrend_budget_t3000_config = {
+	.demod_address = 0x8,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_4M,
+	.agc_config    = TDA10046_AGC_DEFAULT,
+	.if_freq       = TDA10046_FREQ_3617,
+	.tuner_address = 0x63,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * tda 1004x based cards with philips silicon tuner
  */
@@ -1169,6 +1180,18 @@
 			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
 		}
 		break;
+	case SAA7134_BOARD_TECHNOTREND_BUDGET_T3000:
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
+					       &technotrend_budget_t3000_config,
+					       &dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			dev->original_demod_sleep = fe0->dvb.frontend->ops.sleep;
+			fe0->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
+			fe0->dvb.frontend->ops.tuner_ops.init = philips_europa_tuner_init;
+			fe0->dvb.frontend->ops.tuner_ops.sleep = philips_europa_tuner_sleep;
+			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
+		}
+		break;
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &philips_tu1216_61_config,
diff -r 304cfde05b3f linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Sat May 29 18:19:17 2010 +0300
@@ -304,6 +304,7 @@
 #define SAA7134_BOARD_HAWELL_HW_404M7		177
 #define SAA7134_BOARD_BEHOLD_H7             178
 #define SAA7134_BOARD_BEHOLD_A7             179
+#define SAA7134_BOARD_TECHNOTREND_BUDGET_T3000 180
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8


