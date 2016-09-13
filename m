Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45455 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760439AbcIMUKe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 16:10:34 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH] [v4l-utils] libv4l2subdev: Propagate format deep in the topology
Date: Tue, 13 Sep 2016 17:09:58 -0300
Message-Id: <5776a3af5046c55b4efa3b936a1ca68466098207.1473796687.git.helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format was only being propagated to the subdevices directly
connected to the node being changed.
Continue propagating the format to all the subdevices in the video pipe.

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---

Only one level of propagation was not that useful for me so I made it to completely
propagate the format through the topology, I hope this patch to be useful to others.

 utils/media-ctl/libv4l2subdev.c | 43 +++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 3dcf943..8333557 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -644,6 +644,28 @@ static int set_frame_interval(struct media_entity *entity,
 	return 0;
 }
 
+static void propagate_set_fmt(struct media_entity *entity)
+{
+	unsigned int i;
+
+	for (i = 0; i < entity->num_links; ++i) {
+		struct media_link *link = &entity->links[i];
+		struct v4l2_mbus_framefmt format;
+
+		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
+			continue;
+
+		/* If we found a source pad, propagate it's format to the remote sink */
+		if (link->source->entity == entity &&
+		    link->sink->entity->info.type == MEDIA_ENT_T_V4L2_SUBDEV) {
+
+			v4l2_subdev_get_format(entity, &format, link->source->index,
+						V4L2_SUBDEV_FORMAT_ACTIVE);
+			set_format(link->sink, &format);
+			propagate_set_fmt(link->sink->entity);
+		}
+	}
+}
 
 static int v4l2_subdev_parse_setup_format(struct media_device *media,
 					  const char *p, char **endp)
@@ -653,7 +675,6 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 	struct v4l2_rect crop = { -1, -1, -1, -1 };
 	struct v4l2_rect compose = crop;
 	struct v4l2_fract interval = { 0, 0 };
-	unsigned int i;
 	char *end;
 	int ret;
 
@@ -690,24 +711,8 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 		return ret;
 
 
-	/* If the pad is an output pad, automatically set the same format on
-	 * the remote subdev input pads, if any.
-	 */
-	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
-		for (i = 0; i < pad->entity->num_links; ++i) {
-			struct media_link *link = &pad->entity->links[i];
-			struct v4l2_mbus_framefmt remote_format;
-
-			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
-				continue;
-
-			if (link->source == pad &&
-			    link->sink->entity->info.type == MEDIA_ENT_T_V4L2_SUBDEV) {
-				remote_format = format;
-				set_format(link->sink, &remote_format);
-			}
-		}
-	}
+	/* Automaticaly propagate formats through the video pipe */
+	propagate_set_fmt(pad->entity);
 
 	*endp = end;
 	return 0;
-- 
1.9.1

