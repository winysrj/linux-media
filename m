Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbZLITEm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 14:04:42 -0500
Message-ID: <4B1FF4CC.70501@redhat.com>
Date: Wed, 09 Dec 2009 17:04:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 11/11] add FM support for tlg2300
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com> <1258687493-4012-2-git-send-email-shijie8@gmail.com> <1258687493-4012-3-git-send-email-shijie8@gmail.com> <1258687493-4012-4-git-send-email-shijie8@gmail.com> <1258687493-4012-5-git-send-email-shijie8@gmail.com> <1258687493-4012-6-git-send-email-shijie8@gmail.com> <1258687493-4012-7-git-send-email-shijie8@gmail.com> <1258687493-4012-8-git-send-email-shijie8@gmail.com> <1258687493-4012-9-git-send-email-shijie8@gmail.com> <1258687493-4012-10-git-send-email-shijie8@gmail.com> <1258687493-4012-11-git-send-email-shijie8@gmail.com> <1258687493-4012-12-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-12-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> This module contains codes for radio.
> The radio use the ALSA audio as input.
> 
>  The mplayer should be compiled with --enable-radio and
> 	 --enable-radio-capture.
> The command runs as this(assume the alsa audio registers to card 1):
> 	#mplayer radio://103.7/capture/ -radio
> 		 adevice=hw=1,0:arate=48000 -rawaudio rate=48000:channels=2
> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/media/video/tlg2300/pd-radio.c |  383 ++++++++++++++++++++++++++++++++
>  1 files changed, 383 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tlg2300/pd-radio.c
> 
> diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/video/tlg2300/pd-radio.c
> new file mode 100644
> index 0000000..2576f3a
> --- /dev/null
> +++ b/drivers/media/video/tlg2300/pd-radio.c
> @@ -0,0 +1,383 @@
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/bitmap.h>
> +#include <linux/usb.h>
> +#include <linux/i2c.h>
> +#include <media/v4l2-dev.h>
> +#include <linux/version.h>
> +#include <linux/mm.h>
> +#include <linux/mutex.h>
> +#include <media/v4l2-ioctl.h>
> +#include <linux/sched.h>
> +
> +#include "pd-common.h"
> +#include "vendorcmds.h"
> +
> +static int set_frequency(struct poseidon *p, __u32 frequency);
> +static int poseidon_fm_close(struct file *filp);
> +static int poseidon_fm_open(struct file *filp);
> +static int __poseidon_fm_close(struct file *filp);
> +
> +#define TUNER_FREQ_MIN_FM 76000000
> +#define TUNER_FREQ_MAX_FM 108000000
> +
> +static int poseidon_check_mode_radio(struct poseidon *p)
> +{
> +	int ret, radiomode;
> +	u32 status;
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(HZ/2);
> +	ret = usb_set_interface(p->udev, 0, BULK_ALTERNATE_IFACE);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = set_tuner_mode(p, TLG_MODE_FM_RADIO);
> +	if (ret != 0)
> +		goto out;
> +
> +	ret = send_set_req(p, SGNL_SRC_SEL, TLG_SIG_SRC_ANTENNA, &status);
> +	radiomode = get_audio_std(TLG_MODE_FM_RADIO, p->country_code);
> +	ret = send_set_req(p, TUNER_AUD_ANA_STD, radiomode, &status);
> +	ret |= send_set_req(p, TUNER_AUD_MODE,
> +				TLG_TUNE_TVAUDIO_MODE_STEREO, &status);
> +	ret |= send_set_req(p, AUDIO_SAMPLE_RATE_SEL,
> +				ATV_AUDIO_RATE_48K, &status);
> +	ret |= send_set_req(p, TUNE_FREQ_SELECT, TUNER_FREQ_MIN_FM, &status);
> +out:
> +	return ret;
> +}
> +
> +static int pm_fm_suspend(struct poseidon *p)
> +{
> +	pm_alsa_suspend(p);
> +	usb_set_interface(p->udev, 0, 0);
> +	mdelay(2000);
> +	return 0;
> +}
> +
> +static int pm_fm_resume(struct poseidon *p)
> +{
> +	if (in_hibernation(p)) {
> +		__poseidon_fm_close(p->file_for_stream);
> +		return 0;
> +	}
> +	poseidon_check_mode_radio(p);
> +	set_frequency(p, p->radio_data.fm_freq);
> +	pm_alsa_resume(p);
> +	return 0;
> +}
> +
> +static int poseidon_fm_open(struct file *filp)
> +{
> +	struct video_device *vfd = video_devdata(filp);
> +	struct poseidon *p = video_get_drvdata(vfd);
> +	int ret = 0;
> +
> +	if (!p)
> +		return -1;
> +
> +	mutex_lock(&p->lock);
> +	if (p->state & POSEIDON_STATE_DISCONNECT) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	if (p->state && !(p->state & POSEIDON_STATE_FM)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	usb_autopm_get_interface(p->interface);
> +	if (0 == p->state) {
> +		p->country_code = country_code;
> +		set_debug_mode(vfd, debug_mode);
> +
> +		ret = poseidon_check_mode_radio(p);
> +		if (ret < 0)
> +			goto out;
> +		p->state |= POSEIDON_STATE_FM;
> +	}
> +	p->radio_data.users++;
> +	kref_get(&p->kref);
> +	filp->private_data = p;
> +out:
> +	mutex_unlock(&p->lock);
> +	return ret;
> +}
> +
> +static int __poseidon_fm_close(struct file *filp)
> +{
> +	struct poseidon *p = filp->private_data;
> +	struct radio_data *fm = &p->radio_data;
> +	uint32_t status;
> +
> +	mutex_lock(&p->lock);
> +	fm->users--;
> +	if (0 == fm->users)
> +		p->state &= ~POSEIDON_STATE_FM;
> +
> +	if (fm->is_radio_streaming && filp == p->file_for_stream) {
> +		fm->is_radio_streaming = 0;
> +		send_set_req(p, PLAY_SERVICE, TLG_TUNE_PLAY_SVC_STOP, &status);
> +	}
> +	mutex_unlock(&p->lock);
> +
> +	kref_put(&p->kref, poseidon_delete);
> +	filp->private_data = NULL;
> +	return 0;
> +}
> +
> +static int poseidon_fm_close(struct file *filp)
> +{
> +	struct poseidon *p = filp->private_data;
> +
> +	__poseidon_fm_close(filp);
> +	usb_autopm_put_interface(p->interface);
> +	return 0;
> +}
> +
> +static int vidioc_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *v)
> +{
> +	strlcpy(v->driver, "radio-tele", sizeof(v->driver));
> +	strlcpy(v->card, "telegent Radio", sizeof(v->card));
> +	sprintf(v->bus_info, "USB");
> +	v->version = 0;
> +	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> +	return 0;
> +}

