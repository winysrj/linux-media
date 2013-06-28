Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3123 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab3F1M2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 08:28:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/5] solo: implement the new matrix ioctls instead of the custom ones.
Date: Fri, 28 Jun 2013 14:27:32 +0200
Message-Id: <1372422454-13752-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 102 ++++++++++++++++++---
 drivers/staging/media/solo6x10/solo6x10.h          |  10 +-
 2 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index a4c5896..2058f4d 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1033,29 +1033,98 @@ static int solo_s_parm(struct file *file, void *priv,
 	return solo_g_parm(file, priv, sp);
 }
 
-static long solo_enc_default(struct file *file, void *fh,
-			bool valid_prio, unsigned int cmd, void *arg)
+static int solo_query_matrix(struct file *file, void *fh,
+			struct v4l2_query_matrix *qm)
+{
+	qm->columns = 45;
+	qm->rows = 36;
+	switch (qm->type) {
+	case V4L2_MATRIX_TYPE_MD_REGION:
+		qm->elem_size = 1;
+		break;
+	case V4L2_MATRIX_TYPE_MD_THRESHOLD:
+		qm->elem_max.val = 65535;
+		qm->elem_size = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int solo_g_matrix(struct file *file, void *fh,
+			struct v4l2_matrix *m)
+{
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	int w = m->rect.width;
+	int h = m->rect.height;
+	u16 *mt;
+	int y;
+
+	if (m->rect.top < 0 || m->rect.top + h > 35 || h < 0 || w < 0 ||
+	    m->rect.left < 0 || m->rect.left + w >= SOLO_MOTION_SZ)
+		return -EINVAL;
+	if (h == 0 || w == 0)
+		return 0;
+
+	switch (m->type) {
+	case V4L2_MATRIX_TYPE_MD_REGION:
+		return clear_user(m->matrix, w * h);
+	case V4L2_MATRIX_TYPE_MD_THRESHOLD:
+		mt = &solo_enc->motion_thresholds.thresholds[m->rect.top][m->rect.left];
+		for (y = 0; y < h; y++, mt += SOLO_MOTION_SZ)
+			if (copy_to_user(m->matrix + y * w * 2, mt, w * 2))
+				return -EFAULT;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int solo_s_matrix(struct file *file, void *fh,
+			struct v4l2_matrix *m)
 {
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct solo_motion_thresholds *thresholds = arg;
+	int w = m->rect.width;
+	int h = m->rect.height;
+	u16 *mt;
+	int y;
 
-	switch (cmd) {
-	case SOLO_IOC_G_MOTION_THRESHOLDS:
-		*thresholds = solo_enc->motion_thresholds;
+	if (m->rect.top < 0 || m->rect.top + h > 35 || h < 0 || w < 0 ||
+	    m->rect.left < 0 || m->rect.left + w >= SOLO_MOTION_SZ)
+		return -EINVAL;
+	if (h == 0 || w == 0)
 		return 0;
 
-	case SOLO_IOC_S_MOTION_THRESHOLDS:
-		if (!valid_prio)
-			return -EBUSY;
-		solo_enc->motion_thresholds = *thresholds;
-		if (solo_enc->motion_enabled && !solo_enc->motion_global)
-			return solo_set_motion_block(solo_dev, solo_enc->ch,
-						&solo_enc->motion_thresholds);
+	switch (m->type) {
+	case V4L2_MATRIX_TYPE_MD_REGION:
+		/* Check that the region matrix is all zeroes */
+		for (y = 0; y < h; y++) {
+			u8 region[SOLO_MOTION_SZ];
+			static const u8 zeroes[SOLO_MOTION_SZ];
+
+			if (copy_from_user(region, m->matrix + y * w, w))
+				return -EFAULT;
+			if (memcmp(region, zeroes, w))
+				return -EINVAL;
+		}
 		return 0;
+	case V4L2_MATRIX_TYPE_MD_THRESHOLD:
+		mt = &solo_enc->motion_thresholds.thresholds[m->rect.top][m->rect.left];
+		for (y = 0; y < h; y++, mt += SOLO_MOTION_SZ)
+			if (copy_from_user(mt, m->matrix + y * w * 2, w * 2))
+				return -EFAULT;
+		break;
 	default:
-		return -ENOTTY;
+		return -EINVAL;
 	}
+
+	if (solo_enc->motion_enabled && !solo_enc->motion_global)
+		return solo_set_motion_block(solo_dev, solo_enc->ch,
+				&solo_enc->motion_thresholds);
+	return 0;
 }
 
 static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1141,11 +1210,14 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	/* Video capture parameters */
 	.vidioc_s_parm			= solo_s_parm,
 	.vidioc_g_parm			= solo_g_parm,
+	/* Motion Detection matrices */
+	.vidioc_query_matrix		= solo_query_matrix,
+	.vidioc_g_matrix		= solo_g_matrix,
+	.vidioc_s_matrix		= solo_s_matrix,
 	/* Logging and events */
 	.vidioc_log_status		= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
-	.vidioc_default			= solo_enc_default,
 };
 
 static const struct video_device solo_enc_template = {
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 6f91d2e..01c8655 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -114,20 +114,14 @@
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
 struct solo_motion_thresholds {
 	__u16	thresholds[SOLO_MOTION_SZ][SOLO_MOTION_SZ];
 };
 
-#define SOLO_IOC_G_MOTION_THRESHOLDS	_IOR('V', BASE_VIDIOC_PRIVATE+0, struct solo_motion_thresholds)
-#define SOLO_IOC_S_MOTION_THRESHOLDS	_IOW('V', BASE_VIDIOC_PRIVATE+1, struct solo_motion_thresholds)
-
 enum SOLO_I2C_STATE {
 	IIC_STATE_IDLE,
 	IIC_STATE_START,
-- 
1.8.3.1

