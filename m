Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:35748 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HBIql (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 04:46:41 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so181896ead.17
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 01:46:39 -0700 (PDT)
Date: Fri, 2 Aug 2013 10:46:32 +0200
From: Andre Heider <a.heider@gmail.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as
 possible
Message-ID: <20130802084630.GA94492@gmail.com>
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

sorry for the late answer, but the leak I mentioned in my first reply is still there, see below.

On Fri, Jul 19, 2013 at 07:02:33PM +0200, Ricardo Ribalda Delgado wrote:
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
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-sg.c |   60 +++++++++++++++++++++++-----
>  1 file changed, 49 insertions(+), 11 deletions(-)
> 
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
> +
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
> +					return -ENOMEM;
> +				}

The return statement doesn't make sense in the while() scope, that way you wouldn't need the loop at all.

To prevent leaking pages of prior iterations (those with higher orders), pull the return out of there:

			while (last_page--)
				__free_page(buf->pages[last_page]);
			return -ENOMEM;

Regards,
Andre
