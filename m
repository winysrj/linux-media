Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34964 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab2HHMJX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Aug 2012 08:09:23 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hansverk@cisco.com>,
	<linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] vpif: replace preset with the timings API.
Date: Wed, 8 Aug 2012 17:39:07 +0530
Message-ID: <1344427747-21799-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpif.c         |   16 ++--
 drivers/media/video/davinci/vpif.h         |    4 +-
 drivers/media/video/davinci/vpif_capture.c |  114 +++++-----------------------
 drivers/media/video/davinci/vpif_capture.h |    3 +-
 drivers/media/video/davinci/vpif_display.c |  102 +++----------------------
 drivers/media/video/davinci/vpif_display.h |    3 +-
 6 files changed, 43 insertions(+), 199 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index b3637af..b95bff7 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -25,6 +25,8 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/v4l2-dv-timings.h>
+
 #include <mach/hardware.h>
 
 #include "vpif.h"
@@ -65,7 +67,7 @@ const struct vpif_channel_config_params ch_params[] = {
 		.capture_format = 0,
 		.vbi_supported = 0,
 		.hd_sd = 1,
-		.dv_preset = V4L2_DV_480P59_94,
+		.dv_timings = V4L2_DV_BT_CEA_720X480P59_94,
 	},
 	{
 		.name = "576p50",
@@ -82,7 +84,7 @@ const struct vpif_channel_config_params ch_params[] = {
 		.capture_format = 0,
 		.vbi_supported = 0,
 		.hd_sd = 1,
-		.dv_preset = V4L2_DV_576P50,
+		.dv_timings = V4L2_DV_BT_CEA_720X576P50,
 	},
 	{
 		.name = "720p50",
@@ -99,7 +101,7 @@ const struct vpif_channel_config_params ch_params[] = {
 		.capture_format = 0,
 		.vbi_supported = 0,
 		.hd_sd = 1,
-		.dv_preset = V4L2_DV_720P50,
+		.dv_timings = V4L2_DV_BT_CEA_1280X720P50,
 	},
 	{
 		.name = "720p60",
@@ -116,7 +118,7 @@ const struct vpif_channel_config_params ch_params[] = {
 		.capture_format = 0,
 		.vbi_supported = 0,
 		.hd_sd = 1,
-		.dv_preset = V4L2_DV_720P60,
+		.dv_timings = V4L2_DV_BT_CEA_1280X720P60,
 	},
 	{
 		.name = "1080I50",
@@ -136,7 +138,7 @@ const struct vpif_channel_config_params ch_params[] = {
 		.capture_format = 0,
 		.vbi_supported = 0,
 		.hd_sd = 1,
-		.dv_preset = V4L2_DV_1080I50,
+		.dv_timings = V4L2_DV_BT_CEA_1920X1080I50,
 	},
 	{
 		.name = "1080I60",
@@ -156,7 +158,7 @@ const struct vpif_channel_config_params ch_params[] = {
 		.capture_format = 0,
 		.vbi_supported = 0,
 		.hd_sd = 1,
-		.dv_preset = V4L2_DV_1080I60,
+		.dv_timings = V4L2_DV_BT_CEA_1920X1080I60,
 	},
 	{
 		.name = "1080p60",
@@ -173,7 +175,7 @@ const struct vpif_channel_config_params ch_params[] = {
 		.capture_format = 0,
 		.vbi_supported = 0,
 		.hd_sd = 1,
-		.dv_preset = V4L2_DV_1080P60,
+		.dv_timings = V4L2_DV_BT_CEA_1920X1080P60,
 	},
 
 	/* SDTV formats */
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index c2ce4d9..a1ab6a0 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -533,7 +533,7 @@ static inline void channel2_clipping_enable(int enable)
 	}
 }
 
-/* function to enable clipping (for both active and blanking regions) on ch 2 */
+/* function to enable clipping (for both active and blanking regions) on ch 3 */
 static inline void channel3_clipping_enable(int enable)
 {
 	if (enable) {
@@ -634,7 +634,7 @@ struct vpif_channel_config_params {
 					 * supports capturing vbi or not */
 	u8 hd_sd;			/* HDTV (1) or SDTV (0) format */
 	v4l2_std_id stdid;		/* SDTV format */
-	u32 dv_preset;			/* HDTV format */
+	struct v4l2_dv_timings dv_timings;	/* HDTV format */
 };
 
 extern const unsigned int vpif_ch_params_count;
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 266025e..e684c48 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -551,7 +551,8 @@ static int vpif_update_std_info(struct channel_obj *ch)
 			}
 		} else {
 			vpif_dbg(2, debug, "HD format\n");
-			if (config->dv_preset == vid_ch->dv_preset) {
+			if (!memcmp(&config->dv_timings, &vid_ch->dv_timings,
+						sizeof(vid_ch->dv_timings))) {
 				memcpy(std_info, config, sizeof(*config));
 				break;
 			}
@@ -1368,8 +1369,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 
 	/* Call encoder subdevice function to set the standard */
 	ch->video.stdid = *std_id;
-	ch->video.dv_preset = V4L2_DV_INVALID;
-	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
+	memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
 
 	/* Get the information about the standard */
 	if (vpif_update_std_info(ch)) {
@@ -1703,108 +1703,35 @@ static int vpif_cropcap(struct file *file, void *priv,
 }
 
 /**
- * vpif_enum_dv_presets() - ENUM_DV_PRESETS handler
+ * vpif_enum_dv_timings() - ENUM_DV_TIMINGS handler
  * @file: file ptr
  * @priv: file handle
- * @preset: input preset
+ * @timings: input timings
  */
-static int vpif_enum_dv_presets(struct file *file, void *priv,
-		struct v4l2_dv_enum_preset *preset)
+static int vpif_enum_dv_timings(struct file *file, void *priv,
+		struct v4l2_enum_dv_timings *timings)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
 	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
-			video, enum_dv_presets, preset);
+			video, enum_dv_timings, timings);
 }
 
 /**
- * vpif_query_dv_presets() - QUERY_DV_PRESET handler
+ * vpif_query_dv_timings() - QUERY_DV_TIMINGS handler
  * @file: file ptr
  * @priv: file handle
- * @preset: input preset
+ * @timings: input timings
  */
-static int vpif_query_dv_preset(struct file *file, void *priv,
-		struct v4l2_dv_preset *preset)
+static int vpif_query_dv_timings(struct file *file, void *priv,
+		struct v4l2_dv_timings *timings)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
 	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
-		       video, query_dv_preset, preset);
-}
-/**
- * vpif_s_dv_presets() - S_DV_PRESETS handler
- * @file: file ptr
- * @priv: file handle
- * @preset: input preset
- */
-static int vpif_s_dv_preset(struct file *file, void *priv,
-		struct v4l2_dv_preset *preset)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
-
-	if (common->started) {
-		vpif_dbg(1, debug, "streaming in progress\n");
-		return -EBUSY;
-	}
-
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
-	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (ret)
-		return ret;
-
-	fh->initialized = 1;
-
-	/* Call encoder subdevice function to set the standard */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
-	ch->video.dv_preset = preset->preset;
-	ch->video.stdid = V4L2_STD_UNKNOWN;
-	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
-
-	/* Get the information about the standard */
-	if (vpif_update_std_info(ch)) {
-		vpif_dbg(1, debug, "Error getting the standard info\n");
-		ret = -EINVAL;
-	} else {
-		/* Configure the default format information */
-		vpif_config_format(ch);
-
-		ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
-				video, s_dv_preset, preset);
-	}
-
-	mutex_unlock(&common->lock);
-
-	return ret;
-}
-/**
- * vpif_g_dv_presets() - G_DV_PRESETS handler
- * @file: file ptr
- * @priv: file handle
- * @preset: input preset
- */
-static int vpif_g_dv_preset(struct file *file, void *priv,
-		struct v4l2_dv_preset *preset)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	preset->preset = ch->video.dv_preset;
-
-	return 0;
+		       video, query_dv_timings, timings);
 }
 
 /**
@@ -1821,7 +1748,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
-	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
+	struct v4l2_bt_timings *bt = &vid_ch->dv_timings.bt;
 	int ret;
 
 	if (timings->type != V4L2_DV_BT_656_1120) {
@@ -1857,7 +1784,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	*bt = timings->bt;
+	vid_ch->dv_timings = *timings;
 
 	/* Configure video port timings */
 
