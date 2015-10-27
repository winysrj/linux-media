Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36002 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965111AbbJ0TYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 15:24:21 -0400
Received: by lbcao8 with SMTP id ao8so71259963lbc.3
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2015 12:24:20 -0700 (PDT)
Received: from mapperone.Elisa (a88-115-254-86.elisa-laajakaista.fi. [88.115.254.86])
        by smtp.gmail.com with ESMTPSA id v6sm7169090lby.49.2015.10.27.12.24.18
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 27 Oct 2015 12:24:19 -0700 (PDT)
From: Alberto Mardegan <mardy@users.sourceforge.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] em28xx: add Terratec Cinergy T XS (MT2060)
Date: Tue, 27 Oct 2015 21:24:14 +0200
Message-Id: <1445973854-4912-1-git-send-email-mardy@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Terratec Cinergy T XS is a DVB-T receiver with no analog TV tuner.
This patch adds support for the cards carrying the mt2060 tuner; it's
unclear whether there are cards sold under the same name which use a
different tuner.
As long as there are no reports of such cards, and indeed as long as
there are no working drivers for them, we assume that the USB device
[0ccd:0043] is carrying the mt2060 tuner.

Signed-off-by: Alberto Mardegan <mardy@users.sourceforge.net>
---
 Documentation/video4linux/CARDLIST.em28xx |  4 ++--
 drivers/media/usb/em28xx/em28xx-cards.c   |  8 ++++++--
 drivers/media/usb/em28xx/em28xx-dvb.c     | 15 +++++++++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index 9e57ce4..6720999 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -41,8 +41,8 @@
  40 -> Plextor ConvertX PX-TV100U               (em2861)        [093b:a005]
  41 -> Kworld 350 U DVB-T                       (em2870)        [eb1a:e350]
  42 -> Kworld 355 U DVB-T                       (em2870)        [eb1a:e355,eb1a:e357,eb1a:e359]
- 43 -> Terratec Cinergy T XS                    (em2870)        [0ccd:0043]
- 44 -> Terratec Cinergy T XS (MT2060)           (em2870)
+ 43 -> Terratec Cinergy T XS                    (em2870)
+ 44 -> Terratec Cinergy T XS (MT2060)           (em2870)        [0ccd:0043]
  45 -> Pinnacle PCTV DVB-T                      (em2870)
  46 -> Compro, VideoMate U3                     (em2870)        [185b:2870]
  47 -> KWorld DVB-T 305U                        (em2880)        [eb1a:e305]
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 3940046..30d7629 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1051,8 +1051,12 @@ struct em28xx_board em28xx_boards[] = {
 	},
 	[EM2870_BOARD_TERRATEC_XS_MT2060] = {
 		.name         = "Terratec Cinergy T XS (MT2060)",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
+		.xclk         = EM28XX_XCLK_IR_RC5_MODE |
+				EM28XX_XCLK_FREQUENCY_12MHZ,
+		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE,
 		.tuner_type   = TUNER_ABSENT, /* MT2060 */
+		.has_dvb      = 1,
+		.tuner_gpio   = default_tuner_gpio,
 	},
 	[EM2870_BOARD_KWORLD_350U] = {
 		.name         = "Kworld 350 U DVB-T",
@@ -2368,7 +2372,7 @@ struct usb_device_id em28xx_id_table[] = {
 	{ USB_DEVICE(0x0ccd, 0x0042),
 			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
 	{ USB_DEVICE(0x0ccd, 0x0043),
-			.driver_info = EM2870_BOARD_TERRATEC_XS },
+			.driver_info = EM2870_BOARD_TERRATEC_XS_MT2060 },
 	{ USB_DEVICE(0x0ccd, 0x008e),	/* Cinergy HTC USB XS Rev. 1 */
 			.driver_info = EM2884_BOARD_TERRATEC_HTC_USB_XS },
 	{ USB_DEVICE(0x0ccd, 0x00ac),	/* Cinergy HTC USB XS Rev. 2 */
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 357be76..bf5c244 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -38,6 +38,7 @@
 #include "lgdt3305.h"
 #include "zl10353.h"
 #include "s5h1409.h"
+#include "mt2060.h"
 #include "mt352.h"
 #include "mt352_priv.h" /* FIXME */
 #include "tda1002x.h"
@@ -815,6 +816,10 @@ static struct zl10353_config em28xx_zl10353_no_i2c_gate_dev = {
 	.parallel_ts = 1,
 };
 
+static struct mt2060_config em28xx_mt2060_config = {
+	.i2c_address = 0x60,
+};
+
 static struct qt1010_config em28xx_qt1010_config = {
 	.i2c_address = 0x62
 };
@@ -1142,6 +1147,16 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM2870_BOARD_TERRATEC_XS_MT2060:
+		dvb->fe[0] = dvb_attach(zl10353_attach,
+						&em28xx_zl10353_no_i2c_gate_dev,
+						&dev->i2c_adap[dev->def_i2c_bus]);
+		if (dvb->fe[0] != NULL) {
+			dvb_attach(mt2060_attach, dvb->fe[0],
+					&dev->i2c_adap[dev->def_i2c_bus],
+					&em28xx_mt2060_config, 1220);
+		}
+		break;
 	case EM2870_BOARD_KWORLD_355U:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_no_i2c_gate_dev,
-- 
1.9.1

