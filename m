Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BD4C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 02:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A122190A
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 02:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iz0CBCWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfCUCI4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 22:08:56 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42226 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfCUCI4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 22:08:56 -0400
Received: by mail-ed1-f66.google.com with SMTP id j89so3688852edb.9
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 19:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kfdNK38M7Ugu20XRA4rvd71ysDrirHqoExPYIh8X+dU=;
        b=Iz0CBCWUqnKyBCPnk9jG8gp2RHR/WFfkagiPZq+FHi9WI7FBed/2J3dG9SO7wJtMfO
         v0VEWASvhRXPOCMj3iXk5jfLBBhfxdL4dSiK/uHslBtoLA8NwfYIQB834e1a09ICV5fi
         qMTnMUgd1A1bnnGzyjryDFOnS49jBsUTBMBk+KFt479DUW1k0/ArlqKKTQDdeP4zqIeE
         EE+QCd3nAIHILF62+SYynmV5p9cDFbx7vssUkcSXC5lq+dMk/IOvyzq750JYoJPzF0cn
         OFShC71+9FcfY4r41mpn2N5vvofSNL6SrDCTyzGI/64H2agtg5pJwfkbdw8+wL/Pnq33
         PhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kfdNK38M7Ugu20XRA4rvd71ysDrirHqoExPYIh8X+dU=;
        b=RrYEs1oO0TP4Plqth8F/s1zmZd452uRlpeNoOEZnNyl0jskO5K8T4YU7mLT3ns27Le
         MjPFrqAcMVhyBsQwZSWTLbR3rQ7Uyqpe7KN/xy6M/1ueyZZpmMGePnfX9fndqTi6vkqe
         5AZd1g3v07zfaGlBhNnzxcqpN7ADKHGiPv49AF7QOCoN1Fx63U/PoeUuV/L8Qgw8xcrV
         mRCOTEEtAzyWLnatW+nYDZnuR4vsdUbtr3djr37QNFiKKNrDV1xa43AjipJ3FZnprns+
         Ja/5diSLC4ywgGv3xEx9jXFuXcWYoj+MENve1YkPWzVSaU4xO+nMQz6CLCa9o8shSun8
         zN7A==
X-Gm-Message-State: APjAAAVrk1I7aqXg9EXBrF9ezRUw4IbB2PE+hgc6f5lY39f2XisgCIRJ
        7nmelslsEvRlbgiVn68it4fQjMjH8zy74wJX4d5aAA==
X-Google-Smtp-Source: APXvYqyTWz7vsFkSWeqmmAc/3CkigeFsStgT2GUVzZTu0gvgVhSAV4grA05HzmwhSMJupLXsTiO3LduA2is4dmu8lB0=
X-Received: by 2002:a17:906:52c8:: with SMTP id w8mr695910ejn.189.1553134134243;
 Wed, 20 Mar 2019 19:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190128072948.45788-1-linfish@google.com> <20190315084021.3572-1-linfish@google.com>
 <ef29126b-c118-f91f-3b23-c5103bad232a@xs4all.nl>
In-Reply-To: <ef29126b-c118-f91f-3b23-c5103bad232a@xs4all.nl>
From:   Fish Lin <linfish@google.com>
Date:   Thu, 21 Mar 2019 10:08:43 +0800
Message-ID: <CAHpF3dfdB_3rvhrAkV42Zt=8-0yif0Pa=n_ZmyqpNXpJGcH3_A@mail.gmail.com>
Subject: Re: [PATCH v4] Add following V4L2 QP parameters for H.264: *
 V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP
 * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Got it, thanks!

Fish

