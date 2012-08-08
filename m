Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36349 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab2HHMbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Aug 2012 08:31:55 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hansverk@cisco.com>,
	<linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 1/2] dm644x: replace the obsolete preset API by the timings API.
Date: Wed, 8 Aug 2012 18:00:19 +0530
Message-ID: <1344429020-27616-2-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
References: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/board-dm644x-evm.c   |   15 ++--
 arch/arm/mach-davinci/dm644x.c             |   17 +---
 drivers/media/video/davinci/vpbe.c         |  110 ++++++++++++----------------
 drivers/media/video/davinci/vpbe_display.c |   60 +++++++--------
 drivers/media/video/davinci/vpbe_venc.c    |   25 +++---
 include/media/davinci/vpbe.h               |   14 ++--
 include/media/davinci/vpbe_types.h         |    8 +--
 include/media/davinci/vpbe_venc.h          |    2 +-
 8 files changed, 111 insertions(+), 140 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index d34ed55..3baf56d 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -23,6 +23,7 @@
 #include <linux/phy.h>
 #include <linux/clk.h>
 #include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
 #include <linux/export.h>
 
 #include <media/tvp514x.h>
@@ -620,7 +621,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
 	{
 		.name		= "ntsc",
 		.timings_type	= VPBE_ENC_STD,
-		.timings	= {V4L2_STD_525_60},
+		.std_id		= V4L2_STD_525_60,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 480,
@@ -632,7 +633,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
 	{
 		.name		= "pal",
 		.timings_type	= VPBE_ENC_STD,
-		.timings	= {V4L2_STD_625_50},
+		.std_id		= V4L2_STD_625_50,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 576,
@@ -647,8 +648,8 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
 static struct vpbe_enc_mode_info dm644xevm_enc_preset_timing[] = {
 	{
 		.name		= "480p59_94",
-		.timings_type	= VPBE_ENC_DV_PRESET,
-		.timings	= {V4L2_DV_480P59_94},
+		.timings_type	= VPBE_ENC_CUSTOM_TIMINGS,
+		.dv_timings	= V4L2_DV_BT_CEA_720X480P59_94,
 		.interlaced	= 0,
 		.xres		= 720,
 		.yres		= 480,
@@ -659,8 +660,8 @@ static struct vpbe_enc_mode_info dm644xevm_enc_preset_timing[] = {
 	},
 	{
 		.name		= "576p50",
-		.timings_type	= VPBE_ENC_DV_PRESET,
-		.timings	= {V4L2_DV_576P50},
+		.timings_type	= VPBE_ENC_CUSTOM_TIMINGS,
+		.dv_timings	= V4L2_DV_BT_CEA_720X576P50,
 		.interlaced	= 0,
 		.xres		= 720,
 		.yres		= 576,
@@ -698,7 +699,7 @@ static struct vpbe_output dm644xevm_vpbe_outputs[] = {
 			.index		= 1,
 			.name		= "Component",
 			.type		= V4L2_OUTPUT_TYPE_ANALOG,
-			.capabilities	= V4L2_OUT_CAP_PRESETS,
+			.capabilities	= V4L2_OUT_CAP_CUSTOM_TIMINGS,
 		},
 		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
 		.default_mode	= "480p59_94",
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index c8b8666..79d2880 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -701,7 +701,7 @@ static struct resource dm644x_venc_resources[] = {
 #define DM644X_VPSS_DACCLKEN                  BIT(4)
 
 static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type,
-				   unsigned int mode)
+				   unsigned int pclock)
 {
 	int ret = 0;
 	u32 v = DM644X_VPSS_VENCLKEN;
@@ -711,27 +711,18 @@ static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type,
 		v |= DM644X_VPSS_DACCLKEN;
 		writel(v, DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL));
 		break;
-	case VPBE_ENC_DV_PRESET:
-		switch (mode) {
-		case V4L2_DV_480P59_94:
-		case V4L2_DV_576P50:
+	case VPBE_ENC_CUSTOM_TIMINGS:
+		if (pclock <= 27000000) {
 			v |= DM644X_VPSS_MUXSEL_PLL2_MODE |
 			     DM644X_VPSS_DACCLKEN;
 			writel(v, DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL));
-			break;
-		case V4L2_DV_720P60:
-		case V4L2_DV_1080I60:
-		case V4L2_DV_1080P30:
+		} else {
 			/*
 			 * For HD, use external clock source since
 			 * HD requires higher clock rate
 			 */
 			v |= DM644X_VPSS_MUXSEL_VPBECLK_MODE;
 			writel(v, DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL));
-			break;
-		default:
-			ret = -EINVAL;
-			break;
 		}
 		break;
 	default:
diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/video/davinci/vpbe.c
index c4a82a1..bc27b2a 100644
--- a/drivers/media/video/davinci/vpbe.c
+++ b/drivers/media/video/davinci/vpbe.c
@@ -174,26 +174,6 @@ static int vpbe_get_current_mode_info(struct vpbe_device *vpbe_dev,
 	return 0;
 }
 
-static int vpbe_get_dv_preset_info(struct vpbe_device *vpbe_dev,
-				   unsigned int dv_preset)
-{
-	struct vpbe_config *cfg = vpbe_dev->cfg;
-	struct vpbe_enc_mode_info var;
-	int curr_output = vpbe_dev->current_out_index;
-	int i;
-
-	for (i = 0; i < vpbe_dev->cfg->outputs[curr_output].num_modes; i++) {
-		var = cfg->outputs[curr_output].modes[i];
-		if ((var.timings_type & VPBE_ENC_DV_PRESET) &&
-		  (var.timings.dv_preset == dv_preset)) {
-			vpbe_dev->current_timings = var;
-			return 0;
-		}
-	}
-
-	return -EINVAL;
-}
-
 /* Get std by std id */
 static int vpbe_get_std_info(struct vpbe_device *vpbe_dev,
 			     v4l2_std_id std_id)
@@ -206,7 +186,7 @@ static int vpbe_get_std_info(struct vpbe_device *vpbe_dev,
 	for (i = 0; i < vpbe_dev->cfg->outputs[curr_output].num_modes; i++) {
 		var = cfg->outputs[curr_output].modes[i];
 		if ((var.timings_type & VPBE_ENC_STD) &&
-		  (var.timings.std_id & std_id)) {
+		  (var.std_id & std_id)) {
 			vpbe_dev->current_timings = var;
 			return 0;
 		}
@@ -344,38 +324,42 @@ static unsigned int vpbe_get_output(struct vpbe_device *vpbe_dev)
 }
 
 /**
- * vpbe_s_dv_preset - Set the given preset timings in the encoder
+ * vpbe_s_dv_timings - Set the given preset timings in the encoder
  *
- * Sets the preset if supported by the current encoder. Return the status.
+ * Sets the timings if supported by the current encoder. Return the status.
  * 0 - success & -EINVAL on error
  */
-static int vpbe_s_dv_preset(struct vpbe_device *vpbe_dev,
-		     struct v4l2_dv_preset *dv_preset)
+static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
+		     struct v4l2_dv_timings *dv_timings)
 {
 	struct vpbe_config *cfg = vpbe_dev->cfg;
 	int out_index = vpbe_dev->current_out_index;
+	struct vpbe_output *output = &cfg->outputs[out_index];
 	int sd_index = vpbe_dev->current_sd_index;
-	int ret;
+	int ret, i;
 
 
 	if (!(cfg->outputs[out_index].output.capabilities &
-	    V4L2_OUT_CAP_PRESETS))
+	    V4L2_OUT_CAP_CUSTOM_TIMINGS))
 		return -EINVAL;
 
-	ret = vpbe_get_dv_preset_info(vpbe_dev, dv_preset->preset);
-
-	if (ret)
-		return ret;
-
+	for (i = 0; i < output->num_modes; i++) {
+		if (output->modes[i].timings_type == VPBE_ENC_CUSTOM_TIMINGS &&
+		    !memcmp(&output->modes[i].dv_timings,
+				dv_timings, sizeof(*dv_timings)))
+			break;
+	}
+	if (i >= output->num_modes)
+		return -EINVAL;
+	vpbe_dev->current_timings = output->modes[i];
 	mutex_lock(&vpbe_dev->lock);
 
-
 	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
-					s_dv_preset, dv_preset);
+					s_dv_timings, dv_timings);
 	if (!ret && (vpbe_dev->amp != NULL)) {
 		/* Call amplifier subdevice */
 		ret = v4l2_subdev_call(vpbe_dev->amp, video,
-				s_dv_preset, dv_preset);
+				s_dv_timings, dv_timings);
 	}
 	/* set the lcd controller output for the given mode */
 	if (!ret) {
@@ -392,17 +376,17 @@ static int vpbe_s_dv_preset(struct vpbe_device *vpbe_dev,
 }
 
 /**
- * vpbe_g_dv_preset - Get the preset in the current encoder
+ * vpbe_g_dv_timings - Get the timings in the current encoder
  *
- * Get the preset in the current encoder. Return the status. 0 - success
+ * Get the timings in the current encoder. Return the status. 0 - success
  * -EINVAL on error
  */
-static int vpbe_g_dv_preset(struct vpbe_device *vpbe_dev,
-		     struct v4l2_dv_preset *dv_preset)
+static int vpbe_g_dv_timings(struct vpbe_device *vpbe_dev,
+		     struct v4l2_dv_timings *dv_timings)
 {
 	if (vpbe_dev->current_timings.timings_type &
-	  VPBE_ENC_DV_PRESET) {
-		dv_preset->preset = vpbe_dev->current_timings.timings.dv_preset;
+	  VPBE_ENC_CUSTOM_TIMINGS) {
+		*dv_timings = vpbe_dev->current_timings.dv_timings;
 		return 0;
 	}
 
@@ -410,13 +394,13 @@ static int vpbe_g_dv_preset(struct vpbe_device *vpbe_dev,
 }
 
 /**
- * vpbe_enum_dv_presets - Enumerate the dv presets in the current encoder
+ * vpbe_enum_dv_timings - Enumerate the dv timings in the current encoder
  *
- * Get the preset in the current encoder. Return the status. 0 - success
+ * Get the timings in the current encoder. Return the status. 0 - success
  * -EINVAL on error
  */
-static int vpbe_enum_dv_presets(struct vpbe_device *vpbe_dev,
-			 struct v4l2_dv_enum_preset *preset_info)
+static int vpbe_enum_dv_timings(struct vpbe_device *vpbe_dev,
+			 struct v4l2_enum_dv_timings *timings)
 {
 	struct vpbe_config *cfg = vpbe_dev->cfg;
 	int out_index = vpbe_dev->current_out_index;
@@ -424,12 +408,12 @@ static int vpbe_enum_dv_presets(struct vpbe_device *vpbe_dev,
 	int j = 0;
 	int i;
 
-	if (!(output->output.capabilities & V4L2_OUT_CAP_PRESETS))
+	if (!(output->output.capabilities & V4L2_OUT_CAP_CUSTOM_TIMINGS))
 		return -EINVAL;
 
 	for (i = 0; i < output->num_modes; i++) {
-		if (output->modes[i].timings_type == VPBE_ENC_DV_PRESET) {
-			if (j == preset_info->index)
+		if (output->modes[i].timings_type == VPBE_ENC_CUSTOM_TIMINGS) {
+			if (j == timings->index)
 				break;
 			j++;
 		}
@@ -437,9 +421,8 @@ static int vpbe_enum_dv_presets(struct vpbe_device *vpbe_dev,
 
 	if (i == output->num_modes)
 		return -EINVAL;
-
-	return v4l_fill_dv_preset_info(output->modes[i].timings.dv_preset,
-					preset_info);
+	timings->timings = output->modes[i].dv_timings;
+	return 0;
 }
 
 /**
@@ -489,10 +472,10 @@ static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
  */
 static int vpbe_g_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
 {
-	struct vpbe_enc_mode_info cur_timings = vpbe_dev->current_timings;
+	struct vpbe_enc_mode_info *cur_timings = &vpbe_dev->current_timings;
 
-	if (cur_timings.timings_type & VPBE_ENC_STD) {
-		*std_id = cur_timings.timings.std_id;
+	if (cur_timings->timings_type & VPBE_ENC_STD) {
+		*std_id = cur_timings->std_id;
 		return 0;
 	}
 
@@ -511,7 +494,7 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 {
 	struct vpbe_enc_mode_info *preset_mode = NULL;
 	struct vpbe_config *cfg = vpbe_dev->cfg;
-	struct v4l2_dv_preset dv_preset;
+	struct v4l2_dv_timings dv_timings;
 	struct osd_state *osd_device;
 	int out_index = vpbe_dev->current_out_index;
 	int ret = 0;
@@ -530,11 +513,12 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 			 */
 			if (preset_mode->timings_type & VPBE_ENC_STD)
 				return vpbe_s_std(vpbe_dev,
-						 &preset_mode->timings.std_id);
-			if (preset_mode->timings_type & VPBE_ENC_DV_PRESET) {
-				dv_preset.preset =
-					preset_mode->timings.dv_preset;
-				return vpbe_s_dv_preset(vpbe_dev, &dv_preset);
+						 &preset_mode->std_id);
+			if (preset_mode->timings_type &
+						VPBE_ENC_CUSTOM_TIMINGS) {
+				dv_timings =
+					preset_mode->dv_timings;
+				return vpbe_s_dv_timings(vpbe_dev, &dv_timings);
 			}
 		}
 	}
@@ -810,9 +794,9 @@ static struct vpbe_device_ops vpbe_dev_ops = {
 	.enum_outputs = vpbe_enum_outputs,
 	.set_output = vpbe_set_output,
 	.get_output = vpbe_get_output,
-	.s_dv_preset = vpbe_s_dv_preset,
-	.g_dv_preset = vpbe_g_dv_preset,
-	.enum_dv_presets = vpbe_enum_dv_presets,
+	.s_dv_timings = vpbe_s_dv_timings,
+	.g_dv_timings = vpbe_g_dv_timings,
+	.enum_dv_timings = vpbe_enum_dv_timings,
 	.s_std = vpbe_s_std,
 	.g_std = vpbe_g_std,
 	.initialize = vpbe_initialize,
diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index 6fe7034..2fbf3bc 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -393,7 +393,7 @@ vpbe_disp_calculate_scale_factor(struct vpbe_display *disp_dev,
 	int h_scale;
 	int v_scale;
 
-	v4l2_std_id standard_id = vpbe_dev->current_timings.timings.std_id;
+	v4l2_std_id standard_id = vpbe_dev->current_timings.std_id;
 
 	/*
 	 * Application initially set the image format. Current display
@@ -943,7 +943,7 @@ static int vpbe_display_g_std(struct file *file, void *priv,
 
 	/* Get the standard from the current encoder */
 	if (vpbe_dev->current_timings.timings_type & VPBE_ENC_STD) {
-		*std_id = vpbe_dev->current_timings.timings.std_id;
+		*std_id = vpbe_dev->current_timings.std_id;
 		return 0;
 	}
 
@@ -1029,29 +1029,29 @@ static int vpbe_display_g_output(struct file *file, void *priv,
 }
 
 /**
- * vpbe_display_enum_dv_presets - Enumerate the dv presets
+ * vpbe_display_enum_dv_timings - Enumerate the dv timings
  *
- * enum the preset in the current encoder. Return the status. 0 - success
+ * enum the timings in the current encoder. Return the status. 0 - success
  * -EINVAL on error
  */
 static int
-vpbe_display_enum_dv_presets(struct file *file, void *priv,
-			struct v4l2_dv_enum_preset *preset)
+vpbe_display_enum_dv_timings(struct file *file, void *priv,
+			struct v4l2_enum_dv_timings *timings)
 {
 	struct vpbe_fh *fh = priv;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 	int ret;
 
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_ENUM_DV_PRESETS\n");
+	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_ENUM_DV_TIMINGS\n");
 
 	/* Enumerate outputs */
-	if (NULL == vpbe_dev->ops.enum_dv_presets)
+	if (NULL == vpbe_dev->ops.enum_dv_timings)
 		return -EINVAL;
 
-	ret = vpbe_dev->ops.enum_dv_presets(vpbe_dev, preset);
+	ret = vpbe_dev->ops.enum_dv_timings(vpbe_dev, timings);
 	if (ret) {
 		v4l2_err(&vpbe_dev->v4l2_dev,
-			"Failed to enumerate dv presets info\n");
+			"Failed to enumerate dv timings info\n");
 		return -EINVAL;
 	}
 
@@ -1059,21 +1059,21 @@ vpbe_display_enum_dv_presets(struct file *file, void *priv,
 }
 
 /**
- * vpbe_display_s_dv_preset - Set the dv presets
+ * vpbe_display_s_dv_timings - Set the dv timings
  *
- * Set the preset in the current encoder. Return the status. 0 - success
+ * Set the timings in the current encoder. Return the status. 0 - success
  * -EINVAL on error
  */
 static int
-vpbe_display_s_dv_preset(struct file *file, void *priv,
-				struct v4l2_dv_preset *preset)
+vpbe_display_s_dv_timings(struct file *file, void *priv,
+				struct v4l2_dv_timings *timings)
 {
 	struct vpbe_fh *fh = priv;
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 	int ret;
 
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_DV_PRESETS\n");
+	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_DV_TIMINGS\n");
 
 
 	/* If streaming is started, return error */
@@ -1083,13 +1083,13 @@ vpbe_display_s_dv_preset(struct file *file, void *priv,
 	}
 
 	/* Set the given standard in the encoder */
-	if (!vpbe_dev->ops.s_dv_preset)
+	if (!vpbe_dev->ops.s_dv_timings)
 		return -EINVAL;
 
-	ret = vpbe_dev->ops.s_dv_preset(vpbe_dev, preset);
+	ret = vpbe_dev->ops.s_dv_timings(vpbe_dev, timings);
 	if (ret) {
 		v4l2_err(&vpbe_dev->v4l2_dev,
-			"Failed to set the dv presets info\n");
+			"Failed to set the dv timings info\n");
 		return -EINVAL;
 	}
 	/* set the current norm to zero to be consistent. If STD is used
@@ -1101,26 +1101,25 @@ vpbe_display_s_dv_preset(struct file *file, void *priv,
 }
 
 /**
- * vpbe_display_g_dv_preset - Set the dv presets
+ * vpbe_display_g_dv_timings - Set the dv timings
  *
- * Get the preset in the current encoder. Return the status. 0 - success
+ * Get the timings in the current encoder. Return the status. 0 - success
  * -EINVAL on error
  */
 static int
-vpbe_display_g_dv_preset(struct file *file, void *priv,
-				struct v4l2_dv_preset *dv_preset)
+vpbe_display_g_dv_timings(struct file *file, void *priv,
+				struct v4l2_dv_timings *dv_timings)
 {
 	struct vpbe_fh *fh = priv;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_G_DV_PRESETS\n");
+	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_G_DV_TIMINGS\n");
 
 	/* Get the given standard in the encoder */
 
 	if (vpbe_dev->current_timings.timings_type &
-				VPBE_ENC_DV_PRESET) {
-		dv_preset->preset =
-			vpbe_dev->current_timings.timings.dv_preset;
+				VPBE_ENC_CUSTOM_TIMINGS) {
+		*dv_timings = vpbe_dev->current_timings.dv_timings;
 	} else {
 		return -EINVAL;
 	}
@@ -1560,9 +1559,9 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_enum_output	 = vpbe_display_enum_output,
 	.vidioc_s_output	 = vpbe_display_s_output,
 	.vidioc_g_output	 = vpbe_display_g_output,
-	.vidioc_s_dv_preset	 = vpbe_display_s_dv_preset,
-	.vidioc_g_dv_preset	 = vpbe_display_g_dv_preset,
-	.vidioc_enum_dv_presets	 = vpbe_display_enum_dv_presets,
+	.vidioc_s_dv_timings	 = vpbe_display_s_dv_timings,
+	.vidioc_g_dv_timings	 = vpbe_display_g_dv_timings,
+	.vidioc_enum_dv_timings	 = vpbe_display_enum_dv_timings,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	 = vpbe_display_g_register,
 	.vidioc_s_register	 = vpbe_display_s_register,
@@ -1630,8 +1629,7 @@ static __devinit int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 			VPBE_ENC_STD) {
 		vbd->tvnorms = (V4L2_STD_525_60 | V4L2_STD_625_50);
 		vbd->current_norm =
-			disp_dev->vpbe_dev->
-			current_timings.timings.std_id;
+			disp_dev->vpbe_dev->current_timings.std_id;
 	} else
 		vbd->current_norm = 0;
 
diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/video/davinci/vpbe_venc.c
index b21ecc8..86d47c3 100644
--- a/drivers/media/video/davinci/vpbe_venc.c
+++ b/drivers/media/video/davinci/vpbe_venc.c
@@ -298,7 +298,7 @@ static int venc_set_480p59_94(struct v4l2_subdev *sd)
 		return -EINVAL;
 
 	/* Setup clock at VPSS & VENC for SD */
-	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_480P59_94) < 0)
+	if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 27000000) < 0)
 		return -EINVAL;
 
 	venc_enabledigitaloutput(sd, 0);
@@ -345,7 +345,7 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
 	  (pdata->venc_type != VPBE_VERSION_2))
 		return -EINVAL;
 	/* Setup clock at VPSS & VENC for SD */
-	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_576P50) < 0)
+	if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 27000000) < 0)
 		return -EINVAL;
 
 	venc_enabledigitaloutput(sd, 0);
