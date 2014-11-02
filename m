Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaKBMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 07/14] [media] cx231xx: disable I2C errors during i2c_scan
Date: Sun,  2 Nov 2014 10:32:30 -0200
Message-Id: <b7ac688ccd6a6e9d92e214b1f9758b9b4da3f63d.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise, it would produce lots of useless messages like:
	cx231xx: cx231xx_send_usb_command: failed with status --32

After this patch, I2C scan will produce an useful report:

[ 9494.050807] cx231xx: i2c_scan: checking for I2C devices on port=0 ..
[ 9494.074928] cx231xx: i2c scan: Completed Checking for I2C devices on port=0.
[ 9494.074936] cx231xx: i2c_scan: checking for I2C devices on port=3 ..
[ 9494.098934] cx231xx: i2c scan: Completed Checking for I2C devices on port=3.
[ 9494.098942] cx231xx: i2c_scan: checking for I2C devices on port=2 ..
[ 9494.118440] cx231xx: i2c scan: Completed Checking for I2C devices on port=2.
[ 9494.118448] cx231xx: i2c_scan: checking for I2C devices on port=4 ..
[ 9494.141889] cx231xx: i2c scan: Completed Checking for I2C devices on port=4.

[ 9494.060182] cx231xx: i2c scan: found device @ 0x40  [???]
[ 9494.062953] cx231xx: i2c scan: found device @ 0x60  [colibri]
[ 9494.066071] cx231xx: i2c scan: found device @ 0x88  [hammerhead]
[ 9494.067383] cx231xx: i2c scan: found device @ 0x98  [???]
[ 9494.090113] cx231xx: i2c scan: found device @ 0xa0  [eeprom]
[ 9494.106463] cx231xx: i2c scan: found device @ 0x60  [colibri]
[ 9494.113762] cx231xx: i2c scan: found device @ 0xc0  [tuner]
[ 9494.121882] cx231xx: i2c scan: found device @ 0x20  [???]
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index c5842a1ea104..66e8f8ae9be4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -227,7 +227,7 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
-	if (status < 0) {
+	if (status < 0 && !dev->i2c_scan_running) {
 		pr_err("%s: failed with status -%d\n",
 			__func__, status);
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 5a0604711be0..f99857e6c842 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -496,6 +496,9 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	if (!i2c_scan)
 		return;
 
+	/* Don't generate I2C errors during scan */
+	dev->i2c_scan_running = true;
+
 	memset(&client, 0, sizeof(client));
 	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
 
@@ -512,6 +515,8 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	}
 	pr_info("i2c scan: Completed Checking for I2C devices on port=%d.\n",
 		i2c_port);
+
+	dev->i2c_scan_running = false;
 }
 
 /*
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index aeee721a8eef..253f2437c0f1 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -610,6 +610,8 @@ struct cx231xx {
 	unsigned int has_audio_class:1;
 	unsigned int has_alsa_audio:1;
 
+	unsigned int i2c_scan_running:1; /* true only during i2c_scan */
+
 	struct cx231xx_fmt *format;
 
 	struct v4l2_device v4l2_dev;
-- 
1.9.3

