Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47457 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2HOUUh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 16:20:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, dmitriyz@google.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv8 22/26] media: vb2: fail if user ptr buffer is not correctly aligned
Date: Wed, 15 Aug 2012 22:20:52 +0200
Message-ID: <1712149.lhk9fvSKkE@avalon>
In-Reply-To: <1344958496-9373-23-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-23-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 14 August 2012 17:34:52 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index d44766e..11f4a46 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -498,6 +498,16 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, struct vm_area_struct *vma;
>  	struct sg_table *sgt;
>  	unsigned long contig_size;
> +	unsigned long dma_align = dma_get_cache_alignment();
> +
> +	/*
> +	 * DMA transfers are not reliable to buffers which
> +	 * are not cache line aligned!
> +	 */

Are you scared of going near the 80 columns limit ? :-)

> +	if (vaddr & (dma_align - 1)) {

You could use the IS_ALIGNED macro here, but that might just be nitpicking.

> +		pr_err("userptr must be aligned to %lu bytes\n", dma_align);
> +		return ERR_PTR(-EINVAL);
> +	}

Shouldn't you also check that the size is a multiple of dma_align ?

>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>  	if (!buf)

-- 
Regards,

Laurent Pinchart

