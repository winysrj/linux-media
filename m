Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35131 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758822Ab0JWTml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 15:42:41 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "mats.randgaard@tandberg.com" <mats.randgaard@tandberg.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hans.verkuil@tandberg.com" <hans.verkuil@tandberg.com>
Date: Sun, 24 Oct 2010 01:10:01 +0530
Subject: RE: [RFC/PATCH 3/5] vpif_cap/disp: Added support for DV presets
Message-ID: <19F8576C6E063C45BE387C64729E739404AA631350@dbde02.ent.ti.com>
References: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
 <1287730851-18579-4-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1287730851-18579-4-git-send-email-mats.randgaard@tandberg.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: mats.randgaard@tandberg.com [mailto:mats.randgaard@tandberg.com]
> Sent: Friday, October 22, 2010 12:31 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; hans.verkuil@tandberg.com; Mats Randgaard
> Subject: [RFC/PATCH 3/5] vpif_cap/disp: Added support for DV presets
> 
> From: Mats Randgaard <mats.randgaard@tandberg.com>
> 
> Added functions to set/get/query/enum DV presets.
> 
> Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@tandberg.com>
> ---
>  drivers/media/video/davinci/vpif_capture.c |  143
> +++++++++++++++++++++++++++-
>  drivers/media/video/davinci/vpif_capture.h |    1 +
>  drivers/media/video/davinci/vpif_display.c |  119 ++++++++++++++++++++++-
>  drivers/media/video/davinci/vpif_display.h |    1 +
>  4 files changed, 255 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpif_capture.c
> b/drivers/media/video/davinci/vpif_capture.c
> index 778af7e..bf1adea 100644
> --- a/drivers/media/video/davinci/vpif_capture.c
> +++ b/drivers/media/video/davinci/vpif_capture.c
> @@ -432,9 +432,18 @@ static int vpif_update_std_info(struct channel_obj
> *ch)
> 
>  	for (index = 0; index < vpif_ch_params_count; index++) {
>  		config = &ch_params[index];
> -		if (config->stdid & vid_ch->stdid) {
> -			memcpy(std_info, config, sizeof(*config));
> -			break;
> +		if (config->hd_sd == 0) {
> +			vpif_dbg(2, debug, "SD format\n");
> +			if (config->stdid & vid_ch->stdid) {
> +				memcpy(std_info, config, sizeof(*config));
> +				break;
> +			}
> +		} else {
> +			vpif_dbg(2, debug, "HD format\n");
> +			if (config->dv_preset == vid_ch->dv_preset) {
> +				memcpy(std_info, config, sizeof(*config));
> +				break;
> +			}
>  		}
>  	}
> 
> @@ -1442,6 +1451,7 @@ static int vpif_s_std(struct file *file, void *priv,
> v4l2_std_id *std_id)
>  		return -ERESTARTSYS;
> 
>  	ch->video.stdid = *std_id;
> +	ch->video.dv_preset = V4L2_DV_INVALID;
> 
>  	/* Get the information about the standard */
>  	if (vpif_update_std_info(ch)) {
> @@ -1794,6 +1804,129 @@ static int vpif_cropcap(struct file *file, void
> *priv,
>  	return 0;
>  }
> 
> +/**
> + * vpif_enum_dv_presets() - ENUM_DV_PRESETS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @preset: input preset
> + */
> +static int vpif_enum_dv_presets(struct file *file, void *priv,
> +		struct v4l2_dv_enum_preset *preset)
> +{
> +	struct vpif_fh *fh = priv;
> +	struct channel_obj *ch = fh->channel;
> +
> +	if (!vpif_obj.sd) {
> +		vpif_dbg(2, debug, "No sub devices registered\n");
> +
> +		if (preset->index >= vpif_ch_params_count)
> +			return -EINVAL;
> +
> +		/* dv-presets only */
> +		if (ch_params[preset->index].hd_sd == 0)
> +			return -EINVAL;
> +
> +		return v4l_fill_dv_preset_info(
> +				ch_params[preset->index].dv_preset, preset);
> +	}
> +
[Hiremath, Vaibhav] I believe to completely work in non-subdev mode of operation you might have to change some existing API's as well right? So I think we should break this patch into two separate patches, 

vpif_cap/disp: Added support for DV presets
and
vpif_cap/disp: Add support for non-subdev mode

Rest looks ok to me.

Thanks,
Vaibhav


> +	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
> +			video, enum_dv_presets, preset);
> +}
> +
> +/**
> + * vpif_query_dv_presets() - QUERY_DV_PRESET handler
> + * @file: file ptr
> + * @priv: file handle
> + * @preset: input preset
> + */
> +static int vpif_query_dv_preset(struct file *file, void *priv,
> +		struct v4l2_dv_preset *preset)
> +{
> +	struct vpif_fh *fh = priv;
> +	struct channel_obj *ch = fh->channel;
> +
> +	if (!vpif_obj.sd) {
> +		vpif_dbg(2, debug, "No sub devices registered\n");
> +		return -EINVAL;
> +	}
> +
> +	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
> +		       video, query_dv_preset, preset);
> +}
> +/**
> + * vpif_s_dv_presets() - S_DV_PRESETS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @preset: input preset
> + */
> +static int vpif_s_dv_preset(struct file *file, void *priv,
> +		struct v4l2_dv_preset *preset)
> +{
> +	struct vpif_fh *fh = priv;
> +	struct channel_obj *ch = fh->channel;
> +	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> +	int ret = 0;
> +
> +	if (common->started) {
> +		vpif_err("streaming in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
> +	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
> +		if (!fh->initialized) {
> +			vpif_dbg(1, debug, "Channel Busy\n");
> +			return -EBUSY;
> +		}
> +	}
> +
> +	ret = v4l2_prio_check(&ch->prio, fh->prio);
> +	if (ret)
> +		return ret;
> +
> +	fh->initialized = 1;
> +
> +	/* Call encoder subdevice function to set the standard */
> +	if (mutex_lock_interruptible(&common->lock))
> +		return -ERESTARTSYS;
> +
> +	ch->video.dv_preset = preset->preset;
> +	ch->video.stdid = V4L2_STD_UNKNOWN;
> +
> +	/* Get the information about the standard */
> +	if (vpif_update_std_info(ch)) {
> +		ret = -EINVAL;
> +		vpif_err("Error getting the standard info\n");
> +	} else {
> +		/* Configure the default format information */
> +		vpif_config_format(ch);
> +
> +	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
> +			video, s_dv_preset, preset);
> +	}
> +
> +	mutex_unlock(&common->lock);
> +
> +	return ret;
> +}
> +/**
> + * vpif_g_dv_presets() - G_DV_PRESETS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @preset: input preset
> + */
> +static int vpif_g_dv_preset(struct file *file, void *priv,
> +		struct v4l2_dv_preset *preset)
> +{
> +	struct vpif_fh *fh = priv;
> +	struct channel_obj *ch = fh->channel;
> +
> +	preset->preset = ch->video.dv_preset;
> +
> +	return 0;
> +}
> +
>  /*
>   * vpif_g_chip_ident() - Identify the chip
>   * @file: file ptr
> @@ -1896,6 +2029,10 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops =
> {
>  	.vidioc_streamon        	= vpif_streamon,
>  	.vidioc_streamoff       	= vpif_streamoff,
>  	.vidioc_cropcap         	= vpif_cropcap,
> +	.vidioc_enum_dv_presets         = vpif_enum_dv_presets,
> +	.vidioc_s_dv_preset             = vpif_s_dv_preset,
> +	.vidioc_g_dv_preset             = vpif_g_dv_preset,
> +	.vidioc_query_dv_preset         = vpif_query_dv_preset,
>  	.vidioc_g_chip_ident		= vpif_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.vidioc_g_register		= vpif_dbg_g_register,
> diff --git a/drivers/media/video/davinci/vpif_capture.h
> b/drivers/media/video/davinci/vpif_capture.h
> index 4e12ec8..3452a8a 100644
> --- a/drivers/media/video/davinci/vpif_capture.h
> +++ b/drivers/media/video/davinci/vpif_capture.h
> @@ -59,6 +59,7 @@ struct video_obj {
>  	enum v4l2_field buf_field;
>  	/* Currently selected or default standard */
>  	v4l2_std_id stdid;
> +	u32 dv_preset;
>  	/* This is to track the last input that is passed to application */
>  	u32 input_idx;
>  };
> diff --git a/drivers/media/video/davinci/vpif_display.c
> b/drivers/media/video/davinci/vpif_display.c
> index edfc095..4554971 100644
> --- a/drivers/media/video/davinci/vpif_display.c
> +++ b/drivers/media/video/davinci/vpif_display.c
> @@ -373,15 +373,23 @@ static int vpif_get_std_info(struct channel_obj *ch)
> 
>  	int index;
> 
> -	std_info->stdid = vid_ch->stdid;
> -	if (!std_info->stdid)
> -		return -1;
> +	if (!vid_ch->stdid && !vid_ch->dv_preset)
> +		return -EINVAL;
> 
>  	for (index = 0; index < vpif_ch_params_count; index++) {
>  		config = &ch_params[index];
> -		if (config->stdid & std_info->stdid) {
> -			memcpy(std_info, config, sizeof(*config));
> -			break;
> +		if (config->hd_sd == 0) {
> +			vpif_dbg(2, debug, "SD format\n");
> +			if (config->stdid & vid_ch->stdid) {
> +				memcpy(std_info, config, sizeof(*config));
> +				break;
> +			}
> +		} else {
> +			vpif_dbg(2, debug, "HD format\n");
> +			if (config->dv_preset == vid_ch->dv_preset) {
> +				memcpy(std_info, config, sizeof(*config));
> +				break;
> +			}
>  		}
>  	}
> 
> @@ -1305,6 +1313,102 @@ static int vpif_s_priority(struct file *file, void
> *priv, enum v4l2_priority p)
>  	return v4l2_prio_change(&ch->prio, &fh->prio, p);
>  }
> 
> +/**
> + * vpif_enum_dv_presets() - ENUM_DV_PRESETS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @preset: input preset
> + */
> +static int vpif_enum_dv_presets(struct file *file, void *priv,
> +		struct v4l2_dv_enum_preset *preset)
> +{
> +	struct vpif_fh *fh = priv;
> +	struct channel_obj *ch = fh->channel;
> +	struct video_obj *vid_ch = &ch->video;
> +
> +	if (!vpif_obj.sd) {
> +		vpif_dbg(2, debug, "No sub devices registered\n");
> +
> +		if (preset->index >= vpif_ch_params_count)
> +			return -EINVAL;
> +
> +		/* dv-presets only */
> +		if (ch_params[preset->index].hd_sd == 0)
> +			return -EINVAL;
> +
> +		return v4l_fill_dv_preset_info(
> +				ch_params[preset->index].dv_preset, preset);
> +	}
> +
> +	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
> +			video, enum_dv_presets, preset);
> +}
> +
> +/**
> + * vpif_s_dv_presets() - S_DV_PRESETS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @preset: input preset
> + */
> +static int vpif_s_dv_preset(struct file *file, void *priv,
> +		struct v4l2_dv_preset *preset)
> +{
> +	struct vpif_fh *fh = priv;
> +	struct channel_obj *ch = fh->channel;
> +	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> +	struct video_obj *vid_ch = &ch->video;
> +	int ret = 0;
> +
> +	if (common->started) {
> +		vpif_err("streaming in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	ret = v4l2_prio_check(&ch->prio, fh->prio);
> +	if (ret != 0)
> +		return ret;
> +
> +	fh->initialized = 1;
> +
> +	/* Call encoder subdevice function to set the standard */
> +	if (mutex_lock_interruptible(&common->lock))
> +		return -ERESTARTSYS;
> +
> +	ch->video.dv_preset = preset->preset;
> +	ch->video.stdid = V4L2_STD_UNKNOWN;
> +
> +	/* Get the information about the standard */
> +	if (vpif_get_std_info(ch)) {
> +		ret = -EINVAL;
> +		vpif_err("Error getting the standard info\n");
> +	} else {
> +		/* Configure the default format information */
> +		vpif_config_format(ch);
> +
> +		ret = v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
> +				video, s_dv_preset, preset);
> +	}
> +
> +	mutex_unlock(&common->lock);
> +
> +	return ret;
> +}
> +/**
> + * vpif_g_dv_presets() - G_DV_PRESETS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @preset: input preset
> + */
> +static int vpif_g_dv_preset(struct file *file, void *priv,
> +		struct v4l2_dv_preset *preset)
> +{
> +	struct vpif_fh *fh = priv;
> +	struct channel_obj *ch = fh->channel;
> +
> +	preset->preset = ch->video.dv_preset;
> +
> +	return 0;
> +}
> 
>  /*
>   * vpif_g_chip_ident() - Identify the chip
> @@ -1410,6 +1514,9 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops =
> {
>  	.vidioc_s_output		= vpif_s_output,
>  	.vidioc_g_output		= vpif_g_output,
>  	.vidioc_cropcap         	= vpif_cropcap,
> +	.vidioc_enum_dv_presets         = vpif_enum_dv_presets,
> +	.vidioc_s_dv_preset             = vpif_s_dv_preset,
> +	.vidioc_g_dv_preset             = vpif_g_dv_preset,
>  	.vidioc_g_chip_ident		= vpif_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.vidioc_g_register		= vpif_dbg_g_register,
> diff --git a/drivers/media/video/davinci/vpif_display.h
> b/drivers/media/video/davinci/vpif_display.h
> index a2a7cd1..3d56b3e 100644
> --- a/drivers/media/video/davinci/vpif_display.h
> +++ b/drivers/media/video/davinci/vpif_display.h
> @@ -67,6 +67,7 @@ struct video_obj {
>  					 * most recent displayed frame only */
>  	v4l2_std_id stdid;		/* Currently selected or default
>  					 * standard */
> +	u32 dv_preset;
>  	u32 output_id;			/* Current output id */
>  };
> 
> --
> 1.7.1

