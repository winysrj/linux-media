Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56078 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLPLAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 06:00:48 -0500
Message-id: <549010DC.2090206@samsung.com>
Date: Tue, 16 Dec 2014 12:00:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Hans Verkuil <hansverk@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] vb2-vmalloc: Protect DMA-specific code by #ifdef
 CONFIG_HAS_DMA
References: <1418650828-28562-1-git-send-email-geert@linux-m68k.org>
In-reply-to: <1418650828-28562-1-git-send-email-geert@linux-m68k.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-12-15 14:40, Geert Uytterhoeven wrote:
> If NO_DMA=y:
>
> drivers/built-in.o: In function `vb2_vmalloc_dmabuf_ops_detach':
> videobuf2-vmalloc.c:(.text+0x6f11b0): undefined reference to `dma_unmap_sg'
> drivers/built-in.o: In function `vb2_vmalloc_dmabuf_ops_map':
> videobuf2-vmalloc.c:(.text+0x6f1266): undefined reference to `dma_unmap_sg'
> videobuf2-vmalloc.c:(.text+0x6f1282): undefined reference to `dma_map_sg'
>
> As we don't want to make the core VIDEOBUF2_VMALLOC depend on HAS_DMA
> (it's v4l2 core code, and selected by a lot of drivers), stub out the
> DMA support if HAS_DMA is not set.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-vmalloc.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index fba944e502271069..d4fe55c85e0c5e71 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -211,6 +211,7 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
>   	return 0;
>   }
>   
> +#ifdef CONFIG_HAS_DMA
>   /*********************************************/
>   /*         DMABUF ops for exporters          */
>   /*********************************************/
> @@ -380,6 +381,8 @@ static struct dma_buf *vb2_vmalloc_get_dmabuf(void *buf_priv, unsigned long flag
>   
>   	return dbuf;
>   }
> +#endif /* CONFIG_HAS_DMA */
> +
>   
>   /*********************************************/
>   /*       callbacks for DMABUF buffers        */
> @@ -437,7 +440,9 @@ const struct vb2_mem_ops vb2_vmalloc_memops = {
>   	.put		= vb2_vmalloc_put,
>   	.get_userptr	= vb2_vmalloc_get_userptr,
>   	.put_userptr	= vb2_vmalloc_put_userptr,
> +#ifdef CONFIG_HAS_DMA
>   	.get_dmabuf	= vb2_vmalloc_get_dmabuf,
> +#endif
>   	.map_dmabuf	= vb2_vmalloc_map_dmabuf,
>   	.unmap_dmabuf	= vb2_vmalloc_unmap_dmabuf,
>   	.attach_dmabuf	= vb2_vmalloc_attach_dmabuf,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

