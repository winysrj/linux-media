Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4265 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965395AbaGQQSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:18:01 -0400
Message-ID: <53C7F72B.6080908@xs4all.nl>
Date: Thu, 17 Jul 2014 18:17:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>
Subject: Re: [PATCH 06/11] [media] coda: delay coda_fill_bitstream()
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de> <1405613112-22442-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-7-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 06:05 PM, Philipp Zabel wrote:
> From: Michael Olbrich <m.olbrich@pengutronix.de>
> 
> coda_fill_bitstream() calls v4l2_m2m_buf_done() which is no longer allowed
> before streaming was started.
> Delay coda_fill_bitstream() until coda_start_streaming() and explicitly set
> 'start_streaming_called' before calling coda_fill_bitstream()
> 
> Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 141ec29..3d57986 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1682,7 +1682,8 @@ static void coda_buf_queue(struct vb2_buffer *vb)
>  		}
>  		mutex_lock(&ctx->bitstream_mutex);
>  		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
> -		coda_fill_bitstream(ctx);
> +		if (vb2_is_streaming(vb->vb2_queue))
> +			coda_fill_bitstream(ctx);
>  		mutex_unlock(&ctx->bitstream_mutex);
>  	} else {
>  		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
> @@ -2272,6 +2273,15 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>  	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
>  	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>  		if (q_data_src->fourcc == V4L2_PIX_FMT_H264) {
> +			struct vb2_queue *vq;
> +			/* start_streaming_called must be set, for v4l2_m2m_buf_done() */
> +			vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +			vq->start_streaming_called = 1;

Why set start_streaming_called to 1? It is set before calling start_streaming.
This is a recent change in videobuf2-core.c though.

BTW, you should test with CONFIG_VIDEO_ADV_DEBUG on and force start_streaming
errors to check whether vb2_buffer_done(buf, VB2_BUF_STATE_DEQUEUED) is called
for the queued buffers in case of start_streaming failure.

With that config option vb2 will complain about unbalanced vb2 operations.

I strongly suspect this code does not play well with this.

BTW, isn't it time to split up the coda driver? Over 3000 lines...

Regards,

	Hans

> +			/* copy the buffers that where queued before streamon */
> +			mutex_lock(&ctx->bitstream_mutex);
> +			coda_fill_bitstream(ctx);
> +			mutex_unlock(&ctx->bitstream_mutex);
> +
>  			if (coda_get_bitstream_payload(ctx) < 512)
>  				return -EINVAL;
>  		} else {
> 

