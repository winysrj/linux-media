Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2E0R7G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 13:59:06 -0400
Message-ID: <4FC26B6F.6010401@redhat.com>
Date: Sun, 27 May 2012 19:59:11 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 3/5] S_HW_FREQ_SEEK: set capability flags and return
 ENODATA instead of EAGAIN.
References: <1338119425-17274-1-git-send-email-hverkuil@xs4all.nl> <99eeb0aa2d5cee617d456ff85925a329d9553153.1338118975.git.hans.verkuil@cisco.com>
In-Reply-To: <99eeb0aa2d5cee617d456ff85925a329d9553153.1338118975.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good:

Acked-by: Hans de Goede <hdegoede@redhat.com>



On 05/27/2012 01:50 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Set the new capability flags in G_TUNER and return ENODATA if no channels
> were found.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/radio/radio-mr800.c                |    5 +++--
>   drivers/media/radio/radio-wl1273.c               |    3 ++-
>   drivers/media/radio/si470x/radio-si470x-common.c |    6 ++++--
>   drivers/media/radio/wl128x/fmdrv_rx.c            |    2 +-
>   drivers/media/radio/wl128x/fmdrv_v4l2.c          |    4 +++-
>   sound/i2c/other/tea575x-tuner.c                  |    4 +++-
>   6 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
> index 94cb6bc..3182b26 100644
> --- a/drivers/media/radio/radio-mr800.c
> +++ b/drivers/media/radio/radio-mr800.c
> @@ -295,7 +295,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>   	v->type = V4L2_TUNER_RADIO;
>   	v->rangelow = FREQ_MIN * FREQ_MUL;
>   	v->rangehigh = FREQ_MAX * FREQ_MUL;
> -	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
> +	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
> +		V4L2_TUNER_CAP_HWSEEK_WRAP;
>   	v->rxsubchans = is_stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
>   	v->audmode = radio->stereo ?
>   		V4L2_TUNER_MODE_STEREO : V4L2_TUNER_MODE_MONO;
> @@ -372,7 +373,7 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *priv,
>   	timeout = jiffies + msecs_to_jiffies(30000);
>   	for (;;) {
>   		if (time_after(jiffies, timeout)) {
> -			retval = -EAGAIN;
> +			retval = -ENODATA;
>   			break;
>   		}
>   		if (schedule_timeout_interruptible(msecs_to_jiffies(10))) {
> diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
> index f1b6070..e8428f5 100644
> --- a/drivers/media/radio/radio-wl1273.c
> +++ b/drivers/media/radio/radio-wl1273.c
> @@ -1514,7 +1514,8 @@ static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
>   	tuner->rangehigh = WL1273_FREQ(WL1273_BAND_OTHER_HIGH);
>
>   	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS |
> -		V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS_BLOCK_IO;
> +		V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS_BLOCK_IO |
> +		V4L2_TUNER_CAP_HWSEEK_BOUNDED | V4L2_TUNER_CAP_HWSEEK_WRAP;
>
>   	if (radio->stereo)
>   		tuner->audmode = V4L2_TUNER_MODE_STEREO;
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
> index 969cf49..d485b79 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -363,7 +363,7 @@ stop:
>
>   	/* try again, if timed out */
>   	if (retval == 0&&  timed_out)
> -		return -EAGAIN;
> +		return -ENODATA;
>   	return retval;
>   }
>
> @@ -596,7 +596,9 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
>   	strcpy(tuner->name, "FM");
>   	tuner->type = V4L2_TUNER_RADIO;
>   	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
> -			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO;
> +			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO |
> +			    V4L2_TUNER_CAP_HWSEEK_BOUNDED |
> +			    V4L2_TUNER_CAP_HWSEEK_WRAP;
>
>   	/* range limits */
>   	switch ((radio->registers[SYSCONFIG2]&  SYSCONFIG2_BAND)>>  6) {
> diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
> index 43fb722..3dd9fc0 100644
> --- a/drivers/media/radio/wl128x/fmdrv_rx.c
> +++ b/drivers/media/radio/wl128x/fmdrv_rx.c
> @@ -251,7 +251,7 @@ again:
>   	if (!timeleft) {
>   		fmerr("Timeout(%d sec),didn't get tune ended int\n",
>   			   jiffies_to_msecs(FM_DRV_RX_SEEK_TIMEOUT) / 1000);
> -		return -ETIMEDOUT;
> +		return -ENODATA;
>   	}
>
>   	int_reason = fmdev->irq_info.flag&  (FM_TUNE_COMPLETE | FM_BAND_LIMIT);
> diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
> index 080b96a..49a11ec 100644
> --- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
> +++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
> @@ -285,7 +285,9 @@ static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
>   	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO |
>   	((fmdev->rx.rds.flag == FM_RDS_ENABLE) ? V4L2_TUNER_SUB_RDS : 0);
>   	tuner->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
> -			    V4L2_TUNER_CAP_LOW;
> +			    V4L2_TUNER_CAP_LOW |
> +			    V4L2_TUNER_CAP_HWSEEK_BOUNDED |
> +			    V4L2_TUNER_CAP_HWSEEK_WRAP;
>   	tuner->audmode = (stereo_mono_mode ?
>   			  V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO);
>
> diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
> index 582aace..ba2bc51 100644
> --- a/sound/i2c/other/tea575x-tuner.c
> +++ b/sound/i2c/other/tea575x-tuner.c
> @@ -191,6 +191,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>   	strcpy(v->name, "FM");
>   	v->type = V4L2_TUNER_RADIO;
>   	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
> +	if (!tea->cannot_read_data)
> +		v->capability |= V4L2_TUNER_CAP_HWSEEK_BOUNDED;
>   	v->rangelow = FREQ_LO;
>   	v->rangehigh = FREQ_HI;
>   	v->rxsubchans = tea->stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
> @@ -299,7 +301,7 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
>   	}
>   	tea->val&= ~TEA575X_BIT_SEARCH;
>   	snd_tea575x_set_freq(tea);
> -	return -EAGAIN;
> +	return -ENODATA;
>   }
>
>   static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