The same comments I made to the video part applies here: bus_info/version/capabilities are wrong.

Also, V4L2 spec says that you should be able to access the radio mode on any interface
(yes, you can use /dev/video0 to listen to radio).

Not all drivers implement it correctly, though.

> +
> +static long pd_radio_ioctls(struct file *file,
> +			unsigned int cmd, unsigned long arg)
> +{
> +	struct poseidon *p = file->private_data;
> +	unsigned long ret;
> +	int country_code;
> +
> +	if (in_hibernation(p))
> +		return -1;
> +
> +	if (cmd == PD_COUNTRY_CODE) {
> +		ret = copy_from_user(&country_code, (void __user *)arg,
> +					sizeof(country_code));
> +		if (0 == ret) {
> +			p->country_code = country_code;
> +			return 0;
> +		} else
> +			return -EAGAIN;
> +	}

Don't add a country_code. The FM range can be specified via V4L2 calls,
and I think we ended by adding a ctrl to set the pre-emphasis. Userspace
should set pre-emphasis/FM range based on a country code set it might have.

> +	return video_ioctl2(file, cmd, arg);
> +}
> +
> +static const struct v4l2_file_operations poseidon_fm_fops = {
> +	.owner         = THIS_MODULE,
> +	.open          = poseidon_fm_open,
> +	.release       = poseidon_fm_close,
> +	.ioctl	       = pd_radio_ioctls,
> +};
> +
> +int tlg_fm_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
> +{
> +	struct tuner_fm_sig_stat_s fm_stat = {};
> +	int ret, status, count = 5;
> +	struct poseidon *p = file->private_data;
> +
> +	if (vt->index != 0)
> +		return -EINVAL;
> +
> +	vt->type	= V4L2_TUNER_RADIO;
> +	vt->capability	= V4L2_TUNER_CAP_STEREO;
> +	vt->rangelow	= TUNER_FREQ_MIN_FM / 62500;
> +	vt->rangehigh	= TUNER_FREQ_MAX_FM / 62500;
> +	vt->rxsubchans	= V4L2_TUNER_SUB_STEREO;
> +	vt->audmode	= V4L2_TUNER_MODE_STEREO;
> +	vt->signal	= 0;
> +	vt->afc 	= 0;
> +
> +	mutex_lock(&p->lock);
> +	ret = send_get_req(p, TUNER_STATUS, TLG_MODE_FM_RADIO,
> +			      &fm_stat, &status, sizeof(fm_stat));
> +
> +	while (fm_stat.sig_lock_busy && count-- && !ret) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(HZ);
> +
> +		ret = send_get_req(p, TUNER_STATUS, TLG_MODE_FM_RADIO,
> +				  &fm_stat, &status, sizeof(fm_stat));
> +	}
> +	mutex_unlock(&p->lock);
> +
> +	if (ret || status) {
> +		vt->signal = 0;
> +	} else if ((fm_stat.sig_present || fm_stat.sig_locked)
> +			&& fm_stat.sig_strength == 0) {
> +		vt->signal = 0xffff;
> +	} else
> +		vt->signal = (fm_stat.sig_strength * 255 / 10) << 8;
> +
> +	return 0;
> +}
> +
> +int fm_get_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
> +{
> +	struct poseidon *p = file->private_data;
> +
> +	argp->frequency = p->radio_data.fm_freq;
> +	return 0;
> +}
> +
> +static int set_frequency(struct poseidon *p, __u32 frequency)
> +{
> +	__u32 freq ;
> +	int ret, status, radiomode;
> +
> +	mutex_lock(&p->lock);
> +
> +	radiomode = get_audio_std(TLG_MODE_FM_RADIO, p->country_code);
> +	/*NTSC 8,PAL 2 */
> +	ret = send_set_req(p, TUNER_AUD_ANA_STD, radiomode, &status);
> +
> +	freq =  (frequency * 125) * 500 / 1000;/* kHZ */
> +	if (freq < TUNER_FREQ_MIN_FM/1000 || freq > TUNER_FREQ_MAX_FM/1000) {
> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	ret = send_set_req(p, TUNE_FREQ_SELECT, freq, &status);
> +	if (ret < 0)
> +		goto error ;
> +	ret = send_set_req(p, TAKE_REQUEST, 0, &status);
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(HZ/4);
> +	if (!p->radio_data.is_radio_streaming) {
> +		ret = send_set_req(p, TAKE_REQUEST, 0, &status);
> +		ret = send_set_req(p, PLAY_SERVICE,
> +				TLG_TUNE_PLAY_SVC_START, &status);
> +		p->radio_data.is_radio_streaming = 1;
> +	}
> +	p->radio_data.fm_freq = frequency;
> +error:
> +	mutex_unlock(&p->lock);
> +	return ret;
> +}
> +
> +int fm_set_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
> +{
> +	struct poseidon *p = file->private_data;
> +
> +	p->file_for_stream  = file;
> +#ifdef CONFIG_PM
> +	p->inode = file->f_dentry->d_inode;
> +	p->pm_open = poseidon_fm_open;
> +	p->pm_suspend = pm_fm_suspend;
> +	p->pm_resume  = pm_fm_resume;
> +#endif
> +	return set_frequency(p, argp->frequency);
> +}
> +
> +int tlg_fm_vidioc_g_ctrl(struct file *file, void *priv,
> +		struct v4l2_control *arg)
> +{
> +    return 0;
> +}
> +
> +int tlg_fm_vidioc_exts_ctrl(struct file *file, void *fh,
> +		struct v4l2_ext_controls *a)
> +{
> +    return 0;
> +}
> +
> +int tlg_fm_vidioc_s_ctrl(struct file *file, void *priv,
> +		struct v4l2_control *arg)
> +{
> +    return 0;
> +}
> +
> +int tlg_fm_vidioc_queryctrl(struct file *file, void *priv,
> +		struct v4l2_queryctrl *arg)
> +{
> +	arg->minimum = 0;
> +	arg->maximum = 65535;
> +	return 0;
> +}
> +
> +static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
> +{
> +	return vt->index > 0 ? -EINVAL : 0;
> +}
> +static int vidioc_s_audio(struct file *file, void *priv, struct v4l2_audio *va)
> +{
> +	return (va->index != 0) ? -EINVAL : 0;
> +}
> +
> +static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
> +{
> +	a->index    = 0;
> +	a->mode    = 0;
> +	a->capability = V4L2_AUDCAP_STEREO;
> +	strcpy(a->name, "Radio");
> +	return 0;
> +}
> +
> +static int vidioc_s_input(struct file *filp, void *priv, u32 i)
> +{
> +	return (i != 0) ? -EINVAL : 0;
> +}
> +
> +static int vidioc_g_input(struct file *filp, void *priv, u32 *i)
> +{
> +	return (*i != 0) ? -EINVAL : 0;
> +}
> +
> +static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
> +	.vidioc_querycap    = vidioc_querycap,
> +	.vidioc_g_audio     = vidioc_g_audio,
> +	.vidioc_s_audio     = vidioc_s_audio,
> +	.vidioc_g_input     = vidioc_g_input,
> +	.vidioc_s_input     = vidioc_s_input,
> +	.vidioc_queryctrl   = tlg_fm_vidioc_queryctrl,
> +	.vidioc_g_ctrl      = tlg_fm_vidioc_g_ctrl,
> +	.vidioc_s_ctrl      = tlg_fm_vidioc_s_ctrl,
> +	.vidioc_s_ext_ctrls = tlg_fm_vidioc_exts_ctrl,
> +	.vidioc_s_tuner     = vidioc_s_tuner,
> +	.vidioc_g_tuner     = tlg_fm_vidioc_g_tuner,
> +	.vidioc_g_frequency = fm_get_freq,
> +	.vidioc_s_frequency = fm_set_freq,
> +};
> +
> +static struct video_device poseidon_fm_template = {
> +	.name       = "telegent-FM",
> +	.fops       = &poseidon_fm_fops,
> +	.minor      = -1,
> +	.release    = video_device_release,
> +	.ioctl_ops  = &poseidon_fm_ioctl_ops,
> +};
> +
> +int poseidon_fm_init(struct poseidon *p)
> +{
> +	struct video_device *fm_dev;
> +
> +	fm_dev = vdev_init(p, &poseidon_fm_template);
> +	if (fm_dev == NULL)
> +		return -1;
> +
> +	if (video_register_device(fm_dev, VFL_TYPE_RADIO, -1) < 0) {
> +		video_device_release(fm_dev);
> +		return -1;
> +	}
> +	p->radio_data.fm_dev = fm_dev;
> +	return 0;
> +}
> +
> +int poseidon_fm_exit(struct poseidon *p)
> +{
> +	if (p->radio_data.fm_dev) {
> +		video_unregister_device(p->radio_data.fm_dev);
> +		p->radio_data.fm_dev = NULL;
> +	}
> +	return 0;
> +}

