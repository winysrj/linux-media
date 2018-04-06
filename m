Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35369 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbeDFPqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 11:46:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 17/21] media: ispstat: use %p to print the address of a buffer
Date: Fri, 06 Apr 2018 18:46:05 +0300
Message-ID: <2465013.GQB41gvM8H@avalon>
In-Reply-To: <76525da04eb7d8e5faaff7dc5173a05467b96965.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com> <76525da04eb7d8e5faaff7dc5173a05467b96965.1523024380.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday, 6 April 2018 17:23:18 EEST Mauro Carvalho Chehab wrote:
> Instead of converting to int, use %p. That prevents this
> warning:
> 	drivers/media/platform/omap3isp/ispstat.c:451 isp_stat_bufs_alloc() warn:
> argument 7 to %08lx specifier is cast from pointer
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/omap3isp/ispstat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispstat.c
> b/drivers/media/platform/omap3isp/ispstat.c index
> 47cbc7e3d825..eb1b589b0aeb 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -449,10 +449,10 @@ static int isp_stat_bufs_alloc(struct ispstat *stat,
> u32 size) buf->empty = 1;
> 
>  		dev_dbg(stat->isp->dev,
> -			"%s: buffer[%u] allocated. dma=0x%08lx virt=0x%08lx",
> +			"%s: buffer[%u] allocated. dma=0x%08lx virt=%p",
>  			stat->subdev.name, i,
>  			(unsigned long)buf->dma_addr,
> -			(unsigned long)buf->virt_addr);
> +			buf->virt_addr);

While at it you can use %pad for buf->dma_addr.

		dev_dbg(stat->isp->dev,
			"%s: buffer[%u] allocated. dma=%pad virt=%p",
			stat->subdev.name, i, &buf->dma_addr, buf->virt_addr);

With that change,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	}
> 
>  	return 0;

-- 
Regards,

Laurent Pinchart
