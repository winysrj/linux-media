Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46822 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758892Ab2JKVaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 17:30:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv10 23/26] v4l: vb2-dma-contig: align buffer size to PAGE_SIZE
Date: Thu, 11 Oct 2012 23:31:39 +0200
Message-ID: <11844448.MZrezqZD1L@avalon>
In-Reply-To: <1349880405-26049-24-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1349880405-26049-24-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wednesday 10 October 2012 16:46:42 Tomasz Stanislawski wrote:
> Most operations on DMA and DMABUF framework need page
> aligned buffers.

The comment is a bit misleading, the buffer is already page-aligned (unless 
I'm mistaken dma_alloc_coherent() returns a page-aligned buffer) but its size 
isn't a multiple of the page size.

Do we really need a page size multiple ? Isn't it enough to make the size a 
multiple of the cache line size ?

> This fix guarantees this requirement
> for vb2-dma-contig buffers.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 571a919..002ee50
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -162,6 +162,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
> size) if (!buf)
>  		return ERR_PTR(-ENOMEM);
> 
> +	/* align image size to PAGE_SIZE */
> +	size = PAGE_ALIGN(size);
> +
>  	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
>  	if (!buf->vaddr) {
>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
-- 
Regards,

Laurent Pinchart

