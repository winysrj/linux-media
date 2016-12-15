Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49686 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754765AbcLOVLb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 16:11:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 08/11] vb2: dma-contig: Move vb2_dc_get_base_sgt() up
Date: Thu, 15 Dec 2016 23:12:07 +0200
Message-ID: <7453908.U9mZPLNEAl@avalon>
In-Reply-To: <1441972234-8643-9-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-9-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 11 Sep 2015 14:50:31 Sakari Ailus wrote:
> Just move the function up. It'll be soon needed earlier than previously.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I would move this patch to 09/11 though, just before the patch that requires 
it.

> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 44 +++++++++++------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 26a0a0f..3260392
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -82,6 +82,28 @@ static unsigned long vb2_dc_get_contiguous_size(struct
> sg_table *sgt) return size;
>  }
> 
> +static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
> +{
> +	int ret;
> +	struct sg_table *sgt;
> +
> +	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
> +	if (!sgt) {
> +		dev_err(buf->dev, "failed to alloc sg table\n");
> +		return NULL;
> +	}
> +
> +	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> +		buf->size);
> +	if (ret < 0) {
> +		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
> +		kfree(sgt);
> +		return NULL;
> +	}
> +
> +	return sgt;
> +}
> +
>  /*********************************************/
>  /*         callbacks for all buffers         */
>  /*********************************************/
> @@ -375,28 +397,6 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
>  	.release = vb2_dc_dmabuf_ops_release,
>  };
> 
> -static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
> -{
> -	int ret;
> -	struct sg_table *sgt;
> -
> -	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
> -	if (!sgt) {
> -		dev_err(buf->dev, "failed to alloc sg table\n");
> -		return NULL;
> -	}
> -
> -	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> -		buf->size);
> -	if (ret < 0) {
> -		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
> -		kfree(sgt);
> -		return NULL;
> -	}
> -
> -	return sgt;
> -}
> -
>  static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long
> flags) {
>  	struct vb2_dc_buf *buf = buf_priv;

-- 
Regards,

Laurent Pinchart

