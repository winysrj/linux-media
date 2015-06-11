Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59151 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbFKOks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 10:40:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Fabian Frederick <fabf@skynet.be>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 2/9] [media] media: omap_vout: Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
Date: Thu, 11 Jun 2015 07:21:16 +0300
Message-ID: <1439884.SWlnxou8Xt@avalon>
In-Reply-To: <0bec810973e08df0e66260e84d2dcea055a3fad7.1433927458.git.mchehab@osg.samsung.com>
References: <cover.1433927458.git.mchehab@osg.samsung.com> <0bec810973e08df0e66260e84d2dcea055a3fad7.1433927458.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

(CC'ing Tomi Valkeinen)

On Wednesday 10 June 2015 06:20:45 Mauro Carvalho Chehab wrote:
> From: Jan Kara <jack@suse.cz>
> 
> Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() instead of
> hand made mapping of virtual address to physical address. Also the
> function leaked page reference from get_user_pages() so fix that by
> properly release the reference when omap_vout_buffer_release() is
> called.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> [hans.verkuil@cisco.com: remove unused struct omap_vout_device *vout
> variable]
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/platform/omap/omap_vout.c
> b/drivers/media/platform/omap/omap_vout.c index f09c5f17a42f..7feb6394f111
> 100644
> --- a/drivers/media/platform/omap/omap_vout.c
> +++ b/drivers/media/platform/omap/omap_vout.c
> @@ -195,46 +195,34 @@ static int omap_vout_try_format(struct v4l2_pix_format
> *pix) }
> 
>  /*
> - * omap_vout_uservirt_to_phys: This inline function is used to convert user
> - * space virtual address to physical address.
> + * omap_vout_get_userptr: Convert user space virtual address to physical
> + * address.
>   */
> -static unsigned long omap_vout_uservirt_to_phys(unsigned long virtp)
> +static int omap_vout_get_userptr(struct videobuf_buffer *vb, u32 virtp,
> +				 u32 *physp)
>  {
> -	unsigned long physp = 0;
> -	struct vm_area_struct *vma;
> -	struct mm_struct *mm = current->mm;
> +	struct frame_vector *vec;
> +	int ret;
> 
>  	/* For kernel direct-mapped memory, take the easy way */
> -	if (virtp >= PAGE_OFFSET)
> -		return virt_to_phys((void *) virtp);
> -
> -	down_read(&current->mm->mmap_sem);
> -	vma = find_vma(mm, virtp);
> -	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
> -		/* this will catch, kernel-allocated, mmaped-to-usermode
> -		   addresses */
> -		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
> -		up_read(&current->mm->mmap_sem);
> -	} else {
> -		/* otherwise, use get_user_pages() for general userland pages */
> -		int res, nr_pages = 1;
> -		struct page *pages;
> +	if (virtp >= PAGE_OFFSET) {
> +		*physp = virt_to_phys((void *)virtp);

Lovely. virtp comes from userspace and as far as I know it arrives here 
completely unchecked. The problem isn't introduced by this patch, but 
omap_vout buffer management seems completely broken to me, and nobody seems to 
care about the driver. Given that omapdrm should now provide the video output 
capabilities that are missing from omapfb and resulted in the development of 
omap_vout, shouldn't we drop the omap_vout driver ?

Tomi, any opinion on this ? Do you see any omap_vout capability missing from 
omapdrm ?

> +		return 0;
> +	}
> 
> -		res = get_user_pages(current, current->mm, virtp, nr_pages, 1,
> -				0, &pages, NULL);
> -		up_read(&current->mm->mmap_sem);
> +	vec = frame_vector_create(1);
> +	if (!vec)
> +		return -ENOMEM;
> 
> -		if (res == nr_pages) {
> -			physp =  __pa(page_address(&pages[0]) +
> -					(virtp & ~PAGE_MASK));
> -		} else {
> -			printk(KERN_WARNING VOUT_NAME
> -					"get_user_pages failed\n");
> -			return 0;
> -		}
> +	ret = get_vaddr_frames(virtp, 1, true, false, vec);
> +	if (ret != 1) {
> +		frame_vector_destroy(vec);
> +		return -EINVAL;
>  	}
> +	*physp = __pfn_to_phys(frame_vector_pfns(vec)[0]);
> +	vb->priv = vec;
> 
> -	return physp;
> +	return 0;
>  }
> 
>  /*
> @@ -784,11 +772,15 @@ static int omap_vout_buffer_prepare(struct
> videobuf_queue *q, * address of the buffer
>  	 */
>  	if (V4L2_MEMORY_USERPTR == vb->memory) {
> +		int ret;
> +
>  		if (0 == vb->baddr)
>  			return -EINVAL;
>  		/* Physical address */
> -		vout->queued_buf_addr[vb->i] = (u8 *)
> -			omap_vout_uservirt_to_phys(vb->baddr);
> +		ret = omap_vout_get_userptr(vb, vb->baddr,
> +				(u32 *)&vout->queued_buf_addr[vb->i]);
> +		if (ret < 0)
> +			return ret;
>  	} else {
>  		unsigned long addr, dma_addr;
>  		unsigned long size;
> @@ -834,12 +826,13 @@ static void omap_vout_buffer_queue(struct
> videobuf_queue *q, static void omap_vout_buffer_release(struct
> videobuf_queue *q,
>  			    struct videobuf_buffer *vb)
>  {
> -	struct omap_vout_device *vout = q->priv_data;
> -
>  	vb->state = VIDEOBUF_NEEDS_INIT;
> +	if (vb->memory == V4L2_MEMORY_USERPTR && vb->priv) {
> +		struct frame_vector *vec = vb->priv;
> 
> -	if (V4L2_MEMORY_MMAP != vout->memory)
> -		return;
> +		put_vaddr_frames(vec);
> +		frame_vector_destroy(vec);
> +	}
>  }
> 
>  /*

-- 
Regards,

Laurent Pinchart

