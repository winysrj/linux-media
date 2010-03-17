Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:54553 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0CQU6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 16:58:04 -0400
Message-ID: <4BA1422E.4030601@maxwell.research.nokia.com>
Date: Wed, 17 Mar 2010 22:57:18 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Arnout Vandecappelle <arnout@mind.be>
CC: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen
References: <201003031512.45428.arnout@mind.be> <1267718451-24961-2-git-send-email-arnout@mind.be>
In-Reply-To: <1267718451-24961-2-git-send-email-arnout@mind.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnout,

Arnout Vandecappelle wrote:
> videobuf_pages_to_sg() and videobuf_vmalloc_to_sg() happen to create
> a scatterlist element for every page.  However, this is not true for
> bus addresses, so other functions shouldn't rely on the length of the
> scatter list being equal to nr_pages.
> ---
>  drivers/media/video/videobuf-dma-sg.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
> index da1790e..3b6f1b8 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -244,7 +244,7 @@ int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
>  	}
>  	if (!dma->bus_addr) {
>  		dma->sglen = dma_map_sg(q->dev, dma->sglist,
> -					dma->nr_pages, dma->direction);
> +					dma->sglen, dma->direction);
>  		if (0 == dma->sglen) {
>  			printk(KERN_WARNING
>  			       "%s: videobuf_map_sg failed\n",__func__);

Where is dma->sglen actually set?

videobuf_dma_map() is used in __videobuf_iolock
(drivers/media/video/videobuf-dma-sg.c) but neither
videobuf_dma_init_kernel() nor videobuf_dma_init_user() seem to set it.
This apparently leaves the value uninitialised.

I definitely think it should be assigned somewhere. :-)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
