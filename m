Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51344 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbaAFQI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 11:08:28 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/6] em28xx: add timeout debug information if i2c_debug enabled
Date: Mon,  6 Jan 2014 11:05:00 -0200
Message-Id: <1389013500-3110-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
References: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If i2c_debug is enabled, we splicitly want to know when a
device fails with timeout.

If i2c_debug==2, this is already provided, for each I2C transfer
that fails.

However, most of the time, we don't need to go that far. We just
want to know that I2C transfers fail.

So, add such errors for normal (ret == 0x10) I2C aborted timeouts.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 2410ed09e877..d50334ca8175 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -80,6 +80,9 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x80 + len - 1)
 			return len;
 		if (ret == 0x94 + len - 1) {
+			if (i2c_debug == 1)
+				em28xx_warn("R05 returned 0x%02x: I2C timeout",
+					    ret);
 			return -ETIMEDOUT;
 		}
 		if (ret < 0) {
@@ -124,6 +127,9 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x84 + len - 1)
 			break;
 		if (ret == 0x94 + len - 1) {
+			if (i2c_debug == 1)
+				em28xx_warn("R05 returned 0x%02x: I2C timeout",
+					    ret);
 			return -ETIMEDOUT;
 		}
 		if (ret < 0) {
@@ -203,6 +209,9 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		if (ret == 0) /* success */
 			return len;
 		if (ret == 0x10) {
+			if (i2c_debug == 1)
+				em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+					    addr);
 			return -ETIMEDOUT;
 		}
 		if (ret < 0) {
@@ -263,8 +272,12 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 			    ret);
 		return ret;
 	}
-	if (ret == 0x10)
+	if (ret == 0x10) {
+		if (i2c_debug == 1)
+			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+				    addr);
 		return -ETIMEDOUT;
+	}
 
 	em28xx_warn("unknown i2c error (status=%i)\n", ret);
 	return -ENXIO;
@@ -322,8 +335,12 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 */
 	if (!ret)
 		return len;
-	else if (ret > 0)
+	else if (ret > 0) {
+		if (i2c_debug == 1)
+			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
+				    ret);
 		return -ETIMEDOUT;
+	}
 
 	return ret;
 	/*
@@ -373,8 +390,12 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 */
 	if (!ret)
 		return len;
-	else if (ret > 0)
+	else if (ret > 0) {
+		if (i2c_debug == 1)
+			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
+				    ret);
 		return -ETIMEDOUT;
+	}
 
 	return ret;
 	/*
-- 
1.8.3.1

