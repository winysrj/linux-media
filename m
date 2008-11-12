Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVu7s022635
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:56 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVjXs027180
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:46 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:39 +0100
Message-Id: <1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 08/13] soc_camera: add format translation framework
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
host specific translations. We add a framework so that hosts
only have to define a translation table.

Based on this translation table, soc_camera will compute
available formats by matching sensor outputs to host
translations.

The host can add other formats which were not computed by
the translation mechanism, by implementing the
add_extra_format() host operation.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/soc_camera.c |  102 ++++++++++++++++++++++++++++++++++++-
 include/media/soc_camera.h       |   24 +++++++++
 2 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a63738c..641b977 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -47,6 +47,77 @@ const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 }
 EXPORT_SYMBOL(soc_camera_format_by_fourcc);
 
+/**
+ * @icd:	camera device
+ * @i:		index of the camera format to be considered
+ * @fmt:	if (fmt != NULL) it points to the beginning of an area,
+ *		sufficient for all extra formats, that the i's camera format
+ *		can be converted to, and this area has to be filled in
+ * @return:	number of extra formats found for this camera format
+ */
+static int soc_camera_format_generate(struct soc_camera_device *icd, int idx,
+				      struct soc_camera_computed_format *fmt)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_format_translate *trans;
+	int found = 0;
+
+	for (trans = ici->translate_fmt; trans->host_fmt.name; trans++ ) {
+		if (trans->host_fmt.depth != icd->formats[idx].depth)
+			continue;
+		if (trans->sensor_fourcc != icd->formats[idx].fourcc)
+			continue;
+		if (fmt) {
+			fmt[found].host_fmt = &trans->host_fmt;
+			fmt[found].sensor_fmt = &icd->formats[idx];
+		}
+		found++;
+	}
+	return found;
+}
+
+static int soc_camera_init_formats(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int i, j, host_fmts = 0;
+
+	if (!ici->translate_fmt) {
+		dev_err(&icd->dev, "No format translation table provided\n");
+		return -ENODATA;
+	}
+
+	for (i = 0; i < icd->num_formats; i++)
+		host_fmts += soc_camera_format_generate(icd, i, NULL);
+	for (i = 0; ici->ops->add_extra_format && i < icd->num_formats; i++)
+		host_fmts += ici->ops->add_extra_format(icd, i, NULL);
+
+	icd->available_fmts = vmalloc(sizeof(struct soc_camera_computed_format)
+				      * host_fmts);
+	if (!icd->available_fmts)
+		return -ENOMEM;
+
+	dev_dbg(&icd->dev, "Found %d sensor to host compatible formats :\n",
+		host_fmts);
+
+	for (i = 0, j = 0; i < icd->num_formats; i++)
+		j += soc_camera_format_generate(icd, i, &icd->available_fmts[j]);
+	for (i = 0; ici->ops->add_extra_format && i < icd->num_formats; i++)
+		j += ici->ops->add_extra_format(icd, i, &icd->available_fmts[j]);
+
+	for (i = 0; i < host_fmts; i++)
+		dev_dbg(&icd->dev, "\t%s <- sensor %s\n",
+			icd->available_fmts[i].host_fmt->name,
+			icd->available_fmts[i].sensor_fmt->name);
+
+	icd->num_available_fmts = host_fmts;
+	return 0;
+}
+
+static void soc_camera_free_formats(struct soc_camera_device *icd)
+{
+	vfree(icd->available_fmts);
+}
+
 static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 				      struct v4l2_format *f)
 {
@@ -193,6 +264,11 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 	icf->icd = icd;
 	icd->use_count++;
 
+	/* Generate available formats */
+	ret = soc_camera_init_formats(icd);
+	if (ret)
+		goto egenfmt;
+
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
 		ret = ici->ops->add(icd);
@@ -214,6 +290,8 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* All errors are entered with the video_lock held */
 eiciadd:
+	soc_camera_free_formats(icd);
+egenfmt:
 	module_put(ici->ops->owner);
 emgi:
 	module_put(icd->ops->owner);
@@ -231,6 +309,7 @@ static int soc_camera_close(struct inode *inode, struct file *file)
 	struct video_device *vdev = icd->vdev;
 
 	mutex_lock(&video_lock);
+	soc_camera_free_formats(icd);
 	icd->use_count--;
 	if (!icd->use_count)
 		ici->ops->remove(icd);
@@ -323,8 +402,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	ret = ici->ops->set_fmt(icd, f->fmt.pix.pixelformat, &rect);
 	if (ret < 0) {
 		return ret;
-	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != f->fmt.pix.pixelformat) {
+	} else if (!icd->current_fmt) {
 		dev_err(&ici->dev, "Host driver hasn't set up current "
 			"format correctly!\n");
 		return -EINVAL;
@@ -346,6 +424,22 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	return ici->ops->set_bus_param(icd, f->fmt.pix.pixelformat);
 }
 
+static int soc_camera_default_enum_fmt(struct soc_camera_device *icd,
+				       struct v4l2_fmtdesc *f)
+{
+	const struct soc_camera_data_format *format;
+
+	if (f->index >= icd->num_available_fmts)
+		return -EINVAL;
+
+	format = icd->available_fmts[f->index].host_fmt;
+
+	strlcpy(f->description, format->name, sizeof(f->description));
+	f->pixelformat = format->fourcc;
+
+	return 0;
+}
+
 static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 				       struct v4l2_fmtdesc *f)
 {
@@ -744,7 +838,6 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	if (!ici || !ici->ops ||
 	    !ici->ops->try_fmt ||
 	    !ici->ops->set_fmt ||
-	    !ici->ops->enum_fmt ||
 	    !ici->ops->set_bus_param ||
 	    !ici->ops->querycap ||
 	    !ici->ops->init_videobuf ||
@@ -754,6 +847,9 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->ops->poll)
 		return -EINVAL;
 
+	if (!ici->ops->enum_fmt)
+		ici->ops->enum_fmt = soc_camera_default_enum_fmt;
+
 	/* Number might be equal to the platform device ID */
 	sprintf(ici->dev.bus_id, "camera_host%d", ici->nr);
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index a63f7fb..f800948 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -41,6 +41,8 @@ struct soc_camera_device {
 	const struct soc_camera_data_format *current_fmt;
 	const struct soc_camera_data_format *formats;
 	int num_formats;
+	struct soc_camera_computed_format *available_fmts;
+	int num_available_fmts;
 	struct module *owner;
 	void *host_priv;		/* per-device host private data */
 	/* soc_camera.c private count. Only accessed with video_lock held */
@@ -58,6 +60,7 @@ struct soc_camera_host {
 	unsigned char nr;				/* Host number */
 	void *priv;
 	char *drv_name;
+	const struct soc_camera_format_translate *translate_fmt;
 	struct soc_camera_host_ops *ops;
 };
 
@@ -76,6 +79,8 @@ struct soc_camera_host_ops {
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
 	unsigned int (*poll)(struct file *, poll_table *);
+	int (*add_extra_format)(struct soc_camera_device *icd, int idx,
+				struct soc_camera_computed_format *fmt);
 };
 
 struct soc_camera_link {
@@ -109,6 +114,13 @@ extern void soc_camera_video_stop(struct soc_camera_device *icd);
 extern const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
 
+#define COL_FMT(_name, _depth, _fourcc, _colorspace) \
+	{ .name = _name, .depth = _depth, .fourcc = _fourcc, \
+	.colorspace = _colorspace }
+#define RGB_FMT(_name, _depth, _fourcc) \
+	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_SRGB)
+#define JPG_FMT(_name, _depth, _fourcc) \
+	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_JPEG)
 struct soc_camera_data_format {
 	char *name;
 	unsigned int depth;
@@ -116,6 +128,18 @@ struct soc_camera_data_format {
 	enum v4l2_colorspace colorspace;
 };
 
+#define LAST_FMT_TRANSLATION { COL_FMT(NULL, 0, 0, 0), 0 }
+struct soc_camera_format_translate {
+	struct soc_camera_data_format host_fmt;
+	__u32 sensor_fourcc;
+};
+
+struct soc_camera_computed_format {
+	struct soc_camera_data_format *host_fmt;
+	struct soc_camera_data_format *sensor_fmt;
+};
+
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
