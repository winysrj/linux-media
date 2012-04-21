Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48345 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2DUVOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 17:14:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: paul.gortmaker@windriver.com,
	=?utf-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
	amwang@redhat.com, dri-devel@lists.freedesktop.org,
	"'???/Mobile S/W Platform Lab.(???)/E3(??)/????'"
	<inki.dae@samsung.com>, prashanth.g@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Rob Clark <rob@ti.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] scatterlist: add sg_alloc_table_by_pages function
Date: Sat, 21 Apr 2012 22:09:10 +0200
Message-ID: <1814562.vqJLsJ8USJ@avalon>
In-Reply-To: <4F8E8D1B.7020901@samsung.com>
References: <4F8E8D1B.7020901@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Wednesday 18 April 2012 11:44:59 Tomasz Stanislawski wrote:
> This patch adds a new constructor for an sg table. The table is constructed
> from an array of struct pages. All contiguous chunks of the pages are merged
> into a single sg nodes. A user may provide an offset and a size of a buffer
> if the buffer is not page-aligned.
> 
> The function is dedicated for DMABUF exporters which often performs
> conversion from an page array to a scatterlist. Moreover the scatterlist
> should be squashed in order to save memory and to speed-up DMA mapping
> using dma_map_sg.
> 
> The code is based on the patch 'v4l: vb2-dma-contig: add support for
> scatterlist in userptr mode' and hints from Laurent Pinchart.

The patch looks good to me. Just a small comment, what do you think about 
naming the function sg_alloc_table_from_pages instead of 
sg_table_alloc_by_pages ?

> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/scatterlist.h |    4 +++
>  lib/scatterlist.c           |   63
> +++++++++++++++++++++++++++++++++++++++++++ 2 files changed, 67
> insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index ac9586d..8d9e6fe 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -214,6 +214,10 @@ void sg_free_table(struct sg_table *);
>  int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
>  		     sg_alloc_fn *);
>  int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
> +int sg_alloc_table_by_pages(struct sg_table *sgt,
> +	struct page **pages, unsigned int n_pages,
> +	unsigned long offset, unsigned long size,
> +	gfp_t gfp_mask);
>  size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
>  			   void *buf, size_t buflen);
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 6096e89..30b9def 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -319,6 +319,69 @@ int sg_alloc_table(struct sg_table *table, unsigned int
> nents, gfp_t gfp_mask) EXPORT_SYMBOL(sg_alloc_table);
> 
>  /**
> + * sg_alloc_table_by_pages - Allocate and initialize an sg table from an
> array + *			     of pages
> + * @sgt:	The sg table header to use
> + * @pages:	Pointer to an array of page pointers
> + * @n_pages:	Number of pages in the pages array
> + * @offset:     Offset from start of the first page to the start of a
> buffer + * @size:       Number of valid bytes in the buffer (after offset)
> + * @gfp_mask:	GFP allocation mask
> + *
> + *  Description:
> + *    Allocate and initialize an sg table from a list of pages. Continuous
> + *    ranges of the pages are squashed into a single scatterlist node. A
> user + *    may provide an offset at a start and a size of valid data in a
> buffer + *    specified by the page array. The returned sg table is
> released by + *    sg_free_table.
> + *
> + * Returns:
> + *   0 on success

Maybe you should mention what it returns in case of an error as well.

> + **/
> +int sg_alloc_table_by_pages(struct sg_table *sgt,
> +	struct page **pages, unsigned int n_pages,
> +	unsigned long offset, unsigned long size,
> +	gfp_t gfp_mask)
> +{
> +	unsigned int chunks;
> +	unsigned int i;
> +	unsigned int cur_page;
> +	int ret;
> +	struct scatterlist *s;
> +
> +	/* compute number of contiguous chunks */
> +	chunks = 1;
> +	for (i = 1; i < n_pages; ++i)
> +		if (pages[i] != pages[i - 1] + 1)
> +			++chunks;
> +
> +	ret = sg_alloc_table(sgt, chunks, gfp_mask);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	/* merging chunks and putting them into the scatterlist */
> +	cur_page = 0;
> +	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
> +		unsigned long chunk_size;
> +		unsigned int j;
> +
> +		/* looking for the end of the current chunk */
> +		for (j = cur_page + 1; j < n_pages; ++j)
> +			if (pages[j] != pages[j - 1] + 1)
> +				break;
> +
> +		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
> +		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
> +		size -= chunk_size;
> +		offset = 0;
> +		cur_page = j;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(sg_alloc_table_by_pages);
> +
> +/**
>   * sg_miter_start - start mapping iteration over a sg list
>   * @miter: sg mapping iter to be started
>   * @sgl: sg list to iterate over
-- 
Regards,

Laurent Pinchart

