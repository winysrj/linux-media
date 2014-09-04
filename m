Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57842 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaIDUYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 16:24:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 18/46] [media] omap3isp: use true/false for boolean vars
Date: Thu, 04 Sep 2014 23:24:06 +0300
Message-ID: <3962609.YBkbqZnabU@avalon>
In-Reply-To: <f9d3de5adb4521bd377c51468b9e941615f861ba.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com> <f9d3de5adb4521bd377c51468b9e941615f861ba.1409775488.git.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Wednesday 03 September 2014 17:32:50 Mauro Carvalho Chehab wrote:
> Instead of using 0 or 1 for boolean, use the true/false
> defines.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index
> cabf46b4b645..81a9dc053d58 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -1806,7 +1806,7 @@ static int ccdc_video_queue(struct isp_video *video,
> struct isp_buffer *buffer) spin_lock_irqsave(&ccdc->lock, flags);
>  	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS && !ccdc->running &&
>  	    ccdc->bt656)
> -		restart = 1;
> +		restart = true;
>  	else
>  		ccdc->underrun = 1;
>  	spin_unlock_irqrestore(&ccdc->lock, flags);

-- 
Regards,

Laurent Pinchart

