Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44196 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaADR0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:26:12 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 RFC 1/2] [media] em28xx: retry I2C write ops if failed by timeout
Date: Sat,  4 Jan 2014 09:09:19 -0200
Message-Id: <1388833760-23260-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At least on HVR-950, sometimes an I2C operation fails.

This seems to be more frequent when the device is connected
into an USB 3.0 port.

Instead of report an error, try to repeat it, for up to
20 ms. That makes the code more reliable.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 6cd3d909bb3a..35d6808aa9ff 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -189,6 +189,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 * Zero length reads always succeed, even if no device is connected
 	 */
 
+retry:
 	/* Write to i2c device */
 	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 	if (ret != len) {
@@ -208,26 +209,24 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		ret = dev->em28xx_read_reg(dev, 0x05);
 		if (ret == 0) /* success */
 			return len;
-		if (ret == 0x10) {
-			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
-				    addr);
-			return -EREMOTEIO;
-		}
+		if (ret == 0x10)
+			goto retry;
 		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
 		}
 		msleep(5);
-		/*
-		 * NOTE: do we really have to wait for success ?
-		 * Never seen anything else than 0x00 or 0x10
-		 * (even with high payload) ...
-		 */
 	}
 
-	if (i2c_debug)
-		em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
+	if (ret == 0x10) {
+		if (i2c_debug)
+			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+				    addr);
+	} else {
+		em28xx_warn("write to i2c device at 0x%x timed out (ret=0x%02x)\n",
+			    addr, ret);
+	}
 	return -EREMOTEIO;
 }
 
-- 
1.8.3.1

