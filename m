Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57369 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbbFGTBs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 15:01:48 -0400
Date: Thu, 4 Jun 2015 13:20:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH 4/4] media: pxa_camera: conversion to dmaengine
In-Reply-To: <1426980085-12281-5-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1506041318210.15142@axis700.grange>
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
 <1426980085-12281-5-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

Please, correct me if I am wrong, but doesn't this patch have to be 
updates? Elgl looking at this:

On Sun, 22 Mar 2015, Robert Jarzmik wrote:

> From: Robert Jarzmik <robert.jarzmik@intel.com>
> 
> Convert pxa_camera to dmaengine. This removes all DMA registers
> manipulation in favor of the more generic dmaengine API.
> 
> The functional level should be the same as before. The biggest change is
> in the videobuf_sg_splice() function, which splits a videobuf-dma into
> several scatterlists for 3 planes captures (Y, U, V).
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 428 ++++++++++++-------------
>  1 file changed, 211 insertions(+), 217 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 8b39f44..8644022 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c

[snip]

> @@ -276,41 +271,82 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>  	if (buf->vb.state == VIDEOBUF_NEEDS_INIT)
>  		return;
>  
> -	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
> -		if (buf->dmas[i].sg_cpu)
> -			dma_free_coherent(ici->v4l2_dev.dev,
> -					  buf->dmas[i].sg_size,
> -					  buf->dmas[i].sg_cpu,
> -					  buf->dmas[i].sg_dma);
> -		buf->dmas[i].sg_cpu = NULL;
> +	for (i = 0; i < 3 && buf->descs[i]; i++) {
> +		async_tx_ack(buf->descs[i]);
> +		dmaengine_tx_release(buf->descs[i]);

hasn't the addition of your proposed dmaengine_tx_release() API been 
rejected? I'll wait for an updated version then.

Thanks
Guennadi
