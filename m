Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624FBC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A01620818
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfBSKaS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:30:18 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54258 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727023AbfBSKaS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 05:30:18 -0500
Received: from [IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205] ([IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205])
        by smtp-cloud9.xs4all.net with ESMTPA
        id w2fDgYsn5I8AWw2fHgFDUn; Tue, 19 Feb 2019 11:30:15 +0100
Subject: Re: [PATCH v2 04/10] media: vicodec: keep the ref frame according to
 the format in decoder
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190215130509.86290-1-dafna3@gmail.com>
 <20190215130509.86290-5-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <61bd73d9-c157-e121-c597-c8b6876024ac@xs4all.nl>
Date:   Tue, 19 Feb 2019 11:30:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190215130509.86290-5-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCp7aJ0HD61p0hiQUcZvgy1ECQnkXJBnIdgSdHgqO+egpV6jnuTfyutsafglvLRPT9p3wmp14+KACTD/2YSJ53UV+7vvjkgMeo1hEG6hiqtjie0GLdu4
 /owe9INjQxOlehMlptK7pT89nI9OPRXCNlv25uzH4C/29pWOQS6Amc3OFuFq25x/T6NuwweGMyhRqrUM0Wy9OMFE0IWUAXOuFCY444HgekQwz3pqmH1f+C09
 HhQCrTUEC/F/jSHbJCtR1mHGjl90/jUi/yb1QUZyyE8l5WoVvAdss8b5Lt5Myz8MpwpEouBWzWrjz7WbROJ+hiXRQUt0T1ek3F44x5hK3R61j4AdnfNsRSvF
 z+zZWi9d
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/15/19 2:05 PM, Dafna Hirschfeld wrote:
> In the decoder, save the inner reference frame in the same
> format as the capture buffer.
> The decoder writes directly to the capture buffer and then
> the capture buffer is copied to the reference buffer.
> This will simplify the stateless decoder.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/codec-fwht.c   |  68 +++--
>  drivers/media/platform/vicodec/codec-fwht.h   |  10 +-
>  .../media/platform/vicodec/codec-v4l2-fwht.c  | 280 +++---------------
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |   3 +
>  drivers/media/platform/vicodec/vicodec-core.c |   2 +
>  5 files changed, 103 insertions(+), 260 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> index d1d6085da9f1..42849476069b 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-fwht.c
> @@ -632,12 +632,13 @@ static int decide_blocktype(const u8 *cur, const u8 *reference,
>  	return vari <= vard ? IBLOCK : PBLOCK;
>  }
>  
> -static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
> +static void fill_decoder_block(u8 *dst, const s16 *input, int stride,
> +			       unsigned int dst_step)
>  {
>  	int i, j;
>  
>  	for (i = 0; i < 8; i++) {
> -		for (j = 0; j < 8; j++, input++, dst++) {
> +		for (j = 0; j < 8; j++, input++, dst += dst_step) {
>  			if (*input < 0)
>  				*dst = 0;
>  			else if (*input > 255)
> @@ -645,17 +646,19 @@ static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
>  			else
>  				*dst = *input;
>  		}
> -		dst += stride - 8;
> +		dst += stride - (8 * dst_step);
>  	}
>  }
>  
> -static void add_deltas(s16 *deltas, const u8 *ref, int stride)
> +static void add_deltas(s16 *deltas, const u8 *ref, int stride,
> +		       unsigned int ref_step)
>  {
>  	int k, l;
>  
>  	for (k = 0; k < 8; k++) {
>  		for (l = 0; l < 8; l++) {
> -			*deltas += *ref++;
> +			*deltas += *ref;
> +			ref += ref_step;
>  			/*
>  			 * Due to quantizing, it might possible that the
>  			 * decoded coefficients are slightly out of range
> @@ -666,7 +669,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
>  				*deltas = 255;
>  			deltas++;
>  		}
> -		ref += stride - 8;
> +		ref += stride - (8 * ref_step);
>  	}
>  }
>  
> @@ -711,8 +714,8 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>  				ifwht(cf->de_coeffs, cf->de_fwht, blocktype);
>  
>  				if (blocktype == PBLOCK)
> -					add_deltas(cf->de_fwht, refp, 8);
> -				fill_decoder_block(refp, cf->de_fwht, 8);
> +					add_deltas(cf->de_fwht, refp, 8, 1);
> +				fill_decoder_block(refp, cf->de_fwht, 8, 1);
>  			}
>  
>  			input += 8 * input_step;
> @@ -821,8 +824,10 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  	return encoding;
>  }
>  
> -static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> -			 u32 height, u32 width, u32 coded_width,
> +static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco,
> +			 const u8 *ref, u32 height, u32 width, u32 coded_width,
> +			 u8 *dst, unsigned int dst_stride,
> +			 unsigned int dst_step, unsigned int ref_step,
>  			 bool uncompressed, const __be16 *end_of_rlco_buf)
>  {
>  	unsigned int copies = 0;
> @@ -834,10 +839,15 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  	height = round_up(height, 8);
>  
>  	if (uncompressed) {
> +		int i;
> +
>  		if (end_of_rlco_buf + 1 < *rlco + width * height / 2)
>  			return false;
> -		memcpy(ref, *rlco, width * height);
> -		*rlco += width * height / 2;
> +		for (i = 0; i < height; i++) {
> +			memcpy(dst, *rlco, width);
> +			dst += dst_stride;
> +			*rlco += width / 2;
> +		}
>  		return true;
>  	}
>  
> @@ -849,15 +859,18 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  	 */
>  	for (j = 0; j < height / 8; j++) {
>  		for (i = 0; i < width / 8; i++) {
> -			u8 *refp = ref + j * 8 * coded_width + i * 8;
> +			const u8 *refp = ref + j * 8 * ref_step * coded_width +
> +				i * 8 * ref_step;
> +			u8 *dstp = dst + j * 8 * dst_stride + i * 8 * dst_step;
>  
>  			if (copies) {
>  				memcpy(cf->de_fwht, copy, sizeof(copy));
>  				if (stat & PFRAME_BIT)
>  					add_deltas(cf->de_fwht, refp,
> -						   coded_width);
> -				fill_decoder_block(refp, cf->de_fwht,
> -						   coded_width);
> +						   coded_width * ref_step,
> +						   ref_step);
> +				fill_decoder_block(dstp, cf->de_fwht,
> +						   dst_stride, dst_step);
>  				copies--;
>  				continue;
>  			}
> @@ -877,23 +890,28 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  			if (copies)
>  				memcpy(copy, cf->de_fwht, sizeof(copy));
>  			if (stat & PFRAME_BIT)
> -				add_deltas(cf->de_fwht, refp, coded_width);
> -			fill_decoder_block(refp, cf->de_fwht, coded_width);
> +				add_deltas(cf->de_fwht, refp,
> +					   coded_width * ref_step, ref_step);
> +			fill_decoder_block(dstp, cf->de_fwht, dst_stride,
> +					   dst_step);
>  		}
>  	}
>  	return true;
>  }
>  
> -bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> +bool fwht_decode_frame(struct fwht_cframe *cf, const struct fwht_raw_frame *ref,
>  		       u32 hdr_flags, unsigned int components_num,
>  		       unsigned int width, unsigned int height,
> -		       unsigned int coded_width)
> +		       unsigned int coded_width, struct fwht_raw_frame *dst,
> +		       unsigned int dst_stride, unsigned int dst_chroma_stride)
>  {
>  	const __be16 *rlco = cf->rlc_data;
>  	const __be16 *end_of_rlco_buf = cf->rlc_data +
>  			(cf->size / sizeof(*rlco)) - 1;
>  
>  	if (!decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
> +			  dst->luma, dst_stride, dst->luma_alpha_step,
> +			  ref->luma_alpha_step,
>  			  hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED,
>  			  end_of_rlco_buf))
>  		return false;
> @@ -909,11 +927,15 @@ bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
>  			w /= 2;
>  			c /= 2;
>  		}
> -		if (!decode_plane(cf, &rlco, ref->cb, h, w, c,
> +		if (!decode_plane(cf, &rlco, ref->cb, h, w, c, dst->cb,
> +				  dst_chroma_stride, dst->chroma_step,
> +				  ref->chroma_step,
>  				  hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED,
>  				  end_of_rlco_buf))
>  			return false;
> -		if (!decode_plane(cf, &rlco, ref->cr, h, w, c,
> +		if (!decode_plane(cf, &rlco, ref->cr, h, w, c, dst->cr,
> +				  dst_chroma_stride, dst->chroma_step,
> +				  ref->chroma_step,
>  				  hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED,
>  				  end_of_rlco_buf))
>  			return false;
> @@ -922,6 +944,8 @@ bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
>  	if (components_num == 4)
>  		if (!decode_plane(cf, &rlco, ref->alpha, height, width,
>  				  coded_width,
> +				  dst->alpha, dst_stride, dst->luma_alpha_step,
> +				  ref->luma_alpha_step,
>  				  hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED,
>  				  end_of_rlco_buf))
>  			return false;
> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> index 8a4f07d466cb..eab4a97aa132 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-fwht.h
> @@ -140,9 +140,9 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		      bool is_intra, bool next_is_intra,
>  		      unsigned int width, unsigned int height,
>  		      unsigned int stride, unsigned int chroma_stride);
> -bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> -		       u32 hdr_flags, unsigned int components_num,
> -		       unsigned int width, unsigned int height,
> -		       unsigned int coded_width);
> -
> +bool fwht_decode_frame(struct fwht_cframe *cf, const struct fwht_raw_frame *ref,
> +		u32 hdr_flags, unsigned int components_num,
> +		unsigned int width, unsigned int height,
> +		unsigned int coded_width, struct fwht_raw_frame *dst,
> +		unsigned int dst_stride, unsigned int dst_chroma_stride);
>  #endif
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index 728ed5012aed..40b1f4901fd3 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -75,6 +75,35 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
>  	return v4l2_fwht_pixfmts + idx;
>  }
>  
> +void copy_cap_to_ref(u8 *cap, const struct v4l2_fwht_pixfmt_info *info,
> +		     struct v4l2_fwht_state *state)

Should be a static function and cap should be const u8 *.

> +{
> +	int plane_idx;
> +	u8 *p_ref = state->ref_frame.buf;
> +
> +	for (plane_idx = 0; plane_idx < info->planes_num; plane_idx++) {
> +		int i;
> +		bool is_chroma_plane = plane_idx == 1 || plane_idx == 2;
> +		unsigned int h_div = is_chroma_plane ? info->height_div : 1;
> +		unsigned int w_div = is_chroma_plane ? info->width_div : 1;
> +		unsigned int step = is_chroma_plane ? info->chroma_step :
> +			info->luma_alpha_step;
> +		unsigned int stride_div =
> +			(info->planes_num == 3 && plane_idx > 0) ? 2 : 1;
> +
> +		u8 *row_dst = cap;

I'd call this row_cap. 'dst' is confusing since you expect a memcpy to write
to the destination address, but this isn't the 'destination', it is just a
row in the capture buffer.

It really confused me for a bit :-)

Regards,

	Hans

> +		u8 *row_ref = p_ref;
> +
> +		for (i = 0; i < state->visible_height / h_div; i++) {
> +			memcpy(row_ref, row_dst, step * state->visible_width / w_div);
> +			row_ref += step * state->coded_width / w_div;
> +			row_dst += state->stride / stride_div;
> +		}
> +		cap += (state->stride / stride_div) * (state->coded_height / h_div);
> +		p_ref += (step * state->coded_width / w_div) * (state->coded_height / h_div);
> +	}
> +}
> +
>  static int prepare_raw_frame(struct fwht_raw_frame *rf,
>  			 const struct v4l2_fwht_pixfmt_info *info, u8 *buf,
>  			 unsigned int size)
> @@ -243,14 +272,16 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  
>  int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  {
> -	unsigned int i, j, k;
>  	u32 flags;
>  	struct fwht_cframe cf;
> -	u8 *p, *ref_p;
>  	unsigned int components_num = 3;
>  	unsigned int version;
>  	const struct v4l2_fwht_pixfmt_info *info;
>  	unsigned int hdr_width_div, hdr_height_div;
> +	struct fwht_raw_frame dst_rf;
> +	unsigned int dst_chroma_stride = state->stride;
> +	unsigned int dst_size = state->stride * state->coded_height;
> +	unsigned int ref_size;
>  
>  	if (!state->info)
>  		return -EINVAL;
> @@ -298,241 +329,24 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	    hdr_height_div != info->height_div)
>  		return -EINVAL;
>  
> -	if (!fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
> -			       state->visible_width, state->visible_height,
> -			       state->coded_width))
> +	if (prepare_raw_frame(&dst_rf, info, p_out, dst_size))
>  		return -EINVAL;
> +	if (info->id == V4L2_PIX_FMT_YUV420 ||
> +	    info->id == V4L2_PIX_FMT_YVU420 ||
> +	    info->id == V4L2_PIX_FMT_YUV422P)
> +		dst_chroma_stride /= 2;
>  
> -	/*
> -	 * TODO - handle the case where the compressed stream encodes a
> -	 * different format than the requested decoded format.
> -	 */
> -	switch (state->info->id) {
> -	case V4L2_PIX_FMT_GREY:
> -		ref_p = state->ref_frame.luma;
> -		for (i = 0; i < state->coded_height; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width);
> -			p_out += state->stride;
> -			ref_p += state->coded_width;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_YUV420:
> -	case V4L2_PIX_FMT_YUV422P:
> -		ref_p = state->ref_frame.luma;
> -		for (i = 0; i < state->coded_height; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width);
> -			p_out += state->stride;
> -			ref_p += state->coded_width;
> -		}
> -
> -		ref_p = state->ref_frame.cb;
> -		for (i = 0; i < state->coded_height / 2; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width / 2);
> -			p_out += state->stride / 2;
> -			ref_p += state->coded_width / 2;
> -		}
> -		ref_p = state->ref_frame.cr;
> -		for (i = 0; i < state->coded_height / 2; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width / 2);
> -			p_out += state->stride / 2;
> -			ref_p += state->coded_width / 2;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_YVU420:
> -		ref_p = state->ref_frame.luma;
> -		for (i = 0; i < state->coded_height; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width);
> -			p_out += state->stride;
> -			ref_p += state->coded_width;
> -		}
> -
> -		ref_p = state->ref_frame.cr;
> -		for (i = 0; i < state->coded_height / 2; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width / 2);
> -			p_out += state->stride / 2;
> -			ref_p += state->coded_width / 2;
> -		}
> -		ref_p = state->ref_frame.cb;
> -		for (i = 0; i < state->coded_height / 2; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width / 2);
> -			p_out += state->stride / 2;
> -			ref_p += state->coded_width / 2;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_NV12:
> -	case V4L2_PIX_FMT_NV16:
> -	case V4L2_PIX_FMT_NV24:
> -		ref_p = state->ref_frame.luma;
> -		for (i = 0; i < state->coded_height; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width);
> -			p_out += state->stride;
> -			ref_p += state->coded_width;
> -		}
> +	ref_size = state->coded_width * state->coded_height *
> +		info->luma_alpha_step;
>  
> -		k = 0;
> -		for (i = 0; i < state->coded_height / 2; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
> -				*p++ = state->ref_frame.cb[k];
> -				*p++ = state->ref_frame.cr[k];
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_NV21:
> -	case V4L2_PIX_FMT_NV61:
> -	case V4L2_PIX_FMT_NV42:
> -		ref_p = state->ref_frame.luma;
> -		for (i = 0; i < state->coded_height; i++)  {
> -			memcpy(p_out, ref_p, state->visible_width);
> -			p_out += state->stride;
> -			ref_p += state->coded_width;
> -		}
> +	if (prepare_raw_frame(&state->ref_frame, info, state->ref_frame.buf,
> +			      ref_size))
> +		return -EINVAL;
>  
> -		k = 0;
> -		for (i = 0; i < state->coded_height / 2; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
> -				*p++ = state->ref_frame.cr[k];
> -				*p++ = state->ref_frame.cb[k];
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_YUYV:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cb[k / 2];
> -				*p++ = state->ref_frame.luma[k + 1];
> -				*p++ = state->ref_frame.cr[k / 2];
> -				k += 2;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_YVYU:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cr[k / 2];
> -				*p++ = state->ref_frame.luma[k + 1];
> -				*p++ = state->ref_frame.cb[k / 2];
> -				k += 2;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_UYVY:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
> -				*p++ = state->ref_frame.cb[k / 2];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cr[k / 2];
> -				*p++ = state->ref_frame.luma[k + 1];
> -				k += 2;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_VYUY:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
> -				*p++ = state->ref_frame.cr[k / 2];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cb[k / 2];
> -				*p++ = state->ref_frame.luma[k + 1];
> -				k += 2;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_RGB24:
> -	case V4L2_PIX_FMT_HSV24:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width; j++) {
> -				*p++ = state->ref_frame.cr[k];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cb[k];
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_BGR24:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width; j++) {
> -				*p++ = state->ref_frame.cb[k];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cr[k];
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_RGB32:
> -	case V4L2_PIX_FMT_XRGB32:
> -	case V4L2_PIX_FMT_HSV32:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width; j++) {
> -				*p++ = 0;
> -				*p++ = state->ref_frame.cr[k];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cb[k];
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_BGR32:
> -	case V4L2_PIX_FMT_XBGR32:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width; j++) {
> -				*p++ = state->ref_frame.cb[k];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cr[k];
> -				*p++ = 0;
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_ARGB32:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width; j++) {
> -				*p++ = state->ref_frame.alpha[k];
> -				*p++ = state->ref_frame.cr[k];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cb[k];
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	case V4L2_PIX_FMT_ABGR32:
> -		k = 0;
> -		for (i = 0; i < state->coded_height; i++) {
> -			for (j = 0, p = p_out; j < state->coded_width; j++) {
> -				*p++ = state->ref_frame.cb[k];
> -				*p++ = state->ref_frame.luma[k];
> -				*p++ = state->ref_frame.cr[k];
> -				*p++ = state->ref_frame.alpha[k];
> -				k++;
> -			}
> -			p_out += state->stride;
> -		}
> -		break;
> -	default:
> +	if (!fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
> +			       state->visible_width, state->visible_height,
> +			       state->coded_width, &dst_rf, state->stride,
> +			       dst_chroma_stride))
>  		return -EINVAL;
> -	}
>  	return 0;
>  }
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> index aa6fa90a48be..75343cdf45e2 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> @@ -53,6 +53,9 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
>  							  u32 pixenc,
>  							  unsigned int start_idx);
>  
> +void copy_cap_to_ref(u8 *cap, const struct v4l2_fwht_pixfmt_info *info,
> +		struct v4l2_fwht_state *state);
> +
>  int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
>  int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
>  
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 8d38bc1ef079..335a931fdf02 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -194,6 +194,8 @@ static int device_process(struct vicodec_ctx *ctx,
>  		ret = v4l2_fwht_decode(state, p_src, p_dst);
>  		if (ret < 0)
>  			return ret;
> +		copy_cap_to_ref(p_dst, ctx->state.info, &ctx->state);
> +
>  		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
>  	}
>  
> 

