Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93321C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F25221726
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfAWJvj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 04:51:39 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:47804 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727069AbfAWJvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 04:51:38 -0500
Received: from [IPv6:2001:420:44c1:2579:d8f:48e2:1dc9:37b8] ([IPv6:2001:420:44c1:2579:d8f:48e2:1dc9:37b8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id mFBzg1rduBDyImFC3gYJE0; Wed, 23 Jan 2019 10:51:35 +0100
Subject: Re: [PATCH] media: vicodec: ensure comp frame pointer kept in range
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190122150034.49696-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5cfc7cd9-5729-f3e1-de88-8e4c53375ca2@xs4all.nl>
Date:   Wed, 23 Jan 2019 10:51:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190122150034.49696-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfE9EU7lplKVOhgchbz5Nqp117S4oHzhXEc7NKZFEGYYxvCSnulJfVrMhEYxE195NJ6dIAtdqo4Mi3uhzOqt+Lu7DO64mxZxYPH9BhVY8BkCI1zxtH90N
 EPaasEM6DO21SCmdjQ9Zzx1kPAZdKiwiODnEaCpeAFCIHDFsTrVSp064o5Nttxap4HXU4jusaF8gFXjKO1lhTeRZcFv1HKouHp6ZGeGV1lz8dTorM0S3bMFc
 loatjzwFIa8x1thHyfTHFpUfol26vUSQuQggx60A6D3iJI+B/VVfrRxWvrDQz2QmHMwT8chMkHGx07mgmkRnFfZ7MD4XrOFLkBPZVJG5lWJm6CJZPRXe2Ic3
 1k4E9AOF
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dafna,

On 01/22/19 16:00, Dafna Hirschfeld wrote:
> Make sure that the pointer to the compressed frame does not
> get out of the buffer.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/codec-fwht.c   | 73 +++++++++++++------
>  drivers/media/platform/vicodec/codec-fwht.h   |  8 +-
>  .../media/platform/vicodec/codec-v4l2-fwht.c  |  8 +-
>  drivers/media/platform/vicodec/vicodec-core.c |  4 +
>  4 files changed, 62 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> index e5e0a80c2f73..e12f04a99d3f 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-fwht.c
> @@ -104,16 +104,20 @@ static int rlc(const s16 *in, __be16 *output, int blocktype)
>   * This function will worst-case increase rlc_in by 65*2 bytes:
>   * one s16 value for the header and 8 * 8 coefficients of type s16.
>   */
> -static s16 derlc(const __be16 **rlc_in, s16 *dwht_out)
> +static int derlc(const __be16 **rlc_in, s16 *dwht_out, s16 *stat,
> +		 const __be16 *after_rlco)

Hmm. I think this is confusing.

I would add a

#define OVERFLOW_BIT BIT(14)

and return that when a buffer overrun is detected.

I'm not sure why derlc returned a s16 instead of a u16, so let's fix that
as well.

The name 'after_rlco' is, I think, very confusing. How about 'end_of_buffer'
which the last valid address of the buffer (so one less than after_rlco).

>  {
>  	/* header */
>  	const __be16 *input = *rlc_in;
> -	s16 ret = ntohs(*input++);
>  	int dec_count = 0;
>  	s16 block[8 * 8 + 16];
>  	s16 *wp = block;
>  	int i;
>  
> +	if (input >= after_rlco)
> +		return -1;
> +	*stat = ntohs(*input++);
> +
>  	/*
>  	 * Now de-compress, it expands one byte to up to 15 bytes
>  	 * (or fills the remainder of the 64 bytes with zeroes if it
> @@ -123,9 +127,15 @@ static s16 derlc(const __be16 **rlc_in, s16 *dwht_out)
>  	 * allow for overflow if the incoming data was malformed.
>  	 */
>  	while (dec_count < 8 * 8) {
> -		s16 in = ntohs(*input++);
> -		int length = in & 0xf;
> -		int coeff = in >> 4;
> +		s16 in;
> +		int length;
> +		int coeff;
> +
> +		if (input >= after_rlco)
> +			return -1;
> +		in = ntohs(*input++);
> +		length = in & 0xf;
> +		coeff = in >> 4;
>  
>  		/* fill remainder with zeros */
>  		if (length == 15) {
> @@ -150,7 +160,7 @@ static s16 derlc(const __be16 **rlc_in, s16 *dwht_out)
>  		dwht_out[x + y * 8] = *wp++;
>  	}
>  	*rlc_in = input;
> -	return ret;
> +	return 0;
>  }
>  
>  static const int quant_table[] = {
> @@ -808,9 +818,9 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  	return encoding;
>  }
>  
> -static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> -			 u32 height, u32 width, u32 coded_width,
> -			 bool uncompressed)
> +static int decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> +			u32 height, u32 width, u32 coded_width,
> +			bool uncompressed, const __be16 *after_rlco)

I think returning a bool here makes more sense: true == success, false == failure.

>  {
>  	unsigned int copies = 0;
>  	s16 copy[8 * 8];
> @@ -821,9 +831,11 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  	height = round_up(height, 8);
>  
>  	if (uncompressed) {
> +		if (after_rlco < *rlco + width * height / 2)
> +			return -1;
>  		memcpy(ref, *rlco, width * height);
>  		*rlco += width * height / 2;
> -		return;
> +		return 0;
>  	}
>  
>  	/*
> @@ -835,6 +847,7 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  	for (j = 0; j < height / 8; j++) {
>  		for (i = 0; i < width / 8; i++) {
>  			u8 *refp = ref + j * 8 * coded_width + i * 8;
> +			int ret;
>  
>  			if (copies) {
>  				memcpy(cf->de_fwht, copy, sizeof(copy));
> @@ -847,8 +860,9 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  				continue;
>  			}
>  
> -			stat = derlc(rlco, cf->coeffs);
> -
> +			ret = derlc(rlco, cf->coeffs, &stat, after_rlco);
> +			if (ret < 0)
> +				return -1;
>  			if (stat & PFRAME_BIT)
>  				dequantize_inter(cf->coeffs);
>  			else
> @@ -865,17 +879,21 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  			fill_decoder_block(refp, cf->de_fwht, coded_width);
>  		}
>  	}
> +	return 0;
>  }
>  
> -void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> -		       u32 hdr_flags, unsigned int components_num,
> -		       unsigned int width, unsigned int height,
> -		       unsigned int coded_width)
> +int fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,

Also bool.

> +		      u32 hdr_flags, unsigned int components_num,
> +		      unsigned int width, unsigned int height,
> +		      unsigned int coded_width)
>  {
>  	const __be16 *rlco = cf->rlc_data;
> +	const __be16 *after_rlco = cf->rlc_data + (cf->size / sizeof(*rlco));
>  
> -	decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
> -		     hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
> +	if (decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
> +			 hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED,
> +			 after_rlco) < 0)
> +		return -1;
>  
>  	if (components_num >= 3) {
>  		u32 h = height;
> @@ -888,13 +906,20 @@ void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
>  			w /= 2;
>  			c /= 2;
>  		}
> -		decode_plane(cf, &rlco, ref->cb, h, w, c,
> -			     hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
> -		decode_plane(cf, &rlco, ref->cr, h, w, c,
> -			     hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
> +		if (decode_plane(cf, &rlco, ref->cb, h, w, c,
> +				 hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED,
> +				 after_rlco) < 0)
> +			return -1;
> +		if (decode_plane(cf, &rlco, ref->cr, h, w, c,
> +				 hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED,
> +				 after_rlco) < 0)
> +			return -1;
>  	}
>  
>  	if (components_num == 4)
> -		decode_plane(cf, &rlco, ref->alpha, height, width, coded_width,
> -			     hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
> +		if (decode_plane(cf, &rlco, ref->alpha, height, width, coded_width,
> +				 hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED,
> +				 after_rlco) < 0)
> +			return -1;
> +	return 0;
>  }
> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> index ad8cfc60a152..ce7aa8a4d761 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-fwht.h
> @@ -139,9 +139,9 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		      bool is_intra, bool next_is_intra,
>  		      unsigned int width, unsigned int height,
>  		      unsigned int stride, unsigned int chroma_stride);
> -void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> -		       u32 hdr_flags, unsigned int components_num,
> -		       unsigned int width, unsigned int height,
> -		       unsigned int coded_width);
> +int fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> +		      u32 hdr_flags, unsigned int components_num,
> +		      unsigned int width, unsigned int height,
> +		      unsigned int coded_width);
>  
>  #endif
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index ee6903b8896c..d8c58d0a667c 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -280,6 +280,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	state->ycbcr_enc = ntohl(state->header.ycbcr_enc);
>  	state->quantization = ntohl(state->header.quantization);
>  	cf.rlc_data = (__be16 *)p_in;
> +	cf.size = ntohl(state->header.size);
>  
>  	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
>  	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
> @@ -287,9 +288,10 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	    hdr_height_div != info->height_div)
>  		return -EINVAL;
>  
> -	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
> -			  state->visible_width, state->visible_height,
> -			  state->coded_width);
> +	if (fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
> +			      state->visible_width, state->visible_height,
> +			      state->coded_width) < 0)
> +		return -EINVAL;
>  
>  	/*
>  	 * TODO - handle the case where the compressed stream encodes a
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index b84dae343645..953b9c4816a5 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -186,6 +186,10 @@ static int device_process(struct vicodec_ctx *ctx,
>  			return ret;
>  		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
>  	} else {
> +		unsigned int comp_frame_size = ntohl(ctx->state.header.size);
> +
> +		if (comp_frame_size > ctx->comp_max_size)
> +			return -EINVAL;
>  		state->info = q_dst->info;
>  		ret = v4l2_fwht_decode(state, p_src, p_dst);
>  		if (ret < 0)
> 

Regards,

	Hans
