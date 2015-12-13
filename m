Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39098 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbLNBge (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 20:36:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 4/7] media: vb2-dma-contig: add helper for setting dma max seg size
Date: Sun, 13 Dec 2015 21:57:40 +0200
Message-ID: <3238962.HlGfVT9mcy@avalon>
In-Reply-To: <1449669502-24601-5-git-send-email-m.szyprowski@samsung.com>
References: <1449669502-24601-1-git-send-email-m.szyprowski@samsung.com> <1449669502-24601-5-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

Thank you for the patch.

On Wednesday 09 December 2015 14:58:19 Marek Szyprowski wrote:
> Add a helper function for device drivers to set DMA's max_seg_size.
> Setting it to largest possible value lets DMA-mapping API always create
> contiguous mappings in DMA address space. This is essential for all
> devices, which use dma-contig videobuf2 memory allocator and shared
> buffers.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
>  include/media/videobuf2-dma-contig.h           |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index c331272..628518d
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -742,6 +742,21 @@ void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
>  }
>  EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
> 
> +int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
> +{
> +	if (!dev->dma_parms) {

When can this function be called with dev->dma_parms not NULL ?

> +		dev->dma_parms = devm_kzalloc(dev, sizeof(dev->dma_parms),
> +					      GFP_KERNEL);
> +		if (!dev->dma_parms)
> +			return -ENOMEM;
> +	}
> +	if (dma_get_max_seg_size(dev) < size)
> +		return dma_set_max_seg_size(dev, size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vb2_dma_contig_set_max_seg_size);
> +
>  MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
>  MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
>  MODULE_LICENSE("GPL");
> diff --git a/include/media/videobuf2-dma-contig.h
> b/include/media/videobuf2-dma-contig.h index c33dfa6..0e6ba64 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -26,6 +26,7 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb,
> unsigned int plane_no)
> 
>  void *vb2_dma_contig_init_ctx(struct device *dev);
>  void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
> +int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size);
> 
>  extern const struct vb2_mem_ops vb2_dma_contig_memops;

-- 
Regards,

Laurent Pinchart

