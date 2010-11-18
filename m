Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:27812 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0KRHOg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 02:14:36 -0500
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LC2004N8K3O8G70@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Nov 2010 16:14:12 +0900 (KST)
Received: from DOSEUNIPARK01 ([12.23.103.76])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LC200FNCK3OS4@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Nov 2010 16:14:13 +0900 (KST)
Date: Thu, 18 Nov 2010 16:14:37 +0900
From: Sewoon Park <seuni.park@samsung.com>
Subject: RE: [PATCH 4/7] v4l: videobuf2: add DMA coherent allocator
In-reply-to: <1289983174-2835-5-git-send-email-m.szyprowski@samsung.com>
To: 'Marek Szyprowski' <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Cc: pawel@osciak.com, kyungmin.park@samsung.com
Message-id: <001d01cb86f0$442f1380$cc8d3a80$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1289983174-2835-1-git-send-email-m.szyprowski@samsung.com>
 <1289983174-2835-5-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Marek~ 

Marek Szyprowski wrote:
> Sent: Wednesday, November 17, 2010 5:40 PM
> To: linux-media@vger.kernel.org
> Cc: m.szyprowski@samsung.com; pawel@osciak.com; kyungmin.park@samsung.com
> Subject: [PATCH 4/7] v4l: videobuf2: add DMA coherent allocator
> 
> From: Pawel Osciak <p.osciak@samsung.com>
> 
> Add an implementation of DMA coherent memory allocator and handling
> routines for videobuf2, implemented on top of dma_alloc_coherent() call.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/Kconfig                  |    5 +
>  drivers/media/video/Makefile                 |    1 +
>  drivers/media/video/videobuf2-dma-coherent.c |  208
> ++++++++++++++++++++++++++
>  include/media/videobuf2-dma-coherent.h       |   27 ++++
>  4 files changed, 241 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/videobuf2-dma-coherent.c
>  create mode 100644 include/media/videobuf2-dma-coherent.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 9351423..e7752ee1 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -55,6 +55,11 @@ config VIDEOBUF2_CORE
>  config VIDEOBUF2_MEMOPS
>  	tristate
> 
> +config VIDEOBUF2_DMA_COHERENT
> +	select VIDEOBUF2_CORE
> +	select VIDEOBUF2_MEMOPS
> +	tristate
> +
>  config VIDEOBUF2_VMALLOC
>  	select VIDEOBUF2_CORE
>  	select VIDEOBUF2_MEMOPS
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 538bee9..baa74e7 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -117,6 +117,7 @@ obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
>  obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
>  obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
>  obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
> +obj-$(CONFIG_VIDEOBUF2_DMA_COHERENT)	+= videobuf2-dma_coherent.o
> 
>  obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
> 
> diff --git a/drivers/media/video/videobuf2-dma-coherent.c
> b/drivers/media/video/videobuf2-dma-coherent.c
> new file mode 100644
> index 0000000..761f366
> --- /dev/null
> +++ b/drivers/media/video/videobuf2-dma-coherent.c
> @@ -0,0 +1,208 @@
> +/*
> + * videobuf2-dma-coherent.c - DMA coherent memory allocator for videobuf2
> + *
> + * Copyright (C) 2010 Samsung Electronics
> + *
> + * Author: Pawel Osciak <p.osciak@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/dma-mapping.h>
> +
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-memops.h>
> +
> +struct vb2_dc_conf {
> +	struct vb2_alloc_ctx	alloc_ctx;
> +	struct device		*dev;
> +};

(snip)

> +static void vb2_dma_coherent_put_userptr(void *mem_priv)
> +{
> +	struct vb2_dc_buf *buf = mem_priv;
> +
> +	if (!buf)
> +		return;
> +
> +	vb2_put_userptr(buf->vma);
> +	kfree(buf);
> +}
> +
> +const struct vb2_mem_ops vb2_dma_coherent_ops = {
> +	.alloc		= vb2_dma_coherent_alloc,
> +	.put		= vb2_dma_coherent_put,
> +	.paddr		= vb2_dma_coherent_paddr,

The "paddr" is not exist in vb2_mem_ops after [PATCH v4 xxx] lists.
I think you should fix from paddr to cookie like CMA allocator.

> +	.mmap		= vb2_dma_coherent_mmap,
> +	.get_userptr	= vb2_dma_coherent_get_userptr,
> +	.put_userptr	= vb2_dma_coherent_put_userptr,
> +	.num_users	= vb2_dma_coherent_num_users,
> +};
> +

(snip)

> --
> 1.7.1.569.g6f426
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

