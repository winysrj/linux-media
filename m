Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3HWVQy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 17:16:54 -0400
Date: Fri, 23 Aug 2013 23:16:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] mx3-camera: locking typo in mx3_videobuf_queue()
In-Reply-To: <20130823094530.GN31293@elgon.mountain>
Message-ID: <Pine.LNX.4.64.1308232313220.14796@axis700.grange>
References: <20130823094530.GN31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Fri, 23 Aug 2013, Dan Carpenter wrote:

> There is a return in the middle where we haven't restored the IRQs to
> their original state.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> index 1047e3e..4bae910 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -334,7 +334,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
>  	if (!mx3_cam->active)
>  		mx3_cam->active = buf;
>  
> -	spin_unlock_irq(&mx3_cam->lock);
> +	spin_unlock_irqrestore(&mx3_cam->lock, flags);
>  
>  	cookie = txd->tx_submit(txd);
>  	dev_dbg(icd->parent, "Submitted cookie %d DMA 0x%08x\n",

Please, wait with this. The above doesn't seem quite right to me. IIRC, 
the purpose of unlock_irq(), i.e. of the unconditionally enabling IRQs was 
to make sure ->tx_submit() is called with interrupts enabled. I'm 
currently on holiday with very scarce internet access. Either please 
double-check this yourself or I'll have another look at it when back home 
next week.

Thanks
Guennadi

> @@ -343,7 +343,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
>  	if (cookie >= 0)
>  		return;
>  
> -	spin_lock_irq(&mx3_cam->lock);
> +	spin_lock_irqsave(&mx3_cam->lock, flags);
>  
>  	/* Submit error */
>  	list_del_init(&buf->queue);
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
