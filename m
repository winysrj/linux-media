Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33871 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaGUJeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 05:34:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 for v3.17] v4l2-ioctl: don't set PRIV_MAGIC unconditionally in g_fmt()
Date: Mon, 21 Jul 2014 11:34:17 +0200
Message-ID: <2742966.rkmSKnr5zD@avalon>
In-Reply-To: <53CCDE02.2050402@xs4all.nl>
References: <53CCDE02.2050402@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 21 July 2014 11:31:46 Hans Verkuil wrote:
> Regression fix:
> 
> V4L2_PIX_FMT_PRIV_MAGIC should only be set for the VIDEO_CAPTURE and
> VIDEO_OUTPUT buffer types, and not for any others. In the case of
> the win format this overwrote a pointer value that is passed in from
> userspace.
> 
> Just set it for V4L2_BUF_TYPE_VIDEO_CAPTURE and OUTPUT and not anywhere
> else. Also set it before the callback is called rather than after it,
> just as is done for try/s_fmt.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index e620387..e876bb9 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1141,9 +1141,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> -	int ret;
> -
> -	p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> 
>  	/*
>  	 * fmt can't be cleared for these overlay types due to the 'clips'
> @@ -1164,6 +1161,15 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops
> *ops, p->fmt.win.bitmap = bitmap;
>  		break;
>  	}
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		memset(&p->fmt, 0, sizeof(p->fmt));
> +		/*
> +		 * Fill in the priv field to signal that the extended
> +		 * v4l2_pix_format fields are valid.
> +		 */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		break;
>  	default:
>  		memset(&p->fmt, 0, sizeof(p->fmt));
>  		break;
> @@ -1173,9 +1179,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
>  			break;
> -		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
> -		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> -		return ret;
> +		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);

If a driver zeroes the priv field in vidioc_g_fmt_vid_cap or 
(vidioc_g_fmt_vid_out below) this will break. We should really set the field 
before and after calling the operation.

>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap_mplane))
>  			break;
> @@ -1195,9 +1199,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
>  			break;
> -		ret = ops->vidioc_g_fmt_vid_out(file, fh, arg);
> -		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> -		return ret;
> +		return ops->vidioc_g_fmt_vid_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_mplane))
>  			break;

-- 
Regards,

Laurent Pinchart

