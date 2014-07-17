Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2741 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934506AbaGQQKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:10:54 -0400
Message-ID: <53C7F569.9080809@xs4all.nl>
Date: Thu, 17 Jul 2014 18:10:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 04/11] [media] coda: remove VB2_USERPTR from queue io_modes
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de> <1405613112-22442-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-5-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 06:05 PM, Philipp Zabel wrote:
> Disallow USERPTR buffers, videobuf2-dma-contig doesn't support them.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index f52d17c..917727e 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -2865,7 +2865,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>  	int ret;
>  
>  	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -	src_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> +	src_vq->io_modes = VB2_DMABUF | VB2_MMAP;
>  	src_vq->drv_priv = ctx;
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &coda_qops;
> @@ -2878,7 +2878,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>  		return ret;
>  
>  	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> +	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP;
>  	dst_vq->drv_priv = ctx;
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &coda_qops;
> 

