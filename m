Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58574 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbcGAKwg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 06:52:36 -0400
Subject: Re: [PATCH] v4l: ioctl: Clear the v4l2_pix_format_mplane reserved
 field
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1467120010-30973-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <aa4960c5-780e-bd26-4539-fd867e75f2af@xs4all.nl>
Date: Fri, 1 Jul 2016 12:52:31 +0200
MIME-Version: 1.0
In-Reply-To: <1467120010-30973-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2016 03:20 PM, Laurent Pinchart wrote:
> The S_FMT and TRY_FMT handlers in multiplane mode attempt at clearing
> the reserved fields of the v4l2_format structure after the pix_mp
> member. However, the reserved fields are inside pix_mp, not after it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Kieran, this should fix the v4l2-compliance failures you saw when not clearing
> pix_mp.reserved manually in the FDP1 driver. Could you please test it ?
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 19d3aee3b374..86332072a575 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1508,7 +1508,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
>  			break;
> -		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
> +		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);

The same is needed in v4l_try_fmt.

Regards,

	Hans

>  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_overlay))
> @@ -1536,7 +1536,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
>  			break;
> -		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
> +		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_overlay))
> @@ -1598,7 +1598,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap_mplane))
>  			break;
> -		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
> +		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_overlay))
> @@ -1626,7 +1626,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_mplane))
>  			break;
> -		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
> +		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_overlay))
> 
