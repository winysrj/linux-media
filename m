Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49768 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab2EGOih (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 10:38:37 -0400
Message-ID: <4FA7DE61.7000705@gmail.com>
Date: Mon, 07 May 2012 20:08:25 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCHv5 08/13] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com> <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Thomasz, Laurent,

I found an issue in the function vb2_dc_pages_to_sgt() below. I saw that 
during the attach, the size of the SGT and size requested mis-matched 
(by atleast 8k bytes). Hence I made a small correction to the code as 
below. I could then attach the importer properly.

Regards,
Subash

On 04/20/2012 08:15 PM, Tomasz Stanislawski wrote:
> From: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
>
> This patch introduces usage of dma_map_sg to map memory behind
> a userspace pointer to a device as dma-contiguous mapping.
>
> Signed-off-by: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
> Signed-off-by: Marek Szyprowski<m.szyprowski@samsung.com>
> 	[bugfixing]
> Signed-off-by: Kamil Debski<k.debski@samsung.com>
> 	[bugfixing]
> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
> 	[add sglist subroutines/code refactoring]
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   drivers/media/video/videobuf2-dma-contig.c |  279 ++++++++++++++++++++++++++--
>   1 files changed, 262 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
> index 476e536..9cbc8d4 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -11,6 +11,8 @@
>    */
>
>   #include<linux/module.h>
> +#include<linux/scatterlist.h>
> +#include<linux/sched.h>
>   #include<linux/slab.h>
>   #include<linux/dma-mapping.h>
>
> @@ -22,6 +24,8 @@ struct vb2_dc_buf {
>   	void				*vaddr;
>   	unsigned long			size;
>   	dma_addr_t			dma_addr;
> +	enum dma_data_direction		dma_dir;
> +	struct sg_table			*dma_sgt;
>
>   	/* MMAP related */
>   	struct vb2_vmarea_handler	handler;
> @@ -32,6 +36,95 @@ struct vb2_dc_buf {
>   };
>
>   /*********************************************/
> +/*        scatterlist table functions        */
> +/*********************************************/
> +
> +static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
> +	unsigned int n_pages, unsigned long offset, unsigned long size)
> +{
> +	struct sg_table *sgt;
> +	unsigned int chunks;
> +	unsigned int i;
> +	unsigned int cur_page;
> +	int ret;
> +	struct scatterlist *s;
> +
> +	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
> +	if (!sgt)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* compute number of chunks */
> +	chunks = 1;
> +	for (i = 1; i<  n_pages; ++i)
> +		if (pages[i] != pages[i - 1] + 1)
> +			++chunks;
> +
> +	ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
> +	if (ret) {
> +		kfree(sgt);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* merging chunks and putting them into the scatterlist */
> +	cur_page = 0;
> +	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
> +		unsigned long chunk_size;
> +		unsigned int j;
		size = PAGE_SIZE;

> +
> +		for (j = cur_page + 1; j<  n_pages; ++j)
		for (j = cur_page + 1; j < n_pages; ++j) {
> +			if (pages[j] != pages[j - 1] + 1)
> +				break;
			size += PAGE
		}
> +
> +		chunk_size = ((j - cur_page)<<  PAGE_SHIFT) - offset;
> +		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
		[DELETE] size -= chunk_size;
> +		offset = 0;
> +		cur_page = j;
> +	}
> +
> +	return sgt;
> +}
> +
> +static void vb2_dc_release_sgtable(struct sg_table *sgt)
> +{
> +	sg_free_table(sgt);
> +	kfree(sgt);
> +}
> +
> +static void vb2_dc_sgt_foreach_page(struct sg_table *sgt,
> +	void (*cb)(struct page *pg))
> +{
> +	struct scatterlist *s;
> +	unsigned int i;
> +
> +	for_each_sg(sgt->sgl, s, sgt->nents, i) {
> +		struct page *page = sg_page(s);
> +		unsigned int n_pages = PAGE_ALIGN(s->offset + s->length)
> +			>>  PAGE_SHIFT;
> +		unsigned int j;
> +
> +		for (j = 0; j<  n_pages; ++j, ++page)
> +			cb(page);
> +	}
> +}
> +
> +static unsigned long vb2_dc_get_contiguous_size(struct sg_table *sgt)
> +{
> +	struct scatterlist *s;
> +	dma_addr_t expected = sg_dma_address(sgt->sgl);
> +	unsigned int i;
> +	unsigned long size = 0;
> +
> +	for_each_sg(sgt->sgl, s, sgt->nents, i) {
> +		if (sg_dma_address(s) != expected)
> +			break;
> +		expected = sg_dma_address(s) + sg_dma_len(s);
> +		size += sg_dma_len(s);
> +	}
> +	return size;
> +}
> +
> +/*********************************************/
>   /*         callbacks for all buffers         */
>   /*********************************************/
>
> @@ -116,42 +209,194 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
>   /*       callbacks for USERPTR buffers       */
>   /*********************************************/
>
> +static inline int vma_is_io(struct vm_area_struct *vma)
> +{
> +	return !!(vma->vm_flags&  (VM_IO | VM_PFNMAP));
> +}
> +
> +static struct vm_area_struct *vb2_dc_get_user_vma(
> +	unsigned long start, unsigned long size)
> +{
> +	struct vm_area_struct *vma;
> +
> +	/* current->mm->mmap_sem is taken by videobuf2 core */
> +	vma = find_vma(current->mm, start);
> +	if (!vma) {
> +		printk(KERN_ERR "no vma for address %lu\n", start);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	if (vma->vm_end - vma->vm_start<  size) {
> +		printk(KERN_ERR "vma at %lu is too small for %lu bytes\n",
> +			start, size);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	vma = vb2_get_vma(vma);
> +	if (!vma) {
> +		printk(KERN_ERR "failed to copy vma\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	return vma;
> +}
> +
> +static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
> +	int n_pages, struct vm_area_struct *vma, int write)
> +{
> +	if (vma_is_io(vma)) {
> +		unsigned int i;
> +
> +		for (i = 0; i<  n_pages; ++i, start += PAGE_SIZE) {
> +			unsigned long pfn;
> +			int ret = follow_pfn(vma, start,&pfn);
> +
> +			if (ret) {
> +				printk(KERN_ERR "no page for address %lu\n",
> +					start);
> +				return ret;
> +			}
> +			pages[i] = pfn_to_page(pfn);
> +		}
> +	} else {
> +		unsigned int n;
> +
> +		n = get_user_pages(current, current->mm, start&  PAGE_MASK,
> +			n_pages, write, 1, pages, NULL);
> +		if (n != n_pages) {
> +			printk(KERN_ERR "got only %d of %d user pages\n",
> +				n, n_pages);
> +			while (n)
> +				put_page(pages[--n]);
> +			return -EFAULT;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void vb2_dc_put_dirty_page(struct page *page)
> +{
> +	set_page_dirty_lock(page);
> +	put_page(page);
> +}
> +
> +static void vb2_dc_put_userptr(void *buf_priv)
> +{
> +	struct vb2_dc_buf *buf = buf_priv;
> +	struct sg_table *sgt = buf->dma_sgt;
> +
> +	dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> +	if (!vma_is_io(buf->vma))
> +		vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
> +
> +	vb2_dc_release_sgtable(sgt);
> +	vb2_put_vma(buf->vma);
> +	kfree(buf);
> +}
> +
>   static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> -					unsigned long size, int write)
> +	unsigned long size, int write)
>   {
>   	struct vb2_dc_buf *buf;
> -	struct vm_area_struct *vma;
> -	dma_addr_t dma_addr = 0;
> -	int ret;
> +	unsigned long start;
> +	unsigned long end;
> +	unsigned long offset;
> +	struct page **pages;
> +	int n_pages;
> +	int ret = 0;
> +	struct sg_table *sgt;
> +	unsigned long contig_size;
>
>   	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>   	if (!buf)
>   		return ERR_PTR(-ENOMEM);
>
> -	ret = vb2_get_contig_userptr(vaddr, size,&vma,&dma_addr);
> +	buf->dev = alloc_ctx;
> +	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +
> +	start = vaddr&  PAGE_MASK;
> +	offset = vaddr&  ~PAGE_MASK;
> +	end = PAGE_ALIGN(vaddr + size);
> +	n_pages = (end - start)>>  PAGE_SHIFT;
> +
> +	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
> +	if (!pages) {
> +		ret = -ENOMEM;
> +		printk(KERN_ERR "failed to allocate pages table\n");
> +		goto fail_buf;
> +	}
> +
> +	buf->vma = vb2_dc_get_user_vma(start, size);
> +	if (IS_ERR(buf->vma)) {
> +		printk(KERN_ERR "failed to get VMA\n");
> +		ret = PTR_ERR(buf->vma);
> +		goto fail_pages;
> +	}
> +
> +	/* extract page list from userspace mapping */
> +	ret = vb2_dc_get_user_pages(start, pages, n_pages, buf->vma, write);
>   	if (ret) {
> -		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
> -				vaddr);
> -		kfree(buf);
> -		return ERR_PTR(ret);
> +		printk(KERN_ERR "failed to get user pages\n");
> +		goto fail_vma;
> +	}
> +
> +	sgt = vb2_dc_pages_to_sgt(pages, n_pages, offset, size);
> +	if (IS_ERR(sgt)) {
> +		printk(KERN_ERR "failed to create scatterlist table\n");
> +		ret = -ENOMEM;
> +		goto fail_get_user_pages;
> +	}
> +
> +	/* pages are no longer needed */
> +	kfree(pages);
> +	pages = NULL;
> +
> +	sgt->nents = dma_map_sg(buf->dev, sgt->sgl, sgt->orig_nents,
> +		buf->dma_dir);
> +	if (sgt->nents<= 0) {
> +		printk(KERN_ERR "failed to map scatterlist\n");
> +		ret = -EIO;
> +		goto fail_sgt;
>   	}
>
> +	contig_size = vb2_dc_get_contiguous_size(sgt);
> +	if (contig_size<  size) {
> +		printk(KERN_ERR "contiguous mapping is too small %lu/%lu\n",
> +			contig_size, size);
> +		ret = -EFAULT;
> +		goto fail_map_sg;
> +	}
> +
> +	buf->dma_addr = sg_dma_address(sgt->sgl);
>   	buf->size = size;
> -	buf->dma_addr = dma_addr;
> -	buf->vma = vma;
> +	buf->dma_sgt = sgt;
>
>   	return buf;
> -}
>
> -static void vb2_dc_put_userptr(void *mem_priv)
> -{
> -	struct vb2_dc_buf *buf = mem_priv;
> +fail_map_sg:
> +	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>
> -	if (!buf)
> -		return;
> +fail_sgt:
> +	if (!vma_is_io(buf->vma))
> +		vb2_dc_sgt_foreach_page(sgt, put_page);
> +	vb2_dc_release_sgtable(sgt);
> +
> +fail_get_user_pages:
> +	if (pages&&  !vma_is_io(buf->vma))
> +		while (n_pages)
> +			put_page(pages[--n_pages]);
>
> +fail_vma:
>   	vb2_put_vma(buf->vma);
> +
> +fail_pages:
> +	kfree(pages); /* kfree is NULL-proof */
> +
> +fail_buf:
>   	kfree(buf);
> +
> +	return ERR_PTR(ret);
>   }
>
>   /*********************************************/
