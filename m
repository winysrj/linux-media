Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09E0C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 10:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A1B21741
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 10:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbeLTKUO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 05:20:14 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53795 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbeLTKUO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 05:20:14 -0500
Received: from [IPv6:2001:983:e9a7:1:1015:4045:7d9c:9cb8] ([IPv6:2001:983:e9a7:1:1015:4045:7d9c:9cb8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id ZvR1gol1QdllcZvR2glDau; Thu, 20 Dec 2018 11:20:10 +0100
Subject: Re: [PATCH v2] media: vicodec: add support for CROP selection in the
 encoder
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20181219121853.122797-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eb25905d-e729-9448-e119-a9d5b5dac052@xs4all.nl>
Date:   Thu, 20 Dec 2018 11:20:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181219121853.122797-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDxpsSFpn5eHu4Jp/gdnVcNzcPo6kl9PsC+rn3J0+OPWo1i3SnBzssJ2mQqUEkNunFSDQf9ZEI2vtJIh7TLM7aMdixtx0V4btbHwEs1vUZcaylUbE9Du
 228pSSQ+BbI7Co8GtpHig0O/oXuNGnQZhqZxsCVNQtfl3nVy5HDUL2vyBwooU9vuvD+osnpXlHxSrPK9fM877E5SUZwoZIYF9Z0MeVyh9Kwl6EFH931wWu9s
 f1oAv376qXe4x+r2XRdlvjbt8plELmQQ3YRDp91oiPjd43AVAJiK809k963+Yhq6ZRSDaHXbnIwK5zUqI6eRKK5SLRvGHYpCz0L1scsCHLU=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/19/18 1:18 PM, Dafna Hirschfeld wrote:
> Add support for the selection api for the crop target in the encoder.
> The driver rounds up the coded width and height such that
> all planes dimensions are multiple of 8.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
> Changes from v1:
> Renaming fields to be more descriptive.
> Setting default values to g_selection for compose and
> ignoring s_selection for compose.
> Some cleanups.
> 
>  drivers/media/platform/vicodec/codec-fwht.c   |  50 ++--
>  drivers/media/platform/vicodec/codec-fwht.h   |   9 +-
>  .../media/platform/vicodec/codec-v4l2-fwht.c  |  28 ++-
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |   6 +-
>  drivers/media/platform/vicodec/vicodec-core.c | 237 ++++++++++++++----
>  5 files changed, 241 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> index a6fd0477633b..a862442a500f 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-fwht.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/string.h>
>  #include "codec-fwht.h"
> +#include <linux/kernel.h>
>  
>  /*
>   * Note: bit 0 of the header must always be 0. Otherwise it cannot
> @@ -659,7 +660,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
>  }
>  
>  static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
> -			struct fwht_cframe *cf, u32 height, u32 width,
> +			struct fwht_cframe *cf, u32 height, u32 width, u32 stride,
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
> +		input = input_start + j * 8 * stride * input_step;
>  		for (i = 0; i < width / 8; i++) {
>  			/* intra code, first frame is always intra coded. */
>  			int blocktype = IBLOCK;
> @@ -679,9 +684,9 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>  
>  			if (!is_intra)
>  				blocktype = decide_blocktype(input, refp,
> -					deltablock, width, input_step);
> +					deltablock, stride, input_step);
>  			if (blocktype == IBLOCK) {
> -				fwht(input, cf->coeffs, width, input_step, 1);
> +				fwht(input, cf->coeffs, stride, input_step, 1);
>  				quantize_intra(cf->coeffs, cf->de_coeffs,
>  					       cf->i_frame_qp);
>  			} else {
> @@ -722,7 +727,6 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>  			}
>  			last_size = size;
>  		}
> -		input += width * 7 * input_step;
>  	}

This function now looks much better! Nice.

