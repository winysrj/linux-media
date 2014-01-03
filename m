Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3831 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaACOxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jan 2014 09:53:50 -0500
Message-ID: <52C6CEC6.8020602@xs4all.nl>
Date: Fri, 03 Jan 2014 15:52:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 2/2] videobuf2-dma-sg: Replace vb2_dma_sg_desc with
 sg_table
References: <1375453200-28459-1-git-send-email-ricardo.ribalda@gmail.com> <1375453200-28459-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1375453200-28459-3-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

I've run into a problem that is caused by this patch:

On 08/02/2013 04:20 PM, Ricardo Ribalda Delgado wrote:
> Replace the private struct vb2_dma_sg_desc with the struct sg_table so
> we can benefit from all the helping functions in lib/scatterlist.c for
> things like allocating the sg or compacting the descriptor
> 
> marvel-ccic and solo6x10 drivers, that uses this api has been updated
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Andre Heider <a.heider@gmail.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c    |   14 +--
>  drivers/media/v4l2-core/videobuf2-dma-sg.c         |  103 ++++++++------------
>  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   20 ++--
>  include/media/videobuf2-dma-sg.h                   |   10 +-
>  4 files changed, 63 insertions(+), 84 deletions(-)
> 

<snip>

> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 4999c48..2f86054 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c

<snip>

> @@ -99,17 +98,11 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
>  	buf->vaddr = NULL;
>  	buf->write = 0;
>  	buf->offset = 0;
> -	buf->sg_desc.size = size;
> +	buf->size = size;
>  	/* size is already page aligned */
> -	buf->sg_desc.num_pages = size >> PAGE_SHIFT;
> -
> -	buf->sg_desc.sglist = vzalloc(buf->sg_desc.num_pages *
> -				      sizeof(*buf->sg_desc.sglist));
> -	if (!buf->sg_desc.sglist)
> -		goto fail_sglist_alloc;
> -	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
> +	buf->num_pages = size >> PAGE_SHIFT;
>  
> -	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
> +	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
>  			     GFP_KERNEL);
>  	if (!buf->pages)
>  		goto fail_pages_array_alloc;
> @@ -118,6 +111,11 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
>  	if (ret)
>  		goto fail_pages_alloc;
>  
> +	ret = sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
> +			buf->num_pages, 0, size, gfp_flags);
> +	if (ret)
> +		goto fail_table_alloc;
> +
>  	buf->handler.refcount = &buf->refcount;
>  	buf->handler.put = vb2_dma_sg_put;
>  	buf->handler.arg = buf;

The problem here is the switch from sg_init_table to sg_alloc_table_from_pages. If
the PCI hardware only accepts 32-bit DMA transfers, but it is used on a 64-bit OS
with > 4GB physical memory, then the kernel will allocate DMA bounce buffers for you.

With sg_init_table that works fine since each page in the scatterlist maps to a
bounce buffer that is also just one page, but with sg_alloc_table_from_pages the DMA
bounce buffers can be multiple pages. This is in turn rounded up to the next power of
2 and allocated in the 32-bit address space. Unfortunately, due to memory fragmentation
this very quickly fails with -ENOMEM.

I discovered this while converting saa7134 to vb2. I think that when DMA bounce
buffers are needed, then it should revert to sg_init_table.

I don't know whether this bug also affects non-v4l drivers.

For now at least I won't try to fix this myself as I have discovered that dma-sg
doesn't work anyway for saa7134 due to a hardware limitation so I will switch to
dma-contig for that driver.

But at the very least I thought I should write this down so others know about this
subtle problem and perhaps someone else wants to tackle this.

I actually think that the solo driver is affected by this (I haven't tested it yet).
And at some point we need to convert bttv and cx88 to vb2 as well, and I expect that
they will hit the same problem.

If someone knows a better solution than switching to sg_init_table if bounce buffers
are needed, then let me know.

Regards,

	Hans
