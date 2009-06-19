Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:4859 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZFST5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 15:57:06 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1MHlJq-00058c-4z
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Fri, 19 Jun 2009 23:08:18 +0200
Date: Fri, 19 Jun 2009 21:56:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Stop defining I2C adapter IDs nobody uses
Message-ID: <20090619215656.2d189bd0@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no point in defining I2C adapter IDs when no code is using
them. As this field might go away in the future, stop using it when
we don't need to.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
There are 2 different cases:
* If ir-kbd-i2c tests the adapter ID on older kernels, we have to keep
  the ID definition in the v4l-dvb repository and only drop it in the
  upstream kernel.
* For other adapter drivers, we can drop the definition right away.

 linux/drivers/media/video/au0828/au0828-i2c.c        |    1 -
 linux/drivers/media/video/bt8xx/bttv-i2c.c           |    4 ++++
 linux/drivers/media/video/cafe_ccic.c                |    1 -
 linux/drivers/media/video/cx18/cx18-i2c.c            |    2 ++
 linux/drivers/media/video/cx231xx/cx231xx-i2c.c      |    1 -
 linux/drivers/media/video/cx23885/cx23885-i2c.c      |    2 ++
 linux/drivers/media/video/em28xx/em28xx-i2c.c        |    2 ++
 linux/drivers/media/video/hdpvr/hdpvr-i2c.c          |    1 -
 linux/drivers/media/video/ivtv/ivtv-i2c.c            |    4 ++++
 linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    2 ++
 linux/drivers/media/video/vino.c                     |    1 -
 linux/drivers/media/video/w9968cf.c                  |    1 -
 linux/drivers/media/video/zoran/zoran_card.c         |    1 -
 13 files changed, 16 insertions(+), 7 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-i2c.c	2009-06-04 14:08:18.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-i2c.c	2009-06-19 20:30:59.000000000 +0200
