Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1IMIRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 04:17:49 -0400
Date: Tue, 13 Sep 2011 10:17:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/4] v4l2: add vb2_get_unmapped_area in vb2 core
In-Reply-To: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
Message-ID: <Pine.LNX.4.64.1109131016010.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Sep 2011, Scott Jiang wrote:

> no mmu system needs get_unmapped_area file operations to do mmap
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
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

Hm, wouldn't it be better to use vb2_mmap() and provide a dummy .mmap() 
method in videobuf2-dma-contig.c for the NOMMU case?

Thanks
Guennadi

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
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
