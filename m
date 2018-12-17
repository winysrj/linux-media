Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C4AC43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 17:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2492133F
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 17:26:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbVTGejB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732433AbeLQR0h (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 12:26:37 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:32789 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbeLQR0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 12:26:37 -0500
Received: by mail-vs1-f65.google.com with SMTP id p74so8220413vsc.0
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2018 09:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=OTwRCsF3uqS6rVM0vcFXYeg4aEuolYZYQBQ+gtvtiGk=;
        b=QbVTGejB1mzNvsK9giY8nBQvcKkO6yCGyYcc7Ix4eu59UbqtwBtyajKUBqUQ6oO5ZL
         W30qeA/kwLMnHYNQy5PVBMZdt1fhLFNaUYUzoftKigzWY7KPJjndKehuj5DGqMfNNg0z
         uxo8xeXPaCaDw+6yoR92qjk5Y6isa5FO++zbXKQGmBN7OyDmgUaf6h3HFZzT87m06dkv
         Uxqqif6Hba3Nb3SboL8Z3dT76fDbX2vUZog8fOn7u0fNcffTr7WV9vtqln6HV+Ggm6U+
         zmQUUlyIF5HRxiMar7yQhlWBicCWImyA9LE3+ZNj/iKqcfanrH4Wbu8wsGUQ/iTzSvFZ
         FzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=OTwRCsF3uqS6rVM0vcFXYeg4aEuolYZYQBQ+gtvtiGk=;
        b=i6GUJFFOfwBfYrG+Cod8ua3gZmEK1KaHWcWHnIksF4St4GWieSVbYurAKDAvHKt8OE
         IwB5Ljv8psVAxq8mPiHLwFrEj2NF7CQZxyWh0VZxe/WT4nWAudfQEq+PBDYi9hm7WNg3
         2W6OLKsuwW+g0tSg/H1TraZd5vRCq83fmRJ4hohjQa2GLTFu2Z8Vs3khlCoUUU0g04Kk
         wU/dQFUR09XzUc0OALG41/8H+JV3DoK2BuI8tTzKXeJcPUwNNgeOBRHyhJ3WW9rg3mLE
         WzCs4pIgIs06p09RB9ZDsBoOnEW9TavX9f4GjqF3NE8YETHbSY/LSfK32JYlOwieQ0Kc
         PkyQ==
X-Gm-Message-State: AA+aEWZ+xahJTm0NcEg9EMHowsXkoa8sjuLtwXIBZpkj3K2ClqCInzeo
        WwS6Nchnr6amLPQDmrfJuTDkLYvcpYd2qbXAA/ktQc37
X-Google-Smtp-Source: AFSGD/WVyoU9dz3x4JEh/YLXeKEEhceltv2DGFoT5n1fEND7nODWWIcBGX1hyZ+4mX2Ya0Pms3rEzPnMgI2El4c3qNI=
X-Received: by 2002:a67:ff02:: with SMTP id v2mr535947vsp.176.1545067593861;
 Mon, 17 Dec 2018 09:26:33 -0800 (PST)
MIME-Version: 1.0
References: <20181215115436.2956-1-dafna3@gmail.com> <25c2e1f5-7529-1d8a-8ef9-88e29d2bfd95@xs4all.nl>
 <CAJ1myNQTeL6KeiPNyL7z5y0ieOsCbjL2nfBVhEbaK-Ov9VP-ig@mail.gmail.com>
In-Reply-To: <CAJ1myNQTeL6KeiPNyL7z5y0ieOsCbjL2nfBVhEbaK-Ov9VP-ig@mail.gmail.com>
From:   Dafna Hirschfeld <dafna3@gmail.com>
Date:   Mon, 17 Dec 2018 19:26:22 +0200
Message-ID: <CAJ1myNQYVNpqw39H0ex=zAgXnE9jadrzpSg943tQnTaTaDvRbA@mail.gmail.com>
Subject: Fwd: [PATCH] media: vicodec: add support for CROP selection
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

---------- Forwarded message ---------
From: Dafna Hirschfeld <dafna3@gmail.com>
Date: Mon, Dec 17, 2018 at 7:23 PM
Subject: Re: [PATCH] media: vicodec: add support for CROP selection
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
<helen.koike@collabora.com>




On Sun, Dec 16, 2018 at 2:24 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 12/15/18 12:54 PM, Dafna Hirschfeld wrote:
> > Add support for the selection api for the crop target.
>
> Mention that this is added for the encoder only.
>
> > The driver rounds up the width and height such that
> > all planes dimesnsions are multiple of 8.
>
> dimesnsions -> dimensions
>
> > The userspace client should also read and write
> > the raw frames according the padding.
>
> Since we're not changing the userspace client here, you can drop
> that paragraph.
>
> >
> > Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> > ---
> >  drivers/media/platform/vicodec/codec-fwht.c   |  45 ++--
> >  drivers/media/platform/vicodec/codec-fwht.h   |   5 +-
> >  .../media/platform/vicodec/codec-v4l2-fwht.c  |  18 +-
> >  .../media/platform/vicodec/codec-v4l2-fwht.h  |   2 +
> >  drivers/media/platform/vicodec/vicodec-core.c | 219 ++++++++++++++----
> >  5 files changed, 213 insertions(+), 76 deletions(-)
> >
> > diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> > index a678a716580c..ab59f34e9818 100644
> > --- a/drivers/media/platform/vicodec/codec-fwht.c
> > +++ b/drivers/media/platform/vicodec/codec-fwht.c
> > @@ -659,7 +659,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
> >  }
> >
> >  static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
> > -                     struct fwht_cframe *cf, u32 height, u32 width,
> > +                     struct fwht_cframe *cf, u32 height, u32 width, u32 stride,
> >                       unsigned int input_step,
> >                       bool is_intra, bool next_is_intra)
> >  {
> > @@ -679,9 +679,9 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
> >
> >                       if (!is_intra)
> >                               blocktype = decide_blocktype(input, refp,
> > -                                     deltablock, width, input_step);
> > +                                     deltablock, stride, input_step);
> >                       if (blocktype == IBLOCK) {
> > -                             fwht(input, cf->coeffs, width, input_step, 1);
> > +                             fwht(input, cf->coeffs, stride, input_step, 1);
> >                               quantize_intra(cf->coeffs, cf->de_coeffs,
> >                                              cf->i_frame_qp);
> >                       } else {
> > @@ -722,7 +722,7 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
> >                       }
> >                       last_size = size;
> >               }
> > -             input += width * 7 * input_step;
> > +             input += (stride - width/8) * 8 * input_step;
>
> width/8 -> width / 8
>
> Hmm, I think this calculation is confusing.
>
> A better solution would be to set the input pointer just before the
> 'for (i = 0; i < width / 8; i++) {' loop. E.g.:
>
>         for (j = 0; j < height / 8; j++) {
>                 input = input_start + j * 8 * stride * input_step;
>                 for (i = 0; i < width / 8; i++) {
>
> (I hope I got the calculation right)
>
> >       }
> >
> >  exit_loop:
> > @@ -756,7 +756,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
> >
> >       rlco_max = rlco + size / 2 - 256;
> >       encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
> > -                             frm->height, frm->width,
> > +                             frm->height, frm->width, frm->stride,
> >                               frm->luma_alpha_step, is_intra, next_is_intra);
> >       if (encoding & FWHT_FRAME_UNENCODED)
> >               encoding |= FWHT_LUMA_UNENCODED;
> > @@ -765,11 +765,12 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
> >       if (frm->components_num >= 3) {
> >               u32 chroma_h = frm->height / frm->height_div;
> >               u32 chroma_w = frm->width / frm->width_div;
> > +             u32 stride = frm->stride / frm->width_div;
>
> Call this chroma_stride to stay consistent with chroma_h/w etc.
>
> >               unsigned int chroma_size = chroma_h * chroma_w;
> >
> >               rlco_max = rlco + chroma_size / 2 - 256;
> >               encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max,
> > -                                      cf, chroma_h, chroma_w,
> > +                                      cf, chroma_h, chroma_w, stride,
> >                                        frm->chroma_step,
> >                                        is_intra, next_is_intra);
> >               if (encoding & FWHT_FRAME_UNENCODED)
> > @@ -777,7 +778,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
> >               encoding &= ~FWHT_FRAME_UNENCODED;
> >               rlco_max = rlco + chroma_size / 2 - 256;
> >               encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
> > -                                      cf, chroma_h, chroma_w,
> > +                                      cf, chroma_h, chroma_w, stride,
> >                                        frm->chroma_step,
> >                                        is_intra, next_is_intra);
> >               if (encoding & FWHT_FRAME_UNENCODED)
> > @@ -789,7 +790,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
> >               rlco_max = rlco + size / 2 - 256;
> >               encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
> >                                       rlco_max, cf, frm->height, frm->width,
> > -                                     frm->luma_alpha_step,
> > +                                     frm->stride, frm->luma_alpha_step,
> >                                       is_intra, next_is_intra);
> >               if (encoding & FWHT_FRAME_UNENCODED)
> >                       encoding |= FWHT_ALPHA_UNENCODED;
> > @@ -801,7 +802,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
> >  }
> >
> >  static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> > -                      u32 height, u32 width, bool uncompressed)
> > +                      u32 height, u32 width, u32 stride, bool uncompressed)
> >  {
> >       unsigned int copies = 0;
> >       s16 copy[8 * 8];
> > @@ -822,13 +823,13 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> >        */
> >       for (j = 0; j < height / 8; j++) {
> >               for (i = 0; i < width / 8; i++) {
> > -                     u8 *refp = ref + j * 8 * width + i * 8;
> > +                     u8 *refp = ref + j * 8 * stride + i * 8;
> >
> >                       if (copies) {
> >                               memcpy(cf->de_fwht, copy, sizeof(copy));
> >                               if (stat & PFRAME_BIT)
> > -                                     add_deltas(cf->de_fwht, refp, width);
> > -                             fill_decoder_block(refp, cf->de_fwht, width);
> > +                                     add_deltas(cf->de_fwht, refp, stride);
> > +                             fill_decoder_block(refp, cf->de_fwht, stride);
> >                               copies--;
> >                               continue;
> >                       }
> > @@ -847,35 +848,37 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
> >                       if (copies)
> >                               memcpy(copy, cf->de_fwht, sizeof(copy));
> >                       if (stat & PFRAME_BIT)
> > -                             add_deltas(cf->de_fwht, refp, width);
> > -                     fill_decoder_block(refp, cf->de_fwht, width);
> > +                             add_deltas(cf->de_fwht, refp, stride);
> > +                     fill_decoder_block(refp, cf->de_fwht, stride);
> >               }
> >       }
> >  }
> >
> >  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> > -                    u32 hdr_flags, unsigned int components_num)
> > +                    u32 hdr_flags, unsigned int components_num, unsigned int stride)
> >  {
> >       const __be16 *rlco = cf->rlc_data;
> >
> > -     decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
> > +     decode_plane(cf, &rlco, ref->luma, cf->height, cf->width, stride,
> >                    hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
> >
> >       if (components_num >= 3) {
> >               u32 h = cf->height;
> >               u32 w = cf->width;
> > -
> > +             u32 s = stride;
>
> Add an empty line after declaring the variables.
>
> >               if (!(hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT))
> >                       h /= 2;
> > -             if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH))
> > +             if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)) {
> >                       w /= 2;
> > -             decode_plane(cf, &rlco, ref->cb, h, w,
> > +                     s /= 2;
> > +             }
> > +             decode_plane(cf, &rlco, ref->cb, h, w, s,
> >                            hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
> > -             decode_plane(cf, &rlco, ref->cr, h, w,
> > +             decode_plane(cf, &rlco, ref->cr, h, w, s,
> >                            hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
> >       }
> >
> >       if (components_num == 4)
> > -             decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width,
> > +             decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width, stride,
> >                            hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
> >  }
> > diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> > index 90ff8962fca7..86c38e873f69 100644
> > --- a/drivers/media/platform/vicodec/codec-fwht.h
> > +++ b/drivers/media/platform/vicodec/codec-fwht.h
> > @@ -81,6 +81,8 @@
> >  #define FWHT_FL_COMPONENTS_NUM_MSK   GENMASK(17, 16)
> >  #define FWHT_FL_COMPONENTS_NUM_OFFSET        16
> >
> > +#define vic_round_dim(dim, div) (round_up(dim / div, 8) * div)
>
> This macro needs a comment explaining what it does.
>
> > +
> >  struct fwht_cframe_hdr {
> >       u32 magic1;
> >       u32 magic2;
> > @@ -112,6 +114,7 @@ struct fwht_raw_frame {
> >       unsigned int luma_alpha_step;
> >       unsigned int chroma_step;
> >       unsigned int components_num;
> > +     unsigned int stride;
> >       u8 *luma, *cb, *cr, *alpha;
> >  };
> >
> > @@ -127,6 +130,6 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
> >                     struct fwht_cframe *cf,
> >                     bool is_intra, bool next_is_intra);
> >  void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
> > -                    u32 hdr_flags, unsigned int components_num);
> > +                    u32 hdr_flags, unsigned int components_num, unsigned int stride);
> >
> >  #endif
> > diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> > index 8cb0212df67f..3eef6bbe5c06 100644
> > --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> > +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> > @@ -56,7 +56,7 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
> >
> >  int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
> >  {
> > -     unsigned int size = state->width * state->height;
> > +     unsigned int size;
> >       const struct v4l2_fwht_pixfmt_info *info = state->info;
> >       struct fwht_cframe_hdr *p_hdr;
> >       struct fwht_cframe cf;
> > @@ -66,8 +66,11 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
> >
> >       if (!info)
> >               return -EINVAL;
> > +
> > +     size = state->stride * state->padded_height;
>
> Throughout this patch you talk about 'stride', but I think calling it 'padded_width' is a
> much better name.
>
> There are actually three values here:
>
> width: this is the visible width in pixels
> padded_width: this is the visible width in pixels rounded up to the next macroblock alignment
> stride: this is the distance in bytes between two lines.
>
> width <= padded_width <= stride / input_step
>
Currently q_data->width contain none of those, it is the value set by
the S_FMT request so the stride can be calculated from it.
This is actually also the visible width for the decoder, since the
COMPOSE selection is not implemented yet. Right ?

state->width is the cropped width for the encoder and it is the same
as q_data->width for the decoder.
You think I should change the field name  'state->width' to
'state->visible_width' ?

I think that when I implement the COMPOSE for the decoder I could
change the field ''cropped_width" with "visible_width"
in ""vicodec_q_data" and it will be the cropped width for the encoder
and the composed width for the decoder.
Also, when I implement the COMPOSE for the decoder, then q_data->width
could be changed to q_data->coded_width and
will contain the coded resolution (that is
"vic_round_up(width,info->width_div)")

Dafna



>
> Note: stride corresponds to the bytesperline field in struct v4l2_pix_format.
>
> You still need the stride, but the padded_width can always be calculated from the
> width.
>
> I think you need to go through this patch carefully and use the right terminology.
>
> E.g. in encode_plane() you do need the stride, but the width and height that are
> passed to this function should really be the padded width and height.
>
> You can add a line like this at the start of encode_plane() to verify that you get
> valid values:
>
>         WARN_ON((padded_width & 7) || (padded_height & 7));
>
> >       rf.width = state->width;
> >       rf.height = state->height;
> > +     rf.stride = state->stride;
> >       rf.luma = p_in;
> >       rf.width_div = info->width_div;
> >       rf.height_div = info->height_div;
> > @@ -209,8 +212,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
> >
> >  int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
> >  {
> > -     unsigned int size = state->width * state->height;
> > -     unsigned int chroma_size = size;
> > +     unsigned int size;
> > +     unsigned int chroma_size;
> >       unsigned int i;
> >       u32 flags;
> >       struct fwht_cframe_hdr *p_hdr;
> > @@ -218,10 +221,14 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
> >       u8 *p;
> >       unsigned int components_num = 3;
> >       unsigned int version;
> > +     const struct v4l2_fwht_pixfmt_info *info;
> >
> >       if (!state->info)
> >               return -EINVAL;
> >
> > +     info = state->info;
> > +     size = state->stride * state->padded_height;
> > +     chroma_size = size;
> >       p_hdr = (struct fwht_cframe_hdr *)p_in;
> >       cf.width = ntohl(p_hdr->width);
> >       cf.height = ntohl(p_hdr->height);
> > @@ -234,8 +241,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
> >       }
> >
> >       if (p_hdr->magic1 != FWHT_MAGIC1 ||
> > -         p_hdr->magic2 != FWHT_MAGIC2 ||
> > -         (cf.width & 7) || (cf.height & 7))
> > +         p_hdr->magic2 != FWHT_MAGIC2)
> >               return -EINVAL;
> >
> >       /* TODO: support resolution changes */
> > @@ -260,7 +266,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
> >       if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
> >               chroma_size /= 2;
> >
> > -     fwht_decode_frame(&cf, &state->ref_frame, flags, components_num);
> > +     fwht_decode_frame(&cf, &state->ref_frame, flags, components_num, state->stride);
> >
> >       /*
> >        * TODO - handle the case where the compressed stream encodes a
> > diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> > index ed53e28d4f9c..fa429a7cc4cf 100644
> > --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> > +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> > @@ -25,6 +25,8 @@ struct v4l2_fwht_state {
> >       const struct v4l2_fwht_pixfmt_info *info;
> >       unsigned int width;
> >       unsigned int height;
> > +     unsigned int stride;
> > +     unsigned int padded_height;
> >       unsigned int gop_size;
> >       unsigned int gop_cnt;
> >       u16 i_frame_qp;
> > diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> > index 0d7876f5acf0..d593d65869f7 100644
> > --- a/drivers/media/platform/vicodec/vicodec-core.c
> > +++ b/drivers/media/platform/vicodec/vicodec-core.c
> > @@ -77,6 +77,8 @@ static struct platform_device vicodec_pdev = {
> >  struct vicodec_q_data {
> >       unsigned int            width;
> >       unsigned int            height;
> > +     unsigned int            cropped_width;
> > +     unsigned int            cropped_height;
> >       unsigned int            sizeimage;
> >       unsigned int            sequence;
> >       const struct v4l2_fwht_pixfmt_info *info;
> > @@ -464,11 +466,11 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >               if (multiplanar)
> >                       return -EINVAL;
> >               pix = &f->fmt.pix;
> > -             pix->width = q_data->width;
> > -             pix->height = q_data->height;
> > +             pix->width = vic_round_dim(q_data->width, info->width_div);
> > +             pix->height = vic_round_dim(q_data->height, info->height_div);
> >               pix->field = V4L2_FIELD_NONE;
> >               pix->pixelformat = info->id;
> > -             pix->bytesperline = q_data->width * info->bytesperline_mult;
> > +             pix->bytesperline = pix->width * info->bytesperline_mult;
> >               pix->sizeimage = q_data->sizeimage;
> >               pix->colorspace = ctx->state.colorspace;
> >               pix->xfer_func = ctx->state.xfer_func;
> > @@ -481,13 +483,13 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >               if (!multiplanar)
> >                       return -EINVAL;
> >               pix_mp = &f->fmt.pix_mp;
> > -             pix_mp->width = q_data->width;
> > -             pix_mp->height = q_data->height;
> > +             pix_mp->width = vic_round_dim(q_data->width, info->width_div);
> > +             pix_mp->height = vic_round_dim(q_data->height, info->height_div);
> >               pix_mp->field = V4L2_FIELD_NONE;
> >               pix_mp->pixelformat = info->id;
> >               pix_mp->num_planes = 1;
> >               pix_mp->plane_fmt[0].bytesperline =
> > -                             q_data->width * info->bytesperline_mult;
> > +                             pix_mp->width * info->bytesperline_mult;
> >               pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage;
> >               pix_mp->colorspace = ctx->state.colorspace;
> >               pix_mp->xfer_func = ctx->state.xfer_func;
> > @@ -528,8 +530,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >               pix = &f->fmt.pix;
> >               if (pix->pixelformat != V4L2_PIX_FMT_FWHT)
> >                       info = find_fmt(pix->pixelformat);
> > -             pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
> > -             pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
> > +             pix->width = vic_round_dim(clamp(pix->width, MIN_WIDTH, MAX_WIDTH), info->width_div);
> > +             pix->height = vic_round_dim(clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);
> >               pix->field = V4L2_FIELD_NONE;
> >               pix->bytesperline =
> >                       pix->width * info->bytesperline_mult;
> > @@ -545,9 +547,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >               if (pix_mp->pixelformat != V4L2_PIX_FMT_FWHT)
> >                       info = find_fmt(pix_mp->pixelformat);
> >               pix_mp->num_planes = 1;
> > -             pix_mp->width = clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH) & ~7;
> > -             pix_mp->height =
> > -                     clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
> > +             pix_mp->width = vic_round_dim(clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH), info->width_div);
> > +             pix_mp->height = vic_round_dim(clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);
> >               pix_mp->field = V4L2_FIELD_NONE;
> >               plane->bytesperline =
> >                       pix_mp->width * info->bytesperline_mult;
> > @@ -635,13 +636,14 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> >       return vidioc_try_fmt(ctx, f);
> >  }
> >
> > -static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> > +static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f, unsigned int orig_width, unsigned int orig_height)
> >  {
> >       struct vicodec_q_data *q_data;
> >       struct vb2_queue *vq;
> >       bool fmt_changed = true;
> >       struct v4l2_pix_format_mplane *pix_mp;
> >       struct v4l2_pix_format *pix;
> > +     const struct v4l2_fwht_pixfmt_info *info;
> >
> >       vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> >       if (!vq)
> > @@ -650,6 +652,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >       q_data = get_q_data(ctx, f->type);
> >       if (!q_data)
> >               return -EINVAL;
> > +     info = q_data->info;
> >
> >       switch (f->type) {
> >       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> > @@ -658,8 +661,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >               if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
> >                       fmt_changed =
> >                               q_data->info->id != pix->pixelformat ||
> > -                             q_data->width != pix->width ||
> > -                             q_data->height != pix->height;
> > +                             vic_round_dim(q_data->width, info->width_div) != pix->width ||
> > +                             vic_round_dim(q_data->height, info->height_div) != pix->height;
> >
> >               if (vb2_is_busy(vq) && fmt_changed)
> >                       return -EBUSY;
> > @@ -668,8 +671,13 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >                       q_data->info = &pixfmt_fwht;
> >               else
> >                       q_data->info = find_fmt(pix->pixelformat);
> > -             q_data->width = pix->width;
> > -             q_data->height = pix->height;
> > +
> > +             q_data->width = orig_width;
> > +             if (q_data->cropped_width > orig_width)
> > +                     q_data->cropped_width = orig_width;
> > +             q_data->height = orig_height;
> > +             if (q_data->cropped_height > orig_height)
> > +                     q_data->cropped_height = orig_height;
> >               q_data->sizeimage = pix->sizeimage;
> >               break;
> >       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > @@ -678,8 +686,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >               if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
> >                       fmt_changed =
> >                               q_data->info->id != pix_mp->pixelformat ||
> > -                             q_data->width != pix_mp->width ||
> > -                             q_data->height != pix_mp->height;
> > +                             vic_round_dim(q_data->width, info->width_div) != pix_mp->width ||
> > +                             vic_round_dim(q_data->height, info->height_div) != pix_mp->height;
> >
> >               if (vb2_is_busy(vq) && fmt_changed)
> >                       return -EBUSY;
> > @@ -688,8 +696,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> >                       q_data->info = &pixfmt_fwht;
> >               else
> >                       q_data->info = find_fmt(pix_mp->pixelformat);
> > -             q_data->width = pix_mp->width;
> > -             q_data->height = pix_mp->height;
> > +             q_data->width = orig_width;
> > +             q_data->height = orig_height;
> >               q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
> >               break;
> >       default:
> > @@ -707,12 +715,27 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> >                               struct v4l2_format *f)
> >  {
> >       int ret;
> > +     unsigned int orig_width, orig_height;
> >
> > +     switch (f->type) {
> > +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> > +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> > +             orig_width = f->fmt.pix.width;
> > +             orig_height = f->fmt.pix.height;
> > +             break;
> > +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +             orig_width = f->fmt.pix_mp.width;
> > +             orig_height = f->fmt.pix_mp.height;
> > +             break;
> > +     default:
> > +             break;
> > +     }
> >       ret = vidioc_try_fmt_vid_cap(file, priv, f);
> >       if (ret)
> >               return ret;
> >
> > -     return vidioc_s_fmt(file2ctx(file), f);
> > +     return vidioc_s_fmt(file2ctx(file), f, orig_width, orig_height);
> >  }
> >
> >  static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> > @@ -721,36 +744,126 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> >       struct vicodec_ctx *ctx = file2ctx(file);
> >       struct v4l2_pix_format_mplane *pix_mp;
> >       struct v4l2_pix_format *pix;
> > +     unsigned int orig_width, orig_height;
> >       int ret;
> >
> > -     ret = vidioc_try_fmt_vid_out(file, priv, f);
> > -     if (ret)
> > -             return ret;
> > +     switch (f->type) {
> > +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> > +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> > +                             pix = &f->fmt.pix;
> > +             orig_width = pix->width;
> > +             orig_height = pix->height;
> > +             ret = vidioc_try_fmt_vid_out(file, priv, f);
> > +             if (ret)
> > +                     return ret;
> > +             ret = vidioc_s_fmt(file2ctx(file), f, orig_width, orig_height);
> > +             if (ret)
> > +                     return ret;
> > +             ctx->state.colorspace = pix->colorspace;
> > +             ctx->state.xfer_func = pix->xfer_func;
> > +             ctx->state.ycbcr_enc = pix->ycbcr_enc;
> > +             ctx->state.quantization = pix->quantization;
> > +             break;
> > +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +             pix_mp = &f->fmt.pix_mp;
> > +             orig_width = pix_mp->width;
> > +             orig_height = pix_mp->height;
> > +             ret = vidioc_try_fmt_vid_out(file, priv, f);
> > +             if (ret)
> > +                     return ret;
> > +             ret = vidioc_s_fmt(file2ctx(file), f, orig_width, orig_height);
> > +             if (ret)
> > +                     return ret;
> > +             ctx->state.colorspace = pix_mp->colorspace;
> > +             ctx->state.xfer_func = pix_mp->xfer_func;
> > +             ctx->state.ycbcr_enc = pix_mp->ycbcr_enc;
> > +             ctx->state.quantization = pix_mp->quantization;
> > +             break;
> > +     default:
> > +             break;
> > +     }
> > +     return ret;
> > +}
> >
> > -     ret = vidioc_s_fmt(file2ctx(file), f);
> > -     if (!ret) {
> > -             switch (f->type) {
> > -             case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> > -             case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> > -                     pix = &f->fmt.pix;
> > -                     ctx->state.colorspace = pix->colorspace;
> > -                     ctx->state.xfer_func = pix->xfer_func;
> > -                     ctx->state.ycbcr_enc = pix->ycbcr_enc;
> > -                     ctx->state.quantization = pix->quantization;
> > -                     break;
> > -             case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > -             case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > -                     pix_mp = &f->fmt.pix_mp;
> > -                     ctx->state.colorspace = pix_mp->colorspace;
> > -                     ctx->state.xfer_func = pix_mp->xfer_func;
> > -                     ctx->state.ycbcr_enc = pix_mp->ycbcr_enc;
> > -                     ctx->state.quantization = pix_mp->quantization;
> > -                     break;
> > +static int vidioc_g_selection(struct file *file, void *priv,
> > +                         struct v4l2_selection *s)
> > +{
> > +
> > +     struct vicodec_ctx *ctx = file2ctx(file);
> > +     struct vicodec_q_data *q_data;
> > +
> > +     q_data = get_q_data(ctx, s->type);
> > +     if (!q_data)
> > +             return -EINVAL;
> > +
> > +     /* encoder supports only cropping on the OUTPUT buffer */
> > +     if (ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +
> > +             switch (s->target) {
> > +             case V4L2_SEL_TGT_CROP_DEFAULT:
> > +             case V4L2_SEL_TGT_CROP_BOUNDS:
> > +                     s->r.left = s->r.top = 0;
> > +                     s->r.width = q_data->width;
> > +                     s->r.height = q_data->height;
> > +                     return 0;
> > +             case V4L2_SEL_TGT_CROP:
> > +                     s->r.left = s->r.top = 0;
> > +                     s->r.width = q_data->cropped_width;
> > +                     s->r.height = q_data->cropped_height;
> > +                     return 0;
> >               default:
> > -                     break;
> > +                     return -EINVAL;
> > +             }
> > +     /* decoder supports only composing on the CAPTURE buffer */
> > +     } else if (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> > +
> > +             switch (s->target) {
> > +             case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +                     s->r.left = s->r.top = 0;
> > +                     s->r.width = q_data->width;
> > +                     s->r.height = q_data->height;
> > +                     return 0;
> > +     /* TODO
> > +             case V4L2_SEL_TGT_COMPOSE:
> > +             case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +     */
>
> I would for now add these two as well. They would just return the same as
> COMPOSE_BOUNDS.
>
> > +             default:
> > +                     return -EINVAL;
> >               }
> >       }
> > -     return ret;
> > +     return -EINVAL;
> > +}
> > +
> > +static int vidioc_s_selection(struct file *file, void *priv,
> > +                         struct v4l2_selection *s)
> > +{
> > +
> > +     struct vicodec_ctx *ctx = file2ctx(file);
> > +     struct vicodec_q_data *q_data;
> > +
> > +     q_data = get_q_data(ctx, s->type);
> > +     if (!q_data)
> > +             return -EINVAL;
> > +
> > +     /* encoder supports only cropping on the OUTPUT buffer */
> > +     if (ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +             switch (s->target) {
> > +             case V4L2_SEL_TGT_CROP:
> > +                     s->r.left = s->r.top = 0;
> > +                     q_data->cropped_width = clamp(s->r.width, MIN_WIDTH, q_data->width);
> > +                     s->r.width = q_data->cropped_width;
> > +                     q_data->cropped_height = clamp(s->r.height, MIN_HEIGHT, q_data->height);
> > +                     s->r.height = q_data->cropped_height;
> > +                     return 0;
> > +             default:
> > +                     return -EINVAL;
> > +             }
> > +     /* decoder supports only composing on the CAPTURE buffer */
> > +     } else if (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> > +             /* TODO */
>
> Here too: the COMPOSE rectangle is just overridden with the COMPOSE_BOUNDS
> value (i.e. ignoring what userspace provides).
>
> The TODO is then that you actually should be able to change the COMPOSE
> target.
>
> > +     }
> > +     return -EINVAL;
> >  }
> >
> >  static void vicodec_mark_last_buf(struct vicodec_ctx *ctx)
> > @@ -895,6 +1008,9 @@ static const struct v4l2_ioctl_ops vicodec_ioctl_ops = {
> >       .vidioc_streamon        = v4l2_m2m_ioctl_streamon,
> >       .vidioc_streamoff       = v4l2_m2m_ioctl_streamoff,
> >
> > +     .vidioc_g_selection     = vidioc_g_selection,
> > +     .vidioc_s_selection     = vidioc_s_selection,
> > +
> >       .vidioc_try_encoder_cmd = vicodec_try_encoder_cmd,
> >       .vidioc_encoder_cmd     = vicodec_encoder_cmd,
> >       .vidioc_try_decoder_cmd = vicodec_try_decoder_cmd,
> > @@ -988,8 +1104,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
> >       struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
> >       struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
> >       struct v4l2_fwht_state *state = &ctx->state;
> > -     unsigned int size = q_data->width * q_data->height;
> >       const struct v4l2_fwht_pixfmt_info *info = q_data->info;
> > +     unsigned int size = vic_round_dim(q_data->width, info->width_div) * vic_round_dim(q_data->height, info->height_div);
>
> Break up this line, it's way too long. A newline after the * will work well.
>
> >       unsigned int chroma_div = info->width_div * info->height_div;
> >       unsigned int total_planes_size;
> >
> > @@ -1010,13 +1126,18 @@ static int vicodec_start_streaming(struct vb2_queue *q,
> >               if (!ctx->is_enc) {
> >                       state->width = q_data->width;
> >                       state->height = q_data->height;
> > +                     state->stride = vic_round_dim(q_data->width, info->width_div);
> > +                     state->padded_height = vic_round_dim(q_data->height, info->height_div);
> > +
> >               }
> >               return 0;
> >       }
> >
> >       if (ctx->is_enc) {
> > -             state->width = q_data->width;
> > -             state->height = q_data->height;
> > +             state->width = q_data->cropped_width;
> > +             state->height = q_data->cropped_height;
> > +             state->stride = vic_round_dim(q_data->width, info->width_div);
> > +             state->padded_height = vic_round_dim(q_data->height, info->height_div);
> >       }
> >       state->ref_frame.width = state->ref_frame.height = 0;
> >       state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
> > @@ -1206,6 +1327,8 @@ static int vicodec_open(struct file *file)
> >               ctx->is_enc ? v4l2_fwht_get_pixfmt(0) : &pixfmt_fwht;
> >       ctx->q_data[V4L2_M2M_SRC].width = 1280;
> >       ctx->q_data[V4L2_M2M_SRC].height = 720;
> > +     ctx->q_data[V4L2_M2M_SRC].cropped_width = 1280;
> > +     ctx->q_data[V4L2_M2M_SRC].cropped_height = 720;
> >       size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
> >               ctx->q_data[V4L2_M2M_SRC].info->sizeimage_div;
> >       if (ctx->is_enc)
> >
>
> The main thing that needs to be changed is terminology: make it clear when you are
> talking about the width/height, padded_width/height or stride by choosing the right
> variable names.
>
> Regards,
>
>         Hans
