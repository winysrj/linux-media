Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E07C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 10:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9645217D9
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 10:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbeLRKQU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:16:20 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:37771 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbeLRKQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 05:16:19 -0500
Received: from [IPv6:2001:983:e9a7:1:59e2:4cb7:1f98:4b88] ([IPv6:2001:983:e9a7:1:59e2:4cb7:1f98:4b88])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ZCQBgD4Q1eA2FZCQCgNTpm; Tue, 18 Dec 2018 11:16:17 +0100
Subject: Re: [PATCH] media: vicodec: add support for CROP selection
To:     Dafna Hirschfeld <dafna3@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        helen.koike@collabora.com
References: <20181215115436.2956-1-dafna3@gmail.com>
 <25c2e1f5-7529-1d8a-8ef9-88e29d2bfd95@xs4all.nl>
 <CAJ1myNQTeL6KeiPNyL7z5y0ieOsCbjL2nfBVhEbaK-Ov9VP-ig@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <33141e8b-c743-49ec-8e1d-3d1d891687d2@xs4all.nl>
Date:   Tue, 18 Dec 2018 11:16:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAJ1myNQTeL6KeiPNyL7z5y0ieOsCbjL2nfBVhEbaK-Ov9VP-ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBEexxGJ1/qWJ0TiF2vMB1y74DNo1E0JEFspefn0TmGZ589uPQ+zkrqqGPuG0VKkChfrMPYXXjloj0e5s4MsfER3rkodT9TmljdprBtFafxrUtvaob16
 hF0LXTIRpFTfWPB2RKGP3a7RG5ah8Qz9EBBFn1bNVhf9glapsD5QgtVXcl6TAO4aN0itEOs3NbSh6dF4twvMIMnom0h8q5fOMvKiYTlXAIj/D1uy7mFkEVKS
 qRbFOVZo+KNpQ8zB9WFbDk/pFcDNpYKdrXtNbksFLxlFLhF5SGe0tgk5v+m16WiBwdivP5E9G/4zqpkkz74cxLDRiXK56fAjq9Dslk7xpt0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/17/18 6:23 PM, Dafna Hirschfeld wrote:
