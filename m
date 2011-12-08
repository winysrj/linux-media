Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53010 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1LHKzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 05:55:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] media: vb2: vmalloc-based allocator user pointer handling
Date: Thu, 8 Dec 2011 11:56:01 +0100
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
References: <1323275346-25824-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1323275346-25824-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112081156.02438.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek and Andrzej,

Thanks for the patch.

On Wednesday 07 December 2011 17:29:06 Marek Szyprowski wrote:
> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> 
> This patch adds support for user pointer memory buffers to vmalloc
> videobuf2 allocator.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-vmalloc.c |   97
> ++++++++++++++++++++++++++++--- 1 files changed, 89 insertions(+), 8
> deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-vmalloc.c
> b/drivers/media/video/videobuf2-vmalloc.c index a3a8842..8843ad0 100644
> --- a/drivers/media/video/videobuf2-vmalloc.c
> +++ b/drivers/media/video/videobuf2-vmalloc.c
> @@ -12,6 +12,7 @@
> 
>  #include <linux/module.h>
>  #include <linux/mm.h>
> +#include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> 
> @@ -20,7 +21,10 @@
> 
>  struct vb2_vmalloc_buf {
>  	void				*vaddr;
> +	struct page			**pages;
> +	int				write;
>  	unsigned long			size;
> +	unsigned int			n_pages;
>  	atomic_t			refcount;
>  	struct vb2_vmarea_handler	handler;
>  };
> @@ -42,14 +46,14 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx,
> unsigned long size) buf->handler.arg = buf;
> 
>  	if (!buf->vaddr) {
> -		printk(KERN_ERR "vmalloc of size %ld failed\n", buf->size);
> +		pr_err("vmalloc of size %ld failed\n", buf->size);
>  		kfree(buf);
>  		return NULL;
>  	}
> 
>  	atomic_inc(&buf->refcount);
> -	printk(KERN_DEBUG "Allocated vmalloc buffer of size %ld at vaddr=%p\n",
> -			buf->size, buf->vaddr);
> +	pr_err("Allocated vmalloc buffer of size %ld at vaddr=%p\n", buf->size,
> +	       buf->vaddr);

Turning KERN_DEBUG into pr_err() is a bit harsh :-) In my opinion even 
KERN_DEBUG is too much here, I don't want to get messages printed to the 
kernel log every time I allocate buffers.

>  	return buf;
>  }
> @@ -59,13 +63,87 @@ static void vb2_vmalloc_put(void *buf_priv)
>  	struct vb2_vmalloc_buf *buf = buf_priv;
> 
>  	if (atomic_dec_and_test(&buf->refcount)) {
> -		printk(KERN_DEBUG "%s: Freeing vmalloc mem at vaddr=%p\n",
> -			__func__, buf->vaddr);
> +		pr_debug("%s: Freeing vmalloc mem at vaddr=%p\n", __func__,
> +			 buf->vaddr);

Same here. Should we get rid of those two messages, or at least conditionally-
compile them out of the kernel by default ?

>  		vfree(buf->vaddr);
>  		kfree(buf);
>  	}
>  }
> 
> +static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> +				     unsigned long size, int write)
> +{
> +	struct vb2_vmalloc_buf *buf;
> +

No need for a blank line.

> +	unsigned long first, last;
> +	int n_pages_from_user, offset;

You seem to like long names :-) I'd use n_pages, and I would also shorten the 
labels below, but that's just me.

> +	buf = kzalloc(sizeof *buf, GFP_KERNEL);

The kernel coding style encourages parenthesis after the sizeof operator: 
sizeof(*buf).

> +	if (!buf)
> +		return NULL;
> +
> +	buf->write = write;
> +	offset = vaddr & ~PAGE_MASK;
> +	buf->size = size;
> +
> +	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
> +	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;

If you shift right anyway is there a need to & PAGE_MASK first ?

> +	buf->n_pages = last - first + 1;
> +	buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);

