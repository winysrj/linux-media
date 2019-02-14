Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E536C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 02:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DBDB222A4
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 02:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="QP2Gf9t/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393182AbfBNCfT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 21:35:19 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51482 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfBNCfT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 21:35:19 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so4685246wmj.1
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2019 18:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IHMr5d6J2SggaePPhshoKvNCCCpsxcMEXXtmE47hauw=;
        b=QP2Gf9t/Cjn00iSRCVzHgtfD//rKUVFUZ4Zgu+fDkJm51/y31ZLhlEChjjLVEZAkhh
         ElCUG2zWQVL2TGRM9aeGC12xGFHUUJ3O+YGMghZRf1M1wTyUXG8kPypbXO9b9vOTh15r
         ww5/UVIO3UqhFkgXq+53B78c/XKQfwyq8yJ5eX+ucs8qSbRgkxyJv3+jpm5Aldpvjg3C
         P+j5gBXUU4NDG523YpdpnENYQDm0ylRKM8jVSzwjJXpcGMq6W+PZpQnYd21qDuSXusdX
         RuQ02skripHqXm8Do8X85GH+cCv0SegOJnKG7nyCfvKD4knpV2wu7Zskf3F1m+2VPHPa
         vLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IHMr5d6J2SggaePPhshoKvNCCCpsxcMEXXtmE47hauw=;
        b=qcnyoCps22KxQI1OoOAVqMkiCXBtfvTBNtwyV4pehwd5zwrObpDBbJYvl9Nhf/n2Or
         dCHkI+4jh5VyDB6jXoXmnoI8jFawYLcbCsvIKNbJYOTfgaQ1XXmGZB12qrCEVgYlQwTB
         0ata5GlT1i6lO4yX09sqX8WUzyGII96cDxftTcDrQP4EWGxY5fCb7kEp518B+zA5aLUS
         yQR+rrrmJ0h/Dfh5l6biM7TgSZhNX/hrzpUh9fJDGwtwbXmJvJuPWCFCXtx7BJUnOpJw
         q7GnupI0sknM5SP7I+eTAQP/HfurAohv0Y7TgORPKngDDhNQJbBOSCQzNRNKjOogkkgD
         6Qog==
X-Gm-Message-State: AHQUAub6Eb/M0z7yljtXn0a6PCsohsTFgDaynA88e4hBpdQcOMaRhv5k
        3cr62/8BZF0k1nz3I/KoX2z2XuruqGh4NeMzKKPTTgYAcL8=
X-Google-Smtp-Source: AHgI3IYL/NfZSk9DcODHDRb1Og4TH5NoXgEfSsIRtVztXqhxWCXzW9jjJSpYc7C5KAA6VOAAFUAHkndlOXESZTqp/bc=
X-Received: by 2002:a1c:80d6:: with SMTP id b205mr749039wmd.109.1550111716474;
 Wed, 13 Feb 2019 18:35:16 -0800 (PST)
