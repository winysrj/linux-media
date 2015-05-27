Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:52405 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752307AbbE0QLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 12:11:00 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 09/15] media: soc_camera pad-aware driver initialisation
Date: Wed, 27 May 2015 17:10:47 +0100
Message-Id: <1432743053-13479-10-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
References: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add detection of source pad number for drivers aware of the media
controller API, so that soc_camera/rcar_vin can create device nodes
to support a driver such as adv7604.c (for HDMI on Lager) underneath.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c   |    6 +++++
 drivers/media/platform/soc_camera/soc_camera.c |   32 ++++++++++++++++++++++++
 include/media/soc_camera.h                     |    1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 16352a8..0df3212 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1358,7 +1358,13 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		struct v4l2_rect rect;
 		struct device *dev = icd->parent;
 		int shift;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		struct media_pad *remote_pad;
 
+		remote_pad = media_entity_remote_pad(
+					&icd->vdev->entity.pads[0]);
+		fmt.pad = remote_pad->index;
+#endif
 		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d708df4..b054f46 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1293,6 +1293,7 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	int src_pad_idx = -1;
 	int ret;
 
 	sd->grp_id = soc_camera_grp_id(icd);
@@ -1310,8 +1311,30 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 		return ret;
 	}
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
 	/* At this point client .probe() should have run already */
+	ret = media_entity_init(&icd->vdev->entity, 1, &icd->pad, 0);
+	if (!ret) {
+		for (src_pad_idx = 0; src_pad_idx < sd->entity.num_pads;
+				src_pad_idx++)
+			if (sd->entity.pads[src_pad_idx].flags
+						== MEDIA_PAD_FL_SOURCE)
+				break;
+
+		if (src_pad_idx < sd->entity.num_pads) {
+			if (!media_entity_create_link(
+			    &icd->vdev->entity, 0,
+			    &sd->entity, src_pad_idx,
+			    MEDIA_LNK_FL_IMMUTABLE |
+			    MEDIA_LNK_FL_ENABLED)) {
+				ret = soc_camera_init_user_formats(icd);
+			}
+		}
+	}
+#else
 	ret = soc_camera_init_user_formats(icd);
+#endif
+
 	if (ret < 0)
 		goto eusrfmt;
 
@@ -1322,6 +1345,7 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 		goto evidstart;
 
 	/* Try to improve our guess of a reasonable window format */
+	fmt.pad = src_pad_idx;
 	if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt)) {
 		icd->user_width		= mf->width;
 		icd->user_height	= mf->height;
@@ -1335,6 +1359,9 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 evidstart:
 	soc_camera_free_user_formats(icd);
 eusrfmt:
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&icd->vdev->entity);
+#endif
 	soc_camera_remove_device(icd);
 
 	return ret;
@@ -1856,6 +1883,11 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 	if (icd->num_user_formats)
 		soc_camera_free_user_formats(icd);
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (icd->vdev->entity.num_pads)
+		media_entity_cleanup(&icd->vdev->entity);
+#endif
+
 	if (icd->clk) {
 		/* For the synchronous case */
 		v4l2_clk_unregister(icd->clk);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2f6261f..f0c5238 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -42,6 +42,7 @@ struct soc_camera_device {
 	unsigned char devnum;		/* Device number per host */
 	struct soc_camera_sense *sense;	/* See comment in struct definition */
 	struct video_device *vdev;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler ctrl_handler;
 	const struct soc_camera_format_xlate *current_fmt;
 	struct soc_camera_format_xlate *user_formats;
-- 
1.7.10.4

