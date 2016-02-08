Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48305 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbcBHLoN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:13 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 23/35] v4l: vsp1: Move entity route setup function to vsp1_entity.c
Date: Mon,  8 Feb 2016 13:43:53 +0200
Message-Id: <1454931845-23864-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function will be used by the DU code, move it out of vsp1_video.c.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 12 ++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  2 ++
 drivers/media/platform/vsp1/vsp1_video.c  | 12 ------------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 46832242a672..479029fd4e90 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -58,6 +58,18 @@ int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
 	return ret;
 }
 
+void vsp1_entity_route_setup(struct vsp1_entity *source)
+{
+	struct vsp1_entity *sink;
+
+	if (source->route->reg == 0)
+		return;
+
+	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
+	vsp1_write(source->vsp1, source->route->reg,
+		   sink->route->inputs[source->sink_pad]);
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 9c95507ec762..9606d0d21263 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -96,4 +96,6 @@ void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
 bool vsp1_entity_is_streaming(struct vsp1_entity *entity);
 int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming);
 
+void vsp1_entity_route_setup(struct vsp1_entity *source);
+
 #endif /* __VSP1_ENTITY_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index b1bb63d2a365..7cf73d4f0963 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -674,18 +674,6 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
-static void vsp1_entity_route_setup(struct vsp1_entity *source)
-{
-	struct vsp1_entity *sink;
-
-	if (source->route->reg == 0)
-		return;
-
-	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
-	vsp1_write(source->vsp1, source->route->reg,
-		   sink->route->inputs[source->sink_pad]);
-}
-
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
-- 
2.4.10