> 
> 
> On Sun, Dec 16, 2018 at 2:24 PM Hans Verkuil <hverkuil@xs4all.nl <mailto:hverkuil@xs4all.nl>> wrote:
> 
>     On 12/15/18 12:54 PM, Dafna Hirschfeld wrote:
>     > Add support for the selection api for the crop target.
> 
>     Mention that this is added for the encoder only.
> 
>     > The driver rounds up the width and height such that
>     > all planes dimesnsions are multiple of 8.
> 
>     dimesnsions -> dimensions
> 
>     > The userspace client should also read and write
>     > the raw frames according the padding.
> 
>     Since we're not changing the userspace client here, you can drop
>     that paragraph.
> 
>     >
>     > Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com <mailto:dafna3@gmail.com>>
>     > ---
>     >  drivers/media/platform/vicodec/codec-fwht.c   |  45 ++--
>     >  drivers/media/platform/vicodec/codec-fwht.h   |   5 +-
>     >  .../media/platform/vicodec/codec-v4l2-fwht.c  |  18 +-
>     >  .../media/platform/vicodec/codec-v4l2-fwht.h  |   2 +
>     >  drivers/media/platform/vicodec/vicodec-core.c | 219 ++++++++++++++----
>     >  5 files changed, 213 insertions(+), 76 deletions(-)
>     >
>     > diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
>     > index a678a716580c..ab59f34e9818 100644
>     > --- a/drivers/media/platform/vicodec/codec-fwht.c
>     > +++ b/drivers/media/platform/vicodec/codec-fwht.c
>     > @@ -659,7 +659,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
>     >  }
>     > 
>     >  static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>     > -                     struct fwht_cframe *cf, u32 height, u32 width,
>     > +                     struct fwht_cframe *cf, u32 height, u32 width, u32 stride,
>     >                       unsigned int input_step,
>     >                       bool is_intra, bool next_is_intra)
>     >  {
>     > @@ -679,9 +679,9 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>     > 
>     >                       if (!is_intra)
>     >                               blocktype = decide_blocktype(input, refp,
>     > -                                     deltablock, width, input_step);
>     > +                                     deltablock, stride, input_step);
>     >                       if (blocktype == IBLOCK) {
>     > -                             fwht(input, cf->coeffs, width, input_step, 1);
>     > +                             fwht(input, cf->coeffs, stride, input_step, 1);
>     >                               quantize_intra(cf->coeffs, cf->de_coeffs,
>     >                                              cf->i_frame_qp);
>     >                       } else {
>     > @@ -722,7 +722,7 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
>     >                       }
>     >                       last_size = size;
>     >               }
>     > -             input += width * 7 * input_step;
>     > +             input += (stride - width/8) * 8 * input_step;
> 
>     width/8 -> width / 8
> 
>     Hmm, I think this calculation is confusing.
> 
>     A better solution would be to set the input pointer just before the
>     'for (i = 0; i < width / 8; i++) {' loop. E.g.:
> 
>             for (j = 0; j < height / 8; j++) {
>                     input = input_start + j * 8 * stride * input_step;
>                     for (i = 0; i < width / 8; i++) {
> 
>     (I hope I got the calculation right)
> 
>     >       }
>     > 
>     >  exit_loop:
>     > @@ -756,7 +756,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>     > 
>     >       rlco_max = rlco + size / 2 - 256;
>     >       encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
>     > -                             frm->height, frm->width,
>     > +                             frm->height, frm->width, frm->stride,
>     >                               frm->luma_alpha_step, is_intra, next_is_intra);
>     >       if (encoding & FWHT_FRAME_UNENCODED)
>     >               encoding |= FWHT_LUMA_UNENCODED;
>     > @@ -765,11 +765,12 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>     >       if (frm->components_num >= 3) {
>     >               u32 chroma_h = frm->height / frm->height_div;
>     >               u32 chroma_w = frm->width / frm->width_div;
>     > +             u32 stride = frm->stride / frm->width_div;
> 
>     Call this chroma_stride to stay consistent with chroma_h/w etc.
> 
>     >               unsigned int chroma_size = chroma_h * chroma_w;
>     > 
>     >               rlco_max = rlco + chroma_size / 2 - 256;
>     >               encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max,
>     > -                                      cf, chroma_h, chroma_w,
>     > +                                      cf, chroma_h, chroma_w, stride,
>     >                                        frm->chroma_step,
>     >                                        is_intra, next_is_intra);
>     >               if (encoding & FWHT_FRAME_UNENCODED)
>     > @@ -777,7 +778,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>     >               encoding &= ~FWHT_FRAME_UNENCODED;
>     >               rlco_max = rlco + chroma_size / 2 - 256;
>     >               encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
>     > -                                      cf, chroma_h, chroma_w,
>     > +                                      cf, chroma_h, chroma_w, stride,
>     >                                        frm->chroma_step,
>     >                                        is_intra, next_is_intra);
>     >               if (encoding & FWHT_FRAME_UNENCODED)
>     > @@ -789,7 +790,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>     >               rlco_max = rlco + size / 2 - 256;
>     >               encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
>     >                                       rlco_max, cf, frm->height, frm->width,
>     > -                                     frm->luma_alpha_step,
>     > +                                     frm->stride, frm->luma_alpha_step,
>     >                                       is_intra, next_is_intra);
>     >               if (encoding & FWHT_FRAME_UNENCODED)
>     >                       encoding |= FWHT_ALPHA_UNENCODED;
>     > @@ -801,7 +802,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>     >  }
>     > 
>     >  static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>     > -                      u32 height, u32 width, bool uncompressed)
>     > +                      u32 height, u32 width, u32 stride, bool uncompressed)
>     >  {
>     >       unsigned int copies = 0;
>     >       s16 copy[8 * 8];
>     > @@ -822,13 +823,13 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>     >        */
>     >       for (j = 0; j < height / 8; j++) {
>     >               for (i = 0; i < width / 8; i++) {
>     > -                     u8 *refp = ref + j * 8 * width + i * 8;
>     > +                     u8 *refp = ref + j * 8 * stride + i * 8;
>     > 
>     >                       if (copies) {
>     >                               memcpy(cf->de_fwht, copy, sizeof(copy));
>     >                               if (stat & PFRAME_BIT)
>     > -                                     add_deltas(cf->de_fwht, refp, width);
>     > -                             fill_decoder_block(refp, cf->de_fwht, width);
>     > +                                     add_deltas(cf->de_fwht, refp, stride);
>     > +                             fill_decoder_block(refp, cf->de_fwht, stride);
>     >                               copies--;
>     >                               continue;
>     >                       }
>     > @@ -847,35 +848,37 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>     >                       if (copies)
>     >                               memcpy(copy, cf->de_fwht, sizeof(copy));
>     >                       if (stat & PFRAME_BIT)
>     > -                             add_deltas(cf->de_fwht, refp, width);
>     > -                     fill_decoder_block(refp, cf->de_fwht, width);
>     > +                             add_deltas(cf->de_fwht, refp, stride);
>     > +                     fill_decoder_block(refp, cf->de_fwht, stride);
>     >               }
>     >       }
>     >  }
>     > 
>     >  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
>     > -                    u32 hdr_flags, unsigned int components_num)
>     > +                    u32 hdr_flags, unsigned int components_num, unsigned int stride)
>     >  {
>     >       const __be16 *rlco = cf->rlc_data;
>     > 
>     > -     decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
>     > +     decode_plane(cf, &rlco, ref->luma, cf->height, cf->width, stride,
>     >                    hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
>     > 
>     >       if (components_num >= 3) {
>     >               u32 h = cf->height;
>     >               u32 w = cf->width;
>     > -
>     > +             u32 s = stride;
> 
>     Add an empty line after declaring the variables.
> 
>     >               if (!(hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT))
>     >                       h /= 2;
>     > -             if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH))
>     > +             if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)) {
>     >                       w /= 2;
>     > -             decode_plane(cf, &rlco, ref->cb, h, w,
>     > +                     s /= 2;
>     > +             }
>     > +             decode_plane(cf, &rlco, ref->cb, h, w, s,
>     >                            hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
>     > -             decode_plane(cf, &rlco, ref->cr, h, w,
>     > +             decode_plane(cf, &rlco, ref->cr, h, w, s,
>     >                            hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
>     >       }
>     > 
>     >       if (components_num == 4)
>     > -             decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width,
>     > +             decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width, stride,
>     >                            hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
>     >  }
>     > diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
>     > index 90ff8962fca7..86c38e873f69 100644
>     > --- a/drivers/media/platform/vicodec/codec-fwht.h
>     > +++ b/drivers/media/platform/vicodec/codec-fwht.h
>     > @@ -81,6 +81,8 @@
>     >  #define FWHT_FL_COMPONENTS_NUM_MSK   GENMASK(17, 16)
>     >  #define FWHT_FL_COMPONENTS_NUM_OFFSET        16
>     > 
>     > +#define vic_round_dim(dim, div) (round_up(dim / div, 8) * div)
> 
>     This macro needs a comment explaining what it does.
> 
>     > +
>     >  struct fwht_cframe_hdr {
>     >       u32 magic1;
>     >       u32 magic2;
>     > @@ -112,6 +114,7 @@ struct fwht_raw_frame {
>     >       unsigned int luma_alpha_step;
>     >       unsigned int chroma_step;
>     >       unsigned int components_num;
>     > +     unsigned int stride;
>     >       u8 *luma, *cb, *cr, *alpha;
>     >  };
>     > 
>     > @@ -127,6 +130,6 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>     >                     struct fwht_cframe *cf,
>     >                     bool is_intra, bool next_is_intra);
>     >  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
>     > -                    u32 hdr_flags, unsigned int components_num);
>     > +                    u32 hdr_flags, unsigned int components_num, unsigned int stride);
>     > 
>     >  #endif
>     > diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
>     > index 8cb0212df67f..3eef6bbe5c06 100644
>     > --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
>     > +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
>     > @@ -56,7 +56,7 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
>     > 
>     >  int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>     >  {
>     > -     unsigned int size = state->width * state->height;
>     > +     unsigned int size;
>     >       const struct v4l2_fwht_pixfmt_info *info = state->info;
>     >       struct fwht_cframe_hdr *p_hdr;
>     >       struct fwht_cframe cf;
>     > @@ -66,8 +66,11 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>     > 
>     >       if (!info)
>     >               return -EINVAL;
>     > +
>     > +     size = state->stride * state->padded_height;
> 
>     Throughout this patch you talk about 'stride', but I think calling it 'padded_width' is a
>     much better name.
> 
>     There are actually three values here: 
> 
>     width: this is the visible width in pixels
>     padded_width: this is the visible width in pixels rounded up to the next macroblock alignment
>     stride: this is the distance in bytes between two lines.
> 
>     width <= padded_width <= stride / input_step
> 
> Currently q_data->width contain none of those, it is the value set by the S_FMT request so the stride can be calculated from it.
> This is actually also the visible width for the decoder, since the COMPOSE selection is not implemented yet. Right ?

Correct. For the decoder width == padded_width == stride / input_step

> 
> state->width is the cropped width for the encoder and it is the same as q_data->width for the decoder.
> You think I should change the field name  'state->width' to 'state->visible_width' ?

I've been wondering about that myself. I think we should rename it, yes. Or perhaps to 'vis_width' if
'visible_width' becomes too cumbersome in the code.

Being explicit about which 'width' we're talking about is probably helpful in understanding the code.

> 
> I think that when I implement the COMPOSE for the decoder I could change the field ''cropped_width" with "visible_width"
> in ""vicodec_q_data" and it will be the cropped width for the encoder and the composed width for the decoder.
> Also, when I implement the COMPOSE for the decoder, then q_data->width could be changed to q_data->coded_width and
> will contain the coded resolution (that is "vic_round_up(width,info->width_div)")

You can rename it right now, I don't think you need to wait until COMPOSE support is added.

The decoder already has those different 'width's already, they just always have the
same value :-) But that will change once COMPOSE support is added.

Regards,

	Hans
