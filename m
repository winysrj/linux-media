Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:34143 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0BBHIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 02:08:30 -0500
Received: by mail-px0-f182.google.com with SMTP id 12so5432630pxi.33
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 23:08:30 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH v2 05/10] add FM support for tlg2300
Date: Tue,  2 Feb 2010 15:07:51 +0800
Message-Id: <1265094475-13059-6-git-send-email-shijie8@gmail.com>
In-Reply-To: <1265094475-13059-5-git-send-email-shijie8@gmail.com>
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
 <1265094475-13059-2-git-send-email-shijie8@gmail.com>
 <1265094475-13059-3-git-send-email-shijie8@gmail.com>
 <1265094475-13059-4-git-send-email-shijie8@gmail.com>
 <1265094475-13059-5-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This module contains codes for radio.
The radio use the ALSA audio as input.

The mplayer should be compiled with --enable-radio and
 	 --enable-radio-capture.
	 The command runs as this(assume the alsa audio registers to card 1):
	#mplayer radio://103.7/capture/ -radio
		 adevice=hw=1,0:arate=48000 -rawaudio
		 rate=48000:channels=2

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/video/tlg2300/pd-radio.c |  351 ++++++++++++++++++++++++++++++++
 1 files changed, 351 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/tlg2300/pd-radio.c

diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/video/tlg2300/pd-radio.c
new file mode 100644
index 0000000..bdbb0c1
--- /dev/null
+++ b/drivers/media/video/tlg2300/pd-radio.c
@@ -0,0 +1,351 @@
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitmap.h>
+#include <linux/usb.h>
+#include <linux/i2c.h>
+#include <media/v4l2-dev.h>
+#include <linux/version.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <media/v4l2-ioctl.h>
+#include <linux/sched.h>
+
+#include "pd-common.h"
+#include "vendorcmds.h"
+
+static int set_frequency(struct poseidon *p, __u32 frequency);
+static int poseidon_fm_close(struct file *filp);
+static int poseidon_fm_open(struct file *filp);
+
+#define TUNER_FREQ_MIN_FM 76000000
+#define TUNER_FREQ_MAX_FM 108000000
+
+static int poseidon_check_mode_radio(struct poseidon *p)
+{
+	int ret, radiomode;
+	u32 status;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(HZ/2);
+	ret = usb_set_interface(p->udev, 0, BULK_ALTERNATE_IFACE);
+	if (ret < 0)
+		goto out;
+
+	ret = set_tuner_mode(p, TLG_MODE_FM_RADIO);
+	if (ret != 0)
+		goto out;
+
+	ret = send_set_req(p, SGNL_SRC_SEL, TLG_SIG_SRC_ANTENNA, &status);
+	radiomode = get_audio_std(TLG_MODE_FM_RADIO, p->country_code);
+	ret = send_set_req(p, TUNER_AUD_ANA_STD, radiomode, &status);
+	ret |= send_set_req(p, TUNER_AUD_MODE,
+				TLG_TUNE_TVAUDIO_MODE_STEREO, &status);
+	ret |= send_set_req(p, AUDIO_SAMPLE_RATE_SEL,
+				ATV_AUDIO_RATE_48K, &status);
+	ret |= send_set_req(p, TUNE_FREQ_SELECT, TUNER_FREQ_MIN_FM, &status);
+out:
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int pm_fm_suspend(struct poseidon *p)
+{
+	logpm(p);
+	pm_alsa_suspend(p);
+	usb_set_interface(p->udev, 0, 0);
+	msleep(300);
+	return 0;
+}
+
+static int pm_fm_resume(struct poseidon *p)
+{
+	logpm(p);
+	poseidon_check_mode_radio(p);
+	set_frequency(p, p->radio_data.fm_freq);
+	pm_alsa_resume(p);
+	return 0;
+}
+#endif
+
+static int poseidon_fm_open(struct file *filp)
+{
+	struct video_device *vfd = video_devdata(filp);
+	struct poseidon *p = video_get_drvdata(vfd);
+	int ret = 0;
+
+	if (!p)
+		return -1;
+
+	mutex_lock(&p->lock);
+	if (p->state & POSEIDON_STATE_DISCONNECT) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (p->state && !(p->state & POSEIDON_STATE_FM)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	usb_autopm_get_interface(p->interface);
+	if (0 == p->state) {
+		p->country_code = country_code;
+		set_debug_mode(vfd, debug_mode);
+
+		ret = poseidon_check_mode_radio(p);
+		if (ret < 0) {
+			usb_autopm_put_interface(p->interface);
+			goto out;
+		}
+		p->state |= POSEIDON_STATE_FM;
+	}
+	p->radio_data.users++;
+	kref_get(&p->kref);
+	filp->private_data = p;
+out:
+	mutex_unlock(&p->lock);
+	return ret;
+}
+
+static int poseidon_fm_close(struct file *filp)
+{
+	struct poseidon *p = filp->private_data;
+	struct radio_data *fm = &p->radio_data;
+	uint32_t status;
+
+	mutex_lock(&p->lock);
+	fm->users--;
+	if (0 == fm->users)
+		p->state &= ~POSEIDON_STATE_FM;
+
+	if (fm->is_radio_streaming && filp == p->file_for_stream) {
+		fm->is_radio_streaming = 0;
+		send_set_req(p, PLAY_SERVICE, TLG_TUNE_PLAY_SVC_STOP, &status);
+	}
+	usb_autopm_put_interface(p->interface);
+	mutex_unlock(&p->lock);
+
+	kref_put(&p->kref, poseidon_delete);
+	filp->private_data = NULL;
+	return 0;
+}
+
+static int vidioc_querycap(struct file *file, void *priv,
+			struct v4l2_capability *v)
+{
+	struct poseidon *p = file->private_data;
+
+	strlcpy(v->driver, "tele-radio", sizeof(v->driver));
+	strlcpy(v->card, "Telegent Poseidon", sizeof(v->card));
+	usb_make_path(p->udev, v->bus_info, sizeof(v->bus_info));
+	v->version = KERNEL_VERSION(0, 0, 1);
+	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	return 0;
+}
+
+static const struct v4l2_file_operations poseidon_fm_fops = {
+	.owner         = THIS_MODULE,
+	.open          = poseidon_fm_open,
+	.release       = poseidon_fm_close,
+	.ioctl	       = video_ioctl2,
+};
+
+int tlg_fm_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
+{
+	struct tuner_fm_sig_stat_s fm_stat = {};
+	int ret, status, count = 5;
+	struct poseidon *p = file->private_data;
+
+	if (vt->index != 0)
+		return -EINVAL;
+
+	vt->type	= V4L2_TUNER_RADIO;
+	vt->capability	= V4L2_TUNER_CAP_STEREO;
+	vt->rangelow	= TUNER_FREQ_MIN_FM / 62500;
+	vt->rangehigh	= TUNER_FREQ_MAX_FM / 62500;
+	vt->rxsubchans	= V4L2_TUNER_SUB_STEREO;
+	vt->audmode	= V4L2_TUNER_MODE_STEREO;
+	vt->signal	= 0;
+	vt->afc 	= 0;
+
+	mutex_lock(&p->lock);
+	ret = send_get_req(p, TUNER_STATUS, TLG_MODE_FM_RADIO,
+			      &fm_stat, &status, sizeof(fm_stat));
+
+	while (fm_stat.sig_lock_busy && count-- && !ret) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ);
+
+		ret = send_get_req(p, TUNER_STATUS, TLG_MODE_FM_RADIO,
+				  &fm_stat, &status, sizeof(fm_stat));
+	}
+	mutex_unlock(&p->lock);
+
+	if (ret || status) {
+		vt->signal = 0;
+	} else if ((fm_stat.sig_present || fm_stat.sig_locked)
+			&& fm_stat.sig_strength == 0) {
+		vt->signal = 0xffff;
+	} else
+		vt->signal = (fm_stat.sig_strength * 255 / 10) << 8;
+
+	return 0;
+}
+
+int fm_get_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
+{
+	struct poseidon *p = file->private_data;
+
+	argp->frequency = p->radio_data.fm_freq;
+	return 0;
+}
+
+static int set_frequency(struct poseidon *p, __u32 frequency)
+{
+	__u32 freq ;
+	int ret, status, radiomode;
+
+	mutex_lock(&p->lock);
+
+	radiomode = get_audio_std(TLG_MODE_FM_RADIO, p->country_code);
+	/*NTSC 8,PAL 2 */
+	ret = send_set_req(p, TUNER_AUD_ANA_STD, radiomode, &status);
+
+	freq =  (frequency * 125) * 500 / 1000;/* kHZ */
+	if (freq < TUNER_FREQ_MIN_FM/1000 || freq > TUNER_FREQ_MAX_FM/1000) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	ret = send_set_req(p, TUNE_FREQ_SELECT, freq, &status);
+	if (ret < 0)
+		goto error ;
+	ret = send_set_req(p, TAKE_REQUEST, 0, &status);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(HZ/4);
+	if (!p->radio_data.is_radio_streaming) {
+		ret = send_set_req(p, TAKE_REQUEST, 0, &status);
+		ret = send_set_req(p, PLAY_SERVICE,
+				TLG_TUNE_PLAY_SVC_START, &status);
+		p->radio_data.is_radio_streaming = 1;
+	}
+	p->radio_data.fm_freq = frequency;
+error:
+	mutex_unlock(&p->lock);
+	return ret;
+}
+
+int fm_set_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
+{
+	struct poseidon *p = file->private_data;
+
+	p->file_for_stream  = file;
+#ifdef CONFIG_PM
+	p->pm_suspend = pm_fm_suspend;
+	p->pm_resume  = pm_fm_resume;
+#endif
+	return set_frequency(p, argp->frequency);
+}
+
+int tlg_fm_vidioc_g_ctrl(struct file *file, void *priv,
+		struct v4l2_control *arg)
+{
+    return 0;
+}
+
+int tlg_fm_vidioc_exts_ctrl(struct file *file, void *fh,
+		struct v4l2_ext_controls *a)
+{
+    return 0;
+}
+
+int tlg_fm_vidioc_s_ctrl(struct file *file, void *priv,
+		struct v4l2_control *arg)
+{
+    return 0;
+}
+
+int tlg_fm_vidioc_queryctrl(struct file *file, void *priv,
+		struct v4l2_queryctrl *arg)
+{
+	arg->minimum = 0;
+	arg->maximum = 65535;
+	return 0;
+}
+
+static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
+{
+	return vt->index > 0 ? -EINVAL : 0;
+}
+static int vidioc_s_audio(struct file *file, void *priv, struct v4l2_audio *va)
+{
+	return (va->index != 0) ? -EINVAL : 0;
+}
+
+static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
+{
+	a->index    = 0;
+	a->mode    = 0;
+	a->capability = V4L2_AUDCAP_STEREO;
+	strcpy(a->name, "Radio");
+	return 0;
+}
+
+static int vidioc_s_input(struct file *filp, void *priv, u32 i)
+{
+	return (i != 0) ? -EINVAL : 0;
+}
+
+static int vidioc_g_input(struct file *filp, void *priv, u32 *i)
+{
+	return (*i != 0) ? -EINVAL : 0;
+}
+
+static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
+	.vidioc_querycap    = vidioc_querycap,
+	.vidioc_g_audio     = vidioc_g_audio,
+	.vidioc_s_audio     = vidioc_s_audio,
+	.vidioc_g_input     = vidioc_g_input,
+	.vidioc_s_input     = vidioc_s_input,
+	.vidioc_queryctrl   = tlg_fm_vidioc_queryctrl,
+	.vidioc_g_ctrl      = tlg_fm_vidioc_g_ctrl,
+	.vidioc_s_ctrl      = tlg_fm_vidioc_s_ctrl,
+	.vidioc_s_ext_ctrls = tlg_fm_vidioc_exts_ctrl,
+	.vidioc_s_tuner     = vidioc_s_tuner,
+	.vidioc_g_tuner     = tlg_fm_vidioc_g_tuner,
+	.vidioc_g_frequency = fm_get_freq,
+	.vidioc_s_frequency = fm_set_freq,
+};
+
+static struct video_device poseidon_fm_template = {
+	.name       = "Telegent-Radio",
+	.fops       = &poseidon_fm_fops,
+	.minor      = -1,
+	.release    = video_device_release,
+	.ioctl_ops  = &poseidon_fm_ioctl_ops,
+};
+
+int poseidon_fm_init(struct poseidon *p)
+{
+	struct video_device *fm_dev;
+
+	fm_dev = vdev_init(p, &poseidon_fm_template);
+	if (fm_dev == NULL)
+		return -1;
+
+	if (video_register_device(fm_dev, VFL_TYPE_RADIO, -1) < 0) {
+		video_device_release(fm_dev);
+		return -1;
+	}
+	p->radio_data.fm_dev = fm_dev;
+	return 0;
+}
+
+int poseidon_fm_exit(struct poseidon *p)
+{
+	destroy_video_device(&p->radio_data.fm_dev);
+	return 0;
+}
-- 
1.6.5.2

