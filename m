Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49699 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbcLOVNP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 16:13:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 09/11] vb2: dma-contig: Don't warn on failure in obtaining scatterlist
Date: Thu, 15 Dec 2016 23:13:51 +0200
Message-ID: <1965006.ft6WAVAs7u@avalon>
In-Reply-To: <1441972234-8643-10-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-10-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 11 Sep 2015 14:50:32 Sakari Ailus wrote:
> vb2_dc_get_base_sgt() which obtains the scatterlist already prints
> information on why the scatterlist could not be obtained.
> 
> Also, remove the useless warning of a failed kmalloc().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 3260392..65bc687
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -88,10 +88,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct
> vb2_dc_buf *buf) struct sg_table *sgt;
> 
>  	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
> -	if (!sgt) {
> -		dev_err(buf->dev, "failed to alloc sg table\n");
> +	if (!sgt)
>  		return NULL;
> -	}
> 
>  	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
>  		buf->size);
> @@ -411,7 +409,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv,
> unsigned long flags) if (!buf->dma_sgt)
>  		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
> 
> -	if (WARN_ON(!buf->dma_sgt))
> +	if (!buf->dma_sgt)
>  		return NULL;
> 
>  	dbuf = dma_buf_export(&exp_info);

-- 
Regards,

Laurent Pinchart

