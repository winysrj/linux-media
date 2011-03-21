Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:58669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1CUKrM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 06:47:12 -0400
Date: Mon, 21 Mar 2011 11:47:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pawel Osciak <pawel@osciak.com>
cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 2/2] [media] videobuf2-dma-contig: make cookie() return
 a pointer to dma_addr_t
In-Reply-To: <1300109904-3991-2-git-send-email-pawel@osciak.com>
Message-ID: <Pine.LNX.4.64.1103211139560.21013@axis700.grange>
References: <1300109904-3991-1-git-send-email-pawel@osciak.com>
 <1300109904-3991-2-git-send-email-pawel@osciak.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 14 Mar 2011, Pawel Osciak wrote:

> dma_addr_t may not fit into void* on some architectures. To be safe, make
> vb2_dma_contig_cookie() return a pointer to dma_addr_t and dereference it
> in vb2_dma_contig_plane_paddr() back to dma_addr_t.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>

Right, it is correct, that this patch is submitted as "2/2" with 
"sh_mobile_ceu_camera: Do not call vb2's mem_ops directly" being "1/2." 
The only slight difficulty is, that this patch should go directly to 
Mauro or via some vb2 tree, if one exists, whereas "1/2" I would normally 
take via my tree. Hence the question: should I take them both via my tree, 
or should I only take "1/2" and we take care to merge this one after it? 
Assuming, there are no objections against this one.

Thanks
Guennadi

> ---
>  drivers/media/video/videobuf2-dma-contig.c |    2 +-
>  include/media/videobuf2-dma-contig.h       |    9 ++++++---
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
> index 90495b7..58205d5 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -78,7 +78,7 @@ static void *vb2_dma_contig_cookie(void *buf_priv)
>  {
>  	struct vb2_dc_buf *buf = buf_priv;
>  
> -	return (void *)buf->paddr;
> +	return &buf->paddr;
>  }
>  
>  static void *vb2_dma_contig_vaddr(void *buf_priv)
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index 1d6188d..7e6c68b 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -14,11 +14,14 @@
>  #define _MEDIA_VIDEOBUF2_DMA_COHERENT_H
>  
>  #include <media/videobuf2-core.h>
> +#include <linux/dma-mapping.h>
>  
> -static inline unsigned long vb2_dma_contig_plane_paddr(
> -		struct vb2_buffer *vb, unsigned int plane_no)
> +static inline dma_addr_t
> +vb2_dma_contig_plane_paddr(struct vb2_buffer *vb, unsigned int plane_no)
>  {
> -	return (unsigned long)vb2_plane_cookie(vb, plane_no);
> +	dma_addr_t *paddr = vb2_plane_cookie(vb, plane_no);
> +
> +	return *paddr;
>  }
>  
>  void *vb2_dma_contig_init_ctx(struct device *dev);
> -- 
> 1.7.4.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
