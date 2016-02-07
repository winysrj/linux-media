Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61205 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbcBGNtT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 08:49:19 -0500
Date: Sun, 7 Feb 2016 14:48:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] mx3_camera: use %pad format string for dma_ddr_t
In-Reply-To: <1527735.0V0q3NFh2C@wuerfel>
Message-ID: <Pine.LNX.4.64.1602071446310.11458@axis700.grange>
References: <1527735.0V0q3NFh2C@wuerfel>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Mon, 1 Feb 2016, Arnd Bergmann wrote:

> The mx3_camera driver prints DMA addresses using the "%x" format
> string, which is wrong when using a 64-bit dma_addr_t definition:
> 
> media/platform/soc_camera/mx3_camera.c: In function 'mx3_cam_dma_done':
> media/platform/soc_camera/mx3_camera.c:149:125: error: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t {aka long long unsigned int}' [-Werror=format=]
> media/platform/soc_camera/mx3_camera.c: In function 'mx3_videobuf_queue':
> media/platform/soc_camera/mx3_camera.c:317:119: error: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t {aka long long unsigned int}' [-Werror=format=]
> media/platform/soc_camera/mx3_camera.c: In function 'mx3_videobuf_release':
> media/platform/soc_camera/mx3_camera.c:346:119: error: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t {aka long long unsigned int}' [-Werror=format=]
> 
> This changes the code to use the special %pad format string, which
> always does the right thing.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the patch. I'll queue it for 4.6.

Guennadi

> ---
> Another old bug that only rarely shows up in ARM randconfigs.
> 
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> index 169ed1150226..aa39e9569b1a 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -146,8 +146,8 @@ static void mx3_cam_dma_done(void *arg)
>  	struct idmac_channel *ichannel = to_idmac_chan(chan);
>  	struct mx3_camera_dev *mx3_cam = ichannel->client;
>  
> -	dev_dbg(chan->device->dev, "callback cookie %d, active DMA 0x%08x\n",
> -		desc->txd.cookie, mx3_cam->active ? sg_dma_address(&mx3_cam->active->sg) : 0);
> +	dev_dbg(chan->device->dev, "callback cookie %d, active DMA %pad\n",
> +		desc->txd.cookie, mx3_cam->active ? &sg_dma_address(&mx3_cam->active->sg) : NULL);
>  
>  	spin_lock(&mx3_cam->lock);
>  	if (mx3_cam->active) {
> @@ -314,8 +314,8 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
>  	spin_unlock_irq(&mx3_cam->lock);
>  
>  	cookie = txd->tx_submit(txd);
> -	dev_dbg(icd->parent, "Submitted cookie %d DMA 0x%08x\n",
> -		cookie, sg_dma_address(&buf->sg));
> +	dev_dbg(icd->parent, "Submitted cookie %d DMA %pad\n",
> +		cookie, &sg_dma_address(&buf->sg));
>  
>  	if (cookie >= 0)
>  		return;
> @@ -344,8 +344,8 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
>  	unsigned long flags;
>  
>  	dev_dbg(icd->parent,
> -		"Release%s DMA 0x%08x, queue %sempty\n",
> -		mx3_cam->active == buf ? " active" : "", sg_dma_address(&buf->sg),
> +		"Release%s DMA %pad, queue %sempty\n",
> +		mx3_cam->active == buf ? " active" : "", &sg_dma_address(&buf->sg),
>  		list_empty(&buf->queue) ? "" : "not ");
>  
>  	spin_lock_irqsave(&mx3_cam->lock, flags);
> 
