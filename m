Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41081 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3GSUQG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 16:16:06 -0400
Date: Fri, 19 Jul 2013 14:16:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as
 possible
Message-ID: <20130719141603.16ef8f0b@lwn.net>
In-Reply-To: <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
	<1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 19 Jul 2013 19:02:33 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:

> Most DMA engines have limitations regarding the number of DMA segments
> (sg-buffers) that they can handle. Videobuffers can easily spread
> through houndreds of pages.
> 
> In the previous aproach, the pages were allocated individually, this
> could led to the creation houndreds of dma segments (sg-buffers) that
> could not be handled by some DMA engines.
> 
> This patch tries to minimize the number of DMA segments by using
> alloc_pages. In the worst case it will behave as before, but most
> of the times it will reduce the number of dma segments

So I looked this over and I have a few questions...

> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 16ae3dc..c053605 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -42,10 +42,55 @@ struct vb2_dma_sg_buf {
>  
>  static void vb2_dma_sg_put(void *buf_priv);
>  
> +static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
> +		gfp_t gfp_flags)
> +{
> +	unsigned int last_page = 0;
> +	int size = buf->sg_desc.size;
> +
> +	while (size > 0) {
> +		struct page *pages;
> +		int order;
> +		int i;
> +
> +		order = get_order(size);
> +		/* Dont over allocate*/
> +		if ((PAGE_SIZE << order) > size)
> +			order--;

Terrible things will happen if size < PAGE_SIZE.  Presumably that should
never happen, or perhaps one could say any caller who does that will get
what they deserve.

Have you considered alloc_pages_exact(), though?  That might result in
fewer segments overall.

> +		pages = NULL;
> +		while (!pages) {
> +			pages = alloc_pages(GFP_KERNEL | __GFP_ZERO |
> +					__GFP_NOWARN | gfp_flags, order);
> +			if (pages)
> +				break;
> +
> +			if (order == 0)
> +				while (last_page--) {
> +					__free_page(buf->pages[last_page]);

If I understand things, this is wrong; you relly need free_pages() with the
correct order.  Or, at least, that would be the case if you kept the pages
together, but that leads to my biggest question...

> +					return -ENOMEM;
> +				}
> +			order--;
> +		}
> +
> +		split_page(pages, order);
> +		for (i = 0; i < (1<<order); i++) {
> +			buf->pages[last_page] = pages[i];
> +			sg_set_page(&buf->sg_desc.sglist[last_page],
> +					buf->pages[last_page], PAGE_SIZE, 0);
> +			last_page++;
> +		}

You've gone to all this trouble to get a higher-order allocation so you'd
have fewer segments, then you undo it all by splitting things apart into
individual pages.  Why?  Clearly I'm missing something, this seems to
defeat the purpose of the whole exercise?

Thanks,

jon
