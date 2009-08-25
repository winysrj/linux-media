Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59861 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753487AbZHYLF6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 07:05:58 -0400
Date: Tue, 25 Aug 2009 13:06:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/3] soc-camera: fix recently introduced overlong lines
In-Reply-To: <Pine.LNX.4.64.0908251258410.4810@axis700.grange>
Message-ID: <Pine.LNX.4.64.0908251303240.4810@axis700.grange>
References: <Pine.LNX.4.64.0908251258410.4810@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/boards/board-ap325rxa.c           |    3 ++-
 drivers/media/video/mt9m111.c             |    9 +++++----
 drivers/media/video/mt9v022.c             |    5 ++++-
 drivers/media/video/mx1_camera.c          |    3 ++-
 drivers/media/video/ov772x.c              |    6 ++++--
 drivers/media/video/pxa_camera.c          |    3 ++-
 drivers/media/video/soc_camera.c          |   14 +++++++++++---
 drivers/media/video/soc_camera_platform.c |    3 ++-
 drivers/media/video/tw9910.c              |    3 ++-
 include/media/soc_camera.h                |   15 ++++++++++-----
 10 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index e6a6428..b633b25 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -359,7 +359,8 @@ static void ap325rxa_camera_del(struct soc_camera_link *icl)
 		return;
 
 	platform_device_unregister(&camera_device);
-	memset(&migor_camera_device.dev.kobj, 0, sizeof(migor_camera_device.dev.kobj));
+	memset(&migor_camera_device.dev.kobj, 0,
+	       sizeof(migor_camera_device.dev.kobj));
 }
 #endif /* CONFIG_I2C */
 
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 3ec6e4a..90da699 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -514,7 +514,8 @@ static int mt9m111_set_pixfmt(struct i2c_client *client, u32 pixfmt)
 		ret = mt9m111_setfmt_yuv(client);
 		break;
 	default:
-		dev_err(&client->dev, "Pixel format not handled : %x\n", pixfmt);
+		dev_err(&client->dev, "Pixel format not handled : %x\n",
+			pixfmt);
 		ret = -EINVAL;
 	}
 
@@ -537,9 +538,9 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	};
 	int ret;
 
-	dev_dbg(&client->dev, "%s fmt=%x left=%d, top=%d, width=%d, height=%d\n",
-		__func__, pix->pixelformat, rect.left, rect.top, rect.width,
-		rect.height);
+	dev_dbg(&client->dev,
+		"%s fmt=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
+		pix->pixelformat, rect.left, rect.top, rect.width, rect.height);
 
 	ret = mt9m111_make_rect(client, &rect);
 	if (!ret)
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 2bfb26b..995607f 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -847,7 +847,10 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
 
 	icd->ops		= &mt9v022_ops;
-	/* MT9V022 _really_ corrupts the first read out line. TODO: verify on i.MX31 */
+	/*
+	 * MT9V022 _really_ corrupts the first read out line.
+	 * TODO: verify on i.MX31
+	 */
 	icd->y_skip_top		= 1;
 
 	mt9v022->rect.left	= MT9V022_COLUMN_SKIP;
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 3875483..5f37952 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -548,7 +548,8 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pix->pixelformat);
+		dev_warn(icd->dev.parent, "Format %x not found\n",
+			 pix->pixelformat);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 776a91d..eccb40a 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -404,7 +404,8 @@ struct ov772x_priv {
 	int                               model;
 	unsigned short                    flag_vflip:1;
 	unsigned short                    flag_hflip:1;
-	unsigned short                    band_filter;	/* 256 - BDBASE, 0 if (!COM8[5]) */
+	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
+	unsigned short                    band_filter;
 };
 
 #define ENDMARKER { 0xff, 0xff }
