Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54525 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752411AbeCCUv0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/11] media: em28xx-i2c: fix most coding style issues
Date: Sat,  3 Mar 2018 17:51:10 -0300
Message-Id: <3fdaa4bd3ca34cc1d99f58198c270001b7538f70.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of coding style issues at em28xx-i2c.
Fix most of them, by using checkpatch in strict mode to point
for it.

Automatic fixes were made with --fix-inplace, but those
were complemented by manual work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 90 +++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 677f08b3b51d..52d711338701 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -18,7 +18,6 @@
 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 // GNU General Public License for more details.
 
-
 #include "em28xx.h"
 
 #include <linux/module.h>
@@ -47,7 +46,6 @@ MODULE_PARM_DESC(i2c_debug, "i2c debug message level (1: normal debug, 2: show I
 			   "i2c: %s: " fmt, __func__, ## arg);		\
 } while (0)
 
-
 /*
  * Time in msecs to wait for i2c xfers to finish.
  * 35ms is the maximum time a SMBUS device could wait when
@@ -91,7 +89,6 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	if (len < 1 || len > 4)
 		return -EOPNOTSUPP;
 
-	BUG_ON(len < 1 || len > 4);
 	b2[5] = 0x80 + len - 1;
 	b2[4] = addr;
 	b2[3] = buf[0];
@@ -125,7 +122,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 				ret);
 			return ret;
 		}
-		msleep(5);
+		usleep_range(5000, 6000);
 	}
 	dprintk(0, "write to i2c device at 0x%x timed out\n", addr);
 	return -ETIMEDOUT;
@@ -172,14 +169,13 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 				 ret);
 			return ret;
 		}
-		msleep(5);
+		usleep_range(5000, 6000);
 	}
-	if (ret != 0x84 + len - 1) {
+	if (ret != 0x84 + len - 1)
 		dprintk(0, "read from i2c device at 0x%x timed out\n", addr);
-	}
 
 	/* get the received message */
-	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
+	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4 - len, buf2, len);
 	if (ret != len) {
 		dev_warn(&dev->intf->dev,
 			 "reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
@@ -231,12 +227,11 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 "writing to i2c device at 0x%x failed (error=%i)\n",
 				 addr, ret);
 			return ret;
-		} else {
-			dev_warn(&dev->intf->dev,
-				 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
-				 len, addr, ret);
-			return -EIO;
 		}
+		dev_warn(&dev->intf->dev,
+			 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
+				len, addr, ret);
+		return -EIO;
 	}
 
 	/* wait for completion */
@@ -255,7 +250,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 ret);
 			return ret;
 		}
-		msleep(5);
+		usleep_range(5000, 6000);
 		/*
 		 * NOTE: do we really have to wait for success ?
 		 * Never seen anything else than 0x00 or 0x10
@@ -378,12 +373,12 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 "writing to i2c device at 0x%x failed (error=%i)\n",
 				 addr, ret);
 			return ret;
-		} else {
-			dev_warn(&dev->intf->dev,
-				 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
-				 len, addr, ret);
-			return -EIO;
 		}
+
+		dev_warn(&dev->intf->dev,
+			 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
+			 len, addr, ret);
+		return -EIO;
 	}
 	/* Check success */
 	ret = dev->em28xx_read_reg_req(dev, 0x08, 0x0000);
@@ -393,7 +388,8 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 */
 	if (!ret)
 		return len;
