Return-path: <mchehab@gaivota>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:2687 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab0LPP1M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 10:27:12 -0500
From: mats.randgaard@cisco.com
To: linux-media@vger.kernel.org
Cc: mats.randgaard@cisco.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] vpif_cap/disp: Added support for DV timings
Date: Thu, 16 Dec 2010 16:17:44 +0100
Message-Id: <1292512665-22538-5-git-send-email-mats.randgaard@cisco.com>
In-Reply-To: <1292512665-22538-1-git-send-email-mats.randgaard@cisco.com>
References: <1292512665-22538-1-git-send-email-mats.randgaard@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Mats Randgaard <mats.randgaard@cisco.com>

Added functions to set and get custom DV timings.

Signed-off-by: Mats Randgaard <mats.randgaard@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/vpif_capture.c |  123 ++++++++++++++++++
 drivers/media/video/davinci/vpif_capture.h |    1 +
 drivers/media/video/davinci/vpif_display.c |  190 ++++++++++++++++++++++++----
 drivers/media/video/davinci/vpif_display.h |    1 +
 4 files changed, 290 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index f713d08..ff08633 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -1452,6 +1452,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 
 	ch->video.stdid = *std_id;
 	ch->video.dv_preset = V4L2_DV_INVALID;
+	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
 
 	/* Get the information about the standard */
 	if (vpif_update_std_info(ch)) {
@@ -1874,6 +1875,7 @@ static int vpif_s_dv_preset(struct file *file, void *priv,
 
 	ch->video.dv_preset = preset->preset;
 	ch->video.stdid = V4L2_STD_UNKNOWN;
+	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
 
 	/* Get the information about the standard */
 	if (vpif_update_std_info(ch)) {
@@ -1908,6 +1910,125 @@ static int vpif_g_dv_preset(struct file *file, void *priv,
 	return 0;
 }
 
+/**
+ * vpif_s_dv_timings() - S_DV_TIMINGS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @timings: digital video timings
+ */
+static int vpif_s_dv_timings(struct file *file, void *priv,
+		struct v4l2_dv_timings *timings)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct vpif_params *vpifparams = &ch->vpifparams;
+	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
+	struct video_obj *vid_ch = &ch->video;
+	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
+	int ret;
+
+	if (timings->type != V4L2_DV_BT_656_1120) {
+		vpif_dbg(2, debug, "Timing type not defined\n");
+		return -EINVAL;
+	}
+
+	/* Configure subdevice timings, if any */
+	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
+			video, s_dv_timings, timings);
+	if (ret == -ENOIOCTLCMD) {
+		vpif_dbg(2, debug, "Custom DV timings not supported by "
+				"subdevice\n");
+		return -EINVAL;
+	}
+	if (ret < 0) {
+		vpif_dbg(2, debug, "Error setting custom DV timings\n");
+		return ret;
+	}
+
+	if (!(timings->bt.width && timings->bt.height &&
+				(timings->bt.hbackporch ||
+				 timings->bt.hfrontporch ||
+				 timings->bt.hsync) &&
+				timings->bt.vfrontporch &&
+				(timings->bt.vbackporch ||
+				 timings->bt.vsync))) {
+		vpif_dbg(2, debug, "Timings for width, height, "
+				"horizontal back porch, horizontal sync, "
+				"horizontal front porch, vertical back porch, "
+				"vertical sync and vertical back porch "
+				"must be defined\n");
+		return -EINVAL;
+	}
+
+	*bt = timings->bt;
+
+	/* Configure video port timings */
+
+	std_info->eav2sav = bt->hbackporch + bt->hfrontporch +
+		bt->hsync - 8;
+	std_info->sav2eav = bt->width;
+
+	std_info->l1 = 1;
+	std_info->l3 = bt->vsync + bt->vbackporch + 1;
+
+	if (bt->interlaced) {
+		if (bt->il_vbackporch || bt->il_vfrontporch || bt->il_vsync) {
+			std_info->vsize = bt->height * 2 +
+				bt->vfrontporch + bt->vsync + bt->vbackporch +
+				bt->il_vfrontporch + bt->il_vsync +
+				bt->il_vbackporch;
+			std_info->l5 = std_info->vsize/2 -
+				(bt->vfrontporch - 1);
+			std_info->l7 = std_info->vsize/2 + 1;
+			std_info->l9 = std_info->l7 + bt->il_vsync +
+				bt->il_vbackporch + 1;
+			std_info->l11 = std_info->vsize -
+				(bt->il_vfrontporch - 1);
+		} else {
+			vpif_dbg(2, debug, "Required timing values for "
+					"interlaced BT format missing\n");
+			return -EINVAL;
+		}
+	} else {
+		std_info->vsize = bt->height + bt->vfrontporch +
+			bt->vsync + bt->vbackporch;
+		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
+	}
+	strncpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);
+	std_info->width = bt->width;
+	std_info->height = bt->height;
+	std_info->frm_fmt = bt->interlaced ? 0 : 1;
+	std_info->ycmux_mode = 0;
+	std_info->capture_format = 0;
+	std_info->vbi_supported = 0;
+	std_info->hd_sd = 1;
+	std_info->stdid = 0;
+	std_info->dv_preset = V4L2_DV_INVALID;
+
+	vid_ch->stdid = 0;
+	vid_ch->dv_preset = V4L2_DV_INVALID;
+	return 0;
+}
+
+/**
+ * vpif_g_dv_timings() - G_DV_TIMINGS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @timings: digital video timings
+ */
+static int vpif_g_dv_timings(struct file *file, void *priv,
+		struct v4l2_dv_timings *timings)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct video_obj *vid_ch = &ch->video;
+	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
+
+	timings->bt = *bt;
+
+	return 0;
+}
+
 /*
  * vpif_g_chip_ident() - Identify the chip
  * @file: file ptr
@@ -2010,6 +2131,8 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_s_dv_preset             = vpif_s_dv_preset,
 	.vidioc_g_dv_preset             = vpif_g_dv_preset,
 	.vidioc_query_dv_preset         = vpif_query_dv_preset,
+	.vidioc_s_dv_timings            = vpif_s_dv_timings,
+	.vidioc_g_dv_timings            = vpif_g_dv_timings,
 	.vidioc_g_chip_ident		= vpif_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= vpif_dbg_g_register,
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index 3452a8a..7a4196d 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -60,6 +60,7 @@ struct video_obj {
 	/* Currently selected or default standard */
 	v4l2_std_id stdid;
 	u32 dv_preset;
