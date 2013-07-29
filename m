Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1967 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3G2Mlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [RFC PATCH 6/8] v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
Date: Mon, 29 Jul 2013 14:40:59 +0200
Message-Id: <1375101661-6493-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new defines to calculate the full blanking and frame sizes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/i2c/ad9389b.c                    | 6 ++----
 drivers/media/i2c/adv7604.c                    | 8 ++++----
 drivers/media/i2c/ths7303.c                    | 6 ++----
 drivers/media/i2c/ths8200.c                    | 8 ++++----
 drivers/media/platform/blackfin/bfin_capture.c | 9 ++-------
 drivers/media/usb/hdpvr/hdpvr-video.c          | 6 ++----
 6 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 2fa8d72..5295234 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -445,10 +445,8 @@ static int ad9389b_log_status(struct v4l2_subdev *sd)
 	}
 	if (state->dv_timings.type == V4L2_DV_BT_656_1120) {
 		struct v4l2_bt_timings *bt = bt = &state->dv_timings.bt;
-		u32 frame_width = bt->width + bt->hfrontporch +
-			bt->hsync + bt->hbackporch;
-		u32 frame_height = bt->height + bt->vfrontporch +
-			bt->vsync + bt->vbackporch;
+		u32 frame_width = V4L2_DV_BT_FRAME_WIDTH(bt);
+		u32 frame_height = V4L2_DV_BT_FRAME_HEIGHT(bt);
 		u32 frame_size = frame_width * frame_height;
 
 		v4l2_info(sd, "timings: %ux%u%s%u (%ux%u). Pix freq. = %u Hz. Polarities = 0x%x\n",
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 181a6c3..3ec7ec0 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -261,22 +261,22 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 
 static inline unsigned hblanking(const struct v4l2_bt_timings *t)
 {
-	return t->hfrontporch + t->hsync + t->hbackporch;
+	return V4L2_DV_BT_BLANKING_WIDTH(t);
 }
 
 static inline unsigned htotal(const struct v4l2_bt_timings *t)
 {
-	return t->width + t->hfrontporch + t->hsync + t->hbackporch;
+	return V4L2_DV_BT_FRAME_WIDTH(t);
 }
 
 static inline unsigned vblanking(const struct v4l2_bt_timings *t)
 {
-	return t->vfrontporch + t->vsync + t->vbackporch;
+	return V4L2_DV_BT_BLANKING_HEIGHT(t);
 }
 
 static inline unsigned vtotal(const struct v4l2_bt_timings *t)
 {
-	return t->height + t->vfrontporch + t->vsync + t->vbackporch;
+	return V4L2_DV_BT_FRAME_HEIGHT(t);
 }
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 0a2dacb..42276d9 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -291,10 +291,8 @@ static int ths7303_log_status(struct v4l2_subdev *sd)
 		struct v4l2_bt_timings *bt = bt = &state->bt;
 		u32 frame_width, frame_height;
 
-		frame_width = bt->width + bt->hfrontporch +
-			      bt->hsync + bt->hbackporch;
-		frame_height = bt->height + bt->vfrontporch +
-			       bt->vsync + bt->vbackporch;
+		frame_width = V4L2_DV_BT_FRAME_WIDTH(bt);
+		frame_height = V4L2_DV_BT_FRAME_HEIGHT(bt);
 		v4l2_info(sd,
 			  "timings: %dx%d%s%d (%dx%d). Pix freq. = %d Hz. Polarities = 0x%x\n",
 			  bt->width, bt->height, bt->interlaced ? "i" : "p",
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index aef7c0e..28932e9 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -65,22 +65,22 @@ static inline struct ths8200_state *to_state(struct v4l2_subdev *sd)
 
 static inline unsigned hblanking(const struct v4l2_bt_timings *t)
 {
-	return t->hfrontporch + t->hsync + t->hbackporch;
+	return V4L2_DV_BT_BLANKING_WIDTH(t);
 }
 
 static inline unsigned htotal(const struct v4l2_bt_timings *t)
 {
-	return t->width + t->hfrontporch + t->hsync + t->hbackporch;
+	return V4L2_DV_BT_FRAME_WIDTH(t);
 }
 
 static inline unsigned vblanking(const struct v4l2_bt_timings *t)
 {
-	return t->vfrontporch + t->vsync + t->vbackporch;
+	return V4L2_DV_BT_BLANKING_HEIGHT(t);
 }
 
 static inline unsigned vtotal(const struct v4l2_bt_timings *t)
 {
-	return t->height + t->vfrontporch + t->vsync + t->vbackporch;
+	return V4L2_DV_BT_FRAME_HEIGHT(t);
 }
 
 static int ths8200_read(struct v4l2_subdev *sd, u8 reg)
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 7f838c6..4c11059 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -388,13 +388,8 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 		params.hdelay = bt->hsync + bt->hbackporch;
 		params.vdelay = bt->vsync + bt->vbackporch;
-		params.line = bt->hfrontporch + bt->hsync
-				+ bt->hbackporch + bt->width;
-		params.frame = bt->vfrontporch + bt->vsync
-				+ bt->vbackporch + bt->height;
-		if (bt->interlaced)
-			params.frame += bt->il_vfrontporch + bt->il_vsync
-					+ bt->il_vbackporch;
+		params.line = V4L2_DV_BT_FRAME_WIDTH(bt);
+		params.frame = V4L2_DV_BT_FRAME_HEIGHT(bt);
 	} else if (bcap_dev->cfg->inputs[bcap_dev->cur_input].capabilities
 			& V4L2_IN_CAP_STD) {
 		params.hdelay = 0;
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 9c67b6e..e68245a 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -690,10 +690,8 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
 		unsigned vsize;
 		unsigned fps;
 
-		hsize = bt->hfrontporch + bt->hsync + bt->hbackporch + bt->width;
-		vsize = bt->vfrontporch + bt->vsync + bt->vbackporch +
-			bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch +
-			bt->height;
+		hsize = V4L2_DV_BT_FRAME_WIDTH(bt);
+		vsize = V4L2_DV_BT_FRAME_HEIGHT(bt);
 		fps = (unsigned)bt->pixelclock / (hsize * vsize);
 		if (bt->width != vid_info.width ||
 		    bt->height != vid_info.height ||
-- 
1.8.3.2

