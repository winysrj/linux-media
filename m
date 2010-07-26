Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:40449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754148Ab0GZQUu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:20:50 -0400
Date: Mon, 26 Jul 2010 18:21:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH 5/5] V4L2: sh_mobile_camera_ceu: add support for CSI2
In-Reply-To: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
Message-ID: <Pine.LNX.4.64.1007261811410.9816@axis700.grange>
References: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using CEU with CSI2 on SH-Mobile requires some special configuration of the
former. We also have to switch from calling only one subdev .s_mbus_fmt and
.try_mbus_fmt to calling all subdevices. Take care to increment CSI2 driver
use count to prevent it from unloading, while in use.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |  131 ++++++++++++++++++++++++---
 include/media/sh_mobile_ceu.h              |    3 +
 2 files changed, 119 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index d40b1e0..edaedf9 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -633,6 +633,12 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 		cdwdr_width *= 2;
 	}
 
+	/* CSI2 special configuration */
+	if (pcdev->pdata->csi2_dev) {
+		in_width = ((in_width - 2) * 2);
+		left_offset *= 2;
+	}
+
 	/* Set CAMOR, CAPWR, CFSZR, take care of CDWDR */
 	camor = left_offset | (top_offset << 16);
 
@@ -767,6 +773,11 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
 	value |= common_flags & SOCAM_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
 	value |= pcdev->is_16bit ? 1 << 12 : 0;
+
+	/* CSI2 mode */
+	if (pcdev->pdata->csi2_dev)
+		value |= 3 << 12;
+
 	ceu_write(pcdev, CAMCR, value);
 
 	ceu_write(pcdev, CAPCR, 0x00300000);
@@ -883,6 +894,8 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int ret, k, n;
 	int formats = 0;
 	struct sh_mobile_ceu_cam *cam;
@@ -896,19 +909,19 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
-		dev_err(icd->dev.parent,
-			"Invalid format code #%u: %d\n", idx, code);
+		dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
 		return -EINVAL;
 	}
 
-	ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
-	if (ret < 0)
-		return 0;
+	if (!pcdev->pdata->csi2_dev) {
+		ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
+		if (ret < 0)
+			return 0;
+	}
 
 	if (!icd->host_priv) {
 		struct v4l2_mbus_framefmt mf;
 		struct v4l2_rect rect;
-		struct device *dev = icd->dev.parent;
 		int shift = 0;
 
 		/* FIXME: subwindow is lost between close / open */
@@ -927,7 +940,8 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 			/* Try 2560x1920, 1280x960, 640x480, 320x240 */
 			mf.width	= 2560 >> shift;
 			mf.height	= 1920 >> shift;
-			ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+			ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+							 s_mbus_fmt, &mf);
 			if (ret < 0)
 				return ret;
 			shift++;
@@ -1228,7 +1242,8 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	struct v4l2_cropcap cap;
 	int ret;
 
-	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
+	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+					 s_mbus_fmt, mf);
 	if (ret < 0)
 		return ret;
 
@@ -1257,7 +1272,8 @@ static int client_s_fmt(struct soc_camera_device *icd,
 		tmp_h = min(2 * tmp_h, max_height);
 		mf->width = tmp_w;
 		mf->height = tmp_h;
-		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
+		ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+						 s_mbus_fmt, mf);
 		dev_geo(dev, "Camera scaled to %ux%u\n",
 			mf->width, mf->height);
 		if (ret < 0) {
@@ -1514,7 +1530,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct device *dev = icd->dev.parent;
 	__u32 pixfmt = pix->pixelformat;
 	const struct soc_camera_format_xlate *xlate;
-	unsigned int ceu_sub_width, ceu_sub_height;
+	/* Keep Compiler Happy */
+	unsigned int ceu_sub_width = 0, ceu_sub_height = 0;
 	u16 scale_v, scale_h;
 	int ret;
 	bool image_mode;
@@ -1569,8 +1586,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 
 	/* Done with the camera. Now see if we can improve the result */
 
-	dev_geo(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
-		ret, mf.width, mf.height, pix->width, pix->height);
+	dev_geo(dev, "fmt %ux%u, requested %ux%u\n",
+		mf.width, mf.height, pix->width, pix->height);
 	if (ret < 0)
 		return ret;
 
@@ -1634,6 +1651,9 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	int width, height;
 	int ret;
 
+	dev_geo(icd->dev.parent, "TRY_FMT(pix=0x%x, %ux%u)\n",
+		 pixfmt, pix->width, pix->height);
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
@@ -1660,7 +1680,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	mf.code		= xlate->code;
 	mf.colorspace	= pix->colorspace;
 
-	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video, try_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
@@ -1684,7 +1704,8 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			 */
 			mf.width = 2560;
 			mf.height = 1920;
-			ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+			ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+							 try_mbus_fmt, &mf);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
 				dev_err(icd->dev.parent,
@@ -1699,6 +1720,9 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			pix->height = height;
 	}
 
