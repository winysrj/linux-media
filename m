Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44645 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbcC2XvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 19:51:22 -0400
From: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl,
	sakari.ailus@linux.intel.com, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
Cc: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Subject: [PATCH v2] [media] media: change pipeline validation return error
Date: Tue, 29 Mar 2016 20:49:47 -0300
Message-Id: <1459295387-12090-1-git-send-email-helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the V4L2 API, the VIDIOC_STREAMON ioctl should return EPIPE
if there is a format mismatch in the pipeline configuration.

As the .vidioc_streamon in the v4l2_ioctl_ops usually forwards the error
caused by the v4l2_subdev_link_validate_default (if it is in use), it
should return -EPIPE when it detect the mismatch.

When an entity is connected to a non enabled link,
media_entity_pipeline_start should return -ENOLINK, as the link does not
exist.

Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
---

The patch is based on 'media/master' branch and available at
        https://github.com/helen-fornazier/opw-staging media/devel

Changes since v1:
	* Commit message, it was "v4l2-subdev: return -EPIPE instead of -EINVAL in link validate default"
	* EPIPE to ENOLINK in the __media_entity_pipeline_start

 drivers/media/media-entity.c          | 2 +-
 drivers/media/v4l2-core/v4l2-subdev.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c53c1d5..d8a2299 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -445,7 +445,7 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 		bitmap_or(active, active, has_no_links, entity->num_pads);
 
 		if (!bitmap_full(active, entity->num_pads)) {
-			ret = -EPIPE;
+			ret = -ENOLINK;
 			dev_dbg(entity->graph_obj.mdev->dev,
 				"\"%s\":%u must be connected by an enabled link\n",
 				entity->name,
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index d630838..918e79d 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -508,7 +508,7 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 	if (source_fmt->format.width != sink_fmt->format.width
 	    || source_fmt->format.height != sink_fmt->format.height
 	    || source_fmt->format.code != sink_fmt->format.code)
-		return -EINVAL;
+		return -EPIPE;
 
 	/* The field order must match, or the sink field order must be NONE
 	 * to support interlaced hardware connected to bridges that support
@@ -516,7 +516,7 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 	 */
 	if (source_fmt->format.field != sink_fmt->format.field &&
 	    sink_fmt->format.field != V4L2_FIELD_NONE)
-		return -EINVAL;
+		return -EPIPE;
 
 	return 0;
 }
-- 
1.9.1

