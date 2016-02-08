Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48305 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbcBHLoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:16 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 27/35] v4l: vsp1: Make the userspace API optional
Date: Mon,  8 Feb 2016 13:43:57 +0200
Message-Id: <1454931845-23864-28-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R-Car Gen3 SoCs include VSP instances dedicated to the DU that will
be controlled entirely by the rcar-du-drm driver through the KMS API. To
support that use case make the userspace V4L2 API optional.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h        |  1 +
 drivers/media/platform/vsp1/vsp1_drv.c    | 46 +++++++++++++++++++------------
 drivers/media/platform/vsp1/vsp1_entity.c |  2 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |  6 ++--
 drivers/media/platform/vsp1/vsp1_wpf.c    |  6 ++--
 5 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index d980f32aac0b..4fd4386a7049 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -50,6 +50,7 @@ struct vsp1_platform_data {
 	unsigned int uds_count;
 	unsigned int wpf_count;
 	unsigned int num_bru_inputs;
+	bool uapi;
 };
 
 struct vsp1_device {
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 8d67a06c86ea..63892b2f4484 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -143,6 +143,9 @@ static int vsp1_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
+	if (!vsp1->pdata.uapi)
+		return 0;
+
 	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
 		struct vsp1_rwpf *rpf = vsp1->rpf[i];
 
@@ -267,7 +270,6 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
-		struct vsp1_video *video;
 		struct vsp1_rwpf *rpf;
 
 		rpf = vsp1_rpf_create(vsp1, i);
@@ -279,13 +281,16 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		vsp1->rpf[i] = rpf;
 		list_add_tail(&rpf->entity.list_dev, &vsp1->entities);
 
-		video = vsp1_video_create(vsp1, rpf);
-		if (IS_ERR(video)) {
-			ret = PTR_ERR(video);
-			goto done;
-		}
+		if (vsp1->pdata.uapi) {
+			struct vsp1_video *video = vsp1_video_create(vsp1, rpf);
 
-		list_add_tail(&video->list, &vsp1->videos);
+			if (IS_ERR(video)) {
+				ret = PTR_ERR(video);
+				goto done;
+			}
+
+			list_add_tail(&video->list, &vsp1->videos);
+		}
 	}
 
 	if (vsp1->pdata.features & VSP1_HAS_SRU) {
@@ -312,7 +317,6 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
-		struct vsp1_video *video;
 		struct vsp1_rwpf *wpf;
 
 		wpf = vsp1_wpf_create(vsp1, i);
@@ -324,14 +328,17 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		vsp1->wpf[i] = wpf;
 		list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
 
-		video = vsp1_video_create(vsp1, wpf);
-		if (IS_ERR(video)) {
-			ret = PTR_ERR(video);
-			goto done;
-		}
+		if (vsp1->pdata.uapi) {
+			struct vsp1_video *video = vsp1_video_create(vsp1, wpf);
 
-		list_add_tail(&video->list, &vsp1->videos);
-		wpf->entity.sink = &video->video.entity;
+			if (IS_ERR(video)) {
+				ret = PTR_ERR(video);
+				goto done;
+			}
+
+			list_add_tail(&video->list, &vsp1->videos);
+			wpf->entity.sink = &video->video.entity;
+		}
 	}
 
 	/* Register all subdevs. */
@@ -347,9 +354,11 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	if (ret < 0)
 		goto done;
 
-	ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
-	if (ret < 0)
-		goto done;
+	if (vsp1->pdata.uapi) {
+		ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
+		if (ret < 0)
+			goto done;
+	}
 
 	ret = media_device_register(mdev);
 
@@ -545,6 +554,7 @@ static int vsp1_parse_dt(struct vsp1_device *vsp1)
 
 	pdata->features |= VSP1_HAS_BRU;
 	pdata->num_bru_inputs = 4;
+	pdata->uapi = true;
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 479029fd4e90..338a1b0b4fad 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -45,7 +45,7 @@ int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
 	if (!streaming)
 		return 0;
 
-	if (!entity->subdev.ctrl_handler)
+	if (!entity->vsp1->pdata.uapi || !entity->subdev.ctrl_handler)
 		return 0;
 
 	ret = v4l2_ctrl_handler_setup(entity->subdev.ctrl_handler);
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index d41ae950d1a1..cff4a1d82e3b 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -151,11 +151,13 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 	/* Take the control handler lock to ensure that the CTRL0 value won't be
 	 * changed behind our back by a set control operation.
 	 */
-	mutex_lock(sru->ctrls.lock);
+	if (sru->entity.vsp1->pdata.uapi)
+		mutex_lock(sru->ctrls.lock);
 	ctrl0 |= vsp1_sru_read(sru, VI6_SRU_CTRL0)
 	       & (VI6_SRU_CTRL0_PARAM0_MASK | VI6_SRU_CTRL0_PARAM1_MASK);
 	vsp1_sru_write(sru, VI6_SRU_CTRL0, ctrl0);
-	mutex_unlock(sru->ctrls.lock);
+	if (sru->entity.vsp1->pdata.uapi)
+		mutex_unlock(sru->ctrls.lock);
 
 	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index d2537b46fc46..184a7e01aad5 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -151,10 +151,12 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	/* Take the control handler lock to ensure that the PDV value won't be
 	 * changed behind our back by a set control operation.
 	 */
-	mutex_lock(wpf->ctrls.lock);
+	if (vsp1->pdata.uapi)
+		mutex_lock(wpf->ctrls.lock);
 	outfmt |= vsp1_wpf_read(wpf, VI6_WPF_OUTFMT) & VI6_WPF_OUTFMT_PDV_MASK;
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
-	mutex_unlock(wpf->ctrls.lock);
+	if (vsp1->pdata.uapi)
+		mutex_unlock(wpf->ctrls.lock);
 
 	vsp1_write(vsp1, VI6_DPR_WPF_FPORCH(wpf->entity.index),
 		   VI6_DPR_WPF_FPORCH_FP_WPFN);
-- 
2.4.10