@@ -1900,10 +1827,8 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	std_info->vbi_supported = 0;
 	std_info->hd_sd = 1;
 	std_info->stdid = 0;
-	std_info->dv_preset = V4L2_DV_INVALID;
 
 	vid_ch->stdid = 0;
-	vid_ch->dv_preset = V4L2_DV_INVALID;
 	return 0;
 }
 
@@ -1919,9 +1844,8 @@ static int vpif_g_dv_timings(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct video_obj *vid_ch = &ch->video;
-	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
 
-	timings->bt = *bt;
+	*timings = vid_ch->dv_timings;
 
 	return 0;
 }
@@ -2024,10 +1948,8 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_streamon        	= vpif_streamon,
 	.vidioc_streamoff       	= vpif_streamoff,
 	.vidioc_cropcap         	= vpif_cropcap,
-	.vidioc_enum_dv_presets         = vpif_enum_dv_presets,
-	.vidioc_s_dv_preset             = vpif_s_dv_preset,
-	.vidioc_g_dv_preset             = vpif_g_dv_preset,
-	.vidioc_query_dv_preset         = vpif_query_dv_preset,
+	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
+	.vidioc_query_dv_timings        = vpif_query_dv_timings,
 	.vidioc_s_dv_timings            = vpif_s_dv_timings,
 	.vidioc_g_dv_timings            = vpif_g_dv_timings,
 	.vidioc_g_chip_ident		= vpif_g_chip_ident,
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index 3511510..aa6d3da 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -54,8 +54,7 @@ struct video_obj {
 	enum v4l2_field buf_field;
 	/* Currently selected or default standard */
 	v4l2_std_id stdid;
-	u32 dv_preset;
-	struct v4l2_bt_timings bt_timings;
+	struct v4l2_dv_timings dv_timings;
 	/* This is to track the last input that is passed to application */
 	u32 input_idx;
 };
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index e129c98..199eb96 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -499,12 +499,6 @@ static int vpif_update_std_info(struct channel_obj *ch)
 				memcpy(std_info, config, sizeof(*config));
 				break;
 			}
