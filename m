Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATEHt0V024556
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 09:17:55 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATEHgas012193
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 09:17:42 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Date: Sat, 29 Nov 2008 15:17:03 +0100
Message-Id: <1227968224-21577-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: [PATCH v4 1/2] soc-camera: pixel format negotiation - core support
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

Allocate and fill a list of formats, supported by this specific
camera-host combination. Use it for format enumeration. Take care to stay
backwards-compatible.

Camera hosts rely on sensor formats available, as well as
host specific translations. We add a structure so that hosts
can define a translation table and use it for format check
and setup.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/soc_camera.c |   93 +++++++++++++++++++++++++++++++++-----
 include/media/soc_camera.h       |   25 ++++++++++-
 2 files changed, 105 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 9db66a4..aa604ef 100644
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
@@ -161,6 +173,59 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 	return videobuf_dqbuf(&icf->vb_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
+static int soc_camera_init_user_formats(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int i, fmts = 0;
+
+	if (!ici->ops->get_formats)
+		/*
+		 * Fallback mode - the host will have to serve all
+		 * sensor-provided formats one-to-one to the user
+		 */
+		fmts = icd->num_formats;
+	else
+		/*
+		 * First pass - only count formats this host-sensor
+		 * configuration can provide
+		 */
+		for (i = 0; i < icd->num_formats; i++)
+			fmts += ici->ops->get_formats(icd, i, NULL);
+
+	if (!fmts)
+		return -ENXIO;
+
+	icd->user_formats =
+		vmalloc(fmts * sizeof(struct soc_camera_format_xlate));
+	if (!icd->user_formats)
+		return -ENOMEM;
+
+	icd->num_user_formats = fmts;
+	fmts = 0;
+
+	dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
+
+	/* Second pass - actually fill data formats */
+	for (i = 0; i < icd->num_formats; i++)
+		if (!ici->ops->get_formats) {
+			icd->user_formats[i].host_fmt = icd->formats + i;
+			icd->user_formats[i].cam_fmt = icd->formats + i;
+			icd->user_formats[i].buswidth = icd->formats[i].depth;
+		} else {
+			fmts += ici->ops->get_formats(icd, i,
+						      &icd->user_formats[fmts]);
+		}
+
+	icd->current_fmt = &icd->user_formats[0].host_fmt;
+
+	return 0;
+}
+
+static void soc_camera_free_user_formats(struct soc_camera_device *icd)
+{
+	vfree(icd->user_formats);
+}
+
 static int soc_camera_open(struct inode *inode, struct file *file)
 {
 	struct video_device *vdev;
@@ -197,10 +262,12 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
+		ret = soc_camera_init_user_formats(icd);
+		if (ret < 0)
+			goto eiufmt;
 		ret = ici->ops->add(icd);
 		if (ret < 0) {
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
-			icd->use_count--;
 			goto eiciadd;
 		}
 	}
@@ -216,6 +283,9 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* All errors are entered with the video_lock held */
 eiciadd:
+	soc_camera_free_user_formats(icd);
+eiufmt:
+	icd->use_count--;
 	module_put(ici->ops->owner);
 emgi:
 	module_put(icd->ops->owner);
@@ -234,8 +304,10 @@ static int soc_camera_close(struct inode *inode, struct file *file)
 
 	mutex_lock(&video_lock);
 	icd->use_count--;
-	if (!icd->use_count)
+	if (!icd->use_count) {
 		ici->ops->remove(icd);
+		soc_camera_free_user_formats(icd);
+	}
 	module_put(icd->ops->owner);
 	module_put(ici->ops->owner);
 	mutex_unlock(&video_lock);
@@ -311,6 +383,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->dev.parent);
+	__u32 pixfmt = f->fmt.pix.pixelformat;
 	int ret;
 	struct v4l2_rect rect;
 
@@ -328,14 +401,12 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret < 0) {
 		return ret;
 	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != f->fmt.pix.pixelformat) {
-		dev_err(&ici->dev, "Host driver hasn't set up current "
-			"format correctly!\n");
+		   icd->current_fmt->fourcc != pixfmt) {
+		dev_err(&ici->dev,
+			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
 	}
 
-	/* buswidth may be further adjusted by the ici */
-	icd->buswidth		= icd->current_fmt->depth;
 	icd->width		= rect.width;
 	icd->height		= rect.height;
 	icf->vb_vidq.field	= f->fmt.pix.field;
@@ -347,7 +418,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		icd->width, icd->height);
 
 	/* set physical bus parameters */
-	return ici->ops->set_bus_param(icd, f->fmt.pix.pixelformat);
+	return ici->ops->set_bus_param(icd, pixfmt);
 }
 
 static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
@@ -359,10 +430,10 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	if (f->index >= icd->num_formats)
+	if (f->index >= icd->num_user_formats)
 		return -EINVAL;
 
-	format = &icd->formats[f->index];
+	format = icd->user_formats[f->index].host_fmt;
 
 	strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
@@ -919,8 +990,6 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 	vdev->minor		= -1;
 	vdev->tvnorms		= V4L2_STD_UNKNOWN,
 
-	icd->current_fmt = &icd->formats[0];
-
 	err = video_register_device(vdev, VFL_TYPE_GRABBER, vdev->minor);
 	if (err < 0) {
 		dev_err(vdev->parent, "video_register_device failed\n");
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index dddaf45..da57ffd 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -41,6 +41,8 @@ struct soc_camera_device {
 	const struct soc_camera_data_format *current_fmt;
 	const struct soc_camera_data_format *formats;
 	int num_formats;
+	struct soc_camera_format_xlate *user_formats;
+	int num_user_formats;
 	struct module *owner;
 	void *host_priv;		/* per-device host private data */
 	/* soc_camera.c private count. Only accessed with video_lock held */
@@ -65,8 +67,10 @@ struct soc_camera_host_ops {
 	struct module *owner;
 	int (*add)(struct soc_camera_device *);
 	void (*remove)(struct soc_camera_device *);
-	int (*suspend)(struct soc_camera_device *, pm_message_t state);
+	int (*suspend)(struct soc_camera_device *, pm_message_t);
 	int (*resume)(struct soc_camera_device *);
+	int (*get_formats)(struct soc_camera_device *, int,
+			   struct soc_camera_format_xlate *);
 	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
@@ -107,6 +111,8 @@ extern void soc_camera_video_stop(struct soc_camera_device *icd);
 
 extern const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
+extern const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
+	struct soc_camera_device *icd, unsigned int fourcc);
 
 struct soc_camera_data_format {
 	const char *name;
@@ -115,6 +121,23 @@ struct soc_camera_data_format {
 	enum v4l2_colorspace colorspace;
 };
 
+/**
+ * struct soc_camera_format_xlate - match between host and sensor formats
+ * @cam_fmt: sensor format provided by the sensor
+ * @host_fmt: host format after host translation from cam_fmt
+ * @buswidth: bus width for this format
+ *
+ * Host and sensor translation structure. Used in table of host and sensor
+ * formats matchings in soc_camera_device. A host can override the generic list
+ * generation by implementing get_formats(), and use it for format checks and
+ * format setup.
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
