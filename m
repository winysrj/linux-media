Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZGFNPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2009 09:15:09 -0400
Date: Mon, 6 Jul 2009 10:15:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Wally <wally@voosen.eu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: eMpia Microscope Camera
Message-ID: <20090706101505.194332c3@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0907032034150.25247@axis700.grange>
References: <200907030900.53557.wally@voosen.eu>
	<20090703133917.7c62ef47@pedra.chehab.org>
	<Pine.LNX.4.64.0907031851580.25247@axis700.grange>
	<200907031939.45207.wally@voosen.eu>
	<Pine.LNX.4.64.0907032034150.25247@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 3 Jul 2009 20:35:08 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> (re-adding the mailing list)
> 
> On Fri, 3 Jul 2009, Wally wrote:
> 
> > Hello Guennadi, hello Mauro
> > 
> > that's means i have to wait 
> > or is there a workaround or something else i can do for now ? 
> 
> you can either wait, or hack the mt9m001 driver to work for you, or help 
> with development.

The change at em28xx for it should be trivial. The enclosed patch should
provide the mt9v001 glue, once having it ported to v4l2 dev/subdev.

You'll need to use this patch _and_ the v4l dev/subdev version of mt9m001 driver.

Change Huaqi to use mt9m001 driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/linux/drivers/media/video/em28xx/em28xx-cards.c b/linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c
@@ -512,8 +512,9 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2860_BOARD_NETGMBH_CAM] = {
 		/* Beijing Huaqi Information Digital Technology Co., Ltd */
 		.name         = "NetGMBH Cam",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
-		.tuner_type   = TUNER_ABSENT,	/* This is a webcam */
+		.tuner_type   = TUNER_ABSENT,
+		.is_27xx      = 1,
+		.decoder      = EM28XX_MT9M001,
 		.input        = { {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = 0,
@@ -1804,6 +1805,12 @@ static int em28xx_hint_sensor(struct em2
 		dev->model = EM2820_BOARD_SILVERCREST_WEBCAM;
 		sensor_name = "mt9v011";
 		break;
+        case 0x8411:
+        case 0x8421:
+        case 0x8431:
+                dev->model = EM2750_BOARD_DLCW_130;
+		sensor_name = "mt9m001";
+		break;
 	default:
 		printk("Unknown Sensor 0x%04x\n", be16_to_cpu(version));
 		return -EINVAL;
@@ -2371,6 +2378,10 @@ void em28xx_card_setup(struct em28xx *de
 		v4l2_i2c_new_probed_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 			"mt9v011", "mt9v011", mt9v011_addrs);
 
+	if (dev->board.decoder == EM28XX_MT9M001)
+		v4l2_i2c_new_probed_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+			"mt9m001", "mt9m001", mt9v011_addrs);
+
 	if (dev->board.adecoder == EM28XX_TVAUDIO)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 			"tvaudio", "tvaudio", dev->board.tvaudio_addr);
diff --git a/linux/drivers/media/video/em28xx/em28xx.h b/linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h
+++ b/linux/drivers/media/video/em28xx/em28xx.h
@@ -363,6 +363,7 @@ enum em28xx_decoder {
 	EM28XX_TVP5150,
 	EM28XX_SAA711X,
 	EM28XX_MT9V011,
+	EM28XX_MT9M001,
 };
 
 enum em28xx_adecoder {







Cheers,
Mauro
