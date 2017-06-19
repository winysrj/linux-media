Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56896 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFSRBh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:01:37 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v5 04/12] [media] vimc: common: Add vimc_pipeline_s_stream helper
Date: Mon, 19 Jun 2017 14:00:13 -0300
Message-Id: <1497891629-1562-5-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
References: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the vimc_cap_pipeline_s_stream from the vimc-cap.c to vimc-common.c
as this core will be reused by other subdevices to activate the stream
in their directly connected nodes

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v5: None
Changes in v4: None
Changes in v3:
[media] vimc: Add vimc_pipeline_s_stream in the core
	- add it in vimc-common instead of vimc-core
	- rename commit with "common" tag

Changes in v2:
[media] vimc: Add vimc_pipeline_s_stream in the core
	- Use is_media_entity_v4l2_subdev instead of comparing with the old
	entity->type
	- Fix comments style
	- add kernel-docs
	- call s_stream across all sink pads


---
 drivers/media/platform/vimc/vimc-capture.c | 29 ++-------------------------
 drivers/media/platform/vimc/vimc-common.c  | 32 ++++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-common.h  | 11 ++++++++++
 3 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 9adb06d..93f6a09 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -132,31 +132,6 @@ static void vimc_cap_return_all_buffers(struct vimc_cap_device *vcap,
 	spin_unlock(&vcap->qlock);
 }
 
-static int vimc_cap_pipeline_s_stream(struct vimc_cap_device *vcap, int enable)
-{
-	struct v4l2_subdev *sd;
-	struct media_pad *pad;
-	int ret;
-
-	/* Start the stream in the subdevice direct connected */
-	pad = media_entity_remote_pad(&vcap->vdev.entity.pads[0]);
-
-	/*
-	 * if it is a raw node from vimc-core, there is nothing to activate
-	 * TODO: remove this when there are no more raw nodes in the
-	 * core and return error instead
-	 */
-	if (pad->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
-		return 0;
-
-	sd = media_entity_to_v4l2_subdev(pad->entity);
-	ret = v4l2_subdev_call(sd, video, s_stream, enable);
-	if (ret && ret != -ENOIOCTLCMD)
-		return ret;
-
-	return 0;
-}
-
 static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
@@ -173,7 +148,7 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	/* Enable streaming from the pipe */
-	ret = vimc_cap_pipeline_s_stream(vcap, 1);
+	ret = vimc_pipeline_s_stream(&vcap->vdev.entity, 1);
 	if (ret) {
 		media_pipeline_stop(entity);
 		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
@@ -192,7 +167,7 @@ static void vimc_cap_stop_streaming(struct vb2_queue *vq)
 	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
 
 	/* Disable streaming from the pipe */
-	vimc_cap_pipeline_s_stream(vcap, 0);
+	vimc_pipeline_s_stream(&vcap->vdev.entity, 0);
 
 	/* Stop the media pipeline */
 	media_pipeline_stop(&vcap->vdev.entity);
diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 3afbabd..f809a9d 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -220,6 +220,38 @@ struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
 	return pads;
 }
 
+int vimc_pipeline_s_stream(struct media_entity *ent, int enable)
+{
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ent->num_pads; i++) {
+		if (ent->pads[i].flags & MEDIA_PAD_FL_SOURCE)
+			continue;
+
+		/* Start the stream in the subdevice direct connected */
+		pad = media_entity_remote_pad(&ent->pads[i]);
+
+		/*
+		 * if this is a raw node from vimc-core, then there is
+		 * nothing to activate
+		 * TODO: remove this when there are no more raw nodes in the
+		 * core and return error instead
+		 */
+		if (pad->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		ret = v4l2_subdev_call(sd, video, s_stream, enable);
+		if (ret && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
+	return 0;
+}
+
 static const struct media_entity_operations vimc_ent_sd_mops = {
 	.link_validate = v4l2_subdev_link_validate,
 };
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 9ec361c..73e7e94 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -97,6 +97,17 @@ static inline void vimc_pads_cleanup(struct media_pad *pads)
 }
 
 /**
+ * vimc_pipeline_s_stream - start stream through the pipeline
+ *
+ * @ent:		the pointer to struct media_entity for the node
+ * @enable:		1 to start the stream and 0 to stop
+ *
+ * Helper function to call the s_stream of the subdevices connected
+ * in all the sink pads of the entity
+ */
+int vimc_pipeline_s_stream(struct media_entity *ent, int enable);
+
+/**
  * vimc_pix_map_by_code - get vimc_pix_map struct by media bus code
  *
  * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
-- 
2.7.4
