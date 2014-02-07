Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:19363 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBGOD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 09:03:59 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N0M00F8CPQMZ680@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Feb 2014 09:03:58 -0500 (EST)
Date: Fri, 07 Feb 2014 12:03:53 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 23/52] v4l: add new tuner types for SDR
Message-id: <20140207120353.26d71842@samsung.com>
In-reply-to: <1390669846-8131-24-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
 <1390669846-8131-24-git-send-email-crope@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Jan 2014 19:10:17 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Define tuner types V4L2_TUNER_ADC and V4L2_TUNER_RF for SDR usage.
> 
> ADC is used for setting sampling rate (sampling frequency) to SDR
> device.
> 
> Another tuner type, named as V4L2_TUNER_RF, is possible RF tuner.
> Is is used to down-convert RF frequency to range ADC could sample.
> Having RF tuner is optional, whilst in practice it is almost always
> there.
> 
> Also add checks to VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY and
> VIDIOC_ENUM_FREQ_BANDS only allow these two tuner types when device
> type is SDR (VFL_TYPE_SDR). For VIDIOC_G_FREQUENCY we do not check
> tuner type, instead override type with V4L2_TUNER_ADC in every
> case (requested by Hans in order to keep functionality in line with
> existing tuners and existing API does not specify it).
> 
> Prohibit VIDIOC_S_HW_FREQ_SEEK explicitly when device type is SDR,
> as device cannot do hardware seek without a hardware demodulator.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 39 ++++++++++++++++++++++++++----------
>  include/uapi/linux/videodev2.h       |  2 ++
>  2 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 707aef7..15ab349 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1291,8 +1291,11 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
>  	struct video_device *vfd = video_devdata(file);
>  	struct v4l2_frequency *p = arg;
>  
> -	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> -			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> +	if (vfd->vfl_type == VFL_TYPE_SDR)
> +		p->type = V4L2_TUNER_ADC;
> +	else
> +		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> +				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  	return ops->vidioc_g_frequency(file, fh, p);
>  }
>  
> @@ -1303,10 +1306,15 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
>  	const struct v4l2_frequency *p = arg;
>  	enum v4l2_tuner_type type;
>  
> -	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> -			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> -	if (p->type != type)
> -		return -EINVAL;
> +	if (vfd->vfl_type == VFL_TYPE_SDR) {
> +		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
> +			return -EINVAL;
> +	} else {
> +		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> +				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> +		if (type != p->type)
> +			return -EINVAL;
> +	}
>  	return ops->vidioc_s_frequency(file, fh, p);
>  }
>  
> @@ -1386,6 +1394,10 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_hw_freq_seek *p = arg;
>  	enum v4l2_tuner_type type;
>  
> +	/* s_hw_freq_seek is not supported for SDR for now */
> +	if (vfd->vfl_type == VFL_TYPE_SDR)
> +		return -EINVAL;

A minor issue: return code here is IMHO wrong. It should be -ENOTTY.

It makes sense to add a printk_once() to warn about it, as, if we ever
need it for SDR, people could lose hours debugging why this is not work
until finally discovering that the Kernel is blocking such call.

In any case, I'll apply this patch. Please send a fix on a next series.

> +
>  	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>  		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  	if (p->type != type)
> @@ -1885,11 +1897,16 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
>  	enum v4l2_tuner_type type;
>  	int err;
>  
> -	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> -			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> -
> -	if (type != p->type)
> -		return -EINVAL;
> +	if (vfd->vfl_type == VFL_TYPE_SDR) {
> +		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
> +			return -EINVAL;
> +		type = p->type;
> +	} else {
> +		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> +				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> +		if (type != p->type)
> +			return -EINVAL;
> +	}
>  	if (ops->vidioc_enum_freq_bands)
>  		return ops->vidioc_enum_freq_bands(file, fh, p);
>  	if (is_valid_ioctl(vfd, VIDIOC_G_TUNER)) {
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 6ae7bbe..9dc79d1 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -159,6 +159,8 @@ enum v4l2_tuner_type {
>  	V4L2_TUNER_RADIO	     = 1,
>  	V4L2_TUNER_ANALOG_TV	     = 2,
>  	V4L2_TUNER_DIGITAL_TV	     = 3,
> +	V4L2_TUNER_ADC               = 4,
> +	V4L2_TUNER_RF                = 5,
>  };
>  
>  enum v4l2_memory {


-- 

Cheers,
Mauro
