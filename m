Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2857 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaHHIJh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 04:09:37 -0400
Message-ID: <53E485B0.9090007@xs4all.nl>
Date: Fri, 08 Aug 2014 10:09:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: matrandg@cisco.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-ioctl: The result of VIDIOC_S_EDID should always
 be returned
References: <1407484061-26651-1-git-send-email-matrandg@cisco.com>
In-Reply-To: <1407484061-26651-1-git-send-email-matrandg@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

I know I reviewed this earlier and it looked good, but then I added a test for this
to the v4l2-compliance tool and I couldn't reproduce the error that should occur if
this patch wasn't applied.

Some more digging uncovered that the S_EDID ioctl is one of the 'array' controls
(see check_array_args()) and those always write back their struct, even if there
was an error.

So this patch isn't needed, at least not for the latest kernel.

Sorry for not seeing this earlier,

	Hans

On 08/08/2014 09:47 AM, matrandg@cisco.com wrote:
> From: Mats Randgaard <matrandg@cisco.com>
> 
> VIDIOC_S_EDID can return error and valid result
> 
> Documentation/DocBook/media/v4l/vidioc-g-edid.xml:
> "If there are more EDID blocks than the hardware can handle then
> the EDID is not written, but instead the error code E2BIG is set
> and blocks is set to the maximum that the hardware supports."
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index d15e167..f36c018 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2554,9 +2554,9 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  			err = -EFAULT;
>  		goto out_array_args;
>  	}
> -	/* VIDIOC_QUERY_DV_TIMINGS can return an error, but still have valid
> -	   results that must be returned. */
> -	if (err < 0 && cmd != VIDIOC_QUERY_DV_TIMINGS)
> +	/* VIDIOC_QUERY_DV_TIMINGS and VIDIOC_S_EDID can return an error, but
> +	   still have valid results that must be returned. */
> +	if (err < 0 && cmd != VIDIOC_QUERY_DV_TIMINGS && cmd != VIDIOC_S_EDID)
>  		goto out;
>  
>  out_array_args:
> 

