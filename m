Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:25469 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0KGPyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Nov 2010 10:54:46 -0500
Date: Sun, 7 Nov 2010 16:54:39 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michel Ludwig <michel.ludwig@gmail.com>,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/2] TM6000: Drop unused macro
Message-ID: <20101107165439.544bf200@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Michel Ludwig <michel.ludwig@gmail.com>
Cc: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-i2c.c |   12 ------------
 1 file changed, 12 deletions(-)

--- linux-2.6.36-rc7.orig/drivers/staging/tm6000/tm6000-i2c.c	2010-10-13 10:30:09.000000000 +0200
+++ linux-2.6.36-rc7/drivers/staging/tm6000/tm6000-i2c.c	2010-10-13 10:36:15.000000000 +0200
@@ -301,18 +301,6 @@ static u32 functionality(struct i2c_adap
 	return I2C_FUNC_SMBUS_EMUL;
 }
 
-#define mass_write(addr, reg, data...)					\
-	{ static const u8 _val[] = data;				\
-	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,	\
-	REQ_16_SET_GET_I2C_WR1_RDN, (reg<<8)+addr, 0x00, (u8 *) _val,	\
-	ARRAY_SIZE(_val));						\
-	if (rc < 0) {							\
-		printk(KERN_ERR "Error on line %d: %d\n", __LINE__, rc);	\
-		return rc;						\
-	}								\
-	msleep(10);							\
-	}
-
 static const struct i2c_algorithm tm6000_algo = {
 	.master_xfer   = tm6000_i2c_xfer,
 	.functionality = functionality,


-- 
Jean Delvare
