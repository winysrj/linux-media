Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:48983 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932533AbcCHQ5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 11:57:20 -0500
Date: Tue, 8 Mar 2016 17:57:15 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	devicetree@vger.kernel.org
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
	Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 4/7] scatterlist: add sg_alloc_table_from_buf() helper
Message-ID: <20160308175715.44245676@bbrezillon>
In-Reply-To: <1932521.ciegjbjXWo@avalon>
References: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
	<1457435715-24740-5-git-send-email-boris.brezillon@free-electrons.com>
	<1932521.ciegjbjXWo@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, 08 Mar 2016 18:51:49 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Boris,
> 
> Thank you for the patch.
> 
> On Tuesday 08 March 2016 12:15:12 Boris Brezillon wrote:
> > sg_alloc_table_from_buf() provides an easy solution to create an sg_table
> > from a virtual address pointer. This function takes care of dealing with
> > vmallocated buffers, buffer alignment, or DMA engine limitations (maximum
> > DMA transfer size).
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  include/linux/scatterlist.h |  24 ++++++++
> >  lib/scatterlist.c           | 142 +++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 166 insertions(+)
> > 
> > diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> > index 556ec1e..4a75362 100644
> > --- a/include/linux/scatterlist.h
> > +++ b/include/linux/scatterlist.h
> > @@ -41,6 +41,27 @@ struct sg_table {
> >  	unsigned int orig_nents;	/* original size of list */
> >  };
> > 
> > +/**
> > + * struct sg_constraints - SG constraints structure
> > + *
> > + * @max_chunk_len: maximum chunk buffer length. Each SG entry has to be
> > smaller
> > + *		   than this value. Zero means no constraint.
> > + * @required_alignment: minimum alignment. Is used for both size and
> > pointer
> > + *			alignment. If this constraint is not met, the function
> > + *			should return -EINVAL.
> > + * @preferred_alignment: preferred alignment. Mainly used to optimize
> > + *			 throughput when the DMA engine performs better when
> > + *			 doing aligned accesses.
> > + *
> > + * This structure is here to help sg_alloc_table_from_buf() create the
> > optimal
> > + * SG list based on DMA engine constraints.
> > + */
> > +struct sg_constraints {
> > +	size_t max_chunk_len;
> > +	size_t required_alignment;
> > +	size_t preferred_alignment;
> > +};
> > +
> >  /*
> >   * Notes on SG table design.
> >   *
> > @@ -265,6 +286,9 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
> >  	struct page **pages, unsigned int n_pages,
> >  	unsigned long offset, unsigned long size,
> >  	gfp_t gfp_mask);
> > +int sg_alloc_table_from_buf(struct sg_table *sgt, const void *buf, size_t
> > len,
> > +			    const struct sg_constraints *constraints,
> > +			    gfp_t gfp_mask);
> > 
> >  size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void
> > *buf, size_t buflen, off_t skip, bool to_buffer);
> > diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> > index bafa993..706b583 100644
> > --- a/lib/scatterlist.c
> > +++ b/lib/scatterlist.c
> > @@ -433,6 +433,148 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
> >  }
> >  EXPORT_SYMBOL(sg_alloc_table_from_pages);
> > 
> > +static size_t sg_buf_chunk_len(const void *buf, size_t len,
> > +			       const struct sg_constraints *cons)
> > +{
> > +	size_t chunk_len = len;
> > +
> > +	if (cons->max_chunk_len)
> > +		chunk_len = min_t(size_t, chunk_len, cons->max_chunk_len);
> > +
> > +	if (is_vmalloc_addr(buf))
> > +		chunk_len = min_t(size_t, chunk_len,
> > +				  PAGE_SIZE - offset_in_page(buf));
> 
> This will lead to page-sized scatter-gather entries even for pages of the 
> vmalloc memory that happen to be physically contiguous. That works, but I 
> wonder whether we'd want to be more efficient.

Hm, I thought dma_map_sg() was taking care of merging pĥysically
contiguous memory regions, but maybe I'm wrong. Anyway, that's
definitely something I can add at this level.

> 
> > +	if (!IS_ALIGNED((unsigned long)buf, cons->preferred_alignment)) {
> > +		const void *aligned_buf = PTR_ALIGN(buf,
> > +						    cons->preferred_alignment);
> > +		size_t unaligned_len = (unsigned long)(aligned_buf - buf);
> > +
> > +		chunk_len = min_t(size_t, chunk_len, unaligned_len);
> > +	} else if (chunk_len > cons->preferred_alignment) {
> > +		chunk_len &= ~(cons->preferred_alignment - 1);
> > +	}
> > +
> > +	return chunk_len;
> > +}
> > +
> > +#define sg_for_each_chunk_in_buf(buf, len, chunk_len, constraints)	\
> > +	for (chunk_len = sg_buf_chunk_len(buf, len, constraints);	\
> > +	     len;							\
> > +	     len -= chunk_len, buf += chunk_len,			\
> > +	     chunk_len = sg_buf_chunk_len(buf, len, constraints))
> > +
> > +static int sg_check_constraints(struct sg_constraints *cons,
> > +				const void *buf, size_t len)
> > +{
> > +	if (!cons->required_alignment)
> > +		cons->required_alignment = 1;
> > +
> > +	if (!cons->preferred_alignment)
> > +		cons->preferred_alignment = cons->required_alignment;
> > +
> > +	/* Test if buf and len are properly aligned. */
> > +	if (!IS_ALIGNED((unsigned long)buf, cons->required_alignment) ||
> > +	    !IS_ALIGNED(len, cons->required_alignment))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * if the buffer has been vmallocated and required_alignment is
> > +	 * more than PAGE_SIZE we cannot guarantee it.
> > +	 */
> > +	if (is_vmalloc_addr(buf) && cons->required_alignment > PAGE_SIZE)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * max_chunk_len has to be aligned to required_alignment to
> > +	 * guarantee that all buffer chunks are aligned correctly.
> > +	 */
> > +	if (!IS_ALIGNED(cons->max_chunk_len, cons->required_alignment))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * preferred_alignment has to be aligned to required_alignment
> > +	 * to avoid misalignment of buffer chunks.
> > +	 */
> > +	if (!IS_ALIGNED(cons->preferred_alignment, cons->required_alignment))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * sg_alloc_table_from_buf - create an SG table from a buffer
> > + *
> > + * @sgt: SG table
> > + * @buf: buffer you want to create this SG table from
> > + * @len: length of buf
> > + * @constraints: optional constraints to take into account when creating
> > + *		 the SG table. Can be NULL if no specific constraints are
> > + *		 required.
> > + * @gfp_mask: type of allocation to use when creating the table
> > + *
> > + * This function creates an SG table from a buffer, its length and some
> > + * SG constraints.
> > + *
> > + * Note: This function supports vmallocated buffers.
> 
> What other types of memory does it support ? kmalloc() quite obviously, are 
> there others ? I think you should explicitly list the memory types that the 
> function intends to support.

Sure, I can explicitly list all memory types. Do you see any other kind
of memory other than the vmalloced and physically-contiguous ones?

Thanks for your review.

Boris
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
