Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaAJLhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 06:37:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 1/3] [media] em28xx-i2c: Fix error code for I2C error transfers
Date: Fri, 10 Jan 2014 06:33:38 -0200
Message-Id: <1389342820-12605-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389342820-12605-1-git-send-email-m.chehab@samsung.com>
References: <1389342820-12605-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Follow the error codes for I2C as described at Documentation/i2c/fault-codes.

In the case of the I2C status register (0x05), this is mapped into:

	- ENXIO - when reg 05 returns 0x10
	- ETIMEDOUT - when the device is not temporarily not responding
		      (e. g. reg 05 returning something not 0x10 or 0x00)
	- EIO - for generic I/O errors that don't fit into the above.

In the specific case of 0-byte reads, used only during I2C device
probing, it keeps returning -ENODEV.

TODO: return EBUSY when reg 05 returns 0x20 on em2874 and upper.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 37 +++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 342f35ad6070..76f956635bd9 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -80,7 +80,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x80 + len - 1)
 			return len;
 		if (ret == 0x94 + len - 1) {
-			return -ENODEV;
+			return -ENXIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -90,7 +90,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		msleep(5);
 	}
 	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
-	return -EIO;
+	return -ETIMEDOUT;
 }
 
 /*
@@ -123,7 +123,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x84 + len - 1)
 			break;
 		if (ret == 0x94 + len - 1) {
-			return -ENODEV;
+			return -ENXIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -199,7 +199,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		if (ret == 0) /* success */
 			return len;
 		if (ret == 0x10) {
-			return -ENODEV;
+			return -ENXIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -213,9 +213,8 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		 * (even with high payload) ...
 		 */
 	}
-
-	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
-	return -EIO;
+	em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n", addr, ret);
+	return -ETIMEDOUT;
 }
 
 /*
@@ -245,7 +244,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
-	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
+	 * Anyway, the next check will fail with -ENXIO in this case, so avoid
 	 * spamming the system log on device probing and do nothing here.
 	 */
 
@@ -259,10 +258,10 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 		return ret;
 	}
 	if (ret == 0x10)
-		return -ENODEV;
+		return -ENXIO;
 
 	em28xx_warn("unknown i2c error (status=%i)\n", ret);
-	return -EIO;
+	return -ETIMEDOUT;
 }
 
 /*
@@ -318,7 +317,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	if (!ret)
 		return len;
 	else if (ret > 0)
-		return -ENODEV;
+		return -ENXIO;
 
 	return ret;
 	/*
@@ -356,7 +355,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
-	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
+	 * Anyway, the next check will fail with -ENXIO in this case, so avoid
 	 * spamming the system log on device probing and do nothing here.
 	 */
 
@@ -369,7 +368,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	if (!ret)
 		return len;
 	else if (ret > 0)
-		return -ENODEV;
+		return -ENXIO;
 
 	return ret;
 	/*
@@ -410,7 +409,7 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
 		rc = em2800_i2c_check_for_device(dev, addr);
 	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
 		rc = em25xx_bus_B_check_for_device(dev, addr);
-	if (rc == -ENODEV) {
+	if (rc == -ENXIO) {
 		if (i2c_debug)
 			printk(" no device\n");
 	}
@@ -498,11 +497,15 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
 			       i == num - 1 ? "stop" : "nonstop",
 			       addr, msgs[i].len);
-		if (!msgs[i].len) { /* no len: check only for device presence */
+		if (!msgs[i].len) {
+			/*
+			 * no len: check only for device presence
+			 * This code is only called during device probe.
+			 */
 			rc = i2c_check_for_device(i2c_bus, addr);
-			if (rc == -ENODEV) {
+			if (rc == -ENXIO) {
 				rt_mutex_unlock(&dev->i2c_bus_lock);
-				return rc;
+				return -ENODEV;
 			}
 		} else if (msgs[i].flags & I2C_M_RD) {
 			/* read bytes */
-- 
1.8.3.1

