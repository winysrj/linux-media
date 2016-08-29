Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:20736 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755783AbcH2R4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 13:56:12 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 07/13] media: platform: pxa_camera: make printk consistent
Date: Mon, 29 Aug 2016 19:55:52 +0200
Message-Id: <1472493358-24618-8-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make all print consistent by always using :
 - dev_xxx(pcdev_to_dev(pcdev), ....)

This prepares the soc_camera adherence removal by making these call rely
on only pcdev, and not the soc_camera icd structure.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 70 ++++++++++++++++----------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 9870c53e0ec2..45583a40a4bd 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -236,6 +236,14 @@ struct pxa_cam {
 
 static const char *pxa_cam_driver_description = "PXA_Camera";
 
+static struct pxa_camera_dev *icd_to_pcdev(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+
+	return pcdev;
+}
+
 /*
  *  Videobuf operations
  */
@@ -465,7 +473,6 @@ static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev,
 static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 			       enum pxa_camera_active_dma act_dma)
 {
-	struct device *dev = pcdev_to_dev(pcdev);
 	struct pxa_buffer *buf, *last_buf;
 	unsigned long flags;
 	u32 camera_status, overrun;
@@ -476,7 +483,7 @@ static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	camera_status = __raw_readl(pcdev->base + CISR);
-	dev_dbg(dev, "camera dma irq, cisr=0x%x dma=%d\n",
+	dev_dbg(pcdev_to_dev(pcdev), "camera dma irq, cisr=0x%x dma=%d\n",
 		camera_status, act_dma);
 	overrun = CISR_IFO_0;
 	if (pcdev->channels == 3)
@@ -522,7 +529,7 @@ static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 					       NULL, &last_issued);
 	if (camera_status & overrun &&
 	    last_status != DMA_COMPLETE) {
-		dev_dbg(dev, "FIFO overrun! CISR: %x\n",
+		dev_dbg(pcdev_to_dev(pcdev), "FIFO overrun! CISR: %x\n",
 			camera_status);
 		pxa_camera_stop_capture(pcdev);
 		list_for_each_entry(buf, &pcdev->capture, queue)
@@ -545,7 +552,6 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 			    struct pxa_camera_dev *pcdev)
 {
 	unsigned long mclk = pcdev->mclk;
-	struct device *dev = &pdev->dev;
 	u32 div;
 	unsigned long lcdclk;
 
@@ -555,7 +561,8 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 	/* mclk <= ciclk / 4 (27.4.2) */
 	if (mclk > lcdclk / 4) {
 		mclk = lcdclk / 4;
-		dev_warn(dev, "Limiting master clock to %lu\n", mclk);
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Limiting master clock to %lu\n", mclk);
 	}
 
 	/* We verify mclk != 0, so if anyone breaks it, here comes their Oops */
@@ -565,7 +572,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		pcdev->mclk = lcdclk / (2 * (div + 1));
 
-	dev_dbg(dev, "LCD clock %luHz, target freq %luHz, divisor %u\n",
+	dev_dbg(pcdev_to_dev(pcdev), "LCD clock %luHz, target freq %luHz, divisor %u\n",
 		lcdclk, mclk, div);
 
 	return div;
@@ -662,7 +669,9 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 
 static int pxa_camera_add_device(struct soc_camera_device *icd)
 {
-	dev_info(icd->parent, "PXA Camera driver attached to camera %d\n",
+	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
+
+	dev_info(pcdev_to_dev(pcdev), "PXA Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	return 0;
@@ -670,7 +679,9 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 
 static void pxa_camera_remove_device(struct soc_camera_device *icd)
 {
-	dev_info(icd->parent, "PXA Camera driver detached from camera %d\n",
+	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
+
+	dev_info(pcdev_to_dev(pcdev), "PXA Camera driver detached from camera %d\n",
 		 icd->devnum);
 }
 
@@ -1081,7 +1092,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
 		if (!common_flags) {
-			dev_warn(icd->parent,
+			dev_warn(pcdev_to_dev(pcdev),
 				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
 				 cfg.flags, bus_flags);
 			return -EINVAL;
@@ -1122,7 +1133,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 	cfg.flags = common_flags;
 	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
+		dev_dbg(pcdev_to_dev(pcdev), "camera s_mbus_config(0x%lx) returned %d\n",
 			common_flags, ret);
 		return ret;
 	}
@@ -1152,7 +1163,7 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
 		if (!common_flags) {
-			dev_warn(icd->parent,
+			dev_warn(pcdev_to_dev(pcdev),
 				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
 				 cfg.flags, bus_flags);
 			return -EINVAL;
@@ -1189,7 +1200,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 				  struct soc_camera_format_xlate *xlate)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->parent;
+	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
 	int formats = 0, ret;
 	struct pxa_cam *cam;
 	struct v4l2_subdev_mbus_code_enum code = {
@@ -1205,7 +1216,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 
 	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_err(dev, "Invalid format code #%u: %d\n", idx, code.code);
+		dev_err(pcdev_to_dev(pcdev), "Invalid format code #%u: %d\n", idx, code.code);
 		return 0;
 	}
 
@@ -1231,7 +1242,8 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 			xlate->host_fmt	= &pxa_camera_formats[0];
 			xlate->code	= code.code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using code %d\n",
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s using code %d\n",
 				pxa_camera_formats[0].name, code.code);
 		}
 	case MEDIA_BUS_FMT_VYUY8_2X8:
@@ -1240,14 +1252,15 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
 		if (xlate)
-			dev_dbg(dev, "Providing format %s packed\n",
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s packed\n",
 				fmt->name);
 		break;
 	default:
 		if (!pxa_camera_packing_supported(fmt))
 			return 0;
 		if (xlate)
-			dev_dbg(dev,
+			dev_dbg(pcdev_to_dev(pcdev),
 				"Providing format %s in pass-through mode\n",
 				fmt->name);
 	}
@@ -1305,7 +1318,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(dev, "Failed to crop to %ux%u@%u:%u\n",
+		dev_warn(pcdev_to_dev(pcdev), "Failed to crop to %ux%u@%u:%u\n",
 			 rect->width, rect->height, rect->left, rect->top);
 		return ret;
 	}
@@ -1327,7 +1340,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 			return ret;
 
 		if (pxa_camera_check_frame(mf->width, mf->height)) {
-			dev_warn(icd->parent,
+			dev_warn(pcdev_to_dev(pcdev),
 				 "Inconsistent state. Use S_FMT to repair\n");
 			return -EINVAL;
 		}
@@ -1335,7 +1348,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 
 	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(dev,
+			dev_err(pcdev_to_dev(pcdev),
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1372,7 +1385,8 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -1395,16 +1409,17 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(dev, "Failed to configure for format %x\n",
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Failed to configure for format %x\n",
 			 pix->pixelformat);
 	} else if (pxa_camera_check_frame(mf->width, mf->height)) {
-		dev_warn(dev,
+		dev_warn(pcdev_to_dev(pcdev),
 			 "Camera driver produced an unsupported frame %dx%d\n",
 			 mf->width, mf->height);
 		ret = -EINVAL;
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(dev,
+			dev_err(pcdev_to_dev(pcdev),
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1428,6 +1443,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev_pad_config pad_cfg;
@@ -1440,7 +1456,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
+		dev_warn(pcdev_to_dev(pcdev), "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1477,7 +1493,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		break;
 	default:
 		/* TODO: support interlaced at least in pass-through mode */
-		dev_err(icd->parent, "Field type %d unsupported.\n",
+		dev_err(pcdev_to_dev(pcdev), "Field type %d unsupported.\n",
 			mf->field);
 		return -EINVAL;
 	}
@@ -1586,13 +1602,13 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 
 	np = of_graph_get_next_endpoint(np, NULL);
 	if (!np) {
-		dev_err(dev, "could not find endpoint\n");
+		dev_err(pcdev_to_dev(pcdev), "could not find endpoint\n");
 		return -EINVAL;
 	}
 
 	err = v4l2_of_parse_endpoint(np, &ep);
 	if (err) {
-		dev_err(dev, "could not parse endpoint\n");
+		dev_err(pcdev_to_dev(pcdev), "could not parse endpoint\n");
 		goto out;
 	}
 
-- 
2.1.4

