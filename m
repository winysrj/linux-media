Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB19hOXL032332
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 04:43:24 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB19hBDE021332
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 04:43:12 -0500
Date: Mon, 1 Dec 2008 10:41:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <Pine.LNX.4.64.0812011039550.3915@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812011040590.3915@axis700.grange>
References: <20081107130136.fkdeaklvs40ocsws@webmail.hebergement.com>
	<Pine.LNX.4.64.0811290229070.7032@axis700.grange>
	<873ah8n8d3.fsf@free.fr>
	<Pine.LNX.4.64.0812011039550.3915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: [PATCH 2/2] pxa-camera: setup the FIFO inactivity time-out register
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

Using PXA270's FIFO inactivity time-out register (CITOR) reduces FIFO overruns.
The time-out is calculated in CICLK / LCDCLK ticks and has to be longer than
one pixel time. For this we have to know the pixel clock frequency, which
usually is provided by the camera. We use the struct soc_camera_sense to
request PCLK frequency from the camera driver upon each data format change.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |   89 +++++++++++++++++++++++++++++--------
 1 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 8219a6c..e1fff1c 100644
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
+		pcdev->mclk = lcdclk / (2 * (div + 1));
 
-	dev_dbg(pcdev->dev, "LCD clock %lukHz, target freq %dkHz, "
-		"divisor %lu\n", lcdclk * 10, mclk_10khz * 10, div);
+	dev_dbg(pcdev->dev, "LCD clock %luHz, target freq %luHz, "
+		"divisor %u\n", lcdclk, mclk, div);
 
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
@@ -1018,8 +1045,13 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
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
@@ -1032,6 +1064,10 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	host_fmt = xlate->host_fmt;
 	cam_fmt = xlate->cam_fmt;
 
+	/* If PCLK is used to latch data from the sensor, check sense */
+	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
+		icd->sense = &sense;
+
 	switch (pixfmt) {
 	case 0:				/* Only geometry change */
 		ret = icd->ops->set_fmt(icd, pixfmt, rect);
@@ -1040,9 +1076,20 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
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
@@ -1247,14 +1294,17 @@ static int pxa_camera_probe(struct platform_device *pdev)
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
 
+	pcdev->dev = &pdev->dev;
+	pcdev->mclk_divisor = mclk_get_divisor(pcdev);
+
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
 
@@ -1274,7 +1324,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	}
 	pcdev->irq = irq;
 	pcdev->base = base;
-	pcdev->dev = &pdev->dev;
 
 	/* request dma */
 	err = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
