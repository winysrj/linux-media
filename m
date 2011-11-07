Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:14399 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1KGJY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 04:24:57 -0500
Date: Mon, 7 Nov 2011 10:24:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH] [media] usbvision: Drop broken 10-bit I2C address support
Message-ID: <20111107102449.485da579@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The support for 10-bit I2C addresses in usbvision seems plain broken
to me. I had already noticed that back in February 2007 [1]. The code
was not fixed since then, so I take it that it's not actually needed.
And as a matter of fact I don't know of any 10-bit addressed I2C
tuner, encode, decoder or the like.

So let's simply get rid of the broken and useless code.

I'm also adding I2C_FUNC_I2C, as the driver and hardware support plain
I2C messaging.

[1] http://marc.info/?l=linux-i2c&m=117499415208244&w=2

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/media/video/usbvision/usbvision-i2c.c |   46 ++++++-------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

--- linux-3.2-rc0.orig/drivers/media/video/usbvision/usbvision-i2c.c	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc0/drivers/media/video/usbvision/usbvision-i2c.c	2011-11-07 09:54:14.000000000 +0100
@@ -110,42 +110,20 @@ static inline int usb_find_address(struc
 
 	unsigned char addr;
 	int ret;
-	if ((flags & I2C_M_TEN)) {
-		/* a ten bit address */
-		addr = 0xf0 | ((msg->addr >> 7) & 0x03);
-		/* try extended address code... */
-		ret = try_write_address(i2c_adap, addr, retries);
-		if (ret != 1) {
-			dev_err(&i2c_adap->dev,
-				"died at extended address code,	while writing\n");
-			return -EREMOTEIO;
-		}
-		add[0] = addr;
-		if (flags & I2C_M_RD) {
-			/* okay, now switch into reading mode */
-			addr |= 0x01;
-			ret = try_read_address(i2c_adap, addr, retries);
-			if (ret != 1) {
-				dev_err(&i2c_adap->dev,
-					"died at extended address code, while reading\n");
-				return -EREMOTEIO;
-			}
-		}
 
-	} else {		/* normal 7bit address  */
-		addr = (msg->addr << 1);
-		if (flags & I2C_M_RD)
-			addr |= 1;
+	addr = (msg->addr << 1);
+	if (flags & I2C_M_RD)
+		addr |= 1;
 
-		add[0] = addr;
-		if (flags & I2C_M_RD)
-			ret = try_read_address(i2c_adap, addr, retries);
-		else
-			ret = try_write_address(i2c_adap, addr, retries);
+	add[0] = addr;
+	if (flags & I2C_M_RD)
+		ret = try_read_address(i2c_adap, addr, retries);
+	else
+		ret = try_write_address(i2c_adap, addr, retries);
+
+	if (ret != 1)
+		return -EREMOTEIO;
 
-		if (ret != 1)
-			return -EREMOTEIO;
-	}
 	return 0;
 }
 
@@ -184,7 +162,7 @@ usbvision_i2c_xfer(struct i2c_adapter *i
 
 static u32 functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 /* -----exported algorithm data: -------------------------------------	*/


-- 
Jean Delvare