+	dev_geo(icd->dev.parent, "%s(): return %d, fmt 0x%x, %ux%u\n",
+		__func__, ret, pix->pixelformat, pix->width, pix->height);
+
 	return ret;
 }
 
@@ -1853,6 +1877,30 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.num_controls	= ARRAY_SIZE(sh_mobile_ceu_controls),
 };
 
+struct bus_wait {
+	struct notifier_block	notifier;
+	struct completion	completion;
+	struct device		*dev;
+};
+
+static int bus_notify(struct notifier_block *nb,
+		      unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct bus_wait *wait = container_of(nb, struct bus_wait, notifier);
+
+	if (wait->dev != dev)
+		return NOTIFY_DONE;
+
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		/* Protect from module unloading */
+		wait_for_completion(&wait->completion);
+		return NOTIFY_OK;
+	}
+	return NOTIFY_DONE;
+}
+
 static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 {
 	struct sh_mobile_ceu_dev *pcdev;
@@ -1860,6 +1908,11 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 	void __iomem *base;
 	unsigned int irq;
 	int err = 0;
+	struct bus_wait wait = {
+		.completion = COMPLETION_INITIALIZER_ONSTACK(wait.completion),
+		.notifier.notifier_call = bus_notify,
+	};
+	struct device *csi2;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -1931,12 +1984,54 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.drv_name = dev_name(&pdev->dev);
 	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
 
+	/* CSI2 interfacing */
+	csi2 = pcdev->pdata->csi2_dev;
+	if (csi2) {
+		wait.dev = csi2;
+
+		err = bus_register_notifier(&platform_bus_type, &wait.notifier);
+		if (err < 0)
+			goto exit_free_clk;
+
+		/*
+		 * From this point the driver module will not unload, until
+		 * we complete the completion.
+		 */
+
+		if (!csi2->driver || !csi2->driver->owner) {
+			complete(&wait.completion);
+			/* Either too late, or probing failed */
+			bus_unregister_notifier(&platform_bus_type, &wait.notifier);
+			err = -ENXIO;
+			goto exit_free_clk;
+		}
+
+		/*
+		 * The module is still loaded, in the worst case it is hanging
+		 * in device release on our completion. So, _now_ dereferencing
+		 * the "owner" is safe!
+		 */
+
+		err = try_module_get(csi2->driver->owner);
+
+		/* Let notifier complete, if it has been locked */
+		complete(&wait.completion);
+		bus_unregister_notifier(&platform_bus_type, &wait.notifier);
+		if (!err) {
+			err = -ENODEV;
+			goto exit_free_clk;
+		}
+	}
+
 	err = soc_camera_host_register(&pcdev->ici);
 	if (err)
-		goto exit_free_clk;
+		goto exit_module_put;
 
 	return 0;
 
+exit_module_put:
+	if (csi2 && csi2->driver)
+		module_put(csi2->driver->owner);
 exit_free_clk:
 	pm_runtime_disable(&pdev->dev);
 	free_irq(pcdev->irq, pcdev);
@@ -1956,6 +2051,7 @@ static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct sh_mobile_ceu_dev *pcdev = container_of(soc_host,
 					struct sh_mobile_ceu_dev, ici);
+	struct device *csi2 = pcdev->pdata->csi2_dev;
 
 	soc_camera_host_unregister(soc_host);
 	pm_runtime_disable(&pdev->dev);
@@ -1963,7 +2059,10 @@ static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
 	iounmap(pcdev->base);
+	if (csi2 && csi2->driver)
+		module_put(csi2->driver->owner);
 	kfree(pcdev);
+
 	return 0;
 }
 
@@ -1995,6 +2094,8 @@ static struct platform_driver sh_mobile_ceu_driver = {
 
 static int __init sh_mobile_ceu_init(void)
 {
+	/* Whatever return code */
+	request_module("sh_mobile_csi2");
 	return platform_driver_register(&sh_mobile_ceu_driver);
 }
 
diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
index b677478..80346a6 100644
--- a/include/media/sh_mobile_ceu.h
+++ b/include/media/sh_mobile_ceu.h
@@ -6,8 +6,11 @@
 #define SH_CEU_FLAG_HSYNC_LOW		(1 << 2) /* default High if possible */
 #define SH_CEU_FLAG_VSYNC_LOW		(1 << 3) /* default High if possible */
 
+struct device;
+
 struct sh_mobile_ceu_info {
 	unsigned long flags;
+	struct device *csi2_dev;
 };
 
 #endif /* __ASM_SH_MOBILE_CEU_H__ */
-- 
1.6.2.4

