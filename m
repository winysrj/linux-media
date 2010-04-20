Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50811 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0DTPUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 11:20:25 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3KFK9GE008479
	for <linux-media@vger.kernel.org>; Tue, 20 Apr 2010 10:20:24 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH 3/3] V4L2: WL1273 FM Radio: Controls for the FM radio.
Date: Tue, 20 Apr 2010 18:20:07 +0300
Message-Id: <1271776807-2710-4-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1271776807-2710-3-git-send-email-matti.j.aaltonen@nokia.com>
References: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1271776807-2710-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1271776807-2710-3-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file implements V4L2 controls for using the Texas Instruments
WL1273 FM Radio.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/media/radio/Kconfig        |   15 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c |  805 ++++++++++++++++++++++++++++++++++++
 3 files changed, 821 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 83567b8..209fd37 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -452,4 +452,19 @@ config RADIO_TIMBERDALE
 	  found behind the Timberdale FPGA on the Russellville board.
 	  Enabling this driver will automatically select the DSP and tuner.
 
+config RADIO_WL1273
+	tristate "Texas Instruments WL1273 I2C FM Radio"
+        depends on I2C && VIDEO_V4L2 && SND
+	select FW_LOADER
+	---help---
+	  Choose Y here if you have this FM radio chip.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux 2 API.  Information on
+	  this API and pointers to "v4l2" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-wl1273.
+
 endif # RADIO_ADAPTERS
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index f615583..d297074 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
 obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
 obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
 obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
+obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
 
 EXTRA_CFLAGS += -Isound
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
new file mode 100644
index 0000000..07f6787
--- /dev/null
+++ b/drivers/media/radio/radio-wl1273.c
@@ -0,0 +1,805 @@
+/*
+ * Driver for the Texas Instruments WL1273 FM radio.
+ *
+ * Copyright (C) Nokia Corporation
+ * Author: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#undef DEBUG
+
+#include <asm/unaligned.h>
+#include <linux/mfd/wl1273-core.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+
+#define DRIVER_DESC "Wl1273 FM Radio - V4L2"
+
+/*
+ * static int radio_nr - The number of the radio device
+ *
+ * The default is 0.
+ */
+static int radio_nr = -1;
+module_param(radio_nr, int, 0);
+MODULE_PARM_DESC(radio_nr, "Radio Nr");
+
+struct wl1273_device {
+	struct video_device *videodev;
+	struct device *dev;
+	struct wl1273_core *core;
+	bool rds_on;
+};
+
+static ssize_t wl1273_fm_fops_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	unsigned char *s;
+	u16 val;
+	int r;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (radio->core->mode == WL1273_MODE_RX)
+		return count;
+
+	if (mutex_lock_interruptible(&radio->core->lock))
+		return -EINTR;
+
+	/* Manual Mode */
+	if (count > 255)
+		val = 255;
+	else
+		val = count;
+
+	wl1273_fm_write_cmd(radio->core, WL1273_RDS_CONFIG_DATA_SET, val);
+
+	s = kmalloc(val + 1, GFP_KERNEL);
+	if (!s) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(s + 1, buf, val)) {
+		kfree(s);
+		r = -EFAULT;
+		goto out;
+	}
+
+	dev_dbg(radio->dev, "Count: %d\n", val);
+	dev_dbg(radio->dev, "From user: \"%s\"\n", s);
+
+	s[0] = WL1273_RDS_DATA_SET;
+	wl1273_fm_write_data(radio->core, s, val + 1);
+
+	kfree(s);
+	r = val;
+
+out:
+	mutex_unlock(&radio->core->lock);
+
+	return r;
+}
+
+static unsigned int wl1273_fm_fops_poll(struct file *file,
+					struct poll_table_struct *pts)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	unsigned int rd_index, wr_index;
+
+	/* TODO: handle the case of multiple readers */
+
+	poll_wait(file, &core->read_queue, pts);
+
+	rd_index = core->rd_index;
+	wr_index = core->wr_index;
+	if (rd_index != wr_index)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static int wl1273_fm_fops_open(struct file *file)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (!radio->rds_on) {
+		if (mutex_lock_interruptible(&core->lock)) {
+			r = -EINTR;
+			goto out;
+		}
+
+		r = wl1273_fm_rds_on(core);
+		if (r) {
+			mutex_unlock(&core->lock);
+			goto out;
+		}
+
+		radio->rds_on = true;
+		mutex_unlock(&core->lock);
+	}
+
+out:
+	return r;
+}
+
+static int wl1273_fm_fops_release(struct file *file)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (radio->rds_on) {
+		if (mutex_lock_interruptible(&core->lock))
+			return -EINTR;
+
+		wl1273_fm_rds_off(core);
+		radio->rds_on = false;
+		mutex_unlock(&core->lock);
+	}
+
+	return 0;
+}
+
+static ssize_t wl1273_fm_fops_read(struct file *file, char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	int r = 0;
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	unsigned int block_count = 0;
+
+	/* TODO: handle the case of multiple readers */
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (radio->core->mode == WL1273_MODE_TX)
+		return 0;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	/* block if no new data available */
+	while (core->wr_index == core->rd_index) {
+		if (file->f_flags & O_NONBLOCK) {
+			r = -EWOULDBLOCK;
+			goto out;
+		}
+
+		if (wait_event_interruptible(core->read_queue,
+					     core->wr_index !=
+					     core->rd_index) < 0) {
+			r = -EINTR;
+			goto out;
+		}
+	}
+
+	/* calculate block count from byte count */
+	count /= 3;
+
+	/* copy RDS blocks from the internal buffer and to user buffer */
+
+	while (block_count < count) {
+		if (core->rd_index == core->wr_index)
+			break;
+
+		/* always transfer complete RDS blocks */
+		if (copy_to_user(buf, &core->buffer[core->rd_index], 3))
+			break;
+
+		/* increment and wrap the read pointer */
+		core->rd_index += 3;
+		if (core->rd_index >= core->buf_size)
+			core->rd_index = 0;
+
+		/* increment counters */
+		block_count++;
+		buf += 3;
+		r += 3;
+	}
+
+out:
+	dev_dbg(radio->dev, "%s: exit\n", __func__);
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+static const struct v4l2_file_operations wl1273_fops = {
+	.owner		= THIS_MODULE,
+	.read		= wl1273_fm_fops_read,
+	.write		= wl1273_fm_fops_write,
+	.poll		= wl1273_fm_fops_poll,
+	.ioctl		= video_ioctl2,
+	.open		= wl1273_fm_fops_open,
+	.release	= wl1273_fm_fops_release,
+};
+
+static struct v4l2_queryctrl wl1273_v4l2_queryctrl[] = {
+	/* the disabled controls are only here
+	   to satisfy kradio and such apps */
+	{
+		.id		= V4L2_CID_AUDIO_VOLUME,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Volume",
+		.minimum	= 0,
+		.maximum	= 15,
+		.step		= 1,
+		.default_value	= 15,
+	},
+	{
+		.id		= V4L2_CID_AUDIO_BALANCE,
+		.flags		= V4L2_CTRL_FLAG_DISABLED,
+	},
+	{
+		.id		= V4L2_CID_AUDIO_BASS,
+		.flags		= V4L2_CTRL_FLAG_DISABLED,
+	},
+	{
+		.id		= V4L2_CID_AUDIO_TREBLE,
+		.flags		= V4L2_CTRL_FLAG_DISABLED,
+	},
+	{
+		.id		= V4L2_CID_AUDIO_MUTE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Mute",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	},
+	{
+		.id		= V4L2_CID_AUDIO_LOUDNESS,
+		.flags		= V4L2_CTRL_FLAG_DISABLED,
+	},
+};
+
+static int wl1273_fm_vidioc_querycap(struct file *file, void *priv,
+				     struct v4l2_capability *capability)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	strlcpy(capability->driver, WL1273_FM_DRIVER_NAME,
+		sizeof(capability->driver));
+	strlcpy(capability->card, "Texas Instruments Wl1273 FM Radio",
+		sizeof(capability->card));
+	sprintf(capability->bus_info, "I2C");
+	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
+		V4L2_CAP_RADIO | V4L2_CAP_READWRITE | V4L2_CAP_AUDIO;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_g_input(struct file *file, void *priv,
+				    unsigned int *i)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	*i = 0;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_s_input(struct file *file, void *priv,
+				    unsigned int i)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (i != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_queryctrl(struct file *file, void *priv,
+				      struct v4l2_queryctrl *qc)
+{
+	unsigned char i;
+	int r = -EINVAL;
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	for (i = 0; i < ARRAY_SIZE(wl1273_v4l2_queryctrl); i++) {
+		if (qc->id && qc->id == wl1273_v4l2_queryctrl[i].id) {
+			memcpy(qc, &wl1273_v4l2_queryctrl[i], sizeof(*qc));
+			r = 0;
+			break;
+		}
+	}
+	if (r < 0)
+		dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
+			 ": query control failed with %d\n", r);
+	return r;
+}
+
+static int wl1273_fm_vidioc_g_ctrl(struct file *file, void *priv,
+				   struct v4l2_control *ctrl)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	u16 val;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		if (core->mode == WL1273_MODE_RX)
+			r = wl1273_fm_read_reg(core, WL1273_MUTE_STATUS_SET,
+					       &val);
+		else
+			r = wl1273_fm_read_reg(core, WL1273_MUTE, &val);
+
+		if (r)
+			goto out;
+
+		dev_dbg(radio->dev,
+			"MUTE STATUS GET: 0x%02x\n", val);
+
+		if (val)
+			ctrl->value = 1;
+		else
+			ctrl->value = 0;
+
+		break;
+
+	case WL1273_CID_FM_RADIO_MODE:
+		ctrl->value = wl1273_fm_get_mode(core);
+		break;
+
+	case WL1273_CID_FM_AUDIO_MODE:
+		ctrl->value = wl1273_fm_get_audio(core);
+		break;
+
+	case WL1273_CID_FM_REGION:
+		ctrl->value = wl1273_fm_get_region(core);
+		break;
+
+	case WL1273_CID_FM_CHAN_SPACING:
+		ctrl->value = wl1273_fm_tx_get_spacing(core);
+		break;
+
+	case WL1273_CID_FM_RDS_CTRL:
+		ctrl->value = wl1273_fm_get_tx_rds(core);
+		break;
+
+	case WL1273_CID_FM_CTUNE_VAL:
+		ctrl->value = wl1273_fm_get_tx_ctune(core);
+		break;
+
+	case WL1273_CID_TUNE_PREEMPHASIS:
+		ctrl->value = wl1273_fm_get_preemphasis(core);
+		break;
+
+	case WL1273_CID_TX_POWER:
+		ctrl->value = wl1273_fm_get_tx_power(core);
+		break;
+
+	case WL1273_CID_SEARCH_LVL:
+		ctrl->value = wl1273_fm_get_search_level(core);
+		break;
+
+	default:
+		dev_warn(radio->dev, "%s: Unknown IOCTL: %d\n",
+			 __func__, ctrl->id);
+		break;
+	}
+
+out:
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+#define WL1273_MUTE_SOFT_ENABLE    (1 << 0)
+#define WL1273_MUTE_AC             (1 << 1)
+#define WL1273_MUTE_HARD_LEFT      (1 << 2)
+#define WL1273_MUTE_HARD_RIGHT     (1 << 3)
+#define WL1273_MUTE_SOFT_FORCE     (1 << 4)
+
+static int wl1273_fm_vidioc_s_ctrl(struct file *file, void *priv,
+				   struct v4l2_control *ctrl)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		if (mutex_lock_interruptible(&core->lock))
+			return -EINTR;
+
+		if (core->mode == WL1273_MODE_RX && ctrl->value)
+			r = wl1273_fm_write_cmd(core,
+						WL1273_MUTE_STATUS_SET,
+						WL1273_MUTE_HARD_LEFT |
+						WL1273_MUTE_HARD_RIGHT);
+		else if (core->mode == WL1273_MODE_RX)
+			r = wl1273_fm_write_cmd(core,
+						WL1273_MUTE_STATUS_SET, 0x0);
+		else if (core->mode == WL1273_MODE_TX && ctrl->value)
+			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 1);
+		else if (core->mode == WL1273_MODE_TX)
+			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 0);
+
+		mutex_unlock(&core->lock);
+		break;
+
+	case WL1273_CID_FM_RADIO_MODE:
+		dev_dbg(radio->dev, "WL1273_CID_FM_RADIO_MODE\n");
+		r = wl1273_fm_set_mode(core, ctrl->value);
+		break;
+
+	case WL1273_CID_FM_AUDIO_MODE:
+		r = wl1273_fm_set_audio(core, ctrl->value);
+		break;
+
+	case WL1273_CID_FM_REGION:
+		r = wl1273_fm_set_region(core, ctrl->value);
+		break;
+
+	case WL1273_CID_FM_CHAN_SPACING:
+		r = wl1273_fm_tx_set_spacing(core, ctrl->value);
+		break;
+
+	case WL1273_CID_FM_RDS_CTRL:
+		r = wl1273_fm_set_tx_rds(core, ctrl->value);
+		break;
+
+	case WL1273_CID_TUNE_PREEMPHASIS:
+		r = wl1273_fm_set_preemphasis(core, ctrl->value);
+		break;
+
+	case WL1273_CID_TX_POWER:
+		r = wl1273_fm_set_tx_power(core, ctrl->value);
+		break;
+
+	case WL1273_CID_SEARCH_LVL:
+		r = wl1273_fm_set_search_level(core, ctrl->value);
+		break;
+
+	default:
+		dev_warn(radio->dev, "%s: Unknown IOCTL: %d\n",
+			 __func__, ctrl->id);
+		break;
+	}
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+	return r;
+}
+
+static int wl1273_fm_vidioc_g_audio(struct file *file, void *priv,
+				    struct v4l2_audio *audio)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (audio->index > 1)
+		return -EINVAL;
+
+	strcpy(audio->name, "Radio");
+	audio->capability = V4L2_AUDCAP_STEREO;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_s_audio(struct file *file, void *priv,
+				    struct v4l2_audio *audio)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (audio->index != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
+				    struct v4l2_tuner *tuner)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (tuner->index > 0)
+		return -EINVAL;
+
+	strcpy(tuner->name, WL1273_FM_DRIVER_NAME);
+	tuner->type = V4L2_TUNER_RADIO;
+
+	tuner->rangelow	=
+		core->regions[core->region].bottom_frequency * 10000 / 625;
+	tuner->rangehigh =
+		core->regions[core->region].top_frequency * 10000 / 625;
+
+	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+	tuner->capability = V4L2_TUNER_CAP_LOW;
+
+	if (core->mode == WL1273_MODE_RX) {
+		u16 val;
+		int r;
+
+		if (mutex_lock_interruptible(&core->lock))
+			return -EINTR;
+
+		r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &val);
+
+		mutex_unlock(&core->lock);
+		if (r)
+			return r;
+
+		tuner->signal = val;
+
+		dev_dbg(radio->dev, "Signal: %d\n", tuner->signal);
+
+		tuner->signal *= 256;
+		tuner->afc = 0;
+	}
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_s_tuner(struct file *file, void *priv,
+				    struct v4l2_tuner *tuner)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (tuner->index > 0)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	if (tuner->audmode == V4L2_TUNER_MODE_MONO)
+		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
+					WL1273_RX_MONO);
+	else
+		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
+					WL1273_RX_STEREO);
+
+	if (r < 0)
+		dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
+			 ": set tuner mode failed with %d\n", r);
+
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+static int wl1273_fm_vidioc_g_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *freq)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	freq->type = V4L2_TUNER_RADIO;
+	freq->frequency = wl1273_fm_get_freq(core) * 10000 / 625;
+
+	mutex_unlock(&core->lock);
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_s_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *freq)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r;
+
+	dev_dbg(radio->dev, "%s: %d\n", __func__, freq->frequency);
+
+	if (freq->type != V4L2_TUNER_RADIO) {
+		dev_dbg(radio->dev,
+			"freq->type != V4L2_TUNER_RADIO: %d\n", freq->type);
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, core->irq_flags);
+
+	if (core->mode == WL1273_MODE_RX) {
+		r = wl1273_fm_set_rx_freq(core, freq->frequency * 625 / 10000);
+		if (r)
+			dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
+				 ": set frequency failed with %d\n", r);
+	} else {
+		r = wl1273_fm_set_tx_freq(core, freq->frequency * 625 / 10000);
+		if (r)
+			dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
+				 ": set frequency failed with %d\n", r);
+	}
+
+	mutex_unlock(&core->lock);
+
+	dev_dbg(radio->dev, "wl1273_vidioc_s_frequency: DONE\n");
+	return r;
+}
+
+static int wl1273_fm_vidioc_s_hw_freq_seek(struct file *file, void *priv,
+					   struct v4l2_hw_freq_seek *seek)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (core->mode != WL1273_MODE_RX)
+		return 0;
+
+	if (seek->tuner != 0 || seek->type != V4L2_TUNER_RADIO)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	r = wl1273_fm_set_seek(core, seek->wrap_around, seek->seek_upward);
+	if (r)
+		dev_warn(radio->dev, "HW seek failed: %d\n", r);
+
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+static const struct v4l2_ioctl_ops wl1273_ioctl_ops = {
+	.vidioc_querycap	= wl1273_fm_vidioc_querycap,
+	.vidioc_g_input		= wl1273_fm_vidioc_g_input,
+	.vidioc_s_input		= wl1273_fm_vidioc_s_input,
+	.vidioc_queryctrl	= wl1273_fm_vidioc_queryctrl,
+	.vidioc_g_ctrl		= wl1273_fm_vidioc_g_ctrl,
+	.vidioc_s_ctrl		= wl1273_fm_vidioc_s_ctrl,
+	.vidioc_g_audio		= wl1273_fm_vidioc_g_audio,
+	.vidioc_s_audio		= wl1273_fm_vidioc_s_audio,
+	.vidioc_g_tuner		= wl1273_fm_vidioc_g_tuner,
+	.vidioc_s_tuner		= wl1273_fm_vidioc_s_tuner,
+	.vidioc_g_frequency	= wl1273_fm_vidioc_g_frequency,
+	.vidioc_s_frequency	= wl1273_fm_vidioc_s_frequency,
+	.vidioc_s_hw_freq_seek	= wl1273_fm_vidioc_s_hw_freq_seek,
+};
+
+static struct video_device wl1273_viddev_template = {
+	.fops			= &wl1273_fops,
+	.ioctl_ops		= &wl1273_ioctl_ops,
+	.name			= WL1273_FM_DRIVER_NAME,
+	.release		= video_device_release,
+};
+
+static int wl1273_fm_radio_remove(struct platform_device *pdev)
+{
+	dev_info(&pdev->dev, "%s.\n", __func__);
+
+	return 0;
+}
+
+static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
+{
+	struct wl1273_core **pdata = pdev->dev.platform_data;
+	struct wl1273_device *radio;
+	int r = 0;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data.\n");
+		return -EINVAL;
+	}
+
+	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
+	if (!radio)
+		return -ENOMEM;
+
+	radio->core = *pdata;
+	radio->dev = &pdev->dev;
+	radio->rds_on = false;
+
+	/* video device allocation */
+	radio->videodev = video_device_alloc();
+	if (!radio->videodev) {
+		dev_err(&pdev->dev, "Cannot allocate video device.\n");
+		r = -ENOMEM;
+		goto err_device_alloc;
+	}
+
+	/* V4L2 configuration */
+	memcpy(radio->videodev, &wl1273_viddev_template,
+	       sizeof(wl1273_viddev_template));
+
+	/* register video device */
+	r = video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr);
+	if (r) {
+		dev_err(&pdev->dev, WL1273_FM_DRIVER_NAME
+			": Could not register video device\n");
+		goto err_video_register;
+	}
+
+	video_set_drvdata(radio->videodev, radio);
+	platform_set_drvdata(pdev, radio);
+
+	return 0;
+
+err_video_register:
+	video_device_release(radio->videodev);
+err_device_alloc:
+	kfree(radio);
+
+	return r;
+}
+
+MODULE_ALIAS("platform:wl1273_fm_radio");
+
+static struct platform_driver wl1273_fm_radio_driver = {
+	.probe		= wl1273_fm_radio_probe,
+	.remove		= __devexit_p(wl1273_fm_radio_remove),
+	.driver		= {
+		.name	= "wl1273_fm_radio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init wl1273_fm_module_init(void)
+{
+	pr_info("%s\n", __func__);
+	return platform_driver_register(&wl1273_fm_radio_driver);
+}
+module_init(wl1273_fm_module_init);
+
+static void __exit wl1273_fm_module_exit(void)
+{
+	flush_scheduled_work();
+	platform_driver_unregister(&wl1273_fm_radio_driver);
+	pr_info(DRIVER_DESC ", Exiting.\n");
+}
+module_exit(wl1273_fm_module_exit);
+
+MODULE_AUTHOR("Matti Aaltonen <matti.j.aaltonen@nokia.com>");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
-- 
1.6.1.3

