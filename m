Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36216 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382Ab2JKVf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 17:35:56 -0400
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
Subject: Re: [PATCHv10 22/26] v4l: vb2-dma-contig: fail if user ptr buffer is not correctly aligned
Date: Thu, 11 Oct 2012 23:36:41 +0200
Message-ID: <2222801.pVl6O4rxaf@avalon>
In-Reply-To: <1349880405-26049-23-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1349880405-26049-23-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Wednesday 10 October 2012 16:46:41 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> The DMA transfer must be aligned to a specific value. If userptr is not
> aligned to DMA requirements then unexpected corruptions of the memory may
> occur before or after a buffer.  To prevent such situations, all unligned
> userptr buffers are rejected at VIDIOC_QBUF.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 2d661fd..571a919
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -493,6 +493,18 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, struct vm_area_struct *vma;
>  	struct sg_table *sgt;
>  	unsigned long contig_size;
> +	unsigned long dma_align = dma_get_cache_alignment();
> +
> +	/* Only cache aligned DMA transfers are reliable */
> +	if (!IS_ALIGNED(vaddr | size, dma_align)) {
> +		pr_debug("user data must be aligned to %lu bytes\n", dma_align);
> +		return ERR_PTR(-EINVAL);
> +	}

Looks good to me.

> +	if (!size) {
> +		pr_debug("size is zero\n");
> +		return ERR_PTR(-EINVAL);
> +	}

Can this happen ? The vb2 core already has

                /* Check if the provided plane buffer is large enough */
                if (planes[plane].length < q->plane_sizes[plane]) {
                        ret = -EINVAL;
                        goto err;
                }

Unless queue_setup sets plane_sizes to 0 we can't reach vb2_dc_get_userptr.

>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>  	if (!buf)

-- 
Regards,

Laurent Pinchart