+	struct v4l2_bt_timings bt_timings;
 	/* This is to track the last input that is passed to application */
 	u32 input_idx;
 };
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 7992ffe..aed6692 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -363,21 +363,17 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int vpif_get_std_info(struct channel_obj *ch)
+static int vpif_update_std_info(struct channel_obj *ch)
 {
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct video_obj *vid_ch = &ch->video;
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	const struct vpif_channel_config_params *config;
 
-	int index;
-
-	if (!vid_ch->stdid && !vid_ch->dv_preset)
-		return -EINVAL;
+	int i;
 
-	for (index = 0; index < vpif_ch_params_count; index++) {
-		config = &ch_params[index];
+	for (i = 0; i < vpif_ch_params_count; i++) {
+		config = &ch_params[i];
 		if (config->hd_sd == 0) {
 			vpif_dbg(2, debug, "SD format\n");
 			if (config->stdid & vid_ch->stdid) {
@@ -393,17 +389,37 @@ static int vpif_get_std_info(struct channel_obj *ch)
 		}
 	}
 
-	if (index == vpif_ch_params_count)
+	if (i == vpif_ch_params_count) {
+		vpif_dbg(1, debug, "Format not found\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vpif_update_resolution(struct channel_obj *ch)
+{
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	struct video_obj *vid_ch = &ch->video;
+	struct vpif_params *vpifparams = &ch->vpifparams;
+	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
+
+	if (!vid_ch->stdid && !vid_ch->dv_preset && !vid_ch->bt_timings.height)
 		return -EINVAL;
 
+	if (vid_ch->stdid || vid_ch->dv_preset) {
+		if (vpif_update_std_info(ch))
+			return -EINVAL;
+	}
+
 	common->fmt.fmt.pix.width = std_info->width;
 	common->fmt.fmt.pix.height = std_info->height;
 	vpif_dbg(1, debug, "Pixel details: Width = %d,Height = %d\n",
 			common->fmt.fmt.pix.width, common->fmt.fmt.pix.height);
 
 	/* Set height and width paramateres */
-	ch->common[VPIF_VIDEO_INDEX].height = std_info->height;
-	ch->common[VPIF_VIDEO_INDEX].width = std_info->width;
+	common->height = std_info->height;
+	common->width = std_info->width;
 
 	return 0;
 }
@@ -514,10 +530,8 @@ static int vpif_check_format(struct channel_obj *ch,
 	else
 		sizeimage = config_params.channel_bufsize[ch->channel_id];
 
-	if (vpif_get_std_info(ch)) {
-		vpif_err("Error getting the standard info\n");
+	if (vpif_update_resolution(ch))
 		return -EINVAL;
-	}
 
 	hpitch = pixfmt->bytesperline;
 	vpitch = sizeimage / (hpitch * 2);
@@ -715,6 +729,7 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	int ret = 0;
 
 	/* Check the validity of the buffer type */
 	if (common->fmt.type != fmt->type)
@@ -724,14 +739,14 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 	if (mutex_lock_interruptible(&common->lock))
 		return -ERESTARTSYS;
 
-	if (vpif_get_std_info(ch)) {
-		vpif_err("Error getting the standard info\n");
-		return -EINVAL;
-	}
+	if (vpif_update_resolution(ch))
+		ret = -EINVAL;
+	else
+		*fmt = common->fmt;
 
-	*fmt = common->fmt;
 	mutex_unlock(&common->lock);
-	return 0;
+
+	return ret;
 }
 
 static int vpif_s_fmt_vid_out(struct file *file, void *priv,
@@ -992,10 +1007,13 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 		return -ERESTARTSYS;
 
 	ch->video.stdid = *std_id;
+	ch->video.dv_preset = V4L2_DV_INVALID;
+	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
+
 	/* Get the information about the standard */
-	if (vpif_get_std_info(ch)) {
-		vpif_err("Error getting the standard info\n");
-		return -EINVAL;
+	if (vpif_update_resolution(ch)) {
+		ret = -EINVAL;
+		goto s_std_exit;
 	}
 
 	if ((ch->vpifparams.std_info.width *
@@ -1362,11 +1380,11 @@ static int vpif_s_dv_preset(struct file *file, void *priv,
 
 	ch->video.dv_preset = preset->preset;
 	ch->video.stdid = V4L2_STD_UNKNOWN;
+	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
 
 	/* Get the information about the standard */
-	if (vpif_get_std_info(ch)) {
+	if (vpif_update_resolution(ch)) {
 		ret = -EINVAL;
-		vpif_dbg(1, debug, "Error getting the standard info\n");
 	} else {
 		/* Configure the default format information */
 		vpif_config_format(ch);
@@ -1395,6 +1413,126 @@ static int vpif_g_dv_preset(struct file *file, void *priv,
 
 	return 0;
 }
+/**
+ * vpif_s_dv_timings() - S_DV_TIMINGS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @timings: digital video timings
+ */
+static int vpif_s_dv_timings(struct file *file, void *priv,
+		struct v4l2_dv_timings *timings)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct vpif_params *vpifparams = &ch->vpifparams;
+	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
+	struct video_obj *vid_ch = &ch->video;
+	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
+	int ret;
+
+	if (timings->type != V4L2_DV_BT_656_1120) {
+		vpif_dbg(2, debug, "Timing type not defined\n");
+		return -EINVAL;
+	}
+
+	/* Configure subdevice timings, if any */
+	ret = v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
+			video, s_dv_timings, timings);
+	if (ret == -ENOIOCTLCMD) {
+		vpif_dbg(2, debug, "Custom DV timings not supported by "
+				"subdevice\n");
+		return -EINVAL;
+	}
+	if (ret < 0) {
+		vpif_dbg(2, debug, "Error setting custom DV timings\n");
+		return ret;
+	}
+
+	if (!(timings->bt.width && timings->bt.height &&
+				(timings->bt.hbackporch ||
+				 timings->bt.hfrontporch ||
+				 timings->bt.hsync) &&
+				timings->bt.vfrontporch &&
+				(timings->bt.vbackporch ||
+				 timings->bt.vsync))) {
+		vpif_dbg(2, debug, "Timings for width, height, "
+				"horizontal back porch, horizontal sync, "
+				"horizontal front porch, vertical back porch, "
+				"vertical sync and vertical back porch "
+				"must be defined\n");
+		return -EINVAL;
+	}
+
+	*bt = timings->bt;
+
+	/* Configure video port timings */
+
+	std_info->eav2sav = bt->hbackporch + bt->hfrontporch +
+		bt->hsync - 8;
+	std_info->sav2eav = bt->width;
+
+	std_info->l1 = 1;
+	std_info->l3 = bt->vsync + bt->vbackporch + 1;
+
+	if (bt->interlaced) {
+		if (bt->il_vbackporch || bt->il_vfrontporch || bt->il_vsync) {
+			std_info->vsize = bt->height * 2 +
+				bt->vfrontporch + bt->vsync + bt->vbackporch +
+				bt->il_vfrontporch + bt->il_vsync +
+				bt->il_vbackporch;
+			std_info->l5 = std_info->vsize/2 -
+				(bt->vfrontporch - 1);
+			std_info->l7 = std_info->vsize/2 + 1;
+			std_info->l9 = std_info->l7 + bt->il_vsync +
+				bt->il_vbackporch + 1;
+			std_info->l11 = std_info->vsize -
+				(bt->il_vfrontporch - 1);
+		} else {
+			vpif_dbg(2, debug, "Required timing values for "
+					"interlaced BT format missing\n");
+			return -EINVAL;
+		}
+	} else {
+		std_info->vsize = bt->height + bt->vfrontporch +
+			bt->vsync + bt->vbackporch;
+		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
+	}
+	strncpy(std_info->name, "Custom timings BT656/1120",
+			VPIF_MAX_NAME);
+	std_info->width = bt->width;
+	std_info->height = bt->height;
+	std_info->frm_fmt = bt->interlaced ? 0 : 1;
+	std_info->ycmux_mode = 0;
+	std_info->capture_format = 0;
+	std_info->vbi_supported = 0;
+	std_info->hd_sd = 1;
+	std_info->stdid = 0;
+	std_info->dv_preset = V4L2_DV_INVALID;
+
+	vid_ch->stdid = 0;
+	vid_ch->dv_preset = V4L2_DV_INVALID;
+
+	return 0;
+}
+
+/**
+ * vpif_g_dv_timings() - G_DV_TIMINGS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @timings: digital video timings
+ */
+static int vpif_g_dv_timings(struct file *file, void *priv,
+		struct v4l2_dv_timings *timings)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct video_obj *vid_ch = &ch->video;
+	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
+
+	timings->bt = *bt;
+
+	return 0;
+}
 
 /*
  * vpif_g_chip_ident() - Identify the chip
@@ -1498,6 +1636,8 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_enum_dv_presets         = vpif_enum_dv_presets,
 	.vidioc_s_dv_preset             = vpif_s_dv_preset,
 	.vidioc_g_dv_preset             = vpif_g_dv_preset,
+	.vidioc_s_dv_timings            = vpif_s_dv_timings,
+	.vidioc_g_dv_timings            = vpif_g_dv_timings,
 	.vidioc_g_chip_ident		= vpif_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= vpif_dbg_g_register,
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index 3d56b3e..b53aaa8 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -68,6 +68,7 @@ struct video_obj {
 	v4l2_std_id stdid;		/* Currently selected or default
 					 * standard */
 	u32 dv_preset;
+	struct v4l2_bt_timings bt_timings;
 	u32 output_id;			/* Current output id */
 };
 
-- 
1.7.1

