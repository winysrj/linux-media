Return-path: <mchehab@localhost>
Received: from bear.ext.ti.com ([192.94.94.41]:38829 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab0IBOqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Sep 2010 10:46:32 -0400
From: raja_mani@ti.com
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@infradead.org
Cc: matti.j.aaltonen@nokia.com, Raja Mani <raja_mani@ti.com>,
	Pramodh AG <pramodh_ag@ti.com>
Subject: [RFC/PATCH 7/8] drivers:staging:ti-st: Link FM TX module API with FM V4L2 module
Date: Thu,  2 Sep 2010 11:57:59 -0400
Message-Id: <1283443080-30644-8-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-7-git-send-email-raja_mani@ti.com>
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com>
 <1283443080-30644-2-git-send-email-raja_mani@ti.com>
 <1283443080-30644-3-git-send-email-raja_mani@ti.com>
 <1283443080-30644-4-git-send-email-raja_mani@ti.com>
 <1283443080-30644-5-git-send-email-raja_mani@ti.com>
 <1283443080-30644-6-git-send-email-raja_mani@ti.com>
 <1283443080-30644-7-git-send-email-raja_mani@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

From: Raja Mani <raja_mani@ti.com>

 Add FM TX API calls in FM V4L2 module which will internally link to V4L2
 subsystem. It includes ,

 1) Support for set/get modulator attributes and extended control.
 2) fm_v4l2_vidioc_s_ctrl ()
     + added support for V4L2_CID_TUNE_POWER_LEVEL,
       V4L2_CID_TUNE_PREEMPHASIS, V4L2_CID_FM_BAND,
       V4L2_CID_TUNE_ANTENNA_CAPACITOR
 3) fm_v4l2_vidioc_g_ctrl ()
     + added support for V4L2_CID_TUNE_PREEMPHASIS, V4L2_CID_FM_BAND

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
---
 drivers/staging/ti-st/fmdrv_v4l2.c |  243 ++++++++++++++++++++++++++++++++---
 1 files changed, 222 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/ti-st/fmdrv_v4l2.c b/drivers/staging/ti-st/fmdrv_v4l2.c
index c546a0f..d76344e 100644
--- a/drivers/staging/ti-st/fmdrv_v4l2.c
+++ b/drivers/staging/ti-st/fmdrv_v4l2.c
@@ -30,8 +30,7 @@
 #include "fmdrv_v4l2.h"
 #include "fmdrv_common.h"
 #include "fmdrv_rx.h"
-/* TODO: Enable when FM TX is supported */
-/* #include "fmdrv_tx.h" */
+#include "fmdrv_tx.h"
 
 #ifndef DEBUG
 #ifdef pr_info
@@ -134,9 +133,8 @@ static ssize_t fm_v4l2_fops_write(struct file *file, const char __user * buf,
 		   ret, rds.text_type, rds.text, rds.af_freq);
 
 	fmdev = video_drvdata(file);
-	/* TODO: Enable when FM TX is supported */
-	/* fm_tx_set_radio_text(fmdev, rds.text, rds.text_type); */
-	/* fm_tx_set_af(fmdev, rds.af_freq); */
+	fm_tx_set_radio_text(fmdev, rds.text, rds.text_type);
+	fm_tx_set_af(fmdev, rds.af_freq);
 
 	return 0;
 }
@@ -257,6 +255,9 @@ static int fm_v4l2_vidioc_g_ctrl(struct file *file, void *priv,
 	int ret = -EINVAL;
 	unsigned short curr_vol;
 	unsigned char curr_mute_mode;
+	unsigned char region;
+	unsigned char afreq;
+	short threshold;
 	struct fmdrv_ops *fmdev;
 
 	fmdev = video_drvdata(file);
@@ -274,16 +275,48 @@ static int fm_v4l2_vidioc_g_ctrl(struct file *file, void *priv,
 			goto exit;
 		ctrl->value = curr_vol;
 		break;
+	case V4L2_CID_FM_BAND:
+		if (fmdev->curr_fmmode != FM_MODE_RX)
+			break;
+		ret = fm_rx_get_region(fmdev, &region);
+		if (ret < 0)
+			break;
+		if (region == FM_BAND_EUROPE_US)
+			ctrl->value = V4L2_FM_BAND_OTHER;
+		else
+			ctrl->value = V4L2_FM_BAND_JAPAN;
+		break;
+	case V4L2_CID_RSSI_THRESHOLD:
+		ret = fm_rx_get_rssi_threshold(fmdev, &threshold);
+		if (ret == 0)
+			ctrl->value = threshold;
+		break;
+	case V4L2_CID_TUNE_AF:
+		ret = fm_rx_get_af_switch(fmdev, &afreq);
+		if (ret == 0)
+			ctrl->value = afreq;
+		break;
+	case V4L2_CID_TUNE_PREEMPHASIS:
+		ctrl->value = fmdev->tx_data.preemph;
+		break;
 	}
 
 exit:
 	return ret;
 }
 