MIME-Version: 1.0
References: <20190213211557.17696-1-ezequiel@collabora.com> <3507aedd6fd4be7ad66fa27a341faa36b4cef9dc.camel@collabora.com>
In-Reply-To: <3507aedd6fd4be7ad66fa27a341faa36b4cef9dc.camel@collabora.com>
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
Date:   Wed, 13 Feb 2019 21:35:04 -0500
Message-ID: <CAKQmDh_ZrwzxY6L2va1i0kumy1ipo2Hn7oeuR9BJMntKxLuYhQ@mail.gmail.com>
Subject: Re: [RFC] media: uapi: Add VP8 low-level decoder API compound controls.
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     DVB_Linux_Media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mer. 13 f=C3=A9vr. 2019 =C3=A0 16:23, Ezequiel Garcia
<ezequiel@collabora.com> a =C3=A9crit :
>
> Hi,
>
> On Wed, 2019-02-13 at 18:15 -0300, Ezequiel Garcia wrote:
> > From: Pawel Osciak <posciak@chromium.org>
> >
> > These controls are to be used with the new low-level decoder API for VP=
8
> > to provide additional parameters for the hardware that cannot parse the
> > input stream.
> >
> > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > [ezequiel: rebased]
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> > As the H.264 interface is hopefully close to be merged,
> > I'm sending the VP8 interface to start this discussion.
> >
> >  drivers/media/v4l2-core/v4l2-ctrls.c |   7 ++
> >  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> >  include/media/v4l2-ctrls.h           |   3 +
> >  include/media/vp8-ctrls.h            | 104 +++++++++++++++++++++++++++
> >  include/uapi/linux/videodev2.h       |   1 +
> >  5 files changed, 116 insertions(+)
> >  create mode 100644 include/media/vp8-ctrls.h
> >
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-=
core/v4l2-ctrls.c
> > index 366200d31bc0..c77a56c3e2aa 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -869,6 +869,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >       case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:                return "V=
PX P-Frame QP Value";
> >       case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:                   return "V=
P8 Profile";
> >       case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:                   return "V=
P9 Profile";
> > +     case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:                 return "V=
P8 Frame Header";
> >
> >       /* HEVC controls */
> >       case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:               return "H=
EVC I-Frame QP Value";
> > @@ -1323,6 +1324,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, en=
um v4l2_ctrl_type *type,
> >       case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:
> >               *type =3D V4L2_CTRL_TYPE_H264_DECODE_PARAMS;
> >               break;
> > +     case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:
> > +             *type =3D V4L2_CTRL_TYPE_VP8_FRAME_HDR;
> > +             break;
> >       default:
> >               *type =3D V4L2_CTRL_TYPE_INTEGER;
> >               break;
> > @@ -1694,6 +1698,7 @@ static int std_validate(const struct v4l2_ctrl *c=
trl, u32 idx,
> >       case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
> >       case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
> >       case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> > +     case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
> >               return 0;
> >
> >       default:
> > @@ -2290,6 +2295,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l=
2_ctrl_handler *hdl,
> >               break;
> >       case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> >               elem_size =3D sizeof(struct v4l2_ctrl_h264_decode_param);
> > +     case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
> > +             elem_size =3D sizeof(struct v4l2_ctrl_vp8_frame_header);
> >               break;
> >       default:
> >               if (type < V4L2_CTRL_COMPOUND_TYPES)
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-=
core/v4l2-ioctl.c
> > index c765c7c7c562..ea295aa9d0b6 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1324,6 +1324,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc =
*fmt)
> >               case V4L2_PIX_FMT_VC1_ANNEX_G:  descr =3D "VC-1 (SMPTE 41=
2M Annex G)"; break;
> >               case V4L2_PIX_FMT_VC1_ANNEX_L:  descr =3D "VC-1 (SMPTE 41=
2M Annex L)"; break;
> >               case V4L2_PIX_FMT_VP8:          descr =3D "VP8"; break;
> > +             case V4L2_PIX_FMT_VP8_FRAME:    descr =3D "VP8 FRAME"; br=
eak;
> >               case V4L2_PIX_FMT_VP9:          descr =3D "VP9"; break;
> >               case V4L2_PIX_FMT_HEVC:         descr =3D "HEVC"; break; =
/* aka H.265 */
> >               case V4L2_PIX_FMT_FWHT:         descr =3D "FWHT"; break; =
/* used in vicodec */
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index 22b6d09c4764..183c7fc5d18d 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -28,6 +28,7 @@
> >   */
> >  #include <media/mpeg2-ctrls.h>
> >  #include <media/h264-ctrls.h>
> > +#include <media/vp8-ctrls.h>
> >
> >  /* forward references */
> >  struct file;
> > @@ -55,6 +56,7 @@ struct poll_table_struct;
> >   * @p_h264_scaling_matrix:   Pointer to a struct v4l2_ctrl_h264_scalin=
g_matrix.
> >   * @p_h264_slice_param:              Pointer to a struct v4l2_ctrl_h26=
4_slice_param.
> >   * @p_h264_decode_param:     Pointer to a struct v4l2_ctrl_h264_decode=
_param.
> > + * @p_vp8_frame_header:              Pointer to a VP8 frame header str=
ucture.
> >   * @p:                               Pointer to a compound value.
> >   */
> >  union v4l2_ctrl_ptr {
> > @@ -71,6 +73,7 @@ union v4l2_ctrl_ptr {
> >       struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
> >       struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
> >       struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
> > +     struct v4l2_ctrl_vp8_frame_header *p_vp8_frame_header;
> >       void *p;
> >  };
> >
> > diff --git a/include/media/vp8-ctrls.h b/include/media/vp8-ctrls.h
> > new file mode 100644
> > index 000000000000..95b63a0cb239
> > --- /dev/null
> > +++ b/include/media/vp8-ctrls.h
> > @@ -0,0 +1,104 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * TODO: Make sure structs have no holes and are 4-byte aligned.
>
> This is still pending.
>
> > + */
> > +
> > +#ifndef _VP8_CTRLS_H_
> > +#define _VP8_CTRLS_H_
> > +
> > +#include <linux/v4l2-controls.h>
> > +
> > +#define V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR (V4L2_CID_MPEG_BASE + 260)
> > +
> > +#define V4L2_CTRL_TYPE_VP8_FRAME_HDR         0x220
> > +
> > +#define V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED              0x01
> > +#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_MAP           0x02
> > +#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_FEATURE_DATA  0x04
> > +
> > +struct v4l2_vp8_segment_header {
> > +     __u8 segment_feature_mode;
> > +     __s8 quant_update[4];
> > +     __s8 lf_update[4];
> > +     __u8 segment_probs[3];
> > +     __u32 flags;
> > +};
> > +
> > +#define V4L2_VP8_LF_HDR_ADJ_ENABLE   0x01
> > +#define V4L2_VP8_LF_HDR_DELTA_UPDATE 0x02
> > +struct v4l2_vp8_loopfilter_header {
> > +     __u16 type;
> > +     __u8 level;
> > +     __u8 sharpness_level;
> > +     __s8 ref_frm_delta_magnitude[4];
> > +     __s8 mb_mode_delta_magnitude[4];
> > +     __u16 flags;
> > +};
> > +
> > +struct v4l2_vp8_quantization_header {
> > +     __u8 y_ac_qi;
> > +     __s8 y_dc_delta;
> > +     __s8 y2_dc_delta;
> > +     __s8 y2_ac_delta;
> > +     __s8 uv_dc_delta;
> > +     __s8 uv_ac_delta;
> > +     __u16 dequant_factors[4][3][2];
> > +};
> > +
> > +struct v4l2_vp8_entropy_header {
> > +     __u8 coeff_probs[4][8][3][11];
> > +     __u8 y_mode_probs[4];
> > +     __u8 uv_mode_probs[3];
> > +     __u8 mv_probs[2][19];
> > +};
> > +
> > +#define V4L2_VP8_FRAME_HDR_FLAG_EXPERIMENTAL         0x01
> > +#define V4L2_VP8_FRAME_HDR_FLAG_SHOW_FRAME           0x02
> > +#define V4L2_VP8_FRAME_HDR_FLAG_MB_NO_SKIP_COEFF     0x04
> > +struct v4l2_ctrl_vp8_frame_header {
> > +     /* 0: keyframe, 1: not a keyframe */
> > +     __u8 key_frame; // could be a flag?
>
> Is there any reason why there is a separate field for key_frame?

This is exposed differently in VA VAPI, not flag because it's harder to use=
.
https://github.com/intel/libva/blob/master/va/va_dec_vp8.h#L91

>
> > +     __u8 version;
> > +
> > +     /* Populated also if not a key frame */
> > +     __u16 width;
> > +     __u16 height;
> > +     __u8 horizontal_scale;
> > +     __u8 vertical_scale;
> > +
> > +     struct v4l2_vp8_segment_header segment_header;
> > +     struct v4l2_vp8_loopfilter_header lf_header;
> > +     struct v4l2_vp8_quantization_header quant_header;
> > +     struct v4l2_vp8_entropy_header entropy_header;
> > +
> > +     __u8 sign_bias_golden;
> > +     __u8 sign_bias_alternate;
> > +
> > +     __u8 prob_skip_false;
> > +     __u8 prob_intra;
> > +     __u8 prob_last;
> > +     __u8 prob_gf;
> > +
> > +     __u32 first_part_size;
> > +     __u32 first_part_offset; // this needed? it's always 3 + 7 * s->k=
eyframe;
>
> As the comment says, it seems the first partition offset is always
> 3 + 7 * s->keyframe. Or am I wrong?

I can't find it in VA API or GStreamer parsers. Ideally we need to
look in the spec, if it's calculated it does not belong here.

https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/gst-li=
bs/gst/codecparsers/gstvp8parser.h#L255
https://github.com/intel/libva/blob/master/va/va_dec_vp8.h#L72

Notice that VA splits this in two, the some part in the picture
parameter, and some parts as SliceParameters. I believe it's to avoid
having conditional field base on if key_frame =3D=3D 0.

>
> > +     /*
> > +      * Offset in bits of MB data in first partition,
> > +      * i.e. bit offset starting from first_part_offset.
> > +      */
> > +     __u32 macroblock_bit_offset;
> > +
> > +     __u8 num_dct_parts;
> > +     __u32 dct_part_sizes[8];
> > +
> > +     __u8 bool_dec_range;
> > +     __u8 bool_dec_value;
> > +     __u8 bool_dec_count;
> > +
> > +     __u64 last_frame_ts;
> > +     __u64 golden_frame_ts;
> > +     __u64 alt_frame_ts;
> > +
> > +     __u8 flags;
> > +};
> > +
> > +#endif
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videod=
ev2.h
> > index f6a484017208..a906bfc0c8f0 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -664,6 +664,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SM=
PTE 421M Annex G compliant stream */
> >  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SM=
PTE 421M Annex L compliant stream */
> >  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 *=
/
> > +#define V4L2_PIX_FMT_VP8_FRAME v4l2_fourcc('V', 'P', '8', 'F') /* VP8 =
parsed frames */
> >  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 *=
/
> >  #define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC =
aka H.265 */
> >  #define V4L2_PIX_FMT_FWHT     v4l2_fourcc('F', 'W', 'H', 'T') /* Fast =
Walsh Hadamard Transform (vicodec) */
>
>
