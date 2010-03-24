Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:57122 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab0CXFoI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 01:44:08 -0400
Message-ID: <4BA9A67A.3070004@maxwell.research.nokia.com>
Date: Wed, 24 Mar 2010 07:43:22 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Arnout Vandecappelle <arnout@mind.be>
CC: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen
References: <1268866385-15692-1-git-send-email-arnout@mind.be> <1268866385-15692-2-git-send-email-arnout@mind.be>
In-Reply-To: <1268866385-15692-2-git-send-email-arnout@mind.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnout,

Thanks for the patch.

Arnout Vandecappelle wrote:
> videobuf_pages_to_sg() and videobuf_vmalloc_to_sg() happen to create
> a scatterlist element for every page.  However, this is not true for
> bus addresses, so other functions shouldn't rely on the length of the
> scatter list being equal to nr_pages.
> ---
>  drivers/media/video/videobuf-dma-sg.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
> index da1790e..18aaf54 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -262,7 +262,7 @@ int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
>  	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
>  	BUG_ON(!dma->sglen);
>  
> -	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->nr_pages, dma->direction);
> +	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->sglen, dma->direction);
>  	return 0;
>  }

I think the same problem still exists --- dma->sglen is not initialised
anywhere, is it?

> @@ -272,7 +272,7 @@ int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
>  	if (!dma->sglen)
>  		return 0;
>  
> -	dma_unmap_sg(q->dev, dma->sglist, dma->nr_pages, dma->direction);
> +	dma_unmap_sg(q->dev, dma->sglist, dma->sglen, dma->direction);
>  
>  	kfree(dma->sglist);
>  	dma->sglist = NULL;


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
