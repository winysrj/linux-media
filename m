Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4114 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaBQKIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 05:08:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 31/35] solo6x10: implement the new motion detection controls.
Date: Mon, 17 Feb 2014 10:57:46 +0100
Message-Id: <1392631070-41868-32-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace the custom ioctls to set motion detection thresholds by standard
matrix controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-disp.c     |   4 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 103 +++++++--------------
 drivers/staging/media/solo6x10/solo6x10.h          |  19 +---
 3 files changed, 40 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-disp.c b/drivers/staging/media/solo6x10/solo6x10-disp.c
index 145295a..44d98b8 100644
--- a/drivers/staging/media/solo6x10/solo6x10-disp.c
+++ b/drivers/staging/media/solo6x10/solo6x10-disp.c
@@ -211,7 +211,7 @@ int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
 }
 
 int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
-		const struct solo_motion_thresholds *thresholds)
+		const u16 *thresholds)
 {
 	u32 off = SOLO_MOT_FLAG_AREA + ch * SOLO_MOT_THRESH_SIZE * 2;
 	u16 buf[64];
@@ -221,7 +221,7 @@ int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 	memset(buf, 0, sizeof(buf));
 	for (y = 0; y < SOLO_MOTION_SZ; y++) {
 		for (x = 0; x < SOLO_MOTION_SZ; x++)
-			buf[x] = cpu_to_le16(thresholds->thresholds[y][x]);
+			buf[x] = cpu_to_le16(thresholds[y * SOLO_MOTION_SZ + x]);
 		ret |= solo_p2m_dma(solo_dev, 1, buf,
 			SOLO_MOTION_EXT_ADDR(solo_dev) + off + y * sizeof(buf),
 			sizeof(buf), 0, 0);
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index d19743b..a56a687 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1065,31 +1065,6 @@ static int solo_s_parm(struct file *file, void *priv,
 	return solo_g_parm(file, priv, sp);
 }
 
-static long solo_enc_default(struct file *file, void *fh,
-			bool valid_prio, unsigned int cmd, void *arg)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct solo_motion_thresholds *thresholds = arg;
-
-	switch (cmd) {
-	case SOLO_IOC_G_MOTION_THRESHOLDS:
-		*thresholds = solo_enc->motion_thresholds;
-		return 0;
-
-	case SOLO_IOC_S_MOTION_THRESHOLDS:
-		if (!valid_prio)
-			return -EBUSY;
-		solo_enc->motion_thresholds = *thresholds;
-		if (solo_enc->motion_enabled && !solo_enc->motion_global)
-			return solo_set_motion_block(solo_dev, solo_enc->ch,
-						&solo_enc->motion_thresholds);
-		return 0;
-	default:
-		return -ENOTTY;
-	}
-}
-
 static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct solo_enc_dev *solo_enc =
@@ -1108,24 +1083,30 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		solo_enc->gop = ctrl->val;
 		return 0;
-	case V4L2_CID_MOTION_THRESHOLD:
-		solo_enc->motion_thresh = ctrl->val;
+	case V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD:
+		solo_enc->motion_thresh = ctrl->val << 8;
 		if (!solo_enc->motion_global || !solo_enc->motion_enabled)
 			return 0;
-		return solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->val);
-	case V4L2_CID_MOTION_MODE:
-		solo_enc->motion_global = ctrl->val == 1;
-		solo_enc->motion_enabled = ctrl->val > 0;
+		return solo_set_motion_threshold(solo_dev, solo_enc->ch,
+				solo_enc->motion_thresh);
+	case V4L2_CID_DETECT_MD_MODE:
+		solo_enc->motion_global = ctrl->val == V4L2_DETECT_MD_MODE_GLOBAL;
+		solo_enc->motion_enabled = ctrl->val > V4L2_DETECT_MD_MODE_DISABLED;
 		if (ctrl->val) {
 			if (solo_enc->motion_global)
 				solo_set_motion_threshold(solo_dev, solo_enc->ch,
-						solo_enc->motion_thresh);
+					solo_enc->motion_thresh);
 			else
 				solo_set_motion_block(solo_dev, solo_enc->ch,
-						&solo_enc->motion_thresholds);
+					solo_enc->md_thresholds->cur.p_u16);
 		}
 		solo_motion_toggle(solo_enc, ctrl->val);
 		return 0;
