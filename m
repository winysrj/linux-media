Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58742 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbJ3PoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2015 11:44:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: small cleanup in uvc_video_clock_update()
Date: Fri, 30 Oct 2015 17:44:14 +0200
Message-ID: <1682612.NLBs1S0Qsv@avalon>
In-Reply-To: <20151022090905.GB9202@mwanda>
References: <20151022090905.GB9202@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Thursday 22 October 2015 12:09:05 Dan Carpenter wrote:
> Smatch is not smart enough to see that "&stream->clock.lock" and
> "&clock->lock" are the same thing so it complains about the locking
> here.  Let's make it more consistent.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 2b276ab..4abe3e9 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -709,7 +709,7 @@ void uvc_video_clock_update(struct uvc_streaming
> *stream, vbuf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> 
>  done:
> -	spin_unlock_irqrestore(&stream->clock.lock, flags);
> +	spin_unlock_irqrestore(&clock->lock, flags);
>  }
> 
>  /* ------------------------------------------------------------------------

-- 
Regards,

Laurent Pinchart

