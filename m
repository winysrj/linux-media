Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6V5wZVw006843
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 01:58:35 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6V5wNmV026756
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 01:58:23 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
Date: Thu, 31 Jul 2008 08:02:24 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
To: video4linux-list@redhat.com
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] Move .power and .reset from soc_camera platform to sensor
	driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Move .power (enable_camera, disable_camera) and .reset from soc_camera
platform driver (pxa_camera_platform_data, sh_mobile_ceu_info) to sensor
driver (soc_camera_link) and add .init and .release to request and free
gpios.

Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>

diff -r 55e8c99c8aa8 -r 294f0a37c4fe linux/drivers/media/video/mt9m001.c
--- a/linux/drivers/media/video/mt9m001.c	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/drivers/media/video/mt9m001.c	Thu Jul 31 07:59:35 2008 +0200
@@ -117,14 +117,23 @@ static int reg_clear(struct soc_camera_d
 
 static int mt9m001_init(struct soc_camera_device *icd)
 {
-	int ret;
+	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	int ret = 0;
 
 	/* Disable chip, synchronous option update */
 	dev_dbg(icd->vdev->parent, "%s\n", __func__);
 
-	ret = reg_write(icd, MT9M001_RESET, 1);
-	if (ret >= 0)
-		ret = reg_write(icd, MT9M001_RESET, 0);
+	if (icl->power)
+		icl->power(&mt9m001->client->dev, 1);
+
+	if (icl->reset)
+		icl->reset(&mt9m001->client->dev);
+	else {
+		ret = reg_write(icd, MT9M001_RESET, 1);
+		if (ret >= 0)
+			ret = reg_write(icd, MT9M001_RESET, 0);
+	}
 	if (ret >= 0)
 		ret = reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
 
@@ -133,8 +142,15 @@ static int mt9m001_init(struct soc_camer
 
 static int mt9m001_release(struct soc_camera_device *icd)
 {
+	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+
 	/* Disable the chip */
-	reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
+	if (icl->power)
+		icl->power(&mt9m001->client->dev, 0);
+	else
+		reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
+
 	return 0;
 }
 
@@ -670,6 +686,12 @@ static int mt9m001_probe(struct i2c_clie
 	 * ourselves in the driver based on vertical blanking and frame width */
 	mt9m001->autoexposure = 1;
 
+	if (icl->init) {
+		ret = icl->init(&mt9m001->client->dev);
+		if (ret)
+			goto einit;
+	}
+
 	ret = bus_switch_request(mt9m001, icl);
 	if (ret)
 		goto eswinit;
@@ -683,6 +705,9 @@ eisdr:
 eisdr:
 	bus_switch_release(mt9m001);
 eswinit:
+	if (icl->release)
+		icl->release(&mt9m001->client->dev);
+einit:
 	kfree(mt9m001);
 	return ret;
 }
@@ -690,9 +715,12 @@ static int mt9m001_remove(struct i2c_cli
 static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
 
 	soc_camera_device_unregister(&mt9m001->icd);
 	bus_switch_release(mt9m001);
+	if (icl->release)
+		icl->release(&mt9m001->client->dev);
 	kfree(mt9m001);
 
 	return 0;
diff -r 55e8c99c8aa8 -r 294f0a37c4fe linux/drivers/media/video/mt9v022.c
--- a/linux/drivers/media/video/mt9v022.c	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/drivers/media/video/mt9v022.c	Thu Jul 31 07:59:35 2008 +0200
@@ -134,7 +134,11 @@ static int mt9v022_init(struct soc_camer
 static int mt9v022_init(struct soc_camera_device *icd)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
 	int ret;
+
+	if (icl->power)
+		icl->power(&mt9v022->client->dev, 1);
 
 	/* Almost the default mode: master, parallel, simultaneous, and an
 	 * undocumented bit 0x200, which is present in table 7, but not in 8,
@@ -161,7 +165,12 @@ static int mt9v022_init(struct soc_camer
 
 static int mt9v022_release(struct soc_camera_device *icd)
 {
-	/* Nothing? */
+	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+
+	if (icl->power)
+		icl->power(&mt9v022->client->dev, 0);
+
 	return 0;
 }
 
@@ -668,6 +677,7 @@ static int mt9v022_video_probe(struct so
 static int mt9v022_video_probe(struct soc_camera_device *icd)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
 	s32 data;
 	int ret;
 
@@ -686,15 +696,19 @@ static int mt9v022_video_probe(struct so
 		goto ei2c;
 	}
 
-	/* Soft reset */
-	ret = reg_write(icd, MT9V022_RESET, 1);
-	if (ret < 0)
-		goto ei2c;
-	/* 15 clock cycles */
-	udelay(200);
-	if (reg_read(icd, MT9V022_RESET)) {
-		dev_err(&icd->dev, "Resetting MT9V022 failed!\n");
-		goto ei2c;
+	if (icl->reset)
+		icl->reset(&mt9v022->client->dev);
+	else {
+		/* Soft reset */
+		ret = reg_write(icd, MT9V022_RESET, 1);
+		if (ret < 0)
+			goto ei2c;
+		/* 15 clock cycles */
+		udelay(200);
+		if (reg_read(icd, MT9V022_RESET)) {
+			dev_err(&icd->dev, "Resetting MT9V022 failed!\n");
+			goto ei2c;
+		}
 	}
 
 	/* Set monochrome or colour sensor type */
@@ -788,6 +802,12 @@ static int mt9v022_probe(struct i2c_clie
 	 * other widths. Therefore it seems to be a sensible default. */
 	mt9v022->datawidth = 10;
 
+	if (icl->init) {
+		ret = icl->init(&mt9v022->client->dev);
+		if (ret)
+			goto einit;
+	}
+
 	ret = bus_switch_request(mt9v022, icl);
 	if (ret)
 		goto eswinit;
@@ -801,6 +821,9 @@ eisdr:
 eisdr:
 	bus_switch_release(mt9v022);
 eswinit:
+	if (icl->release)
+		icl->release(&mt9v022->client->dev);
+einit:
 	kfree(mt9v022);
 	return ret;
 }
@@ -808,9 +831,12 @@ static int mt9v022_remove(struct i2c_cli
 static int mt9v022_remove(struct i2c_client *client)
 {
 	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
 
 	soc_camera_device_unregister(&mt9v022->icd);
 	bus_switch_release(mt9v022);
+	if (icl->release)
+		icl->release(&mt9v022->client->dev);
 	kfree(mt9v022);
 
 	return 0;
diff -r 55e8c99c8aa8 -r 294f0a37c4fe linux/drivers/media/video/pxa_camera.c
--- a/linux/drivers/media/video/pxa_camera.c	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/drivers/media/video/pxa_camera.c	Thu Jul 31 07:59:35 2008 +0200
@@ -627,17 +627,6 @@ static void pxa_camera_activate(struct p
 		pdata->init(pcdev->dev);
 	}
 
-	if (pdata && pdata->power) {
-		dev_dbg(pcdev->dev, "%s: Power on camera\n", __func__);
-		pdata->power(pcdev->dev, 1);
-	}
-
-	if (pdata && pdata->reset) {
-		dev_dbg(pcdev->dev, "%s: Releasing camera reset\n",
-			__func__);
-		pdata->reset(pcdev->dev, 1);
-	}
-
 	CICR0 = 0x3FF;   /* disable all interrupts */
 
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
@@ -658,20 +647,7 @@ static void pxa_camera_activate(struct p
 
 static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 {
-	struct pxacamera_platform_data *board = pcdev->pdata;
-
 	clk_disable(pcdev->clk);
-
-	if (board && board->reset) {
-		dev_dbg(pcdev->dev, "%s: Asserting camera reset\n",
-			__func__);
-		board->reset(pcdev->dev, 0);
-	}
-
-	if (board && board->power) {
-		dev_dbg(pcdev->dev, "%s: Power off camera\n", __func__);
-		board->power(pcdev->dev, 0);
-	}
 }
 
 static irqreturn_t pxa_camera_irq(int irq, void *data)
diff -r 55e8c99c8aa8 -r 294f0a37c4fe linux/drivers/media/video/sh_mobile_ceu_camera.c
--- a/linux/drivers/media/video/sh_mobile_ceu_camera.c	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/drivers/media/video/sh_mobile_ceu_camera.c	Thu Jul 31 07:59:35 2008 +0200
@@ -304,9 +304,6 @@ static int sh_mobile_ceu_add_device(stru
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
 
-	if (pcdev->pdata->enable_camera)
-		pcdev->pdata->enable_camera();
-
 	ret = icd->ops->init(icd);
 	if (ret)
 		goto err;
@@ -333,8 +330,6 @@ static void sh_mobile_ceu_remove_device(
 	ceu_write(pcdev, CEIER, 0);
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
 	icd->ops->release(icd);
-	if (pcdev->pdata->disable_camera)
-		pcdev->pdata->disable_camera();
 
 	dev_info(&icd->dev,
 		 "SuperH Mobile CEU driver detached from camera %d\n",
diff -r 55e8c99c8aa8 -r 294f0a37c4fe linux/include/asm-arm/arch-pxa/camera.h
--- a/linux/include/asm-arm/arch-pxa/camera.h	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/include/asm-arm/arch-pxa/camera.h	Thu Jul 31 07:59:35 2008 +0200
@@ -36,8 +36,6 @@
 
 struct pxacamera_platform_data {
 	int (*init)(struct device *);
-	int (*power)(struct device *, int);
-	int (*reset)(struct device *, int);
 
 	unsigned long flags;
 	unsigned long mclk_10khz;
diff -r 55e8c99c8aa8 -r 294f0a37c4fe linux/include/media/sh_mobile_ceu.h
--- a/linux/include/media/sh_mobile_ceu.h	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/include/media/sh_mobile_ceu.h	Thu Jul 31 07:59:35 2008 +0200
@@ -5,8 +5,6 @@
 
 struct sh_mobile_ceu_info {
 	unsigned long flags; /* SOCAM_... */
-	void (*enable_camera)(void);
-	void (*disable_camera)(void);
 };
 
 #endif /* __ASM_SH_MOBILE_CEU_H__ */
diff -r 55e8c99c8aa8 -r 294f0a37c4fe linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/include/media/soc_camera.h	Thu Jul 31 07:59:35 2008 +0200
@@ -76,6 +76,11 @@ struct soc_camera_host_ops {
 };
 
 struct soc_camera_link {
+	int (*init)(struct device *);
+	void (*release)(struct device *);
+	void (*power)(struct device *, int);
+	void (*reset)(struct device *);
+
 	/* Camera bus id, used to match a camera and a bus */
 	int bus_id;
 	/* GPIO number to switch between 8 and 10 bit modes */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
