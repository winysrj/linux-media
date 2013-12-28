Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab3L1MQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 10/24] em28xx: convert i2c wait completion logic to use jiffies
Date: Sat, 28 Dec 2013 10:16:02 -0200
Message-Id: <1388232976-20061-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

The I2C wait completion/timeout logic currently assumes that
msleep(5) will wait exaclty 5 ms. This is not true at all,
as it depends on CONFIG_HZ.

Convert it to use jiffies, in order to not wait for more time
than needed.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 65 ++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9e6a11d01858..9fa7ed51e5b1 100644
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
@@ -74,15 +75,15 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
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
 			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
 			return -ENODEV;
-		} else if (ret < 0) {
+		}
+		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
@@ -99,9 +100,9 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
  */
 static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
 	u8 buf2[4];
 	int ret;
-	int read_timeout;
 	int i;
 
 	if (len < 1 || len > 4)
@@ -118,15 +119,15 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
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
 			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
 			return -ENODEV;
-		} else if (ret < 0) {
+		}
+		if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
@@ -170,7 +171,8 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 u16 len, int stop)
 {
-	int write_timeout, ret;
+	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
+	int ret;
 
 	if (len < 1 || len > 64)
 		return -EOPNOTSUPP;
@@ -193,17 +195,18 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
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
-			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x", addr);
+		if (ret == 0x10) {
+			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+				    addr);
 			return -ENODEV;
-		} else if (ret < 0) {
-			em28xx_warn("failed to read i2c transfer status from bridge (error=%i)\n",
+		}
+		if (ret < 0) {
+			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
 		}
@@ -214,6 +217,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		 * (even with high payload) ...
 		 */
 	}
+
 	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
 	return -EIO;
 }
@@ -251,21 +255,20 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 
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
-			em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
-			return -ENODEV;
-		} else {
-			em28xx_warn("unknown i2c error (status=%i)\n", ret);
-			return -EIO;
-		}
+	if (ret == 0x10) {
+		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
+		return -ENODEV;
 	}
-	return len;
+
+	em28xx_warn("unknown i2c error (status=%i)\n", ret);
+	return -EIO;
 }
 
 /*
-- 
1.8.3.1

