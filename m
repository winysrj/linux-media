Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10523 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3DYJ4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 05:56:52 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT00BHW2AJB150@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 10:56:50 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Kamil Debski' <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Javier Martin' <javier.martin@vista-silicon.com>
References: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
 <1366883390-12890-7-git-send-email-k.debski@samsung.com>
In-reply-to: <1366883390-12890-7-git-send-email-k.debski@samsung.com>
Subject: RE: [PATCH 5/7] exynos-gsc: Add copy time stamp handling
Date: Thu, 25 Apr 2013 11:56:32 +0200
Message-id: <000601ce419b$2bd10ce0$837326a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

git send-email --dryrun had no errors, but during the real send it had a few
"Use of uninitialized value".
I think that this caused this patch to have a wrong subject. Sorry for that.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Kamil Debski [mailto:k.debski@samsung.com]
> Sent: Thursday, April 25, 2013 11:50 AM
> To: linux-media@vger.kernel.org
> Cc: Kamil Debski; Kyungmin Park; Javier Martin
> Subject: [PATCH 5/7] exynos-gsc: Add copy time stamp handling
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/platform/m2m-deinterlace.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/m2m-deinterlace.c
> b/drivers/media/platform/m2m-deinterlace.c
> index 6c4db9b..7585646 100644
> --- a/drivers/media/platform/m2m-deinterlace.c
> +++ b/drivers/media/platform/m2m-deinterlace.c
> @@ -207,6 +207,9 @@ static void dma_callback(void *data)
>  	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
>  	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
> 
> +	src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
> +	src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
> +
>  	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
>  	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> 
> @@ -866,6 +869,7 @@ static int queue_init(void *priv, struct vb2_queue
> *src_vq,
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &deinterlace_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	q_data[V4L2_M2M_SRC].fmt = &formats[0];
>  	q_data[V4L2_M2M_SRC].width = 640;
>  	q_data[V4L2_M2M_SRC].height = 480;
> @@ -882,6 +886,7 @@ static int queue_init(void *priv, struct vb2_queue
> *src_vq,
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &deinterlace_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	q_data[V4L2_M2M_DST].fmt = &formats[0];
>  	q_data[V4L2_M2M_DST].width = 640;
>  	q_data[V4L2_M2M_DST].height = 480;
> --
> 1.7.9.5


