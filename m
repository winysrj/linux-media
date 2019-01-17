Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4827C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3626320855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfAQLlO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:41:14 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35781 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728426AbfAQLlM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 06:41:12 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id k62ngc0zLNR5yk62ogSn0T; Thu, 17 Jan 2019 12:41:10 +0100
Subject: Re: [PATCH v2 6/6] media: vicodec: Add support for resolution change
 event.
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190116152527.34411-1-dafna3@gmail.com>
 <20190116152527.34411-7-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a2d09554-f00c-160f-4902-9155c7de2b21@xs4all.nl>
Date:   Thu, 17 Jan 2019 12:41:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190116152527.34411-7-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCPoHp/5R9dwZREwxjTOF6JMlEJuGMQveNtfrYXUPj4kElm3HSBmiYEHgcalEOeelD7ggAZ4YVgCaKkx/O3OTpnQZUPS+V5IEt2gG0ZBuJua4qBSkkun
 ASd/P/8lINC4JwCeNGkNWMd6THnykVd7NRlIyioMyMbm8XmjWOyneYo7MXSUN4YL9UrHmZBiLnbre0i6OaL7Sj823inyRDzUjc2opJqQC632lCX6QdiuxCW/
 riCevdn0EYUnoLpaVshry1Qc4SVW5IA1gdXa72Hj4tKjz8GFFMftjERpnCuUGrnnvz6ZZ4R+poium28R9rUAL6tPKwdT8BEzzEuy4R1/PQE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/16/19 4:25 PM, Dafna Hirschfeld wrote:
