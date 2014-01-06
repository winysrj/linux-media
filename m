Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaAFQI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 11:08:26 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/6] [media] em28xx: convert i2c wait completion logic to use jiffies
Date: Mon,  6 Jan 2014 11:04:55 -0200
Message-Id: <1389013500-3110-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
References: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C wait completion/timeout logic currently assumes that
msleep(5) will wait exaclty 5 ms. This is not true at all,
as it depends on CONFIG_HZ.

Convert it to use jiffies, in order to not wait for more time
than needed.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 61 ++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index c4ff9739a7ae..91f9f0a3f05e 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
+#include <linux/jiffies.h>
 
 #include "em28xx.h"
 #include "tuner-xc2028.h"
@@ -48,8 +49,8 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
  */
 static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
 	int ret;
-	int write_timeout;
 	u8 b2[6];
 
 	if (len < 1 || len > 4)
@@ -74,14 +75,14 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		return (ret < 0) ? ret : -EIO;
 	}
 	/* wait for completion */
-	for (write_timeout = EM2800_I2C_XFER_TIMEOUT; write_timeout > 0;
-	     write_timeout -= 5) {
+	while (time_is_after_jiffies(timeout)) {
 		ret = dev->em28xx_read_reg(dev, 0x05);
-		if (ret == 0x80 + len - 1) {
+		if (ret == 0x80 + len - 1)
 			return len;
-		} else if (ret == 0x94 + len - 1) {
+		if (ret == 0x94 + len - 1) {
 			return -ENODEV;
-		} else if (ret < 0) {
+		}
+		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
@@ -98,9 +99,9 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
  */
 static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
 	u8 buf2[4];
 	int ret;
-	int read_timeout;
 	int i;
 
 	if (len < 1 || len > 4)
@@ -117,14 +118,14 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	}
 
 	/* wait for completion */
-	for (read_timeout = EM2800_I2C_XFER_TIMEOUT; read_timeout > 0;
-	     read_timeout -= 5) {
+	while (time_is_after_jiffies(timeout)) {
 		ret = dev->em28xx_read_reg(dev, 0x05);
-		if (ret == 0x84 + len - 1) {
+		if (ret == 0x84 + len - 1)
 			break;
-		} else if (ret == 0x94 + len - 1) {
+		if (ret == 0x94 + len - 1) {
 			return -ENODEV;
-		} else if (ret < 0) {
+		}
+		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
@@ -168,7 +169,8 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 u16 len, int stop)
 {
-	int write_timeout, ret;
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
+	int ret;
 
 	if (len < 1 || len > 64)
 		return -EOPNOTSUPP;
@@ -191,16 +193,16 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		}
 	}
 
-	/* Check success of the i2c operation */
-	for (write_timeout = EM2800_I2C_XFER_TIMEOUT; write_timeout > 0;
-	     write_timeout -= 5) {
+	/* wait for completion */
+	while (time_is_after_jiffies(timeout)) {
 		ret = dev->em28xx_read_reg(dev, 0x05);
-		if (ret == 0) { /* success */
+		if (ret == 0) /* success */
 			return len;
-		} else if (ret == 0x10) {
+		if (ret == 0x10) {
 			return -ENODEV;
-		} else if (ret < 0) {
-			em28xx_warn("failed to read i2c transfer status from bridge (error=%i)\n",
+		}
+		if (ret < 0) {
+			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
 		}
@@ -211,6 +213,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		 * (even with high payload) ...
 		 */
 	}
+
 	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
 	return -EIO;
 }
@@ -248,20 +251,18 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 
 	/* Check success of the i2c operation */
 	ret = dev->em28xx_read_reg(dev, 0x05);
+	if (ret == 0) /* success */
+		return len;
 	if (ret < 0) {
-		em28xx_warn("failed to read i2c transfer status from bridge (error=%i)\n",
+		em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 			    ret);
 		return ret;
 	}
-	if (ret > 0) {
-		if (ret == 0x10) {
-			return -ENODEV;
-		} else {
-			em28xx_warn("unknown i2c error (status=%i)\n", ret);
-			return -EIO;
-		}
-	}
-	return len;
+	if (ret == 0x10)
+		return -ENODEV;
+
+	em28xx_warn("unknown i2c error (status=%i)\n", ret);
+	return -EIO;
 }
 
 /*
-- 
1.8.3.1

