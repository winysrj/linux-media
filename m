Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:14163 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab0J1Gqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 02:46:37 -0400
From: mats.randgaard@tandberg.com
To: hvaibhav@ti.com, mkaricheri@gmail.com
Cc: hans.verkuil@tandberg.com, linux-media@vger.kernel.org,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [RFCv2/PATCH 3/5] vpif_cap/disp: Add support for DV presets
Date: Thu, 28 Oct 2010 08:46:21 +0200
Message-Id: <1288248383-12557-4-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1288248383-12557-1-git-send-email-mats.randgaard@tandberg.com>
References: <1288248383-12557-1-git-send-email-mats.randgaard@tandberg.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Mats Randgaard <mats.randgaard@tandberg.com>

- Added functions to set/get/query/enum DV presets for vpif_caputre and vpif_display.
- The format specification table is extended with all the DV formats supportet by TVP7002.
  support DV formats.

Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
Signed-off-by: Hans Verkuil <hans.verkuil@tandberg.com>
---
 drivers/media/video/davinci/vpif.c         |  127 ++++++++++++++++++++++++++++
 drivers/media/video/davinci/vpif.h         |    1 +
 drivers/media/video/davinci/vpif_capture.c |  124 ++++++++++++++++++++++++++-
 drivers/media/video/davinci/vpif_capture.h |    1 +
 drivers/media/video/davinci/vpif_display.c |  105 ++++++++++++++++++++++--
 drivers/media/video/davinci/vpif_display.h |    1 +
 6 files changed, 350 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index 54cc0da..9f3bfc1 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -46,6 +46,133 @@ void __iomem *vpif_base;
  * The table must include all presets from supported subdevices.
  */
 const struct vpif_channel_config_params ch_params[] = {
+	/* HDTV formats */
+	{
+		.name = "480p59_94",
+		.width = 720,
+		.height = 480,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 138-8,
+		.sav2eav = 720,
+		.l1 = 1,
+		.l3 = 43,
+		.l5 = 523,
+		.vsize = 525,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_480P59_94,
+	},
+	{
+		.name = "576p50",
+		.width = 720,
+		.height = 576,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 144-8,
+		.sav2eav = 720,
+		.l1 = 1,
+		.l3 = 45,
+		.l5 = 621,
+		.vsize = 625,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_576P50,
+	},
+	{
+		.name = "720p50",
+		.width = 1280,
+		.height = 720,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 700-8,
+		.sav2eav = 1280,
+		.l1 = 1,
+		.l3 = 26,
+		.l5 = 746,
+		.vsize = 750,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_720P50,
+	},
+	{
+		.name = "720p60",
+		.width = 1280,
+		.height = 720,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 370 - 8,
+		.sav2eav = 1280,
+		.l1 = 1,
+		.l3 = 26,
+		.l5 = 746,
+		.vsize = 750,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_720P60,
+	},
+	{
+		.name = "1080I50",
+		.width = 1920,
+		.height = 1080,
+		.frm_fmt = 0,
+		.ycmux_mode = 0,
+		.eav2sav = 720 - 8,
+		.sav2eav = 1920,
+		.l1 = 1,
+		.l3 = 21,
+		.l5 = 561,
+		.l7 = 563,
+		.l9 = 584,
+		.l11 = 1124,
+		.vsize = 1125,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_1080I50,
+	},
+	{
+		.name = "1080I60",
+		.width = 1920,
+		.height = 1080,
+		.frm_fmt = 0,
+		.ycmux_mode = 0,
+		.eav2sav = 280 - 8,
+		.sav2eav = 1920,
+		.l1 = 1,
+		.l3 = 21,
+		.l5 = 561,
+		.l7 = 563,
+		.l9 = 584,
+		.l11 = 1124,
+		.vsize = 1125,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_1080I60,
+	},
+	{
+		.name = "1080p60",
+		.width = 1920,
+		.height = 1080,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 280 - 8,
+		.sav2eav = 1920,
+		.l1 = 1,
+		.l3 = 42,
+		.l5 = 1122,
+		.vsize = 1125,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_1080P60,
+	},
+
 	/* SDTV formats */
 	{
 		.name = "NTSC_M",
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 940c30f..b121683 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -591,6 +591,7 @@ struct vpif_channel_config_params {
 					 * supports capturing vbi or not */
 	u8 hd_sd;
 	v4l2_std_id stdid;
+	u32 dv_preset;			/* HDTV format */
 };
 
 extern const unsigned int vpif_ch_params_count;
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 4768f79..f713d08 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -432,9 +432,18 @@ static int vpif_update_std_info(struct channel_obj *ch)
 
 	for (index = 0; index < vpif_ch_params_count; index++) {
 		config = &ch_params[index];
-		if (config->stdid & vid_ch->stdid) {
-			memcpy(std_info, config, sizeof(*config));
-			break;
+		if (config->hd_sd == 0) {
+			vpif_dbg(2, debug, "SD format\n");
+			if (config->stdid & vid_ch->stdid) {
+				memcpy(std_info, config, sizeof(*config));
+				break;
+			}
+		} else {
+			vpif_dbg(2, debug, "HD format\n");
+			if (config->dv_preset == vid_ch->dv_preset) {
+				memcpy(std_info, config, sizeof(*config));
+				break;
+			}
 		}
 	}
 
@@ -1442,6 +1451,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 		return -ERESTARTSYS;
 
 	ch->video.stdid = *std_id;
+	ch->video.dv_preset = V4L2_DV_INVALID;
 
 	/* Get the information about the standard */
 	if (vpif_update_std_info(ch)) {
@@ -1794,6 +1804,110 @@ static int vpif_cropcap(struct file *file, void *priv,
 	return 0;
 }
 
+/**
+ * vpif_enum_dv_presets() - ENUM_DV_PRESETS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @preset: input preset
+ */
+static int vpif_enum_dv_presets(struct file *file, void *priv,
+		struct v4l2_dv_enum_preset *preset)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+
+	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
+			video, enum_dv_presets, preset);
+}
+
+/**
+ * vpif_query_dv_presets() - QUERY_DV_PRESET handler
+ * @file: file ptr
+ * @priv: file handle
+ * @preset: input preset
+ */
+static int vpif_query_dv_preset(struct file *file, void *priv,
+		struct v4l2_dv_preset *preset)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+
+	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
+		       video, query_dv_preset, preset);
+}
+/**
+ * vpif_s_dv_presets() - S_DV_PRESETS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @preset: input preset
+ */
+static int vpif_s_dv_preset(struct file *file, void *priv,
+		struct v4l2_dv_preset *preset)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	int ret = 0;
+
+	if (common->started) {
+		vpif_dbg(1, debug, "streaming in progress\n");
+		return -EBUSY;
+	}
+
+	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
+	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
+		if (!fh->initialized) {
+			vpif_dbg(1, debug, "Channel Busy\n");
+			return -EBUSY;
+		}
+	}
+
+	ret = v4l2_prio_check(&ch->prio, fh->prio);
+	if (ret)
+		return ret;
+
+	fh->initialized = 1;
+
+	/* Call encoder subdevice function to set the standard */
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
+	ch->video.dv_preset = preset->preset;
+	ch->video.stdid = V4L2_STD_UNKNOWN;
+
+	/* Get the information about the standard */
+	if (vpif_update_std_info(ch)) {
+		vpif_dbg(1, debug, "Error getting the standard info\n");
+		ret = -EINVAL;
+	} else {
+		/* Configure the default format information */
+		vpif_config_format(ch);
+
+		ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
+				video, s_dv_preset, preset);
+	}
+
+	mutex_unlock(&common->lock);
+
+	return ret;
+}
+/**
+ * vpif_g_dv_presets() - G_DV_PRESETS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @preset: input preset
+ */
+static int vpif_g_dv_preset(struct file *file, void *priv,
+		struct v4l2_dv_preset *preset)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+
+	preset->preset = ch->video.dv_preset;
+
+	return 0;
+}
+
 /*
  * vpif_g_chip_ident() - Identify the chip
  * @file: file ptr
@@ -1892,6 +2006,10 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_streamon        	= vpif_streamon,
 	.vidioc_streamoff       	= vpif_streamoff,
 	.vidioc_cropcap         	= vpif_cropcap,
+	.vidioc_enum_dv_presets         = vpif_enum_dv_presets,
+	.vidioc_s_dv_preset             = vpif_s_dv_preset,
+	.vidioc_g_dv_preset             = vpif_g_dv_preset,
+	.vidioc_query_dv_preset         = vpif_query_dv_preset,
 	.vidioc_g_chip_ident		= vpif_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= vpif_dbg_g_register,
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index 4e12ec8..3452a8a 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -59,6 +59,7 @@ struct video_obj {
 	enum v4l2_field buf_field;
 	/* Currently selected or default standard */
 	v4l2_std_id stdid;
