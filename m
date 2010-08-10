Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60525 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525Ab0HJWBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 18:01:04 -0400
Received: by wyb32 with SMTP id 32so1167201wyb.19
        for <linux-media@vger.kernel.org>; Tue, 10 Aug 2010 15:01:02 -0700 (PDT)
Date: Tue, 10 Aug 2010 23:57:19 +0200
From: Davor Emard <davoremard@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Avermedia dvb-t hybrid A188
Message-ID: <20100810215718.GB27972@emard.lan>
References: <20100806114248.GA29247@emard.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806114248.GA29247@emard.lan>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

HI

This is my second attempt on Avermedia A188.
The hardware on this card is:

1x Philips SAA7160 pci-e bridge
2x NXP SAA7136 multistandard 10-bit A/V decoder
2x Afatech AF9013S demodulator
2x NXP TDA18271 silicon tuner ic (digital/analog)

I've written af9013 frontend attach code but I'm having
problems with loading firmware.

If someone can scan the card on window$ and see what the
driver does, are there some gpios that turn on the frontend
would be nice (maybe also extract correct firmware)

What I did
-----------
started from saa716x tree
hg clone http://www.jusst.de/hg/saa716x/
and added the af9013 frontend.

It compiles fine, loads af9013 module and requests
firmware but it won't load

Firmware was downloaded from http://www.otit.fi/~crope/v4l-dvb/af9015/dvb-fe-af9013.fw 
Also tried another firmware for af9015 usb sticks

In the code I made a loop to try i2c addresses from 0x00-0x7f
for af9013 but so far not found the correct one

The patch avermedia-005.diff
---------
diff -pur saa716x.orig/linux/drivers/media/common/saa716x/saa716x_hybrid.c saa716x/linux/drivers/media/common/saa716x/saa716x_hybrid.c
--- saa716x.orig/linux/drivers/media/common/saa716x/saa716x_hybrid.c	2010-06-20 13:24:18.000000000 +0200
+++ saa716x/linux/drivers/media/common/saa716x/saa716x_hybrid.c	2010-08-10 23:34:42.901211071 +0200
@@ -35,6 +35,9 @@
 #include "zl10353.h"
 #include "mb86a16.h"
 #include "tda1004x.h"
+#include "af9013.h"
+#include "tda18271.h"
+
 
 unsigned int verbose;
 module_param(verbose, int, 0644);
@@ -540,6 +543,82 @@ static struct saa716x_config saa716x_ave
 	.i2c_rate		= SAA716x_I2C_RATE_100,
 };
 
+#define SAA716x_MODEL_AVERMEDIA_A188	"Avermedia AVerTV Duo Hybrid PCI-E II A188"
+#define SAA716x_DEV_AVERMEDIA_A188	"2x DVB-T + 2x Analaog"
+
+static int load_config_avera188(struct saa716x_dev *saa716x)
+{
+	int ret = 0;
+	return ret;
+}
+
+/* probably af9013 is used in parallel mode 
+** common demod_address are 0x38 and 0x3a
+** tuner is nxp tda18271
+*/
+struct af9013_config avera188_af9013_config = {
+		.demod_address = 0x38,
+		.output_mode = AF9013_OUTPUT_MODE_PARALLEL,
+		.api_version = { 0, 1, 9, 0 },
+		.gpio[0] = AF9013_GPIO_HI,
+		.gpio[3] = AF9013_GPIO_TUNER_ON,
+
+/*
+		.demod_address = 0x3a,
+		.output_mode = AF9013_OUTPUT_MODE_SERIAL,
+		.api_version = { 0, 1, 9, 0 },
+		.gpio[0] = AF9013_GPIO_TUNER_ON,
+		.gpio[1] = AF9013_GPIO_LO,
+*/
+};
+
+
+static int saa716x_avera188_frontend_attach(struct saa716x_adapter *adapter, int count)
+{
+	struct saa716x_dev *saa716x = adapter->saa716x;
+	struct saa716x_i2c *i2c = &saa716x->i2c[count];
+        int i;
+        
+	if (count  == 0) {
+		dprintk(SAA716x_DEBUG, 1, "Adapter (%d) SAA716x frontend Init", count);
+		dprintk(SAA716x_DEBUG, 1, "Adapter (%d) Device ID=%02x", count, saa716x->pdev->subsystem_device);
+		dprintk(SAA716x_ERROR, 1, "Adapter (%d) Power ON", count);
+		saa716x_gpio_write(saa716x, GPIO_14, 1);
+		msleep(100);
+
+		for(i = 0; i < 1; i++)
+		{ /* try all addresses in a loop */
+		/* avera188_af9013_config.demod_address = i; */
+
+                printk("Trying af9013 frontend on I2C address 0x%02x", avera188_af9013_config.demod_address);
+		adapter->fe = af9013_attach(&avera188_af9013_config, &i2c->i2c_adapter);
+		if (adapter->fe == NULL) {
+			dprintk(SAA716x_ERROR, 1, "Frontend attach failed");
+			/* return -ENODEV; */
+		} else {
+			dprintk(SAA716x_ERROR, 1, "Done!");
+			return 0;
+		}
+		}
+		return -ENODEV;
+		
+	}
+
+	return 0;
+}
+
+static struct saa716x_config saa716x_avera188_config = {
+	.model_name		= SAA716x_MODEL_AVERMEDIA_A188,
+	.dev_type		= SAA716x_DEV_AVERMEDIA_A188,
+	.boot_mode		= SAA716x_EXT_BOOT,
+	.load_config		= &load_config_avera188,
+	.adapters		= 1,
+	.frontend_attach	= saa716x_avera188_frontend_attach,
+	.irq_handler		= saa716x_hybrid_pci_irq,
+	.i2c_rate		= SAA716x_I2C_RATE_100,
+};
+
+
 static struct pci_device_id saa716x_hybrid_pci_table[] = {
 
 	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, TWINHAN_VP_6090, SAA7162, &saa716x_vp6090_config),
@@ -547,6 +626,7 @@ static struct pci_device_id saa716x_hybr
 	MAKE_ENTRY(NXP_REFERENCE_BOARD, PCI_ANY_ID, SAA7160, &saa716x_nemo_config),
 	MAKE_ENTRY(AVERMEDIA, AVERMEDIA_HC82, SAA7160, &saa716x_averhc82_config),
 	MAKE_ENTRY(AVERMEDIA, AVERMEDIA_H788, SAA7160, &saa716x_averh788_config),
+	MAKE_ENTRY(AVERMEDIA, AVERMEDIA_A188, SAA7160, &saa716x_avera188_config),
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, saa716x_hybrid_pci_table);
Only in saa716x/linux/drivers/media/common/saa716x: saa716x_hybrid.c~
diff -pur saa716x.orig/linux/drivers/media/common/saa716x/saa716x_hybrid.h saa716x/linux/drivers/media/common/saa716x/saa716x_hybrid.h
--- saa716x.orig/linux/drivers/media/common/saa716x/saa716x_hybrid.h	2010-06-20 13:24:18.000000000 +0200
+++ saa716x/linux/drivers/media/common/saa716x/saa716x_hybrid.h	2010-08-10 21:02:40.587592396 +0200
@@ -7,5 +7,6 @@
 #define TWINHAN_VP_6090		0x0027
 #define AVERMEDIA_HC82		0x2355
 #define AVERMEDIA_H788		0x1455
+#define AVERMEDIA_A188		0x1855
 
 #endif /* __SAA716x_HYBRID_H */
Only in saa716x/linux/drivers/media/dvb/frontends: af9013.c~
