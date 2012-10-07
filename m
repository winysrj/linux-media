Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41456 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2JGNh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 09:37:56 -0400
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
Subject: Re: [PATCHv9 22/25] v4l: vb2-dma-contig: fail if user ptr buffer is not correctly aligned
Date: Sun, 07 Oct 2012 15:38:37 +0200
Message-ID: <2975726.pfZgGt5FAy@avalon>
In-Reply-To: <1349188056-4886-23-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <1349188056-4886-23-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 02 October 2012 16:27:33 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> The DMA transfer must be aligned to a specific value. If userptr is not
> aligned to DMA requirements then unexpected corruptions of the memory may
> occur before or after a buffer.  To prevent such situations, all unligned
> userptr buffers are rejected at VIDIOC_QBUF.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index b4d287a..55f8c80 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -494,6 +494,13 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, struct vm_area_struct *vma;
>  	struct sg_table *sgt;
>  	unsigned long contig_size;
> +	unsigned long dma_align = dma_get_cache_alignment();
> +
> +	/* Only cache aligned DMA transfers are reliable */
> +	if (!IS_ALIGNED(vaddr | size, dma_align)) {
> +		pr_err("user data must be aligned to %lu bytes\n", dma_align);
> +		return ERR_PTR(-EINVAL);

Do you think EFAULT would be more descriptive ? EINVAL is already used quite 
extensively. We could then possibly turn pr_err() into pr_dbg() to avoid 
flooding the kernel log.

> +	}
> 
>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>  	if (!buf)

-- 
Regards,

Laurent Pinchart