>  
>  exit_loop:
> @@ -756,7 +760,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  
>  	rlco_max = rlco + size / 2 - 256;
>  	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
> -				frm->height, frm->width,
> +				frm->height, frm->width, frm->stride,
>  				frm->luma_alpha_step, is_intra, next_is_intra);
>  	if (encoding & FWHT_FRAME_UNENCODED)
>  		encoding |= FWHT_LUMA_UNENCODED;
> @@ -765,11 +769,12 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  	if (frm->components_num >= 3) {
>  		u32 chroma_h = frm->height / frm->height_div;
>  		u32 chroma_w = frm->width / frm->width_div;
> +		u32 chroma_stride = frm->stride / frm->width_div;
>  		unsigned int chroma_size = chroma_h * chroma_w;
>  
>  		rlco_max = rlco + chroma_size / 2 - 256;
>  		encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max,
> -					 cf, chroma_h, chroma_w,
> +					 cf, chroma_h, chroma_w, chroma_stride,
>  					 frm->chroma_step,
>  					 is_intra, next_is_intra);
>  		if (encoding & FWHT_FRAME_UNENCODED)
> @@ -777,7 +782,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		encoding &= ~FWHT_FRAME_UNENCODED;
>  		rlco_max = rlco + chroma_size / 2 - 256;
>  		encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
> -					 cf, chroma_h, chroma_w,
> +					 cf, chroma_h, chroma_w, chroma_stride,
>  					 frm->chroma_step,
>  					 is_intra, next_is_intra);
>  		if (encoding & FWHT_FRAME_UNENCODED)
> @@ -789,7 +794,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		rlco_max = rlco + size / 2 - 256;
>  		encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
>  					 rlco_max, cf, frm->height, frm->width,
> -					 frm->luma_alpha_step,
> +					 frm->stride, frm->luma_alpha_step,
>  					 is_intra, next_is_intra);
>  		if (encoding & FWHT_FRAME_UNENCODED)
>  			encoding |= FWHT_ALPHA_UNENCODED;
> @@ -801,7 +806,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  }
>  
>  static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> -			 u32 height, u32 width, bool uncompressed)
> +			 u32 height, u32 width, u32 stride, bool uncompressed)
>  {
>  	unsigned int copies = 0;
>  	s16 copy[8 * 8];
> @@ -813,6 +818,8 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  		*rlco += width * height / 2;
>  		return;
>  	}
> +	width = round_up(width, 8);
> +	height = round_up(height, 8);
>  
>  	/*
>  	 * When decoding each macroblock the rlco pointer will be increased
> @@ -822,13 +829,13 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  	 */
>  	for (j = 0; j < height / 8; j++) {
>  		for (i = 0; i < width / 8; i++) {
> -			u8 *refp = ref + j * 8 * width + i * 8;
> +			u8 *refp = ref + j * 8 * stride + i * 8;
>  
>  			if (copies) {
>  				memcpy(cf->de_fwht, copy, sizeof(copy));
>  				if (stat & PFRAME_BIT)
> -					add_deltas(cf->de_fwht, refp, width);
> -				fill_decoder_block(refp, cf->de_fwht, width);
> +					add_deltas(cf->de_fwht, refp, stride);
> +				fill_decoder_block(refp, cf->de_fwht, stride);
>  				copies--;
>  				continue;
>  			}
> @@ -847,35 +854,38 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>  			if (copies)
>  				memcpy(copy, cf->de_fwht, sizeof(copy));
>  			if (stat & PFRAME_BIT)
> -				add_deltas(cf->de_fwht, refp, width);
> -			fill_decoder_block(refp, cf->de_fwht, width);
> +				add_deltas(cf->de_fwht, refp, stride);
> +			fill_decoder_block(refp, cf->de_fwht, stride);
>  		}
>  	}
>  }
>  
>  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> -		       u32 hdr_flags, unsigned int components_num)
> +		       u32 hdr_flags, unsigned int components_num, unsigned int stride)
>  {
>  	const __be16 *rlco = cf->rlc_data;
>  
> -	decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
> +	decode_plane(cf, &rlco, ref->luma, cf->height, cf->width, stride,
>  		     hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
>  
>  	if (components_num >= 3) {
>  		u32 h = cf->height;
>  		u32 w = cf->width;
> +		u32 s = stride;
>  
>  		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT))
>  			h /= 2;
> -		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH))
> +		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)) {
>  			w /= 2;
> -		decode_plane(cf, &rlco, ref->cb, h, w,
> +			s /= 2;
> +		}
> +		decode_plane(cf, &rlco, ref->cb, h, w, s,
>  			     hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
> -		decode_plane(cf, &rlco, ref->cr, h, w,
> +		decode_plane(cf, &rlco, ref->cr, h, w, s,
>  			     hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
>  	}
>  
>  	if (components_num == 4)
> -		decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width,
> +		decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width, stride,
>  			     hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
>  }
> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> index 90ff8962fca7..1da0a2384b48 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-fwht.h
> @@ -81,6 +81,12 @@
>  #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
>  #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
>  
> +/* A macro to calculate the needed padding in order to make sure
> + * both luma and chroma components resolutions are rounded up to
> + * closest multiple of 8
> + */
> +#define vic_round_dim(dim, div) (round_up((dim) / (div), 8) * (div))
> +
>  struct fwht_cframe_hdr {
>  	u32 magic1;
>  	u32 magic2;
> @@ -112,6 +118,7 @@ struct fwht_raw_frame {
>  	unsigned int luma_alpha_step;
>  	unsigned int chroma_step;
>  	unsigned int components_num;
> +	unsigned int stride;
>  	u8 *luma, *cb, *cr, *alpha;
>  };
>  
> @@ -127,6 +134,6 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  		      struct fwht_cframe *cf,
>  		      bool is_intra, bool next_is_intra);
>  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> -		       u32 hdr_flags, unsigned int components_num);
> +		       u32 hdr_flags, unsigned int components_num, unsigned int stride);
>  
>  #endif
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index 8cb0212df67f..32a1216e66e6 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -56,7 +56,7 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
>  
>  int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  {
> -	unsigned int size = state->width * state->height;
> +	unsigned int size;
>  	const struct v4l2_fwht_pixfmt_info *info = state->info;
>  	struct fwht_cframe_hdr *p_hdr;
>  	struct fwht_cframe cf;
> @@ -66,8 +66,11 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  
>  	if (!info)
>  		return -EINVAL;
> -	rf.width = state->width;
> -	rf.height = state->height;
> +
> +	size = state->stride * state->padded_height;
> +	rf.width = state->visible_width;
> +	rf.height = state->visible_height;

I don't think this is right. I think rf.width/height should be the padded width and height
since that's what the codec needs and it determined the amount of memory that should be
allocated for the internal reference buffer.

Using the padded width/height here also avoids the round_up in the en/decoder_plane functions.

I think that's wrong as well since for a 4:2:0 format the padded_width != round_up(visible_width, 8).

By using the padded width/height for the low-level codec functions you avoid this.

It would mean that the width and height fields in structs fwht_cframe and fwht_raw_frame
are renamed to padded_width/height.

But to be honest, I think that it would be even better if the width and height fields are
removed from both structs and instead you add padded_width and padded_height arguments
to the fwht_en/decode_frame functions.

The width and height fields in these structs are really duplicates and I never liked that.

> +	rf.stride = state->stride;
>  	rf.luma = p_in;
>  	rf.width_div = info->width_div;
>  	rf.height_div = info->height_div;
> @@ -163,8 +166,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  		return -EINVAL;
>  	}
>  
> -	cf.width = state->width;
> -	cf.height = state->height;
> +	cf.width = state->visible_width;
> +	cf.height = state->visible_height;
>  	cf.i_frame_qp = state->i_frame_qp;
>  	cf.p_frame_qp = state->p_frame_qp;
>  	cf.rlc_data = (__be16 *)(p_out + sizeof(*p_hdr));
> @@ -209,8 +212,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
> @@ -218,10 +221,14 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	u8 *p;
>  	unsigned int components_num = 3;
>  	unsigned int version;
> +	const struct v4l2_fwht_pixfmt_info *info;
>  
>  	if (!state->info)
>  		return -EINVAL;
>  
> +	info = state->info;
> +	size = state->stride * state->padded_height;
> +	chroma_size = size;
>  	p_hdr = (struct fwht_cframe_hdr *)p_in;
>  	cf.width = ntohl(p_hdr->width);
>  	cf.height = ntohl(p_hdr->height);
> @@ -234,12 +241,11 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
> +	if (cf.width != state->visible_width || cf.height != state->visible_height)
>  		return -EINVAL;
>  
>  	flags = ntohl(p_hdr->flags);
> @@ -260,7 +266,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
>  		chroma_size /= 2;
>  
> -	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num);
> +	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num, state->stride);
>  
>  	/*
>  	 * TODO - handle the case where the compressed stream encodes a
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> index ed53e28d4f9c..d140ac770866 100644
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
> +	unsigned int stride;
> +	unsigned int padded_height;

I think adding padded_width as well will help.

Hmm, I see that later you call this coded_height.

That's probably a better name since it matches the terminology of the codec spec,
so use coded_width and coded_height instead of padded_width and padded_height in this driver.

>  	unsigned int gop_size;
>  	unsigned int gop_cnt;
>  	u16 i_frame_qp;
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 0d7876f5acf0..e94f1a22f5b9 100644
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
> +		pix->width = vic_round_dim(q_data->coded_width, info->width_div);
> +		pix->height = vic_round_dim(q_data->coded_height, info->height_div);
>  		pix->field = V4L2_FIELD_NONE;
>  		pix->pixelformat = info->id;
> -		pix->bytesperline = q_data->width * info->bytesperline_mult;
> +		pix->bytesperline = pix->width * info->bytesperline_mult;
>  		pix->sizeimage = q_data->sizeimage;
>  		pix->colorspace = ctx->state.colorspace;
>  		pix->xfer_func = ctx->state.xfer_func;
> @@ -481,13 +483,13 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		if (!multiplanar)
>  			return -EINVAL;
>  		pix_mp = &f->fmt.pix_mp;
> -		pix_mp->width = q_data->width;
> -		pix_mp->height = q_data->height;
> +		pix_mp->width = vic_round_dim(q_data->coded_width, info->width_div);
> +		pix_mp->height = vic_round_dim(q_data->coded_height, info->height_div);
>  		pix_mp->field = V4L2_FIELD_NONE;
>  		pix_mp->pixelformat = info->id;
>  		pix_mp->num_planes = 1;
>  		pix_mp->plane_fmt[0].bytesperline =
> -				q_data->width * info->bytesperline_mult;
> +			pix_mp->width * info->bytesperline_mult;
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
>  			pix->width * info->bytesperline_mult;
> @@ -545,9 +547,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
> @@ -635,13 +636,15 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
>  	return vidioc_try_fmt(ctx, f);
>  }
>  
> -static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> +static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f,
> +			unsigned int orig_width, unsigned int orig_height)
>  {
>  	struct vicodec_q_data *q_data;
>  	struct vb2_queue *vq;
>  	bool fmt_changed = true;
>  	struct v4l2_pix_format_mplane *pix_mp;
>  	struct v4l2_pix_format *pix;
> +	const struct v4l2_fwht_pixfmt_info *info;
>  
>  	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>  	if (!vq)
> @@ -650,6 +653,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  	q_data = get_q_data(ctx, f->type);
>  	if (!q_data)
>  		return -EINVAL;
> +	info = q_data->info;
>  
>  	switch (f->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> @@ -658,8 +662,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
>  			fmt_changed =
>  				q_data->info->id != pix->pixelformat ||
> -				q_data->width != pix->width ||
> -				q_data->height != pix->height;
> +				vic_round_dim(q_data->coded_width, info->width_div) != pix->width ||
> +				vic_round_dim(q_data->coded_height, info->height_div) != pix->height;
>  
>  		if (vb2_is_busy(vq) && fmt_changed)
>  			return -EBUSY;
> @@ -668,8 +672,13 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  			q_data->info = &pixfmt_fwht;
>  		else
>  			q_data->info = find_fmt(pix->pixelformat);
> -		q_data->width = pix->width;
> -		q_data->height = pix->height;
> +
> +		q_data->coded_width = orig_width;

Shouldn't this be 'q_data->coded_width = pix->width;' ?

> +		if (q_data->visible_width > orig_width)
> +			q_data->visible_width = orig_width;
> +		q_data->coded_height = orig_height;
> +		if (q_data->visible_height > orig_height)
> +			q_data->visible_height = orig_height;
>  		q_data->sizeimage = pix->sizeimage;
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> @@ -678,8 +687,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
>  			fmt_changed =
>  				q_data->info->id != pix_mp->pixelformat ||
> -				q_data->width != pix_mp->width ||
> -				q_data->height != pix_mp->height;
> +				vic_round_dim(q_data->coded_width, info->width_div) != pix_mp->width ||
> +				vic_round_dim(q_data->coded_height, info->height_div) != pix_mp->height;
>  
>  		if (vb2_is_busy(vq) && fmt_changed)
>  			return -EBUSY;
> @@ -688,8 +697,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  			q_data->info = &pixfmt_fwht;
>  		else
>  			q_data->info = find_fmt(pix_mp->pixelformat);
> -		q_data->width = pix_mp->width;
> -		q_data->height = pix_mp->height;
> +		q_data->coded_width = orig_width;
> +		q_data->coded_height = orig_height;

Same question as above.

I'm also missing the

		if (q_data->visible_width > orig_width)
			q_data->visible_width = orig_width;

etc. code here. In fact, you get move that code out of the switch so you don't have
it at two places.

>  		q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
>  		break;
>  	default:
> @@ -698,7 +707,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  
>  	dprintk(ctx->dev,
>  		"Setting format for type %d, wxh: %dx%d, fourcc: %08x\n",
> -		f->type, q_data->width, q_data->height, q_data->info->id);
> +		f->type, q_data->coded_width, q_data->coded_height, q_data->info->id);

I would recommend logging the visible width/height here as well.

>  
>  	return 0;
>  }
> @@ -707,12 +716,27 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  				struct v4l2_format *f)
>  {
>  	int ret;
> +	unsigned int orig_width, orig_height;
>  
> +	switch (f->type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		orig_width = f->fmt.pix.width;
> +		orig_height = f->fmt.pix.height;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		orig_width = f->fmt.pix_mp.width;
> +		orig_height = f->fmt.pix_mp.height;
> +		break;
> +	default:
> +		break;
> +	}
>  	ret = vidioc_try_fmt_vid_cap(file, priv, f);
>  	if (ret)
>  		return ret;
>  
> -	return vidioc_s_fmt(file2ctx(file), f);
> +	return vidioc_s_fmt(file2ctx(file), f, orig_width, orig_height);
>  }
>  
>  static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> @@ -721,36 +745,128 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
>  	struct vicodec_ctx *ctx = file2ctx(file);
>  	struct v4l2_pix_format_mplane *pix_mp;
>  	struct v4l2_pix_format *pix;
> +	unsigned int orig_width, orig_height;
>  	int ret;
>  
> -	ret = vidioc_try_fmt_vid_out(file, priv, f);
> -	if (ret)
> -		return ret;
> +	switch (f->type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +				pix = &f->fmt.pix;
> +		orig_width = pix->width;
> +		orig_height = pix->height;
> +		ret = vidioc_try_fmt_vid_out(file, priv, f);
> +		if (ret)
> +			return ret;
> +		ret = vidioc_s_fmt(file2ctx(file), f, orig_width, orig_height);
> +		if (ret)
> +			return ret;
> +		ctx->state.colorspace = pix->colorspace;
> +		ctx->state.xfer_func = pix->xfer_func;
> +		ctx->state.ycbcr_enc = pix->ycbcr_enc;
> +		ctx->state.quantization = pix->quantization;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		pix_mp = &f->fmt.pix_mp;
> +		orig_width = pix_mp->width;
> +		orig_height = pix_mp->height;
> +		ret = vidioc_try_fmt_vid_out(file, priv, f);
> +		if (ret)
> +			return ret;
> +		ret = vidioc_s_fmt(file2ctx(file), f, orig_width, orig_height);
> +		if (ret)
> +			return ret;
> +		ctx->state.colorspace = pix_mp->colorspace;
> +		ctx->state.xfer_func = pix_mp->xfer_func;
> +		ctx->state.ycbcr_enc = pix_mp->ycbcr_enc;
> +		ctx->state.quantization = pix_mp->quantization;
> +		break;
> +	default:
> +		break;
> +	}
> +	return ret;
> +}
>  
> -	ret = vidioc_s_fmt(file2ctx(file), f);
> -	if (!ret) {
> -		switch (f->type) {
> -		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -			pix = &f->fmt.pix;
> -			ctx->state.colorspace = pix->colorspace;
> -			ctx->state.xfer_func = pix->xfer_func;
> -			ctx->state.ycbcr_enc = pix->ycbcr_enc;
> -			ctx->state.quantization = pix->quantization;
> -			break;
> -		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -			pix_mp = &f->fmt.pix_mp;
> -			ctx->state.colorspace = pix_mp->colorspace;
> -			ctx->state.xfer_func = pix_mp->xfer_func;
> -			ctx->state.ycbcr_enc = pix_mp->ycbcr_enc;
> -			ctx->state.quantization = pix_mp->quantization;
> -			break;
> +static int vidioc_g_selection(struct file *file, void *priv,
> +			      struct v4l2_selection *s)
> +{
> +	struct vicodec_ctx *ctx = file2ctx(file);
> +	struct vicodec_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	/* encoder supports only cropping on the OUTPUT buffer */
> +	if (ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		switch (s->target) {
> +		case V4L2_SEL_TGT_CROP_DEFAULT:
> +		case V4L2_SEL_TGT_CROP_BOUNDS:
> +			s->r.left = 0;
> +			s->r.top = 0;
> +			s->r.width = q_data->coded_width;
> +			s->r.height = q_data->coded_height;
> +			return 0;
> +		case V4L2_SEL_TGT_CROP:
> +			s->r.left = 0;
> +			s->r.top = 0;
> +			s->r.width = q_data->visible_width;
> +			s->r.height = q_data->visible_height;
> +			return 0;
>  		default:
> -			break;
> +			return -EINVAL;
> +		}
> +	/* decoder supports only composing on the CAPTURE buffer */
> +	} else if (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		switch (s->target) {
> +		case V4L2_SEL_TGT_COMPOSE:
> +		case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +			s->r.left = 0;
> +			s->r.top = 0;
> +			s->r.width = q_data->coded_width;
> +			s->r.height = q_data->coded_height;
> +			return 0;
> +		default:
> +			return -EINVAL;
>  		}
>  	}
> -	return ret;
> +	return -EINVAL;
> +}
> +
> +static int vidioc_s_selection(struct file *file, void *priv,
> +			      struct v4l2_selection *s)
> +{
> +	struct vicodec_ctx *ctx = file2ctx(file);
> +	struct vicodec_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	/* encoder supports only cropping on the OUTPUT buffer */
> +	if (ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		switch (s->target) {
> +		case V4L2_SEL_TGT_CROP:

I'd just do 'if (s->target == V4L2_SEL_TGT_CROP) {' here instead of a switch.

> +			s->r.left = 0;
> +			s->r.top = 0;
> +			q_data->visible_width = clamp(s->r.width, MIN_WIDTH, q_data->coded_width);
> +			s->r.width = q_data->visible_width;
> +			q_data->visible_height = clamp(s->r.height, MIN_HEIGHT, q_data->coded_height);
> +			s->r.height = q_data->visible_height;
> +			return 0;
> +		default:
> +			return -EINVAL;
> +		}
> +	/* decoder supports only composing on the CAPTURE buffer */
> +	} else if (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {

You do can add a '&& s->target == V4L2_SEL_TGT_COMPOSE' to the condition and...

> +		/* TODO - enable COMOPOSE setting on the capture buffer */
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = q_data->coded_width;
> +		s->r.height = q_data->coded_height;

... return 0 here.

> +	}
> +	return -EINVAL;
>  }
>  
>  static void vicodec_mark_last_buf(struct vicodec_ctx *ctx)
> @@ -895,6 +1011,9 @@ static const struct v4l2_ioctl_ops vicodec_ioctl_ops = {
>  	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
>  	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
>  
> +	.vidioc_g_selection	= vidioc_g_selection,
> +	.vidioc_s_selection	= vidioc_s_selection,
> +
>  	.vidioc_try_encoder_cmd	= vicodec_try_encoder_cmd,
>  	.vidioc_encoder_cmd	= vicodec_encoder_cmd,
>  	.vidioc_try_decoder_cmd	= vicodec_try_decoder_cmd,
> @@ -988,8 +1107,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  	struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
>  	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
>  	struct v4l2_fwht_state *state = &ctx->state;
> -	unsigned int size = q_data->width * q_data->height;
>  	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
> +	unsigned int size = vic_round_dim(q_data->coded_width, info->width_div) *
> +		vic_round_dim(q_data->coded_height, info->height_div);
>  	unsigned int chroma_div = info->width_div * info->height_div;
>  	unsigned int total_planes_size;
>  
> @@ -1008,15 +1128,20 @@ static int vicodec_start_streaming(struct vb2_queue *q,
>  
>  	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
>  		if (!ctx->is_enc) {
> -			state->width = q_data->width;
> -			state->height = q_data->height;
> +			state->visible_width = q_data->coded_width;
> +			state->visible_height = q_data->coded_height;
> +			state->stride = vic_round_dim(q_data->coded_width, info->width_div);
> +			state->padded_height = vic_round_dim(q_data->coded_height, info->height_div);
> +
>  		}
>  		return 0;
>  	}
>  
>  	if (ctx->is_enc) {
> -		state->width = q_data->width;
> -		state->height = q_data->height;
> +		state->visible_width = q_data->visible_width;
> +		state->visible_height = q_data->visible_height;
> +		state->stride = vic_round_dim(q_data->coded_width, info->width_div);
> +		state->padded_height = vic_round_dim(q_data->coded_height, info->height_div);
>  	}
>  	state->ref_frame.width = state->ref_frame.height = 0;
>  	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
> @@ -1204,8 +1329,10 @@ static int vicodec_open(struct file *file)
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

	Hans
