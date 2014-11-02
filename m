Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42486 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaKBMcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 14/14] [media] cx231xx: simplify I2C scan debug messages
Date: Sun,  2 Nov 2014 10:32:37 -0200
Message-Id: <c85e371647e162da4b039785dc829d7659a295e4.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't need to show when it starts or stops. Just print lines
when devices are found.

After the changes, the output for i2c scan will be like:

	usb 1-2: i2c scan: found device @ port 0 addr 0x40  [???]
	usb 1-2: i2c scan: found device @ port 0 addr 0x60  [colibri]
	usb 1-2: i2c scan: found device @ port 0 addr 0x88  [hammerhead]
	usb 1-2: i2c scan: found device @ port 0 addr 0x98  [???]
	usb 1-2: i2c scan: found device @ port 3 addr 0xa0  [eeprom]
	usb 1-2: i2c scan: found device @ port 2 addr 0x60  [colibri]
	usb 1-2: i2c scan: found device @ port 2 addr 0xc0  [tuner]
	usb 1-2: i2c scan: found device @ port 4 addr 0x20  [demod]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 87b26157cad0..7ccc33d33664 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -502,21 +502,17 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	memset(&client, 0, sizeof(client));
 	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
 
-	dev_info(&dev->udev->dev,
-		"i2c_scan: checking for I2C devices on port=%d ..\n",
-		i2c_port);
 	for (i = 0; i < 128; i++) {
 		client.addr = i;
 		rc = i2c_master_recv(&client, &buf, 0);
 		if (rc < 0)
 			continue;
 		dev_info(&dev->udev->dev,
-			 "i2c scan: found device @ 0x%x  [%s]\n",
+			 "i2c scan: found device @ port %d addr 0x%x  [%s]\n",
+			 i2c_port,
 			 i << 1,
 			 i2c_devs[i] ? i2c_devs[i] : "???");
 	}
-	dev_info(&dev->udev->dev, "i2c scan: Completed Checking for I2C devices on port=%d.\n",
-		i2c_port);
 
 	dev->i2c_scan_running = false;
 }
-- 
1.9.3