-		} else {
-			vpif_dbg(2, debug, "HD format\n");
-			if (config->dv_preset == vid_ch->dv_preset) {
-				memcpy(std_info, config, sizeof(*config));
-				break;
-			}
 		}
 	}
 
@@ -523,10 +517,10 @@ static int vpif_update_resolution(struct channel_obj *ch)
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 
-	if (!vid_ch->stdid && !vid_ch->dv_preset && !vid_ch->bt_timings.height)
+	if (!vid_ch->stdid && !vid_ch->dv_timings.bt.height)
 		return -EINVAL;
 
-	if (vid_ch->stdid || vid_ch->dv_preset) {
+	if (vid_ch->stdid) {
 		if (vpif_update_std_info(ch))
 			return -EINVAL;
 	}
@@ -1039,8 +1033,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 
 	/* Call encoder subdevice function to set the standard */
 	ch->video.stdid = *std_id;
-	ch->video.dv_preset = V4L2_DV_INVALID;
-	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
+	memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
 
 	/* Get the information about the standard */
 	if (vpif_update_resolution(ch))
@@ -1271,87 +1264,22 @@ static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
 }
 
 /**
- * vpif_enum_dv_presets() - ENUM_DV_PRESETS handler
+ * vpif_enum_dv_timings() - ENUM_DV_TIMINGS handler
  * @file: file ptr
  * @priv: file handle
- * @preset: input preset
+ * @timings: input timings
  */
