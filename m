Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaADN7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 08:59:18 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 22/22] [media] em28xx: retry read operation if it fails
Date: Sat,  4 Jan 2014 08:55:51 -0200
Message-Id: <1388832951-11195-23-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C read operations can also take some time to happen.

Try again, if it fails with return code different than 0x10
until timeout.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 62 +++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index e030e0b7d645..6cd3d909bb3a 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -237,6 +237,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
  */
 static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
 	int ret;
 
 	if (len < 1 || len > 64)
@@ -246,39 +247,44 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
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
-	 * Anyway, the next check will fail with -EREMOTEIO in this case, so avoid
-	 * spamming the system log on device probing and do nothing here.
-	 */
+	do {
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
+		* Anyway, the next check will fail with -EREMOTEIO in this case, so avoid
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
+	} while (time_is_after_jiffies(timeout));
 
-	/* Check success of the i2c operation */
-	ret = dev->em28xx_read_reg(dev, 0x05);
-	if (ret == 0) /* success */
-		return len;
-	if (ret < 0) {
-		em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-			    ret);
-		return ret;
-	}
 	if (ret == 0x10) {
 		if (i2c_debug)
-			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+			em28xx_warn("I2C transfer timeout on reading from addr 0x%02x",
 				    addr);
-		return -EREMOTEIO;
+	} else {
+		em28xx_warn("unknown i2c error (status=%i)\n", ret);
 	}
-
-	em28xx_warn("unknown i2c error (status=%i)\n", ret);
 	return -EREMOTEIO;
 }
 
-- 
1.8.3.1