Hans Verkuil <hverkuil-cisco@xs4all.nl> =E6=96=BC 2019=E5=B9=B43=E6=9C=8820=
=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=8811:00=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
> This subject line is insanely long :-)
>
> Please use a short subject line for v5 (i.e. "Add V4L2 QP parameters for =
H.264")
> and mention the actual parameters you are adding in the commit log.
>
> Some more comments below:
>
> On 3/15/19 9:40 AM, Fish Lin wrote:
> > These controls will limit QP range for intra and inter frame,
> > provide more manual control to improve video encode quality.
> >
> > Signed-off-by: Fish Lin <linfish@google.com>
> > ---
> > Changelog since v3:
> > - Put document in ext-ctrls-codec.rst instead of extended-controls.rst
> >   (which was previous version).
> >
> > Changelog since v2:
> > - Add interaction with V4L2_CID_MPEG_VIDEO_H264_MIN/MAX_QP
> >   description in the document.
> >
> > Changelog since v1:
> > - Add description in document.
> >
> >  .../media/uapi/v4l/ext-ctrls-codec.rst        | 24 +++++++++++++++++++
> >  drivers/media/v4l2-core/v4l2-ctrls.c          |  4 ++++
> >  include/uapi/linux/v4l2-controls.h            |  6 +++++
> >  3 files changed, 34 insertions(+)
> >
> > diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documen=
tation/media/uapi/v4l/ext-ctrls-codec.rst
> > index c97fb7923be5..de60b2e788eb 100644
> > --- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> > +++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> > @@ -1048,6 +1048,30 @@ enum v4l2_mpeg_video_h264_entropy_mode -
> >      Quantization parameter for an B frame for H264. Valid range: from =
0
> >      to 51.
> >
> > +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
> > +    Minimum quantization parameter for H264 I frame, to limit I frame
>
> H264 -> the H264
> frame, to -> frame to
>
> Same below.
>
> > +    quality in a range. Valid range: from 0 to 51. If
>
> in -> to
>
> (you limit a value *to* a range, not 'in a range')
>
> Same below.
>
> Regards,
>
>         Hans
>
> > +    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is also set, the quantization para=
meter
> > +    should be chosen to meet both requirements.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
> > +    Maximum quantization parameter for H264 I frame, to limit I frame
> > +    quality in a range. Valid range: from 0 to 51. If
> > +    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is also set, the quantization para=
meter
> > +    should be chosen to meet both requirements.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
> > +    Minimum quantization parameter for H264 P frame, to limit P frame
> > +    quality in a range. Valid range: from 0 to 51. If
> > +    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is also set, the quantization para=
meter
> > +    should be chosen to meet both requirements.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
> > +    Maximum quantization parameter for H264 P frame, to limit P frame
> > +    quality in a range. Valid range: from 0 to 51. If
> > +    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is also set, the quantization para=
meter
> > +    should be chosen to meet both requirements.
> > +
> >  ``V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP (integer)``
> >      Quantization parameter for an I frame for MPEG4. Valid range: from=
 1
> >      to 31.
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-=
core/v4l2-ctrls.c
> > index b79d3bbd8350..115fb8debe23 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -828,6 +828,10 @@ const char *v4l2_ctrl_get_name(u32 id)
> >       case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
> >                                                               return "H=
264 Constrained Intra Pred";
> >       case V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET:   return "H=
264 Chroma QP Index Offset";
> > +     case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP:           return "H=
264 I-Frame Minimum QP Value";
> > +     case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP:           return "H=
264 I-Frame Maximum QP Value";
> > +     case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP:           return "H=
264 P-Frame Minimum QP Value";
> > +     case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP:           return "H=
264 P-Frame Maximum QP Value";
> >       case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:              return "M=
PEG4 I-Frame QP Value";
> >       case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:              return "M=
PEG4 P-Frame QP Value";
> >       case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:              return "M=
PEG4 B-Frame QP Value";
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4=
l2-controls.h
> > index 06479f2fb3ae..4421baa84177 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -535,6 +535,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type=
 {
> >  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP        (=
V4L2_CID_MPEG_BASE+382)
> >  #define V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION        (=
V4L2_CID_MPEG_BASE+383)
> >  #define V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET              (=
V4L2_CID_MPEG_BASE+384)
> > +
> > +#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP      (V4L2_CID_MPEG_BA=
SE+390)
> > +#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP      (V4L2_CID_MPEG_BA=
SE+391)
> > +#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP      (V4L2_CID_MPEG_BA=
SE+392)
> > +#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP      (V4L2_CID_MPEG_BA=
SE+393)
> > +
> >  #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP (V4L2_CID_MPEG_BASE+400)
> >  #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP (V4L2_CID_MPEG_BASE+401)
> >  #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP (V4L2_CID_MPEG_BASE+402)
> >
>