> If the the queues are not streaming then the first resolution
> change is handled in the buf_queue callback.
> The following resolution change events are handled in job_ready.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 381 ++++++++++++++----
>  1 file changed, 304 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index c97300344fbd..44f2ed59f4a3 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -129,6 +129,8 @@ struct vicodec_ctx {
>  	u32			comp_frame_size;
>  	bool			comp_has_frame;
>  	bool			comp_has_next_frame;
> +	bool			first_source_change_sent;
> +	bool			source_changed;
>  };
>  
>  static inline struct vicodec_ctx *file2ctx(struct file *file)
> @@ -322,6 +324,107 @@ static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
>  	spin_unlock(ctx->lock);
>  }
>  
> +static const struct v4l2_fwht_pixfmt_info *info_from_header(struct fwht_cframe_hdr p_hdr)
> +{
> +	unsigned int flags = ntohl(p_hdr.flags);
> +	unsigned int width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
> +	unsigned int height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
> +	unsigned int components_num = 3;
> +	unsigned int pixenc = 0;
> +	unsigned int version = ntohl(p_hdr.version);
> +
> +	if (version == FWHT_VERSION) {
> +		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
> +				FWHT_FL_COMPONENTS_NUM_OFFSET);
> +		pixenc = (flags & FWHT_FL_PIXENC_MSK);
> +	}
> +	return v4l2_fwht_default_fmt(width_div, height_div, version,
> +				     components_num, pixenc, 0);
> +}
> +
> +static bool is_header_valid(struct fwht_cframe_hdr p_hdr)
> +{
> +	const struct v4l2_fwht_pixfmt_info *info;
> +	unsigned int w = ntohl(p_hdr.width);
> +	unsigned int h = ntohl(p_hdr.height);
> +	unsigned int version = ntohl(p_hdr.version);
> +	unsigned int flags = ntohl(p_hdr.flags);
> +
> +	if (p_hdr.magic1 != FWHT_MAGIC1 || p_hdr.magic2 != FWHT_MAGIC2)
> +		return false;

I don't think this check is needed since you can never get here unless
the magic sequence was found.

> +
> +	if (!version || version > FWHT_VERSION)
> +		return false;
> +
> +	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
> +		return false;
> +
> +	if (version == FWHT_VERSION) {
> +		unsigned int components_num = 1 +
> +			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
> +			FWHT_FL_COMPONENTS_NUM_OFFSET);
> +		unsigned int pixenc = flags & FWHT_FL_PIXENC_MSK;
> +
> +		if (components_num == 0 || components_num > 4 || pixenc == BIT(19))
> +			return false;
> +	}
> +
> +	info = info_from_header(p_hdr);
> +	if (!info)
> +		return false;
> +	return true;
> +}
> +
> +static void update_capture_data_from_header(struct vicodec_ctx *ctx)
> +{
> +	struct vicodec_q_data *q_dst = get_q_data(ctx,
> +						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	struct fwht_cframe_hdr p_hdr = ctx->state.header;
> +	const struct v4l2_fwht_pixfmt_info *info = info_from_header(p_hdr);
> +	unsigned int flags = ntohl(p_hdr.flags);
> +	unsigned int hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
> +	unsigned int hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
> +
> +	q_dst->info = info;
> +	q_dst->visible_width = ntohl(p_hdr.width);
> +	q_dst->visible_height = ntohl(p_hdr.height);
> +	q_dst->coded_width = vic_round_dim(q_dst->visible_width, hdr_width_div);
> +	q_dst->coded_height = vic_round_dim(q_dst->visible_height,
> +					    hdr_height_div);
> +
> +	q_dst->sizeimage = q_dst->coded_width * q_dst->coded_height *
> +		q_dst->info->sizeimage_mult / q_dst->info->sizeimage_div;
> +	ctx->state.colorspace = ntohl(p_hdr.colorspace);
> +
> +	ctx->state.xfer_func = ntohl(p_hdr.xfer_func);
> +	ctx->state.ycbcr_enc = ntohl(p_hdr.ycbcr_enc);
> +	ctx->state.quantization = ntohl(p_hdr.quantization);
> +}
> +
> +static void set_last_buffer(struct vb2_v4l2_buffer *dst_buf,
> +			    struct vb2_v4l2_buffer *src_buf,

src_buf should be made const.

> +			    struct vicodec_ctx *ctx)
> +{
> +	struct vicodec_q_data *q_dst = get_q_data(ctx,
> +						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +
> +	vb2_set_plane_payload(&dst_buf->vb2_buf, 0, 0);
> +	dst_buf->sequence = q_dst->sequence++;
> +	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
> +
> +	if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE)
> +		dst_buf->timecode = src_buf->timecode;
> +	dst_buf->field = src_buf->field;
> +	dst_buf->flags |= src_buf->flags &
> +		(V4L2_BUF_FLAG_TIMECODE |
> +		 V4L2_BUF_FLAG_KEYFRAME |
> +		 V4L2_BUF_FLAG_PFRAME |
> +		 V4L2_BUF_FLAG_BFRAME |
> +		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);

Use v4l2_m2m_buf_copy_data(src_buf, dst_buf, true)

> +	dst_buf->flags |= V4L2_BUF_FLAG_LAST;
> +	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +}
> +
>  static int job_ready(void *priv)
>  {
>  	static const u8 magic[] = {
> @@ -333,7 +436,15 @@ static int job_ready(void *priv)
>  	u8 *p;
>  	u32 sz;
>  	u32 state;
> -
> +	struct vicodec_q_data *q_dst = get_q_data(ctx,
> +						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	unsigned int flags;
> +	unsigned int hdr_width_div;
> +	unsigned int hdr_height_div;
> +	unsigned int max_to_copy;
> +
> +	if (ctx->source_changed)
> +		return 0;
>  	if (ctx->is_enc || ctx->comp_has_frame)
>  		return 1;
>  
> @@ -358,11 +469,17 @@ static int job_ready(void *priv)
>  
>  	ctx->comp_frame_size = ntohl(ctx->state.header.size);
>  
> -	if (ctx->comp_frame_size > ctx->comp_max_size)
> -		ctx->comp_frame_size = ctx->comp_max_size;
> +	/*
> +	 * The current scanned frame might be the first frame of a new
> +	 * resolution so its size might be larger than ctx->comp_max_size.
> +	 * In that case it is copied up to the current buffer capacity and
> +	 * the copy will continue after allocating new large enough buffer
> +	 * when restreaming
> +	 */
> +	max_to_copy = min(ctx->comp_frame_size, ctx->comp_max_size);
>  
> -	if (ctx->comp_size < ctx->comp_frame_size) {
> -		u32 copy = ctx->comp_frame_size - ctx->comp_size;
> +	if (ctx->comp_size < max_to_copy) {
> +		u32 copy = max_to_copy - ctx->comp_size;
>  
>  		if (copy > p_src + sz - p)
>  			copy = p_src + sz - p;
> @@ -371,15 +488,16 @@ static int job_ready(void *priv)
>  		       p, copy);
>  		p += copy;
>  		ctx->comp_size += copy;
> -		if (ctx->comp_size < ctx->comp_frame_size) {
> +		if (ctx->comp_size < max_to_copy) {
>  			job_remove_src_buf(ctx, state);
>  			goto restart;
>  		}
>  	}
>  	ctx->cur_buf_offset = p - p_src;
> -	ctx->comp_has_frame = true;
> +	if (ctx->comp_size == ctx->comp_frame_size)
> +		ctx->comp_has_frame = true;
>  	ctx->comp_has_next_frame = false;
> -	if (sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {
> +	if (ctx->comp_has_frame && sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {
>  		struct fwht_cframe_hdr *p_hdr = (struct fwht_cframe_hdr *)p;
>  		u32 frame_size = ntohl(p_hdr->size);
>  		u32 remaining = sz - ctx->cur_buf_offset - sizeof(*p_hdr);
> @@ -387,6 +505,36 @@ static int job_ready(void *priv)
>  		if (!memcmp(p, magic, sizeof(magic)))
>  			ctx->comp_has_next_frame = remaining >= frame_size;
>  	}
> +	/*
> +	 * if the header is invalid the device_run will just drop the frame
> +	 * with an error
> +	 */
> +	if (!is_header_valid(ctx->state.header) && ctx->comp_has_frame)
> +		return 1;
> +	flags = ntohl(ctx->state.header.flags);
> +	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
> +	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
> +
> +	if (ntohl(ctx->state.header.width) != q_dst->visible_width ||
> +	    ntohl(ctx->state.header.height) != q_dst->visible_height ||
> +	    !q_dst->info ||
> +	    hdr_width_div != q_dst->info->width_div ||
> +	    hdr_height_div != q_dst->info->height_div) {
> +		static const struct v4l2_event rs_event = {
> +			.type = V4L2_EVENT_SOURCE_CHANGE,
> +			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
> +		};
> +
> +		struct vb2_v4l2_buffer *dst_buf =
> +			v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +
> +		update_capture_data_from_header(ctx);
> +		ctx->first_source_change_sent = true;
> +		v4l2_event_queue_fh(&ctx->fh, &rs_event);
> +		set_last_buffer(dst_buf, src_buf, ctx);
> +		ctx->source_changed = true;
> +		return 0;
> +	}
>  	return 1;
>  }
>  
> @@ -426,7 +574,7 @@ static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx, bool is_out
>  	if (is_uncomp) {
>  		const struct v4l2_fwht_pixfmt_info *info = get_q_data(ctx, f->type)->info;
>  
> -		if (ctx->is_enc)
> +		if (!info || ctx->is_enc)
>  			info = v4l2_fwht_get_pixfmt(f->index);
>  		else
>  			info = v4l2_fwht_default_fmt(info->width_div,
> @@ -477,6 +625,9 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  	q_data = get_q_data(ctx, f->type);
>  	info = q_data->info;
>  
> +	if (!info)
> +		info = v4l2_fwht_get_pixfmt(0);
> +
>  	switch (f->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> @@ -950,6 +1101,7 @@ static int vicodec_subscribe_event(struct v4l2_fh *fh,
>  {
>  	switch (sub->type) {
>  	case V4L2_EVENT_EOS:
> +	case V4L2_EVENT_SOURCE_CHANGE:
>  		return v4l2_event_subscribe(fh, sub, 0, NULL);
>  	default:
>  		return v4l2_ctrl_subscribe_event(fh, sub);
> @@ -1058,7 +1210,64 @@ static void vicodec_buf_queue(struct vb2_buffer *vb)
>  {
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct vicodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned int sz = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
> +	u8 *p_src = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
> +	u8 *p = p_src;
> +	struct vb2_queue *vq_out = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +						   V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	struct vb2_queue *vq_cap = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +						   V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +
> +	/* buf_queue handles only the first source change event */
> +	if (ctx->first_source_change_sent) {
> +		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> +		return;
> +	}
> +	/*
> +	 * if both queues are streaming, the source change event is
> +	 * handled in job_ready
> +	 */
> +	if (vb2_is_streaming(vq_cap) && vb2_is_streaming(vq_out)) {
> +		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> +		return;
> +	}
> +
> +	if (!ctx->is_enc && V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {

Do this instead:

	if (ctx->is_enc || !V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
	  	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
		return;
	}

Now you can shift the remainder of the code one tab to the left.

> +		bool header_valid = false;
> +		static const struct v4l2_event rs_event = {
> +			.type = V4L2_EVENT_SOURCE_CHANGE,
> +			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
> +		};
> +
> +		do {
> +			enum vb2_buffer_state state = get_next_header(ctx, p_src, sz,
> +								      (u8 *)&ctx->state.header,
> +								      &p);
> +
> +			if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {
> +				v4l2_m2m_buf_done(vbuf, state);
> +				return;
> +			}
> +			header_valid = is_header_valid(ctx->state.header);
> +			/*
> +			 * p points right after the end of the header in the
> +			 * buffer. If the header is invalid we set p to point
> +			 * to the next byte after the start of the header
> +			 */
> +			if (!header_valid) {
> +				p = p - sizeof(struct fwht_cframe_hdr) + 1;
> +				ctx->header_size = 0;
> +				ctx->comp_magic_cnt = 0;
> +			}
> +
> +		} while (!header_valid);
> +		if (p < p_src + sz)
> +			ctx->cur_buf_offset = p - p_src;
>  
> +		update_capture_data_from_header(ctx);
> +		ctx->first_source_change_sent = true;
> +		v4l2_event_queue_fh(&ctx->fh, &rs_event);
> +	}
>  	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
>  }
>  
> @@ -1087,73 +1296,80 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
>  	struct v4l2_fwht_state *state = &ctx->state;
>  	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
> -	unsigned int size = q_data->coded_width * q_data->coded_height;
> -	unsigned int chroma_div = info->width_div * info->height_div;
> -	unsigned int total_planes_size;
>  
> -	/*
> -	 * we don't know ahead how many components are in the encoding type
> -	 * V4L2_PIX_FMT_FWHT, so we will allocate space for 4 planes.
> -	 */
> -	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
> -		total_planes_size = 2 * size + 2 * (size / chroma_div);
> -	else if (info->components_num == 3)
> -		total_planes_size = size + 2 * (size / chroma_div);
> -	else
> -		total_planes_size = size;
> +	if (!info)
> +		return -EINVAL;
>  
>  	q_data->sequence = 0;
>  
> -	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
> -		if (!ctx->is_enc) {
> -			state->visible_width = q_data->visible_width;
> -			state->visible_height = q_data->visible_height;
> -			state->coded_width = q_data->coded_width;
> -			state->coded_height = q_data->coded_height;
> -			state->stride = q_data->coded_width * info->bytesperline_mult;
> +	ctx->last_src_buf = NULL;
> +	ctx->last_dst_buf = NULL;
> +	state->gop_cnt = 0;
> +
> +	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
> +	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
> +		unsigned int size = q_data->coded_width * q_data->coded_height;
> +		unsigned int chroma_div = info->width_div * info->height_div;
> +		unsigned int total_planes_size;
> +		u8 *new_comp_frame;
> +
> +		if (!info || info->id == V4L2_PIX_FMT_FWHT) {
> +			vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
> +			return -EINVAL;
>  		}
> -		return 0;
> -	}
> +		if (info->components_num == 4)
> +			total_planes_size = 2 * size + 2 * (size / chroma_div);
> +		else if (info->components_num == 3)
> +			total_planes_size = size + 2 * (size / chroma_div);
> +		else
> +			total_planes_size = size;
>  
> -	if (ctx->is_enc) {
>  		state->visible_width = q_data->visible_width;
>  		state->visible_height = q_data->visible_height;
>  		state->coded_width = q_data->coded_width;
>  		state->coded_height = q_data->coded_height;
>  		state->stride = q_data->coded_width * info->bytesperline_mult;
> -	}
> -	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
> -	ctx->comp_max_size = total_planes_size;
> -	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
> -	if (!state->ref_frame.luma || !state->compressed_frame) {
> -		kvfree(state->ref_frame.luma);
> -		kvfree(state->compressed_frame);
> -		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
> -		return -ENOMEM;
> -	}
> -	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num >= 3) {
> -		state->ref_frame.cb = state->ref_frame.luma + size;
> -		state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
> -	} else {
> -		state->ref_frame.cb = NULL;
> -		state->ref_frame.cr = NULL;
> -	}
>  
> -	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
> -		state->ref_frame.alpha =
> -			state->ref_frame.cr + size / chroma_div;
> -	else
> -		state->ref_frame.alpha = NULL;
> +		state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
> +		ctx->comp_max_size = total_planes_size;
> +		new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
>  
> -	ctx->last_src_buf = NULL;
> -	ctx->last_dst_buf = NULL;
> -	state->gop_cnt = 0;
> -	ctx->cur_buf_offset = 0;
> -	ctx->comp_size = 0;
> -	ctx->header_size = 0;
> -	ctx->comp_magic_cnt = 0;
> -	ctx->comp_has_frame = false;
> +		if (!state->ref_frame.luma || !new_comp_frame) {
> +			kvfree(state->ref_frame.luma);
> +			kvfree(new_comp_frame);
> +			vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
> +			return -ENOMEM;
> +		}
> +		/*
> +		 * if state->compressed_frame was already allocated then
> +		 * it contain data of the first frame of the new resolution
> +		 */
> +		if (state->compressed_frame) {
> +			if (ctx->comp_size > ctx->comp_max_size) {
> +				ctx->comp_size = ctx->comp_max_size;
> +				ctx->comp_frame_size = ctx->comp_max_size;
> +			}
> +			memcpy(new_comp_frame,
> +			       state->compressed_frame, ctx->comp_size);
> +		}
> +
> +		kvfree(state->compressed_frame);
> +		state->compressed_frame = new_comp_frame;
> +
> +		if (info->components_num >= 3) {
> +			state->ref_frame.cb = state->ref_frame.luma + size;
> +			state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
> +		} else {
> +			state->ref_frame.cb = NULL;
> +			state->ref_frame.cr = NULL;
> +		}
>  
> +		if (info->components_num == 4)
> +			state->ref_frame.alpha =
> +				state->ref_frame.cr + size / chroma_div;
> +		else
> +			state->ref_frame.alpha = NULL;
> +	}
>  	return 0;
>  }
>  
> @@ -1163,11 +1379,21 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
>  
>  	vicodec_return_bufs(q, VB2_BUF_STATE_ERROR);
>  
> -	if (!V4L2_TYPE_IS_OUTPUT(q->type))
> -		return;
> -
> -	kvfree(ctx->state.ref_frame.luma);
> -	kvfree(ctx->state.compressed_frame);
> +	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
> +	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
> +		kvfree(ctx->state.ref_frame.luma);
> +		ctx->source_changed = false;
> +	}
> +	if (V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) {
> +		ctx->cur_buf_offset = 0;
> +		ctx->comp_max_size = 0;
> +		ctx->comp_size = 0;
> +		ctx->header_size = 0;
> +		ctx->comp_magic_cnt = 0;
> +		ctx->comp_frame_size = 0;
> +		ctx->comp_has_frame = 0;
> +		ctx->comp_has_next_frame = 0;
> +	}
>  }
>  
>  static const struct vb2_ops vicodec_qops = {
> @@ -1319,16 +1545,17 @@ static int vicodec_open(struct file *file)
>  	else
>  		ctx->q_data[V4L2_M2M_SRC].sizeimage =
>  			size + sizeof(struct fwht_cframe_hdr);
> -	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
> -	ctx->q_data[V4L2_M2M_DST].info =
> -		ctx->is_enc ? &pixfmt_fwht : v4l2_fwht_get_pixfmt(0);
> -	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
> -		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
> -	if (ctx->is_enc)
> -		ctx->q_data[V4L2_M2M_DST].sizeimage =
> -			size + sizeof(struct fwht_cframe_hdr);
> -	else
> -		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
> +	if (ctx->is_enc) {
> +		ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
> +		ctx->q_data[V4L2_M2M_DST].info = &pixfmt_fwht;
> +		ctx->q_data[V4L2_M2M_DST].sizeimage = 1280 * 720 *
> +			ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
> +			ctx->q_data[V4L2_M2M_DST].info->sizeimage_div +
> +			sizeof(struct fwht_cframe_hdr);
> +	} else {
> +		ctx->q_data[V4L2_M2M_DST].info = NULL;
> +	}
> +
>  	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
>  
>  	if (ctx->is_enc) {
> 

To be honest, this patch is hard to follow. Not your fault, it simply is difficult
code. I think that I will merge a v3 (with all the comments fixed) and then see if
I can refactor things to make the code easier to understand.

And while I do that, you can start work on the stateless codec, which is after all
the goal of your project :-)

Regards,

	Hans