-static int vpif_enum_dv_presets(struct file *file, void *priv,
-		struct v4l2_dv_enum_preset *preset)
+static int vpif_enum_dv_timings(struct file *file, void *priv,
+		struct v4l2_enum_dv_timings *timings)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct video_obj *vid_ch = &ch->video;
 
 	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
-			video, enum_dv_presets, preset);
-}
-
-/**
- * vpif_s_dv_presets() - S_DV_PRESETS handler
- * @file: file ptr
- * @priv: file handle
- * @preset: input preset
- */
-static int vpif_s_dv_preset(struct file *file, void *priv,
-		struct v4l2_dv_preset *preset)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct video_obj *vid_ch = &ch->video;
-	int ret = 0;
-
-	if (common->started) {
-		vpif_dbg(1, debug, "streaming in progress\n");
-		return -EBUSY;
-	}
-
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (ret != 0)
-		return ret;
-
-	fh->initialized = 1;
-
-	/* Call encoder subdevice function to set the standard */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
-	ch->video.dv_preset = preset->preset;
-	ch->video.stdid = V4L2_STD_UNKNOWN;
-	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
-
-	/* Get the information about the standard */
-	if (vpif_update_resolution(ch)) {
-		ret = -EINVAL;
-	} else {
-		/* Configure the default format information */
-		vpif_config_format(ch);
-
-		ret = v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
-				video, s_dv_preset, preset);
-	}
-
-	mutex_unlock(&common->lock);
-
-	return ret;
+			video, enum_dv_timings, timings);
 }
-/**
- * vpif_g_dv_presets() - G_DV_PRESETS handler
- * @file: file ptr
- * @priv: file handle
- * @preset: input preset
- */
-static int vpif_g_dv_preset(struct file *file, void *priv,
-		struct v4l2_dv_preset *preset)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	preset->preset = ch->video.dv_preset;
 
-	return 0;
-}
 /**
  * vpif_s_dv_timings() - S_DV_TIMINGS handler
  * @file: file ptr
@@ -1366,7 +1294,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
-	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
+	struct v4l2_bt_timings *bt = &vid_ch->dv_timings.bt;
 	int ret;
 
 	if (timings->type != V4L2_DV_BT_656_1120) {
@@ -1402,7 +1330,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	*bt = timings->bt;
+	vid_ch->dv_timings = *timings;
 
 	/* Configure video port timings */
 
@@ -1446,10 +1374,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	std_info->vbi_supported = 0;
 	std_info->hd_sd = 1;
 	std_info->stdid = 0;
-	std_info->dv_preset = V4L2_DV_INVALID;
-
 	vid_ch->stdid = 0;
-	vid_ch->dv_preset = V4L2_DV_INVALID;
 
 	return 0;
 }
@@ -1466,9 +1391,8 @@ static int vpif_g_dv_timings(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct video_obj *vid_ch = &ch->video;
-	struct v4l2_bt_timings *bt = &vid_ch->bt_timings;
 
-	timings->bt = *bt;
+	*timings = vid_ch->dv_timings;
 
 	return 0;
 }
@@ -1572,9 +1496,7 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_s_output		= vpif_s_output,
 	.vidioc_g_output		= vpif_g_output,
 	.vidioc_cropcap         	= vpif_cropcap,
-	.vidioc_enum_dv_presets         = vpif_enum_dv_presets,
-	.vidioc_s_dv_preset             = vpif_s_dv_preset,
-	.vidioc_g_dv_preset             = vpif_g_dv_preset,
+	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
 	.vidioc_s_dv_timings            = vpif_s_dv_timings,
 	.vidioc_g_dv_timings            = vpif_g_dv_timings,
 	.vidioc_g_chip_ident		= vpif_g_chip_ident,
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index 8967ffb..1263de6 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -62,8 +62,7 @@ struct video_obj {
 					 * most recent displayed frame only */
 	v4l2_std_id stdid;		/* Currently selected or default
 					 * standard */
-	u32 dv_preset;
-	struct v4l2_bt_timings bt_timings;
+	struct v4l2_dv_timings dv_timings;
 	u32 output_id;			/* Current output id */
 };
 
-- 
1.7.0.4

