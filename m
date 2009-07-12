Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZGLOXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 10:23:04 -0400
Date: Sun, 12 Jul 2009 11:22:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Wally <wally@voosen.eu>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: eMpia Microscope Camera
Message-ID: <20090712112255.72c9a949@pedra.chehab.org>
In-Reply-To: <20090706101505.194332c3@pedra.chehab.org>
References: <200907030900.53557.wally@voosen.eu>
	<20090703133917.7c62ef47@pedra.chehab.org>
	<Pine.LNX.4.64.0907031851580.25247@axis700.grange>
	<200907031939.45207.wally@voosen.eu>
	<Pine.LNX.4.64.0907032034150.25247@axis700.grange>
	<20090706101505.194332c3@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wally,

Em Mon, 6 Jul 2009 10:15:05 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Fri, 3 Jul 2009 20:35:08 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> 
> > (re-adding the mailing list)
> > 
> > On Fri, 3 Jul 2009, Wally wrote:
> > 
> > > Hello Guennadi, hello Mauro
> > > 
> > > that's means i have to wait 
> > > or is there a workaround or something else i can do for now ? 
> > 
> > you can either wait, or hack the mt9m001 driver to work for you, or help 
> > with development.
> 
> The change at em28xx for it should be trivial. The enclosed patch should
> provide the mt9v001 glue, once having it ported to v4l2 dev/subdev.
> 
> You'll need to use this patch _and_ the v4l dev/subdev version of mt9m001 driver.
> 
> Change Huaqi to use mt9m001 driver.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
 
I did a few changes on em28xx that will help to have a better webcam support.
Due to that, the patch I've sent before won't apply anymore.

Could you please test the enclosed patch? It adds a hack that may work with
mt9m001 sensor.



Cheers,
Mauro


---
 linux/drivers/media/video/em28xx/em28xx-cards.c |   55 ++++++++++++++++++++++++
 linux/drivers/media/video/em28xx/em28xx.h       |    1 
 2 files changed, 56 insertions(+)

--- master.orig/linux/drivers/media/video/em28xx/em28xx-cards.c
+++ master/linux/drivers/media/video/em28xx/em28xx-cards.c
@@ -1778,6 +1778,46 @@ static inline void em28xx_set_model(stru
 				       EM28XX_I2C_FREQ_100_KHZ;
 }
 
+/* FIXME: Should be replaced by a proper mt9m001 driver */
+static int em28xx_initialize_mt9m001(struct em28xx *dev)
+{
+	int i;
+	unsigned char regs[][3] = {
+		{ 0x0d, 0x00, 0x01 },
+		{ 0x0d, 0x00, 0x00 },
+		{ 0x01, 0x00, 0x08 },   /* ROWSTART */
+		{ 0x02, 0x00, 0x14 },   /* COLSTART */
+		{ 0x03, 0x01, 0xe0 },   /* WINDOW HEIGHT */
+		{ 0x04, 0x02, 0x80 },   /* WINDOW WIDTH */
+		{ 0x05, 0x00, 0x01 },   /* HORIZONTAL BLANKING */
+		{ 0x06, 0x00, 0x01 },   /* VERTICAL BLANKING */
+		{ 0x0d, 0x00, 0x02 },
+		{ 0x0a, 0x00, 0x00 },
+		{ 0x0c, 0x00, 0x00 },
+		{ 0x11, 0x00, 0x00 },
+		{ 0x1e, 0x80, 0x00 },
+		{ 0x5f, 0x89, 0x04 },
+		{ 0x60, 0x00, 0x00 },
+		{ 0x61, 0x00, 0x00 },
+		{ 0x62, 0x04, 0x98 },
+		{ 0x63, 0x00, 0x00 },
+		{ 0x64, 0x00, 0x00 },
+		{ 0x20, 0x11, 0x1d },
+		{ 0x06, 0x00, 0xf2 },
+		{ 0x05, 0x00, 0x13 },
+		{ 0x09, 0x10, 0xf2 },
+		{ 0x07, 0x00, 0x03 },
+		{ 0x2b, 0x00, 0x2a },
+		{ 0x2d, 0x00, 0x2a },
+		{ 0x2c, 0x00, 0x2a },
+		{ 0x2e, 0x00, 0x29 },
+		{ 0x07, 0x00, 0x02 },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		i2c_master_send(&dev->i2c_client, &regs[i][0], 3);
+}
+
 /* HINT method: webcam I2C chips
  *
  * This method work for webcams with Micron sensors
@@ -1809,6 +1849,14 @@ static int em28xx_hint_sensor(struct em2
 		sensor_name = "mt9v011";
 		dev->em28xx_sensor = EM28XX_MT9V011;
 		break;
+	case 0x8411:
+	case 0x8421:
+	case 0x8431:
+		dev->model = EM2750_BOARD_UNKNOWN;
+		sensor_name = "mt9m001";
+		dev->em28xx_sensor = EM28XX_MT9M001;
+		em28xx_initialize_mt9m001(dev);
+		break;
 	default:
 		printk("Unknown Micron Sensor 0x%04x\n", be16_to_cpu(version));
 		return -EINVAL;
@@ -2376,6 +2424,13 @@ void em28xx_card_setup(struct em28xx *de
 		v4l2_i2c_new_probed_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 			"mt9v011", "mt9v011", mt9v011_addrs);
 
+#if 0
+	/* FIXME: use mt9m001 after their conversion to v4l dev/subdev */
+	if (dev->em28xx_sensor == EM28XX_MT9M001)
+		v4l2_i2c_new_probed_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+			"mt9m001", "mt9m001", mt9v011_addrs);
+#endif
+
 	if (dev->board.adecoder == EM28XX_TVAUDIO)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 			"tvaudio", "tvaudio", dev->board.tvaudio_addr);
--- master.orig/linux/drivers/media/video/em28xx/em28xx.h
+++ master/linux/drivers/media/video/em28xx/em28xx.h
@@ -367,6 +367,7 @@ enum em28xx_decoder {
 enum em28xx_sensor {
 	EM28XX_NOSENSOR = 0,
 	EM28XX_MT9V011,
+	EM28XX_MT9M001,
 };
 
 enum em28xx_adecoder {

