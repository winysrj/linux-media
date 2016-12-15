Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49785 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbcLOWFo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:05:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 11/11] vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
Date: Thu, 15 Dec 2016 23:57:54 +0200
Message-ID: <1547868.pze7WEjWy0@avalon>
In-Reply-To: <1441972234-8643-12-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-12-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 11 Sep 2015 14:50:34 Sakari Ailus wrote:
> The scatterlist should always be present when the cache would need to be
> flushed. Each buffer type has its own means to provide that. Add
> WARN_ON_ONCE() to check the scatterist exists.

Do you think such a check is really needed ? Have you run into this before ?

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 65ee122..58c35c5
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -145,6 +145,9 @@ static void vb2_dc_prepare(void *buf_priv)
>  	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
>  		return;
> 
> +	if (WARN_ON_ONCE(!sgt))
> +		return;
> +
>  	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>  }
> 
> @@ -161,6 +164,9 @@ static void vb2_dc_finish(void *buf_priv)
>  	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
>  		return;
> 
> +	if (WARN_ON_ONCE(!sgt))
> +		return;
> +
>  	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>  }

-- 
Regards,

Laurent Pinchart

