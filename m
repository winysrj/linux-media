Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3L1MQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 23/24] em28xx: don't return -ENODEV for I2C xfer errors
Date: Sat, 28 Dec 2013 10:16:15 -0200
Message-Id: <1388232976-20061-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

-ENODEV reports a permanent condition where a device is not found.
Except during device detection, this is not the case of I2C
transfer timeout errors.

So, change them to return -EIO instead.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 420fddf7da3a..16862c4cc745 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -81,7 +81,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			return len;
 		if (ret == 0x94 + len - 1) {
 			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
-			return -ENODEV;
+			return -EIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -125,7 +125,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			break;
 		if (ret == 0x94 + len - 1) {
 			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
-			return -ENODEV;
+			return -EIO;
 		}
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -214,7 +214,7 @@ retry:
 	if (ret == 0x10) {
 		em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
 			    addr);
-		return -ENODEV;
+		return -EIO;
 	}
 	em28xx_warn("write to i2c device at 0x%x timed out (ret=0x%02x)\n",
 		    addr, ret);
@@ -250,7 +250,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 		* bytes if we are on bus B AND there was no write attempt to the
 		* specified slave address before AND no device is present at the
 		* requested slave address.
-		* Anyway, the next check will fail with -ENODEV in this case, so avoid
+		* Anyway, the next check will fail with -EIO in this case, so avoid
 		* spamming the system log on device probing and do nothing here.
 		*/
 
@@ -270,7 +270,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 
 	if (ret == 0x10) {
 		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
-		return -ENODEV;
+		return -EIO;
 	}
 
 	em28xx_warn("unknown i2c error (status=%i)\n", ret);
@@ -331,7 +331,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
-		return -ENODEV;
+		return -EIO;
 	}
 
 	return ret;
@@ -370,8 +370,6 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
-	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
-	 * spamming the system log on device probing and do nothing here.
 	 */
 
 	/* Check success */
@@ -384,7 +382,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
-		return -ENODEV;
+		return -EIO;
 	}
 
 	return ret;
@@ -426,7 +424,7 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
 		rc = em2800_i2c_check_for_device(dev, addr);
 	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
 		rc = em25xx_bus_B_check_for_device(dev, addr);
-	if (rc == -ENODEV) {
+	if (rc < 0) {
 		if (i2c_debug)
 			printk(" no device\n");
 	}
@@ -516,7 +514,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
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

