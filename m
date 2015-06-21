Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63564 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbbFUQkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 12:40:53 -0400
Date: Sun, 21 Jun 2015 18:40:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 01/14] sh-veu: initialize timestamp_flags and copy
 timestamp info
In-Reply-To: <1434368021-7467-2-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1506211840210.7745@axis700.grange>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
 <1434368021-7467-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Jun 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This field wasn't set, causing WARN_ON's from the vb2 core.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/platform/sh_veu.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
> index 2554f37..77a74d3 100644
> --- a/drivers/media/platform/sh_veu.c
> +++ b/drivers/media/platform/sh_veu.c
> @@ -958,6 +958,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &sh_veu_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
>  	src_vq->lock = &veu->fop_lock;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret < 0)
> @@ -971,6 +972,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->ops = &sh_veu_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
>  	dst_vq->lock = &veu->fop_lock;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> @@ -1103,6 +1105,12 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
>  	if (!src || !dst)
>  		return IRQ_NONE;
>  
> +	dst->v4l2_buf.timestamp = src->v4l2_buf.timestamp;
> +	dst->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	dst->v4l2_buf.flags |=
> +		src->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	dst->v4l2_buf.timecode = src->v4l2_buf.timecode;
> +
>  	spin_lock(&veu->lock);
>  	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
>  	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
> -- 
> 2.1.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
