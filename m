Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52954 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091AbcFTTOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:14:00 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 23/24] v4l: vsp1: Constify operation structures
Date: Mon, 20 Jun 2016 22:10:41 +0300
Message-Id: <1466449842-29502-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structures are never modified, make them const.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c   | 4 ++--
 drivers/media/platform/vsp1/vsp1_clu.c   | 4 ++--
 drivers/media/platform/vsp1/vsp1_hgo.c   | 4 ++--
 drivers/media/platform/vsp1/vsp1_histo.c | 2 +-
 drivers/media/platform/vsp1/vsp1_hsit.c  | 4 ++--
 drivers/media/platform/vsp1/vsp1_lif.c   | 4 ++--
 drivers/media/platform/vsp1/vsp1_lut.c   | 4 ++--
 drivers/media/platform/vsp1/vsp1_rpf.c   | 2 +-
 drivers/media/platform/vsp1/vsp1_sru.c   | 4 ++--
 drivers/media/platform/vsp1/vsp1_uds.c   | 4 ++--
 drivers/media/platform/vsp1/vsp1_video.c | 4 ++--
 drivers/media/platform/vsp1/vsp1_wpf.c   | 4 ++--
 12 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index dfd48cf4a11a..8268b87727a7 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -249,7 +249,7 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops bru_pad_ops = {
+static const struct v4l2_subdev_pad_ops bru_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = bru_enum_mbus_code,
 	.enum_frame_size = bru_enum_frame_size,
@@ -259,7 +259,7 @@ static struct v4l2_subdev_pad_ops bru_pad_ops = {
 	.set_selection = bru_set_selection,
 };
 
-static struct v4l2_subdev_ops bru_ops = {
+static const struct v4l2_subdev_ops bru_ops = {
 	.pad    = &bru_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index 2f77c2c60ad2..b63d2dbe5ea3 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -189,7 +189,7 @@ static int clu_set_format(struct v4l2_subdev *subdev,
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_pad_ops clu_pad_ops = {
+static const struct v4l2_subdev_pad_ops clu_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = clu_enum_mbus_code,
 	.enum_frame_size = clu_enum_frame_size,
@@ -197,7 +197,7 @@ static struct v4l2_subdev_pad_ops clu_pad_ops = {
 	.set_fmt = clu_set_format,
 };
 
-static struct v4l2_subdev_ops clu_ops = {
+static const struct v4l2_subdev_ops clu_ops = {
 	.pad    = &clu_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index 25983f37d711..aee49f370558 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -380,7 +380,7 @@ static int hgo_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops hgo_pad_ops = {
+static const struct v4l2_subdev_pad_ops hgo_pad_ops = {
 	.enum_mbus_code = hgo_enum_mbus_code,
 	.enum_frame_size = hgo_enum_frame_size,
 	.get_fmt = hgo_get_format,
@@ -389,7 +389,7 @@ static struct v4l2_subdev_pad_ops hgo_pad_ops = {
 	.set_selection = hgo_set_selection,
 };
 
-static struct v4l2_subdev_ops hgo_ops = {
+static const struct v4l2_subdev_ops hgo_ops = {
 	.pad    = &hgo_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
index e9eb22835483..97b1cb891e90 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.c
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -155,7 +155,7 @@ static void histo_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&histo->irqlock, flags);
 }
 
-static struct vb2_ops histo_video_queue_qops = {
+static const struct vb2_ops histo_video_queue_qops = {
 	.queue_setup = histo_queue_setup,
 	.buf_prepare = histo_buffer_prepare,
 	.buf_queue = histo_buffer_queue,
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 42d74fc1119f..6e5077beb38c 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -107,7 +107,7 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops hsit_pad_ops = {
+static const struct v4l2_subdev_pad_ops hsit_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = hsit_enum_mbus_code,
 	.enum_frame_size = hsit_enum_frame_size,
@@ -115,7 +115,7 @@ static struct v4l2_subdev_pad_ops hsit_pad_ops = {
 	.set_fmt = hsit_set_format,
 };
 
-static struct v4l2_subdev_ops hsit_ops = {
+static const struct v4l2_subdev_ops hsit_ops = {
 	.pad    = &hsit_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index b7b69b043bdb..a720063f38c5 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -104,7 +104,7 @@ static int lif_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops lif_pad_ops = {
+static const struct v4l2_subdev_pad_ops lif_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lif_enum_mbus_code,
 	.enum_frame_size = lif_enum_frame_size,
@@ -112,7 +112,7 @@ static struct v4l2_subdev_pad_ops lif_pad_ops = {
 	.set_fmt = lif_set_format,
 };
 
-static struct v4l2_subdev_ops lif_ops = {
+static const struct v4l2_subdev_ops lif_ops = {
 	.pad    = &lif_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index e34237824a5a..dc31de9602ba 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -165,7 +165,7 @@ static int lut_set_format(struct v4l2_subdev *subdev,
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_pad_ops lut_pad_ops = {
+static const struct v4l2_subdev_pad_ops lut_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lut_enum_mbus_code,
 	.enum_frame_size = lut_enum_frame_size,
@@ -173,7 +173,7 @@ static struct v4l2_subdev_pad_ops lut_pad_ops = {
 	.set_fmt = lut_set_format,
 };
 
-static struct v4l2_subdev_ops lut_ops = {
+static const struct v4l2_subdev_ops lut_ops = {
 	.pad    = &lut_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index a4bf6e1bcaea..388838913205 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -38,7 +38,7 @@ static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf,
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_ops rpf_ops = {
+static const struct v4l2_subdev_ops rpf_ops = {
 	.pad    = &vsp1_rwpf_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 707d2b601f62..47f5e0cea2ce 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -239,7 +239,7 @@ static int sru_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops sru_pad_ops = {
+static const struct v4l2_subdev_pad_ops sru_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = sru_enum_mbus_code,
 	.enum_frame_size = sru_enum_frame_size,
@@ -247,7 +247,7 @@ static struct v4l2_subdev_pad_ops sru_pad_ops = {
 	.set_fmt = sru_set_format,
 };
 
-static struct v4l2_subdev_ops sru_ops = {
+static const struct v4l2_subdev_ops sru_ops = {
 	.pad    = &sru_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 5291f8b36688..652dcd895022 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -228,7 +228,7 @@ static int uds_set_format(struct v4l2_subdev *subdev,
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_pad_ops uds_pad_ops = {
+static const struct v4l2_subdev_pad_ops uds_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = uds_enum_mbus_code,
 	.enum_frame_size = uds_enum_frame_size,
@@ -236,7 +236,7 @@ static struct v4l2_subdev_pad_ops uds_pad_ops = {
 	.set_fmt = uds_set_format,
 };
 
-static struct v4l2_subdev_ops uds_ops = {
+static const struct v4l2_subdev_ops uds_ops = {
 	.pad    = &uds_pad_ops,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d20257b4054b..f2cb19bd86ca 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -708,7 +708,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&video->irqlock, flags);
 }
 
-static struct vb2_ops vsp1_video_queue_qops = {
+static const struct vb2_ops vsp1_video_queue_qops = {
 	.queue_setup = vsp1_video_queue_setup,
 	.buf_prepare = vsp1_video_buffer_prepare,
 	.buf_queue = vsp1_video_buffer_queue,
@@ -925,7 +925,7 @@ static int vsp1_video_release(struct file *file)
 	return 0;
 }
 
-static struct v4l2_file_operations vsp1_video_fops = {
+static const struct v4l2_file_operations vsp1_video_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = video_ioctl2,
 	.open = vsp1_video_open,
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 1281ab3fa59c..25d93fc984d2 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -151,11 +151,11 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_video_ops wpf_video_ops = {
+static const struct v4l2_subdev_video_ops wpf_video_ops = {
 	.s_stream = wpf_s_stream,
 };
 
-static struct v4l2_subdev_ops wpf_ops = {
+static const struct v4l2_subdev_ops wpf_ops = {
 	.video	= &wpf_video_ops,
 	.pad    = &vsp1_rwpf_pad_ops,
 };
-- 
Regards,

Laurent Pinchart

