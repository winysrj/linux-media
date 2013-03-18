Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4127 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3CRMcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 13/19] solo6x10: drop video_type and add proper s_std support.
Date: Mon, 18 Mar 2013 13:32:12 +0100
Message-Id: <1363609938-21735-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/core.c     |   19 ------------
 drivers/staging/media/solo6x10/disp.c     |    8 +----
 drivers/staging/media/solo6x10/solo6x10.h |    6 +++-
 drivers/staging/media/solo6x10/tw28.c     |    2 ++
 drivers/staging/media/solo6x10/v4l2-enc.c |   37 ++++++++++++++---------
 drivers/staging/media/solo6x10/v4l2.c     |   47 +++++++++++++++++++++++------
 6 files changed, 67 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index b7e5d5e..00fb35a 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -231,24 +231,6 @@ static ssize_t eeprom_show(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static ssize_t video_type_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	return -EPERM;
-}
-
-static ssize_t video_type_show(struct device *dev,
-			       struct device_attribute *attr,
-			       char *buf)
-{
-	struct solo_dev *solo_dev =
-		container_of(dev, struct solo_dev, dev);
-
-	return sprintf(buf, "%s", solo_dev->video_type ==
-		       SOLO_VO_FMT_TYPE_NTSC ? "NTSC" : "PAL");
-}
-
 static ssize_t p2m_timeouts_show(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
@@ -435,7 +417,6 @@ static ssize_t sdram_show(struct file *file, struct kobject *kobj,
 
 static const struct device_attribute solo_dev_attrs[] = {
 	__ATTR(eeprom, 0640, eeprom_show, eeprom_store),
-	__ATTR(video_type, 0644, video_type_show, video_type_store),
 	__ATTR(p2m_timeout, 0644, p2m_timeout_show, p2m_timeout_store),
 	__ATTR_RO(p2m_timeouts),
 	__ATTR_RO(sdram_size),
diff --git a/drivers/staging/media/solo6x10/disp.c b/drivers/staging/media/solo6x10/disp.c
index ddd85e7..3dcaad9 100644
--- a/drivers/staging/media/solo6x10/disp.c
+++ b/drivers/staging/media/solo6x10/disp.c
@@ -39,10 +39,6 @@
 #define SOLO_MOT_FLAG_SIZE		1024
 #define SOLO_MOT_FLAG_AREA		(SOLO_MOT_FLAG_SIZE * 16)
 
-static unsigned video_type;
-module_param(video_type, uint, 0644);
-MODULE_PARM_DESC(video_type, "video_type (0 = NTSC/Default, 1 = PAL)");
-
 static void solo_vin_config(struct solo_dev *solo_dev)
 {
 	solo_dev->vin_hstart = 8;
@@ -273,12 +269,10 @@ int solo_disp_init(struct solo_dev *solo_dev)
 	int i;
 
 	solo_dev->video_hsize = 704;
-	if (video_type == 0) {
-		solo_dev->video_type = SOLO_VO_FMT_TYPE_NTSC;
+	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC) {
 		solo_dev->video_vsize = 240;
 		solo_dev->fps = 30;
 	} else {
-		solo_dev->video_type = SOLO_VO_FMT_TYPE_PAL;
 		solo_dev->video_vsize = 288;
 		solo_dev->fps = 25;
 	}
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 96ac299..56789b4 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -320,7 +320,7 @@ static inline void solo_irq_off(struct solo_dev *dev, u32 mask)
 	solo_reg_write(dev, SOLO_IRQ_MASK, dev->irq_mask);
 }
 
-/* Init/exit routeines for subsystems */
+/* Init/exit routines for subsystems */
 int solo_disp_init(struct solo_dev *solo_dev);
 void solo_disp_exit(struct solo_dev *solo_dev);
 
@@ -373,6 +373,10 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 		      struct solo_p2m_desc *desc, dma_addr_t desc_dma,
 		      int desc_cnt);
 
+/* Global s_std ioctl */
+int solo_set_video_type(struct solo_dev *solo_dev, bool type);
+void solo_update_mode(struct solo_enc_dev *solo_enc);
+
 /* Set the threshold for motion detection */
 int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
 int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch, u16 val,
diff --git a/drivers/staging/media/solo6x10/tw28.c b/drivers/staging/media/solo6x10/tw28.c
index 69baf82..6c77af8 100644
--- a/drivers/staging/media/solo6x10/tw28.c
+++ b/drivers/staging/media/solo6x10/tw28.c
@@ -576,6 +576,8 @@ int solo_tw28_init(struct solo_dev *solo_dev)
 	int i;
 	u8 value;
 
+	solo_dev->tw28_cnt = 0;
+
 	/* Detect techwell chip type(s) */
 	for (i = 0; i < solo_dev->nr_chans / 4; i++) {
 		value = solo_i2c_readbyte(solo_dev, SOLO_I2C_TW,
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index dc1f8b3..93f0dc7 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -176,7 +176,7 @@ static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 	spin_unlock_irqrestore(&solo_enc->motion_lock, flags);
 }
 
-static void solo_update_mode(struct solo_enc_dev *solo_enc)
+void solo_update_mode(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	int vop_len;
@@ -749,11 +749,7 @@ static int solo_enc_enum_input(struct file *file, void *priv,
 	snprintf(input->name, sizeof(input->name), "Encoder %d",
 		 solo_enc->ch + 1);
 	input->type = V4L2_INPUT_TYPE_CAMERA;
-
-	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC)
-		input->std = V4L2_STD_NTSC_M;
-	else
-		input->std = V4L2_STD_PAL_B;
+	input->std = solo_enc->vfd->tvnorms;
 
 	if (!tw28_get_video_status(solo_dev, solo_enc->ch))
 		input->status = V4L2_IN_ST_NO_SIGNAL;
@@ -886,11 +882,25 @@ static int solo_enc_get_fmt_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
+static int solo_enc_g_std(struct file *file, void *priv, v4l2_std_id *i)
 {
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
+
+	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC)
+		*i = V4L2_STD_NTSC_M;
+	else
+		*i = V4L2_STD_PAL;
 	return 0;
 }
 
+static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+
+	return solo_set_video_type(solo_enc->solo_dev, *std & V4L2_STD_PAL);
+}
+
 static int solo_enum_framesizes(struct file *file, void *priv,
 				struct v4l2_frmsizeenum *fsize)
 {
@@ -938,14 +948,14 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 
 	fintv->type = V4L2_FRMIVAL_TYPE_STEPWISE;
 
+	fintv->stepwise.min.numerator = 1;
 	fintv->stepwise.min.denominator = solo_dev->fps;
-	fintv->stepwise.min.numerator = 15;
 
+	fintv->stepwise.max.numerator = 15;
 	fintv->stepwise.max.denominator = solo_dev->fps;
-	fintv->stepwise.max.numerator = 1;
 
 	fintv->stepwise.step.numerator = 1;
-	fintv->stepwise.step.denominator = 1;
+	fintv->stepwise.step.denominator = solo_dev->fps;
 
 	return 0;
 }
@@ -1067,6 +1077,7 @@ static const struct v4l2_file_operations solo_enc_fops = {
 static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_querycap		= solo_enc_querycap,
 	.vidioc_s_std			= solo_enc_s_std,
+	.vidioc_g_std			= solo_enc_g_std,
 	/* Input callbacks */
 	.vidioc_enum_input		= solo_enc_enum_input,
 	.vidioc_s_input			= solo_enc_set_input,
@@ -1101,9 +1112,7 @@ static const struct video_device solo_enc_template = {
 	.ioctl_ops		= &solo_enc_ioctl_ops,
 	.minor			= -1,
 	.release		= video_device_release,
-
-	.tvnorms		= V4L2_STD_NTSC_M | V4L2_STD_PAL_B,
-	.current_norm		= V4L2_STD_NTSC_M,
+	.tvnorms		= V4L2_STD_NTSC_M | V4L2_STD_PAL,
 };
 
 static const struct v4l2_ctrl_ops solo_ctrl_ops = {
@@ -1203,9 +1212,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	ret = vb2_queue_init(&solo_enc->vidq);
 	if (ret)
 		goto hdl_free;
-	spin_lock(&solo_enc->av_lock);
 	solo_update_mode(solo_enc);
-	spin_unlock(&solo_enc->av_lock);
 
 	spin_lock_init(&solo_enc->motion_lock);
 
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 6931950..94db4c2 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -426,12 +426,7 @@ static int solo_enum_input(struct file *file, void *priv,
 	}
 
 	input->type = V4L2_INPUT_TYPE_CAMERA;
-
-	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC)
-		input->std = V4L2_STD_NTSC_M;
-	else
-		input->std = V4L2_STD_PAL_B;
-
+	input->std = solo_dev->vfd->tvnorms;
 	return 0;
 }
 
@@ -520,11 +515,44 @@ static int solo_get_fmt_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int solo_s_std(struct file *file, void *priv, v4l2_std_id *i)
+static int solo_g_std(struct file *file, void *priv, v4l2_std_id *i)
 {
+	struct solo_dev *solo_dev = video_drvdata(file);
+
+	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC)
+		*i = V4L2_STD_NTSC_M;
+	else
+		*i = V4L2_STD_PAL;
 	return 0;
 }
 
+int solo_set_video_type(struct solo_dev *solo_dev, bool type)
+{
+	int i;
+
+	/* Make sure all video nodes are idle */
+	if (vb2_is_busy(&solo_dev->vidq))
+		return -EBUSY;
+	for (i = 0; i < solo_dev->nr_chans; i++)
+		if (vb2_is_busy(&solo_dev->v4l2_enc[i]->vidq))
+			return -EBUSY;
+	solo_dev->video_type = type;
+	/* Reconfigure for the new standard */
+	solo_disp_init(solo_dev);
+	solo_enc_init(solo_dev);
+	solo_tw28_init(solo_dev);
+	for (i = 0; i < solo_dev->nr_chans; i++)
+		solo_update_mode(solo_dev->v4l2_enc[i]);
+	return solo_v4l2_set_ch(solo_dev, solo_dev->cur_disp_ch);
+}
+
+static int solo_s_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct solo_dev *solo_dev = video_drvdata(file);
+
+	return solo_set_video_type(solo_dev, *std & V4L2_STD_PAL);
+}
+
 static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct solo_dev *solo_dev =
@@ -567,6 +595,7 @@ static const struct v4l2_file_operations solo_v4l2_fops = {
 static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 	.vidioc_querycap		= solo_querycap,
 	.vidioc_s_std			= solo_s_std,
+	.vidioc_g_std			= solo_g_std,
 	/* Input callbacks */
 	.vidioc_enum_input		= solo_enum_input,
 	.vidioc_s_input			= solo_set_input,
@@ -595,9 +624,7 @@ static struct video_device solo_v4l2_template = {
 	.ioctl_ops		= &solo_v4l2_ioctl_ops,
 	.minor			= -1,
 	.release		= video_device_release,
-
-	.tvnorms		= V4L2_STD_NTSC_M | V4L2_STD_PAL_B,
-	.current_norm		= V4L2_STD_NTSC_M,
+	.tvnorms		= V4L2_STD_NTSC_M | V4L2_STD_PAL,
 };
 
 static const struct v4l2_ctrl_ops solo_ctrl_ops = {
-- 
1.7.10.4

