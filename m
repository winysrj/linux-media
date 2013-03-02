Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1404 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3CBXp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 16/20] solo6x10: drop video_type and add proper s_std support.
Date: Sun,  3 Mar 2013 00:45:32 +0100
Message-Id: <77525a98c070d163849fb0ef25729431e44a31f7.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/disp.c     |    8 +----
 drivers/staging/media/solo6x10/solo6x10.h |    3 ++
 drivers/staging/media/solo6x10/v4l2-enc.c |   33 +++++++++++++--------
 drivers/staging/media/solo6x10/v4l2.c     |   45 ++++++++++++++++++++++-------
 4 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/media/solo6x10/disp.c b/drivers/staging/media/solo6x10/disp.c
index 884c0eb..b91a6e2 100644
--- a/drivers/staging/media/solo6x10/disp.c
+++ b/drivers/staging/media/solo6x10/disp.c
@@ -33,10 +33,6 @@
 #define SOLO_MOT_FLAG_SIZE		512
 #define SOLO_MOT_FLAG_AREA		(SOLO_MOT_FLAG_SIZE * 32)
 
-static unsigned video_type;
-module_param(video_type, uint, 0644);
-MODULE_PARM_DESC(video_type, "video_type (0 = NTSC/Default, 1 = PAL)");
-
 static void solo_vin_config(struct solo_dev *solo_dev)
 {
 	solo_dev->vin_hstart = 8;
@@ -214,12 +210,10 @@ int solo_disp_init(struct solo_dev *solo_dev)
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
index facd395..d24b3cd 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -357,6 +357,9 @@ void solo_p2m_push_desc(struct p2m_desc *desc, int wr, dma_addr_t dma_addr,
 int solo_p2m_dma_desc(struct solo_dev *solo_dev, u8 id,
 		      struct p2m_desc *desc, int desc_count);
 
+/* Global s_std ioctl */
+int solo_set_video_type(struct solo_dev *solo_dev, bool type);
+
 /* Set the threshold for motion detection */
 void solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
 #define SOLO_DEF_MOT_THRESH		0x0300
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index fd9cf4f..5445e6f 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -909,11 +909,7 @@ static int solo_enc_enum_input(struct file *file, void *priv,
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
@@ -1083,11 +1079,25 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
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
@@ -1135,14 +1145,14 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 
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
@@ -1251,6 +1261,7 @@ static const struct v4l2_file_operations solo_enc_fops = {
 static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_querycap		= solo_enc_querycap,
 	.vidioc_s_std			= solo_enc_s_std,
+	.vidioc_g_std			= solo_enc_g_std,
 	/* Input callbacks */
 	.vidioc_enum_input		= solo_enc_enum_input,
 	.vidioc_s_input			= solo_enc_set_input,
@@ -1285,9 +1296,7 @@ static struct video_device solo_enc_template = {
 	.ioctl_ops		= &solo_enc_ioctl_ops,
 	.minor			= -1,
 	.release		= video_device_release,
-
-	.tvnorms		= V4L2_STD_NTSC_M | V4L2_STD_PAL_B,
-	.current_norm		= V4L2_STD_NTSC_M,
+	.tvnorms		= V4L2_STD_NTSC_M | V4L2_STD_PAL,
 };
 
 static const struct v4l2_ctrl_ops solo_ctrl_ops = {
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 8a4194b..a965b63 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -527,12 +527,7 @@ static int solo_enum_input(struct file *file, void *priv,
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
 
@@ -615,11 +610,42 @@ static int solo_get_fmt_cap(struct file *file, void *priv,
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
@@ -662,6 +688,7 @@ static const struct v4l2_file_operations solo_v4l2_fops = {
 static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 	.vidioc_querycap		= solo_querycap,
 	.vidioc_s_std			= solo_s_std,
+	.vidioc_g_std			= solo_g_std,
 	/* Input callbacks */
 	.vidioc_enum_input		= solo_enum_input,
 	.vidioc_s_input			= solo_set_input,
@@ -690,9 +717,7 @@ static struct video_device solo_v4l2_template = {
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

