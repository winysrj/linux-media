Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:18111 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab0JMMXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 08:23:05 -0400
Date: Wed, 13 Oct 2010 14:22:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] i2c: Stop using I2C_CLASS_TV_ANALOG
Message-ID: <20101013142254.4581b58b@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Detection class I2C_CLASS_TV_ANALOG is set by a few adapters but no
I2C device driver is setting it anymore, which means it can be
dropped. I2C devices on analog TV adapters are instantiated
explicitly these days, which is much better.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/media/dvb/ngene/ngene-i2c.c   |    2 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c |    1 -
 drivers/media/video/hexium_gemini.c   |    1 -
 drivers/media/video/hexium_orion.c    |    1 -
 4 files changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.36-rc7.orig/drivers/media/dvb/ngene/ngene-i2c.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/ngene/ngene-i2c.c	2010-10-13 12:36:50.000000000 +0200
@@ -165,7 +165,7 @@ int ngene_i2c_init(struct ngene *dev, in
 	struct i2c_adapter *adap = &(dev->channel[dev_nr].i2c_adapter);
 
 	i2c_set_adapdata(adap, &(dev->channel[dev_nr]));
-	adap->class = I2C_CLASS_TV_DIGITAL | I2C_CLASS_TV_ANALOG;
+	adap->class = I2C_CLASS_TV_DIGITAL;
 
 	strcpy(adap->name, "nGene");
 
--- linux-2.6.36-rc7.orig/drivers/media/video/hdpvr/hdpvr-i2c.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/video/hdpvr/hdpvr-i2c.c	2010-10-13 12:36:50.000000000 +0200
@@ -127,7 +127,6 @@ int hdpvr_register_i2c_adapter(struct hd
 	strlcpy(i2c_adap->name, "Hauppauge HD PVR I2C",
 		sizeof(i2c_adap->name));
 	i2c_adap->algo  = &hdpvr_algo;
-	i2c_adap->class = I2C_CLASS_TV_ANALOG;
 	i2c_adap->owner = THIS_MODULE;
 	i2c_adap->dev.parent = &dev->udev->dev;
 
--- linux-2.6.36-rc7.orig/drivers/media/video/hexium_gemini.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/video/hexium_gemini.c	2010-10-13 12:36:50.000000000 +0200
@@ -367,7 +367,6 @@ static int hexium_attach(struct saa7146_
 	saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
 
 	hexium->i2c_adapter = (struct i2c_adapter) {
-		.class = I2C_CLASS_TV_ANALOG,
 		.name = "hexium gemini",
 	};
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
--- linux-2.6.36-rc7.orig/drivers/media/video/hexium_orion.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/video/hexium_orion.c	2010-10-13 12:36:50.000000000 +0200
@@ -230,7 +230,6 @@ static int hexium_probe(struct saa7146_d
 	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
 
 	hexium->i2c_adapter = (struct i2c_adapter) {
-		.class = I2C_CLASS_TV_ANALOG,
 		.name = "hexium orion",
 	};
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);


-- 
Jean Delvare
