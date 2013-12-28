Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3L1MQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 13/24] em28xx: retry I2C ops if failed by timeout
Date: Sat, 28 Dec 2013 10:16:05 -0200
Message-Id: <1388232976-20061-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

At least on HVR-950, sometimes an I2C operation fails.

This seems to be more frequent when the device is connected
into an USB 3.0 port.

Instead of report an error, try to repeat it, for up to
20 ms. That makes the code more reliable.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 67 ++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9fa7ed51e5b1..26f7b0a2e83a 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -181,6 +181,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 * Zero length reads always succeed, even if no device is connected
 	 */
 
+retry:
 	/* Write to i2c device */
 	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 	if (ret != len) {
@@ -200,11 +201,8 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		ret = dev->em28xx_read_reg(dev, 0x05);
 		if (ret == 0) /* success */
 			return len;
-		if (ret == 0x10) {
-			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
-				    addr);
-			return -ENODEV;
-		}
+		if (ret == 0x10)
+			goto retry;
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
@@ -218,6 +216,11 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		 */
 	}
 
+	if (ret == 0x10) {
+		em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+			    addr);
+		return -ENODEV;
+	}
 	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
 	return -EIO;
 }
@@ -228,6 +231,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
  */
 static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
 	int ret;
 
 	if (len < 1 || len > 64)
@@ -237,30 +241,35 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	 * Zero length reads always succeed, even if no device is connected
 	 */
 
-	/* Read data from i2c device */
-	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
-	if (ret < 0) {
-		em28xx_warn("reading from i2c device at 0x%x failed (error=%i)\n",
-			    addr, ret);
-		return ret;
-	}
-	/*
-	 * NOTE: some devices with two i2c busses have the bad habit to return 0
-	 * bytes if we are on bus B AND there was no write attempt to the
-	 * specified slave address before AND no device is present at the
-	 * requested slave address.
-	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
-	 * spamming the system log on device probing and do nothing here.
-	 */
-
-	/* Check success of the i2c operation */
-	ret = dev->em28xx_read_reg(dev, 0x05);
-	if (ret == 0) /* success */
-		return len;
-	if (ret < 0) {
-		em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-			    ret);
-		return ret;
+	while (time_is_after_jiffies(timeout)) {
+		/* Read data from i2c device */
+		ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
+		if (ret < 0) {
+			em28xx_warn("reading from i2c device at 0x%x failed (error=%i)\n",
+				    addr, ret);
+			return ret;
+		}
+		/*
+		 * NOTE: some devices with two i2c busses have the bad habit to return 0
+		* bytes if we are on bus B AND there was no write attempt to the
+		* specified slave address before AND no device is present at the
+		* requested slave address.
+		* Anyway, the next check will fail with -ENODEV in this case, so avoid
+		* spamming the system log on device probing and do nothing here.
+		*/
+
+		/* Check success of the i2c operation */
+		ret = dev->em28xx_read_reg(dev, 0x05);
+		if (ret == 0) /* success */
+			return len;
+		if (ret < 0) {
+			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+				    ret);
+			return ret;
+		}
+		if (ret != 0x10)
+			break;
+		msleep(5);
 	}
 	if (ret == 0x10) {
 		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
-- 
1.8.3.1

