Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:11998 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0KGPyk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Nov 2010 10:54:40 -0500
Date: Sun, 7 Nov 2010 16:53:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michel Ludwig <michel.ludwig@gmail.com>,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/2] TM6000: Clean-up i2c initialization
Message-ID: <20101107165344.4243b602@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Usage of templates for large structures is a bad idea, as it wastes a
lot of space. Manually initializing the few fields we need is way more
efficient.

Also set the algorithm data const, use strlcpy instead of strcpy, fix
a small race (device data must always be set before registering said
device) and properly return error on adapter registration failure.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Michel Ludwig <michel.ludwig@gmail.com>
Cc: Stefan Ringel <stefan.ringel@arcor.de>
---
Untested, I don't have the hardware.

 drivers/staging/tm6000/tm6000-i2c.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- linux-2.6.36-rc7.orig/drivers/staging/tm6000/tm6000-i2c.c	2010-10-13 09:56:21.000000000 +0200
+++ linux-2.6.36-rc7/drivers/staging/tm6000/tm6000-i2c.c	2010-10-13 10:52:26.000000000 +0200
@@ -313,21 +313,11 @@ static u32 functionality(struct i2c_adap
 	msleep(10);							\
 	}
 
-static struct i2c_algorithm tm6000_algo = {
+static const struct i2c_algorithm tm6000_algo = {
 	.master_xfer   = tm6000_i2c_xfer,
 	.functionality = functionality,
 };
 
-static struct i2c_adapter tm6000_adap_template = {
-	.owner = THIS_MODULE,
-	.name = "tm6000",
-	.algo = &tm6000_algo,
-};
-
-static struct i2c_client tm6000_client_template = {
-	.name = "tm6000 internal",
-};
-
 /* ----------------------------------------------------------- */
 
 /*
@@ -337,17 +327,20 @@ static struct i2c_client tm6000_client_t
 int tm6000_i2c_register(struct tm6000_core *dev)
 {
 	unsigned char eedata[256];
+	int rc;
 
-	dev->i2c_adap = tm6000_adap_template;
+	dev->i2c_adap.owner = THIS_MODULE;
+	dev->i2c_adap.algo = &tm6000_algo;
 	dev->i2c_adap.dev.parent = &dev->udev->dev;
-	strcpy(dev->i2c_adap.name, dev->name);
+	strlcpy(dev->i2c_adap.name, dev->name, sizeof(dev->i2c_adap.name));
 	dev->i2c_adap.algo_data = dev;
-	i2c_add_adapter(&dev->i2c_adap);
+	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
+	rc = i2c_add_adapter(&dev->i2c_adap);
+	if (rc)
+		return rc;
 
-	dev->i2c_client = tm6000_client_template;
 	dev->i2c_client.adapter = &dev->i2c_adap;
-
-	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
+	strlcpy(dev->i2c_client.name, "tm6000 internal", I2C_NAME_SIZE);
 
 	tm6000_i2c_eeprom(dev, eedata, sizeof(eedata));
 


-- 
Jean Delvare
