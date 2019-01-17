Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E483AC43612
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B382B20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfAQLvP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:51:15 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46299 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbfAQLvP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 06:51:15 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id k6CWgc5cjNR5yk6CXgSp5R; Thu, 17 Jan 2019 12:51:13 +0100
Subject: Re: [PATCH v2 6/6] media: vicodec: Add support for resolution change
 event.
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190116152527.34411-1-dafna3@gmail.com>
 <20190116152527.34411-7-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b6790f25-8586-ba6e-2cf7-65d78302d765@xs4all.nl>
Date:   Thu, 17 Jan 2019 12:51:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190116152527.34411-7-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGyyH26owCR005se46kpPxyqnzNp52g+sBw+b7szFanphG6JxRuDFChn5ihRYz3roD7AYQOVsNdsdDz5WVQdTjoJzfj4nYy2P6LDtgh4+liuKHtR1R7m
 Ol4MEHMSjTPhHAqvS0BYtRjlor3oOOZOBVhQZSuG4qNP36tx/y3LtpYsj3kTQE/ci9F0g6VtXSoLfTGNgwrJ9auiVWzCiif67nkM7jF8DPhWhII3cAQu0bi5
 hkovOio3NQvBOpoALmS5K87mFxS3/I3u7ykbjXSa8wzcnLdNXud+U+i/IE95vb7t1Ch8QwNBY6A1Ms4JADL0G1aYG3Mh/rD3P+zvljZ96HU=
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

<snip>

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

You can simplify this by doing:

	if ((V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
	    (!V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc))
		return 0;

And the remainder can be shifted one tab to the left.

Regards,

	Hans

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

