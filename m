Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33034 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbcEKODU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 10:03:20 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Laurent Pinchart <laurent.pinchart@linaro.org>
Subject: [PATCH v4 1/8] v4l: subdev: Add pad config allocator and init
Date: Wed, 11 May 2016 16:02:49 +0200
Message-Id: <1462975376-491-2-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@linaro.org>

Add a new subdev operation to initialize a subdev pad config array, and
a helper function to allocate and initialize the array. This can be used
by bridge drivers to implement try format based on subdev pad
operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@linaro.org>
Acked-by: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 19 ++++++++++++++++++-
 include/media/v4l2-subdev.h           | 10 ++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index d630838..f32ac0d 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -35,7 +35,7 @@
 static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
 {
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-	fh->pad = kzalloc(sizeof(*fh->pad) * sd->entity.num_pads, GFP_KERNEL);
+	fh->pad = v4l2_subdev_alloc_pad_config(sd);
 	if (fh->pad == NULL)
 		return -ENOMEM;
 #endif
@@ -569,6 +569,23 @@ int v4l2_subdev_link_validate(struct media_link *link)
 		sink, link, &source_fmt, &sink_fmt);
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate);
+
+struct v4l2_subdev_pad_config *v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd)
+{
+	struct v4l2_subdev_pad_config *cfg;
+
+	if (!sd->entity.num_pads)
+		return NULL;
+
+	cfg = kcalloc(sd->entity.num_pads, sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
+		return NULL;
+
+	v4l2_subdev_call(sd, pad, init_cfg, cfg);
+
+	return cfg;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_alloc_pad_config);
 #endif /* CONFIG_MEDIA_CONTROLLER */
 
 void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 11e2dfe..6c47cdd 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -607,6 +607,8 @@ struct v4l2_subdev_pad_config {
  *                  may be adjusted by the subdev driver to device capabilities.
  */
 struct v4l2_subdev_pad_ops {
+	void (*init_cfg)(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_pad_config *cfg);
 	int (*enum_mbus_code)(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code);
@@ -801,7 +803,15 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_format *source_fmt,
 				      struct v4l2_subdev_format *sink_fmt);
 int v4l2_subdev_link_validate(struct media_link *link);
+
+struct v4l2_subdev_pad_config *v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd);
+
+static inline void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg)
+{
+	kfree(cfg);
+}
 #endif /* CONFIG_MEDIA_CONTROLLER */
+
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
-- 
2.7.4

