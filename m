Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56237 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752357AbbEUJCn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:02:43 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 10/20] media: soc_camera: soc_scale_crop: Use correct pad when calling subdev try_fmt
Date: Wed, 20 May 2015 17:39:30 +0100
Message-Id: <1432139980-12619-11-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Fix calls to subdev try_fmt to use correct pad. Fixes failures with
subdevs that care about having the right pad number set.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_scale_crop.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index bda29bc..d8d32ea 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -224,6 +224,10 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_cropcap cap;
 	bool host_1to1;
 	int ret;
+	struct media_pad *remote_pad;
+
+	remote_pad = media_entity_remote_pad(&icd->vdev->entity.pads[0]);
+	format->pad = remote_pad->index;
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					 soc_camera_grp_id(icd), pad,
@@ -261,10 +265,17 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
 	while ((width > tmp_w || height > tmp_h) &&
 	       tmp_w < max_width && tmp_h < max_height) {
+		struct media_pad *remote_pad;
+
 		tmp_w = min(2 * tmp_w, max_width);
 		tmp_h = min(2 * tmp_h, max_height);
 		mf->width = tmp_w;
 		mf->height = tmp_h;
+
+		remote_pad = media_entity_remote_pad(
+			&icd->vdev->entity.pads[0]);
+		format->pad = remote_pad->index;
+
 		ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					soc_camera_grp_id(icd), pad,
 					set_fmt, NULL, format);
-- 
1.7.10.4

