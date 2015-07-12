Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64448 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbbGLRGE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 13:06:04 -0400
Date: Sun, 12 Jul 2015 19:05:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] media: pxa_camera: conversion to dmaengine
In-Reply-To: <1436120872-24484-5-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1507121859030.32193@axis700.grange>
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
 <1436120872-24484-5-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sun, 5 Jul 2015, Robert Jarzmik wrote:

> Convert pxa_camera to dmaengine. This removes all DMA registers
> manipulation in favor of the more generic dmaengine API.
> 
> The functional level should be the same as before. The biggest change is
> in the videobuf_sg_splice() function, which splits a videobuf-dma into
> several scatterlists for 3 planes captures (Y, U, V).
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
> Since v1: Guennadi's fixes
>           dma tasklet functions prototypes change (trivial move)
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 438 ++++++++++++-------------
>  1 file changed, 215 insertions(+), 223 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 1ab4f9d..76b2b7b 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c

[snip]

> @@ -498,9 +499,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  
>  	if (vb->state == VIDEOBUF_NEEDS_INIT) {
>  		int size = vb->size;
> -		int next_ofs = 0;
>  		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
> -		struct scatterlist *sg;
>  
>  		ret = videobuf_iolock(vq, vb, NULL);
>  		if (ret)
> @@ -513,11 +512,9 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  			size_y = size;
>  		}
>  
> -		sg = dma->sglist;
> -
>  		/* init DMA for Y channel */

How about taking the loop over the sg list out of pxa_init_dma_channel() 
to avoid having to iterate it from the beginning each time? Then you would 
be able to split it into channels inside that global loop? Would that 
work? Of course you might need to rearrange functions to avoid too deep 
code nesting.

Thanks
Guennadi

> -		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
> -					   &sg, &next_ofs);
> +		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0,
> +					   size_y, 0);
>  		if (ret) {
>  			dev_err(dev, "DMA initialization for Y/RGB failed\n");
>  			goto fail;
> @@ -526,19 +523,19 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  		/* init DMA for U channel */
>  		if (size_u)
>  			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
> -						   size_u, &sg, &next_ofs);
> +						   size_u, size_y);
>  		if (ret) {
>  			dev_err(dev, "DMA initialization for U failed\n");
> -			goto fail_u;
> +			goto fail;
>  		}
>  
>  		/* init DMA for V channel */
>  		if (size_v)
>  			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
> -						   size_v, &sg, &next_ofs);
> +						   size_v, size_y + size_u);
>  		if (ret) {
>  			dev_err(dev, "DMA initialization for V failed\n");
> -			goto fail_v;
> +			goto fail;
>  		}
>  
>  		vb->state = VIDEOBUF_PREPARED;
> @@ -549,12 +546,6 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  
>  	return 0;
>  
> -fail_v:
> -	dma_free_coherent(dev, buf->dmas[1].sg_size,
> -			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
> -fail_u:
> -	dma_free_coherent(dev, buf->dmas[0].sg_size,
> -			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
>  fail:
>  	free_buffer(vq, buf);
>  out:
