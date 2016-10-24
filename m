Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23154 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbcJXHVj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 03:21:39 -0400
Subject: Re: [PATCH 1/5] lib/scatterlist: Fix offset type in
 sg_alloc_table_from_pages
To: Tvrtko Ursulin <tursulin@ursulin.net>,
        Intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <38b72c9f-e9a7-2d7e-dd93-2f79c7f6c2eb@samsung.com>
Date: Mon, 24 Oct 2016 09:21:34 +0200
MIME-version: 1.0
In-reply-to: <1477059083-3500-2-git-send-email-tvrtko.ursulin@linux.intel.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
 <CGME20161021141144eucas1p24cd984476554d06e4d45683bc8a60d0d@eucas1p2.samsung.com>
 <1477059083-3500-2-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tvrtko,


On 2016-10-21 16:11, Tvrtko Ursulin wrote:
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>
> Scatterlist entries have an unsigned int for the offset so
> correct the sg_alloc_table_from_pages function accordingly.
>
> Since these are offsets withing a page, unsigned int is
> wide enough.
>
> Also converts callers which were using unsigned long locally
> with the lower_32_bits annotation to make it explicitly
> clear what is happening.
>
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
>   drivers/rapidio/devices/rio_mport_cdev.c       | 4 ++--
>   include/linux/scatterlist.h                    | 2 +-
>   lib/scatterlist.c                              | 2 +-
>   4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index fb6a177be461..a3aac7533241 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -478,7 +478,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>   {
>   	struct vb2_dc_buf *buf;
>   	struct frame_vector *vec;
> -	unsigned long offset;
> +	unsigned int offset;
>   	int n_pages, i;
>   	int ret = 0;
>   	struct sg_table *sgt;
> @@ -506,7 +506,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>   	buf->dev = dev;
>   	buf->dma_dir = dma_dir;
>   
> -	offset = vaddr & ~PAGE_MASK;
> +	offset = lower_32_bits(vaddr & ~PAGE_MASK);
>   	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
>   	if (IS_ERR(vec)) {
>   		ret = PTR_ERR(vec);
> diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
> index 436dfe871d32..f545cf20561f 100644
> --- a/drivers/rapidio/devices/rio_mport_cdev.c
> +++ b/drivers/rapidio/devices/rio_mport_cdev.c
> @@ -876,10 +876,10 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
>   	 * offset within the internal buffer specified by handle parameter.
>   	 */
>   	if (xfer->loc_addr) {
> -		unsigned long offset;
> +		unsigned int offset;
>   		long pinned;
>   
> -		offset = (unsigned long)(uintptr_t)xfer->loc_addr & ~PAGE_MASK;
> +		offset = lower_32_bits(xfer->loc_addr & ~PAGE_MASK);
>   		nr_pages = PAGE_ALIGN(xfer->length + offset) >> PAGE_SHIFT;
>   
>   		page_list = kmalloc_array(nr_pages,
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index cb3c8fe6acd7..c981bee1a3ae 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -263,7 +263,7 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int,
>   int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
>   int sg_alloc_table_from_pages(struct sg_table *sgt,
>   	struct page **pages, unsigned int n_pages,
> -	unsigned long offset, unsigned long size,
> +	unsigned int offset, unsigned long size,
>   	gfp_t gfp_mask);
>   
>   size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 004fc70fc56a..e05e7fc98892 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -391,7 +391,7 @@ EXPORT_SYMBOL(sg_alloc_table);
>    */
>   int sg_alloc_table_from_pages(struct sg_table *sgt,
>   	struct page **pages, unsigned int n_pages,
> -	unsigned long offset, unsigned long size,
> +	unsigned int offset, unsigned long size,
>   	gfp_t gfp_mask)
>   {
>   	unsigned int chunks;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