+	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
+		if (solo_enc->motion_enabled && !solo_enc->motion_global)
+			return solo_set_motion_block(solo_dev, solo_enc->ch,
+					solo_enc->md_thresholds->new.p_u16);
+		break;
 	case V4L2_CID_OSD_TEXT:
 		strcpy(solo_enc->osd_text, ctrl->new.p_char);
 		err = solo_osd_print(solo_enc);
@@ -1177,7 +1158,6 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_log_status		= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
-	.vidioc_default			= solo_enc_default,
 };
 
 static const struct video_device solo_enc_template = {
@@ -1193,33 +1173,6 @@ static const struct v4l2_ctrl_ops solo_ctrl_ops = {
 	.s_ctrl = solo_s_ctrl,
 };
 
-static const struct v4l2_ctrl_config solo_motion_threshold_ctrl = {
-	.ops = &solo_ctrl_ops,
-	.id = V4L2_CID_MOTION_THRESHOLD,
-	.name = "Motion Detection Threshold",
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.max = 0xffff,
-	.def = SOLO_DEF_MOT_THRESH,
-	.step = 1,
-	.flags = V4L2_CTRL_FLAG_SLIDER,
-};
-
-static const char * const solo_motion_mode_menu[] = {
-	"Disabled",
-	"Global Threshold",
-	"Regional Threshold",
-	NULL
-};
-
-static const struct v4l2_ctrl_config solo_motion_enable_ctrl = {
-	.ops = &solo_ctrl_ops,
-	.id = V4L2_CID_MOTION_MODE,
-	.name = "Motion Detection Mode",
-	.type = V4L2_CTRL_TYPE_MENU,
-	.qmenu = solo_motion_mode_menu,
-	.max = 2,
-};
-
 static const struct v4l2_ctrl_config solo_osd_text_ctrl = {
 	.ops = &solo_ctrl_ops,
 	.id = V4L2_CID_OSD_TEXT,
@@ -1229,13 +1182,23 @@ static const struct v4l2_ctrl_config solo_osd_text_ctrl = {
 	.step = 1,
 };
 
+/* Motion Detection Threshold matrix */
+static const struct v4l2_ctrl_config solo_md_thresholds = {
+	.ops = &solo_ctrl_ops,
+	.id = V4L2_CID_DETECT_MD_THRESHOLD_GRID,
+	.rows = SOLO_MOTION_SZ,
+	.cols = SOLO_MOTION_SZ,
+	.def = SOLO_DEF_MOT_THRESH,
+	.max = 65535,
+	.step = 1,
+};
+
 static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 					   u8 ch, unsigned nr)
 {
 	struct solo_enc_dev *solo_enc;
 	struct v4l2_ctrl_handler *hdl;
 	int ret;
-	int x, y;
 
 	solo_enc = kzalloc(sizeof(*solo_enc), GFP_KERNEL);
 	if (!solo_enc)
@@ -1256,9 +1219,16 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 			V4L2_CID_SHARPNESS, 0, 15, 1, 0);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, solo_dev->fps);
-	v4l2_ctrl_new_custom(hdl, &solo_motion_threshold_ctrl, NULL);
-	v4l2_ctrl_new_custom(hdl, &solo_motion_enable_ctrl, NULL);
+	v4l2_ctrl_new_std_menu(hdl, &solo_ctrl_ops,
+			V4L2_CID_DETECT_MD_MODE,
+			V4L2_DETECT_MD_MODE_THRESHOLD_GRID, 0,
+			V4L2_DETECT_MD_MODE_DISABLED);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD, 0, 0xff, 1,
+			SOLO_DEF_MOT_THRESH >> 8);
 	v4l2_ctrl_new_custom(hdl, &solo_osd_text_ctrl, NULL);
