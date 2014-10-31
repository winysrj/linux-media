Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51740 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbaJaPVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:21:19 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id CACFE217D4
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:19:05 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] v4l: omap4iss: Stop started entities when pipeline start fails
Date: Fri, 31 Oct 2014 17:21:22 +0200
Message-Id: <1414768882-16255-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an entity can't be started when starting a pipeline we need to clean
up by stopping all entities that have been successfully started.
Otherwise the hardware and software states won't match, potentially
leading to crashes (for instance due to the CSI2 receiver receiving
interrupts with a NULL pipeline pointer).

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 108 +++++++++++++++++++----------------
 1 file changed, 59 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index fa05908..d8240a1 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -560,6 +560,61 @@ static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
  */
 
 /*
+ * iss_pipeline_disable - Disable streaming on a pipeline
+ * @pipe: ISS pipeline
+ * @until: entity at which to stop pipeline walk
+ *
+ * Walk the entities chain starting at the pipeline output video node and stop
+ * all modules in the chain. Wait synchronously for the modules to be stopped if
+ * necessary.
+ *
+ * If the until argument isn't NULL, stop the pipeline walk when reaching the
+ * until entity. This is used to disable a partially started pipeline due to a
+ * subdev start error.
+ */
+static int iss_pipeline_disable(struct iss_pipeline *pipe,
+				struct media_entity *until)
+{
+	struct iss_device *iss = pipe->output->iss;
+	struct media_entity *entity;
+	struct media_pad *pad;
+	struct v4l2_subdev *subdev;
+	int failure = 0;
+	int ret;
+
+	entity = &pipe->output->video.entity;
+	while (1) {
+		pad = &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		pad = media_entity_remote_pad(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		entity = pad->entity;
+		if (entity == until)
+			break;
+
+		subdev = media_entity_to_v4l2_subdev(entity);
+		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
+		if (ret < 0) {
+			dev_dbg(iss->dev, "%s: module stop timeout.\n",
+				subdev->name);
+			/* If the entity failed to stopped, assume it has
+			 * crashed. Mark it as such, the ISS will be reset when
+			 * applications will release it.
+			 */
+			iss->crashed |= 1U << subdev->entity.id;
+			failure = -ETIMEDOUT;
+		}
+	}
+
+	return failure;
+}
+
+/*
  * iss_pipeline_enable - Enable streaming on a pipeline
  * @pipe: ISS pipeline
  * @mode: Stream mode (single shot or continuous)
@@ -610,8 +665,10 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
 		subdev = media_entity_to_v4l2_subdev(entity);
 
 		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
-		if (ret < 0 && ret != -ENOIOCTLCMD)
+		if (ret < 0 && ret != -ENOIOCTLCMD) {
+			iss_pipeline_disable(pipe, entity);
 			return ret;
+		}
 
 		if (subdev == &iss->csi2a.subdev ||
 		    subdev == &iss->csi2b.subdev)
@@ -623,53 +680,6 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
 }
 
 /*
- * iss_pipeline_disable - Disable streaming on a pipeline
- * @pipe: ISS pipeline
- *
- * Walk the entities chain starting at the pipeline output video node and stop
- * all modules in the chain. Wait synchronously for the modules to be stopped if
- * necessary.
- */
-static int iss_pipeline_disable(struct iss_pipeline *pipe)
-{
-	struct iss_device *iss = pipe->output->iss;
-	struct media_entity *entity;
-	struct media_pad *pad;
-	struct v4l2_subdev *subdev;
-	int failure = 0;
-	int ret;
-
-	entity = &pipe->output->video.entity;
-	while (1) {
-		pad = &entity->pads[0];
-		if (!(pad->flags & MEDIA_PAD_FL_SINK))
-			break;
-
-		pad = media_entity_remote_pad(pad);
-		if (pad == NULL ||
-		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
-			break;
-
-		entity = pad->entity;
-		subdev = media_entity_to_v4l2_subdev(entity);
-
-		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
-		if (ret < 0) {
-			dev_dbg(iss->dev, "%s: module stop timeout.\n",
-				subdev->name);
-			/* If the entity failed to stopped, assume it has
-			 * crashed. Mark it as such, the ISS will be reset when
-			 * applications will release it.
-			 */
-			iss->crashed |= 1U << subdev->entity.id;
-			failure = -ETIMEDOUT;
-		}
-	}
-
-	return failure;
-}
-
-/*
  * omap4iss_pipeline_set_stream - Enable/disable streaming on a pipeline
  * @pipe: ISS pipeline
  * @state: Stream state (stopped, single shot or continuous)
@@ -687,7 +697,7 @@ int omap4iss_pipeline_set_stream(struct iss_pipeline *pipe,
 	int ret;
 
 	if (state == ISS_PIPELINE_STREAM_STOPPED)
-		ret = iss_pipeline_disable(pipe);
+		ret = iss_pipeline_disable(pipe, NULL);
 	else
 		ret = iss_pipeline_enable(pipe, state);
 
-- 
2.0.4