@@ -587,7 +588,8 @@ static const struct v4l2_queryctrl ov772x_controls[] = {
 
 static struct ov772x_priv *to_ov772x(const struct i2c_client *client)
 {
-	return container_of(i2c_get_clientdata(client), struct ov772x_priv, subdev);
+	return container_of(i2c_get_clientdata(client), struct ov772x_priv,
+			    subdev);
 }
 
 static int ov772x_write_array(struct i2c_client        *client,
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index a19bb76..6952e96 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -274,7 +274,8 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 
 	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
 		if (buf->dmas[i].sg_cpu)
-			dma_free_coherent(ici->v4l2_dev.dev, buf->dmas[i].sg_size,
+			dma_free_coherent(ici->v4l2_dev.dev,
+					  buf->dmas[i].sg_size,
 					  buf->dmas[i].sg_cpu,
 					  buf->dmas[i].sg_dma);
 		buf->dmas[i].sg_cpu = NULL;
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 95dfa43..e8248ba 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -327,7 +327,9 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 static int soc_camera_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct soc_camera_device *icd = container_of(vdev->parent, struct soc_camera_device, dev);
+	struct soc_camera_device *icd = container_of(vdev->parent,
+						     struct soc_camera_device,
+						     dev);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct soc_camera_host *ici;
 	struct soc_camera_file *icf;
@@ -349,7 +351,10 @@ static int soc_camera_open(struct file *file)
 		goto emgi;
 	}
 
-	/* Protect against icd->ops->remove() until we module_get() both drivers. */
+	/*
+	 * Protect against icd->ops->remove() until we module_get() both
+	 * drivers.
+	 */
 	mutex_lock(&icd->video_lock);
 
 	icf->icd = icd;
@@ -931,7 +936,10 @@ static int soc_camera_probe(struct device *dev)
 		if (ret < 0)
 			goto eadddev;
 
-		/* FIXME: this is racy, have to use driver-binding notification */
+		/*
+		 * FIXME: this is racy, have to use driver-binding notification,
+		 * when it is available
+		 */
 		control = to_soc_camera_control(icd);
 		if (!control || !control->driver || !dev_get_drvdata(control) ||
 		    !try_module_get(control->driver->owner)) {
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 3825c35..1b6dd02 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -33,7 +33,8 @@ static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
 
 static struct soc_camera_platform_info *get_info(struct soc_camera_device *icd)
 {
-	struct platform_device *pdev = to_platform_device(to_soc_camera_control(icd));
+	struct platform_device *pdev =
+		to_platform_device(to_soc_camera_control(icd));
 	return pdev->dev.platform_data;
 }
 
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index fbf4130..269ab04 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -357,7 +357,8 @@ static const struct tw9910_hsync_ctrl tw9910_hsync_ctrl = {
  */
 static struct tw9910_priv *to_tw9910(const struct i2c_client *client)
 {
-	return container_of(i2c_get_clientdata(client), struct tw9910_priv, subdev);
+	return container_of(i2c_get_clientdata(client), struct tw9910_priv,
+			    subdev);
 }
 
 static int tw9910_set_scale(struct i2c_client *client,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index fe20e33..3d74e60 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -126,29 +126,34 @@ struct soc_camera_link {
 	void (*free_bus)(struct soc_camera_link *);
 };
 
-static inline struct soc_camera_device *to_soc_camera_dev(const struct device *dev)
+static inline struct soc_camera_device *to_soc_camera_dev(
+	const struct device *dev)
 {
 	return container_of(dev, struct soc_camera_device, dev);
 }
 
-static inline struct soc_camera_host *to_soc_camera_host(const struct device *dev)
+static inline struct soc_camera_host *to_soc_camera_host(
+	const struct device *dev)
 {
 	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
 
 	return container_of(v4l2_dev, struct soc_camera_host, v4l2_dev);
 }
 
-static inline struct soc_camera_link *to_soc_camera_link(const struct soc_camera_device *icd)
+static inline struct soc_camera_link *to_soc_camera_link(
+	const struct soc_camera_device *icd)
 {
 	return icd->dev.platform_data;
 }
 
-static inline struct device *to_soc_camera_control(const struct soc_camera_device *icd)
+static inline struct device *to_soc_camera_control(
+	const struct soc_camera_device *icd)
 {
 	return dev_get_drvdata(&icd->dev);
 }
 
-static inline struct v4l2_subdev *soc_camera_to_subdev(const struct soc_camera_device *icd)
+static inline struct v4l2_subdev *soc_camera_to_subdev(
+	const struct soc_camera_device *icd)
 {
 	struct device *control = to_soc_camera_control(icd);
 	return dev_get_drvdata(control);
-- 
1.6.2.4

