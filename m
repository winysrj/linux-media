Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4089 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaCKMEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:04:13 -0400
Message-ID: <531EFB86.6070603@xs4all.nl>
Date: Tue, 11 Mar 2014 13:03:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 04/14] v4l: ti-vpe: Allow DMABUF buffer type support
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-5-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-5-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/14 09:33, Archit Taneja wrote:
> For OMAP and DRA7x, we generally allocate video and graphics buffers through
> omapdrm since the corresponding omap-gem driver provides DMM-Tiler backed
> contiguous buffers. omapdrm is a dma-buf exporter. These buffers are used by
> other drivers in the video pipeline.
> 
> Add VB2_DMABUF flag to the io_modes of the vb2 output and capture queues. This
> allows the driver to import dma shared buffers.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 0363df6..0e7573a 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1770,7 +1770,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  
>  	memset(src_vq, 0, sizeof(*src_vq));
>  	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -	src_vq->io_modes = VB2_MMAP;
> +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
>  	src_vq->drv_priv = ctx;
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &vpe_qops;
> @@ -1783,7 +1783,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  
>  	memset(dst_vq, 0, sizeof(*dst_vq));
>  	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -	dst_vq->io_modes = VB2_MMAP;
> +	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
>  	dst_vq->drv_priv = ctx;
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &vpe_qops;
> 

