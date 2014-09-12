Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36035 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILVyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 17:54:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 03/14] vb2-dma-sg: add prepare/finish memops
Date: Sat, 13 Sep 2014 00:54:37 +0300
Message-ID: <13309231.cvmkYBHmIS@avalon>
In-Reply-To: <1410526803-25887-4-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl> <1410526803-25887-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 12 September 2014 14:59:52 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This moves dma_(un)map_sg to the prepare/finish memops of
> videobuf2-dma-sg.c.
> 
> Now that vb2-dma-sg will sync the buffers for you in the prepare/finish
> memops we can drop that from the drivers that use dma-sg.
> 
> For the solo6x10 driver that was a bit more involved because it needs to
> copy JPEG or MPEG headers to the buffer before returning it to userspace,
> and that cannot be done in the old place since the buffer there is still
> setup for DMA access, not for CPU access. However, the buf_finish_for_cpu
> op is the ideal place to do this. By the time buf_finish_for_cpu is called
> the buffer is available for CPU access, so copying to the buffer is fine.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/cx23885/cx23885-417.c         |  7 +---
>  drivers/media/pci/cx23885/cx23885-core.c        |  5 ---
>  drivers/media/pci/cx23885/cx23885-dvb.c         |  7 +---
>  drivers/media/pci/cx23885/cx23885-vbi.c         | 13 +------
>  drivers/media/pci/cx23885/cx23885-video.c       | 13 +------
>  drivers/media/pci/saa7134/saa7134-empress.c     |  1 -
>  drivers/media/pci/saa7134/saa7134-ts.c          | 16 --------
>  drivers/media/pci/saa7134/saa7134-vbi.c         | 15 --------
>  drivers/media/pci/saa7134/saa7134-video.c       | 15 --------
>  drivers/media/pci/saa7134/saa7134.h             |  1 -
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  | 50 ++++++++++------------
>  drivers/media/pci/tw68/tw68-video.c             | 12 +-----
>  drivers/media/platform/marvell-ccic/mcam-core.c | 18 +--------
>  drivers/media/v4l2-core/videobuf2-dma-sg.c      | 18 +++++++++
>  14 files changed, 51 insertions(+), 140 deletions(-)

[snip]

> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index 9b7a041..f3bc01b 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -170,6 +170,22 @@ static void vb2_dma_sg_put(void *buf_priv)
>  	}
>  }
> 
> +static void vb2_dma_sg_prepare(void *buf_priv)
> +{
> +	struct vb2_dma_sg_buf *buf = buf_priv;
> +	struct sg_table *sgt = &buf->sg_table;
> +
> +	dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);

Shouldn't you use dma_sync_sg_for_device (and dma_sync_sg_for_cpu below) 
instead ? Mapping/unmapping the buffer can be costly when an IOMMU is 
involved.

> +}
> +
> +static void vb2_dma_sg_finish(void *buf_priv)
> +{
> +	struct vb2_dma_sg_buf *buf = buf_priv;
> +	struct sg_table *sgt = &buf->sg_table;
> +
> +	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> +}
> +
>  static inline int vma_is_io(struct vm_area_struct *vma)
>  {
>  	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
> @@ -366,6 +382,8 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
>  	.put		= vb2_dma_sg_put,
>  	.get_userptr	= vb2_dma_sg_get_userptr,
>  	.put_userptr	= vb2_dma_sg_put_userptr,
> +	.prepare	= vb2_dma_sg_prepare,
> +	.finish		= vb2_dma_sg_finish,
>  	.vaddr		= vb2_dma_sg_vaddr,
>  	.mmap		= vb2_dma_sg_mmap,
>  	.num_users	= vb2_dma_sg_num_users,

-- 
Regards,

Laurent Pinchart

