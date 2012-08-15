Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43965 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2HOUDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 16:03:47 -0400
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
Subject: Re: [PATCHv8 21/26] v4l: vb2-dma-contig: add reference counting for a device from allocator context
Date: Wed, 15 Aug 2012 22:04:02 +0200
Message-ID: <10699580.p7WLNaRi24@avalon>
In-Reply-To: <1344958496-9373-22-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-22-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 14 August 2012 17:34:51 Tomasz Stanislawski wrote:
> This patch adds taking reference to the device for MMAP buffers.
> 
> Such buffers, may be exported using DMABUF mechanism. If the driver that
> created a queue is unloaded then the queue is released, the device might be
> released too.  However, buffers cannot be released if they are referenced by
> DMABUF descriptor(s). The device pointer kept in a buffer must be valid for
> the whole buffer's lifetime. Therefore MMAP buffers should take a reference
> to the device to avoid risk of dangling pointers.

That patch looks good, but that approach won't scale if we ever need a more 
complex context that can't be copied. We can ignore that for now, but if we 
decide to support "orphan" vb2 buffers, that's an issue we need to be aware of 
as it might come back to bite us in the future.

I assume that this patch requires your dmabuf owner patch to fix the orphan 
buffer case properly.

> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index bb2b4ac8..d44766e 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -148,6 +148,7 @@ static void vb2_dc_put(void *buf_priv)
>  		kfree(buf->sgt_base);
>  	}
>  	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
> +	put_device(buf->dev);
>  	kfree(buf);
>  }
> 
> @@ -161,9 +162,13 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> long size) if (!buf)
>  		return ERR_PTR(-ENOMEM);
> 
> +	/* prevent the device from release while the buffer is exported */
> +	get_device(dev);
> +
>  	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
>  	if (!buf->vaddr) {
>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
> +		put_device(dev);
>  		kfree(buf);
>  		return ERR_PTR(-ENOMEM);
>  	}
-- 
Regards,

Laurent Pinchart

