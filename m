Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:19845 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0DZAWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 20:22:30 -0400
Received: by ey-out-2122.google.com with SMTP id d26so1023331eyd.19
        for <linux-media@vger.kernel.org>; Sun, 25 Apr 2010 17:22:28 -0700 (PDT)
Date: Mon, 26 Apr 2010 10:25:14 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Bee Hock Goh <beehock@gmail.com>
Subject: Re: [PATCH] tm6000 fix i2c
Message-ID: <20100426102514.2c13761e@glory.loctelecom.ru>
In-Reply-To: <4BD1B985.8060703@arcor.de>
References: <20100423104804.784fb730@glory.loctelecom.ru>
 <4BD1B985.8060703@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/EfhKOJtgoAW_QcYnJ8kwPpy"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/EfhKOJtgoAW_QcYnJ8kwPpy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi 

Rework last I2C patch.
Set correct limit for I2C packet.
Use different method for the tm5600/tm6000 and tm6010 to read word.

Try this patch.

diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-i2c.c
--- a/linux/drivers/staging/tm6000/tm6000-i2c.c	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/staging/tm6000/tm6000-i2c.c	Mon Apr 26 04:15:56 2010 +1000
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
+#include <linux/delay.h>
 
 #include "compat.h"
 #include "tm6000.h"
@@ -45,11 +46,49 @@
 			printk(KERN_DEBUG "%s at %s: " fmt, \
 			dev->name, __FUNCTION__ , ##args); } while (0)
 
+static void tm6000_i2c_reset(struct tm6000_core *dev)
+{
+	tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 0);
+	msleep(15);
+	tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 1);
+	msleep(15);
+}
+
 static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 				__u8 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf, len);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 14000us for 64 bytes */
+	tsleep = ((len * 200) + 200 + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
 }
 
 /* Generic read - doesn't work fine with 16bit registers */
@@ -58,23 +97,41 @@
 {
 	int rc;
 	u8 b[2];
+	unsigned int i2c_packet_limit = 16;
 
-	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr) && (reg % 2 == 0)) {
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr)
+	&& (reg % 2 == 0)) {
 		/*
 		 * Workaround an I2C bug when reading from zl10353
 		 */
 		reg -= 1;
 		len += 1;
 
-		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, b, len);
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, b, len);
 
 		*buf = b[1];
 	} else {
-		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf, len);
 	}
 
+	/* release mutex */
 	return rc;
 }
 
@@ -85,8 +142,137 @@
 static int tm6000_i2c_recv_regs16(struct tm6000_core *dev, unsigned char addr,
 				  __u16 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
+	int rc;
+	unsigned char ureg;
+
+	if (!buf || len != 2)
+		return -1;
+
+	/* capture mutex */
+	if (dev->dev_type == TM6010){
+		ureg = reg & 0xFF;
+		rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+			addr | (reg & 0xFF00), 0, &ureg, 1);
+
+		if (rc < 0) {
+			/* release mutex */
+			return rc;
+		}
+
+		msleep(1400 / 1000);
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
+			reg, 0, buf, len);
+	}
+	else {
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_14_SET_GET_I2C_WR2_RDN,
+			addr, reg, buf, len);
+	}
+
+	/* release mutex */
+	return rc;
+}
+
+static int tm6000_i2c_read_sequence(struct tm6000_core *dev, unsigned char addr,
+				  __u16 reg, char *buf, int len)
+{
+	int rc;
+
+	if (dev->dev_type != TM6010)
+		return -1;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > 64){
+		printk("Incorrect lenght of i2c packet = %d, limit set to 64\n",
+			len);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
+		reg, 0, buf, len);
+	/* release mutex */
+	return rc;
+}
+
+static int tm6000_i2c_write_sequence(struct tm6000_core *dev,
+				unsigned char addr, __u16 reg, char *buf,
+				int len)
+{
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf+1, len-1);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 13800us for 64 bytes */
+	tsleep = ((len * 200) + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
+}
+
+static int tm6000_i2c_write_uni(struct tm6000_core *dev, unsigned char addr,
+				  __u16 reg, char *buf, int len)
+{
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_30_I2C_WRITE,
+		addr | reg << 8, 0, buf+1, len-1);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 14800us for 64 bytes */
+	tsleep = ((len * 200) + 1000 + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
 }
 
 static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,


