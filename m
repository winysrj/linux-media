Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8667EC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 10:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B40E2054F
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 10:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfAQK3z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 05:29:55 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:60164 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726917AbfAQK3z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 05:29:55 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id k4vngbNwWNR5yk4vogSSEB; Thu, 17 Jan 2019 11:29:52 +0100
Subject: Re: [PATCH v2 5/6] media: vicodec: Separate fwht header from the
 frame data
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190116152527.34411-1-dafna3@gmail.com>
 <20190116152527.34411-6-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d227d768-e9db-bddf-54c8-88b1cb963989@xs4all.nl>
Date:   Thu, 17 Jan 2019 11:29:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190116152527.34411-6-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfF2Th5JJQixGt+h4n+EqK65pSTt5KYVud6ai/FC8JFR/eIk5p+g8kyBDX1gy8rITg7VEo7jXCbvXWoAZH6O0QIXbLpY8DV1Ih97H9uSv8DjNWkK6wN8f
 Nl4momXoec3xTa0Q1mScbLmWgNrC00inW1R9JVJlIY9bQrxlKDezGVm3/qL739dOKgdz9Ng7c3lcRXyy5NON0sDLD2/+1qYakXDMeGD6aZ9kdJQe9EjZwpi6
 oNiC7KoyH4X0m/r+LWTwNUCGHaALMl1hJI1rOrhhyQ91LCtNUKO+QOFHNKxLGsMnsoyfo+mo4pYGigc8V2szbw2S5TPomM/W0WC10RNAiso=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/16/19 4:25 PM, Dafna Hirschfeld wrote:
