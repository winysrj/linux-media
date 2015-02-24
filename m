Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49739 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbBXAK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 19:10:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] media: omap3isp: ispvideo: drop setting of vb2 buffer state to VB2_BUF_STATE_ACTIVE
Date: Tue, 24 Feb 2015 02:12 +0200
Message-ID: <17811429.e5EH6tz6Dl@avalon>
In-Reply-To: <1424722773-20131-2-git-send-email-prabhakar.csengg@gmail.com>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com> <1424722773-20131-2-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Monday 23 February 2015 20:19:31 Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> There isn't a need to assign the state of vb2_buffer to active
> as this is already done by the core.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and queued to my tree. I still have to test the patch, I'll report any issue I 
can find.

> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index 3fe9047..837018d 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -524,7 +524,6 @@ struct isp_buffer *omap3isp_video_buffer_next(struct
> isp_video *video)
> 
>  	buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
>  			       irqlist);
> -	buf->vb.state = VB2_BUF_STATE_ACTIVE;
> 
>  	spin_unlock_irqrestore(&video->irqlock, flags);

-- 
Regards,

Laurent Pinchart

