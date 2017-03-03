Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40455 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751459AbdCCQls (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 11:41:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: Laura Abbott <labbott@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        devel@driverdev.osuosl.org, romlem@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Mark Brown <broonie@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 10/12] staging: android: ion: Use CMA APIs directly
Date: Fri, 03 Mar 2017 18:41:33 +0200
Message-ID: <2140021.hmlAgxcLbU@avalon>
In-Reply-To: <1488491084-17252-11-git-send-email-labbott@redhat.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com> <1488491084-17252-11-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laura,

Thank you for the patch.

On Thursday 02 Mar 2017 13:44:42 Laura Abbott wrote:
> When CMA was first introduced, its primary use was for DMA allocation
> and the only way to get CMA memory was to call dma_alloc_coherent. This
> put Ion in an awkward position since there was no device structure
> readily available and setting one up messed up the coherency model.
> These days, CMA can be allocated directly from the APIs. Switch to using
> this model to avoid needing a dummy device. This also avoids awkward
> caching questions.

If the DMA mapping API isn't suitable for today's requirements anymore, I 
believe that's what needs to be fixed, instead of working around the problem 
by introducing another use-case-specific API.

> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
>  drivers/staging/android/ion/ion_cma_heap.c | 97 +++++++--------------------
>  1 file changed, 26 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/staging/android/ion/ion_cma_heap.c
> b/drivers/staging/android/ion/ion_cma_heap.c index d562fd7..6838825 100644
> --- a/drivers/staging/android/ion/ion_cma_heap.c
> +++ b/drivers/staging/android/ion/ion_cma_heap.c
> @@ -19,24 +19,19 @@
>  #include <linux/slab.h>
>  #include <linux/errno.h>
>  #include <linux/err.h>
> -#include <linux/dma-mapping.h>
> +#include <linux/cma.h>
> +#include <linux/scatterlist.h>
> 
>  #include "ion.h"
>  #include "ion_priv.h"
> 
>  struct ion_cma_heap {
>  	struct ion_heap heap;
> -	struct device *dev;
> +	struct cma *cma;
>  };
> 
>  #define to_cma_heap(x) container_of(x, struct ion_cma_heap, heap)
> 
> -struct ion_cma_buffer_info {
> -	void *cpu_addr;
> -	dma_addr_t handle;
> -	struct sg_table *table;
> -};
> -
> 
>  /* ION CMA heap operations functions */
>  static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer
> *buffer, @@ -44,93 +39,53 @@ static int ion_cma_allocate(struct ion_heap
> *heap, struct ion_buffer *buffer, unsigned long flags)
>  {
>  	struct ion_cma_heap *cma_heap = to_cma_heap(heap);
> -	struct device *dev = cma_heap->dev;
> -	struct ion_cma_buffer_info *info;
> -
> -	dev_dbg(dev, "Request buffer allocation len %ld\n", len);
> -
> -	if (buffer->flags & ION_FLAG_CACHED)
> -		return -EINVAL;
> +	struct sg_table *table;
> +	struct page *pages;
> +	int ret;
> 
> -	info = kzalloc(sizeof(*info), GFP_KERNEL);
> -	if (!info)
> +	pages = cma_alloc(cma_heap->cma, len, 0);
> +	if (!pages)
>  		return -ENOMEM;
> 
> -	info->cpu_addr = dma_alloc_coherent(dev, len, &(info->handle),
> -						GFP_HIGHUSER | __GFP_ZERO);
> -
> -	if (!info->cpu_addr) {
> -		dev_err(dev, "Fail to allocate buffer\n");
> +	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
> +	if (!table)
>  		goto err;
> -	}
> 
> -	info->table = kmalloc(sizeof(*info->table), GFP_KERNEL);
> -	if (!info->table)
> +	ret = sg_alloc_table(table, 1, GFP_KERNEL);
> +	if (ret)
>  		goto free_mem;
> 
> -	if (dma_get_sgtable(dev, info->table, info->cpu_addr, info->handle,
> -			    len))
> -		goto free_table;
> -	/* keep this for memory release */
> -	buffer->priv_virt = info;
> -	buffer->sg_table = info->table;
> -	dev_dbg(dev, "Allocate buffer %p\n", buffer);
> +	sg_set_page(table->sgl, pages, len, 0);
> +
> +	buffer->priv_virt = pages;
> +	buffer->sg_table = table;
>  	return 0;
> 
> -free_table:
> -	kfree(info->table);
>  free_mem:
> -	dma_free_coherent(dev, len, info->cpu_addr, info->handle);
> +	kfree(table);
>  err:
> -	kfree(info);
> +	cma_release(cma_heap->cma, pages, buffer->size);
>  	return -ENOMEM;
>  }
> 
>  static void ion_cma_free(struct ion_buffer *buffer)
>  {
>  	struct ion_cma_heap *cma_heap = to_cma_heap(buffer->heap);
> -	struct device *dev = cma_heap->dev;
> -	struct ion_cma_buffer_info *info = buffer->priv_virt;
> +	struct page *pages = buffer->priv_virt;
> 
> -	dev_dbg(dev, "Release buffer %p\n", buffer);
>  	/* release memory */
> -	dma_free_coherent(dev, buffer->size, info->cpu_addr, info->handle);
> +	cma_release(cma_heap->cma, pages, buffer->size);
>  	/* release sg table */
> -	sg_free_table(info->table);
> -	kfree(info->table);
> -	kfree(info);
> -}
> -
> -static int ion_cma_mmap(struct ion_heap *mapper, struct ion_buffer *buffer,
> -			struct vm_area_struct *vma)
> -{
> -	struct ion_cma_heap *cma_heap = to_cma_heap(buffer->heap);
> -	struct device *dev = cma_heap->dev;
> -	struct ion_cma_buffer_info *info = buffer->priv_virt;
> -
> -	return dma_mmap_coherent(dev, vma, info->cpu_addr, info->handle,
> -				 buffer->size);
> -}
> -
> -static void *ion_cma_map_kernel(struct ion_heap *heap,
> -				struct ion_buffer *buffer)
> -{
> -	struct ion_cma_buffer_info *info = buffer->priv_virt;
> -	/* kernel memory mapping has been done at allocation time */
> -	return info->cpu_addr;
> -}
> -
> -static void ion_cma_unmap_kernel(struct ion_heap *heap,
> -				 struct ion_buffer *buffer)
> -{
> +	sg_free_table(buffer->sg_table);
> +	kfree(buffer->sg_table);
>  }
> 
>  static struct ion_heap_ops ion_cma_ops = {
>  	.allocate = ion_cma_allocate,
>  	.free = ion_cma_free,
> -	.map_user = ion_cma_mmap,
> -	.map_kernel = ion_cma_map_kernel,
> -	.unmap_kernel = ion_cma_unmap_kernel,
> +	.map_user = ion_heap_map_user,
> +	.map_kernel = ion_heap_map_kernel,
> +	.unmap_kernel = ion_heap_unmap_kernel,
>  };
> 
>  struct ion_heap *ion_cma_heap_create(struct ion_platform_heap *data)
> @@ -147,7 +102,7 @@ struct ion_heap *ion_cma_heap_create(struct
> ion_platform_heap *data) * get device from private heaps data, later it
> will be
>  	 * used to make the link with reserved CMA memory
>  	 */
> -	cma_heap->dev = data->priv;
> +	cma_heap->cma = data->priv;
>  	cma_heap->heap.type = ION_HEAP_TYPE_DMA;
>  	return &cma_heap->heap;
>  }

-- 
Regards,

Laurent Pinchart
