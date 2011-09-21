Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28490 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1IUMUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 08:20:16 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRV00B4JGXPTI@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 13:20:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV000W9GXPLV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 13:20:13 +0100 (BST)
Date: Wed, 21 Sep 2011 14:20:06 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] v4l2: add vb2_get_unmapped_area in vb2 core
In-reply-to: <1315519892-15641-1-git-send-email-scott.jiang.linux@gmail.com>
To: 'Scott Jiang' <scott.jiang.linux@gmail.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Message-id: <000601cc7858$cc9984d0$65cc8e70$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1315519892-15641-1-git-send-email-scott.jiang.linux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, September 09, 2011 12:12 AM Scott Jiang wrote:
 
> no mmu system needs get_unmapped_area file operations to do mmap
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>

The patch looks fine, I will add it to my videobuf2 fixes branch. Thanks for your
contribution!

> ---
>  drivers/media/video/videobuf2-core.c |   31 +++++++++++++++++++++++++++++++
>  include/media/videobuf2-core.h       |    7 +++++++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 3015e60..02a0ec6 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1344,6 +1344,37 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>  }
>  EXPORT_SYMBOL_GPL(vb2_mmap);
> 
> +#ifndef CONFIG_MMU
> +unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
> +				    unsigned long addr,
> +				    unsigned long len,
> +				    unsigned long pgoff,
> +				    unsigned long flags)
> +{
> +	unsigned long off = pgoff << PAGE_SHIFT;
> +	struct vb2_buffer *vb;
> +	unsigned int buffer, plane;
> +	int ret;
> +
> +	if (q->memory != V4L2_MEMORY_MMAP) {
> +		dprintk(1, "Queue is not currently set up for mmap\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Find the plane corresponding to the offset passed by userspace.
> +	 */
> +	ret = __find_plane_by_offset(q, off, &buffer, &plane);
> +	if (ret)
> +		return ret;
> +
> +	vb = q->bufs[buffer];
> +
> +	return (unsigned long)vb2_plane_vaddr(vb, plane);
> +}
> +EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
> +#endif
> +
>  static int __vb2_init_fileio(struct vb2_queue *q, int read);
>  static int __vb2_cleanup_fileio(struct vb2_queue *q);
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f87472a..5c7b5b4 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -302,6 +302,13 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
>  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
> 
>  int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> +#ifndef CONFIG_MMU
> +unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
> +				    unsigned long addr,
> +				    unsigned long len,
> +				    unsigned long pgoff,
> +				    unsigned long flags);
> +#endif
>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
>  size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
>  		loff_t *ppos, int nonblock);
> --
> 1.7.0.4

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


