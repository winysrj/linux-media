Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaAEPuT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 10:50:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx: rename I2C timeout to EM28XX_I2C_XFER_TIMEOUT
Date: Sun,  5 Jan 2014 10:46:54 -0200
Message-Id: <1388926014-3706-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This macro is used by all em28xx devices, and not just em2800.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 6 +++---
 drivers/media/usb/em28xx/em28xx.h     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9fa7ed51e5b1..a22fec727ae7 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -49,7 +49,7 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
  */
 static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
 	int ret;
 	u8 b2[6];
 
@@ -100,7 +100,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
  */
 static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
 	u8 buf2[4];
 	int ret;
 	int i;
@@ -171,7 +171,7 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 u16 len, int stop)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
 	int ret;
 
 	if (len < 1 || len > 64)
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 9fe061ff1227..544c7ebeaba9 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -184,7 +184,7 @@
 #define EM28XX_INTERLACED_DEFAULT 1
 
 /* time in msecs to wait for i2c xfers to finish */
-#define EM2800_I2C_XFER_TIMEOUT		20
+#define EM28XX_I2C_XFER_TIMEOUT		20
 
 /* time in msecs to wait for AC97 xfers to finish */
 #define EM28XX_AC97_XFER_TIMEOUT	100
-- 
1.8.3.1

