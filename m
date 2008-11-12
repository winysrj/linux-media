Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVnLA022472
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:49 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVaVm027073
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:36 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:35 +0100
Message-Id: <1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 04/13] soc-camera: simplify naming
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

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

We anyway don't follow the s_fmt_vid_cap / g_fmt_vid_cap / try_fmt_vid_cap
naming, and soc-camera is so far only about video capture, let's simplify
operation names a bit further. set_fmt_cap / try_fmt_cap wasn't a very good
choice too.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c              |   14 +++++++-------
 drivers/media/video/mt9m111.c              |   12 ++++++------
 drivers/media/video/mt9v022.c              |   14 +++++++-------
 drivers/media/video/pxa_camera.c           |   16 ++++++++--------
 drivers/media/video/sh_mobile_ceu_camera.c |   16 ++++++++--------
 drivers/media/video/soc_camera.c           |    6 +++---
 drivers/media/video/soc_camera_platform.c  |   12 ++++++------
 include/media/soc_camera.h                 |   10 ++++------
 8 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 0c52437..0bcfef7 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -285,8 +285,8 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 		width_flag;
 }
 
-static int mt9m001_set_fmt_cap(struct soc_camera_device *icd,
-		__u32 pixfmt, struct v4l2_rect *rect)
+static int mt9m001_set_fmt(struct soc_camera_device *icd,
+			   __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
 	int ret;
@@ -298,7 +298,7 @@ static int mt9m001_set_fmt_cap(struct soc_camera_device *icd,
 		ret = reg_write(icd, MT9M001_VERTICAL_BLANKING, vblank);
 
 	/* The caller provides a supported format, as verified per
-	 * call to icd->try_fmt_cap() */
+	 * call to icd->try_fmt() */
 	if (!ret)
 		ret = reg_write(icd, MT9M001_COLUMN_START, rect->left);
 	if (!ret)
@@ -325,8 +325,8 @@ static int mt9m001_set_fmt_cap(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int mt9m001_try_fmt_cap(struct soc_camera_device *icd,
-			       struct v4l2_format *f)
+static int mt9m001_try_fmt(struct soc_camera_device *icd,
+			   struct v4l2_format *f)
 {
 	if (f->fmt.pix.height < 32 + icd->y_skip_top)
 		f->fmt.pix.height = 32 + icd->y_skip_top;
@@ -447,8 +447,8 @@ static struct soc_camera_ops mt9m001_ops = {
 	.release		= mt9m001_release,
 	.start_capture		= mt9m001_start_capture,
 	.stop_capture		= mt9m001_stop_capture,
-	.set_fmt_cap		= mt9m001_set_fmt_cap,
-	.try_fmt_cap		= mt9m001_try_fmt_cap,
+	.set_fmt		= mt9m001_set_fmt,
+	.try_fmt		= mt9m001_try_fmt,
 	.set_bus_param		= mt9m001_set_bus_param,
 	.query_bus_param	= mt9m001_query_bus_param,
 	.controls		= mt9m001_controls,
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 208ec6c..8062be5 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -475,8 +475,8 @@ static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 	return ret;
 }
 
-static int mt9m111_set_fmt_cap(struct soc_camera_device *icd,
-			       __u32 pixfmt, struct v4l2_rect *rect)
+static int mt9m111_set_fmt(struct soc_camera_device *icd,
+			   __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	int ret;
@@ -496,8 +496,8 @@ static int mt9m111_set_fmt_cap(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int mt9m111_try_fmt_cap(struct soc_camera_device *icd,
-			       struct v4l2_format *f)
+static int mt9m111_try_fmt(struct soc_camera_device *icd,
+			   struct v4l2_format *f)
 {
 	if (f->fmt.pix.height > MT9M111_MAX_HEIGHT)
 		f->fmt.pix.height = MT9M111_MAX_HEIGHT;
@@ -620,8 +620,8 @@ static struct soc_camera_ops mt9m111_ops = {
 	.release		= mt9m111_release,
 	.start_capture		= mt9m111_start_capture,
 	.stop_capture		= mt9m111_stop_capture,
-	.set_fmt_cap		= mt9m111_set_fmt_cap,
-	.try_fmt_cap		= mt9m111_try_fmt_cap,
+	.set_fmt		= mt9m111_set_fmt,
+	.try_fmt		= mt9m111_try_fmt,
 	.query_bus_param	= mt9m111_query_bus_param,
 	.set_bus_param		= mt9m111_set_bus_param,
 	.controls		= mt9m111_controls,
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 2584201..3a39f02 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -337,14 +337,14 @@ static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 		width_flag;
 }
 
-static int mt9v022_set_fmt_cap(struct soc_camera_device *icd,
-		__u32 pixfmt, struct v4l2_rect *rect)
+static int mt9v022_set_fmt(struct soc_camera_device *icd,
+			   __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
 	int ret;
 
 	/* The caller provides a supported format, as verified per call to
-	 * icd->try_fmt_cap(), datawidth is from our supported format list */
+	 * icd->try_fmt(), datawidth is from our supported format list */
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
@@ -400,8 +400,8 @@ static int mt9v022_set_fmt_cap(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9v022_try_fmt_cap(struct soc_camera_device *icd,
-			       struct v4l2_format *f)
+static int mt9v022_try_fmt(struct soc_camera_device *icd,
+			   struct v4l2_format *f)
 {
 	if (f->fmt.pix.height < 32 + icd->y_skip_top)
 		f->fmt.pix.height = 32 + icd->y_skip_top;
@@ -538,8 +538,8 @@ static struct soc_camera_ops mt9v022_ops = {
 	.release		= mt9v022_release,
 	.start_capture		= mt9v022_start_capture,
 	.stop_capture		= mt9v022_stop_capture,
-	.set_fmt_cap		= mt9v022_set_fmt_cap,
-	.try_fmt_cap		= mt9v022_try_fmt_cap,
+	.set_fmt		= mt9v022_set_fmt,
+	.try_fmt		= mt9v022_try_fmt,
 	.set_bus_param		= mt9v022_set_bus_param,
 	.query_bus_param	= mt9v022_query_bus_param,
 	.controls		= mt9v022_controls,
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index a375872..665eef2 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -904,8 +904,8 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
 }
 
-static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
-				  __u32 pixfmt, struct v4l2_rect *rect)
+static int pxa_camera_set_fmt(struct soc_camera_device *icd,
+			      __u32 pixfmt, struct v4l2_rect *rect)
 {
 	const struct soc_camera_data_format *cam_fmt;
 	int ret;
@@ -920,15 +920,15 @@ static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
 			return -EINVAL;
 	}
 
-	ret = icd->ops->set_fmt_cap(icd, pixfmt, rect);
+	ret = icd->ops->set_fmt(icd, pixfmt, rect);
 	if (pixfmt && !ret)
 		icd->current_fmt = cam_fmt;
 
 	return ret;
 }
 
-static int pxa_camera_try_fmt_cap(struct soc_camera_device *icd,
-				  struct v4l2_format *f)
+static int pxa_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
 {
 	const struct soc_camera_data_format *cam_fmt;
 	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
@@ -960,7 +960,7 @@ static int pxa_camera_try_fmt_cap(struct soc_camera_device *icd,
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 
 	/* limit to sensor capabilities */
-	return icd->ops->try_fmt_cap(icd, f);
+	return icd->ops->try_fmt(icd, f);
 }
 
 static int pxa_camera_reqbufs(struct soc_camera_file *icf,
@@ -1068,8 +1068,8 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.remove		= pxa_camera_remove_device,
 	.suspend	= pxa_camera_suspend,
 	.resume		= pxa_camera_resume,
-	.set_fmt_cap	= pxa_camera_set_fmt_cap,
-	.try_fmt_cap	= pxa_camera_try_fmt_cap,
+	.set_fmt	= pxa_camera_set_fmt,
+	.try_fmt	= pxa_camera_try_fmt,
 	.init_videobuf	= pxa_camera_init_videobuf,
 	.reqbufs	= pxa_camera_reqbufs,
 	.poll		= pxa_camera_poll,
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 1bacfc7..367c4eb 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -444,8 +444,8 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int sh_mobile_ceu_set_fmt_cap(struct soc_camera_device *icd,
-				     __u32 pixfmt, struct v4l2_rect *rect)
+static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
+				 __u32 pixfmt, struct v4l2_rect *rect)
 {
 	const struct soc_camera_data_format *cam_fmt;
 	int ret;
@@ -460,15 +460,15 @@ static int sh_mobile_ceu_set_fmt_cap(struct soc_camera_device *icd,
 			return -EINVAL;
 	}
 
-	ret = icd->ops->set_fmt_cap(icd, pixfmt, rect);
+	ret = icd->ops->set_fmt(icd, pixfmt, rect);
 	if (pixfmt && !ret)
 		icd->current_fmt = cam_fmt;
 
 	return ret;
 }
 
-static int sh_mobile_ceu_try_fmt_cap(struct soc_camera_device *icd,
-				     struct v4l2_format *f)
+static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
+				 struct v4l2_format *f)
 {
 	const struct soc_camera_data_format *cam_fmt;
 	int ret = sh_mobile_ceu_try_bus_param(icd, f->fmt.pix.pixelformat);
@@ -502,7 +502,7 @@ static int sh_mobile_ceu_try_fmt_cap(struct soc_camera_device *icd,
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 
 	/* limit to sensor capabilities */
-	return icd->ops->try_fmt_cap(icd, f);
+	return icd->ops->try_fmt(icd, f);
 }
 
 static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,
@@ -570,8 +570,8 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= sh_mobile_ceu_add_device,
 	.remove		= sh_mobile_ceu_remove_device,
-	.set_fmt_cap	= sh_mobile_ceu_set_fmt_cap,
-	.try_fmt_cap	= sh_mobile_ceu_try_fmt_cap,
+	.set_fmt	= sh_mobile_ceu_set_fmt,
+	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index afadb33..7304e73 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -73,7 +73,7 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 	}
 
 	/* limit format to hardware capabilities */
-	ret = ici->ops->try_fmt_cap(icd, f);
+	ret = ici->ops->try_fmt(icd, f);
 
 	return ret;
 }
@@ -324,7 +324,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	rect.top	= icd->y_current;
 	rect.width	= f->fmt.pix.width;
 	rect.height	= f->fmt.pix.height;
-	ret = ici->ops->set_fmt_cap(icd, f->fmt.pix.pixelformat, &rect);
+	ret = ici->ops->set_fmt(icd, f->fmt.pix.pixelformat, &rect);
 	if (ret < 0) {
 		return ret;
 	} else if (!icd->current_fmt ||
@@ -553,7 +553,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	ret = ici->ops->set_fmt_cap(icd, 0, &a->c);
+	ret = ici->ops->set_fmt(icd, 0, &a->c);
 	if (!ret) {
 		icd->width	= a->c.width;
 		icd->height	= a->c.height;
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index bb7a9d4..c23871e 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -79,14 +79,14 @@ soc_camera_platform_query_bus_param(struct soc_camera_device *icd)
 	return p->bus_param;
 }
 
-static int soc_camera_platform_set_fmt_cap(struct soc_camera_device *icd,
-					   __u32 pixfmt, struct v4l2_rect *rect)
+static int soc_camera_platform_set_fmt(struct soc_camera_device *icd,
+				       __u32 pixfmt, struct v4l2_rect *rect)
 {
 	return 0;
 }
 
-static int soc_camera_platform_try_fmt_cap(struct soc_camera_device *icd,
-					   struct v4l2_format *f)
+static int soc_camera_platform_try_fmt(struct soc_camera_device *icd,
+				       struct v4l2_format *f)
 {
 	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
 
@@ -124,8 +124,8 @@ static struct soc_camera_ops soc_camera_platform_ops = {
 	.release		= soc_camera_platform_release,
 	.start_capture		= soc_camera_platform_start_capture,
 	.stop_capture		= soc_camera_platform_stop_capture,
-	.set_fmt_cap		= soc_camera_platform_set_fmt_cap,
-	.try_fmt_cap		= soc_camera_platform_try_fmt_cap,
+	.set_fmt		= soc_camera_platform_set_fmt,
+	.try_fmt		= soc_camera_platform_try_fmt,
 	.set_bus_param		= soc_camera_platform_set_bus_param,
 	.query_bus_param	= soc_camera_platform_query_bus_param,
 };
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index c9b2b7f..64eb4b5 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -66,9 +66,8 @@ struct soc_camera_host_ops {
 	void (*remove)(struct soc_camera_device *);
 	int (*suspend)(struct soc_camera_device *, pm_message_t state);
 	int (*resume)(struct soc_camera_device *);
-	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
-			   struct v4l2_rect *);
-	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
+	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
+	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
 			      struct soc_camera_device *);
 	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
@@ -125,9 +124,8 @@ struct soc_camera_ops {
 	int (*release)(struct soc_camera_device *);
 	int (*start_capture)(struct soc_camera_device *);
 	int (*stop_capture)(struct soc_camera_device *);
-	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
-			   struct v4l2_rect *);
-	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
+	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
+	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 	int (*get_chip_id)(struct soc_camera_device *,
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
