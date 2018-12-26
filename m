Return-Path: <SRS0=4xye=PD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB8AC43387
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 19:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C11D620C01
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 19:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbeLZTWj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 14:22:39 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54614 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbeLZTWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 14:22:39 -0500
Received: from [IPv6:2804:431:9719:5b90:cb93:549b:79a9:1c1e] (unknown [IPv6:2804:431:9719:5b90:cb93:549b:79a9:1c1e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5BCEE260B2D;
        Wed, 26 Dec 2018 19:22:30 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH v4] media: vicodec: add support for CROP and COMPOSE
 selection
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
References: <20181223203639.77966-1-dafna3@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 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
Message-ID: <6e1030b8-4ccd-51f7-12b7-cb2a40ede702@collabora.com>
Date:   Wed, 26 Dec 2018 17:22:24 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181223203639.77966-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dafna,

Thanks for the patch, just a few comments, mostly regarding coding
style, I'll let Hans review the major logic.

On 12/23/18 6:36 PM, Dafna Hirschfeld wrote:
> Add support for the selection api for the crop and compose targets.
> The driver rounds up the coded width and height such that
> all planes dimensions are multiple of 8.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
> Changes from v3:
> In v3 mistakenly renamed some stride variables in codec-fwht.c
> to coded_width which should actually be kept named stride
> 
>  drivers/media/platform/vicodec/codec-fwht.c   |  66 ++++----
>  drivers/media/platform/vicodec/codec-fwht.h   |  15 +-
>  .../media/platform/vicodec/codec-v4l2-fwht.c  |  36 ++---
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |   6 +-
>  drivers/media/platform/vicodec/vicodec-core.c | 146 ++++++++++++++----
>  5 files changed, 187 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> index a6fd0477633b..530a5bceb2b9 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-fwht.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/string.h>
>  #include "codec-fwht.h"
> +#include <linux/kernel.h>

Please add linux/kernel.h just after linux/string.h

>  
>  /*
>   * Note: bit 0 of the header must always be 0. Otherwise it cannot
> @@ -659,7 +660,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
>  }
>  
>  static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
> -			struct fwht_cframe *cf, u32 height, u32 width,
> +			struct fwht_cframe *cf, u32 height, u32 width, u32 coded_width,

over 80 chars

>  			unsigned int input_step,
>  			bool is_intra, bool next_is_intra)
>  {
> @@ -671,7 +672,11 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>  	unsigned int last_size = 0;
>  	unsigned int i, j;
>  
> +	width = round_up(width, 8);
> +	height = round_up(height, 8);
> +
>  	for (j = 0; j < height / 8; j++) {
> +		input = input_start + j * 8 * coded_width * input_step;
>  		for (i = 0; i < width / 8; i++) {
>  			/* intra code, first frame is always intra coded. */
>  			int blocktype = IBLOCK;
> @@ -679,9 +684,9 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>  
>  			if (!is_intra)
>  				blocktype = decide_blocktype(input, refp,
> -					deltablock, width, input_step);
> +					deltablock, coded_width, input_step);
>  			if (blocktype == IBLOCK) {
> -				fwht(input, cf->coeffs, width, input_step, 1);
> +				fwht(input, cf->coeffs, coded_width, input_step, 1);

over 80 chars

I think there are other places with line over 80 chars, checkpatch
should show you the other places.

This is not a strict rule, but I would try to follow it unless you
really think it is much easier to read otherwise.

>  				quantize_intra(cf->coeffs, cf->de_coeffs,
>  					       cf->i_frame_qp);
>  			} else {
> @@ -722,7 +727,6 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>  			}
>  			last_size = size;
>  		}
> -		input += width * 7 * input_step;
>  	}
>  
>  exit_loop:
> @@ -747,29 +751,31 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>  u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		      struct fwht_raw_frame *ref_frm,
>  		      struct fwht_cframe *cf,
> -		      bool is_intra, bool next_is_intra)
> +		      bool is_intra, bool next_is_intra,
> +		      unsigned int width, unsigned int height)
>  {
> -	unsigned int size = frm->height * frm->width;
> +	unsigned int size = height * width;
>  	__be16 *rlco = cf->rlc_data;
>  	__be16 *rlco_max;
>  	u32 encoding;
>  
>  	rlco_max = rlco + size / 2 - 256;
>  	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
> -				frm->height, frm->width,
> +				height, width, frm->coded_width,
>  				frm->luma_alpha_step, is_intra, next_is_intra);
>  	if (encoding & FWHT_FRAME_UNENCODED)
>  		encoding |= FWHT_LUMA_UNENCODED;
>  	encoding &= ~FWHT_FRAME_UNENCODED;
>  
>  	if (frm->components_num >= 3) {
> -		u32 chroma_h = frm->height / frm->height_div;
> -		u32 chroma_w = frm->width / frm->width_div;
> +		u32 chroma_h = height / frm->height_div;
> +		u32 chroma_w = width / frm->width_div;
> +		u32 chroma_coded_width = frm->coded_width / frm->width_div;
>  		unsigned int chroma_size = chroma_h * chroma_w;
>  
>  		rlco_max = rlco + chroma_size / 2 - 256;
>  		encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max,
> -					 cf, chroma_h, chroma_w,
> +					 cf, chroma_h, chroma_w, chroma_coded_width,
>  					 frm->chroma_step,
>  					 is_intra, next_is_intra);
>  		if (encoding & FWHT_FRAME_UNENCODED)
> @@ -777,7 +783,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		encoding &= ~FWHT_FRAME_UNENCODED;
>  		rlco_max = rlco + chroma_size / 2 - 256;
>  		encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
> -					 cf, chroma_h, chroma_w,
> +					 cf, chroma_h, chroma_w, chroma_coded_width,
>  					 frm->chroma_step,
>  					 is_intra, next_is_intra);
>  		if (encoding & FWHT_FRAME_UNENCODED)
> @@ -788,8 +794,8 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  	if (frm->components_num == 4) {
>  		rlco_max = rlco + size / 2 - 256;
>  		encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
> -					 rlco_max, cf, frm->height, frm->width,
> -					 frm->luma_alpha_step,
> +					 rlco_max, cf, height, width,
> +					 frm->coded_width, frm->luma_alpha_step,
>  					 is_intra, next_is_intra);
>  		if (encoding & FWHT_FRAME_UNENCODED)
>  			encoding |= FWHT_ALPHA_UNENCODED;
> @@ -801,7 +807,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  }
>  
>  static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> -			 u32 height, u32 width, bool uncompressed)
> +			 u32 height, u32 width, u32 coded_width, bool uncompressed)
>  {
>  	unsigned int copies = 0;
>  	s16 copy[8 * 8];
> @@ -813,6 +819,8 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  		*rlco += width * height / 2;
>  		return;
>  	}
> +	width = round_up(width, 8);
> +	height = round_up(height, 8);
>  
>  	/*
>  	 * When decoding each macroblock the rlco pointer will be increased
> @@ -822,13 +830,13 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  	 */
>  	for (j = 0; j < height / 8; j++) {
>  		for (i = 0; i < width / 8; i++) {
> -			u8 *refp = ref + j * 8 * width + i * 8;
> +			u8 *refp = ref + j * 8 * coded_width + i * 8;
>  
>  			if (copies) {
>  				memcpy(cf->de_fwht, copy, sizeof(copy));
>  				if (stat & PFRAME_BIT)
> -					add_deltas(cf->de_fwht, refp, width);
> -				fill_decoder_block(refp, cf->de_fwht, width);
> +					add_deltas(cf->de_fwht, refp, coded_width);
> +				fill_decoder_block(refp, cf->de_fwht, coded_width);
>  				copies--;
>  				continue;
>  			}
> @@ -847,35 +855,39 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  			if (copies)
>  				memcpy(copy, cf->de_fwht, sizeof(copy));
>  			if (stat & PFRAME_BIT)
> -				add_deltas(cf->de_fwht, refp, width);
> -			fill_decoder_block(refp, cf->de_fwht, width);
> +				add_deltas(cf->de_fwht, refp, coded_width);
> +			fill_decoder_block(refp, cf->de_fwht, coded_width);
>  		}
>  	}
>  }
>  
>  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> -		       u32 hdr_flags, unsigned int components_num)
> +		       u32 hdr_flags, unsigned int components_num,
> +		       unsigned int width, unsigned int height, unsigned int coded_width)
>  {
>  	const __be16 *rlco = cf->rlc_data;
>  
> -	decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
> +	decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
>  		     hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
>  
>  	if (components_num >= 3) {
> -		u32 h = cf->height;
> -		u32 w = cf->width;
> +		u32 h = height;
> +		u32 w = width;
> +		u32 c = coded_width;
>  
>  		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT))
>  			h /= 2;
> -		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH))
> +		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)) {
>  			w /= 2;
> -		decode_plane(cf, &rlco, ref->cb, h, w,
> +			c /= 2;
> +		}
> +		decode_plane(cf, &rlco, ref->cb, h, w, c,
>  			     hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
> -		decode_plane(cf, &rlco, ref->cr, h, w,
> +		decode_plane(cf, &rlco, ref->cr, h, w, c,
>  			     hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
>  	}
>  
>  	if (components_num == 4)
> -		decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width,
> +		decode_plane(cf, &rlco, ref->alpha, height, width, coded_width,
>  			     hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
>  }
> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> index 90ff8962fca7..8163014c368c 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-fwht.h
> @@ -81,6 +81,12 @@
>  #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
>  #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
>  
> +/* A macro to calculate the needed padding in order to make sure

Multiple line comments usually starts with an empty line, and I also
would start the phrase directly with what it does:

/*
 * Calculate the needed padding in order...
...

> + * both luma and chroma components resolutions are rounded up to
> + * closest multiple of 8
> + */
> +#define vic_round_dim(dim, div) (round_up((dim) / (div), 8) * (div))
> +
>  struct fwht_cframe_hdr {
>  	u32 magic1;
>  	u32 magic2;
> @@ -95,7 +101,6 @@ struct fwht_cframe_hdr {
>  };
>  
>  struct fwht_cframe {
> -	unsigned int width, height;
>  	u16 i_frame_qp;
>  	u16 p_frame_qp;
>  	__be16 *rlc_data;
> @@ -106,12 +111,12 @@ struct fwht_cframe {
>  };
>  
>  struct fwht_raw_frame {
> -	unsigned int width, height;
>  	unsigned int width_div;
>  	unsigned int height_div;
>  	unsigned int luma_alpha_step;
>  	unsigned int chroma_step;
>  	unsigned int components_num;
> +	unsigned int coded_width;
>  	u8 *luma, *cb, *cr, *alpha;
>  };
>  
> @@ -125,8 +130,10 @@ struct fwht_raw_frame {
>  u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		      struct fwht_raw_frame *ref_frm,
>  		      struct fwht_cframe *cf,
> -		      bool is_intra, bool next_is_intra);
> +		      bool is_intra, bool next_is_intra,
> +		      unsigned int width, unsigned int height);
>  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> -		       u32 hdr_flags, unsigned int components_num);
> +		       u32 hdr_flags, unsigned int components_num,
> +		       unsigned int width, unsigned int height, unsigned int coded_width);
>  
>  #endif
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index 8cb0212df67f..652296bdd250 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -56,7 +56,7 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
>  
>  int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  {
> -	unsigned int size = state->width * state->height;
> +	unsigned int size;

You could initialize it here:
        unsigned int size = state->coded_width * state->coded_height

>  	const struct v4l2_fwht_pixfmt_info *info = state->info;
>  	struct fwht_cframe_hdr *p_hdr;
>  	struct fwht_cframe cf;
> @@ -66,8 +66,9 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  
>  	if (!info)
>  		return -EINVAL;
> -	rf.width = state->width;
> -	rf.height = state->height;
> +
> +	size = state->coded_width * state->coded_height;
> +	rf.coded_width = state->coded_width;
>  	rf.luma = p_in;
>  	rf.width_div = info->width_div;
>  	rf.height_div = info->height_div;
> @@ -163,15 +164,14 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  		return -EINVAL;
>  	}
>  
> -	cf.width = state->width;
> -	cf.height = state->height;
>  	cf.i_frame_qp = state->i_frame_qp;
>  	cf.p_frame_qp = state->p_frame_qp;
>  	cf.rlc_data = (__be16 *)(p_out + sizeof(*p_hdr));
>  
>  	encoding = fwht_encode_frame(&rf, &state->ref_frame, &cf,
>  				     !state->gop_cnt,
> -				     state->gop_cnt == state->gop_size - 1);
> +				     state->gop_cnt == state->gop_size - 1,
> +				     state->visible_width, state->visible_height);
>  	if (!(encoding & FWHT_FRAME_PCODED))
>  		state->gop_cnt = 0;
>  	if (++state->gop_cnt >= state->gop_size)
> @@ -181,8 +181,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	p_hdr->magic1 = FWHT_MAGIC1;
>  	p_hdr->magic2 = FWHT_MAGIC2;
>  	p_hdr->version = htonl(FWHT_VERSION);
> -	p_hdr->width = htonl(cf.width);
> -	p_hdr->height = htonl(cf.height);
> +	p_hdr->width = htonl(state->visible_width);
> +	p_hdr->height = htonl(state->visible_height);
>  	flags |= (info->components_num - 1) << FWHT_FL_COMPONENTS_NUM_OFFSET;
>  	if (encoding & FWHT_LUMA_UNENCODED)
>  		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
> @@ -202,15 +202,13 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	p_hdr->ycbcr_enc = htonl(state->ycbcr_enc);
>  	p_hdr->quantization = htonl(state->quantization);
>  	p_hdr->size = htonl(cf.size);
> -	state->ref_frame.width = cf.width;
> -	state->ref_frame.height = cf.height;
>  	return cf.size + sizeof(*p_hdr);
>  }
>  
>  int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  {
> -	unsigned int size = state->width * state->height;
> -	unsigned int chroma_size = size;
> +	unsigned int size;
> +	unsigned int chroma_size;
>  	unsigned int i;
>  	u32 flags;
>  	struct fwht_cframe_hdr *p_hdr;
> @@ -218,13 +216,15 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	u8 *p;
>  	unsigned int components_num = 3;
>  	unsigned int version;
> +	const struct v4l2_fwht_pixfmt_info *info;
>  
>  	if (!state->info)
>  		return -EINVAL;
>  
> +	info = state->info;
> +	size = state->coded_width * state->coded_height;
> +	chroma_size = size;
>  	p_hdr = (struct fwht_cframe_hdr *)p_in;
> -	cf.width = ntohl(p_hdr->width);
> -	cf.height = ntohl(p_hdr->height);
>  
>  	version = ntohl(p_hdr->version);
>  	if (!version || version > FWHT_VERSION) {
> @@ -234,12 +234,11 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	}
>  
>  	if (p_hdr->magic1 != FWHT_MAGIC1 ||
> -	    p_hdr->magic2 != FWHT_MAGIC2 ||
> -	    (cf.width & 7) || (cf.height & 7))
> +	    p_hdr->magic2 != FWHT_MAGIC2)
>  		return -EINVAL;
>  
>  	/* TODO: support resolution changes */
> -	if (cf.width != state->width || cf.height != state->height)
> +	if (ntohl(p_hdr->width) != state->visible_width || ntohl(p_hdr->height) != state->visible_height)
>  		return -EINVAL;
>  
>  	flags = ntohl(p_hdr->flags);
> @@ -260,7 +259,8 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
>  		chroma_size /= 2;
>  
> -	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num);
> +	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
> +			  state->visible_width, state->visible_height, state->coded_width);
>  
>  	/*
>  	 * TODO - handle the case where the compressed stream encodes a
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> index ed53e28d4f9c..2a09ad13ddd6 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> @@ -23,8 +23,10 @@ struct v4l2_fwht_pixfmt_info {
>  
>  struct v4l2_fwht_state {
>  	const struct v4l2_fwht_pixfmt_info *info;
> -	unsigned int width;
> -	unsigned int height;
> +	unsigned int visible_width;
> +	unsigned int visible_height;
> +	unsigned int coded_width;
> +	unsigned int coded_height;
>  	unsigned int gop_size;
>  	unsigned int gop_cnt;
>  	u16 i_frame_qp;
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 0d7876f5acf0..91e7e4c6fa49 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -75,8 +75,10 @@ static struct platform_device vicodec_pdev = {
>  
>  /* Per-queue, driver-specific private data */
>  struct vicodec_q_data {
> -	unsigned int		width;
> -	unsigned int		height;
> +	unsigned int		coded_width;
> +	unsigned int		coded_height;
> +	unsigned int		visible_width;
> +	unsigned int		visible_height;
>  	unsigned int		sizeimage;
>  	unsigned int		sequence;
>  	const struct v4l2_fwht_pixfmt_info *info;
> @@ -464,11 +466,11 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		if (multiplanar)
>  			return -EINVAL;
>  		pix = &f->fmt.pix;
> -		pix->width = q_data->width;
> -		pix->height = q_data->height;
> +		pix->width = q_data->coded_width;
> +		pix->height = q_data->coded_height;
>  		pix->field = V4L2_FIELD_NONE;
>  		pix->pixelformat = info->id;
> -		pix->bytesperline = q_data->width * info->bytesperline_mult;
> +		pix->bytesperline = q_data->coded_width * info->bytesperline_mult;
>  		pix->sizeimage = q_data->sizeimage;
>  		pix->colorspace = ctx->state.colorspace;
>  		pix->xfer_func = ctx->state.xfer_func;
> @@ -481,13 +483,13 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		if (!multiplanar)
>  			return -EINVAL;
>  		pix_mp = &f->fmt.pix_mp;
> -		pix_mp->width = q_data->width;
> -		pix_mp->height = q_data->height;
> +		pix_mp->width = q_data->coded_width;
> +		pix_mp->height = q_data->coded_height;
>  		pix_mp->field = V4L2_FIELD_NONE;
>  		pix_mp->pixelformat = info->id;
>  		pix_mp->num_planes = 1;
>  		pix_mp->plane_fmt[0].bytesperline =
> -				q_data->width * info->bytesperline_mult;
> +				q_data->coded_width * info->bytesperline_mult;
>  		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage;
>  		pix_mp->colorspace = ctx->state.colorspace;
>  		pix_mp->xfer_func = ctx->state.xfer_func;
> @@ -528,8 +530,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		pix = &f->fmt.pix;
>  		if (pix->pixelformat != V4L2_PIX_FMT_FWHT)
>  			info = find_fmt(pix->pixelformat);
> -		pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
> -		pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
> +		pix->width = vic_round_dim(clamp(pix->width, MIN_WIDTH, MAX_WIDTH), info->width_div);
> +		pix->height = vic_round_dim(clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);
>  		pix->field = V4L2_FIELD_NONE;
>  		pix->bytesperline =
>  			pix->width * info->bytesperline_mult;> @@ -545,9 +547,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx,
struct v4l2_format *f)
>  		if (pix_mp->pixelformat != V4L2_PIX_FMT_FWHT)
>  			info = find_fmt(pix_mp->pixelformat);
>  		pix_mp->num_planes = 1;
> -		pix_mp->width = clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH) & ~7;
> -		pix_mp->height =
> -			clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
> +		pix_mp->width = vic_round_dim(clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH), info->width_div);
> +		pix_mp->height = vic_round_dim(clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);
>  		pix_mp->field = V4L2_FIELD_NONE;
>  		plane->bytesperline =
>  			pix_mp->width * info->bytesperline_mult;
> @@ -658,8 +659,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
>  			fmt_changed =
>  				q_data->info->id != pix->pixelformat ||
> -				q_data->width != pix->width ||
> -				q_data->height != pix->height;
> +				q_data->coded_width != pix->width ||
> +				q_data->coded_height != pix->height;
>  
>  		if (vb2_is_busy(vq) && fmt_changed)
>  			return -EBUSY;
> @@ -668,8 +669,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  			q_data->info = &pixfmt_fwht;
>  		else
>  			q_data->info = find_fmt(pix->pixelformat);
> -		q_data->width = pix->width;
> -		q_data->height = pix->height;
> +		q_data->coded_width = pix->width;
> +		q_data->coded_height = pix->height;
>  		q_data->sizeimage = pix->sizeimage;
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> @@ -678,8 +679,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
>  			fmt_changed =
>  				q_data->info->id != pix_mp->pixelformat ||
> -				q_data->width != pix_mp->width ||
> -				q_data->height != pix_mp->height;
> +				q_data->coded_width != pix_mp->width ||
> +				q_data->coded_height != pix_mp->height;
>  
>  		if (vb2_is_busy(vq) && fmt_changed)
>  			return -EBUSY;
> @@ -688,17 +689,23 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  			q_data->info = &pixfmt_fwht;
>  		else
>  			q_data->info = find_fmt(pix_mp->pixelformat);
> -		q_data->width = pix_mp->width;
> -		q_data->height = pix_mp->height;
> +		q_data->coded_width = pix_mp->width;
> +		q_data->coded_height = pix_mp->height;
>  		q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
>  		break;
>  	default:
>  		return -EINVAL;
>  	}
> +	if (q_data->visible_width > q_data->coded_width)
> +		q_data->visible_width = q_data->coded_width;
> +	if (q_data->visible_height > q_data->coded_height)
> +		q_data->visible_height = q_data->coded_height;
> +
>  
>  	dprintk(ctx->dev,
> -		"Setting format for type %d, wxh: %dx%d, fourcc: %08x\n",
> -		f->type, q_data->width, q_data->height, q_data->info->id);
> +		"Setting format for type %d, coded wxh: %dx%d, visible wxh: %dx%d, fourcc: %08x\n",
> +		f->type, q_data->coded_width, q_data->coded_height,
> +		q_data->visible_width, q_data->visible_height, q_data->info->id);
>  
>  	return 0;
>  }
> @@ -753,6 +760,75 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
>  	return ret;
>  }
>  
> +static int vidioc_g_selection(struct file *file, void *priv,
> +			      struct v4l2_selection *s)
> +{
> +	struct vicodec_ctx *ctx = file2ctx(file);
> +	struct vicodec_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +	/*
> +	 * encoder supports only cropping on the OUTPUT buffer
> +	 * decoder supports only composing on the CAPTURE buffer
> +	 */
> +	if ((ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
> +	    (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {

Shouldn't you use the macro V4L2_TYPE_IS_OUTPUT(type) ? Or at least
compare it with V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE and
V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE too no?

> +		switch (s->target) {
> +		case V4L2_SEL_TGT_COMPOSE:
> +		case V4L2_SEL_TGT_CROP:
> +			s->r.left = 0;
> +			s->r.top = 0;
> +			s->r.width = q_data->visible_width;
> +			s->r.height = q_data->visible_height;
> +			return 0;
> +		case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		case V4L2_SEL_TGT_CROP_DEFAULT:
> +		case V4L2_SEL_TGT_CROP_BOUNDS:
> +			s->r.left = 0;
> +			s->r.top = 0;
> +			s->r.width = q_data->coded_width;
> +			s->r.height = q_data->coded_height;
> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vidioc_s_selection(struct file *file, void *priv,
> +			      struct v4l2_selection *s)
> +{
> +	struct vicodec_ctx *ctx = file2ctx(file);
> +	struct vicodec_q_data *q_data;
> +	bool is_out_crop_on_enc;
> +	bool is_cap_compose_on_dec;
> +
> +	q_data = get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	is_out_crop_on_enc = ctx->is_enc &&
> +			     s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> +			     s->target == V4L2_SEL_TGT_CROP;

Shoulnd't it be checked against V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE too?

> +
> +	is_cap_compose_on_dec = !ctx->is_enc &&
> +				s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +				s->target == V4L2_SEL_TGT_COMPOSE;

Shoulnd't it be checked against V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE too?

> +
> +	if (is_out_crop_on_enc || is_cap_compose_on_dec) {
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		q_data->visible_width = clamp(s->r.width, MIN_WIDTH, q_data->coded_width);
> +		s->r.width = q_data->visible_width;
> +		q_data->visible_height = clamp(s->r.height, MIN_HEIGHT, q_data->coded_height);
> +		s->r.height = q_data->visible_height;
> +		return 0;
> +	}

You could avoid this big identation block by doing:

if (!is_out_crop_on_enc && !is_cap_compose_on_dec)
	return -EINVAL;

s->r.left = 0;
...
return 0;


> +	return -EINVAL;
> +}
> +
>  static void vicodec_mark_last_buf(struct vicodec_ctx *ctx)
>  {
>  	static const struct v4l2_event eos_event = {
> @@ -895,6 +971,9 @@ static const struct v4l2_ioctl_ops vicodec_ioctl_ops = {
>  	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
>  	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
>  
> +	.vidioc_g_selection	= vidioc_g_selection,
> +	.vidioc_s_selection	= vidioc_s_selection,
> +
>  	.vidioc_try_encoder_cmd	= vicodec_try_encoder_cmd,
>  	.vidioc_encoder_cmd	= vicodec_encoder_cmd,
>  	.vidioc_try_decoder_cmd	= vicodec_try_decoder_cmd,
> @@ -988,8 +1067,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  	struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
>  	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
>  	struct v4l2_fwht_state *state = &ctx->state;
> -	unsigned int size = q_data->width * q_data->height;
>  	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
> +	unsigned int size = q_data->coded_width * q_data->coded_height;
>  	unsigned int chroma_div = info->width_div * info->height_div;
>  	unsigned int total_planes_size;
>  
> @@ -1008,17 +1087,20 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  
>  	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
>  		if (!ctx->is_enc) {
> -			state->width = q_data->width;
> -			state->height = q_data->height;
> +			state->visible_width = q_data->visible_width;
> +			state->visible_height = q_data->visible_height;
> +			state->coded_width = q_data->coded_width;
> +			state->coded_height = q_data->coded_height;
>  		}
>  		return 0;
>  	}
>  
>  	if (ctx->is_enc) {
> -		state->width = q_data->width;
> -		state->height = q_data->height;
> +		state->visible_width = q_data->visible_width;
> +		state->visible_height = q_data->visible_height;
> +		state->coded_width = q_data->coded_width;
> +		state->coded_height = q_data->coded_height;
>  	}
> -	state->ref_frame.width = state->ref_frame.height = 0;
>  	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
>  	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
>  	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
> @@ -1204,8 +1286,10 @@ static int vicodec_open(struct file *file)
>  
>  	ctx->q_data[V4L2_M2M_SRC].info =
>  		ctx->is_enc ? v4l2_fwht_get_pixfmt(0) : &pixfmt_fwht;
> -	ctx->q_data[V4L2_M2M_SRC].width = 1280;
> -	ctx->q_data[V4L2_M2M_SRC].height = 720;
> +	ctx->q_data[V4L2_M2M_SRC].coded_width = 1280;
> +	ctx->q_data[V4L2_M2M_SRC].coded_height = 720;
> +	ctx->q_data[V4L2_M2M_SRC].visible_width = 1280;
> +	ctx->q_data[V4L2_M2M_SRC].visible_height = 720;
>  	size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
>  		ctx->q_data[V4L2_M2M_SRC].info->sizeimage_div;
>  	if (ctx->is_enc)
> 

Regards,
Helen
