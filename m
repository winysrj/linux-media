Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42443 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2DQAnj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 20:43:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH v4 08/14] v4l: vb2-dma-contig: add support for scatterlist in userptr mode
Date: Tue, 17 Apr 2012 02:43:50 +0200
Message-ID: <6297844.L9YCZPPyju@avalon>
In-Reply-To: <1334332076-28489-9-git-send-email-t.stanislaws@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-9-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 13 April 2012 17:47:50 Tomasz Stanislawski wrote:
> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> 
> This patch introduces usage of dma_map_sg to map memory behind
> a userspace pointer to a device as dma-contiguous mapping.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 	[bugfixing]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> 	[bugfixing]
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> 	[add sglist subroutines/code refactoring]
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |  287 +++++++++++++++++++++++--
>  1 files changed, 270 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 476e536..3a1e314 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c

[snip]

> +static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
> +	unsigned int n_pages, unsigned long offset, unsigned long size)
> +{
> +	struct sg_table *sgt;
> +	unsigned int chunks;
> +	unsigned int i;
> +	unsigned int cur_page;
> +	int ret;
> +	struct scatterlist *s;
> +	unsigned int offset_end = n_pages * PAGE_SIZE - size;

Shouldn't offset_end be equal to n_page * PAGE_SIZE - size - offset ?

> +	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
> +	if (!sgt)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* compute number of chunks */
> +	chunks = 1;
> +	for (i = 1; i < n_pages; ++i)
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
> +		size_t size = PAGE_SIZE;

This will shadow the size parameter, it's a bit confusing. You could rename it 
chunk_size.

> +		unsigned int j;
> +
> +		for (j = cur_page + 1; j < n_pages; ++j) {
> +			if (pages[j] != pages[j - 1] + 1)
> +				break;
> +			size += PAGE_SIZE;
> +		}

> +		/* cut offset if chunk starts at the first page */
> +		if (cur_page == 0)
> +			size -= offset;
> +		/* cut offset_end if chunk ends at the last page */
> +		if (j == n_pages)
> +			size -= offset_end;
> +
> +		sg_set_page(s, pages[cur_page], size, offset);
> +		offset = 0;

What about just

		chunk_size -= offset;
		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
		size -= chunk_size;
		offset = 0;

You could then remove the offset_end calculation above.

> +		cur_page = j;
> +	}
> +
> +	return sgt;
> +}

-- 
Regards,

Laurent Pinchart

