Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2131 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3CRMcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 19/19] solo6x10: clean up motion detection handling.
Date: Mon, 18 Mar 2013 13:32:18 +0100
Message-Id: <1363609938-21735-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

An earlier patch temporarily disabled regional motion detection. This patch
adds it back: the 'Motion Detection Enable' control is now a 'Motion Detection Mode'.
And to set/get the regional thresholds two new ioctls were added to get/set those
thresholds.

The BUF_FLAG constants were also updated to prevent clashing with existing buffer
flags.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/disp.c     |   37 +++++-------
 drivers/staging/media/solo6x10/solo6x10.h |   27 +++++++--
 drivers/staging/media/solo6x10/v4l2-enc.c |   87 ++++++++++++++++++++---------
 3 files changed, 97 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/media/solo6x10/disp.c b/drivers/staging/media/solo6x10/disp.c
index 7007006..78070c8 100644
--- a/drivers/staging/media/solo6x10/disp.c
+++ b/drivers/staging/media/solo6x10/disp.c
@@ -201,31 +201,22 @@ int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
 				   val, SOLO_MOT_THRESH_SIZE);
 }
 
-int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch, u16 val,
-			   u16 block)
+int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
+		const struct solo_motion_thresholds *thresholds)
 {
-	u16 buf[64];
-	u32 addr;
-	int re;
-
-	addr = SOLO_MOTION_EXT_ADDR(solo_dev) +
-		SOLO_MOT_FLAG_AREA +
-		(SOLO_MOT_THRESH_SIZE * 2 * ch) +
-		(block * 2);
-
-	/* Read and write only on a 128-byte boundary; 4-byte writes with
-	   solo_p2m_dma silently failed. Bluecherry bug #908. */
-	re = solo_p2m_dma(solo_dev, 0, &buf, addr & ~0x7f, sizeof(buf), 0, 0);
-	if (re)
-		return re;
-
-	buf[(addr & 0x7f) / 2] = val;
-
-	re = solo_p2m_dma(solo_dev, 1, &buf, addr & ~0x7f, sizeof(buf), 0, 0);
-	if (re)
-		return re;
+	u32 off = SOLO_MOT_FLAG_AREA + ch * SOLO_MOT_THRESH_SIZE * 2;
+	u16 buf[SOLO_MOTION_SZ];
+	int x, y;
+	int ret = 0;
 
-	return 0;
+	for (y = 0; y < SOLO_MOTION_SZ; y++) {
+		for (x = 0; x < SOLO_MOTION_SZ; x++)
+			buf[x] = cpu_to_le16(thresholds->thresholds[y][x]);
+		ret |= solo_p2m_dma(solo_dev, 1, buf,
+			SOLO_MOTION_EXT_ADDR(solo_dev) + off + y * sizeof(buf),
+			sizeof(buf), 0, 0);
+	}
+	return ret;
 }
 
 /* First 8k is motion flag (512 bytes * 16). Following that is an 8k+8k
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 3313257..1d08dbc 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -98,16 +98,30 @@
 #define SOLO_DEFAULT_QP			3
 
 #ifndef V4L2_BUF_FLAG_MOTION_ON
-#define V4L2_BUF_FLAG_MOTION_ON		0x0400
-#define V4L2_BUF_FLAG_MOTION_DETECTED	0x0800
+#define V4L2_BUF_FLAG_MOTION_ON		0x10000
+#define V4L2_BUF_FLAG_MOTION_DETECTED	0x20000
 #endif
 
 #define SOLO_CID_CUSTOM_BASE		(V4L2_CID_USER_BASE | 0xf000)
-#define V4L2_CID_MOTION_ENABLE		(SOLO_CID_CUSTOM_BASE+0)
+#define V4L2_CID_MOTION_MODE		(SOLO_CID_CUSTOM_BASE+0)
 #define V4L2_CID_MOTION_THRESHOLD	(SOLO_CID_CUSTOM_BASE+1)
 #define V4L2_CID_MOTION_TRACE		(SOLO_CID_CUSTOM_BASE+2)
 #define V4L2_CID_OSD_TEXT		(SOLO_CID_CUSTOM_BASE+3)
 
+/*
+ * Motion thresholds are in a table of 64x64 samples, with
+ * each sample representing 16x16 pixels of the source. In
+ * effect, 44x30 samples are used for NTSC, and 44x36 for PAL.
+ * The 5th sample on the 10th row is (10*64)+5 = 645.
+ */
+#define SOLO_MOTION_SZ (64)
+struct solo_motion_thresholds {
+	__u16	thresholds[SOLO_MOTION_SZ][SOLO_MOTION_SZ];
+};
+
+#define SOLO_IOC_G_MOTION_THRESHOLDS	_IOR('V', BASE_VIDIOC_PRIVATE+0, struct solo_motion_thresholds)
+#define SOLO_IOC_S_MOTION_THRESHOLDS	_IOW('V', BASE_VIDIOC_PRIVATE+1, struct solo_motion_thresholds)
+
 enum SOLO_I2C_STATE {
 	IIC_STATE_IDLE,
 	IIC_STATE_START,
@@ -157,6 +171,9 @@ struct solo_enc_dev {
 	u8			mode, gop, qp, interlaced, interval;
 	u8			bw_weight;
 	u16			motion_thresh;
+	struct solo_motion_thresholds motion_thresholds;
+	bool			motion_global;
+	bool			motion_enabled;
 	u16			width;
 	u16			height;
 
@@ -381,8 +398,8 @@ void solo_update_mode(struct solo_enc_dev *solo_enc);
 
 /* Set the threshold for motion detection */
 int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
-int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch, u16 val,
-			   u16 block);
+int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
+		const struct solo_motion_thresholds *thresholds);
 #define SOLO_DEF_MOT_THRESH		0x0300
 
 /* Write text on OSD */
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 642ebbf..a3332fe 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -511,6 +511,8 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 	int ret;
 
 	/* Check for motion flags */
