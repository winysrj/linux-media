Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58896 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2HOSYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 14:24:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, dmitriyz@google.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv8 06/26] v4l: vb2-dma-contig: remove reference of alloc_ctx from a buffer
Date: Wed, 15 Aug 2012 20:24:32 +0200
Message-ID: <2417829.O1YMMu0gWf@avalon>
In-Reply-To: <1344958496-9373-7-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-7-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 14 August 2012 17:34:36 Tomasz Stanislawski wrote:
> This patch removes a reference to alloc_ctx from an instance of a DMA
> contiguous buffer. It helps to avoid a risk of a dangling pointer if the
> context is released while the buffer is still valid. Moreover it removes one
> dereference step while accessing a device structure.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/videobuf2-dma-contig.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index a05784f..20c95da 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -23,7 +23,7 @@ struct vb2_dc_conf {
>  };
> 
>  struct vb2_dc_buf {
> -	struct vb2_dc_conf		*conf;
> +	struct device			*dev;
>  	void				*vaddr;
>  	dma_addr_t			dma_addr;
>  	unsigned long			size;
> @@ -37,22 +37,21 @@ static void vb2_dc_put(void *buf_priv);
>  static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
>  {
>  	struct vb2_dc_conf *conf = alloc_ctx;
> +	struct device *dev = conf->dev;
>  	struct vb2_dc_buf *buf;
> 
>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>  	if (!buf)
>  		return ERR_PTR(-ENOMEM);
> 
> -	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->dma_addr,
> -					GFP_KERNEL);
> +	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
>  	if (!buf->vaddr) {
> -		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
> -			size);
> +		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
>  		kfree(buf);
>  		return ERR_PTR(-ENOMEM);
>  	}
> 
> -	buf->conf = conf;
> +	buf->dev = dev;
>  	buf->size = size;
> 
>  	buf->handler.refcount = &buf->refcount;
> @@ -69,7 +68,7 @@ static void vb2_dc_put(void *buf_priv)
>  	struct vb2_dc_buf *buf = buf_priv;
> 
>  	if (atomic_dec_and_test(&buf->refcount)) {
> -		dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
> +		dma_free_coherent(buf->dev, buf->size, buf->vaddr,
>  				  buf->dma_addr);
>  		kfree(buf);
>  	}
-- 
Regards,

Laurent Pinchart

