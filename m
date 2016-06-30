Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35669 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbcF3NBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 09:01:11 -0400
Received: by mail-wm0-f65.google.com with SMTP id a66so22649101wme.2
        for <linux-media@vger.kernel.org>; Thu, 30 Jun 2016 06:01:10 -0700 (PDT)
Subject: Re: [PATCH] v4l: ioctl: Clear the v4l2_pix_format_mplane reserved
 field
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1467120010-30973-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <5775149C.7080506@bingham.xyz>
Date: Thu, 30 Jun 2016 13:46:20 +0100
MIME-Version: 1.0
In-Reply-To: <1467120010-30973-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks - this fixes the issue I saw.

On 28/06/16 14:20, Laurent Pinchart wrote:
> The S_FMT and TRY_FMT handlers in multiplane mode attempt at clearing
> the reserved fields of the v4l2_format structure after the pix_mp
> member. However, the reserved fields are inside pix_mp, not after it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Tested-by: Kieran Bingham <kieran@bingham.xyz>

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

-- 
Regards

Kieran Bingham