@@ -355,7 +355,9 @@ int __devinit init_bttv_i2c(struct bttv
 		/* bt878 */
 		strlcpy(btv->c.i2c_adap.name, "bt878",
 			sizeof(btv->c.i2c_adap.name));
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 		btv->c.i2c_adap.id = I2C_HW_B_BT848;	/* FIXME */
+#endif
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
 		btv->c.i2c_adap.algo = (struct i2c_algorithm *)&bttv_algo;
 #else
@@ -369,7 +371,9 @@ int __devinit init_bttv_i2c(struct bttv
 
 		strlcpy(btv->c.i2c_adap.name, "bttv",
 			sizeof(btv->c.i2c_adap.name));
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 		btv->c.i2c_adap.id = I2C_HW_B_BT848;
+#endif
 		memcpy(&btv->i2c_algo, &bttv_i2c_algo_bit_template,
 		       sizeof(bttv_i2c_algo_bit_template));
 		btv->i2c_algo.udelay = i2c_udelay;
--- v4l-dvb.orig/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-05-28 12:42:51.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-06-19 20:30:02.000000000 +0200
@@ -618,7 +618,9 @@ static struct i2c_algorithm pvr2_i2c_alg
 static struct i2c_adapter pvr2_i2c_adap_template = {
 	.owner         = THIS_MODULE,
 	.class	       = 0,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 	.id            = I2C_HW_B_BT848,
+#endif
 };
 
 
--- v4l-dvb.orig/linux/drivers/media/video/zoran/zoran_card.c	2009-06-16 20:56:12.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/zoran/zoran_card.c	2009-06-19 20:53:11.000000000 +0200
@@ -733,7 +733,6 @@ zoran_register_i2c (struct zoran *zr)
 	memcpy(&zr->i2c_algo, &zoran_i2c_bit_data_template,
 	       sizeof(struct i2c_algo_bit_data));
 	zr->i2c_algo.data = zr;
-	zr->i2c_adapter.id = I2C_HW_B_ZR36067;
 	strlcpy(zr->i2c_adapter.name, ZR_DEVNAME(zr),
 		sizeof(zr->i2c_adapter.name));
 	i2c_set_adapdata(&zr->i2c_adapter, &zr->v4l2_dev);
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-i2c.c	2009-05-28 12:42:51.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-i2c.c	2009-06-19 20:54:27.000000000 +0200
@@ -465,7 +465,9 @@ static struct i2c_adapter em28xx_adap_te
 	.class = I2C_CLASS_TV_ANALOG,
 #endif
 	.name = "em28xx",
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 	.id = I2C_HW_B_EM28XX,
+#endif
 	.algo = &em28xx_algo,
 };
 
--- v4l-dvb.orig/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-21 11:00:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx18/cx18-i2c.c	2009-06-19 20:58:10.000000000 +0200
@@ -190,7 +190,9 @@ static int cx18_getsda(void *data)
 /* template for i2c-bit-algo */
 static struct i2c_adapter cx18_i2c_adap_template = {
 	.name = "cx18 i2c driver",
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 	.id = I2C_HW_B_CX2341X,
+#endif
 	.algo = NULL,                   /* set by i2c-algo-bit */
 	.algo_data = NULL,              /* filled from template */
 	.owner = THIS_MODULE,
--- v4l-dvb.orig/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-06-19 18:34:13.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-06-19 20:58:26.000000000 +0200
@@ -516,7 +516,9 @@ static struct i2c_algorithm ivtv_algo =
 /* template for our-bit banger */
 static struct i2c_adapter ivtv_i2c_adap_hw_template = {
 	.name = "ivtv i2c driver",
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 	.id = I2C_HW_B_CX2341X,
+#endif
 	.algo = &ivtv_algo,
 	.algo_data = NULL,			/* filled from template */
 	.owner = THIS_MODULE,
@@ -570,7 +572,9 @@ static int ivtv_getsda_old(void *data)
 /* template for i2c-bit-algo */
 static struct i2c_adapter ivtv_i2c_adap_template = {
 	.name = "ivtv i2c driver",
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 	.id = I2C_HW_B_CX2341X,
+#endif
 	.algo = NULL,                   /* set by i2c-algo-bit */
 	.algo_data = NULL,              /* filled from template */
 	.owner = THIS_MODULE,
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-i2c.c	2009-05-28 12:42:50.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-i2c.c	2009-06-19 21:01:28.000000000 +0200
@@ -287,7 +287,9 @@ static struct i2c_algorithm cx23885_i2c_
 static struct i2c_adapter cx23885_i2c_adap_template = {
 	.name              = "cx23885",
 	.owner             = THIS_MODULE,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 	.id                = I2C_HW_B_CX23885,
+#endif
 	.algo              = &cx23885_i2c_algo_template,
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
 	.class             = I2C_CLASS_TV_ANALOG,
--- v4l-dvb.orig/linux/drivers/media/video/au0828/au0828-i2c.c	2009-04-03 14:18:26.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/au0828/au0828-i2c.c	2009-06-19 21:01:54.000000000 +0200
@@ -324,7 +324,6 @@ static struct i2c_algorithm au0828_i2c_a
 static struct i2c_adapter au0828_i2c_adap_template = {
 	.name              = DRIVER_NAME,
 	.owner             = THIS_MODULE,
-	.id                = I2C_HW_B_AU0828,
 	.algo              = &au0828_i2c_algo_template,
 };
 
--- v4l-dvb.orig/linux/drivers/media/video/cafe_ccic.c	2009-05-11 11:12:02.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cafe_ccic.c	2009-06-19 21:04:12.000000000 +0200
@@ -491,7 +491,6 @@ static int cafe_smbus_setup(struct cafe_
 	int ret;
 
 	cafe_smbus_enable_irq(cam);
-	adap->id = I2C_HW_SMBUS_CAFE;
 	adap->owner = THIS_MODULE;
 	adap->algo = &cafe_smbus_algo;
 	strcpy(adap->name, "cafe_ccic");
--- v4l-dvb.orig/linux/drivers/media/video/cx231xx/cx231xx-i2c.c	2009-05-28 12:42:50.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx231xx/cx231xx-i2c.c	2009-06-19 21:02:13.000000000 +0200
@@ -435,7 +435,6 @@ static struct i2c_algorithm cx231xx_algo
 static struct i2c_adapter cx231xx_adap_template = {
 	.owner = THIS_MODULE,
 	.name = "cx231xx",
-	.id = I2C_HW_B_CX231XX,
 	.algo = &cx231xx_algo,
 };
 
--- v4l-dvb.orig/linux/drivers/media/video/hdpvr/hdpvr-i2c.c	2009-03-27 15:01:39.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/hdpvr/hdpvr-i2c.c	2009-06-19 21:02:49.000000000 +0200
@@ -127,7 +127,6 @@ int hdpvr_register_i2c_adapter(struct hd
 		sizeof(i2c_adap->name));
 	i2c_adap->algo  = &hdpvr_algo;
 	i2c_adap->class = I2C_CLASS_TV_ANALOG;
-	i2c_adap->id    = I2C_HW_B_HDPVR;
 	i2c_adap->owner = THIS_MODULE;
 	i2c_adap->dev.parent = &dev->udev->dev;
 
--- v4l-dvb.orig/linux/drivers/media/video/vino.c	2009-06-16 20:56:12.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/vino.c	2009-06-19 21:03:07.000000000 +0200
@@ -1776,7 +1776,6 @@ static struct i2c_algo_sgi_data i2c_sgi_
 
 static struct i2c_adapter vino_i2c_adapter = {
 	.name			= "VINO I2C bus",
-	.id			= I2C_HW_SGI_VINO,
 	.algo			= &sgi_algo,
 	.algo_data		= &i2c_sgi_vino_data,
 	.owner 			= THIS_MODULE,
--- v4l-dvb.orig/linux/drivers/media/video/w9968cf.c	2009-06-04 13:45:28.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/w9968cf.c	2009-06-19 21:03:35.000000000 +0200
@@ -1508,7 +1508,6 @@ static int w9968cf_i2c_init(struct w9968
 	};
 
 	static struct i2c_adapter adap = {
-		.id =                I2C_HW_SMBUS_W9968CF,
 		.owner =             THIS_MODULE,
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
 		.class =	     I2C_CLASS_TV_ANALOG,


-- 
Jean Delvare
