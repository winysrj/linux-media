Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:36962 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752843AbeBEOyd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 09:54:33 -0500
Subject: Re: [PATCH 4/5] add V4L2 control functions
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
 <1517840981-12280-5-git-send-email-floe@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4835be2b-238c-bb27-e9e5-98642ae76733@xs4all.nl>
Date: Mon, 5 Feb 2018 15:54:27 +0100
MIME-Version: 1.0
In-Reply-To: <1517840981-12280-5-git-send-email-floe@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 03:29 PM, Florian Echtler wrote:
> Signed-off-by: Florian Echtler <floe@butterbrot.org>
> ---
>  drivers/input/touchscreen/sur40.c | 114 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index 63c7264b..c4b7cf1 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -953,6 +953,119 @@ static int sur40_vidioc_g_fmt(struct file *file, void *priv,
>  	return 0;
>  }
>  
> +
> +static int sur40_vidioc_queryctrl(struct file *file, void *fh,
> +			       struct v4l2_queryctrl *qc)
> +{
> +
> +	switch (qc->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		qc->flags = 0;
> +		sprintf(qc->name, "Brightness");
> +		qc->type = V4L2_CTRL_TYPE_INTEGER;
> +		qc->minimum = SUR40_BRIGHTNESS_MIN;
> +		qc->default_value = SUR40_BRIGHTNESS_DEF;
> +		qc->maximum = SUR40_BRIGHTNESS_MAX;
> +		qc->step = 8;
> +		return 0;
> +	case V4L2_CID_CONTRAST:
> +		qc->flags = 0;
> +		sprintf(qc->name, "Contrast");
> +		qc->type = V4L2_CTRL_TYPE_INTEGER;
> +		qc->minimum = SUR40_CONTRAST_MIN;
> +		qc->default_value = SUR40_CONTRAST_DEF;
> +		qc->maximum = SUR40_CONTRAST_MAX;
> +		qc->step = 1;
> +		return 0;
> +	case V4L2_CID_GAIN:
> +		qc->flags = 0;
> +		sprintf(qc->name, "Gain");
> +		qc->type = V4L2_CTRL_TYPE_INTEGER;
> +		qc->minimum = SUR40_GAIN_MIN;
> +		qc->default_value = SUR40_GAIN_DEF;
> +		qc->maximum = SUR40_GAIN_MAX;
> +		qc->step = 1;
> +		return 0;
> +	case V4L2_CID_BACKLIGHT_COMPENSATION:
> +		qc->flags = 0;
> +		sprintf(qc->name, "Preprocessor");
> +		qc->type = V4L2_CTRL_TYPE_INTEGER;
> +		qc->minimum = SUR40_BACKLIGHT_MIN;
> +		qc->default_value = SUR40_BACKLIGHT_DEF;
> +		qc->maximum = SUR40_BACKLIGHT_MAX;
> +		qc->step = 1;
> +		return 0;
> +	default:
> +		qc->flags = V4L2_CTRL_FLAG_DISABLED;
> +		return -EINVAL;
> +	}
> +}
> +
> +static int sur40_vidioc_g_ctrl(struct file *file, void *fh,
> +			    struct v4l2_control *ctrl)
> +{
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		ctrl->value = sur40_v4l2_brightness;
> +		return 0;
> +	case V4L2_CID_CONTRAST:
> +		ctrl->value = sur40_v4l2_contrast;
> +		return 0;
> +	case V4L2_CID_GAIN:
> +		ctrl->value = sur40_v4l2_gain;
> +		return 0;
> +	case V4L2_CID_BACKLIGHT_COMPENSATION:
> +		ctrl->value = sur40_v4l2_backlight;
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int sur40_vidioc_s_ctrl(struct file *file, void *fh,
> +			    struct v4l2_control *ctrl)
> +{
> +	u8 value = 0;
> +	struct sur40_state *sur40 = video_drvdata(file);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		sur40_v4l2_brightness = ctrl->value;
> +		if (sur40_v4l2_brightness < SUR40_BRIGHTNESS_MIN)
> +			sur40_v4l2_brightness = SUR40_BRIGHTNESS_MIN;
> +		else if (sur40_v4l2_brightness > SUR40_BRIGHTNESS_MAX)
> +			sur40_v4l2_brightness = SUR40_BRIGHTNESS_MAX;
> +		sur40_set_irlevel(sur40, sur40_v4l2_brightness);
> +		return 0;
> +	case V4L2_CID_CONTRAST:
> +		sur40_v4l2_contrast = ctrl->value;
> +		if (sur40_v4l2_contrast < SUR40_CONTRAST_MIN)
> +			sur40_v4l2_contrast = SUR40_CONTRAST_MIN;
> +		else if (sur40_v4l2_contrast > SUR40_CONTRAST_MAX)
> +			sur40_v4l2_contrast = SUR40_CONTRAST_MAX;
> +		value = (sur40_v4l2_contrast << 4) + sur40_v4l2_gain;
> +		sur40_set_vsvideo(sur40, value);
> +		return 0;
> +	case V4L2_CID_GAIN:
> +		sur40_v4l2_gain = ctrl->value;
> +		if (sur40_v4l2_gain < SUR40_GAIN_MIN)
> +			sur40_v4l2_gain = SUR40_GAIN_MIN;
> +		else if (sur40_v4l2_gain > SUR40_GAIN_MAX)
> +			sur40_v4l2_gain = SUR40_GAIN_MAX;
> +		value = (sur40_v4l2_contrast << 4) + sur40_v4l2_gain;
> +		sur40_set_vsvideo(sur40, value);
> +		return 0;
> +	case V4L2_CID_BACKLIGHT_COMPENSATION:
> +		sur40_v4l2_backlight = ctrl->value;
> +		sur40_set_preprocessor(sur40, sur40_v4l2_backlight);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +
>  static int sur40_ioctl_parm(struct file *file, void *priv,
>  			    struct v4l2_streamparm *p)
>  {
> @@ -1071,6 +1181,10 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
>  	.vidioc_g_input		= sur40_vidioc_g_input,
>  	.vidioc_s_input		= sur40_vidioc_s_input,
>  
> +	.vidioc_queryctrl	= sur40_vidioc_queryctrl,
> +	.vidioc_g_ctrl		= sur40_vidioc_g_ctrl,
> +	.vidioc_s_ctrl		= sur40_vidioc_s_ctrl,
> +
>  	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
>  	.vidioc_create_bufs	= vb2_ioctl_create_bufs,
>  	.vidioc_querybuf	= vb2_ioctl_querybuf,
> 

Sorry, but this is very wrong. Use the control framework instead. See
https://hverkuil.home.xs4all.nl/spec/kapi/v4l2-controls.html and pretty much all
media drivers (with the exception of uvc). See for example this driver:
drivers/media/pci/tw68/tw68-video.c (randomly chosen).

It actually makes life a lot easier for you as you don't have to perform any
range checks and all control ioctls are automatically supported for you.

Regards,

	Hans
