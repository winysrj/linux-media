Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45333 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbbDXORA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:17:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] vivid-tpg: add tpg_log_status()
Date: Fri, 24 Apr 2015 16:16:22 +0200
Message-Id: <1429884986-38671-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
References: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a log_status function to the test pattern generator and use that
in vivid. This simplifies debugging complex colorspace problems.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 13 ++++++++++++-
 drivers/media/platform/vivid/vivid-tpg.c  | 16 ++++++++++++++++
 drivers/media/platform/vivid/vivid-tpg.h  |  1 +
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index d33f164..d6caeeb 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -392,6 +392,17 @@ static int vidioc_s_parm(struct file *file, void *fh,
 	return vivid_vid_out_g_parm(file, fh, parm);
 }
 
+static int vidioc_log_status(struct file *file, void *fh)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	v4l2_ctrl_log_status(file, fh);
+	if (vdev->vfl_dir == VFL_DIR_RX && vdev->vfl_type == VFL_TYPE_GRABBER)
+		tpg_log_status(&dev->tpg);
+	return 0;
+}
+
 static ssize_t vivid_radio_read(struct file *file, char __user *buf,
 			 size_t size, loff_t *offset)
 {
@@ -610,7 +621,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
 	.vidioc_g_edid			= vidioc_g_edid,
 	.vidioc_s_edid			= vidioc_s_edid,
 
-	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_log_status		= vidioc_log_status,
 	.vidioc_subscribe_event		= vidioc_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index cb766eb..69cd8fb 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1670,6 +1670,22 @@ static int tpg_pattern_avg(const struct tpg_data *tpg,
 	return -1;
 }
 
+void tpg_log_status(struct tpg_data *tpg)
+{
+	pr_info("tpg source WxH: %ux%u (%s)\n",
+			tpg->src_width, tpg->src_height,
+			tpg->is_yuv ? "YCbCr" : "RGB");
+	pr_info("tpg field: %u\n", tpg->field);
+	pr_info("tpg crop: %ux%u@%dx%d\n", tpg->crop.width, tpg->crop.height,
+			tpg->crop.left, tpg->crop.top);
+	pr_info("tpg compose: %ux%u@%dx%d\n", tpg->compose.width, tpg->compose.height,
+			tpg->compose.left, tpg->compose.top);
+	pr_info("tpg colorspace: %d\n", tpg->colorspace);
+	pr_info("tpg Y'CbCr encoding: %d/%d\n", tpg->ycbcr_enc, tpg->real_ycbcr_enc);
+	pr_info("tpg quantization: %d/%d\n", tpg->quantization, tpg->real_quantization);
+	pr_info("tpg RGB range: %d/%d\n", tpg->rgb_range, tpg->real_rgb_range);
+}
+
 /*
  * This struct contains common parameters used by both the drawing of the
  * test pattern and the drawing of the extras (borders, square, etc.)
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index a50cd2e..ef8638f 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -192,6 +192,7 @@ int tpg_alloc(struct tpg_data *tpg, unsigned max_w);
 void tpg_free(struct tpg_data *tpg);
 void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned height,
 		       u32 field);
+void tpg_log_status(struct tpg_data *tpg);
 
 void tpg_set_font(const u8 *f);
 void tpg_gen_text(const struct tpg_data *tpg,
-- 
2.1.4

