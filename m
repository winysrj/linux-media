Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D424C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 00:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75A32083E
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 00:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfBOAGY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 19:06:24 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54614 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfBOAGY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 19:06:24 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 790812798EA
Message-ID: <4812f69e53d1313678d0c54577793362e6d7ad2e.camel@collabora.com>
Subject: Re: [RFC] media: uapi: Add VP8 low-level decoder API compound
 controls.
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
Cc:     DVB_Linux_Media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
Date:   Thu, 14 Feb 2019 21:06:10 -0300
In-Reply-To: <CAKQmDh_ZrwzxY6L2va1i0kumy1ipo2Hn7oeuR9BJMntKxLuYhQ@mail.gmail.com>
References: <20190213211557.17696-1-ezequiel@collabora.com>
         <3507aedd6fd4be7ad66fa27a341faa36b4cef9dc.camel@collabora.com>
         <CAKQmDh_ZrwzxY6L2va1i0kumy1ipo2Hn7oeuR9BJMntKxLuYhQ@mail.gmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2019-02-13 at 21:35 -0500, Nicolas Dufresne wrote:
> Le mer. 13 févr. 2019 à 16:23, Ezequiel Garcia
> <ezequiel@collabora.com> a écrit :
> > Hi,
> > 
> > On Wed, 2019-02-13 at 18:15 -0300, Ezequiel Garcia wrote:
> > > From: Pawel Osciak <posciak@chromium.org>
> > > 
> > > These controls are to be used with the new low-level decoder API for VP8
> > > to provide additional parameters for the hardware that cannot parse the
> > > input stream.
> > > 
> > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > [ezequiel: rebased]
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > > As the H.264 interface is hopefully close to be merged,
> > > I'm sending the VP8 interface to start this discussion.
> > > 
> > >  drivers/media/v4l2-core/v4l2-ctrls.c |   7 ++
> > >  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> > >  include/media/v4l2-ctrls.h           |   3 +
> > >  include/media/vp8-ctrls.h            | 104 +++++++++++++++++++++++++++
> > >  include/uapi/linux/videodev2.h       |   1 +
> > >  5 files changed, 116 insertions(+)
> > >  create mode 100644 include/media/vp8-ctrls.h
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > > index 366200d31bc0..c77a56c3e2aa 100644
> > > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > > @@ -869,6 +869,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> > >       case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:                return "VPX P-Frame QP Value";
> > >       case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:                   return "VP8 Profile";
> > >       case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:                   return "VP9 Profile";
> > > +     case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:                 return "VP8 Frame Header";
> > > 
> > >       /* HEVC controls */
> > >       case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:               return "HEVC I-Frame QP Value";
> > > @@ -1323,6 +1324,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
> > >       case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:
> > >               *type = V4L2_CTRL_TYPE_H264_DECODE_PARAMS;
> > >               break;
> > > +     case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:
> > > +             *type = V4L2_CTRL_TYPE_VP8_FRAME_HDR;
> > > +             break;
> > >       default:
> > >               *type = V4L2_CTRL_TYPE_INTEGER;
> > >               break;
> > > @@ -1694,6 +1698,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
> > >       case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
> > >       case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
> > >       case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> > > +     case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
> > >               return 0;
> > > 
> > >       default:
> > > @@ -2290,6 +2295,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
> > >               break;
> > >       case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> > >               elem_size = sizeof(struct v4l2_ctrl_h264_decode_param);
> > > +     case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
> > > +             elem_size = sizeof(struct v4l2_ctrl_vp8_frame_header);
> > >               break;
> > >       default:
> > >               if (type < V4L2_CTRL_COMPOUND_TYPES)
> > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > index c765c7c7c562..ea295aa9d0b6 100644
> > > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > @@ -1324,6 +1324,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> > >               case V4L2_PIX_FMT_VC1_ANNEX_G:  descr = "VC-1 (SMPTE 412M Annex G)"; break;
> > >               case V4L2_PIX_FMT_VC1_ANNEX_L:  descr = "VC-1 (SMPTE 412M Annex L)"; break;
> > >               case V4L2_PIX_FMT_VP8:          descr = "VP8"; break;
> > > +             case V4L2_PIX_FMT_VP8_FRAME:    descr = "VP8 FRAME"; break;
> > >               case V4L2_PIX_FMT_VP9:          descr = "VP9"; break;
> > >               case V4L2_PIX_FMT_HEVC:         descr = "HEVC"; break; /* aka H.265 */
> > >               case V4L2_PIX_FMT_FWHT:         descr = "FWHT"; break; /* used in vicodec */
> > > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > > index 22b6d09c4764..183c7fc5d18d 100644
> > > --- a/include/media/v4l2-ctrls.h
> > > +++ b/include/media/v4l2-ctrls.h
> > > @@ -28,6 +28,7 @@
> > >   */
> > >  #include <media/mpeg2-ctrls.h>
> > >  #include <media/h264-ctrls.h>
> > > +#include <media/vp8-ctrls.h>
> > > 
> > >  /* forward references */
> > >  struct file;
> > > @@ -55,6 +56,7 @@ struct poll_table_struct;
> > >   * @p_h264_scaling_matrix:   Pointer to a struct v4l2_ctrl_h264_scaling_matrix.
> > >   * @p_h264_slice_param:              Pointer to a struct v4l2_ctrl_h264_slice_param.
> > >   * @p_h264_decode_param:     Pointer to a struct v4l2_ctrl_h264_decode_param.
> > > + * @p_vp8_frame_header:              Pointer to a VP8 frame header structure.
> > >   * @p:                               Pointer to a compound value.
> > >   */
> > >  union v4l2_ctrl_ptr {
> > > @@ -71,6 +73,7 @@ union v4l2_ctrl_ptr {
> > >       struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
> > >       struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
> > >       struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
> > > +     struct v4l2_ctrl_vp8_frame_header *p_vp8_frame_header;
> > >       void *p;
> > >  };
> > > 
> > > diff --git a/include/media/vp8-ctrls.h b/include/media/vp8-ctrls.h
> > > new file mode 100644
> > > index 000000000000..95b63a0cb239
> > > --- /dev/null
> > > +++ b/include/media/vp8-ctrls.h
> > > @@ -0,0 +1,104 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * TODO: Make sure structs have no holes and are 4-byte aligned.
> > 
> > This is still pending.
> > 
> > > + */
> > > +
> > > +#ifndef _VP8_CTRLS_H_
> > > +#define _VP8_CTRLS_H_
> > > +
> > > +#include <linux/v4l2-controls.h>
> > > +
> > > +#define V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR (V4L2_CID_MPEG_BASE + 260)
> > > +
> > > +#define V4L2_CTRL_TYPE_VP8_FRAME_HDR         0x220
> > > +
> > > +#define V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED              0x01
> > > +#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_MAP           0x02
> > > +#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_FEATURE_DATA  0x04
> > > +
> > > +struct v4l2_vp8_segment_header {
> > > +     __u8 segment_feature_mode;
> > > +     __s8 quant_update[4];
> > > +     __s8 lf_update[4];
> > > +     __u8 segment_probs[3];
> > > +     __u32 flags;
> > > +};
> > > +
> > > +#define V4L2_VP8_LF_HDR_ADJ_ENABLE   0x01
> > > +#define V4L2_VP8_LF_HDR_DELTA_UPDATE 0x02
> > > +struct v4l2_vp8_loopfilter_header {
> > > +     __u16 type;
> > > +     __u8 level;
> > > +     __u8 sharpness_level;
> > > +     __s8 ref_frm_delta_magnitude[4];
> > > +     __s8 mb_mode_delta_magnitude[4];
> > > +     __u16 flags;
> > > +};
> > > +
> > > +struct v4l2_vp8_quantization_header {
> > > +     __u8 y_ac_qi;
> > > +     __s8 y_dc_delta;
> > > +     __s8 y2_dc_delta;
> > > +     __s8 y2_ac_delta;
> > > +     __s8 uv_dc_delta;
> > > +     __s8 uv_ac_delta;
> > > +     __u16 dequant_factors[4][3][2];
> > > +};
> > > +
> > > +struct v4l2_vp8_entropy_header {
> > > +     __u8 coeff_probs[4][8][3][11];
> > > +     __u8 y_mode_probs[4];
> > > +     __u8 uv_mode_probs[3];
> > > +     __u8 mv_probs[2][19];
> > > +};
> > > +
> > > +#define V4L2_VP8_FRAME_HDR_FLAG_EXPERIMENTAL         0x01
> > > +#define V4L2_VP8_FRAME_HDR_FLAG_SHOW_FRAME           0x02
> > > +#define V4L2_VP8_FRAME_HDR_FLAG_MB_NO_SKIP_COEFF     0x04
> > > +struct v4l2_ctrl_vp8_frame_header {
> > > +     /* 0: keyframe, 1: not a keyframe */
> > > +     __u8 key_frame; // could be a flag?
> > 
> > Is there any reason why there is a separate field for key_frame?
> 
> This is exposed differently in VA VAPI, not flag because it's harder to use.
> https://github.com/intel/libva/blob/master/va/va_dec_vp8.h#L91
> 

Well, it is exposed with a bit field. However, bit fields are rarely
used (if at all) in the uAPI.

Why do you say it's harder to use?

if (a.flags & KEYFRAME)

vs.

if (a.keyframe)

The way I see it, it's either all flags or all fields.
Although I might be missing something.

> > > +     __u8 version;
> > > +
> > > +     /* Populated also if not a key frame */
> > > +     __u16 width;
> > > +     __u16 height;
> > > +     __u8 horizontal_scale;
> > > +     __u8 vertical_scale;
> > > +
> > > +     struct v4l2_vp8_segment_header segment_header;
> > > +     struct v4l2_vp8_loopfilter_header lf_header;
> > > +     struct v4l2_vp8_quantization_header quant_header;
> > > +     struct v4l2_vp8_entropy_header entropy_header;
> > > +
> > > +     __u8 sign_bias_golden;
> > > +     __u8 sign_bias_alternate;
> > > +
> > > +     __u8 prob_skip_false;
> > > +     __u8 prob_intra;
> > > +     __u8 prob_last;
> > > +     __u8 prob_gf;
> > > +
> > > +     __u32 first_part_size;
> > > +     __u32 first_part_offset; // this needed? it's always 3 + 7 * s->keyframe;
> > 
> > As the comment says, it seems the first partition offset is always
> > 3 + 7 * s->keyframe. Or am I wrong?
> 
> I can't find it in VA API or GStreamer parsers. Ideally we need to
> look in the spec, if it's calculated it does not belong here.
> 

Looking into the spec, I don't think it's part of it.

> https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/gst-libs/gst/codecparsers/gstvp8parser.h#L255
> https://github.com/intel/libva/blob/master/va/va_dec_vp8.h#L72
> 
> Notice that VA splits this in two, the some part in the picture
> parameter, and some parts as SliceParameters. I believe it's to avoid
> having conditional field base on if key_frame == 0.
> 

That might make sense. Something to look into.

Thanks for the review!
Ezequiel

