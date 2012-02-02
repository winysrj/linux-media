Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43168 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 15/31] v4l: Implement v4l2_subdev_link_validate()
Date: Fri,  3 Feb 2012 01:54:35 +0200
Message-Id: <1328226891-8968-15-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_link_validate() is the default op for validating a link. In V4L2
subdev context, it is used to call a pad op which performs the proper link
check without much extra work.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/v4l2-framework.txt |   12 +++++
 drivers/media/video/v4l2-subdev.c            |   69 ++++++++++++++++++++++++++
 include/media/v4l2-subdev.h                  |   10 ++++
 3 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index f06c563..9d341bc 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -312,6 +312,18 @@ If the subdev driver intends to process video and integrate with the media
 framework, it must implement format related functionality using
 v4l2_subdev_pad_ops instead of v4l2_subdev_video_ops.
 
+In that case, the subdev driver may set the link_validate field to provide
+its own link validation function. The link validation function is called for
+every link in the pipeline where both of the ends of the links are V4L2
+sub-devices. The driver is still responsible for validating the correctness
+of the format configuration between sub-devices and video nodes.
+
+If link_validate op is not set, the default function
+v4l2_subdev_link_validate_default() is used instead. This function ensures
+that width, height and the media bus pixel code are equal on both source and
+sink of the link. Subdev drivers are also free to use this function to
+perform the checks mentioned above in addition to their own checks.
+
 A device (bridge) driver needs to register the v4l2_subdev with the
 v4l2_device:
 
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 2c8d467..4203241 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -371,6 +371,75 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
 	.poll = subdev_poll,
 };
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
+				      struct media_link *link,
+				      struct v4l2_subdev_format *source_fmt,
+				      struct v4l2_subdev_format *sink_fmt)
+{
+	if (source_fmt->format.width != sink_fmt->format.width
+	    || source_fmt->format.height != sink_fmt->format.height
+	    || source_fmt->format.code != sink_fmt->format.code)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_default);
+
+static struct v4l2_subdev_format
+*v4l2_subdev_link_validate_get_format(struct media_pad *pad,
+				      struct v4l2_subdev_format *fmt)
+{
+	int rval;
+
+	switch (media_entity_type(pad->entity)) {
+	case MEDIA_ENT_T_V4L2_SUBDEV:
+		fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		fmt->pad = pad->index;
+		rval = v4l2_subdev_call(media_entity_to_v4l2_subdev(
+						pad->entity),
+					pad, get_fmt, NULL, fmt);
+		if (rval < 0)
+			return NULL;
+		return fmt;
+	default:
+		WARN(1, "Driver bug! Wrong media entity type %d, entity %s\n",
+		     media_entity_type(pad->entity), pad->entity->name);
+		/* Fall through */
+	case MEDIA_ENT_T_DEVNODE_V4L:
+		return NULL;
+	}
+}
+
+int v4l2_subdev_link_validate(struct media_link *link)
+{
+	struct v4l2_subdev *sink;
+	struct v4l2_subdev_format _sink_fmt, _source_fmt;
+	struct v4l2_subdev_format *sink_fmt, *source_fmt;
+	int rval;
+
+	source_fmt = v4l2_subdev_link_validate_get_format(
+		link->source, &_source_fmt);
+	if (!source_fmt)
+		return 0;
+
+	sink_fmt = v4l2_subdev_link_validate_get_format(
+		link->sink, &_sink_fmt);
+	if (!sink_fmt)
+		return 0;
+
+	sink = media_entity_to_v4l2_subdev(link->sink->entity);
+
+	rval = v4l2_subdev_call(sink, pad, link_validate, link,
+				source_fmt, sink_fmt);
+	if (rval < 0 && rval != -ENOIOCTLCMD)
+		return rval;
+	return v4l2_subdev_link_validate_default(sink, link, source_fmt,
+						 sink_fmt);
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate);
+#endif /* CONFIG_MEDIA_CONTROLLER */
+
 void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 {
 	INIT_LIST_HEAD(&sd->list);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index feab950..436e6f4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -470,6 +470,11 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_selection *sel);
 	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_selection *sel);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
+			     struct v4l2_subdev_format *source_fmt,
+			     struct v4l2_subdev_format *sink_fmt);
+#endif /* CONFIG_MEDIA_CONTROLLER */
 };
 
 struct v4l2_subdev_ops {
@@ -606,6 +611,11 @@ static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
 	return sd->host_priv;
 }
 
+int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
+				      struct media_link *link,
+				      struct v4l2_subdev_format *source_fmt,
+				      struct v4l2_subdev_format *sink_fmt);
+int v4l2_subdev_link_validate(struct media_link *link);
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
-- 
1.7.2.5