+/* Change the value of specified control.
+ * V4L2_CID_TUNE_POWER_LEVEL: Application will specify power level value in
+ * units of dB/uV, whereas range and step are specific to FM chip. For TI's WL
+ * chips, convert application specified power level value to chip specific
+ * value by substracting it with 122. Refer to TI FM data sheet for details.
+ */
 static int fm_v4l2_vidioc_s_ctrl(struct file *file, void *priv,
 					struct v4l2_control *ctrl)
 {
 	int ret = -EINVAL;
+	unsigned int emph_filter;
+	unsigned char region;
 	struct fmdrv_ops *fmdev;
 
 	fmdev = video_drvdata(file);
@@ -291,17 +324,61 @@ static int fm_v4l2_vidioc_s_ctrl(struct file *file, void *priv,
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:	/* set mute */
 		ret = fmc_set_mute_mode(fmdev, (unsigned char)ctrl->value);
-		if (ret < 0)
-			goto exit;
 		break;
 	case V4L2_CID_AUDIO_VOLUME:	/* set volume */
 		ret = fm_rx_set_volume(fmdev, (unsigned short)ctrl->value);
-		if (ret < 0)
-			goto exit;
+		break;
+	case V4L2_CID_TUNE_POWER_LEVEL: /* set TX power level - ext control */
+		if (ctrl->value >= FM_PWR_LVL_LOW &&
+				ctrl->value <= FM_PWR_LVL_HIGH) {
+			ctrl->value = FM_PWR_LVL_HIGH - ctrl->value;
+			ret = fm_tx_set_pwr_lvl(fmdev,
+					(unsigned char)ctrl->value);
+		} else
+			ret = -ERANGE;
+		break;
+	case V4L2_CID_FM_BAND:
+		if (ctrl->value < V4L2_FM_BAND_OTHER ||
+				ctrl->value > V4L2_FM_BAND_JAPAN) {
+			ret = -ERANGE;
+			break;
+		}
+		if (ctrl->value == V4L2_FM_BAND_OTHER)
+			region = FM_BAND_EUROPE_US;
+		else
+			region = FM_BAND_JAPAN;
+		ret = fmc_set_region(fmdev, region);
+		break;
+	case V4L2_CID_RSSI_THRESHOLD:
+		ret = fm_rx_set_rssi_threshold(fmdev, (short)ctrl->value);
+		break;
+	case V4L2_CID_TUNE_AF:
+		ret = fm_rx_set_af_switch(fmdev, (unsigned char)ctrl->value);
+		break;
+	case V4L2_CID_TUNE_PREEMPHASIS:
+		if (ctrl->value < V4L2_PREEMPHASIS_DISABLED ||
+			ctrl->value > V4L2_PREEMPHASIS_75_uS) {
+			ret = -EINVAL;
+			break;
+		}
+		if (ctrl->value == V4L2_PREEMPHASIS_DISABLED)
+			emph_filter = FM_TX_PREEMPH_OFF;
+		else if (ctrl->value == V4L2_PREEMPHASIS_50_uS)
+			emph_filter = FM_TX_PREEMPH_50US;
+		else
+			emph_filter = FM_TX_PREEMPH_75US;
+		ret = fm_tx_set_preemph_filter(fmdev, emph_filter);
+		break;
+	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+		if (ctrl->value == FM_TX_ANT_IMP_50 ||
+			ctrl->value == FM_TX_ANT_IMP_200 ||
+				ctrl->value == FM_TX_ANT_IMP_500)
+			ret = fm_tx_set_ant_imp(fmdev, ctrl->value);
+		else
+			ret = -EINVAL;
 		break;
 	}
 
-exit:
 	return ret;
 }
 
