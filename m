Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41420 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2JGNhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 09:37:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv9 21/25] v4l: vb2-dma-contig: add reference counting for a device from allocator context
Date: Sun, 07 Oct 2012 15:38:20 +0200
Message-ID: <5632939.khdjxQCaCl@avalon>
In-Reply-To: <1349188056-4886-22-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <1349188056-4886-22-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 02 October 2012 16:27:32 Tomasz Stanislawski wrote:
> This patch adds taking reference to the device for MMAP buffers.
> 
> Such buffers, may be exported using DMABUF mechanism. If the driver that
> created a queue is unloaded then the queue is released, the device might be
> released too.  However, buffers cannot be released if they are referenced by
> DMABUF descriptor(s). The device pointer kept in a buffer must be valid for
> the whole buffer's lifetime. Therefore MMAP buffers should take a reference
> to the device to avoid risk of dangling pointers.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index b138b5c..b4d287a 100644
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

What about moving this below the dma_alloc_coherent() call ? You could then 
avoid the put_device() call in the error path.

>  	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
>  	if (!buf->vaddr) {
>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
> +		put_device(dev);
>  		kfree(buf);
>  		return ERR_PTR(-ENOMEM);
>  	}

Something like

-	buf->dev = dev;
+	buf->dev = get_device(dev);
	buf->size = size

-- 
Regards,

Laurent Pinchart
