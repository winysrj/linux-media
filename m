Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:52409 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752347AbbE0QLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 12:11:00 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 11/15] media: soc_camera: soc_scale_crop: Use correct pad when calling subdev try_fmt
Date: Wed, 27 May 2015 17:10:49 +0100
Message-Id: <1432743053-13479-12-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
References: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Fix calls to subdev try_fmt to use correct pad. Fixes failures with
subdevs that care about having the right pad number set.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_scale_crop.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index bda29bc..d2b377f 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -224,6 +224,12 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_cropcap cap;
 	bool host_1to1;
 	int ret;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad *remote_pad;
+
+	remote_pad = media_entity_remote_pad(&icd->vdev->entity.pads[0]);
+	format->pad = remote_pad->index;
+#endif
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					 soc_camera_grp_id(icd), pad,
@@ -261,10 +267,21 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
 	while ((width > tmp_w || height > tmp_h) &&
 	       tmp_w < max_width && tmp_h < max_height) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		struct media_pad *remote_pad;
+#endif
+
 		tmp_w = min(2 * tmp_w, max_width);
 		tmp_h = min(2 * tmp_h, max_height);
 		mf->width = tmp_w;
 		mf->height = tmp_h;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		remote_pad = media_entity_remote_pad(
+			&icd->vdev->entity.pads[0]);
+		format->pad = remote_pad->index;
+#endif
+
 		ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					soc_camera_grp_id(icd), pad,
 					set_fmt, NULL, format);
-- 
1.7.10.4

