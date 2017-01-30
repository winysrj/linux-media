Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36829 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752896AbdA3JoZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 04:44:25 -0500
Received: by mail-wm0-f67.google.com with SMTP id r18so4725444wmd.3
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2017 01:44:25 -0800 (PST)
Date: Mon, 30 Jan 2017 10:44:20 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Intel-gfx@lists.freedesktop.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Pawel Osciak <pawel@osciak.com>, linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        linux-media@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [Intel-gfx] [PATCH 1/4] lib/scatterlist: Fix offset type in
 sg_alloc_table_from_pages
Message-ID: <20170130094420.gf6ajmbt6jfk2m7h@phenom.ffwll.local>
References: <1484575930-6810-1-git-send-email-tvrtko.ursulin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484575930-6810-1-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Ok if we merge the entire series through drm-intel (likely for 4.12, 4.11
is getting a bit late)? We'd like to use this there, and Mauro already
reviewed the v4l side ...

Thanks, Daniel

On Mon, Jan 16, 2017 at 02:12:07PM +0000, Tvrtko Ursulin wrote:
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
> v2: Use offset_in_page. (Chris Wilson)
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
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> (v1)
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
>  drivers/rapidio/devices/rio_mport_cdev.c       | 4 ++--
>  include/linux/scatterlist.h                    | 2 +-
>  lib/scatterlist.c                              | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index fb6a177be461..51e8765bc3c6 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -478,7 +478,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>  {
>  	struct vb2_dc_buf *buf;
>  	struct frame_vector *vec;
> -	unsigned long offset;
> +	unsigned int offset;
>  	int n_pages, i;
>  	int ret = 0;
>  	struct sg_table *sgt;
> @@ -506,7 +506,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>  	buf->dev = dev;
>  	buf->dma_dir = dma_dir;
>  
> -	offset = vaddr & ~PAGE_MASK;
> +	offset = lower_32_bits(offset_in_page(vaddr));
>  	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
>  	if (IS_ERR(vec)) {
>  		ret = PTR_ERR(vec);
> diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
> index 9013a585507e..0fae29ff47ba 100644
> --- a/drivers/rapidio/devices/rio_mport_cdev.c
> +++ b/drivers/rapidio/devices/rio_mport_cdev.c
> @@ -876,10 +876,10 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
>  	 * offset within the internal buffer specified by handle parameter.
>  	 */
>  	if (xfer->loc_addr) {
> -		unsigned long offset;
> +		unsigned int offset;
>  		long pinned;
>  
> -		offset = (unsigned long)(uintptr_t)xfer->loc_addr & ~PAGE_MASK;
> +		offset = lower_32_bits(offset_in_page(xfer->loc_addr));
>  		nr_pages = PAGE_ALIGN(xfer->length + offset) >> PAGE_SHIFT;
>  
>  		page_list = kmalloc_array(nr_pages,
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index cb3c8fe6acd7..c981bee1a3ae 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -263,7 +263,7 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int,
>  int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
>  int sg_alloc_table_from_pages(struct sg_table *sgt,
>  	struct page **pages, unsigned int n_pages,
> -	unsigned long offset, unsigned long size,
> +	unsigned int offset, unsigned long size,
>  	gfp_t gfp_mask);
>  
>  size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 004fc70fc56a..e05e7fc98892 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -391,7 +391,7 @@ EXPORT_SYMBOL(sg_alloc_table);
>   */
>  int sg_alloc_table_from_pages(struct sg_table *sgt,
>  	struct page **pages, unsigned int n_pages,
> -	unsigned long offset, unsigned long size,
> +	unsigned int offset, unsigned long size,
>  	gfp_t gfp_mask)
>  {
>  	unsigned int chunks;
> -- 
> 2.7.4
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
