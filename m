Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40001 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726340AbeJSPdv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 11:33:51 -0400
Subject: Re: [PATCH 2/2] vicodec: Implement spec-compliant stop command
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
References: <20181018160841.17674-1-ezequiel@collabora.com>
 <20181018160841.17674-3-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b75076e1-075b-50eb-96ff-f7115168d2bd@xs4all.nl>
Date: Fri, 19 Oct 2018 09:28:55 +0200
MIME-Version: 1.0
In-Reply-To: <20181018160841.17674-3-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2018 06:08 PM, Ezequiel Garcia wrote:
> Set up a statically-allocated, dummy buffer to
> be used as flush buffer, which signals
> a encoding (or decoding) stop.
> 
> When the flush buffer is queued to the OUTPUT queue,
> the driver will send an V4L2_EVENT_EOS event, and
> mark the CAPTURE buffer with V4L2_BUF_FLAG_LAST.

I'm confused. What is the current driver doing wrong? It is already
setting the LAST flag AFAIK. I don't see why a dummy buffer is needed.

Regards,

	Hans

> 
> With this change, it's possible to run a pipeline to completion:
> 
> gst-launch-1.0 videotestsrc num-buffers=10 ! v4l2fwhtenc ! v4l2fwhtdec ! fakevideosink
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 80 ++++++++++---------
>  1 file changed, 44 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index a2c487b4b80d..4ed4dae10e30 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -113,7 +113,7 @@ struct vicodec_ctx {
>  	struct v4l2_ctrl_handler hdl;
>  
>  	struct vb2_v4l2_buffer *last_src_buf;
> -	struct vb2_v4l2_buffer *last_dst_buf;
> +	struct vb2_v4l2_buffer  flush_buf;
>  
>  	/* Source and destination queue data */
>  	struct vicodec_q_data   q_data[2];
> @@ -220,6 +220,7 @@ static void device_run(void *priv)
>  	struct vicodec_dev *dev = ctx->dev;
>  	struct vb2_v4l2_buffer *src_buf, *dst_buf;
>  	struct vicodec_q_data *q_out;
> +	bool flushing;
>  	u32 state;
>  
>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> @@ -227,26 +228,36 @@ static void device_run(void *priv)
>  	q_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
>  
>  	state = VB2_BUF_STATE_DONE;
> -	if (device_process(ctx, src_buf, dst_buf))
> +
> +	flushing = (src_buf == &ctx->flush_buf);
> +	if (!flushing && device_process(ctx, src_buf, dst_buf))
>  		state = VB2_BUF_STATE_ERROR;
> -	ctx->last_dst_buf = dst_buf;
>  
>  	spin_lock(ctx->lock);
> -	if (!ctx->comp_has_next_frame && src_buf == ctx->last_src_buf) {
> +	if (!flushing) {
> +		if (!ctx->comp_has_next_frame && src_buf == ctx->last_src_buf) {
> +			dst_buf->flags |= V4L2_BUF_FLAG_LAST;
> +			v4l2_event_queue_fh(&ctx->fh, &eos_event);
> +		}
> +
> +		if (ctx->is_enc) {
> +			src_buf->sequence = q_out->sequence++;
> +			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +			v4l2_m2m_buf_done(src_buf, state);
> +		} else if (vb2_get_plane_payload(&src_buf->vb2_buf, 0)
> +				== ctx->cur_buf_offset) {
> +			src_buf->sequence = q_out->sequence++;
> +			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +			v4l2_m2m_buf_done(src_buf, state);
> +			ctx->cur_buf_offset = 0;
> +			ctx->comp_has_next_frame = false;
> +		}
> +	} else {
> +		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, 0);
>  		dst_buf->flags |= V4L2_BUF_FLAG_LAST;
>  		v4l2_event_queue_fh(&ctx->fh, &eos_event);
>  	}
> -	if (ctx->is_enc) {
> -		src_buf->sequence = q_out->sequence++;
> -		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> -		v4l2_m2m_buf_done(src_buf, state);
> -	} else if (vb2_get_plane_payload(&src_buf->vb2_buf, 0) == ctx->cur_buf_offset) {
> -		src_buf->sequence = q_out->sequence++;
> -		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> -		v4l2_m2m_buf_done(src_buf, state);
> -		ctx->cur_buf_offset = 0;
> -		ctx->comp_has_next_frame = false;
> -	}
>  	v4l2_m2m_buf_done(dst_buf, state);
>  	ctx->comp_size = 0;
>  	ctx->comp_magic_cnt = 0;
> @@ -293,6 +304,8 @@ static int job_ready(void *priv)
>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>  	if (!src_buf)
>  		return 0;
> +	if (src_buf == &ctx->flush_buf)
> +		return 1;
>  	p_out = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
>  	sz = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
>  	p = p_out + ctx->cur_buf_offset;
> @@ -770,21 +783,6 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
>  	return ret;
>  }
>  
> -static void vicodec_mark_last_buf(struct vicodec_ctx *ctx)
> -{
> -	static const struct v4l2_event eos_event = {
> -		.type = V4L2_EVENT_EOS
> -	};
> -
> -	spin_lock(ctx->lock);
> -	ctx->last_src_buf = v4l2_m2m_last_src_buf(ctx->fh.m2m_ctx);
> -	if (!ctx->last_src_buf && ctx->last_dst_buf) {
> -		ctx->last_dst_buf->flags |= V4L2_BUF_FLAG_LAST;
> -		v4l2_event_queue_fh(&ctx->fh, &eos_event);
> -	}
> -	spin_unlock(ctx->lock);
> -}
> -
>  static int vicodec_try_encoder_cmd(struct file *file, void *fh,
>  				struct v4l2_encoder_cmd *ec)
>  {
> @@ -806,8 +804,8 @@ static int vicodec_encoder_cmd(struct file *file, void *fh,
>  	ret = vicodec_try_encoder_cmd(file, fh, ec);
>  	if (ret < 0)
>  		return ret;
> -
> -	vicodec_mark_last_buf(ctx);
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, &ctx->flush_buf);
> +	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
>  	return 0;
>  }
>  
> @@ -835,8 +833,8 @@ static int vicodec_decoder_cmd(struct file *file, void *fh,
>  	ret = vicodec_try_decoder_cmd(file, fh, dc);
>  	if (ret < 0)
>  		return ret;
> -
> -	vicodec_mark_last_buf(ctx);
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, &ctx->flush_buf);
> +	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
>  	return 0;
>  }
>  
> @@ -991,7 +989,7 @@ static void vicodec_return_bufs(struct vb2_queue *q, u32 state)
>  			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>  		else
>  			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> -		if (vbuf == NULL)
> +		if (!vbuf || vbuf == &ctx->flush_buf)
>  			return;
>  		spin_lock(ctx->lock);
>  		v4l2_m2m_buf_done(vbuf, state);
> @@ -1031,7 +1029,6 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  	state->ref_frame.cb = state->ref_frame.luma + size;
>  	state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
>  	ctx->last_src_buf = NULL;
> -	ctx->last_dst_buf = NULL;
>  	state->gop_cnt = 0;
>  	ctx->cur_buf_offset = 0;
>  	ctx->comp_size = 0;
> @@ -1158,6 +1155,7 @@ static int vicodec_open(struct file *file)
>  	struct vicodec_dev *dev = video_drvdata(file);
>  	struct vicodec_ctx *ctx = NULL;
>  	struct v4l2_ctrl_handler *hdl;
> +	struct vb2_queue *vq;
>  	unsigned int size;
>  	int rc = 0;
>  
> @@ -1234,6 +1232,16 @@ static int vicodec_open(struct file *file)
>  
>  	v4l2_fh_add(&ctx->fh);
>  
> +	/* Setup a dummy flush buffer, used to signal
> +	 * encoding/decoding stop operation. When this buffer
> +	 * is queued to the OUTPUT queue, the driver will send
> +	 * V4L2_EVENT_EOS and send the last buffer to userspace.
> +	 */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, multiplanar ?
> +			     V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
> +			     V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	ctx->flush_buf.vb2_buf.vb2_queue = vq;
> +
>  open_unlock:
>  	mutex_unlock(vfd->lock);
>  	return rc;
> 
