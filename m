Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2999 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaICHau (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 03:30:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] vivid: remove duplicate and unused g/s_edid functions
Date: Wed,  3 Sep 2014 09:30:30 +0200
Message-Id: <1409729431-7870-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I'm not sure how I missed this, but they should be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-out.c | 57 ----------------------------
 drivers/media/platform/vivid/vivid-vid-out.h |  1 -
 2 files changed, 58 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index c983461..8206dc6 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1117,63 +1117,6 @@ int vivid_vid_out_s_dv_timings(struct file *file, void *_fh,
 	return 0;
 }
 
-#if 0
-int vivid_vid_out_g_edid(struct file *file, void *_fh,
-			 struct v4l2_edid *edid)
-{
-	struct vivid_dev *dev = video_drvdata(file);
-	struct video_device *vdev = video_devdata(file);
-
-	memset(edid->reserved, 0, sizeof(edid->reserved));
-	if (vdev->vfl_dir == VFL_DIR_RX) {
-		if (edid->pad >= dev->num_inputs)
-			return -EINVAL;
-		if (dev->input_type[edid->pad] != HDMI)
-			return -EINVAL;
-	} else {
-		if (edid->pad >= dev->num_outputs)
-			return -EINVAL;
-		if (dev->output_type[edid->pad] != HDMI)
-			return -EINVAL;
-	}
-	if (edid->start_block == 0 && edid->blocks == 0) {
-		edid->blocks = dev->edid_blocks;
-		return 0;
-	}
-	if (dev->edid_blocks == 0)
-		return -ENODATA;
-	if (edid->start_block >= dev->edid_blocks)
-		return -EINVAL;
-	if (edid->start_block + edid->blocks > dev->edid_blocks)
-		edid->blocks = dev->edid_blocks - edid->start_block;
-	memcpy(edid->edid, dev->edid, edid->blocks * 128);
-	return 0;
-}
-
-int vivid_vid_out_s_edid(struct file *file, void *_fh,
-			 struct v4l2_edid *edid)
-{
-	struct vivid_dev *dev = video_drvdata(file);
-
-	memset(edid->reserved, 0, sizeof(edid->reserved));
-	if (edid->pad >= dev->num_inputs)
-		return -EINVAL;
-	if (dev->input_type[edid->pad] != HDMI || edid->start_block)
-		return -EINVAL;
-	if (edid->blocks == 0) {
-		dev->edid_blocks = 0;
-		return 0;
-	}
-	if (edid->blocks > dev->edid_max_blocks) {
-		edid->blocks = dev->edid_max_blocks;
-		return -E2BIG;
-	}
-	dev->edid_blocks = edid->blocks;
-	memcpy(dev->edid, edid->edid, edid->blocks * 128);
-	return 0;
-}
-#endif
-
 int vivid_vid_out_g_parm(struct file *file, void *priv,
 			  struct v4l2_streamparm *parm)
 {
diff --git a/drivers/media/platform/vivid/vivid-vid-out.h b/drivers/media/platform/vivid/vivid-vid-out.h
index a237465..dfa84db 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.h
+++ b/drivers/media/platform/vivid/vivid-vid-out.h
@@ -51,7 +51,6 @@ int vidioc_g_audout(struct file *file, void *fh, struct v4l2_audioout *vout);
 int vidioc_s_audout(struct file *file, void *fh, const struct v4l2_audioout *vout);
 int vivid_vid_out_s_std(struct file *file, void *priv, v4l2_std_id id);
 int vivid_vid_out_s_dv_timings(struct file *file, void *_fh, struct v4l2_dv_timings *timings);
-int vidioc_g_edid(struct file *file, void *_fh, struct v4l2_edid *edid);
 int vivid_vid_out_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm);
 
 #endif
-- 
2.1.0

