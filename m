Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaADN7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 08:59:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 18/22] [media] em28xx: don't return -ENODEV for I2C xfer errors
Date: Sat,  4 Jan 2014 08:55:47 -0200
Message-Id: <1388832951-11195-19-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-ENODEV reports a permanent condition where a device is not found,
and used only during device probing or device removal, as stated
at  the V4L2 spec:
	http://linuxtv.org/downloads/v4l-dvb-apis/gen_errors.html

Except during device detection, this is not the case of I2C
transfer timeout errors.

So, change them to return -EREMOTEIO instead.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 8b35aa51b9bb..c3ba8ace5c94 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -81,7 +81,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			return len;
 		if (ret == 0x94 + len - 1) {
 			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
-			return -ENODEV;
+			return -EREMOTEIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -125,7 +125,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			break;
 		if (ret == 0x94 + len - 1) {
 			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
-			return -ENODEV;
+			return -EREMOTEIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -203,7 +203,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		if (ret == 0x10) {
 			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
 				    addr);
-			return -ENODEV;
+			return -EREMOTEIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -249,7 +249,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
-	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
+	 * Anyway, the next check will fail with -EREMOTEIO in this case, so avoid
 	 * spamming the system log on device probing and do nothing here.
 	 */
 
@@ -264,7 +264,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	}
 	if (ret == 0x10) {
 		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
-		return -ENODEV;
+		return -EREMOTEIO;
 	}
 
 	em28xx_warn("unknown i2c error (status=%i)\n", ret);
@@ -325,7 +325,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
-		return -ENODEV;
+		return -EREMOTEIO;
 	}
 
 	return ret;
@@ -364,8 +364,6 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
-	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
-	 * spamming the system log on device probing and do nothing here.
 	 */
 
 	/* Check success */
@@ -378,7 +376,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
-		return -ENODEV;
+		return -EREMOTEIO;
 	}
 
 	return ret;
@@ -420,7 +418,7 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
 		rc = em2800_i2c_check_for_device(dev, addr);
 	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
 		rc = em25xx_bus_B_check_for_device(dev, addr);
-	if (rc == -ENODEV) {
+	if (rc < 0) {
 		if (i2c_debug)
 			printk(" no device\n");
 	}
@@ -510,7 +508,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			       addr, msgs[i].len);
 		if (!msgs[i].len) { /* no len: check only for device presence */
 			rc = i2c_check_for_device(i2c_bus, addr);
-			if (rc == -ENODEV) {
+			if (rc < 0) {
 				rt_mutex_unlock(&dev->i2c_bus_lock);
 				return rc;
 			}
-- 
1.8.3.1

