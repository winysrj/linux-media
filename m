Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43681 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab3LWLMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 06:12:38 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Cc: zzam@gentoo.org
Subject: [PATCH v2] cx231xx: fix i2c debug prints
Date: Mon, 23 Dec 2013 12:12:21 +0100
Message-Id: <1387797141-15991-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not shift the already 7bit i2c address.
Print a message also for write+read transactions.
For write+read, print the read buffer correctly instead of using the write
buffer.
Fix continuation lines

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 96a5a09..7c0f797 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -371,9 +371,9 @@ static int cx231xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	mutex_lock(&dev->i2c_lock);
 	for (i = 0; i < num; i++) {
 
-		addr = msgs[i].addr >> 1;
+		addr = msgs[i].addr;
 
-		dprintk2(2, "%s %s addr=%x len=%d:",
+		dprintk2(2, "%s %s addr=0x%x len=%d:",
 			 (msgs[i].flags & I2C_M_RD) ? "read" : "write",
 			 i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
 		if (!msgs[i].len) {
@@ -390,32 +390,41 @@ static int cx231xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			rc = cx231xx_i2c_recv_bytes(i2c_adap, &msgs[i]);
 			if (i2c_debug >= 2) {
 				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
+					printk(KERN_CONT " %02x", msgs[i].buf[byte]);
 			}
 		} else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
 			   msgs[i].addr == msgs[i + 1].addr
 			   && (msgs[i].len <= 2) && (bus->nr < 3)) {
+			/* write bytes */
+			if (i2c_debug >= 2) {
+				for (byte = 0; byte < msgs[i].len; byte++)
+					printk(KERN_CONT " %02x", msgs[i].buf[byte]);
+				printk(KERN_CONT "\n");
+			}
 			/* read bytes */
+			dprintk2(2, "plus %s %s addr=0x%x len=%d:",
+				(msgs[i+1].flags & I2C_M_RD) ? "read" : "write",
+				i+1 == num - 1 ? "stop" : "nonstop", addr, msgs[i+1].len);
 			rc = cx231xx_i2c_recv_bytes_with_saddr(i2c_adap,
 							       &msgs[i],
 							       &msgs[i + 1]);
 			if (i2c_debug >= 2) {
-				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
+				for (byte = 0; byte < msgs[i+1].len; byte++)
+					printk(KERN_CONT " %02x", msgs[i+1].buf[byte]);
 			}
 			i++;
 		} else {
 			/* write bytes */
 			if (i2c_debug >= 2) {
 				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
+					printk(KERN_CONT " %02x", msgs[i].buf[byte]);
 			}
 			rc = cx231xx_i2c_send_bytes(i2c_adap, &msgs[i]);
 		}
 		if (rc < 0)
 			goto err;
 		if (i2c_debug >= 2)
-			printk("\n");
+			printk(KERN_CONT "\n");
 	}
 	mutex_unlock(&dev->i2c_lock);
 	return num;
-- 
1.8.4.4