@@ -324,7 +401,7 @@ static int fm_v4l2_vidioc_s_audio(struct file *file, void *priv,
 	return 0;
 }
 
-/* Get tuner attributes. If current mode is NOT RX, set to RX */
+/* Get tuner attributes. If current mode is NOT RX, return error */
 static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *tuner)
 {
@@ -340,12 +417,8 @@ static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
 
 	fmdev = video_drvdata(file);
 	if (fmdev->curr_fmmode != FM_MODE_RX) {
-		ret = fmc_set_mode(fmdev, FM_MODE_RX);
-		if (ret < 0) {
-			pr_err("(fmdrv): Failed to set RX mode; unable to " \
-					"read tuner attributes\n");
-			goto exit;
-		}
+		ret = -EPERM;
+		goto exit;
 	}
 
 	ret = fm_rx_get_currband_lowhigh_freq(fmdev, &bottom_frequency,
@@ -364,11 +437,12 @@ static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
 	strcpy(tuner->name, "FM");
 	tuner->type = V4L2_TUNER_RADIO;
 	/* Store rangelow and rangehigh freq in unit of 62.5 KHz */
-	tuner->rangelow = (bottom_frequency * 10000) / 625;
-	tuner->rangehigh = (top_frequency * 10000) / 625;
+	tuner->rangelow = bottom_frequency * 16;
+	tuner->rangehigh = top_frequency * 16;
 	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO |
 	((fmdev->rx.rds.flag == FM_RDS_ENABLE) ? V4L2_TUNER_SUB_RDS : 0);
-	tuner->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS;
+	tuner->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
+			    V4L2_TUNER_CAP_LOW;
 	tuner->audmode = (stereo_mono_mode ?
 			  V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO);
 
@@ -440,6 +514,8 @@ static int fm_v4l2_vidioc_g_frequency(struct file *file, void *priv,
 	ret = fmc_get_frequency(fmdev, &freq->frequency);
 	if (ret < 0)
 		return ret;
+
+	freq->frequency *= 16; /* unit of 62.5 */
 	return 0;
 }
 
@@ -451,6 +527,13 @@ static int fm_v4l2_vidioc_s_frequency(struct file *file, void *priv,
 	struct fmdrv_ops *fmdev;
 
 	fmdev = video_drvdata(file);
+
+	/*
+	* As per V4L2 specifications user sends the frequency
+	* in units of 62.5.
+	*/
+	freq->frequency = (unsigned int)(freq->frequency / 16);
+
 	ret = fmc_set_frequency(fmdev, freq->frequency);
 	if (ret < 0)
 		return ret;
@@ -482,6 +565,120 @@ exit:
 	return ret;
 }
 
+static int fm_v4l2_vidioc_g_ext_ctrls(struct file *file, void *priv,
+					struct v4l2_ext_controls *ext_ctrls)
+{
+	int index;
+	int ret = -EINVAL;
+	struct v4l2_control ctrl;
+
+	if (V4L2_CTRL_CLASS_FM_TX == ext_ctrls->ctrl_class) {
+		for (index = 0; index < ext_ctrls->count; index++) {
+			ctrl.id = ext_ctrls->controls[index].id;
+			ctrl.value = ext_ctrls->controls[index].value;
+			ret = fm_v4l2_vidioc_g_ctrl(file, priv, &ctrl);
+			if (ret < 0) {
+				ext_ctrls->error_idx = index;
+				break;
+			}
+			ext_ctrls->controls[index].value = ctrl.value;
+		}
+	}
+	return ret;
+}
+
+static int fm_v4l2_vidioc_s_ext_ctrls(struct file *file, void *priv,
+					struct v4l2_ext_controls *ext_ctrls)
+{
+	int index;
+	int ret = -EINVAL;
+	struct v4l2_control ctrl;
+
+	if (V4L2_CTRL_CLASS_FM_TX == ext_ctrls->ctrl_class) {
+		for (index = 0; index < ext_ctrls->count; index++) {
+			ctrl.id = ext_ctrls->controls[index].id;
+			ctrl.value = ext_ctrls->controls[index].value;
+			ret = fm_v4l2_vidioc_s_ctrl(file, priv, &ctrl);
+			if (ret < 0) {
+				ext_ctrls->error_idx = index;
+				break;
+			}
+			ext_ctrls->controls[index].value = ctrl.value;
+		}
+	}
+	return ret;
+}
+
+/* Get modulator attributes. If mode is not TX, return no attributes. */
+static int fm_v4l2_vidioc_g_modulator(struct file *file, void *priv,
+					struct v4l2_modulator *mod)
+{
+	int ret = -EPERM;
+	struct fmdrv_ops *fmdev;
+
+	if (mod->index != 0) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	fmdev = video_drvdata(file);
+	if (fmdev->curr_fmmode != FM_MODE_TX)
+		goto exit;
+
+	mod->txsubchans = ((fmdev->tx_data.aud_mode == FM_STEREO_MODE) ?
+	V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO) |
+	((fmdev->tx_data.rds.flag == FM_RDS_ENABLE) ? V4L2_TUNER_SUB_RDS : 0);
+
+	mod->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS;
+	ret = 0;
+exit:
+	return ret;
+}
+
+/* Set modulator attributes. If mode is not TX, set to TX. */
+static int fm_v4l2_vidioc_s_modulator(struct file *file, void *priv,
+					struct v4l2_modulator *mod)
+{
+	unsigned char rds_mode;
+	unsigned short aud_mode;
+	int ret;
+	struct fmdrv_ops *fmdev;
+
+	if (mod->index != 0) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	fmdev = video_drvdata(file);
+	if (fmdev->curr_fmmode != FM_MODE_TX) {
+		ret = fmc_set_mode(fmdev, FM_MODE_TX);
+		if (ret != 0) {
+			pr_err("(fmdrv): Failed to set TX mode; unable to " \
+					"set modulator attributes\n");
+			goto exit;
+		}
+	}
+
+	aud_mode = (mod->txsubchans & V4L2_TUNER_SUB_STEREO) ?
+			FM_STEREO_MODE : FM_MONO_MODE;
+	rds_mode = (mod->txsubchans & V4L2_TUNER_SUB_RDS) ?
+			FM_RDS_ENABLE : FM_RDS_DISABLE;
+
+	ret = fm_tx_set_stereo_mono(fmdev, aud_mode);
+	if (ret < 0) {
+		pr_err("(fmdrv): Failed to set mono/stereo mode for TX\n");
+		goto exit;
+	}
+
+	ret = fm_tx_set_rds_mode(fmdev, rds_mode);
+	if (ret < 0) {
+		pr_err("(fmdrv): Failed to set rds mode for TX\n");
+		goto exit;
+	}
+exit:
+	return ret;
+}
+
 static const struct v4l2_file_operations fm_drv_fops = {
 	.owner = THIS_MODULE,
 	.read = fm_v4l2_fops_read,
@@ -497,13 +694,17 @@ static const struct v4l2_ioctl_ops fm_drv_ioctl_ops = {
 	.vidioc_queryctrl = fm_v4l2_vidioc_queryctrl,
 	.vidioc_g_ctrl = fm_v4l2_vidioc_g_ctrl,
 	.vidioc_s_ctrl = fm_v4l2_vidioc_s_ctrl,
+	.vidioc_g_ext_ctrls = fm_v4l2_vidioc_g_ext_ctrls,
+	.vidioc_s_ext_ctrls = fm_v4l2_vidioc_s_ext_ctrls,
 	.vidioc_g_audio = fm_v4l2_vidioc_g_audio,
 	.vidioc_s_audio = fm_v4l2_vidioc_s_audio,
 	.vidioc_g_tuner = fm_v4l2_vidioc_g_tuner,
 	.vidioc_s_tuner = fm_v4l2_vidioc_s_tuner,
 	.vidioc_g_frequency = fm_v4l2_vidioc_g_frequency,
 	.vidioc_s_frequency = fm_v4l2_vidioc_s_frequency,
-	.vidioc_s_hw_freq_seek = fm_v4l2_vidioc_s_hw_freq_seek
+	.vidioc_s_hw_freq_seek = fm_v4l2_vidioc_s_hw_freq_seek,
+	.vidioc_g_modulator = fm_v4l2_vidioc_g_modulator,
+	.vidioc_s_modulator = fm_v4l2_vidioc_s_modulator
 };
 
 /* V4L2 RADIO device parent structure */
-- 
1.5.6.3

