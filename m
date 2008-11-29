Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAT1h4bC028881
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 20:43:04 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAT1gkkn015029
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 20:42:47 -0500
Date: Sat, 29 Nov 2008 02:42:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>, fpantaleao@mobisensesystems.com
In-Reply-To: <20081107130136.fkdeaklvs40ocsws@webmail.hebergement.com>
Message-ID: <Pine.LNX.4.64.0811290229070.7032@axis700.grange>
References: <20081107130136.fkdeaklvs40ocsws@webmail.hebergement.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: About CITOR register value for pxa_camera
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

I finally got round to trying this...

On Fri, 7 Nov 2008, fpantaleao@mobisensesystems.com wrote:

> On Fri, 7 Nov 2008, g.liakhovetski@gmx.de wrote:
> 
> > On Fri, 7 Nov 2008, fpantaleao@mobisensesystems.com wrote:
> > 
> > > To be more general (sensor clocked by MCLK or not), I think we should
> > > request
> > > the sensor its PCLK, by adding a get_pclk member in soc_camera_ops for
> > > example.
> > 
> > Yes, that should be even better, and pass master-clock frequency as a
> > parameter? What shall we take for default? pclk == mclk or some safe
> > conservative value? Don't think requiring every camera driver to provide
> > this method would be very good.
> 
> MCLK as a parameter is fine.
> For the default, I suggest:
>  PCLK = MCLK when MCLK is enabled,
>  13MHz otherwise which is a low value for PCLK.
> 
> I agree we must keep things simple even if a correct value for CITOR really
> improves acquisition performance.

Please, have a look at this patch. I decided against another function call 
for a number of reasons: first, if the host calls into the camera to ask 
whether the frequency has changed, it is not easy to recognise, whether it 
changed _now_, if you let camera notify the host about frequency change 
this breaks the hierarchy. Second, you don't know how many more similar 
parameters will have to be communicated between the camera and the host. 
So, I decided to add an extensible sense struct.

Only compile tested so far, will run-test later, maybe tomorrow (actually, 
already today). Comments welcome, tests even more so:-)

> > Another question, are there situations, when a sensor might decide to change
> > its pixelclock dynamically? Then it might need to inform the host driver
> > about the change?
> 
> PCLK changes dynamically with sensor resolution, subsampling, pixel format and
> so on. Every time a format change occurs, CITOR could be updated in 2 steps:
> 1. PCLK value should be updated by the camera driver.
> The computation is based on the sensor input clock (provided by platform data)
> and current settings.
> To make things more simple, the camera driver can use a constant equal to the
> lowest possible value.
> 2. PCLK value should be read to compute the new CITOR value.

Patch below. Loosely based on top of our current format-negotiation 
stack...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 660ffd4..a437d6e 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -120,7 +120,9 @@ struct pxa_camera_dev {
 	struct pxacamera_platform_data *pdata;
 	struct resource		*res;
 	unsigned long		platform_flags;
-	unsigned long		platform_mclk_10khz;
+	unsigned long		ciclk;
+	unsigned long		mclk;
+	u32			mclk_divisor;
 
 	struct list_head	capture;
 
@@ -598,24 +600,43 @@ static void pxa_camera_init_videobuf(struct videobuf_queue *q,
 				sizeof(struct pxa_buffer), icd);
 }
 
-static int mclk_get_divisor(struct pxa_camera_dev *pcdev)
+static u32 mclk_get_divisor(struct pxa_camera_dev *pcdev)
 {
-	unsigned int mclk_10khz = pcdev->platform_mclk_10khz;
-	unsigned long div;
+	unsigned long mclk = pcdev->mclk;
+	u32 div;
 	unsigned long lcdclk;
 
-	lcdclk = clk_get_rate(pcdev->clk) / 10000;
+	lcdclk = clk_get_rate(pcdev->clk);
+	pcdev->ciclk = lcdclk;
 
-	/* We verify platform_mclk_10khz != 0, so if anyone breaks it, here
-	 * they get a nice Oops */
-	div = (lcdclk + 2 * mclk_10khz - 1) / (2 * mclk_10khz) - 1;
+	/* mclk <= ciclk / 4 (27.4.2) */
+	if (mclk > lcdclk / 4) {
+		mclk = lcdclk / 4;
+		dev_warn(pcdev->dev, "Limiting master clock to %lu\n", mclk);
+	}
+
+	/* We verify mclk != 0, so if anyone breaks it, here comes their Oops */
+	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
+
+	/* If we're not supplying MCLK, leave it at 0 */
+	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
+		pcdev->mclk = lcdclk / (2 * (div - 1));
 
-	dev_dbg(pcdev->dev, "LCD clock %lukHz, target freq %dkHz, "
-		"divisor %lu\n", lcdclk * 10, mclk_10khz * 10, div);
+	dev_dbg(pcdev->dev, "LCD clock %luHz, target freq %dHz, "
+		"divisor %lu\n", lcdclk, mclk, div);
 
 	return div;
 }
 