+	vb->v4l2_buf.flags &= ~(V4L2_BUF_FLAG_MOTION_ON |
+				V4L2_BUF_FLAG_MOTION_DETECTED);
 	if (solo_is_motion_on(solo_enc)) {
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_MOTION_ON;
 		if (enc_buf->motion)
@@ -1018,6 +1020,31 @@ static int solo_s_parm(struct file *file, void *priv,
 	return 0;
 }
 
+static long solo_enc_default(struct file *file, void *fh,
+			bool valid_prio, int cmd, void *arg)
+{
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_motion_thresholds *thresholds = arg;
+
+	switch (cmd) {
+	case SOLO_IOC_G_MOTION_THRESHOLDS:
+		*thresholds = solo_enc->motion_thresholds;
+		return 0;
+
+	case SOLO_IOC_S_MOTION_THRESHOLDS:
+		if (!valid_prio)
+			return -EBUSY;
+		solo_enc->motion_thresholds = *thresholds;
+		if (solo_enc->motion_enabled && !solo_enc->motion_global)
+			return solo_set_motion_block(solo_dev, solo_enc->ch,
+						&solo_enc->motion_thresholds);
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
 static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct solo_enc_dev *solo_enc =
@@ -1036,28 +1063,22 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		solo_enc->gop = ctrl->val;
 		return 0;
-	case V4L2_CID_MOTION_THRESHOLD: {
-		u16 block = (ctrl->val >> 16) & 0xffff;
-		u16 value = ctrl->val & 0xffff;
-
-		/* Motion thresholds are in a table of 64x64 samples, with
-		 * each sample representing 16x16 pixels of the source. In
-		 * effect, 44x30 samples are used for NTSC, and 44x36 for PAL.
-		 * The 5th sample on the 10th row is (10*64)+5 = 645.
-		 *
-		 * Block is 0 to set the threshold globally, or any positive
-		 * number under 2049 to set block-1 individually. */
-		/* Currently we limit support to block 0 only. A later patch
-		 * will add a new ioctl to set all other blocks. */
-		if (block == 0) {
-			solo_enc->motion_thresh = value;
-			return solo_set_motion_threshold(solo_dev,
-							 solo_enc->ch, value);
+	case V4L2_CID_MOTION_THRESHOLD:
+		solo_enc->motion_thresh = ctrl->val;
+		if (!solo_enc->motion_global || !solo_enc->motion_enabled)
+			return 0;
+		return solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->val);
+	case V4L2_CID_MOTION_MODE:
+		solo_enc->motion_global = ctrl->val == 1;
+		solo_enc->motion_enabled = ctrl->val > 0;
+		if (ctrl->val) {
+			if (solo_enc->motion_global)
+				solo_set_motion_threshold(solo_dev, solo_enc->ch,
+						solo_enc->motion_thresh);
+			else
+				solo_set_motion_block(solo_dev, solo_enc->ch,
+						&solo_enc->motion_thresholds);
 		}
-		return solo_set_motion_block(solo_dev, solo_enc->ch,
-						     value, block - 1);
-	}
-	case V4L2_CID_MOTION_ENABLE:
 		solo_motion_toggle(solo_enc, ctrl->val);
 		return 0;
 	case V4L2_CID_OSD_TEXT:
@@ -1111,6 +1132,7 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_log_status		= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+	.vidioc_default			= solo_enc_default,
 };
 
 static const struct video_device solo_enc_template = {
@@ -1137,13 +1159,20 @@ static const struct v4l2_ctrl_config solo_motion_threshold_ctrl = {
 	.flags = V4L2_CTRL_FLAG_SLIDER,
 };
 
+static const char * const solo_motion_mode_menu[] = {
+	"Disabled",
+	"Global Threshold",
+	"Regional Threshold",
+	NULL
+};
+
 static const struct v4l2_ctrl_config solo_motion_enable_ctrl = {
 	.ops = &solo_ctrl_ops,
-	.id = V4L2_CID_MOTION_ENABLE,
-	.name = "Motion Detection Enable",
-	.type = V4L2_CTRL_TYPE_BOOLEAN,
-	.max = 1,
-	.step = 1,
+	.id = V4L2_CID_MOTION_MODE,
+	.name = "Motion Detection Mode",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.qmenu = solo_motion_mode_menu,
+	.max = 2,
 };
 
 static const struct v4l2_ctrl_config solo_osd_text_ctrl = {
@@ -1161,6 +1190,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	struct solo_enc_dev *solo_enc;
 	struct v4l2_ctrl_handler *hdl;
 	int ret;
+	int x, y;
 
 	solo_enc = kzalloc(sizeof(*solo_enc), GFP_KERNEL);
 	if (!solo_enc)
@@ -1201,7 +1231,12 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	solo_enc->gop = solo_dev->fps;
 	solo_enc->interval = 1;
 	solo_enc->mode = SOLO_ENC_MODE_CIF;
+	solo_enc->motion_global = true;
 	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
+	for (y = 0; y < SOLO_MOTION_SZ; y++)
+		for (x = 0; x < SOLO_MOTION_SZ; x++)
+			solo_enc->motion_thresholds.thresholds[y][x] =
+							SOLO_DEF_MOT_THRESH;
 
 	solo_enc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	solo_enc->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
-- 
1.7.10.4

