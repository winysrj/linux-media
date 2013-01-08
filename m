Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51763 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3AHGxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 01:53:38 -0500
Message-id: <50EBC26E.5090803@samsung.com>
Date: Tue, 08 Jan 2013 07:53:34 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v4 1/3] videobuf2-dma-contig: user can specify GFP flags
References: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com>
In-reply-to: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 1/6/2013 6:29 PM, Federico Vaga wrote:
> This is useful when you need to specify specific GFP flags during memory
> allocation (e.g. GFP_DMA).
>
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> ---
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 7 ++-----
>   include/media/videobuf2-dma-contig.h           | 5 +++++
>   2 file modificati, 7 inserzioni(+), 5 rimozioni(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 10beaee..bb411c0 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -21,10 +21,6 @@
>   #include <media/videobuf2-dma-contig.h>
>   #include <media/videobuf2-memops.h>
>   
> -struct vb2_dc_conf {
> -	struct device		*dev;
> -};
> -
>   struct vb2_dc_buf {
>   	struct device			*dev;
>   	void				*vaddr;
> @@ -165,7 +161,8 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
>   	/* align image size to PAGE_SIZE */
>   	size = PAGE_ALIGN(size);
>   
> -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
> +	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> +									GFP_KERNEL | conf->mem_flags);

I think we can add GFP_DMA flag unconditionally to the vb2_dc_contig 
allocator.
It won't hurt existing clients as most of nowadays platforms doesn't 
have DMA
zone (GFP_DMA is ignored in such case), but it should fix the issues 
with some
older and non-standard systems.

>   	if (!buf->vaddr) {
>   		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
>   		kfree(buf);
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index 8197f87..22733f4 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -16,6 +16,11 @@
>   #include <media/videobuf2-core.h>
>   #include <linux/dma-mapping.h>
>   
> +struct vb2_dc_conf {
> +	struct device		*dev;
> +	gfp_t				mem_flags;
> +};
> +
>   static inline dma_addr_t
>   vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>   {

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


