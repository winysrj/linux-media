Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52883 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933124AbcCHQv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 11:51:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org, Mark Brown <broonie@kernel.org>,
	linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/7] scatterlist: add sg_alloc_table_from_buf() helper
Date: Tue, 08 Mar 2016 18:51:49 +0200
Message-ID: <1932521.ciegjbjXWo@avalon>
In-Reply-To: <1457435715-24740-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com> <1457435715-24740-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Boris,

Thank you for the patch.

On Tuesday 08 March 2016 12:15:12 Boris Brezillon wrote:
> sg_alloc_table_from_buf() provides an easy solution to create an sg_table
> from a virtual address pointer. This function takes care of dealing with
> vmallocated buffers, buffer alignment, or DMA engine limitations (maximum
> DMA transfer size).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  include/linux/scatterlist.h |  24 ++++++++
>  lib/scatterlist.c           | 142 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 166 insertions(+)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 556ec1e..4a75362 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -41,6 +41,27 @@ struct sg_table {
>  	unsigned int orig_nents;	/* original size of list */
>  };
> 
> +/**
> + * struct sg_constraints - SG constraints structure
> + *
> + * @max_chunk_len: maximum chunk buffer length. Each SG entry has to be
> smaller
> + *		   than this value. Zero means no constraint.
> + * @required_alignment: minimum alignment. Is used for both size and
> pointer
> + *			alignment. If this constraint is not met, the function
> + *			should return -EINVAL.
> + * @preferred_alignment: preferred alignment. Mainly used to optimize
> + *			 throughput when the DMA engine performs better when
> + *			 doing aligned accesses.
> + *
> + * This structure is here to help sg_alloc_table_from_buf() create the
> optimal
> + * SG list based on DMA engine constraints.
> + */
> +struct sg_constraints {
> +	size_t max_chunk_len;
> +	size_t required_alignment;
> +	size_t preferred_alignment;
> +};
> +
>  /*
>   * Notes on SG table design.
>   *
> @@ -265,6 +286,9 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
>  	struct page **pages, unsigned int n_pages,
>  	unsigned long offset, unsigned long size,
>  	gfp_t gfp_mask);
> +int sg_alloc_table_from_buf(struct sg_table *sgt, const void *buf, size_t
> len,
> +			    const struct sg_constraints *constraints,
> +			    gfp_t gfp_mask);
> 
>  size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void
> *buf, size_t buflen, off_t skip, bool to_buffer);
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index bafa993..706b583 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -433,6 +433,148 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
>  }
>  EXPORT_SYMBOL(sg_alloc_table_from_pages);
> 
> +static size_t sg_buf_chunk_len(const void *buf, size_t len,
> +			       const struct sg_constraints *cons)
> +{
> +	size_t chunk_len = len;
> +
> +	if (cons->max_chunk_len)
> +		chunk_len = min_t(size_t, chunk_len, cons->max_chunk_len);
> +
> +	if (is_vmalloc_addr(buf))
> +		chunk_len = min_t(size_t, chunk_len,
> +				  PAGE_SIZE - offset_in_page(buf));

This will lead to page-sized scatter-gather entries even for pages of the 
vmalloc memory that happen to be physically contiguous. That works, but I 
wonder whether we'd want to be more efficient.

> +	if (!IS_ALIGNED((unsigned long)buf, cons->preferred_alignment)) {
> +		const void *aligned_buf = PTR_ALIGN(buf,
> +						    cons->preferred_alignment);
> +		size_t unaligned_len = (unsigned long)(aligned_buf - buf);
> +
> +		chunk_len = min_t(size_t, chunk_len, unaligned_len);
> +	} else if (chunk_len > cons->preferred_alignment) {
> +		chunk_len &= ~(cons->preferred_alignment - 1);
> +	}
> +
> +	return chunk_len;
> +}
> +
> +#define sg_for_each_chunk_in_buf(buf, len, chunk_len, constraints)	\
> +	for (chunk_len = sg_buf_chunk_len(buf, len, constraints);	\
> +	     len;							\
> +	     len -= chunk_len, buf += chunk_len,			\
> +	     chunk_len = sg_buf_chunk_len(buf, len, constraints))
> +
> +static int sg_check_constraints(struct sg_constraints *cons,
> +				const void *buf, size_t len)
> +{
> +	if (!cons->required_alignment)
> +		cons->required_alignment = 1;
> +
> +	if (!cons->preferred_alignment)
> +		cons->preferred_alignment = cons->required_alignment;
> +
> +	/* Test if buf and len are properly aligned. */
> +	if (!IS_ALIGNED((unsigned long)buf, cons->required_alignment) ||
> +	    !IS_ALIGNED(len, cons->required_alignment))
> +		return -EINVAL;
> +
> +	/*
> +	 * if the buffer has been vmallocated and required_alignment is
> +	 * more than PAGE_SIZE we cannot guarantee it.
> +	 */
> +	if (is_vmalloc_addr(buf) && cons->required_alignment > PAGE_SIZE)
> +		return -EINVAL;
> +
> +	/*
> +	 * max_chunk_len has to be aligned to required_alignment to
> +	 * guarantee that all buffer chunks are aligned correctly.
> +	 */
> +	if (!IS_ALIGNED(cons->max_chunk_len, cons->required_alignment))
> +		return -EINVAL;
> +
> +	/*
> +	 * preferred_alignment has to be aligned to required_alignment
> +	 * to avoid misalignment of buffer chunks.
> +	 */
> +	if (!IS_ALIGNED(cons->preferred_alignment, cons->required_alignment))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/**
> + * sg_alloc_table_from_buf - create an SG table from a buffer
> + *
> + * @sgt: SG table
> + * @buf: buffer you want to create this SG table from
> + * @len: length of buf
> + * @constraints: optional constraints to take into account when creating
> + *		 the SG table. Can be NULL if no specific constraints are
> + *		 required.
> + * @gfp_mask: type of allocation to use when creating the table
> + *
> + * This function creates an SG table from a buffer, its length and some
> + * SG constraints.
> + *
> + * Note: This function supports vmallocated buffers.

What other types of memory does it support ? kmalloc() quite obviously, are 
there others ? I think you should explicitly list the memory types that the 
function intends to support.

> + */
> +int sg_alloc_table_from_buf(struct sg_table *sgt, const void *buf, size_t
> len,
> +			    const struct sg_constraints *constraints,
> +			    gfp_t gfp_mask)
> +{
> +	struct sg_constraints cons = { };
> +	size_t remaining, chunk_len;
> +	const void *sg_buf;
> +	int i, ret;
> +
> +	if (constraints)
> +		cons = *constraints;
> +
> +	ret = sg_check_constraints(&cons, buf, len);
> +	if (ret)
> +		return ret;
> +
> +	sg_buf = buf;
> +	remaining = len;
> +	i = 0;
> +	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons)
> +		i++;
> +
> +	ret = sg_alloc_table(sgt, i, gfp_mask);
> +	if (ret)
> +		return ret;
> +
> +	sg_buf = buf;
> +	remaining = len;
> +	i = 0;
> +	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons) {
> +		if (is_vmalloc_addr(sg_buf)) {
> +			struct page *vm_page;
> +
> +			vm_page = vmalloc_to_page(sg_buf);
> +			if (!vm_page) {
> +				ret = -ENOMEM;
> +				goto err_free_table;
> +			}
> +
> +			sg_set_page(&sgt->sgl[i], vm_page, chunk_len,
> +				    offset_in_page(sg_buf));
> +		} else {
> +			sg_set_buf(&sgt->sgl[i], sg_buf, chunk_len);
> +		}
> +
> +		i++;
> +	}
> +
> +	return 0;
> +
> +err_free_table:
> +	sg_free_table(sgt);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(sg_alloc_table_from_buf);
> +
>  void __sg_page_iter_start(struct sg_page_iter *piter,
>  			  struct scatterlist *sglist, unsigned int nents,
>  			  unsigned long pgoffset)

-- 
Regards,

Laurent Pinchart

