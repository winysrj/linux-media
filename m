Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34253 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaGUKwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 06:52:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv4 for v3.17] v4l2-ioctl: don't set PRIV_MAGIC unconditionally in g_fmt()
Date: Mon, 21 Jul 2014 12:52:37 +0200
Message-ID: <6634144.okXzqVkmdj@avalon>
In-Reply-To: <53CCF07F.1050100@xs4all.nl>
References: <53CCF07F.1050100@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 21 July 2014 12:50:39 Hans Verkuil wrote:
> Regression fix:
> 
> V4L2_PIX_FMT_PRIV_MAGIC should only be set for the VIDEO_CAPTURE and
> VIDEO_OUTPUT buffer types, and not for any others. In the case of
> the win format this overwrote a pointer value that is passed in from
> userspace.
> 
> Just set it for V4L2_BUF_TYPE_VIDEO_CAPTURE and OUTPUT only. Set
> it before the callback is called, just as is done for try/s_fmt, and
> again afterwards in case the driver zeroed it. The latter was missing
> in try/s_fmt, so add it there as well. Currently it is quite likely
> that drivers clear priv (that was needed for a long time), so it makes
> sense to set it twice.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index e620387..9fc8076 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1143,8 +1143,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  	int ret;
> 
> -	p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> -
>  	/*
>  	 * fmt can't be cleared for these overlay types due to the 'clips'
>  	 * 'clipcount' and 'bitmap' pointers in struct v4l2_window.
> @@ -1173,7 +1171,9 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
>  			break;
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
> +		/* just in case the driver zeroed it again */
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> @@ -1195,7 +1195,9 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
>  			break;
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		ret = ops->vidioc_g_fmt_vid_out(file, fh, arg);
> +		/* just in case the driver zeroed it again */
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> @@ -1231,6 +1233,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
> bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> +	int ret;
> 
>  	v4l_sanitize_format(p);
> 
> @@ -1239,7 +1242,10 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops
> *ops, if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
> -		return ops->vidioc_s_fmt_vid_cap(file, fh, arg);
> +		ret = ops->vidioc_s_fmt_vid_cap(file, fh, arg);
> +		/* just in case the driver zeroed it again */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
>  			break;
> @@ -1264,7 +1270,10 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops
> *ops, if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
> -		return ops->vidioc_s_fmt_vid_out(file, fh, arg);
> +		ret = ops->vidioc_s_fmt_vid_out(file, fh, arg);
> +		/* just in case the driver zeroed it again */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
>  			break;
> @@ -1303,6 +1312,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops
> *ops, bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> +	int ret;
> 
>  	v4l_sanitize_format(p);
> 
> @@ -1311,7 +1321,10 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops
> *ops, if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap))
> break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
> -		return ops->vidioc_try_fmt_vid_cap(file, fh, arg);
> +		ret = ops->vidioc_try_fmt_vid_cap(file, fh, arg);
> +		/* just in case the driver zeroed it again */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  		if (unlikely(!is_rx || !is_vid || !ops-
>vidioc_try_fmt_vid_cap_mplane))
>  			break;
> @@ -1336,7 +1349,10 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops
> *ops, if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out))
> break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
> -		return ops->vidioc_try_fmt_vid_out(file, fh, arg);
> +		ret = ops->vidioc_try_fmt_vid_out(file, fh, arg);
> +		/* just in case the driver zeroed it again */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>  		if (unlikely(!is_tx || !is_vid || !ops-
>vidioc_try_fmt_vid_out_mplane))
>  			break;

-- 
Regards,

Laurent Pinchart