+	u32 dv_preset;
 	/* This is to track the last input that is passed to application */
 	u32 input_idx;
 };
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index be3fa2e..7992ffe 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -373,15 +373,23 @@ static int vpif_get_std_info(struct channel_obj *ch)
 
 	int index;
 
-	std_info->stdid = vid_ch->stdid;
-	if (!std_info->stdid)
-		return -1;
+	if (!vid_ch->stdid && !vid_ch->dv_preset)
+		return -EINVAL;
 
 	for (index = 0; index < vpif_ch_params_count; index++) {
 		config = &ch_params[index];
-		if (config->stdid & std_info->stdid) {
-			memcpy(std_info, config, sizeof(*config));
-			break;
+		if (config->hd_sd == 0) {
+			vpif_dbg(2, debug, "SD format\n");
+			if (config->stdid & vid_ch->stdid) {
+				memcpy(std_info, config, sizeof(*config));
+				break;
+			}
+		} else {
+			vpif_dbg(2, debug, "HD format\n");
+			if (config->dv_preset == vid_ch->dv_preset) {
+				memcpy(std_info, config, sizeof(*config));
+				break;
+			}
 		}
 	}
 
@@ -1305,6 +1313,88 @@ static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
 	return v4l2_prio_change(&ch->prio, &fh->prio, p);
 }
 
