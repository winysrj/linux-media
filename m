Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:35657 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751172AbeEVLzE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 07:55:04 -0400
Subject: Re: [PATCH v10 08/16] v4l: mark unordered formats
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
 <20180521165946.11778-9-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2df0ec97-9e0f-8fc3-1481-ac0a72e52e4d@xs4all.nl>
Date: Tue, 22 May 2018 13:55:01 +0200
MIME-Version: 1.0
In-Reply-To: <20180521165946.11778-9-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/05/18 18:59, Ezequiel Garcia wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Now that we've introduced the V4L2_FMT_FLAG_UNORDERED flag,
> mark the appropriate formats.
> 
> v2: Set unordered flag before calling the driver callback.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 74 +++++++++++++++++++++++++++---------
>  1 file changed, 57 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index f48c505550e0..2135ac235a96 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1102,6 +1102,27 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
>  	return ops->vidioc_enum_output(file, fh, p);
>  }
>  
> +static void v4l_fill_unordered_fmtdesc(struct v4l2_fmtdesc *fmt)
> +{
> +	switch (fmt->pixelformat) {
> +	case V4L2_PIX_FMT_MPEG:
> +	case V4L2_PIX_FMT_H264:
> +	case V4L2_PIX_FMT_H264_NO_SC:
> +	case V4L2_PIX_FMT_H264_MVC:
> +	case V4L2_PIX_FMT_H263:
> +	case V4L2_PIX_FMT_MPEG1:
> +	case V4L2_PIX_FMT_MPEG2:
> +	case V4L2_PIX_FMT_MPEG4:
> +	case V4L2_PIX_FMT_XVID:
> +	case V4L2_PIX_FMT_VC1_ANNEX_G:
> +	case V4L2_PIX_FMT_VC1_ANNEX_L:
> +	case V4L2_PIX_FMT_VP8:
> +	case V4L2_PIX_FMT_VP9:
> +	case V4L2_PIX_FMT_HEVC:
> +		fmt->flags |= V4L2_FMT_FLAG_UNORDERED;

Please add a break here. This prevents potential future errors if new cases
are added below this line.

> +	}
> +}
> +
>  static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  {
>  	const unsigned sz = sizeof(fmt->description);
> @@ -1310,61 +1331,80 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  
>  	if (descr)
>  		WARN_ON(strlcpy(fmt->description, descr, sz) >= sz);
> -	fmt->flags = flags;
> +	fmt->flags |= flags;
>  }
>  
> -static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
> -				struct file *file, void *fh, void *arg)
> -{
> -	struct v4l2_fmtdesc *p = arg;
> -	int ret = check_fmt(file, p->type);
>  
> -	if (ret)
> -		return ret;
> -	ret = -EINVAL;
> +static int __vidioc_enum_fmt(const struct v4l2_ioctl_ops *ops,
> +			     struct v4l2_fmtdesc *p,
> +			     struct file *file, void *fh)
> +{
> +	int ret = 0;
>  
>  	switch (p->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  		if (unlikely(!ops->vidioc_enum_fmt_vid_cap))
>  			break;
> -		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, p);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  		if (unlikely(!ops->vidioc_enum_fmt_vid_cap_mplane))
>  			break;
> -		ret = ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, p);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  		if (unlikely(!ops->vidioc_enum_fmt_vid_overlay))
>  			break;
> -		ret = ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_vid_overlay(file, fh, p);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>  		if (unlikely(!ops->vidioc_enum_fmt_vid_out))
>  			break;
> -		ret = ops->vidioc_enum_fmt_vid_out(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_vid_out(file, fh, p);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>  		if (unlikely(!ops->vidioc_enum_fmt_vid_out_mplane))
>  			break;
> -		ret = ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_vid_out_mplane(file, fh, p);
>  		break;
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
>  		if (unlikely(!ops->vidioc_enum_fmt_sdr_cap))
>  			break;
> -		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, p);
>  		break;
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		if (unlikely(!ops->vidioc_enum_fmt_sdr_out))
>  			break;
> -		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, p);
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
>  		if (unlikely(!ops->vidioc_enum_fmt_meta_cap))
>  			break;
> -		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
> +		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, p);
>  		break;
>  	}
> +	return ret;
> +}
> +
> +static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
> +				struct file *file, void *fh, void *arg)
> +{
> +	struct v4l2_fmtdesc *p = arg;
> +	int ret = check_fmt(file, p->type);
> +
> +	if (ret)
> +		return ret;
> +	ret = -EINVAL;

Why set ret when it is overwritten below?

> +
> +	ret = __vidioc_enum_fmt(ops, p, file, fh);
> +	if (ret)
> +		return ret;

Huh? Why call the driver twice? As far as I can see you can just drop
these three lines above.

Regards,

	Hans

> +	/*
> +	 * Set the unordered flag and call the driver
> +	 * again so it has the chance to clear the flag.
> +	 */
> +	v4l_fill_unordered_fmtdesc(p);
> +	ret = __vidioc_enum_fmt(ops, p, file, fh);
>  	if (ret == 0)
>  		v4l_fill_fmtdesc(p);
>  	return ret;
> 
