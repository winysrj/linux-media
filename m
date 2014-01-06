Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaAFQI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 11:08:28 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/6] [media] em28xx: cleanup I2C debug messages
Date: Mon,  6 Jan 2014 11:04:59 -0200
Message-Id: <1389013500-3110-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
References: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C output messages is too polluted. Clean it a little
bit, by:
	- use the proper core support for memory dumps;
	- hide most stuff under the i2c_debug umbrella;
	- add the missing KERN_CONT where needed;
	- use 2 levels or verbosity. Only the second one
	  will show the I2C transfer data.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 84 ++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 40 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 8d14be06f088..2410ed09e877 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
 static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
-MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
+MODULE_PARM_DESC(i2c_debug, "i2c debug message level (1: normal debug, 2: show I2C transfers)");
 
 /*
  * em2800_i2c_send_bytes()
@@ -89,7 +89,8 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		}
 		msleep(5);
 	}
-	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
+	if (i2c_debug)
+		em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
 	return -ETIMEDOUT;
 }
 
@@ -132,8 +133,11 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		}
 		msleep(5);
 	}
-	if (ret != 0x84 + len - 1)
-		em28xx_warn("read from i2c device at 0x%x timed out\n", addr);
+	if (ret != 0x84 + len - 1) {
+		if (i2c_debug)
+			em28xx_warn("read from i2c device at 0x%x timed out\n",
+				    addr);
+	}
 
 	/* get the received message */
 	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
@@ -213,7 +217,9 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		 * (even with high payload) ...
 		 */
 	}
-	em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n", addr, ret);
+	if (i2c_debug)
+		em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
+			    addr, ret);
 	return -ENXIO;
 }
 
@@ -409,10 +415,6 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
 		rc = em2800_i2c_check_for_device(dev, addr);
 	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
 		rc = em25xx_bus_B_check_for_device(dev, addr);
-	if (rc == -ETIMEDOUT) {
-		if (i2c_debug)
-			printk(" timeout\n");
-	}
 	return rc;
 }
 
@@ -421,7 +423,7 @@ static inline int i2c_recv_bytes(struct em28xx_i2c_bus *i2c_bus,
 {
 	struct em28xx *dev = i2c_bus->dev;
 	u16 addr = msg.addr << 1;
-	int byte, rc = -EOPNOTSUPP;
+	int rc = -EOPNOTSUPP;
 
 	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
 		rc = em28xx_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
@@ -429,10 +431,6 @@ static inline int i2c_recv_bytes(struct em28xx_i2c_bus *i2c_bus,
 		rc = em2800_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
 	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
 		rc = em25xx_bus_B_recv_bytes(dev, addr, msg.buf, msg.len);
-	if (i2c_debug) {
-		for (byte = 0; byte < msg.len; byte++)
-			printk(" %02x", msg.buf[byte]);
-	}
 	return rc;
 }
 
@@ -441,12 +439,8 @@ static inline int i2c_send_bytes(struct em28xx_i2c_bus *i2c_bus,
 {
 	struct em28xx *dev = i2c_bus->dev;
 	u16 addr = msg.addr << 1;
-	int byte, rc = -EOPNOTSUPP;
+	int rc = -EOPNOTSUPP;
 
-	if (i2c_debug) {
-		for (byte = 0; byte < msg.len; byte++)
-			printk(" %02x", msg.buf[byte]);
-	}
 	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
 		rc = em28xx_i2c_send_bytes(dev, addr, msg.buf, msg.len, stop);
 	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)
@@ -491,7 +485,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	}
 	for (i = 0; i < num; i++) {
 		addr = msgs[i].addr << 1;
-		if (i2c_debug)
+		if (i2c_debug > 1)
 			printk(KERN_DEBUG "%s at %s: %s %s addr=%02x len=%d:",
 			       dev->name, __func__ ,
 			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
@@ -503,25 +497,41 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			 * This code is only called during device probe.
 			 */
 			rc = i2c_check_for_device(i2c_bus, addr);
-			if (rc == -ETIMEDOUT) {
+			if (rc < 0) {
+				if (rc == -ETIMEDOUT) {
+					if (i2c_debug > 1)
+						printk(KERN_CONT " no device\n");
+					rc = -ENODEV;
+				} else {
+					if (i2c_debug > 1)
+						printk(KERN_CONT " ERROR: %i\n", rc);
+				}
 				rt_mutex_unlock(&dev->i2c_bus_lock);
-				return -ENODEV;
+				return rc;
 			}
 		} else if (msgs[i].flags & I2C_M_RD) {
 			/* read bytes */
 			rc = i2c_recv_bytes(i2c_bus, msgs[i]);
+
+			if (i2c_debug > 1 && rc >= 0)
+				printk(KERN_CONT " %*ph",
+				       msgs[i].len, msgs[i].buf);
 		} else {
+			if (i2c_debug > 1)
+				printk(KERN_CONT " %*ph",
+				       msgs[i].len, msgs[i].buf);
+
 			/* write bytes */
 			rc = i2c_send_bytes(i2c_bus, msgs[i], i == num - 1);
 		}
 		if (rc < 0) {
-			if (i2c_debug)
-				printk(" ERROR: %i\n", rc);
+			if (i2c_debug > 1)
+				printk(KERN_CONT " ERROR: %i\n", rc);
 			rt_mutex_unlock(&dev->i2c_bus_lock);
 			return rc;
 		}
-		if (i2c_debug)
-			printk("\n");
+		if (i2c_debug > 1)
+			printk(KERN_CONT "\n");
 	}
 
 	rt_mutex_unlock(&dev->i2c_bus_lock);
@@ -604,7 +614,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 	 * calculation and returned device dataset. Simplifies the code a lot,
 	 * but we might have to deal with multiple sizes in the future !
 	 */
-	int i, err;
+	int err;
 	struct em28xx_eeprom *dev_config;
 	u8 buf, *data;
 
@@ -635,20 +645,14 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		goto error;
 	}
 
-	/* Display eeprom content */
-	for (i = 0; i < len; i++) {
-		if (0 == (i % 16)) {
-			if (dev->eeprom_addrwidth_16bit)
-				em28xx_info("i2c eeprom %04x:", i);
-			else
-				em28xx_info("i2c eeprom %02x:", i);
-		}
-		printk(" %02x", data[i]);
-		if (15 == (i % 16))
-			printk("\n");
+	if (i2c_debug) {
+		/* Display eeprom content */
+		print_hex_dump(KERN_INFO, "eeprom ", DUMP_PREFIX_OFFSET,
+			       16, 1, data, len, true);
+
+		if (dev->eeprom_addrwidth_16bit)
+			em28xx_info("eeprom %06x: ... (skipped)\n", 256);
 	}
-	if (dev->eeprom_addrwidth_16bit)
-		em28xx_info("i2c eeprom %04x: ... (skipped)\n", i);
 
 	if (dev->eeprom_addrwidth_16bit &&
 	    data[0] == 0x26 && data[3] == 0x00) {
-- 
1.8.3.1

