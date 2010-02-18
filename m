Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:47933 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553Ab0BRVLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 16:11:48 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 07/11] tm6000: add i2c send recv functions
Date: Thu, 18 Feb 2010 22:11:03 +0100
Message-Id: <1266527463-32477-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 6b17d0b..9d02674 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -42,6 +42,32 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 			printk(KERN_DEBUG "%s at %s: " fmt, \
 			dev->name, __FUNCTION__ , ##args); } while (0)
 
+int tm6000_i2c_send_byte (struct tm6000_core *dev, unsigned char addr, __u8 reg, char *buf, int len)
+{
+	return tm6000_read_write_usb (dev, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+}
+
+int tm6000_i2c_recv_byte (struct tm6000_core *dev, unsigned char addr, __u8 reg, char *buf, int len)
+{
+	int rc:
+
+	rc = tm6000_read_write_usb (dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+
+	return rc;
+}
+
+int tm6000_i2c_recv_word (struct tm6000_core *dev, unsigned char addr, __u16 reg, char *buf , int len)
+{
+	int rc;
+
+	rc = tm6000_read_write_usb (dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
+
+	return rc;
+}
+
 static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			   struct i2c_msg msgs[], int num)
 {
@@ -76,13 +102,14 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			i2c_dprintk(2, "; joined to read %s len=%d:",
 				    i == num - 2 ? "stop" : "nonstop",
 				    msgs[i + 1].len);
-			rc = tm6000_read_write_usb (dev,
-				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				msgs[i].len == 1 ? REQ_16_SET_GET_I2C_WR1_RDN
-						 : REQ_14_SET_GET_I2C_WR2_RDN,
-				addr | msgs[i].buf[0] << 8,
-				msgs[i].len == 1 ? 0 : msgs[i].buf[1],
-				msgs[i + 1].buf, msgs[i + 1].len);
+
+			if (msgs[i].len == 1) {
+				rc = tm6000_i2c_recv_byte (dev, addr, msgs[i].buf[0],
+					msgs[i + 1].buf, msgs[i + 1].len);
+			} else {
+				rc = tm6000_i2c_recv_word (dev, addr, msgs[i].buf[0] << 8 | msgs[i].buf[1],
+					msgs[i + 1].buf, msgs[i + 1].len);
+			}
 			i++;
 
 			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
@@ -97,10 +124,8 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
 					printk(" %02x", msgs[i].buf[byte]);
-			rc = tm6000_read_write_usb(dev,
-				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				REQ_16_SET_GET_I2C_WR1_RDN,
-				addr | msgs[i].buf[0] << 8, 0,
+
+			rc = tm6000_i2c_send_byte(dev, addr, msgs[i].buf[0],
 				msgs[i].buf + 1, msgs[i].len - 1);
 
 			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
-- 
1.6.6.1