+static void recalculate_fifo_timeout(struct pxa_camera_dev *pcdev,
+				     unsigned long pclk)
+{
+	/* We want a timeout > 1 pixel time, not ">=" */
+	u32 ciclk_per_pixel = pcdev->ciclk / pclk + 1;
+
+	CITOR = ciclk_per_pixel;
+}
+
 static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 {
 	struct pxacamera_platform_data *pdata = pcdev->pdata;
@@ -642,7 +663,14 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 	if (pcdev->platform_flags & PXA_CAMERA_VSP)
 		cicr4 |= CICR4_VSP;
 
-	CICR4 = mclk_get_divisor(pcdev) | cicr4;
+	CICR4 = pcdev->mclk_divisor | cicr4;
+
+	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
+		/* Initialise the timeout under the assumption pclk = mclk */
+		recalculate_fifo_timeout(pcdev, pcdev->mclk);
+	else
+		/* "Safe default" - 13MHz */
+		recalculate_fifo_timeout(pcdev, 13000000);
 
 	clk_enable(pcdev->clk);
 }
@@ -888,7 +916,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	CICR2 = 0;
 	CICR3 = CICR3_LPF_VAL(icd->height - 1) |
 		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
-	CICR4 = mclk_get_divisor(pcdev) | cicr4;
+	CICR4 = pcdev->mclk_divisor | cicr4;
 
 	/* CIF interrupts are not used, only DMA */
 	CICR0 = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
@@ -901,8 +929,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 				    unsigned char buswidth)
 {
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
@@ -1014,13 +1041,17 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 	return formats;
 }
 
-
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 			      __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
 	const struct soc_camera_data_format *host_fmt, *cam_fmt = NULL;
 	const struct soc_camera_format_xlate *xlate;
+	struct soc_camera_sense sense = {
+		.master_clock = pcdev->mclk,
+		.pixel_clock_max = pcdev->ciclk / 4,
+	};
 	int ret, buswidth;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
@@ -1033,6 +1064,10 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	host_fmt = xlate->host_fmt;
 	cam_fmt = xlate->cam_fmt;
 
+	/* If PCLK is used to latch data from the sensor, check sense */
+	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
+		icd->sense = &sense;
+
 	switch (pixfmt) {
 	case 0:				/* Only geometry change */
 		ret = icd->ops->set_fmt(icd, pixfmt, rect);
@@ -1041,9 +1076,20 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		ret = icd->ops->set_fmt(icd, cam_fmt->fourcc, rect);
 	}
 
-	if (ret < 0)
+	icd->sense = NULL;
+
+	if (ret < 0) {
 		dev_warn(&ici->dev, "Failed to configure for format %x\n",
 			 pixfmt);
+	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
+		if (sense.pixel_clock > sense.pixel_clock_max) {
+			dev_err(&ici->dev,
+				"pixel clock %lu set by the camera too high!",
+				sense.pixel_clock);
+			return -EIO;
+		}
+		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
+	}
 
 	if (pixfmt && !ret) {
 		icd->buswidth = buswidth;
@@ -1248,14 +1294,16 @@ static int pxa_camera_probe(struct platform_device *pdev)
 			 "data widths, using default 10 bit\n");
 		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
 	}
-	pcdev->platform_mclk_10khz = pcdev->pdata->mclk_10khz;
-	if (!pcdev->platform_mclk_10khz) {
+	pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
+	if (!pcdev->mclk) {
 		dev_warn(&pdev->dev,
-			 "mclk_10khz == 0! Please, fix your platform data. "
+			 "mclk == 0! Please, fix your platform data. "
 			 "Using default 20MHz\n");
-		pcdev->platform_mclk_10khz = 2000;
+		pcdev->mclk = 20000000;
 	}
 
+	pcdev->mclk_divisor = mclk_get_divisor(pcdev);
+
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b1126b1..cf9bf8c 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -36,6 +36,7 @@ struct soc_camera_device {
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
 	unsigned char buswidth;		/* See comment in .c */
+	struct soc_camera_sense *sense;	/* See comment in struct definition */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
 	const struct soc_camera_data_format *current_fmt;
@@ -162,6 +163,32 @@ struct soc_camera_ops {
 	int num_controls;
 };
 
+#define SOCAM_SENSE_PCLK_CHANGED	(1 << 0)
+
+/**
+ * This struct can be attached to struct soc_camera_device by the host driver
+ * to request sense from the camera, for example, when calling .set_fmt(). The
+ * host then can check which flags are set and verify respective values if any.
+ * For example, if SOCAM_SENSE_PCLK_CHANGED is set, it means, pixclock has
+ * changed during this operation. After completion the host should detach sense.
+ *
+ * @flags		ored SOCAM_SENSE_* flags
+ * @master_clock	if the host wants to be informed about pixel-clock
+ *			change, it better set master_clock.
+ * @pixel_clock_max	maximum pixel clock frequency supported by the host,
+ *			camera is not allowed to exceed this.
+ * @pixel_clock		if the camera driver changed pixel clock during this
+ *			operation, it sets SOCAM_SENSE_PCLK_CHANGED, uses
+ *			master_clock to calculate the new pixel-clock and
+ *			sets it.
+ */
+struct soc_camera_sense {
+	unsigned long flags;
+	unsigned long master_clock;
+	unsigned long pixel_clock_max;
+	unsigned long pixel_clock;
+};
+
 static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 	struct soc_camera_ops *ops, int id)
 {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
