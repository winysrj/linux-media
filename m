Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56499 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JTVDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 17:03:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] v4l: Don't warn during link validation when encountering a V4L2 devnode
Date: Sat, 20 Oct 2012 23:04:33 +0200
Message-Id: <1350767073-9478-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_link_validate_get_format() retrieves the remote pad format
depending on the entity type and prints a warning if the entity type is
not supported. The type check doesn't take the subtype into account, and
thus always prints a warning for device node types, even when supported.
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 9182f81..5f74d96 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -406,20 +406,20 @@ static int
 v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 				     struct v4l2_subdev_format *fmt)
 {
-	switch (media_entity_type(pad->entity)) {
-	case MEDIA_ENT_T_V4L2_SUBDEV:
+	if (media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV) {
+		struct v4l2_subdev *sd =
+			media_entity_to_v4l2_subdev(pad->entity);
+
 		fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
 		fmt->pad = pad->index;
-		return v4l2_subdev_call(media_entity_to_v4l2_subdev(
-						pad->entity),
-					pad, get_fmt, NULL, fmt);
-	default:
-		WARN(1, "Driver bug! Wrong media entity type %d, entity %s\n",
-		     media_entity_type(pad->entity), pad->entity->name);
-		/* Fall through */
-	case MEDIA_ENT_T_DEVNODE_V4L:
-		return -EINVAL;
+		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
 	}
+
+	WARN(pad->entity->type != MEDIA_ENT_T_DEVNODE_V4L,
+	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
+	     pad->entity->type, pad->entity->name);
+
+	return -EINVAL;
 }
 
 int v4l2_subdev_link_validate(struct media_link *link)
-- 
Regards,

Laurent Pinchart