With my best regards, Dmitry.
--MP_/EfhKOJtgoAW_QcYnJ8kwPpy
Content-Type: text/x-patch; name=tm6000_i2c.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_i2c.patch

diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-i2c.c
--- a/linux/drivers/staging/tm6000/tm6000-i2c.c	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/staging/tm6000/tm6000-i2c.c	Mon Apr 26 04:15:56 2010 +1000
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
+#include <linux/delay.h>
 
 #include "compat.h"
 #include "tm6000.h"
@@ -45,11 +46,49 @@
 			printk(KERN_DEBUG "%s at %s: " fmt, \
 			dev->name, __FUNCTION__ , ##args); } while (0)
 
+static void tm6000_i2c_reset(struct tm6000_core *dev)
+{
+	tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 0);
+	msleep(15);
+	tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 1);
+	msleep(15);
+}
+
 static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 				__u8 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf, len);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 14000us for 64 bytes */
+	tsleep = ((len * 200) + 200 + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
 }
 
 /* Generic read - doesn't work fine with 16bit registers */
@@ -58,23 +97,41 @@
 {
 	int rc;
 	u8 b[2];
+	unsigned int i2c_packet_limit = 16;
 
-	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr) && (reg % 2 == 0)) {
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr)
+	&& (reg % 2 == 0)) {
 		/*
 		 * Workaround an I2C bug when reading from zl10353
 		 */
 		reg -= 1;
 		len += 1;
 
-		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, b, len);
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, b, len);
 
 		*buf = b[1];
 	} else {
-		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf, len);
 	}
 
+	/* release mutex */
 	return rc;
 }
 
@@ -85,8 +142,137 @@
 static int tm6000_i2c_recv_regs16(struct tm6000_core *dev, unsigned char addr,
 				  __u16 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
+	int rc;
+	unsigned char ureg;
+
+	if (!buf || len != 2)
+		return -1;
+
+	/* capture mutex */
+	if (dev->dev_type == TM6010){
+		ureg = reg & 0xFF;
+		rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+			addr | (reg & 0xFF00), 0, &ureg, 1);
+
+		if (rc < 0) {
+			/* release mutex */
+			return rc;
+		}
+
+		msleep(1400 / 1000);
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
+			reg, 0, buf, len);
+	}
+	else {
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_14_SET_GET_I2C_WR2_RDN,
+			addr, reg, buf, len);
+	}
+
+	/* release mutex */
+	return rc;
+}
+
+static int tm6000_i2c_read_sequence(struct tm6000_core *dev, unsigned char addr,
+				  __u16 reg, char *buf, int len)
+{
+	int rc;
+
+	if (dev->dev_type != TM6010)
+		return -1;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > 64){
+		printk("Incorrect lenght of i2c packet = %d, limit set to 64\n",
+			len);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
+		reg, 0, buf, len);
+	/* release mutex */
+	return rc;
+}
+
+static int tm6000_i2c_write_sequence(struct tm6000_core *dev,
+				unsigned char addr, __u16 reg, char *buf,
+				int len)
+{
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf+1, len-1);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 13800us for 64 bytes */
+	tsleep = ((len * 200) + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
+}
+
+static int tm6000_i2c_write_uni(struct tm6000_core *dev, unsigned char addr,
+				  __u16 reg, char *buf, int len)
+{
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_30_I2C_WRITE,
+		addr | reg << 8, 0, buf+1, len-1);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 14800us for 64 bytes */
+	tsleep = ((len * 200) + 1000 + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
 }
 
 static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,

--MP_/EfhKOJtgoAW_QcYnJ8kwPpy--
