Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62378 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1LUPtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 10:49:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 4225F18B04B
	for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 16:49:05 +0100 (CET)
Date: Wed, 21 Dec 2011 16:49:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: remove redundant parameter from the
 .set_bus_param() method
Message-ID: <Pine.LNX.4.64.1112211647120.30646@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "pixfmt" parameter of the struct soc_camera_host_ops::set_bus_param()
method is redundant, because at the time, when this method is called,
pixfmt is guaranteed to be equal to icd->current_fmt->host_fmt->fourcc.
Remove this parameter and update all drivers accordingly.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Will be pushed to 3.3 in a day or two, unless there are objections

 drivers/media/video/atmel-isi.c            |    2 +-
 drivers/media/video/mx1_camera.c           |    2 +-
 drivers/media/video/mx2_camera.c           |    3 +--
 drivers/media/video/mx3_camera.c           |    3 ++-
 drivers/media/video/omap1_camera.c         |    4 ++--
 drivers/media/video/pxa_camera.c           |    3 ++-
 drivers/media/video/sh_mobile_ceu_camera.c |   11 ++---------
 drivers/media/video/soc_camera.c           |    2 +-
 include/media/soc_camera.h                 |    2 +-
 9 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index fbc904f..b25bd7b 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -803,7 +803,7 @@ static int isi_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
+static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 18e94c7..055d11d 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -487,7 +487,7 @@ static int mx1_camera_set_crop(struct soc_camera_device *icd,
 	return v4l2_subdev_call(sd, video, s_crop, a);
 }
 
-static int mx1_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+static int mx1_camera_set_bus_param(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index a803d9e..ffbfbfe 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -766,8 +766,7 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 			pcdev->base_emma + PRP_INTR_CNTL);
 }
 
-static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
-		__u32 pixfmt)
+static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index f96f92f..ba00474 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -982,12 +982,13 @@ static int mx3_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+static int mx3_camera_set_bus_param(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	u32 pixfmt = icd->current_fmt->host_fmt->fourcc;
 	unsigned long bus_flags, common_flags;
 	u32 dw, sens_conf;
 	const struct soc_mbus_pixelfmt *fmt;
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index 6a6cf38..946ee55 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -1436,13 +1436,13 @@ static int omap1_cam_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static int omap1_cam_set_bus_param(struct soc_camera_device *icd,
-		__u32 pixfmt)
+static int omap1_cam_set_bus_param(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
+	u32 pixfmt = icd->current_fmt->host_fmt->fourcc;
 	const struct soc_camera_format_xlate *xlate;
 	const struct soc_mbus_pixelfmt *fmt;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 79fb22c..2f9ae63 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1133,12 +1133,13 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	__raw_writel(cicr0, pcdev->base + CICR0);
 }
 
-static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	u32 pixfmt = icd->current_fmt->host_fmt->fourcc;
 	unsigned long bus_flags, common_flags;
 	int ret;
 	struct pxa_cam *cam = icd->host_priv;
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index f390682..c0a106d 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -784,8 +784,7 @@ static struct v4l2_subdev *find_bus_subdev(struct sh_mobile_ceu_dev *pcdev,
 		V4L2_MBUS_DATA_ACTIVE_HIGH)
 
 /* Capture is not running, no interrupts, no locking needed */
-static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
-				       __u32 pixfmt)
+static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
@@ -923,11 +922,6 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	ceu_write(pcdev, CDOCR, value);
 	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */
 
-	dev_dbg(icd->parent, "S_FMT successful for %c%c%c%c %ux%u\n",
-		pixfmt & 0xff, (pixfmt >> 8) & 0xff,
-		(pixfmt >> 16) & 0xff, (pixfmt >> 24) & 0xff,
-		icd->user_width, icd->user_height);
-
 	capture_restore(pcdev, capsr);
 
 	/* not in bundle mode: skip CBDSR, CDAYR2, CDACR2, CDBYR2, CDBCR2 */
@@ -1958,8 +1952,7 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 		if (!ret) {
 			icd->user_width		= out_width & ~3;
 			icd->user_height	= out_height & ~3;
-			ret = sh_mobile_ceu_set_bus_param(icd,
-					icd->current_fmt->host_fmt->fourcc);
+			ret = sh_mobile_ceu_set_bus_param(icd);
 		}
 	}
 
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index b72580c..69f6dc3 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -487,7 +487,7 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 		icd->user_width, icd->user_height);
 
 	/* set physical bus parameters */
-	return ici->ops->set_bus_param(icd, pix->pixelformat);
+	return ici->ops->set_bus_param(icd);
 }
 
 static int soc_camera_open(struct file *file)
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b1377b9..291ff622 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -94,7 +94,7 @@ struct soc_camera_host_ops {
 			      struct soc_camera_device *);
 	int (*reqbufs)(struct soc_camera_device *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
-	int (*set_bus_param)(struct soc_camera_device *, __u32);
+	int (*set_bus_param)(struct soc_camera_device *);
 	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*enum_fsizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
-- 
1.7.2.5