It's a common practice in the kernel to use variables instead of types when 
possible with the sizeof operator: sizeof(buf->pages). That's up to you.

> +	if (!buf->pages)
> +		goto userptr_fail_pages_array_alloc;
> +
> +	/* current->mm->mmap_sem is taken by videobuf core */
> +	n_pages_from_user = get_user_pages(current, current->mm,
> +					     vaddr & PAGE_MASK,
> +					     buf->n_pages,
> +					     write,
> +					     1, /* force */
> +					     buf->pages,
> +					     NULL);
> +	if (n_pages_from_user != buf->n_pages)
> +		goto userptr_fail_get_user_pages;
> +
> +	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
> +

No need for a blank line.

> +	if (!buf->vaddr)
> +		goto userptr_fail_get_user_pages;
> +
> +	buf->vaddr += offset;
> +	return buf;
> +
> +userptr_fail_get_user_pages:
> +	pr_debug("get_user_pages requested/got: %d/%d]\n", n_pages_from_user,
> +		 buf->n_pages);
> +	while (--n_pages_from_user >= 0)
> +		put_page(buf->pages[n_pages_from_user]);
> +	kfree(buf->pages);
> +
> +userptr_fail_pages_array_alloc:
> +	kfree(buf);
> +
> +	return NULL;
> +}
> +
> +static void vb2_vmalloc_put_userptr(void *buf_priv)
> +{
> +	struct vb2_vmalloc_buf *buf = buf_priv;
> +

No need for a blank line.

> +	unsigned int i;
> +	int offset = (unsigned long)buf->vaddr & ~PAGE_MASK;
> +
> +	if (buf->vaddr)
> +		vm_unmap_ram((const void *)((unsigned long)buf->vaddr - offset),
> +			     buf->n_pages);

Wouldn't just "buf->vaddr & PAGE_MASK" (with the proper casts if required) be 
simpler ? There's no need to compute the offset.

> +	for (i = 0; i < buf->n_pages; ++i) {
> +		if (buf->write)
> +			set_page_dirty_lock(buf->pages[i]);
> +		put_page(buf->pages[i]);
> +	}
> +	kfree(buf->pages);
> +	kfree(buf);
> +}
> +
>  static void *vb2_vmalloc_vaddr(void *buf_priv)
>  {
>  	struct vb2_vmalloc_buf *buf = buf_priv;
> @@ -73,7 +151,8 @@ static void *vb2_vmalloc_vaddr(void *buf_priv)
>  	BUG_ON(!buf);
> 
>  	if (!buf->vaddr) {
> -		printk(KERN_ERR "Address of an unallocated plane requested\n");
> +		pr_err("Address of an unallocated plane requested "
> +		       "or cannot map user pointer\n");
>  		return NULL;
>  	}
> 
> @@ -92,13 +171,13 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct
> vm_area_struct *vma) int ret;
> 
>  	if (!buf) {
> -		printk(KERN_ERR "No memory to map\n");
> +		pr_err("No memory to map\n");
>  		return -EINVAL;
>  	}
> 
>  	ret = remap_vmalloc_range(vma, buf->vaddr, 0);
>  	if (ret) {
> -		printk(KERN_ERR "Remapping vmalloc memory, error: %d\n", ret);
> +		pr_err("Remapping vmalloc memory, error: %d\n", ret);
>  		return ret;
>  	}
> 
> @@ -121,6 +200,8 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct
> vm_area_struct *vma) const struct vb2_mem_ops vb2_vmalloc_memops = {
>  	.alloc		= vb2_vmalloc_alloc,
>  	.put		= vb2_vmalloc_put,
> +	.get_userptr	= vb2_vmalloc_get_userptr,
> +	.put_userptr	= vb2_vmalloc_put_userptr,
>  	.vaddr		= vb2_vmalloc_vaddr,
>  	.mmap		= vb2_vmalloc_mmap,
>  	.num_users	= vb2_vmalloc_num_users,

-- 
Regards,

Laurent Pinchart