+	solo_enc->md_thresholds =
+		v4l2_ctrl_new_custom(hdl, &solo_md_thresholds, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
 		goto hdl_free;
@@ -1279,11 +1249,6 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	solo_enc->mode = SOLO_ENC_MODE_CIF;
 	solo_enc->motion_global = true;
 	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
-	for (y = 0; y < SOLO_MOTION_SZ; y++)
-		for (x = 0; x < SOLO_MOTION_SZ; x++)
-			solo_enc->motion_thresholds.thresholds[y][x] =
-							SOLO_DEF_MOT_THRESH;
-
 	solo_enc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	solo_enc->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	solo_enc->vidq.ops = &solo_enc_video_qops;
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 8964f8b..19cb56b 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -102,8 +102,6 @@
 #endif
 
 #define SOLO_CID_CUSTOM_BASE		(V4L2_CID_USER_BASE | 0xf000)
-#define V4L2_CID_MOTION_MODE		(SOLO_CID_CUSTOM_BASE+0)
-#define V4L2_CID_MOTION_THRESHOLD	(SOLO_CID_CUSTOM_BASE+1)
 #define V4L2_CID_MOTION_TRACE		(SOLO_CID_CUSTOM_BASE+2)
 #define V4L2_CID_OSD_TEXT		(SOLO_CID_CUSTOM_BASE+3)
 
@@ -113,19 +111,10 @@
  * effect, 44x30 samples are used for NTSC, and 44x36 for PAL.
  * The 5th sample on the 10th row is (10*64)+5 = 645.
  *
- * Using a 64x64 array will result in a problem on some architectures like
- * the powerpc where the size of the argument is limited to 13 bits.
- * Since both PAL and NTSC do not use the full table anyway I've chosen
- * to limit the array to 45x45 (45*16 = 720, which is the maximum PAL/NTSC
- * width).
+ * Internally it is stored as a 45x45 array (45*16 = 720, which is the
+ * maximum PAL/NTSC width).
  */
 #define SOLO_MOTION_SZ (45)
-struct solo_motion_thresholds {
-	__u16	thresholds[SOLO_MOTION_SZ][SOLO_MOTION_SZ];
-};
-
-#define SOLO_IOC_G_MOTION_THRESHOLDS	_IOR('V', BASE_VIDIOC_PRIVATE+0, struct solo_motion_thresholds)
-#define SOLO_IOC_S_MOTION_THRESHOLDS	_IOW('V', BASE_VIDIOC_PRIVATE+1, struct solo_motion_thresholds)
 
 enum SOLO_I2C_STATE {
 	IIC_STATE_IDLE,
@@ -168,6 +157,7 @@ struct solo_enc_dev {
 	struct solo_dev	*solo_dev;
 	/* V4L2 Items */
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *md_thresholds;
 	struct video_device	*vfd;
 	/* General accounting */
 	struct mutex		lock;
@@ -176,7 +166,6 @@ struct solo_enc_dev {
 	u8			mode, gop, qp, interlaced, interval;
 	u8			bw_weight;
 	u16			motion_thresh;
-	struct solo_motion_thresholds motion_thresholds;
 	bool			motion_global;
 	bool			motion_enabled;
 	u16			width;
@@ -404,7 +393,7 @@ void solo_update_mode(struct solo_enc_dev *solo_enc);
 /* Set the threshold for motion detection */
 int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
 int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
-		const struct solo_motion_thresholds *thresholds);
+		const u16 *thresholds);
 #define SOLO_DEF_MOT_THRESH		0x0300
 
 /* Write text on OSD */
-- 
1.8.4.rc3

