Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50042 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbbGLPOI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 11:14:08 -0400
Date: Sun, 12 Jul 2015 17:13:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH 1/4] media: pxa_camera: fix the buffer free path (fwd)
Message-ID: <Pine.LNX.4.64.1507121712310.32193@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

No idea why this mail hasn't been delivered... Sorry, resending.

Thanks
Guennadi

---------- Forwarded message ----------
Date: Sun, 31 May 2015 21:34:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/4] media: pxa_camera: fix the buffer free path

Hi Robert,

Thanks for the patch.

On Sun, 22 Mar 2015, Robert Jarzmik wrote:

> From: Robert Jarzmik <robert.jarzmik@intel.com>

free_buffer() is called from two locations: from the .buf_release() 
callback and on the error path in .buf_prepare(). In the first case it 
does the complete freeing of the buffers and DMA channels, in the latter 
case the error path, including buffer freeing can _only_ be entered if 
buffer allocation has been attempted, i.e. buffer state is 
VIDEOBUF_NEEDS_INIT. Which is exactly the case you're catching below. 
Following your patch, in this case free_buffer() shouldn't be called at 
all, because videobuf_waiton() isn't needed either. That can be achieved 
easier:

 fail_u:
 	dma_free_coherent(dev, buf->dmas[0].sg_size,
 			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
-fail:
-	free_buffer(vq, buf);
 out:
 	buf->inwork = 0;
 	return ret;

But tbh I don't understand why videobuf_dma_free() and 
videobuf_dma_unmap() shouldn't be called if videobuf_iolock() was 
successful, are you sure about that?

Thanks
Guennadi

> Fix the error path where the video buffer wasn't allocated nor
> mapped. In this case, in the driver free path don't try to unmap memory
> which was not mapped in the first place.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 8d6e343..3ca33f0 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -272,8 +272,8 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>  	 * longer in STATE_QUEUED or STATE_ACTIVE
>  	 */
>  	videobuf_waiton(vq, &buf->vb, 0, 0);
> -	videobuf_dma_unmap(vq->dev, dma);
> -	videobuf_dma_free(dma);
> +	if (buf->vb.state == VIDEOBUF_NEEDS_INIT)
> +		return;
>  
>  	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
>  		if (buf->dmas[i].sg_cpu)
> @@ -283,6 +283,8 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>  					  buf->dmas[i].sg_dma);
>  		buf->dmas[i].sg_cpu = NULL;
>  	}
> +	videobuf_dma_unmap(vq->dev, dma);
> +	videobuf_dma_free(dma);
>  
>  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>  }
> -- 
> 2.1.4
> 
