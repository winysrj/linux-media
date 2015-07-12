Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56623 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbbGLN6W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 09:58:22 -0400
Date: Sun, 12 Jul 2015 15:58:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH v2 1/4] media: pxa_camera: fix the buffer free path
In-Reply-To: <1436120872-24484-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1507121557210.32193@axis700.grange>
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
 <1436120872-24484-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sun, 5 Jul 2015, Robert Jarzmik wrote:

> From: Robert Jarzmik <robert.jarzmik@intel.com>
> 
> Fix the error path where the video buffer wasn't allocated nor
> mapped. In this case, in the driver free path don't try to unmap memory
> which was not mapped in the first place.

Have I missed your reply to my comments to v1 of this patch? This one 
seems to be its exact copy?

Thanks
Guennadi

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
