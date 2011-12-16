Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:38585 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab1LPSPS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 13:15:18 -0500
From: Matthieu CASTET <castet.matthieu@free.fr>
To: linux-media@vger.kernel.org
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
	Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] tm6000 : improve loading speed on hauppauge 900H
Date: Fri, 16 Dec 2011 19:15:07 +0100
Message-Id: <1324059307-7094-1-git-send-email-castet.matthieu@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- enable fast usb quirk
- use usleep_range instead on msleep for short sleep
- merge i2c out and usb delay
- do like the windows driver that upload the tuner firmware with 80 bytes
packets

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
CC: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    2 ++
 drivers/staging/tm6000/tm6000-core.c  |   16 +++++++++++++++-
 drivers/staging/tm6000/tm6000-i2c.c   |    8 +-------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index ec2578a..2136fa9 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -941,6 +941,7 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		case TM6010_BOARD_HAUPPAUGE_900H:
 		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 		case TM6010_BOARD_TWINHAN_TU501:
+			ctl.max_len = 80;
 			ctl.fname = "xc3028L-v36.fw";
 			break;
 		default:
@@ -1002,6 +1003,7 @@ static int fill_board_specific_data(struct tm6000_core *dev)
 	/* setup per-model quirks */
 	switch (dev->model) {
 	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+	case TM6010_BOARD_HAUPPAUGE_900H:
 		dev->quirks |= TM6000_QUIRK_NO_USB_DELAY;
 		break;
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 6d0803c..c559f9f 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -38,6 +38,7 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	int          ret, i;
 	unsigned int pipe;
 	u8	     *data = NULL;
+	int delay = 5000;
 
 	mutex_lock(&dev->usb_lock);
 
@@ -88,7 +89,20 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	}
 
 	kfree(data);
-	msleep(5);
+
+	if (dev->quirks & TM6000_QUIRK_NO_USB_DELAY)
+		delay = 0;
+
+	if (req == REQ_16_SET_GET_I2C_WR1_RDN && !(req_type & USB_DIR_IN)) {
+		unsigned int tsleep;
+		/* Calculate delay time, 14000us for 64 bytes */
+		tsleep = (len * 200) + 200;
+		if (tsleep < delay)
+			tsleep = delay;
+		usleep_range(tsleep, tsleep + 1000);
+	}
+	else if (delay)
+		usleep_range(delay, delay + 1000);
 
 	mutex_unlock(&dev->usb_lock);
 	return ret;
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 76a8e3a..8809ed1 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -46,11 +46,10 @@ static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 				__u8 reg, char *buf, int len)
 {
 	int rc;
-	unsigned int tsleep;
 	unsigned int i2c_packet_limit = 16;
 
 	if (dev->dev_type == TM6010)
-		i2c_packet_limit = 64;
+		i2c_packet_limit = 80;
 
 	if (!buf)
 		return -1;
@@ -71,10 +70,6 @@ static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 		return rc;
 	}
 
-	/* Calculate delay time, 14000us for 64 bytes */
-	tsleep = ((len * 200) + 200 + 1000) / 1000;
-	msleep(tsleep);
-
 	/* release mutex */
 	return rc;
 }
@@ -145,7 +140,6 @@ static int tm6000_i2c_recv_regs16(struct tm6000_core *dev, unsigned char addr,
 			return rc;
 		}
 
-		msleep(1400 / 1000);
 		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
 			USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
 			reg, 0, buf, len);
-- 
1.7.5.4

