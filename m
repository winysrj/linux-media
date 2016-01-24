Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54307 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbcAXTcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 14:32:17 -0500
Date: Sun, 24 Jan 2016 20:31:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <rainyfeeling@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>, Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH 12/13] atmel-isi: use union for the fbd (frame buffer
 descriptor)
In-Reply-To: <1453121545-27528-8-git-send-email-rainyfeeling@gmail.com>
Message-ID: <Pine.LNX.4.64.1601241931430.16570@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-8-git-send-email-rainyfeeling@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jan 2016, Josh Wu wrote:

> From: Josh Wu <josh.wu@atmel.com>
> 
> This way, we can easy to add other type of fbd for new hardware.

Ok, I've applied all your 13 patches to check, what the resulting driver 
would look like. To me it looks like you really abstract away _everything_ 
remotely hardware-specific. What is left is yet another abstraction layer, 
into which you can pack a wide range of hardware types, which are very 
different from the original ISI. I mean, you could probably pack - to some 
extent, maybe sacrificing some features - other existing soc-camera 
drivers, like MX3, MX2, CEU,... - essentially those, using VB2. And I 
don't think that's a good idea. We have a class of V4L2 camera bridge 
drivers, that's fine. They use all the standard APIs to connect to the 
user-space and to other V4L2 drivers in video pipelines - V4L2 ioctl()s, 
subdev, Media Controller, VB2, V4L2 control API etc. Under that we have 
soc-camera - mainly for a few existing bridge drivers, because it takes a 
part of bridge driver's implementation freedom away and many or most 
modern camera bridge interfaces are more complex, than what soc-camera 
currently supports, and extending it makes little sense, it is just more 
logical to create a full-features V4L2 bridge driver with a full access to 
all relevant APIs. With your patches #12 and #13 you seem to be creating 
an even tighter, narrower API for very thin drivers. That just provide a 
couple of hardware-related functions and create a V4L2 bridge driver from 
that. What kind of hardware is that new controller, that you'd like to 
support by the same driver? Wouldn't it be better to create a new driver 
for it? Is it really similar to the ISI controller?

Thanks
Guennadi

> 
> Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 33 ++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 7d2e952..b4c1f38 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -37,7 +37,7 @@
>  #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
>  
>  /* Frame buffer descriptor */
> -struct fbd {
> +struct fbd_isi_v2 {
>  	/* Physical address of the frame buffer */
>  	u32 fb_address;
>  	/* DMA Control Register(only in HISI2) */
> @@ -46,9 +46,13 @@ struct fbd {
>  	u32 next_fbd_address;
>  };
>  
> +union fbd {
> +	struct fbd_isi_v2 fbd_isi;
> +};
> +
>  struct isi_dma_desc {
>  	struct list_head list;
> -	struct fbd *p_fbd;
> +	union fbd *p_fbd;
>  	dma_addr_t fbd_phys;
>  };
>  
> @@ -69,7 +73,7 @@ struct atmel_isi {
>  	struct vb2_alloc_ctx		*alloc_ctx;
>  
>  	/* Allocate descriptors for dma buffer use */
> -	struct fbd			*p_fb_descriptors;
> +	union fbd			*p_fb_descriptors;
>  	dma_addr_t			fb_descriptors_phys;
>  	struct				list_head dma_desc_head;
>  	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
> @@ -396,6 +400,16 @@ static int buffer_init(struct vb2_buffer *vb)
>  	return 0;
>  }
>  
> +static void isi_hw_init_dma_desc(union fbd *p_fdb, u32 fb_addr,
> +				 u32 next_fbd_addr)
> +{
> +	struct fbd_isi_v2 *p = &(p_fdb->fbd_isi);

Superfluous parentheses

> +
> +	p->fb_address = fb_addr;
> +	p->next_fbd_address = next_fbd_addr;
> +	p->dma_ctrl = ISI_DMA_CTRL_WB;
> +}
> +
>  static int buffer_prepare(struct vb2_buffer *vb)
>  {
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> @@ -428,10 +442,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
>  			list_del_init(&desc->list);
>  
>  			/* Initialize the dma descriptor */
> -			desc->p_fbd->fb_address =
> -					vb2_dma_contig_plane_dma_addr(vb, 0);
> -			desc->p_fbd->next_fbd_address = 0;
> -			desc->p_fbd->dma_ctrl = ISI_DMA_CTRL_WB;
> +			isi_hw_init_dma_desc(desc->p_fbd, vb2_dma_contig_plane_dma_addr(vb, 0), 0);
>  
>  			buf->p_dma_desc = desc;
>  		}
> @@ -923,7 +934,7 @@ static int atmel_isi_remove(struct platform_device *pdev)
>  	soc_camera_host_unregister(soc_host);
>  	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
>  	dma_free_coherent(&pdev->dev,
> -			sizeof(struct fbd) * MAX_BUFFER_NUM,
> +			sizeof(union fbd) * MAX_BUFFER_NUM,
>  			isi->p_fb_descriptors,
>  			isi->fb_descriptors_phys);
>  	pm_runtime_disable(&pdev->dev);
> @@ -1010,7 +1021,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&isi->dma_desc_head);
>  
>  	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
> -				sizeof(struct fbd) * MAX_BUFFER_NUM,
> +				sizeof(union fbd) * MAX_BUFFER_NUM,
>  				&isi->fb_descriptors_phys,
>  				GFP_KERNEL);
>  	if (!isi->p_fb_descriptors) {
> @@ -1021,7 +1032,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
>  	for (i = 0; i < MAX_BUFFER_NUM; i++) {
>  		isi->dma_desc[i].p_fbd = isi->p_fb_descriptors + i;
>  		isi->dma_desc[i].fbd_phys = isi->fb_descriptors_phys +
> -					i * sizeof(struct fbd);
> +					i * sizeof(union fbd);
>  		list_add(&isi->dma_desc[i].list, &isi->dma_desc_head);
>  	}
>  
> @@ -1080,7 +1091,7 @@ err_ioremap:
>  	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
>  err_alloc_ctx:
>  	dma_free_coherent(&pdev->dev,
> -			sizeof(struct fbd) * MAX_BUFFER_NUM,
> +			sizeof(union fbd) * MAX_BUFFER_NUM,
>  			isi->p_fb_descriptors,
>  			isi->fb_descriptors_phys);
>  
> -- 
> 1.9.1
> 