-	else if (ret > 0) {
+
+	if (ret > 0) {
 		dprintk(1, "Bus B R08 returned 0x%02x: I2C ACK error\n", ret);
 		return -ENXIO;
 	}
@@ -447,7 +443,8 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 */
 	if (!ret)
 		return len;
-	else if (ret > 0) {
+
+	if (ret > 0) {
 		dprintk(1, "Bus B R08 returned 0x%02x: I2C ACK error\n", ret);
 		return -ENXIO;
 	}
@@ -535,13 +532,15 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 {
 	struct em28xx_i2c_bus *i2c_bus = i2c_adap->algo_data;
 	struct em28xx *dev = i2c_bus->dev;
-	unsigned bus = i2c_bus->bus;
+	unsigned int bus = i2c_bus->bus;
 	int addr, rc, i;
 	u8 reg;
 
-	/* prevent i2c xfer attempts after device is disconnected
-	   some fe's try to do i2c writes/reads from their release
-	   interfaces when called in disconnect path */
+	/*
+	 * prevent i2c xfer attempts after device is disconnected
+	 * some fe's try to do i2c writes/reads from their release
+	 * interfaces when called in disconnect path
+	 */
 	if (dev->disconnected)
 		return -ENODEV;
 
@@ -624,12 +623,13 @@ static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
 		if (len == length) {
 			c = (char)len;
 			len = -1;
-		} else
+		} else {
 			c = *buf++;
+		}
 		l = (l << 8) | c;
 		len++;
 		if ((len & (32 / 8 - 1)) == 0)
-			hash = ((hash^l) * 0x9e370001UL);
+			hash = ((hash ^ l) * 0x9e370001UL);
 	} while (len);
 
 	return (hash >> (32 - bits)) & 0xffffffffUL;
@@ -639,7 +639,7 @@ static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
  * Helper function to read data blocks from i2c clients with 8 or 16 bit
  * address width, 8 bit register width and auto incrementation been activated
  */
-static int em28xx_i2c_read_block(struct em28xx *dev, unsigned bus, u16 addr,
+static int em28xx_i2c_read_block(struct em28xx *dev, unsigned int bus, u16 addr,
 				 bool addr_w16, u16 len, u8 *data)
 {
 	int remain = len, rsize, rsize_max, ret;
@@ -651,7 +651,8 @@ static int em28xx_i2c_read_block(struct em28xx *dev, unsigned bus, u16 addr,
 	/* Select address */
 	buf[0] = addr >> 8;
 	buf[1] = addr & 0xff;
-	ret = i2c_master_send(&dev->i2c_client[bus], buf + !addr_w16, 1 + addr_w16);
+	ret = i2c_master_send(&dev->i2c_client[bus],
+			      buf + !addr_w16, 1 + addr_w16);
 	if (ret < 0)
 		return ret;
 	/* Read data */
@@ -676,7 +677,7 @@ static int em28xx_i2c_read_block(struct em28xx *dev, unsigned bus, u16 addr,
 	return len;
 }
 
-static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
+static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned int bus,
 			     u8 **eedata, u16 *eedata_len)
 {
 	const u16 len = 256;
@@ -704,7 +705,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 	}
 
 	data = kzalloc(len, GFP_KERNEL);
-	if (data == NULL)
+	if (!data)
 		return -ENOMEM;
 
 	/* Read EEPROM content */
@@ -796,7 +797,10 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 			return 0;
 		}
 
-		/* TODO: decrypt eeprom data for camera bridges (em25xx, em276x+) */
+		/*
+		 * TODO: decrypt eeprom data for camera bridges
+		 * (em25xx, em276x+)
+		 */
 
 	} else if (!dev->eeprom_addrwidth_16bit &&
 		   data[0] == 0x1a && data[1] == 0xeb &&
@@ -886,8 +890,8 @@ static u32 functionality(struct i2c_adapter *i2c_adap)
 {
 	struct em28xx_i2c_bus *i2c_bus = i2c_adap->algo_data;
 
-	if ((i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) ||
-	    (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)) {
+	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX ||
+	    i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
 		return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)  {
 		return (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL) &
@@ -920,7 +924,7 @@ static const struct i2c_client em28xx_client_template = {
  * incomplete list of known devices
  */
 static char *i2c_devs[128] = {
-       [0x1c >> 1] = "lgdt330x",
+	[0x1c >> 1] = "lgdt330x",
 	[0x3e >> 1] = "remote IR sensor",
 	[0x4a >> 1] = "saa7113h",
 	[0x52 >> 1] = "drxk",
@@ -943,7 +947,7 @@ static char *i2c_devs[128] = {
  * do_i2c_scan()
  * check i2c address range for devices
  */
-void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
+void em28xx_do_i2c_scan(struct em28xx *dev, unsigned int bus)
 {
 	u8 i2c_devicelist[128];
 	unsigned char buf;
@@ -971,13 +975,14 @@ void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
  * em28xx_i2c_register()
  * register i2c bus
  */
-int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
+int em28xx_i2c_register(struct em28xx *dev, unsigned int bus,
 			enum em28xx_i2c_algo_type algo_type)
 {
 	int retval;
 
-	BUG_ON(!dev->em28xx_write_regs || !dev->em28xx_read_reg);
-	BUG_ON(!dev->em28xx_write_regs_req || !dev->em28xx_read_reg_req);
+	if (WARN_ON(!dev->em28xx_write_regs || !dev->em28xx_read_reg ||
+		    !dev->em28xx_write_regs_req || !dev->em28xx_read_reg_req))
+		return -ENODEV;
 
 	if (bus >= NUM_I2C_BUSES)
 		return -ENODEV;
@@ -1004,8 +1009,9 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 
 	/* Up to now, all eeproms are at bus 0 */
 	if (!bus) {
-		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
-		if ((retval < 0) && (retval != -ENODEV)) {
+		retval = em28xx_i2c_eeprom(dev, bus,
+					   &dev->eedata, &dev->eedata_len);
+		if (retval < 0 && retval != -ENODEV) {
 			dev_err(&dev->intf->dev,
 				"%s: em28xx_i2_eeprom failed! retval [%d]\n",
 				__func__, retval);
@@ -1022,7 +1028,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
  * em28xx_i2c_unregister()
  * unregister i2c_bus
  */
-int em28xx_i2c_unregister(struct em28xx *dev, unsigned bus)
+int em28xx_i2c_unregister(struct em28xx *dev, unsigned int bus)
 {
 	if (bus >= NUM_I2C_BUSES)
 		return -ENODEV;
-- 
2.14.3
