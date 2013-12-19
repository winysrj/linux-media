Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41577 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3LSBCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 20:02:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kernel-janitors@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch v2] [media] v4l: omap4iss: Restore irq flags correctly in omap4iss_video_buffer_next()
Date: Thu, 19 Dec 2013 02:03:05 +0100
Message-ID: <9772816.NZs94s1p3P@avalon>
In-Reply-To: <20131216150612.GA15506@elgon.mountain>
References: <20131216150612.GA15506@elgon.mountain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Wednesday 18 December 2013 10:29:24 Dan Carpenter wrote:
> The spin_lock_irqsave() macro is not nestable.  The second call will
> overwrite the first record of "flags" so the IRQs will not be enabled
> correctly at the end of the function.
> 
> In the current code, this function is always called from the IRQ handler
> so everything works fine and this fix doesn't change anything.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I'll send a pull request shortly.

> ---
> v2:  Updated the change log
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c
> b/drivers/staging/media/omap4iss/iss_video.c index
> 766491e6a8d0..c9b71c750b15 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -451,9 +451,9 @@ struct iss_buffer *omap4iss_video_buffer_next(struct
> iss_video *video) }
> 
>  	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->input != NULL) {
> -		spin_lock_irqsave(&pipe->lock, flags);
> +		spin_lock(&pipe->lock);
>  		pipe->state &= ~ISS_PIPELINE_STREAM;
> -		spin_unlock_irqrestore(&pipe->lock, flags);
> +		spin_unlock(&pipe->lock);
>  	}
> 
>  	buf = list_first_entry(&video->dmaqueue, struct iss_buffer,

-- 
Regards,

Laurent Pinchart

