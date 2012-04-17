Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39242 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2DQNRC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 09:17:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com
Subject: Re: [RFC 04/13] v4l: vb2-dma-contig: add setup of sglist for MMAP buffers
Date: Tue, 17 Apr 2012 15:17:13 +0200
Message-ID: <1634369.EmMfL12p0k@avalon>
In-Reply-To: <1334063447-16824-5-git-send-email-t.stanislaws@samsung.com>
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com> <1334063447-16824-5-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 10 April 2012 15:10:38 Tomasz Stanislawski wrote:
> This patch adds the setup of sglist list for MMAP buffers.
> It is needed for buffer exporting via DMABUF mechanism.
> 
> This patch depends on dma_get_pages extension to DMA api.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |   51 ++++++++++++++++++++++++-
>  1 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index f4df9e2..0cdcd2b 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c

[snip]

> @@ -197,6 +199,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
> size) {
>  	struct device *dev = alloc_ctx;
>  	struct vb2_dc_buf *buf;
> +	int ret = -ENOMEM;
> +	int n_pages;
> +	struct page **pages = NULL;
> 
>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>  	if (!buf)
> @@ -205,10 +210,41 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> long size) buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> GFP_KERNEL); if (!buf->vaddr) {
>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
> -		kfree(buf);
> -		return ERR_PTR(-ENOMEM);
> +		goto fail_buf;
> +	}
> +
> +	WARN_ON((unsigned long)buf->vaddr & ~PAGE_MASK);
> +	WARN_ON(buf->dma_addr & ~PAGE_MASK);
> +
> +	n_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +
> +	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
> +	if (!pages) {
> +		dev_err(dev, "failed to alloc page table\n");
> +		goto fail_dma;
> +	}
> +
> +	ret = dma_get_pages(dev, buf->vaddr, buf->dma_addr, pages, n_pages);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to get buffer pages from DMA API\n");
> +		goto fail_pages;
> +	}
> +	if (ret != n_pages) {
> +		ret = -EFAULT;
> +		dev_err(dev, "failed to get all pages from DMA API\n");
> +		goto fail_pages;
>  	}
> 
> +	buf->sgt_base = vb2_dc_pages_to_sgt(pages, n_pages, 0, 0);
> +	if (IS_ERR(buf->sgt_base)) {
> +		ret = PTR_ERR(buf->sgt_base);
> +		dev_err(dev, "failed to prepare sg table\n");
> +		goto fail_pages;
> +	}

I still (at least partially) share Daniel's opinion regarding dma_get_pages(), 
As I stated before, I think what we need here would be either

-  a DMA API call that maps the memory to the importer device instead of
dma_get_pages() + vb2_dc_pages_to_sgt(). The call would take a DMA memory
"cookie" (see the "Minutes from V4L2 update call" mail thread) and a pointer
to the importer device.

- a DMA API call to retrieve a scatter list suitable to be passed to
dma_map_sg(). This would be similar to dma_get_pages() +
vb2_dc_pages_to_sgt().

(And we still have to figure out whether the mapping call should be in the 
exporter or importer, which might have an influence here).

> +
> +	/* pages are no longer needed */
> +	kfree(pages);
> +
>  	buf->dev = dev;
>  	buf->size = size;
> 
> @@ -219,6 +255,17 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> long size) atomic_inc(&buf->refcount);
> 
>  	return buf;
> +
> +fail_pages:
> +	kfree(pages);

As kfree(NULL) is legal, you can remove the fail_pages label and move the 
kfree() call just before dma_free_coherent().

> +
> +fail_dma:
> +	dma_free_coherent(dev, size, buf->vaddr, buf->dma_addr);
> +
> +fail_buf:
> +	kfree(buf);
> +
> +	return ERR_PTR(ret);
>  }
> 
>  static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)

-- 
Regards,

Laurent Pinchart