> Keep the fwht header in separated field from the data.
> Refactor job_ready to use a new function 'get_next_header'
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  .../media/platform/vicodec/codec-v4l2-fwht.c  |  24 ++--
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |   1 +
>  drivers/media/platform/vicodec/vicodec-core.c | 118 ++++++++++--------
>  3 files changed, 81 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index 3df51d47674b..3dcf2ed24212 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -234,7 +234,6 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  {
>  	unsigned int i, j, k;
>  	u32 flags;
> -	struct fwht_cframe_hdr *p_hdr;
>  	struct fwht_cframe cf;
>  	u8 *p, *ref_p;
>  	unsigned int components_num = 3;
> @@ -246,25 +245,24 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  		return -EINVAL;
>  
>  	info = state->info;
> -	p_hdr = (struct fwht_cframe_hdr *)p_in;
>  
> -	version = ntohl(p_hdr->version);
> +	version = ntohl(state->header.version);
>  	if (!version || version > FWHT_VERSION) {
>  		pr_err("version %d is not supported, current version is %d\n",
>  		       version, FWHT_VERSION);
>  		return -EINVAL;
>  	}
>  
> -	if (p_hdr->magic1 != FWHT_MAGIC1 ||
> -	    p_hdr->magic2 != FWHT_MAGIC2)
> +	if (state->header.magic1 != FWHT_MAGIC1 ||
> +	    state->header.magic2 != FWHT_MAGIC2)
>  		return -EINVAL;
>  
>  	/* TODO: support resolution changes */
> -	if (ntohl(p_hdr->width)  != state->visible_width ||
> -	    ntohl(p_hdr->height) != state->visible_height)
> +	if (ntohl(state->header.width)  != state->visible_width ||
> +	    ntohl(state->header.height) != state->visible_height)
>  		return -EINVAL;
>  
> -	flags = ntohl(p_hdr->flags);
> +	flags = ntohl(state->header.flags);
>  
>  	if (version == FWHT_VERSION) {
>  		u32 pixenc = flags & FWHT_FL_PIXENC_MSK;
> @@ -277,11 +275,11 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  			return -EINVAL;
>  	}
>  
> -	state->colorspace = ntohl(p_hdr->colorspace);
> -	state->xfer_func = ntohl(p_hdr->xfer_func);
> -	state->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
> -	state->quantization = ntohl(p_hdr->quantization);
> -	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
> +	state->colorspace = ntohl(state->header.colorspace);
> +	state->xfer_func = ntohl(state->header.xfer_func);
> +	state->ycbcr_enc = ntohl(state->header.ycbcr_enc);
> +	state->quantization = ntohl(state->header.quantization);
> +	cf.rlc_data = (__be16 *)p_in;
>  
>  	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
>  	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> index 5787d4e6822b..1dc5169a14e5 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> @@ -41,6 +41,7 @@ struct v4l2_fwht_state {
>  	enum v4l2_quantization quantization;
>  
>  	struct fwht_raw_frame ref_frame;
> +	struct fwht_cframe_hdr header;
>  	u8 *compressed_frame;
>  };
>  
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 0df8d3509144..c97300344fbd 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -124,6 +124,7 @@ struct vicodec_ctx {
>  	u32			cur_buf_offset;
>  	u32			comp_max_size;
>  	u32			comp_size;
> +	u32			header_size;
>  	u32			comp_magic_cnt;
>  	u32			comp_frame_size;
>  	bool			comp_has_frame;
> @@ -201,6 +202,61 @@ static int device_process(struct vicodec_ctx *ctx,
>  /*
>   * mem2mem callbacks
>   */
> +enum vb2_buffer_state get_next_header(struct vicodec_ctx *ctx, u8 *p_src,
> +				      u32 sz, u8 *header, u8 **pp)

This can be simplified: there is no need to pass the header since it can be
obtained via ctx. And rather than passing p_src, sz and pp you can pass pp and
the remaining sz in the buffer.

> +{
> +	static const u8 magic[] = {
> +		0x4f, 0x4f, 0x4f, 0x4f, 0xff, 0xff, 0xff, 0xff
> +	};
> +	u8 *p = *pp;
> +	u32 state;
> +
> +	state = VB2_BUF_STATE_DONE;
> +
> +	if (!ctx->header_size) {
> +		state = VB2_BUF_STATE_ERROR;
> +		for (; p < p_src + sz; p++) {
> +			u32 copy;
> +
> +			p = memchr(p, magic[ctx->comp_magic_cnt],
> +					p_src + sz - p);
> +			if (!p) {
> +				ctx->comp_magic_cnt = 0;
> +				break;
> +			}
> +			copy = sizeof(magic) - ctx->comp_magic_cnt;
> +			if (p_src + sz - p < copy)
> +				copy = p_src + sz - p;
> +
> +			memcpy(header + ctx->comp_magic_cnt, p, copy);
> +			ctx->comp_magic_cnt += copy;
> +			if (!memcmp(header, magic, ctx->comp_magic_cnt)) {
> +				p += copy;
> +				state = VB2_BUF_STATE_DONE;
> +				break;
> +			}
> +			ctx->comp_magic_cnt = 0;
> +		}
> +		if (ctx->comp_magic_cnt < sizeof(magic)) {
> +			*pp = p;
> +			return state;
> +		}
> +		ctx->header_size = sizeof(magic);
> +	}
> +
> +	if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {
> +		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->header_size;
> +
> +		if (copy > p_src + sz - p)
> +			copy = p_src + sz - p;
> +
> +		memcpy(header + ctx->header_size, p, copy);
> +		p += copy;
> +		ctx->header_size += copy;
> +	}
> +	*pp = p;
> +	return state;
> +}

Hmm, I think the original code is a bit buggy. I don't think it will find
the correct header in some circumstances: e.g. a sequence of 5 0x4f bytes
followed by 4 0xff bytes will likely fail.

Try to prepend a 0x4f byte to a fwht bitstream and see if that works. I think
it will fail to find the header.

Anyway, that can be fixed in a separate patch.

I think a proper solution just counts the number of consecutive 0x4f bytes
and the number of consecutive 0xff bytes that follow.

The magic header sequence is found if the 0x4f count >= 4 and the 0xff count == 4.

There is no need to copy the magic header sequence to state.header in this case
since it is really just a state machine. I suspect it will actually make the code
simpler.

>  
>  /* device_run() - prepares and starts the device */
>  static void device_run(void *priv)
> @@ -241,6 +297,7 @@ static void device_run(void *priv)
>  	}
>  	v4l2_m2m_buf_done(dst_buf, state);
>  	ctx->comp_size = 0;
> +	ctx->header_size = 0;
>  	ctx->comp_magic_cnt = 0;
>  	ctx->comp_has_frame = false;
>  	spin_unlock(ctx->lock);
> @@ -291,57 +348,19 @@ static int job_ready(void *priv)
>  
>  	state = VB2_BUF_STATE_DONE;
>  
> -	if (!ctx->comp_size) {
> -		state = VB2_BUF_STATE_ERROR;
> -		for (; p < p_src + sz; p++) {
> -			u32 copy;
> +	if (ctx->header_size < sizeof(struct fwht_cframe_hdr))
> +		state = get_next_header(ctx, p_src, sz,
> +					(u8 *)&ctx->state.header, &p);
> +	if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {

This 'if' should be inside the previous 'if'.

> +		job_remove_src_buf(ctx, state);
> +		goto restart;
> +	}
>  
> -			p = memchr(p, magic[ctx->comp_magic_cnt],
> -				   p_src + sz - p);
> -			if (!p) {
> -				ctx->comp_magic_cnt = 0;
> -				break;
> -			}
> -			copy = sizeof(magic) - ctx->comp_magic_cnt;
> -			if (p_src + sz - p < copy)
> -				copy = p_src + sz - p;
> +	ctx->comp_frame_size = ntohl(ctx->state.header.size);

This line as well...

>  
> -			memcpy(ctx->state.compressed_frame + ctx->comp_magic_cnt,
> -			       p, copy);
> -			ctx->comp_magic_cnt += copy;
> -			if (!memcmp(ctx->state.compressed_frame, magic,
> -				    ctx->comp_magic_cnt)) {
> -				p += copy;
> -				state = VB2_BUF_STATE_DONE;
> -				break;
> -			}
> -			ctx->comp_magic_cnt = 0;
> -		}
> -		if (ctx->comp_magic_cnt < sizeof(magic)) {
> -			job_remove_src_buf(ctx, state);
> -			goto restart;
> -		}
> -		ctx->comp_size = sizeof(magic);
> -	}
> -	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
> -		struct fwht_cframe_hdr *p_hdr =
> -			(struct fwht_cframe_hdr *)ctx->state.compressed_frame;
> -		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->comp_size;
> +	if (ctx->comp_frame_size > ctx->comp_max_size)
> +		ctx->comp_frame_size = ctx->comp_max_size;

...and also these two. After all, this only needs to be done when a new header
was found.

>  
> -		if (copy > p_src + sz - p)
> -			copy = p_src + sz - p;
> -		memcpy(ctx->state.compressed_frame + ctx->comp_size,
> -		       p, copy);
> -		p += copy;
> -		ctx->comp_size += copy;
> -		if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
> -			job_remove_src_buf(ctx, state);
> -			goto restart;
> -		}
> -		ctx->comp_frame_size = ntohl(p_hdr->size) + sizeof(*p_hdr);
> -		if (ctx->comp_frame_size > ctx->comp_max_size)
> -			ctx->comp_frame_size = ctx->comp_max_size;
> -	}
>  	if (ctx->comp_size < ctx->comp_frame_size) {
>  		u32 copy = ctx->comp_frame_size - ctx->comp_size;
>  
> @@ -1104,7 +1123,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  		state->stride = q_data->coded_width * info->bytesperline_mult;
>  	}
>  	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
> -	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
> +	ctx->comp_max_size = total_planes_size;
>  	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
>  	if (!state->ref_frame.luma || !state->compressed_frame) {
>  		kvfree(state->ref_frame.luma);
> @@ -1131,6 +1150,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  	state->gop_cnt = 0;
>  	ctx->cur_buf_offset = 0;
>  	ctx->comp_size = 0;
> +	ctx->header_size = 0;
>  	ctx->comp_magic_cnt = 0;
>  	ctx->comp_has_frame = false;
>  
> 

Regards,

	Hans
