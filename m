Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DDUslG005480
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 09:30:54 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7DDUiBn028023
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 09:30:44 -0400
Date: Wed, 13 Aug 2008 15:30:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <4892C629.5000208@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0808131456140.5389@axis700.grange>
References: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
	<48917CB5.6000304@teltonika.lt> <4892A90B.7080309@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010820560.14927@axis700.grange>
	<4892BCD8.4010102@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010940400.14927@axis700.grange>
	<4892C629.5000208@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH] soc-camera: Move .power and .reset from soc_camera host to
 sensor driver
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

Make .power and .reset callbacks per camera instead of per host, also move 
their invocation to camera drivers.

Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

Robert and Stefan, please, read comments below, well, and the patch too:-)

This patch applies on the top of other my patches today.

Robert, please, have a look if you agree with the hunk for mt9m111. I so 
far added ->power calls to your enable and disable functions, not sure if 
this is the best place. BTW, why do you call enable from video_probe 
again? Is it really necessary? And you might want to call disable at 
suspend? Which would then also power the camera down, if supported by the 
platform.

Stefan,

On Fri, 1 Aug 2008, Stefan Herbrechtsmeier wrote:

> Guennadi Liakhovetski schrieb:
> > 
> > I'd rather preserve the possibility to use "soft" reset / poweroff also when
> > a platform function is defined. In fact, it might be even better to do a
> > soft power-off first and then call platform-provided one. Don't think it
> > would make much sense for reset though.
> >   
> You are right, I'll change it with the next version.

How about the version below? I didn't understand why you need extra .init 
and .release calls, so, I removed them for now. I think, .init per host 
and power-on / off per camera should be enough for all init / release 
needs, don't you think so?

> > > > And as a parameter wouldn't it make more sense to pass the
> > > > soc_camera_link
> > > > to the platform functions instead of the struct device from the i2c
> > > > device?
> > > >         
> > > I have simple make the function similar to other platform_data functions
> > > on my
> > > system.
> > > At the moment I use the parameter only for printing messages via dev_err.
> > >     
> > 
> > You have to be able to trace which camera has to be resetted / powered on or
> > off in your platform code, and the camera_link structure is the object that
> > identifies a specific camera, ot, at least, it can be. Whereas the device
> > pointer doesn't easily tell you which camera you want to operate upon.
> >   
> If you use the same function for different sensors (camera_links), you are
> right,
> but you can get the camera_link from the dev pointer (.platform_data) if you
> need it.

