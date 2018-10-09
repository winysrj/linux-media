Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35216 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeJIOqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 10:46:10 -0400
Received: by mail-yw1-f67.google.com with SMTP id y76-v6so248362ywd.2
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 00:30:36 -0700 (PDT)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id 15-v6sm3498530ywo.6.2018.10.09.00.30.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Oct 2018 00:30:34 -0700 (PDT)
Received: by mail-yw1-f44.google.com with SMTP id a197-v6so235609ywh.9
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 00:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20181004081119.102575-1-acourbot@chromium.org> <f1fa989b372b514f0a7534057de80b0c453cc8a3.camel@paulk.fr>
In-Reply-To: <f1fa989b372b514f0a7534057de80b0c453cc8a3.camel@paulk.fr>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 Oct 2018 16:30:22 +0900
Message-ID: <CAAFQd5A4t1F9kqepJ+11GJj7zJWKTp-bD1aCNL0N1w9Qeqtmuw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
To: contact@paulk.fr
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 4, 2018 at 9:46 PM Paul Kocialkowski <contact@paulk.fr> wrote:
>
> Hi,
>
> Here are a few minor suggestion about H.264 controls.
>
> Le jeudi 04 octobre 2018 =C3=A0 17:11 +0900, Alexandre Courbot a =C3=A9cr=
it :
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Docum=
entation/media/uapi/v4l/extended-controls.rst
> > index a9252225b63e..9d06d853d4ff 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -810,6 +810,31 @@ enum v4l2_mpeg_video_bitrate_mode -
> >      otherwise the decoder expects a single frame in per buffer.
> >      Applicable to the decoder, all codecs.
> >
> > +.. _v4l2-mpeg-h264:
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SPS``
> > +    Instance of struct v4l2_ctrl_h264_sps, containing the SPS of to us=
e with
> > +    the next queued frame. Applicable to the H.264 stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_PPS``
> > +    Instance of struct v4l2_ctrl_h264_pps, containing the PPS of to us=
e with
> > +    the next queued frame. Applicable to the H.264 stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX``
>
> For consistency with MPEG-2 and upcoming JPEG, I think we should call
> this "H264_QUANTIZATION".

I'd rather stay consistent with H.264 specification, which uses the
wording as defined in Alex's patch. Otherwise it would be difficult to
correlate between the controls and the specification, which is
something that the userspace developer would definitely need to
understand how to properly parse the stream and obtain the decoding
parameters.

>
> > +    Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the s=
caling
> > +    matrix to use when decoding the next queued frame. Applicable to t=
he H.264
> > +    stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM``
>
> Ditto with "H264_SLICE_PARAMS".
>

It doesn't seem to be related to the spec in this case and "params"
sounds better indeed.

Best regards,
Tomasz
