Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37418 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0HBNNU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 09:13:20 -0400
From: raja_mani@ti.com
To: olbpdev@list.ti.com, linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Raja-Mani <x0102026@ti.com>,
	Pramodh AG <pramodh_ag@ti.com>
Subject: [RFC 3/4] drivers:staging:ti-st: Sources for FM V4L2 interfaces
Date: Mon,  2 Aug 2010 08:13:11 -0500
Message-Id: <1280754792-14943-4-git-send-email-raja_mani@ti.com>
In-Reply-To: <1280754792-14943-3-git-send-email-raja_mani@ti.com>
References: <1280754792-14943-1-git-send-email-raja_mani@ti.com>
 <1280754792-14943-2-git-send-email-raja_mani@ti.com>
 <1280754792-14943-3-git-send-email-raja_mani@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Raja-Mani <x0102026@ti.com>

This module interfaces V4L2 subsystem and FM common
module. It registers itself with V4L2 as Radio module.

Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Raja-Mani <x0102026@ti.com>
---
 drivers/staging/ti-st/fmdrv_v4l2.c |  550 ++++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h |   32 ++
 2 files changed, 582 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h

diff --git a/drivers/staging/ti-st/fmdrv_v4l2.c b/drivers/staging/ti-st/fmdrv_v4l2.c
new file mode 100644
index 0000000..047bce5
--- /dev/null
+++ b/drivers/staging/ti-st/fmdrv_v4l2.c
@@ -0,0 +1,550 @@
+/*
+ *  FM Driver for Connectivity chip of Texas Instruments.
+ *  This file provides interfaces to V4L2 subsystem.
+ *
+ *  This module registers with V4L2 subsystem as Radio
+ *  data system interface (/dev/radio). During the registration,
+ *  it will expose two set of function pointers to V4L2 subsystem.
+ *
+ *    1) File operation related API (open, close, read, write, poll...etc).
+ *    2) Set of V4L2 IOCTL complaint API.
+ *
+ *  Copyright (C) 2010 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include "fmdrv.h"
+#include "fmdrv_v4l2.h"
+#include "fmdrv_common.h"
+#include "fmdrv_rx.h"
+/* TODO: Enable when FM TX is supported */
+/* #include "fmdrv_tx.h" */
+
+static struct video_device *gradio_dev;
+static unsigned char radio_disconnected;
+
+/* Query control */
+static struct v4l2_queryctrl fmdrv_v4l2_queryctrl[] = {
+	{
+	 .id = V4L2_CID_AUDIO_VOLUME,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
+	 .name = "Volume",
+	 .minimum = FM_RX_VOLUME_MIN,
+	 .maximum = FM_RX_VOLUME_MAX,
+	 .step = 1,
+	 .default_value = FM_DEFAULT_RX_VOLUME,
+	 },
+	{
+	 .id = V4L2_CID_AUDIO_BALANCE,
+	 .flags = V4L2_CTRL_FLAG_DISABLED,
+	 },
+	{
+	 .id = V4L2_CID_AUDIO_BASS,
+	 .flags = V4L2_CTRL_FLAG_DISABLED,
+	 },
+	{
+	 .id = V4L2_CID_AUDIO_TREBLE,
+	 .flags = V4L2_CTRL_FLAG_DISABLED,
+	 },
+	{
+	 .id = V4L2_CID_AUDIO_MUTE,
+	 .type = V4L2_CTRL_TYPE_BOOLEAN,
+	 .name = "Mute",
+	 .minimum = 0,
+	 .maximum = 2,
+	 .step = 1,
+	 .default_value = FM_MUTE_OFF,
+	 },
+	{
+	 .id = V4L2_CID_AUDIO_LOUDNESS,
+	 .flags = V4L2_CTRL_FLAG_DISABLED,
+	 },
+};
+
+/* -- V4L2 RADIO (/dev/radioX) device file operation interfaces --- */
+/* Read RX RDS data */
+static ssize_t fm_v4l2_fops_read(struct file *file, char __user * buf,
+					size_t count, loff_t *ppos)
+{
+	unsigned char rds_mode;
+	int ret;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+
+	if (!radio_disconnected) {
+		pr_err("(fmdrv): FM device is already disconnected\n");
+		ret = -EIO;
+		goto exit;
+	}
+
+	/* Turn on RDS mode , if it is disabled */
+	ret = fm_rx_get_rds_mode(fmdev, &rds_mode);
+	if (ret < 0) {
+		pr_err("(fmdrv): Unable to read current rds mode");
+		goto exit;
+	}
+	if (rds_mode == FM_RDS_DISABLE) {
+		ret = fmc_set_rds_mode(fmdev, FM_RDS_ENABLE);
+		if (ret < 0) {
+			pr_err("(fmdrv): Failed to enable rds mode");
+			goto exit;
+		}
+	}
+	/* Copy RDS data from internal buffer to user buffer */
+	ret = fmc_transfer_rds_from_internal_buff(fmdev, file, buf, count);
+
+exit:
+	return ret;
+}
+
+/* Write RDS data.
+ * TODO: When FM TX support is added, use "V4L2_CID_RDS_TX_XXXX" codes,
+ * instead of write operation.
+ */
+static ssize_t fm_v4l2_fops_write(struct file *file, const char __user * buf,
+					size_t count, loff_t *ppos)
+{
+	struct tx_rds rds;
+	int ret;
+	struct fmdrv_ops *fmdev;
+
+	ret = copy_from_user(&rds, buf, sizeof(rds));
+	pr_info("(fmdrv): (%d)type: %d, text %s, af %d",
+		   ret, rds.text_type, rds.text, rds.af_freq);
+
+	fmdev = video_drvdata(file);
+	/* TODO: Enable when FM TX is supported */
+	/* fm_tx_set_radio_text(fmdev, rds.text, rds.text_type); */
+	/* fm_tx_set_af(fmdev, rds.af_freq); */
+
+	return 0;
+}
+
+static unsigned int fm_v4l2_fops_poll(struct file *file,
+				      struct poll_table_struct *pts)
+{
+	int ret;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+	ret = fmc_is_rds_data_available(fmdev, file, pts);
+	if (!ret)
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+/* Handle open request for "/dev/radioX" device.
+ * Start with FM RX mode as default.
+ */
+static int fm_v4l2_fops_open(struct file *file)
+{
+	int ret;
+	struct fmdrv_ops *fmdev = NULL;
+
+	/* Don't allow multiple open */
+	if (radio_disconnected) {
+		pr_err("(fmdrv): FM device is already opened\n");
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	fmdev = video_drvdata(file);
+	ret = fmc_prepare(fmdev);
+	if (ret < 0) {
+		pr_err("(fmdrv): Unable to prepare FM CORE");
+		goto exit;
+	}
+
+	pr_info("(fmdrv): Load FM RX firmware..");
+	ret = fmc_set_mode(fmdev, FM_MODE_RX);
+	if (ret < 0) {
+		pr_err("(fmdrv): Unable to load FM RX firmware");
+		goto exit;
+	}
+	radio_disconnected = 1;
+
+exit:
+	return ret;
+}
+
+static int fm_v4l2_fops_release(struct file *file)
+{
+	int ret = 0;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+	if (!radio_disconnected) {
+		pr_info("(fmdrv):FM dev already closed, close called again?");
+		goto exit;
+	}
+	ret = fmc_set_mode(fmdev, FM_MODE_OFF);
+	if (ret < 0) {
+		pr_err("(fmdrv): Unable to turn off the chip");
+		goto exit;
+	}
+	ret = fmc_release(fmdev);
+	if (ret < 0) {
+		pr_err("(fmdrv): FM CORE release failed");
+		goto exit;
+	}
+	radio_disconnected = 0;
+
+exit:
+	return ret;
+}
+
+/* V4L2 RADIO (/dev/radioX) device IOCTL interfaces */
+static int fm_v4l2_vidioc_querycap(struct file *file, void *priv,
+					struct v4l2_capability *capability)
+{
+	strlcpy(capability->driver, FM_DRV_NAME, sizeof(capability->driver));
+	strlcpy(capability->card, FM_DRV_CARD_SHORT_NAME,
+		sizeof(capability->card));
+	sprintf(capability->bus_info, "UART");
+	capability->version = FM_DRV_RADIO_VERSION;
+	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
+				V4L2_CAP_RADIO | V4L2_CAP_MODULATOR |
+				V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
+				V4L2_CAP_RDS_CAPTURE;
+	return 0;
+}
+
+static int fm_v4l2_vidioc_queryctrl(struct file *file, void *priv,
+					struct v4l2_queryctrl *qc)
+{
+	int index;
+	int ret = -EINVAL;
+
+	if (qc->id < V4L2_CID_BASE)
+		return ret;
+
+	/* Search control ID and copy its properties */
+	for (index = 0; index < NO_OF_ENTRIES_IN_ARRAY(fmdrv_v4l2_queryctrl);\
+		index++) {
+		if (qc->id && qc->id == fmdrv_v4l2_queryctrl[index].id) {
+			memcpy(qc, &(fmdrv_v4l2_queryctrl[index]), sizeof(*qc));
+			ret = 0;
+			break;
+		}
+	}
+	return ret;
+}
+
+static int fm_v4l2_vidioc_g_ctrl(struct file *file, void *priv,
+					struct v4l2_control *ctrl)
+{
+	int ret = -EINVAL;
+	unsigned short curr_vol;
+	unsigned char curr_mute_mode;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:	/* get mute mode */
+		ret = fm_rx_get_mute_mode(fmdev, &curr_mute_mode);
+		if (ret < 0)
+			goto exit;
+		ctrl->value = curr_mute_mode;
+		break;
+	case V4L2_CID_AUDIO_VOLUME:	/* get volume */
+		ret = fm_rx_get_volume(fmdev, &curr_vol);
+		if (ret < 0)
+			goto exit;
+		ctrl->value = curr_vol;
+		break;
+	}
+
+exit:
+	return ret;
+}
+
+static int fm_v4l2_vidioc_s_ctrl(struct file *file, void *priv,
+					struct v4l2_control *ctrl)
+{
+	int ret = -EINVAL;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:	/* set mute */
+		ret = fmc_set_mute_mode(fmdev, (unsigned char)ctrl->value);
+		if (ret < 0)
+			goto exit;
+		break;
+	case V4L2_CID_AUDIO_VOLUME:	/* set volume */
+		ret = fm_rx_set_volume(fmdev, (unsigned short)ctrl->value);
+		if (ret < 0)
+			goto exit;
+		break;
+	}
+
+exit:
+	return ret;
+}
+
+static int fm_v4l2_vidioc_g_audio(struct file *file, void *priv,
+					struct v4l2_audio *audio)
+{
+	memset(audio, 0, sizeof(*audio));
+	audio->index = 0;
+	strcpy(audio->name, "Radio");
+	audio->capability = V4L2_AUDCAP_STEREO;
+
+	return 0;
+}
+
+static int fm_v4l2_vidioc_s_audio(struct file *file, void *priv,
+					struct v4l2_audio *audio)
+{
+	if (audio->index != 0)
+		return -EINVAL;
+	return 0;
+}
+
+/* Get tuner attributes. If current mode is NOT RX, set to RX */
+static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *tuner)
+{
+	unsigned int bottom_frequency;
+	unsigned int top_frequency;
+	unsigned short stereo_mono_mode;
+	unsigned short rssilvl;
+	int ret = -EINVAL;
+	struct fmdrv_ops *fmdev;
+
+	if (tuner->index != 0)
+		goto exit;
+
+	fmdev = video_drvdata(file);
+	if (fmdev->curr_fmmode != FM_MODE_RX) {
+		ret = fmc_set_mode(fmdev, FM_MODE_RX);
+		if (ret < 0) {
+			pr_err("(fmdrv): Failed to set RX mode; unable to " \
+					"read tuner attributes\n");
+			goto exit;
+		}
+	}
+
+	ret = fm_rx_get_currband_lowhigh_freq(fmdev, &bottom_frequency,
+						 &top_frequency);
+	if (ret < 0)
+		goto exit;
+
+	ret = fm_rx_get_stereo_mono(fmdev, &stereo_mono_mode);
+	if (ret < 0)
+		goto exit;
+
+	ret = fm_rx_get_rssi_level(fmdev, &rssilvl);
+	if (ret < 0)
+		goto exit;
+
+	strcpy(tuner->name, "FM");
+	tuner->type = V4L2_TUNER_RADIO;
+	/* Store rangelow and rangehigh freq in unit of 62.5 KHz */
+	tuner->rangelow = (bottom_frequency * 10000) / 625;
+	tuner->rangehigh = (top_frequency * 10000) / 625;
+	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO |
+	((fmdev->rx.rds.flag == FM_RDS_ENABLE) ? V4L2_TUNER_SUB_RDS : 0);
+	tuner->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS;
+	tuner->audmode = (stereo_mono_mode ?
+			  V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO);
+
+	/* Actual rssi value lies in between -128 to +127.
+	 * Convert this range from 0 to 255 by adding +128
+	 */
+	rssilvl += 128;
+
+	/* Return signal strength value should be within 0 to 65535.
+	 * Find out correct signal radio by multiplying (65535/255) = 257
+	 */
+	tuner->signal = rssilvl * 257;
+	tuner->afc = 0;
+
+exit:
+	return ret;
+}
+
+/* Set tuner attributes. If current mode is NOT RX, set to RX.
+ * Currently, we set only audio mode (mono/stereo) and RDS state (on/off).
+ * Should we set other tuner attributes, too?
+ */
+static int fm_v4l2_vidioc_s_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *tuner)
+{
+	unsigned short aud_mode;
+	unsigned char rds_mode;
+	int ret = -EINVAL;
+	struct fmdrv_ops *fmdev;
+
+	if (tuner->index != 0)
+		goto exit;
+
+	aud_mode = (tuner->audmode == V4L2_TUNER_MODE_STEREO) ?
+	    FM_STEREO_MODE : FM_MONO_MODE;
+	rds_mode = (tuner->rxsubchans & V4L2_TUNER_SUB_RDS) ?
+			FM_RDS_ENABLE : FM_RDS_DISABLE;
+
+	fmdev = video_drvdata(file);
+	if (fmdev->curr_fmmode != FM_MODE_RX) {
+		ret = fmc_set_mode(fmdev, FM_MODE_RX);
+		if (ret < 0) {
+			pr_err("(fmdrv): Failed to set RX mode; unable to" \
+					"write tuner attributes\n");
+			goto exit;
+		}
+	}
+
+	ret = fmc_set_stereo_mono(fmdev, aud_mode);
+	if (ret < 0)
+		goto exit;
+
+	ret = fmc_set_rds_mode(fmdev, rds_mode);
+	if (ret < 0)
+		goto exit;
+
+exit:
+	return ret;
+}
+
+/* Get tuner or modulator radio frequency */
+static int fm_v4l2_vidioc_g_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *freq)
+{
+	int ret;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+	ret = fmc_get_frequency(fmdev, &freq->frequency);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+/* Set tuner or modulator radio frequency */
+static int fm_v4l2_vidioc_s_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *freq)
+{
+	int ret;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+	ret = fmc_set_frequency(fmdev, freq->frequency);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+/* Set hardware frequency seek. If current mode is NOT RX, set it RX. */
+static int fm_v4l2_vidioc_s_hw_freq_seek(struct file *file, void *priv,
+					struct v4l2_hw_freq_seek *seek)
+{
+	int ret;
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_drvdata(file);
+	if (fmdev->curr_fmmode != FM_MODE_RX) {
+		ret = fmc_set_mode(fmdev, FM_MODE_RX);
+		if (ret != 0) {
+			pr_err("(fmdrv): Failed to set RX mode; unable to " \
+					"start HW frequency seek\n");
+			goto exit;
+		}
+	}
+
+	ret = fm_rx_seek(fmdev, seek->seek_upward, seek->wrap_around);
+	if (ret < 0)
+		goto exit;
+
+exit:
+	return ret;
+}
+
+static const struct v4l2_file_operations fm_drv_fops = {
+	.owner = THIS_MODULE,
+	.read = fm_v4l2_fops_read,
+	.write = fm_v4l2_fops_write,
+	.poll = fm_v4l2_fops_poll,
+	.ioctl = video_ioctl2,
+	.open = fm_v4l2_fops_open,
+	.release = fm_v4l2_fops_release,
+};
+
+static const struct v4l2_ioctl_ops fm_drv_ioctl_ops = {
+	.vidioc_querycap = fm_v4l2_vidioc_querycap,
+	.vidioc_queryctrl = fm_v4l2_vidioc_queryctrl,
+	.vidioc_g_ctrl = fm_v4l2_vidioc_g_ctrl,
+	.vidioc_s_ctrl = fm_v4l2_vidioc_s_ctrl,
+	.vidioc_g_audio = fm_v4l2_vidioc_g_audio,
+	.vidioc_s_audio = fm_v4l2_vidioc_s_audio,
+	.vidioc_g_tuner = fm_v4l2_vidioc_g_tuner,
+	.vidioc_s_tuner = fm_v4l2_vidioc_s_tuner,
+	.vidioc_g_frequency = fm_v4l2_vidioc_g_frequency,
+	.vidioc_s_frequency = fm_v4l2_vidioc_s_frequency,
+	.vidioc_s_hw_freq_seek = fm_v4l2_vidioc_s_hw_freq_seek
+};
+
+/* V4L2 RADIO device parent structure */
+static struct video_device fm_viddev_template = {
+	.fops = &fm_drv_fops,
+	.ioctl_ops = &fm_drv_ioctl_ops,
+	.name = FM_DRV_NAME,
+	.release = video_device_release,
+};
+
+int fm_v4l2_init_video_device(struct fmdrv_ops *fmdev, int radio_nr)
+{
+	int ret = -ENOMEM;
+
+	gradio_dev = NULL;
+	/* Allocate new video device */
+	gradio_dev = video_device_alloc();
+	if (NULL == gradio_dev) {
+		pr_err("(fmdrv): Can't allocate video device");
+		goto exit;
+	}
+
+	/* Setup FM driver's V4L2 properties */
+	memcpy(gradio_dev, &fm_viddev_template, sizeof(fm_viddev_template));
+
+	video_set_drvdata(gradio_dev, fmdev);
+
+	/* Register with V4L2 subsystem as RADIO device */
+	if (video_register_device(gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
+		video_device_release(gradio_dev);
+		pr_err("(fmdrv): Could not register video device");
+		goto exit;
+	}
+
+	fmdev->radio_dev = gradio_dev;
+	ret = 0;
+
+exit:
+	return ret;
+}
+
+void *fm_v4l2_deinit_video_device(void)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = video_get_drvdata(gradio_dev);
+	/* Unregister RADIO device from V4L2 subsystem */
+	video_unregister_device(gradio_dev);
+
+	return fmdev;
+}
diff --git a/drivers/staging/ti-st/fmdrv_v4l2.h b/drivers/staging/ti-st/fmdrv_v4l2.h
new file mode 100644
index 0000000..6f0a415
--- /dev/null
+++ b/drivers/staging/ti-st/fmdrv_v4l2.h
@@ -0,0 +1,32 @@
+/*
+ *  FM Driver for Connectivity chip of Texas Instruments.
+ *
+ *  FM V4L2 module header.
+ *
+ *  Copyright (C) 2010 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef _FMDRV_V4L2_H
+#define _FMDRV_V4L2_H
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+
+int fm_v4l2_init_video_device(struct fmdrv_ops *, int);
+void *fm_v4l2_deinit_video_device(void);
+
+#endif
-- 
1.5.6.3