Agree, I kept your version with struct device pointer.

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 3531f93..0c52437 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -117,13 +117,33 @@ static int reg_clear(struct soc_camera_device *icd, const u8 reg,
 
 static int mt9m001_init(struct soc_camera_device *icd)
 {
+	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
 	int ret;
 
 	dev_dbg(icd->vdev->parent, "%s\n", __func__);
 
-	ret = reg_write(icd, MT9M001_RESET, 1);
-	if (!ret)
-		ret = reg_write(icd, MT9M001_RESET, 0);
+	if (icl->power) {
+		ret = icl->power(&mt9m001->client->dev, 1);
+		if (ret < 0) {
+			dev_err(icd->vdev->parent,
+				"Platform failed to power-on the camera.\n");
+			return ret;
+		}
+	}
+
+	/* The camera could have been already on, we reset it additionally */
+	if (icl->reset)
+		ret = icl->reset(&mt9m001->client->dev);
+	else
+		ret = -ENODEV;
+
+	if (ret < 0) {
+		/* Either no platform reset, or platform reset failed */
+		ret = reg_write(icd, MT9M001_RESET, 1);
+		if (!ret)
+			ret = reg_write(icd, MT9M001_RESET, 0);
+	}
 	/* Disable chip, synchronous option update */
 	if (!ret)
 		ret = reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
@@ -133,8 +153,15 @@ static int mt9m001_init(struct soc_camera_device *icd)
 
 static int mt9m001_release(struct soc_camera_device *icd)
 {
+	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+
 	/* Disable the chip */
 	reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
+
+	if (icl->power)
+		icl->power(&mt9m001->client->dev, 0);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 537cff0..8c532ac 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -351,8 +351,18 @@ static int mt9m111_setfmt_yuv(struct soc_camera_device *icd)
 static int mt9m111_enable(struct soc_camera_device *icd)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
 	int ret;
 
+	if (icl->power) {
+		ret = icl->power(&mt9m111->client->dev, 1);
+		if (ret < 0) {
+			dev_err(icd->vdev->parent,
+				"Platform failed to power-on the camera.\n");
+			return ret;
+		}
+	}
+
 	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
 	if (!ret)
 		mt9m111->powered = 1;
@@ -362,11 +372,16 @@ static int mt9m111_enable(struct soc_camera_device *icd)
 static int mt9m111_disable(struct soc_camera_device *icd)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
 	int ret;
 
 	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
 	if (!ret)
 		mt9m111->powered = 0;
+
+	if (icl->power)
+		icl->power(&mt9m111->client->dev, 0);
+
 	return ret;
 }
 
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 0f4b204..2584201 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -134,8 +134,25 @@ static int reg_clear(struct soc_camera_device *icd, const u8 reg,
 static int mt9v022_init(struct soc_camera_device *icd)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
 	int ret;
 
+	if (icl->power) {
+		ret = icl->power(&mt9v022->client->dev, 1);
+		if (ret < 0) {
+			dev_err(icd->vdev->parent,
+				"Platform failed to power-on the camera.\n");
+			return ret;
+		}
+	}
+
+	/*
+	 * The camera could have been already on, we hard-reset it additionally,
+	 * if available. Soft reset is done in video_probe().
+	 */
+	if (icl->reset)
+		icl->reset(&mt9v022->client->dev);
+
 	/* Almost the default mode: master, parallel, simultaneous, and an
 	 * undocumented bit 0x200, which is present in table 7, but not in 8,
 	 * plus snapshot mode to disable scan for now */
@@ -161,7 +178,12 @@ static int mt9v022_init(struct soc_camera_device *icd)
 
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
 
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 85f545d..6df2aee 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -629,17 +629,6 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
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
@@ -660,20 +649,7 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 
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
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index f7ca3cb..f6cec44 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -304,9 +304,6 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
 
-	if (pcdev->pdata->enable_camera)
-		pcdev->pdata->enable_camera();
-
 	ret = icd->ops->init(icd);
 	if (ret)
 		goto err;
@@ -333,8 +330,6 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	ceu_write(pcdev, CEIER, 0);
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
 	icd->ops->release(icd);
-	if (pcdev->pdata->disable_camera)
-		pcdev->pdata->disable_camera();
 
 	dev_info(&icd->dev,
 		 "SuperH Mobile CEU driver detached from camera %d\n",
diff --git a/include/asm-arm/arch-pxa/camera.h b/include/asm-arm/arch-pxa/camera.h
index 39516ce..31abe6d 100644
--- a/include/asm-arm/arch-pxa/camera.h
+++ b/include/asm-arm/arch-pxa/camera.h
@@ -36,8 +36,6 @@
 
 struct pxacamera_platform_data {
 	int (*init)(struct device *);
-	int (*power)(struct device *, int);
-	int (*reset)(struct device *, int);
 
 	unsigned long flags;
 	unsigned long mclk_10khz;
diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
index 234a471..b5dbefe 100644
--- a/include/media/sh_mobile_ceu.h
+++ b/include/media/sh_mobile_ceu.h
@@ -5,8 +5,6 @@
 
 struct sh_mobile_ceu_info {
 	unsigned long flags; /* SOCAM_... */
-	void (*enable_camera)(void);
-	void (*disable_camera)(void);
 };
 
 #endif /* __ASM_SH_MOBILE_CEU_H__ */
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d548de3..c5de7bb 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -83,6 +83,9 @@ struct soc_camera_link {
 	int bus_id;
 	/* GPIO number to switch between 8 and 10 bit modes */
 	unsigned int gpio;
+	/* Optional callbacks to power on or off and reset the sensor */
+	int (*power)(struct device *, int);
+	int (*reset)(struct device *);
 };
 
 static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
