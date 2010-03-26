Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3283 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab0CZLT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 07:19:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: fix ENUMSTD ioctl to report all supported standards
Date: Fri, 26 Mar 2010 12:19:59 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1003260758550.4298@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1003260758550.4298@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003261219.59703.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 26 March 2010 08:06:42 Guennadi Liakhovetski wrote:
> V4L2_STD_PAL, V4L2_STD_SECAM, and V4L2_STD_NTSC are not the only composite 
> standards. Currently, e.g., if a driver supports all of V4L2_STD_PAL_B, 
> V4L2_STD_PAL_B1 and V4L2_STD_PAL_G, the enumeration will report 
> V4L2_STD_PAL_BG and not the single standards, which can confuse 
> applications. Fix this by only clearing simple standards from the mask. 
> This, of course, will only work, if composite standards are listed before 
> simple ones in the standards array in v4l2-ioctl.c, which is currently 
> the case.

Do you have an specific example where the current implementation will do the
wrong thing?

Regards,

	Hans

> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 4b11257..2389df0 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1065,9 +1065,7 @@ static long __video_do_ioctl(struct file *file,
>  			j++;
>  			if (curr_id == 0)
>  				break;
> -			if (curr_id != V4L2_STD_PAL &&
> -			    curr_id != V4L2_STD_SECAM &&
> -			    curr_id != V4L2_STD_NTSC)
> +			if (is_power_of_2(curr_id))
>  				id &= ~curr_id;
>  		}
>  		if (i <= index)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