+/**
+ * vpif_enum_dv_presets() - ENUM_DV_PRESETS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @preset: input preset
+ */
+static int vpif_enum_dv_presets(struct file *file, void *priv,
+		struct v4l2_dv_enum_preset *preset)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct video_obj *vid_ch = &ch->video;
+
+	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
+			video, enum_dv_presets, preset);
+}
+
+/**
+ * vpif_s_dv_presets() - S_DV_PRESETS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @preset: input preset
+ */
+static int vpif_s_dv_preset(struct file *file, void *priv,
+		struct v4l2_dv_preset *preset)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	struct video_obj *vid_ch = &ch->video;
+	int ret = 0;
+
+	if (common->started) {
+		vpif_dbg(1, debug, "streaming in progress\n");
+		return -EBUSY;
+	}
+
+	ret = v4l2_prio_check(&ch->prio, fh->prio);
+	if (ret != 0)
+		return ret;
+
+	fh->initialized = 1;
+
+	/* Call encoder subdevice function to set the standard */
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
+	ch->video.dv_preset = preset->preset;
+	ch->video.stdid = V4L2_STD_UNKNOWN;
+
+	/* Get the information about the standard */
+	if (vpif_get_std_info(ch)) {
+		ret = -EINVAL;
+		vpif_dbg(1, debug, "Error getting the standard info\n");
+	} else {
+		/* Configure the default format information */
+		vpif_config_format(ch);
+
+		ret = v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
+				video, s_dv_preset, preset);
+	}
+
+	mutex_unlock(&common->lock);
+
+	return ret;
+}
+/**
+ * vpif_g_dv_presets() - G_DV_PRESETS handler
+ * @file: file ptr
+ * @priv: file handle
+ * @preset: input preset
+ */
+static int vpif_g_dv_preset(struct file *file, void *priv,
+		struct v4l2_dv_preset *preset)
+{
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+
+	preset->preset = ch->video.dv_preset;
+
+	return 0;
+}
 
 /*
  * vpif_g_chip_ident() - Identify the chip
@@ -1405,6 +1495,9 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_s_output		= vpif_s_output,
 	.vidioc_g_output		= vpif_g_output,
 	.vidioc_cropcap         	= vpif_cropcap,
+	.vidioc_enum_dv_presets         = vpif_enum_dv_presets,
+	.vidioc_s_dv_preset             = vpif_s_dv_preset,
+	.vidioc_g_dv_preset             = vpif_g_dv_preset,
 	.vidioc_g_chip_ident		= vpif_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= vpif_dbg_g_register,
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index a2a7cd1..3d56b3e 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -67,6 +67,7 @@ struct video_obj {
 					 * most recent displayed frame only */
 	v4l2_std_id stdid;		/* Currently selected or default
 					 * standard */
+	u32 dv_preset;
 	u32 output_id;			/* Current output id */
 };
 
-- 
1.7.1

