Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOJT9xB021944
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 14:29:09 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOJSunU024780
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 14:28:56 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Date: Mon, 24 Nov 2008 20:28:47 +0100
Message-Id: <1227554928-25471-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
References: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: [PATCH 1/2] soc_camera: add format translation structure
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

Camera hosts rely on sensor formats available, as well as
host specific translations. We add a structure so that hosts
can define a translation table and use it for format check
and setup.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/soc_camera.c |   42 ++++++++++++++++++++++++++-----------
 include/media/soc_camera.h       |   23 ++++++++++++++++++--
 2 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index f5a1e5a..c7c1ae5 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -47,6 +47,18 @@ const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 }
 EXPORT_SYMBOL(soc_camera_format_by_fourcc);
 
+const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
+	struct soc_camera_device *icd, unsigned int fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; i < icd->num_user_formats; i++)
+		if (icd->user_formats[i].host_fmt->fourcc == fourcc)
+			return icd->user_formats + i;
+	return NULL;
+}
+EXPORT_SYMBOL(soc_camera_xlate_by_fourcc);
+
 static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 				      struct v4l2_format *f)
 {
@@ -183,8 +195,8 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	if (!fmts)
 		return -ENXIO;
 
-	icd->user_formats = vmalloc(sizeof(struct soc_camera_data_format *) *
-				    fmts);
+	icd->user_formats =
+		vmalloc(fmts * sizeof(struct soc_camera_format_xlate));
 	if (!icd->user_formats)
 		return -ENOMEM;
 
@@ -195,13 +207,16 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 
 	/* Second pass - actually fill data formats */
 	for (i = 0; i < icd->num_formats; i++)
-		if (!ici->ops->get_formats)
-			icd->user_formats[i] = icd->formats + i;
-		else
+		if (!ici->ops->get_formats) {
+			icd->user_formats[i].host_fmt = icd->formats + i;
+			icd->user_formats[i].cam_fmt = icd->formats + i;
+			icd->user_formats[i].buswidth = icd->formats[i].depth;
+		} else {
 			fmts += ici->ops->get_formats(icd, i,
 						      &icd->user_formats[fmts]);
+		}
 
-	icd->current_fmt = icd->user_formats[0];
+	icd->current_fmt = &icd->user_formats[0];
 
 	return 0;
 }
@@ -368,6 +383,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->dev.parent);
+	__u32 pixfmt = f->fmt.pix.pixelformat;
 	int ret;
 	struct v4l2_rect rect;
 
@@ -385,7 +401,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret < 0) {
 		return ret;
 	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != f->fmt.pix.pixelformat) {
+		   icd->current_fmt->host_fmt->fourcc != pixfmt) {
 		dev_err(&ici->dev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
@@ -402,7 +418,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		icd->width, icd->height);
 
 	/* set physical bus parameters */
-	return ici->ops->set_bus_param(icd, f->fmt.pix.pixelformat);
+	return ici->ops->set_bus_param(icd, pixfmt);
 }
 
 static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
@@ -417,7 +433,7 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index >= icd->num_user_formats)
 		return -EINVAL;
 
-	format = icd->user_formats[f->index];
+	format = icd->user_formats[f->index].host_fmt;
 
 	strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
@@ -435,12 +451,12 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width	= icd->width;
 	f->fmt.pix.height	= icd->height;
 	f->fmt.pix.field	= icf->vb_vidq.field;
-	f->fmt.pix.pixelformat	= icd->current_fmt->fourcc;
+	f->fmt.pix.pixelformat	= icd->current_fmt->host_fmt->fourcc;
 	f->fmt.pix.bytesperline	= f->fmt.pix.width *
-		DIV_ROUND_UP(icd->current_fmt->depth, 8);
+		DIV_ROUND_UP(icd->current_fmt->host_fmt->depth, 8);
 	f->fmt.pix.sizeimage	= f->fmt.pix.height * f->fmt.pix.bytesperline;
-	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
-		icd->current_fmt->fourcc);
+	dev_dbg(&icd->dev, "current_fmt->host_fmt->fourcc: 0x%08x\n",
+		icd->current_fmt->host_fmt->fourcc);
 	return 0;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d6333a0..19fa2f7 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -38,10 +38,10 @@ struct soc_camera_device {
 	unsigned char buswidth;		/* See comment in .c */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
-	const struct soc_camera_data_format *current_fmt;
+	const struct soc_camera_format_xlate *current_fmt;
 	const struct soc_camera_data_format *formats;
 	int num_formats;
-	const struct soc_camera_data_format **user_formats;
+	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
 	struct module *owner;
 	void *host_priv;		/* per-device host private data */
@@ -70,7 +70,7 @@ struct soc_camera_host_ops {
 	int (*suspend)(struct soc_camera_device *, pm_message_t);
 	int (*resume)(struct soc_camera_device *);
 	int (*get_formats)(struct soc_camera_device *, int,
-			   const struct soc_camera_data_format **);
+			   struct soc_camera_format_xlate *);
 	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
@@ -111,6 +111,8 @@ extern void soc_camera_video_stop(struct soc_camera_device *icd);
 
 extern const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
+extern const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
+	struct soc_camera_device *icd, unsigned int fourcc);
 
 struct soc_camera_data_format {
 	const char *name;
@@ -119,6 +121,21 @@ struct soc_camera_data_format {
 	enum v4l2_colorspace colorspace;
 };
 
+/**
+ * struct soc_camera_format_xlate - match between host and sensor formats
+ * @cam_fmt: sensor format provided by the sensor
+ * @host_fmt: host format after host translation from cam_fmt
+ * @buswidth: bus width for this format
+ *
+ * Table of host and sensor formats matchings. A host can generate this list, in
+ * camera registation, and use it for format checks and format setup.
+ */
+struct soc_camera_format_xlate {
+	const struct soc_camera_data_format *cam_fmt;
+	const struct soc_camera_data_format *host_fmt;
+	unsigned char buswidth;
+};
+
 struct soc_camera_ops {
 	struct module *owner;
 	int (*probe)(struct soc_camera_device *);
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
