Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:21588 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933992Ab2AKV1U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:20 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 17/23] v4l: Implement v4l2_subdev_link_validate()
Date: Wed, 11 Jan 2012 23:26:54 +0200
Message-Id: <1326317220-15339-17-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_link_validate() is the default op for validating a link. In V4L2
subdev context, it is used to call a pad op which performs the proper link
check without much extra work.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/v4l2-subdev.c |   62 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-subdev.h       |   10 ++++++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 836270d..4b329a0 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -367,6 +367,68 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
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
+	case MEDIA_ENT_T_DEVNODE_V4L:
+		return NULL;
+	default:
+		BUG();
+	}
+}
+
+int v4l2_subdev_link_validate(struct media_link *link)
+{
+	struct v4l2_subdev *sink = NULL, *source = NULL;
+	struct v4l2_subdev_format _sink_fmt, _source_fmt;
+	struct v4l2_subdev_format *sink_fmt, *source_fmt;
+
+	source_fmt = v4l2_subdev_link_validate_get_format(
+		link->source, &_source_fmt);
+	sink_fmt = v4l2_subdev_link_validate_get_format(
+		link->sink, &_sink_fmt);
+
+	if (source_fmt)
+		source = media_entity_to_v4l2_subdev(link->source->entity);
+	if (sink_fmt)
+		sink = media_entity_to_v4l2_subdev(link->sink->entity);
+
+	if (source_fmt && sink_fmt)
+		return v4l2_subdev_call(sink, pad, link_validate, link,
+					source_fmt, sink_fmt);
+	return 0;
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

