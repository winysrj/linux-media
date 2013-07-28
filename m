Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:56923 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3G1UCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jul 2013 16:02:40 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 2/2] tea575x: Move from sound to media
Date: Sun, 28 Jul 2013 22:01:44 +0200
Message-Id: <1375041704-17928-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1375041704-17928-2-git-send-email-linux@rainbow-software.org>
References: <1375041704-17928-1-git-send-email-linux@rainbow-software.org>
 <1375041704-17928-2-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move tea575x from sound/i2c/other to drivers/media/radio
Includes Kconfig changes by Hans Verkuil.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/Kconfig     |   12 +-
 drivers/media/radio/Makefile    |    1 +
 drivers/media/radio/tea575x.c   |  584 +++++++++++++++++++++++++++++++++++++++
 sound/i2c/other/Makefile        |    2 -
 sound/i2c/other/tea575x-tuner.c |  584 ---------------------------------------
 sound/pci/Kconfig               |    9 +-
 6 files changed, 598 insertions(+), 594 deletions(-)
 create mode 100644 drivers/media/radio/tea575x.c
 delete mode 100644 sound/i2c/other/tea575x-tuner.c

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index d529ba7..39882dd 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -12,6 +12,9 @@ menuconfig RADIO_ADAPTERS
 
 if RADIO_ADAPTERS && VIDEO_V4L2
 
+config RADIO_TEA575X
+	tristate
+
 config RADIO_SI470X
 	bool "Silicon Labs Si470x FM Radio Receiver support"
 	depends on VIDEO_V4L2
@@ -61,7 +64,8 @@ config USB_DSBR
 
 config RADIO_MAXIRADIO
 	tristate "Guillemot MAXI Radio FM 2000 radio"
-	depends on VIDEO_V4L2 && PCI && SND
+	depends on VIDEO_V4L2 && PCI
+	select RADIO_TEA575X
 	---help---
 	  Choose Y here if you have this radio card.  This card may also be
 	  found as Gemtek PCI FM.
@@ -76,7 +80,8 @@ config RADIO_MAXIRADIO
 
 config RADIO_SHARK
 	tristate "Griffin radioSHARK USB radio receiver"
-	depends on USB && SND
+	depends on USB
+	select RADIO_TEA575X
 	---help---
 	  Choose Y here if you have this radio receiver.
 
@@ -393,7 +398,8 @@ config RADIO_SF16FMI
 
 config RADIO_SF16FMR2
 	tristate "SF16-FMR2/SF16-FMD2 Radio"
-	depends on ISA && VIDEO_V4L2 && SND
+	depends on ISA && VIDEO_V4L2
+	select RADIO_TEA575X
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
 
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 0dcdb32..3b64560 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
 obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
 obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
 obj-$(CONFIG_RADIO_WL128X) += wl128x/
+obj-$(CONFIG_RADIO_TEA575X) += tea575x.o
 
 shark2-objs := radio-shark2.o radio-tea5777.o
 
diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
new file mode 100644
index 0000000..cef0698
--- /dev/null
+++ b/drivers/media/radio/tea575x.c
@@ -0,0 +1,584 @@
+/*
+ *   ALSA driver for TEA5757/5759 Philips AM/FM radio tuner chips
+ *
+ *	Copyright (c) 2004 Jaroslav Kysela <perex@perex.cz>
+ *
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <asm/io.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
+#include <media/tea575x.h>
+
+MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
+MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
+MODULE_LICENSE("GPL");
+
+/*
+ * definitions
+ */
+
+#define TEA575X_BIT_SEARCH	(1<<24)		/* 1 = search action, 0 = tuned */
+#define TEA575X_BIT_UPDOWN	(1<<23)		/* 0 = search down, 1 = search up */
+#define TEA575X_BIT_MONO	(1<<22)		/* 0 = stereo, 1 = mono */
+#define TEA575X_BIT_BAND_MASK	(3<<20)
+#define TEA575X_BIT_BAND_FM	(0<<20)
+#define TEA575X_BIT_BAND_MW	(1<<20)
+#define TEA575X_BIT_BAND_LW	(2<<20)
+#define TEA575X_BIT_BAND_SW	(3<<20)
+#define TEA575X_BIT_PORT_0	(1<<19)		/* user bit */
+#define TEA575X_BIT_PORT_1	(1<<18)		/* user bit */
+#define TEA575X_BIT_SEARCH_MASK	(3<<16)		/* search level */
+#define TEA575X_BIT_SEARCH_5_28	     (0<<16)	/* FM >5uV, AM >28uV */
+#define TEA575X_BIT_SEARCH_10_40     (1<<16)	/* FM >10uV, AM > 40uV */
+#define TEA575X_BIT_SEARCH_30_63     (2<<16)	/* FM >30uV, AM > 63uV */
+#define TEA575X_BIT_SEARCH_150_1000  (3<<16)	/* FM > 150uV, AM > 1000uV */
+#define TEA575X_BIT_DUMMY	(1<<15)		/* buffer */
+#define TEA575X_BIT_FREQ_MASK	0x7fff
+
+enum { BAND_FM, BAND_FM_JAPAN, BAND_AM };
+
+static const struct v4l2_frequency_band bands[] = {
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			      V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  87500 * 16,
+		.rangehigh  = 108000 * 16,
+		.modulation = V4L2_BAND_MODULATION_FM,
+	},
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			      V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   = 76000 * 16,
+		.rangehigh  = 91000 * 16,
+		.modulation = V4L2_BAND_MODULATION_FM,
+	},
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 1,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  530 * 16,
+		.rangehigh  = 1710 * 16,
+		.modulation = V4L2_BAND_MODULATION_AM,
+	},
+};
+
+/*
+ * lowlevel part
+ */
+
+static void snd_tea575x_write(struct snd_tea575x *tea, unsigned int val)
+{
+	u16 l;
+	u8 data;
+
+	if (tea->ops->write_val)
+		return tea->ops->write_val(tea, val);
+
+	tea->ops->set_direction(tea, 1);
+	udelay(16);
+
+	for (l = 25; l > 0; l--) {
+		data = (val >> 24) & TEA575X_DATA;
+		val <<= 1;			/* shift data */
+		tea->ops->set_pins(tea, data | TEA575X_WREN);
+		udelay(2);
+		tea->ops->set_pins(tea, data | TEA575X_WREN | TEA575X_CLK);
+		udelay(2);
+		tea->ops->set_pins(tea, data | TEA575X_WREN);
+		udelay(2);
+	}
+
+	if (!tea->mute)
+		tea->ops->set_pins(tea, 0);
+}
+
+static u32 snd_tea575x_read(struct snd_tea575x *tea)
+{
+	u16 l, rdata;
+	u32 data = 0;
+
+	if (tea->ops->read_val)
+		return tea->ops->read_val(tea);
+
+	tea->ops->set_direction(tea, 0);
+	tea->ops->set_pins(tea, 0);
+	udelay(16);
+
+	for (l = 24; l--;) {
+		tea->ops->set_pins(tea, TEA575X_CLK);
+		udelay(2);
+		if (!l)
+			tea->tuned = tea->ops->get_pins(tea) & TEA575X_MOST ? 0 : 1;
+		tea->ops->set_pins(tea, 0);
+		udelay(2);
+		data <<= 1;			/* shift data */
+		rdata = tea->ops->get_pins(tea);
+		if (!l)
+			tea->stereo = (rdata & TEA575X_MOST) ?  0 : 1;
+		if (rdata & TEA575X_DATA)
+			data++;
+		udelay(2);
+	}
+
+	if (tea->mute)
+		tea->ops->set_pins(tea, TEA575X_WREN);
+
+	return data;
+}
+
+static u32 snd_tea575x_val_to_freq(struct snd_tea575x *tea, u32 val)
+{
+	u32 freq = val & TEA575X_BIT_FREQ_MASK;
+
+	if (freq == 0)
+		return freq;
+
+	switch (tea->band) {
+	case BAND_FM:
+		/* freq *= 12.5 */
+		freq *= 125;
+		freq /= 10;
+		/* crystal fixup */
+		freq -= TEA575X_FMIF;
+		break;
+	case BAND_FM_JAPAN:
+		/* freq *= 12.5 */
+		freq *= 125;
+		freq /= 10;
+		/* crystal fixup */
+		freq += TEA575X_FMIF;
+		break;
+	case BAND_AM:
+		/* crystal fixup */
+		freq -= TEA575X_AMIF;
+		break;
+	}
+
+	return clamp(freq * 16, bands[tea->band].rangelow,
+				bands[tea->band].rangehigh); /* from kHz */
+}
+
+static u32 snd_tea575x_get_freq(struct snd_tea575x *tea)
+{
+	return snd_tea575x_val_to_freq(tea, snd_tea575x_read(tea));
+}
+
+void snd_tea575x_set_freq(struct snd_tea575x *tea)
+{
+	u32 freq = tea->freq / 16;	/* to kHz */
+	u32 band = 0;
+
+	switch (tea->band) {
+	case BAND_FM:
+		band = TEA575X_BIT_BAND_FM;
+		/* crystal fixup */
+		freq += TEA575X_FMIF;
+		/* freq /= 12.5 */
+		freq *= 10;
+		freq /= 125;
+		break;
+	case BAND_FM_JAPAN:
+		band = TEA575X_BIT_BAND_FM;
+		/* crystal fixup */
+		freq -= TEA575X_FMIF;
+		/* freq /= 12.5 */
+		freq *= 10;
+		freq /= 125;
+		break;
+	case BAND_AM:
+		band = TEA575X_BIT_BAND_MW;
+		/* crystal fixup */
+		freq += TEA575X_AMIF;
+		break;
+	}
+
+	tea->val &= ~(TEA575X_BIT_FREQ_MASK | TEA575X_BIT_BAND_MASK);
+	tea->val |= band;
+	tea->val |= freq & TEA575X_BIT_FREQ_MASK;
+	snd_tea575x_write(tea, tea->val);
+	tea->freq = snd_tea575x_val_to_freq(tea, tea->val);
+}
+
+/*
+ * Linux Video interface
+ */
+
+static int vidioc_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *v)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+
+	strlcpy(v->driver, tea->v4l2_dev->name, sizeof(v->driver));
+	strlcpy(v->card, tea->card, sizeof(v->card));
+	strlcat(v->card, tea->tea5759 ? " TEA5759" : " TEA5757", sizeof(v->card));
+	strlcpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	if (!tea->cannot_read_data)
+		v->device_caps |= V4L2_CAP_HW_FREQ_SEEK;
+	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int vidioc_enum_freq_bands(struct file *file, void *priv,
+					 struct v4l2_frequency_band *band)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+	int index;
+
+	if (band->tuner != 0)
+		return -EINVAL;
+
+	switch (band->index) {
+	case 0:
+		if (tea->tea5759)
+			index = BAND_FM_JAPAN;
+		else
+			index = BAND_FM;
+		break;
+	case 1:
+		if (tea->has_am) {
+			index = BAND_AM;
+			break;
+		}
+		/* Fall through */
+	default:
+		return -EINVAL;
+	}
+
+	*band = bands[index];
+	if (!tea->cannot_read_data)
+		band->capability |= V4L2_TUNER_CAP_HWSEEK_BOUNDED;
+
+	return 0;
+}
+
+static int vidioc_g_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *v)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+	struct v4l2_frequency_band band_fm = { 0, };
+
+	if (v->index > 0)
+		return -EINVAL;
+
+	snd_tea575x_read(tea);
+	vidioc_enum_freq_bands(file, priv, &band_fm);
+
+	memset(v, 0, sizeof(*v));
+	strlcpy(v->name, tea->has_am ? "FM/AM" : "FM", sizeof(v->name));
+	v->type = V4L2_TUNER_RADIO;
+	v->capability = band_fm.capability;
+	v->rangelow = tea->has_am ? bands[BAND_AM].rangelow : band_fm.rangelow;
+	v->rangehigh = band_fm.rangehigh;
+	v->rxsubchans = tea->stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
+	v->audmode = (tea->val & TEA575X_BIT_MONO) ?
+		V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO;
+	v->signal = tea->tuned ? 0xffff : 0;
+	return 0;
+}
+
+static int vidioc_s_tuner(struct file *file, void *priv,
+					const struct v4l2_tuner *v)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+	u32 orig_val = tea->val;
+
+	if (v->index)
+		return -EINVAL;
+	tea->val &= ~TEA575X_BIT_MONO;
+	if (v->audmode == V4L2_TUNER_MODE_MONO)
+		tea->val |= TEA575X_BIT_MONO;
+	/* Only apply changes if currently tuning FM */
+	if (tea->band != BAND_AM && tea->val != orig_val)
+		snd_tea575x_set_freq(tea);
+
+	return 0;
+}
+
+static int vidioc_g_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *f)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+
+	if (f->tuner != 0)
+		return -EINVAL;
+	f->type = V4L2_TUNER_RADIO;
+	f->frequency = tea->freq;
+	return 0;
+}
+
+static int vidioc_s_frequency(struct file *file, void *priv,
+					const struct v4l2_frequency *f)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+
+	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
+		return -EINVAL;
+
+	if (tea->has_am && f->frequency < (20000 * 16))
+		tea->band = BAND_AM;
+	else if (tea->tea5759)
+		tea->band = BAND_FM_JAPAN;
+	else
+		tea->band = BAND_FM;
+
+	tea->freq = clamp_t(u32, f->frequency, bands[tea->band].rangelow,
+					bands[tea->band].rangehigh);
+	snd_tea575x_set_freq(tea);
+	return 0;
+}
+
+static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
+					const struct v4l2_hw_freq_seek *a)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+	unsigned long timeout;
+	int i, spacing;
+
+	if (tea->cannot_read_data)
+		return -ENOTTY;
+	if (a->tuner || a->wrap_around)
+		return -EINVAL;
+
+	if (file->f_flags & O_NONBLOCK)
+		return -EWOULDBLOCK;
+
+	if (a->rangelow || a->rangehigh) {
+		for (i = 0; i < ARRAY_SIZE(bands); i++) {
+			if ((i == BAND_FM && tea->tea5759) ||
+			    (i == BAND_FM_JAPAN && !tea->tea5759) ||
+			    (i == BAND_AM && !tea->has_am))
+				continue;
+			if (bands[i].rangelow  == a->rangelow &&
+			    bands[i].rangehigh == a->rangehigh)
+				break;
+		}
+		if (i == ARRAY_SIZE(bands))
+			return -EINVAL; /* No matching band found */
+		if (i != tea->band) {
+			tea->band = i;
+			tea->freq = clamp(tea->freq, bands[i].rangelow,
+						     bands[i].rangehigh);
+			snd_tea575x_set_freq(tea);
+		}
+	}
+
+	spacing = (tea->band == BAND_AM) ? 5 : 50; /* kHz */
+
+	/* clear the frequency, HW will fill it in */
+	tea->val &= ~TEA575X_BIT_FREQ_MASK;
+	tea->val |= TEA575X_BIT_SEARCH;
+	if (a->seek_upward)
+		tea->val |= TEA575X_BIT_UPDOWN;
+	else
+		tea->val &= ~TEA575X_BIT_UPDOWN;
+	snd_tea575x_write(tea, tea->val);
+	timeout = jiffies + msecs_to_jiffies(10000);
+	for (;;) {
+		if (time_after(jiffies, timeout))
+			break;
+		if (schedule_timeout_interruptible(msecs_to_jiffies(10))) {
+			/* some signal arrived, stop search */
+			tea->val &= ~TEA575X_BIT_SEARCH;
+			snd_tea575x_set_freq(tea);
+			return -ERESTARTSYS;
+		}
+		if (!(snd_tea575x_read(tea) & TEA575X_BIT_SEARCH)) {
+			u32 freq;
+
+			/* Found a frequency, wait until it can be read */
+			for (i = 0; i < 100; i++) {
+				msleep(10);
+				freq = snd_tea575x_get_freq(tea);
+				if (freq) /* available */
+					break;
+			}
+			if (freq == 0) /* shouldn't happen */
+				break;
+			/*
+			 * if we moved by less than the spacing, or in the
+			 * wrong direction, continue seeking
+			 */
+			if (abs(tea->freq - freq) < 16 * spacing ||
+					(a->seek_upward && freq < tea->freq) ||
+					(!a->seek_upward && freq > tea->freq)) {
+				snd_tea575x_write(tea, tea->val);
+				continue;
+			}
+			tea->freq = freq;
+			tea->val &= ~TEA575X_BIT_SEARCH;
+			return 0;
+		}
+	}
+	tea->val &= ~TEA575X_BIT_SEARCH;
+	snd_tea575x_set_freq(tea);
+	return -ENODATA;
+}
+
+static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct snd_tea575x *tea = container_of(ctrl->handler, struct snd_tea575x, ctrl_handler);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		tea->mute = ctrl->val;
+		snd_tea575x_set_freq(tea);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static const struct v4l2_file_operations tea575x_fops = {
+	.unlocked_ioctl	= video_ioctl2,
+	.open           = v4l2_fh_open,
+	.release        = v4l2_fh_release,
+	.poll           = v4l2_ctrl_poll,
+};
+
+static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
+	.vidioc_querycap    = vidioc_querycap,
+	.vidioc_g_tuner     = vidioc_g_tuner,
+	.vidioc_s_tuner     = vidioc_s_tuner,
+	.vidioc_g_frequency = vidioc_g_frequency,
+	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_s_hw_freq_seek = vidioc_s_hw_freq_seek,
+	.vidioc_enum_freq_bands = vidioc_enum_freq_bands,
+	.vidioc_log_status  = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static const struct video_device tea575x_radio = {
+	.ioctl_ops 	= &tea575x_ioctl_ops,
+	.release        = video_device_release_empty,
+};
+
+static const struct v4l2_ctrl_ops tea575x_ctrl_ops = {
+	.s_ctrl = tea575x_s_ctrl,
+};
+
+
+int snd_tea575x_hw_init(struct snd_tea575x *tea)
+{
+	tea->mute = true;
+
+	/* Not all devices can or know how to read the data back.
+	   Such devices can set cannot_read_data to true. */
+	if (!tea->cannot_read_data) {
+		snd_tea575x_write(tea, 0x55AA);
+		if (snd_tea575x_read(tea) != 0x55AA)
+			return -ENODEV;
+	}
+
+	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_5_28;
+	tea->freq = 90500 * 16;		/* 90.5Mhz default */
+	snd_tea575x_set_freq(tea);
+
+	return 0;
+}
+EXPORT_SYMBOL(snd_tea575x_hw_init);
+
+int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
+{
+	int retval = snd_tea575x_hw_init(tea);
+
+	if (retval)
+		return retval;
+
+	tea->vd = tea575x_radio;
+	video_set_drvdata(&tea->vd, tea);
+	mutex_init(&tea->mutex);
+	strlcpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
+	tea->vd.lock = &tea->mutex;
+	tea->vd.v4l2_dev = tea->v4l2_dev;
+	tea->fops = tea575x_fops;
+	tea->fops.owner = owner;
+	tea->vd.fops = &tea->fops;
+	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
+	/* disable hw_freq_seek if we can't use it */
+	if (tea->cannot_read_data)
+		v4l2_disable_ioctl(&tea->vd, VIDIOC_S_HW_FREQ_SEEK);
+
+	if (!tea->cannot_mute) {
+		tea->vd.ctrl_handler = &tea->ctrl_handler;
+		v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
+		v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops,
+				  V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+		retval = tea->ctrl_handler.error;
+		if (retval) {
+			v4l2_err(tea->v4l2_dev, "can't initialize controls\n");
+			v4l2_ctrl_handler_free(&tea->ctrl_handler);
+			return retval;
+		}
+
+		if (tea->ext_init) {
+			retval = tea->ext_init(tea);
+			if (retval) {
+				v4l2_ctrl_handler_free(&tea->ctrl_handler);
+				return retval;
+			}
+		}
+
+		v4l2_ctrl_handler_setup(&tea->ctrl_handler);
+	}
+
+	retval = video_register_device(&tea->vd, VFL_TYPE_RADIO, tea->radio_nr);
+	if (retval) {
+		v4l2_err(tea->v4l2_dev, "can't register video device!\n");
+		v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
+		return retval;
+	}
+
+	return 0;
+}
+
+void snd_tea575x_exit(struct snd_tea575x *tea)
+{
+	video_unregister_device(&tea->vd);
+	v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
+}
+
+static int __init alsa_tea575x_module_init(void)
+{
+	return 0;
+}
+
+static void __exit alsa_tea575x_module_exit(void)
+{
+}
+
+module_init(alsa_tea575x_module_init)
+module_exit(alsa_tea575x_module_exit)
+
+EXPORT_SYMBOL(snd_tea575x_init);
+EXPORT_SYMBOL(snd_tea575x_exit);
+EXPORT_SYMBOL(snd_tea575x_set_freq);
diff --git a/sound/i2c/other/Makefile b/sound/i2c/other/Makefile
index c95d8f1..5526b03 100644
--- a/sound/i2c/other/Makefile
+++ b/sound/i2c/other/Makefile
@@ -8,10 +8,8 @@ snd-ak4117-objs := ak4117.o
 snd-ak4113-objs := ak4113.o
 snd-ak4xxx-adda-objs := ak4xxx-adda.o
 snd-pt2258-objs := pt2258.o
