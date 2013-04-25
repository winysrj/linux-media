Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab3DYPvs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 11:51:48 -0400
Message-ID: <1366905070.4419.21.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 4/7 v2] coda: Add copy time stamp handling
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Thu, 25 Apr 2013 17:51:10 +0200
In-Reply-To: <1366889768-16677-5-git-send-email-k.debski@samsung.com>
References: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
	 <1366889768-16677-5-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Am Donnerstag, den 25.04.2013, 13:36 +0200 schrieb Kamil Debski:
> Since the introduction of the timestamp_type field, it is necessary that
> the driver chooses which type it will use. This patch adds support for
> the timestamp_type.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>

Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/media/platform/coda.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 20827ba..5612329 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1422,6 +1422,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &coda_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -1433,6 +1434,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &coda_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> @@ -1628,6 +1630,9 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
>  		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
>  	}
>  
> +	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
> +	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
> +
>  	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
>  	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
>  

regards
Philipp

