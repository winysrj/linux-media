Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55597 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab3LMHCs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 02:02:48 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [RFC PATCH 3/3] cx231xx: add wintv 930c hd dvb support
Date: Fri, 13 Dec 2013 08:02:13 +0100
Message-Id: <1386918133-21628-4-git-send-email-zzam@gentoo.org>
In-Reply-To: <1386918133-21628-1-git-send-email-zzam@gentoo.org>
References: <1386918133-21628-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/Kconfig         |  1 +
 drivers/media/usb/cx231xx/cx231xx-cards.c |  2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 25 +++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index f14c5e8..036454e 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -47,6 +47,7 @@ config VIDEO_CX231XX_DVB
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
 
 	---help---
 	  This adds support for DVB cards based on the
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index b6b99a0..6e64696 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -720,7 +720,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = 1,
 		.demod_i2c_master = 2,
-		.has_dvb = 0,
+		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_PAL,
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 4504bc6..e3d8e3c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -32,6 +32,7 @@
 #include "tda18271.h"
 #include "s5h1411.h"
 #include "lgdt3305.h"
+#include "si2165.h"
 #include "mb86a20s.h"
 
 MODULE_DESCRIPTION("driver for cx231xx based DVB cards");
@@ -704,6 +705,30 @@ static int dvb_init(struct cx231xx *dev)
 			   &hcw_tda18271_config);
 		break;
 
+	case CX231XX_BOARD_HAUPPAUGE_EXETER_CT:
+
+		printk(KERN_INFO "%s: looking for tuner / demod on i2c bus: %d\n",
+		       __func__, i2c_adapter_id(&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap));
+
+		dev->dvb->frontend = dvb_attach(si2165_attach,
+						0x64,
+						&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap);
+
+		if (dev->dvb->frontend == NULL) {
+			printk(DRIVER_NAME
+			       ": Failed to attach SI2165 front end\n");
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		/* define general-purpose callback pointer */
+		dvb->frontend->callback = cx231xx_tuner_callback;
+
+		dvb_attach(tda18271_attach, dev->dvb->frontend,
+			   0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			   &hcw_tda18271_config);
+		break;
+
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
-- 
1.8.4.4