-snd-tea575x-tuner-objs := tea575x-tuner.o
 
 # Module Dependency
 obj-$(CONFIG_SND_PDAUDIOCF) += snd-ak4117.o
 obj-$(CONFIG_SND_ICE1712) += snd-ak4xxx-adda.o
 obj-$(CONFIG_SND_ICE1724) += snd-ak4114.o snd-ak4113.o snd-ak4xxx-adda.o snd-pt2258.o
-obj-$(CONFIG_SND_TEA575X) += snd-tea575x-tuner.o
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
deleted file mode 100644
index cef0698..0000000
--- a/sound/i2c/other/tea575x-tuner.c
+++ /dev/null
@@ -1,584 +0,0 @@
-/*
- *   ALSA driver for TEA5757/5759 Philips AM/FM radio tuner chips
- *
- *	Copyright (c) 2004 Jaroslav Kysela <perex@perex.cz>
- *
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation; either version 2 of the License, or
- *   (at your option) any later version.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *   GNU General Public License for more details.
- *
- *   You should have received a copy of the GNU General Public License
- *   along with this program; if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- *
- */
-
-#include <asm/io.h>
-#include <linux/delay.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/sched.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-dev.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-event.h>
-#include <media/tea575x.h>
-
-MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
-MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
-MODULE_LICENSE("GPL");
-
-/*
- * definitions
- */
-
-#define TEA575X_BIT_SEARCH	(1<<24)		/* 1 = search action, 0 = tuned */
-#define TEA575X_BIT_UPDOWN	(1<<23)		/* 0 = search down, 1 = search up */
-#define TEA575X_BIT_MONO	(1<<22)		/* 0 = stereo, 1 = mono */
-#define TEA575X_BIT_BAND_MASK	(3<<20)
-#define TEA575X_BIT_BAND_FM	(0<<20)
-#define TEA575X_BIT_BAND_MW	(1<<20)
-#define TEA575X_BIT_BAND_LW	(2<<20)
-#define TEA575X_BIT_BAND_SW	(3<<20)
-#define TEA575X_BIT_PORT_0	(1<<19)		/* user bit */
-#define TEA575X_BIT_PORT_1	(1<<18)		/* user bit */
-#define TEA575X_BIT_SEARCH_MASK	(3<<16)		/* search level */
-#define TEA575X_BIT_SEARCH_5_28	     (0<<16)	/* FM >5uV, AM >28uV */
-#define TEA575X_BIT_SEARCH_10_40     (1<<16)	/* FM >10uV, AM > 40uV */
-#define TEA575X_BIT_SEARCH_30_63     (2<<16)	/* FM >30uV, AM > 63uV */
-#define TEA575X_BIT_SEARCH_150_1000  (3<<16)	/* FM > 150uV, AM > 1000uV */
-#define TEA575X_BIT_DUMMY	(1<<15)		/* buffer */
-#define TEA575X_BIT_FREQ_MASK	0x7fff
-
-enum { BAND_FM, BAND_FM_JAPAN, BAND_AM };
-
-static const struct v4l2_frequency_band bands[] = {
-	{
-		.type = V4L2_TUNER_RADIO,
-		.index = 0,
-		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
-			      V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =  87500 * 16,
-		.rangehigh  = 108000 * 16,
-		.modulation = V4L2_BAND_MODULATION_FM,
-	},
-	{
-		.type = V4L2_TUNER_RADIO,
-		.index = 0,
-		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
-			      V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   = 76000 * 16,
-		.rangehigh  = 91000 * 16,
-		.modulation = V4L2_BAND_MODULATION_FM,
-	},
-	{
-		.type = V4L2_TUNER_RADIO,
-		.index = 1,
-		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =  530 * 16,
-		.rangehigh  = 1710 * 16,
-		.modulation = V4L2_BAND_MODULATION_AM,
-	},
-};
-
-/*
- * lowlevel part
- */
-
-static void snd_tea575x_write(struct snd_tea575x *tea, unsigned int val)
-{
-	u16 l;
-	u8 data;
-
-	if (tea->ops->write_val)
-		return tea->ops->write_val(tea, val);
-
-	tea->ops->set_direction(tea, 1);
-	udelay(16);
-
-	for (l = 25; l > 0; l--) {
-		data = (val >> 24) & TEA575X_DATA;
-		val <<= 1;			/* shift data */
-		tea->ops->set_pins(tea, data | TEA575X_WREN);
-		udelay(2);
-		tea->ops->set_pins(tea, data | TEA575X_WREN | TEA575X_CLK);
-		udelay(2);
-		tea->ops->set_pins(tea, data | TEA575X_WREN);
-		udelay(2);
-	}
-
-	if (!tea->mute)
-		tea->ops->set_pins(tea, 0);
-}
-
-static u32 snd_tea575x_read(struct snd_tea575x *tea)
-{
-	u16 l, rdata;
-	u32 data = 0;
-
-	if (tea->ops->read_val)
-		return tea->ops->read_val(tea);
-
-	tea->ops->set_direction(tea, 0);
-	tea->ops->set_pins(tea, 0);
-	udelay(16);
-
-	for (l = 24; l--;) {
-		tea->ops->set_pins(tea, TEA575X_CLK);
-		udelay(2);
-		if (!l)
-			tea->tuned = tea->ops->get_pins(tea) & TEA575X_MOST ? 0 : 1;
-		tea->ops->set_pins(tea, 0);
-		udelay(2);
-		data <<= 1;			/* shift data */
-		rdata = tea->ops->get_pins(tea);
-		if (!l)
-			tea->stereo = (rdata & TEA575X_MOST) ?  0 : 1;
-		if (rdata & TEA575X_DATA)
-			data++;
-		udelay(2);
-	}
-
-	if (tea->mute)
-		tea->ops->set_pins(tea, TEA575X_WREN);
-
-	return data;
-}
-
-static u32 snd_tea575x_val_to_freq(struct snd_tea575x *tea, u32 val)
-{
-	u32 freq = val & TEA575X_BIT_FREQ_MASK;
-
-	if (freq == 0)
-		return freq;
-
-	switch (tea->band) {
-	case BAND_FM:
-		/* freq *= 12.5 */
-		freq *= 125;
-		freq /= 10;
-		/* crystal fixup */
-		freq -= TEA575X_FMIF;
-		break;
-	case BAND_FM_JAPAN:
-		/* freq *= 12.5 */
-		freq *= 125;
-		freq /= 10;
-		/* crystal fixup */
-		freq += TEA575X_FMIF;
-		break;
-	case BAND_AM:
-		/* crystal fixup */
-		freq -= TEA575X_AMIF;
-		break;
-	}
-
-	return clamp(freq * 16, bands[tea->band].rangelow,
-				bands[tea->band].rangehigh); /* from kHz */
-}
-
-static u32 snd_tea575x_get_freq(struct snd_tea575x *tea)
-{
-	return snd_tea575x_val_to_freq(tea, snd_tea575x_read(tea));
-}
-
-void snd_tea575x_set_freq(struct snd_tea575x *tea)
-{
-	u32 freq = tea->freq / 16;	/* to kHz */
-	u32 band = 0;
-
-	switch (tea->band) {
-	case BAND_FM:
-		band = TEA575X_BIT_BAND_FM;
-		/* crystal fixup */
-		freq += TEA575X_FMIF;
-		/* freq /= 12.5 */
-		freq *= 10;
-		freq /= 125;
-		break;
-	case BAND_FM_JAPAN:
-		band = TEA575X_BIT_BAND_FM;
-		/* crystal fixup */
-		freq -= TEA575X_FMIF;
-		/* freq /= 12.5 */
-		freq *= 10;
-		freq /= 125;
-		break;
-	case BAND_AM:
-		band = TEA575X_BIT_BAND_MW;
-		/* crystal fixup */
-		freq += TEA575X_AMIF;
-		break;
-	}
-
-	tea->val &= ~(TEA575X_BIT_FREQ_MASK | TEA575X_BIT_BAND_MASK);
-	tea->val |= band;
-	tea->val |= freq & TEA575X_BIT_FREQ_MASK;
-	snd_tea575x_write(tea, tea->val);
-	tea->freq = snd_tea575x_val_to_freq(tea, tea->val);
-}
-
-/*
- * Linux Video interface
- */
-
-static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *v)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-
-	strlcpy(v->driver, tea->v4l2_dev->name, sizeof(v->driver));
-	strlcpy(v->card, tea->card, sizeof(v->card));
-	strlcat(v->card, tea->tea5759 ? " TEA5759" : " TEA5757", sizeof(v->card));
-	strlcpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
-	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	if (!tea->cannot_read_data)
-		v->device_caps |= V4L2_CAP_HW_FREQ_SEEK;
-	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
-	return 0;
-}
-
-static int vidioc_enum_freq_bands(struct file *file, void *priv,
-					 struct v4l2_frequency_band *band)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-	int index;
-
-	if (band->tuner != 0)
-		return -EINVAL;
-
-	switch (band->index) {
-	case 0:
-		if (tea->tea5759)
-			index = BAND_FM_JAPAN;
-		else
-			index = BAND_FM;
-		break;
-	case 1:
-		if (tea->has_am) {
-			index = BAND_AM;
-			break;
-		}
-		/* Fall through */
-	default:
-		return -EINVAL;
-	}
-
-	*band = bands[index];
-	if (!tea->cannot_read_data)
-		band->capability |= V4L2_TUNER_CAP_HWSEEK_BOUNDED;
-
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-	struct v4l2_frequency_band band_fm = { 0, };
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	snd_tea575x_read(tea);
-	vidioc_enum_freq_bands(file, priv, &band_fm);
-
-	memset(v, 0, sizeof(*v));
-	strlcpy(v->name, tea->has_am ? "FM/AM" : "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->capability = band_fm.capability;
-	v->rangelow = tea->has_am ? bands[BAND_AM].rangelow : band_fm.rangelow;
-	v->rangehigh = band_fm.rangehigh;
-	v->rxsubchans = tea->stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
-	v->audmode = (tea->val & TEA575X_BIT_MONO) ?
-		V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO;
-	v->signal = tea->tuned ? 0xffff : 0;
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-					const struct v4l2_tuner *v)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-	u32 orig_val = tea->val;
-
-	if (v->index)
-		return -EINVAL;
-	tea->val &= ~TEA575X_BIT_MONO;
-	if (v->audmode == V4L2_TUNER_MODE_MONO)
-		tea->val |= TEA575X_BIT_MONO;
-	/* Only apply changes if currently tuning FM */
-	if (tea->band != BAND_AM && tea->val != orig_val)
-		snd_tea575x_set_freq(tea);
-
-	return 0;
-}
-
-static int vidioc_g_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = tea->freq;
-	return 0;
-}
-
-static int vidioc_s_frequency(struct file *file, void *priv,
-					const struct v4l2_frequency *f)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-
-	if (tea->has_am && f->frequency < (20000 * 16))
-		tea->band = BAND_AM;
-	else if (tea->tea5759)
-		tea->band = BAND_FM_JAPAN;
-	else
-		tea->band = BAND_FM;
-
-	tea->freq = clamp_t(u32, f->frequency, bands[tea->band].rangelow,
-					bands[tea->band].rangehigh);
-	snd_tea575x_set_freq(tea);
-	return 0;
-}
-
-static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
-					const struct v4l2_hw_freq_seek *a)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-	unsigned long timeout;
-	int i, spacing;
-
-	if (tea->cannot_read_data)
-		return -ENOTTY;
-	if (a->tuner || a->wrap_around)
-		return -EINVAL;
-
-	if (file->f_flags & O_NONBLOCK)
-		return -EWOULDBLOCK;
-
-	if (a->rangelow || a->rangehigh) {
-		for (i = 0; i < ARRAY_SIZE(bands); i++) {
-			if ((i == BAND_FM && tea->tea5759) ||
-			    (i == BAND_FM_JAPAN && !tea->tea5759) ||
-			    (i == BAND_AM && !tea->has_am))
-				continue;
-			if (bands[i].rangelow  == a->rangelow &&
-			    bands[i].rangehigh == a->rangehigh)
-				break;
-		}
-		if (i == ARRAY_SIZE(bands))
-			return -EINVAL; /* No matching band found */
-		if (i != tea->band) {
-			tea->band = i;
-			tea->freq = clamp(tea->freq, bands[i].rangelow,
-						     bands[i].rangehigh);
-			snd_tea575x_set_freq(tea);
-		}
-	}
-
-	spacing = (tea->band == BAND_AM) ? 5 : 50; /* kHz */
-
-	/* clear the frequency, HW will fill it in */
-	tea->val &= ~TEA575X_BIT_FREQ_MASK;
-	tea->val |= TEA575X_BIT_SEARCH;
-	if (a->seek_upward)
-		tea->val |= TEA575X_BIT_UPDOWN;
-	else
-		tea->val &= ~TEA575X_BIT_UPDOWN;
-	snd_tea575x_write(tea, tea->val);
-	timeout = jiffies + msecs_to_jiffies(10000);
-	for (;;) {
-		if (time_after(jiffies, timeout))
-			break;
-		if (schedule_timeout_interruptible(msecs_to_jiffies(10))) {
-			/* some signal arrived, stop search */
-			tea->val &= ~TEA575X_BIT_SEARCH;
-			snd_tea575x_set_freq(tea);
-			return -ERESTARTSYS;
-		}
-		if (!(snd_tea575x_read(tea) & TEA575X_BIT_SEARCH)) {
-			u32 freq;
-
-			/* Found a frequency, wait until it can be read */
-			for (i = 0; i < 100; i++) {
-				msleep(10);
-				freq = snd_tea575x_get_freq(tea);
-				if (freq) /* available */
-					break;
-			}
-			if (freq == 0) /* shouldn't happen */
-				break;
-			/*
-			 * if we moved by less than the spacing, or in the
-			 * wrong direction, continue seeking
-			 */
-			if (abs(tea->freq - freq) < 16 * spacing ||
-					(a->seek_upward && freq < tea->freq) ||
-					(!a->seek_upward && freq > tea->freq)) {
-				snd_tea575x_write(tea, tea->val);
-				continue;
-			}
-			tea->freq = freq;
-			tea->val &= ~TEA575X_BIT_SEARCH;
-			return 0;
-		}
-	}
-	tea->val &= ~TEA575X_BIT_SEARCH;
-	snd_tea575x_set_freq(tea);
-	return -ENODATA;
-}
-
-static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct snd_tea575x *tea = container_of(ctrl->handler, struct snd_tea575x, ctrl_handler);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		tea->mute = ctrl->val;
-		snd_tea575x_set_freq(tea);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-static const struct v4l2_file_operations tea575x_fops = {
-	.unlocked_ioctl	= video_ioctl2,
-	.open           = v4l2_fh_open,
-	.release        = v4l2_fh_release,
-	.poll           = v4l2_ctrl_poll,
-};
-
-static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
-	.vidioc_querycap    = vidioc_querycap,
-	.vidioc_g_tuner     = vidioc_g_tuner,
-	.vidioc_s_tuner     = vidioc_s_tuner,
-	.vidioc_g_frequency = vidioc_g_frequency,
-	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_s_hw_freq_seek = vidioc_s_hw_freq_seek,
-	.vidioc_enum_freq_bands = vidioc_enum_freq_bands,
-	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-};
-
-static const struct video_device tea575x_radio = {
-	.ioctl_ops 	= &tea575x_ioctl_ops,
-	.release        = video_device_release_empty,
-};
-
-static const struct v4l2_ctrl_ops tea575x_ctrl_ops = {
-	.s_ctrl = tea575x_s_ctrl,
-};
-
-
-int snd_tea575x_hw_init(struct snd_tea575x *tea)
-{
-	tea->mute = true;
-
-	/* Not all devices can or know how to read the data back.
-	   Such devices can set cannot_read_data to true. */
-	if (!tea->cannot_read_data) {
-		snd_tea575x_write(tea, 0x55AA);
-		if (snd_tea575x_read(tea) != 0x55AA)
-			return -ENODEV;
-	}
-
-	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_5_28;
-	tea->freq = 90500 * 16;		/* 90.5Mhz default */
-	snd_tea575x_set_freq(tea);
-
-	return 0;
-}
-EXPORT_SYMBOL(snd_tea575x_hw_init);
-
-int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
-{
-	int retval = snd_tea575x_hw_init(tea);
-
-	if (retval)
-		return retval;
-
-	tea->vd = tea575x_radio;
-	video_set_drvdata(&tea->vd, tea);
-	mutex_init(&tea->mutex);
-	strlcpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
-	tea->vd.lock = &tea->mutex;
-	tea->vd.v4l2_dev = tea->v4l2_dev;
-	tea->fops = tea575x_fops;
-	tea->fops.owner = owner;
-	tea->vd.fops = &tea->fops;
-	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
-	/* disable hw_freq_seek if we can't use it */
-	if (tea->cannot_read_data)
-		v4l2_disable_ioctl(&tea->vd, VIDIOC_S_HW_FREQ_SEEK);
-
-	if (!tea->cannot_mute) {
-		tea->vd.ctrl_handler = &tea->ctrl_handler;
-		v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
-		v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops,
-				  V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
-		retval = tea->ctrl_handler.error;
-		if (retval) {
-			v4l2_err(tea->v4l2_dev, "can't initialize controls\n");
-			v4l2_ctrl_handler_free(&tea->ctrl_handler);
-			return retval;
-		}
-
-		if (tea->ext_init) {
-			retval = tea->ext_init(tea);
-			if (retval) {
-				v4l2_ctrl_handler_free(&tea->ctrl_handler);
-				return retval;
-			}
-		}
-
-		v4l2_ctrl_handler_setup(&tea->ctrl_handler);
-	}
-
-	retval = video_register_device(&tea->vd, VFL_TYPE_RADIO, tea->radio_nr);
-	if (retval) {
-		v4l2_err(tea->v4l2_dev, "can't register video device!\n");
-		v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
-		return retval;
-	}
-
-	return 0;
-}
-
-void snd_tea575x_exit(struct snd_tea575x *tea)
-{
-	video_unregister_device(&tea->vd);
-	v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
-}
-
-static int __init alsa_tea575x_module_init(void)
-{
-	return 0;
-}
-
-static void __exit alsa_tea575x_module_exit(void)
-{
-}
-
-module_init(alsa_tea575x_module_init)
-module_exit(alsa_tea575x_module_exit)
-
-EXPORT_SYMBOL(snd_tea575x_init);
-EXPORT_SYMBOL(snd_tea575x_exit);
-EXPORT_SYMBOL(snd_tea575x_set_freq);
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index fe6fa93..9df80ef 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -1,10 +1,5 @@
 # ALSA PCI drivers
 
-config SND_TEA575X
-	tristate
-	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
-	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
-
 menuconfig SND_PCI
 	bool "PCI sound devices"
 	depends on PCI
@@ -542,7 +537,9 @@ config SND_ES1968_INPUT
 config SND_ES1968_RADIO
 	bool "Enable TEA5757 radio tuner support for es1968"
 	depends on SND_ES1968
+	depends on MEDIA_RADIO_SUPPORT
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_ES1968
+	select RADIO_TEA575X
 	help
 	  Say Y here to include support for TEA5757 radio tuner integrated on
 	  some MediaForte cards (e.g. SF64-PCE2).
@@ -562,7 +559,9 @@ config SND_FM801
 config SND_FM801_TEA575X_BOOL
 	bool "ForteMedia FM801 + TEA5757 tuner"
 	depends on SND_FM801
+	depends on MEDIA_RADIO_SUPPORT
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_FM801
+	select RADIO_TEA575X
 	help
 	  Say Y here to include support for soundcards based on the ForteMedia
 	  FM801 chip with a TEA5757 tuner (MediaForte SF256-PCS, SF256-PCP and
-- 
Ondrej Zary