@@ -385,7 +385,7 @@ static int venc_set_720p60_internal(struct v4l2_subdev *sd)
 	struct venc_state *venc = to_state(sd);
 	struct venc_platform_data *pdata = venc->pdata;
 
-	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_720P60) < 0)
+	if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 74250000) < 0)
 		return -EINVAL;
 
 	venc_enabledigitaloutput(sd, 0);
@@ -413,7 +413,7 @@ static int venc_set_1080i30_internal(struct v4l2_subdev *sd)
 	struct venc_state *venc = to_state(sd);
 	struct venc_platform_data *pdata = venc->pdata;
 
-	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_1080P30) < 0)
+	if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 74250000) < 0)
 		return -EINVAL;
 
 	venc_enabledigitaloutput(sd, 0);
@@ -446,26 +446,27 @@ static int venc_s_std_output(struct v4l2_subdev *sd, v4l2_std_id norm)
 	return -EINVAL;
 }
 
-static int venc_s_dv_preset(struct v4l2_subdev *sd,
-			    struct v4l2_dv_preset *dv_preset)
+static int venc_s_dv_timings(struct v4l2_subdev *sd,
+			    struct v4l2_dv_timings *dv_timings)
 {
 	struct venc_state *venc = to_state(sd);
+	u32 height = dv_timings->bt.height;
 	int ret;
 
-	v4l2_dbg(debug, 1, sd, "venc_s_dv_preset\n");
+	v4l2_dbg(debug, 1, sd, "venc_s_dv_timings\n");
 
-	if (dv_preset->preset == V4L2_DV_576P50)
+	if (height == 576)
 		return venc_set_576p50(sd);
-	else if (dv_preset->preset == V4L2_DV_480P59_94)
+	else if (height == 480)
 		return venc_set_480p59_94(sd);
-	else if ((dv_preset->preset == V4L2_DV_720P60) &&
+	else if ((height == 720) &&
 			(venc->pdata->venc_type == VPBE_VERSION_2)) {
 		/* TBD setup internal 720p mode here */
 		ret = venc_set_720p60_internal(sd);
 		/* for DM365 VPBE, there is DAC inside */
 		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
 		return ret;
-	} else if ((dv_preset->preset == V4L2_DV_1080I30) &&
+	} else if ((height == 1080) &&
 		(venc->pdata->venc_type == VPBE_VERSION_2)) {
 		/* TBD setup internal 1080i mode here */
 		ret = venc_set_1080i30_internal(sd);
@@ -518,7 +519,7 @@ static const struct v4l2_subdev_core_ops venc_core_ops = {
 static const struct v4l2_subdev_video_ops venc_video_ops = {
 	.s_routing = venc_s_routing,
 	.s_std_output = venc_s_std_output,
-	.s_dv_preset = venc_s_dv_preset,
+	.s_dv_timings = venc_s_dv_timings,
 };
 
 static const struct v4l2_subdev_ops venc_ops = {
diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
index 8bc1b3c..a7ca488 100644
--- a/include/media/davinci/vpbe.h
+++ b/include/media/davinci/vpbe.h
@@ -35,7 +35,7 @@ struct osd_config_info {
 struct vpbe_output {
 	struct v4l2_output output;
 	/*
-	 * If output capabilities include dv_preset, list supported presets
+	 * If output capabilities include dv_timings, list supported timings
 	 * below
 	 */
 	char *subdev_name;
@@ -120,16 +120,16 @@ struct vpbe_device_ops {
 	unsigned int (*get_output)(struct vpbe_device *vpbe_dev);
 
 	/* Set DV preset at current output */
-	int (*s_dv_preset)(struct vpbe_device *vpbe_dev,
-			   struct v4l2_dv_preset *dv_preset);
+	int (*s_dv_timings)(struct vpbe_device *vpbe_dev,
+			   struct v4l2_dv_timings *dv_timings);
 
 	/* Get DV presets supported at the output */
-	int (*g_dv_preset)(struct vpbe_device *vpbe_dev,
-			   struct v4l2_dv_preset *dv_preset);
+	int (*g_dv_timings)(struct vpbe_device *vpbe_dev,
+			   struct v4l2_dv_timings *dv_timings);
 
 	/* Enumerate the DV Presets supported at the output */
-	int (*enum_dv_presets)(struct vpbe_device *vpbe_dev,
-			       struct v4l2_dv_enum_preset *preset_info);
+	int (*enum_dv_timings)(struct vpbe_device *vpbe_dev,
+			       struct v4l2_enum_dv_timings *timings_info);
 
 	/* Set std at the output */
 	int (*s_std)(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id);
diff --git a/include/media/davinci/vpbe_types.h b/include/media/davinci/vpbe_types.h
index 727f551..9b85396 100644
--- a/include/media/davinci/vpbe_types.h
+++ b/include/media/davinci/vpbe_types.h
@@ -32,11 +32,6 @@ enum vpbe_enc_timings_type {
 	VPBE_ENC_TIMINGS_INVALID = 0x8,
 };
 
-union vpbe_timings {
-	v4l2_std_id std_id;
-	unsigned int dv_preset;
-};
-
 /*
  * struct vpbe_enc_mode_info
  * @name: ptr to name string of the standard, "NTSC", "PAL" etc
@@ -73,7 +68,8 @@ union vpbe_timings {
 struct vpbe_enc_mode_info {
 	unsigned char *name;
 	enum vpbe_enc_timings_type timings_type;
-	union vpbe_timings timings;
+	v4l2_std_id std_id;
+	struct v4l2_dv_timings dv_timings;
 	unsigned int interlaced;
 	unsigned int xres;
 	unsigned int yres;
diff --git a/include/media/davinci/vpbe_venc.h b/include/media/davinci/vpbe_venc.h
index 6b57334..cc78c2e 100644
--- a/include/media/davinci/vpbe_venc.h
+++ b/include/media/davinci/vpbe_venc.h
@@ -32,7 +32,7 @@ struct venc_platform_data {
 	int (*setup_pinmux)(enum v4l2_mbus_pixelcode if_type,
 			    int field);
 	int (*setup_clock)(enum vpbe_enc_timings_type type,
-			   unsigned int mode);
+			   unsigned int pixclock);
 	int (*setup_if_config)(enum v4l2_mbus_pixelcode pixcode);
 	/* Number of LCD outputs supported */
 	int num_lcd_outputs;
-- 
1.7.0.4

