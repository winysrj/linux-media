Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:50773 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756015AbbFCOAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 10:00:13 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>,
	hans verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 11/15] media: soc_camera: soc_scale_crop: Use correct pad number in try_fmt
Date: Wed,  3 Jun 2015 14:59:58 +0100
Message-Id: <1433340002-1691-12-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Fix calls to subdev try_fmt to use correct pad. Fixes failures with
subdevs that care about having the right pad number set.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_scale_crop.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index bda29bc..90e2769 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -225,6 +225,10 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	bool host_1to1;
 	int ret;
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	format->pad = icd->src_pad_idx;
+#endif
+
 	ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					 soc_camera_grp_id(icd), pad,
 					 set_fmt, NULL, format);
@@ -261,10 +265,16 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
 	while ((width > tmp_w || height > tmp_h) &&
 	       tmp_w < max_width && tmp_h < max_height) {
+
 		tmp_w = min(2 * tmp_w, max_width);
 		tmp_h = min(2 * tmp_h, max_height);
 		mf->width = tmp_w;
 		mf->height = tmp_h;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		format->pad = icd->src_pad_idx;
+#endif
+
 		ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					soc_camera_grp_id(icd), pad,
 					set_fmt, NULL, format);
-- 
1.7.10.4

