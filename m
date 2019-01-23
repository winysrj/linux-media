Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814F8C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C4A20861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OLbH+1wE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfAWJw1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 04:52:27 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:32897 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfAWJw1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 04:52:27 -0500
Received: by mail-ot1-f67.google.com with SMTP id i20so1403361otl.0
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 01:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9lf/Hc9Sx7T4k9CNZ+yhXGHGbCp+DRjBH5/K+Yanz/Q=;
        b=OLbH+1wEGkV7NjR245ejRYgEZZCk687XlAK5730DEnCI/Gswme7SHG/UMJcvBKIcul
         iY0X03VXaNKDSTxxjJD4POnCn7wacGzXRwECRuW4O57H7RHZbonjzpU42EdVAPB0sFYx
         yWoAEG7JFMNU1b+9QbltPXEwHBkE4y4TJo9ug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9lf/Hc9Sx7T4k9CNZ+yhXGHGbCp+DRjBH5/K+Yanz/Q=;
        b=NzU89yv1zFcg+iRLtVAQ8TULc+bmJYItet76ud21Bniz90mYwlDKilOb1P2jW+9syo
         uMf+7lat2L8OePwm+rqmjEKuqC4hyHHYIQd3aYNchcAOe+m9EW8lt2mJFHmvUkiKbwMy
         rPi5udifxenGQjMLTbsvE0dY2oe+VWl5pny303fzm/WOhacN+g5yuKXc3Wh6+ZgSNVIO
         ywCpqEN2daBsdoim/WkN+l75SBdCGuOVqSzWxKg/5fVpNJnCH1sKLLEQ6k/hT10j+bP6
         /m6Uwp2fdERds6M12husrxABf7LCIDjlT9dNty9Hdm9W7htDsXQ1+Txhnzfx3LcxA/WF
         1sgg==
X-Gm-Message-State: AJcUukdQCZRR3PaDIWrFnmLbj04F727bEvkwAtrhQwtYXe4fRd+VbCnx
        EFMbVlzEhOU6Q/XRFmUbiiDK06xuN9E=
X-Google-Smtp-Source: ALg8bN7tXKIS77tJlmXOGF1NErdYMwIS5gXwSXenok0N4MuCfaSiV14GdO0XVzcRl7i902Z1FHuB8A==
X-Received: by 2002:a9d:641:: with SMTP id 59mr919926otn.215.1548237145524;
        Wed, 23 Jan 2019 01:52:25 -0800 (PST)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id i22sm7639389otp.7.2019.01.23.01.52.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 01:52:25 -0800 (PST)
Received: by mail-oi1-f170.google.com with SMTP id y23so1300943oia.4
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 01:52:25 -0800 (PST)
X-Received: by 2002:aca:c2c3:: with SMTP id s186mr998297oif.173.1548237144539;
 Wed, 23 Jan 2019 01:52:24 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-3-tfiga@chromium.org>
 <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl>
In-Reply-To: <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 23 Jan 2019 18:52:13 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DthE3vL+gycEBgm+aF0YhRncrfBVBNLLF4g+oKhBHEWQ@mail.gmail.com>
Message-ID: <CAAFQd5DthE3vL+gycEBgm+aF0YhRncrfBVBNLLF4g+oKhBHEWQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Nov 12, 2018 at 10:23 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 10/22/2018 04:49 PM, Tomasz Figa wrote:
> > Due to complexity of the video encoding process, the V4L2 drivers of
> > stateful encoder hardware require specific sequences of V4L2 API calls
> > to be followed. These include capability enumeration, initialization,
> > encoding, encode parameters change, drain and reset.
> >
> > Specifics of the above have been discussed during Media Workshops at
> > LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API that
> > originated at those events was later implemented by the drivers we alre=
ady
> > have merged in mainline, such as s5p-mfc or coda.
> >
> > The only thing missing was the real specification included as a part of
> > Linux Media documentation. Fix it now and document the encoder part of
> > the Codec API.
> >
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > ---
> >  Documentation/media/uapi/v4l/dev-encoder.rst  | 579 ++++++++++++++++++
> >  Documentation/media/uapi/v4l/devices.rst      |   1 +
> >  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |   5 +
> >  Documentation/media/uapi/v4l/v4l2.rst         |   2 +
> >  .../media/uapi/v4l/vidioc-encoder-cmd.rst     |  38 +-
> >  5 files changed, 610 insertions(+), 15 deletions(-)
> >  create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst b/Documentati=
on/media/uapi/v4l/dev-encoder.rst
> > new file mode 100644
> > index 000000000000..41139e5e48eb
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/dev-encoder.rst
> > @@ -0,0 +1,579 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _encoder:
> > +
> > +*************************************************
> > +Memory-to-memory Stateful Video Encoder Interface
> > +*************************************************
> > +
> > +A stateful video encoder takes raw video frames in display order and e=
ncodes
> > +them into a bitstream. It generates complete chunks of the bitstream, =
including
> > +all metadata, headers, etc. The resulting bitstream does not require a=
ny
> > +further post-processing by the client.
> > +
> > +Performing software stream processing, header generation etc. in the d=
river
> > +in order to support this interface is strongly discouraged. In case su=
ch
> > +operations are needed, use of the Stateless Video Encoder Interface (i=
n
> > +development) is strongly advised.
> > +
> > +Conventions and notation used in this document
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. The general V4L2 API rules apply if not specified in this document
> > +   otherwise.
> > +
> > +2. The meaning of words "must", "may", "should", etc. is as per RFC
> > +   2119.
> > +
> > +3. All steps not marked "optional" are required.
> > +
> > +4. :c:func:`VIDIOC_G_EXT_CTRLS`, :c:func:`VIDIOC_S_EXT_CTRLS` may be u=
sed
> > +   interchangeably with :c:func:`VIDIOC_G_CTRL`, :c:func:`VIDIOC_S_CTR=
L`,
> > +   unless specified otherwise.
> > +
> > +5. Single-plane API (see spec) and applicable structures may be used
> > +   interchangeably with Multi-plane API, unless specified otherwise,
> > +   depending on encoder capabilities and following the general V4L2
> > +   guidelines.
> > +
> > +6. i =3D [a..b]: sequence of integers from a to b, inclusive, i.e. i =
=3D
> > +   [0..2]: i =3D 0, 1, 2.
> > +
> > +7. Given an ``OUTPUT`` buffer A, A' represents a buffer on the ``CAPTU=
RE``
> > +   queue containing data (encoded frame/stream) that resulted from pro=
cessing
> > +   buffer A.
>
> The same comments as I mentioned for the previous patch apply to this sec=
tion.
>

I suppose you mean the decoder patch, right? (Will address those.)

> > +
> > +Glossary
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Refer to :ref:`decoder-glossary`.
>
> Ah, you refer to the same glossary. Then my comment about the source reso=
lution
> terms is obviously wrong.
>
> I wonder if it wouldn't be better to split off the sections above into a =
separate
> HW codec intro section where you explain the differences between stateful=
/stateless
> encoders and decoders, and add the conventions and glossary.
>
> After that you have the three documents for each variant (later four when=
 we get
> stateless encoders).
>
> Up to you, and it can be done later in a follow-up patch.
>

I'd indeed prefer to do it in a follow up patch, to avoid distracting
this series too much. Agreed that such an intro section would make
sense, though.

> > +
> > +State machine
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +.. kernel-render:: DOT
> > +   :alt: DOT digraph of encoder state machine
> > +   :caption: Encoder state machine
> > +
> > +   digraph encoder_state_machine {
> > +       node [shape =3D doublecircle, label=3D"Encoding"] Encoding;
> > +
> > +       node [shape =3D circle, label=3D"Initialization"] Initializatio=
n;
> > +       node [shape =3D circle, label=3D"Stopped"] Stopped;
> > +       node [shape =3D circle, label=3D"Drain"] Drain;
> > +       node [shape =3D circle, label=3D"Reset"] Reset;
> > +
> > +       node [shape =3D point]; qi
> > +       qi -> Initialization [ label =3D "open()" ];
> > +
> > +       Initialization -> Encoding [ label =3D "Both queues streaming" =
];
> > +
> > +       Encoding -> Drain [ label =3D "V4L2_DEC_CMD_STOP" ];
> > +       Encoding -> Reset [ label =3D "VIDIOC_STREAMOFF(CAPTURE)" ];
> > +       Encoding -> Stopped [ label =3D "VIDIOC_STREAMOFF(OUTPUT)" ];
> > +       Encoding -> Encoding;
> > +
> > +       Drain -> Stopped [ label =3D "All CAPTURE\nbuffers dequeued\nor=
\nVIDIOC_STREAMOFF(CAPTURE)" ];
> > +       Drain -> Reset [ label =3D "VIDIOC_STREAMOFF(CAPTURE)" ];
> > +
> > +       Reset -> Encoding [ label =3D "VIDIOC_STREAMON(CAPTURE)" ];
> > +       Reset -> Initialization [ label =3D "VIDIOC_REQBUFS(OUTPUT, 0)"=
 ];
> > +
> > +       Stopped -> Encoding [ label =3D "V4L2_DEC_CMD_START\nor\nVIDIOC=
_STREAMON(OUTPUT)" ];
> > +       Stopped -> Reset [ label =3D "VIDIOC_STREAMOFF(CAPTURE)" ];
> > +   }
> > +
> > +Querying capabilities
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. To enumerate the set of coded formats supported by the encoder, the
> > +   client may call :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
> > +
> > +   * The full set of supported formats will be returned, regardless of=
 the
> > +     format set on ``OUTPUT``.
> > +
> > +2. To enumerate the set of supported raw formats, the client may call
> > +   :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
> > +
> > +   * Only the formats supported for the format currently active on ``C=
APTURE``
> > +     will be returned.
> > +
> > +   * In order to enumerate raw formats supported by a given coded form=
at,
> > +     the client must first set that coded format on ``CAPTURE`` and th=
en
> > +     enumerate the formats on ``OUTPUT``.
> > +
> > +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect suppo=
rted
> > +   resolutions for a given format, passing desired pixel format in
> > +   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` for a coded p=
ixel
> > +     format will include all possible coded resolutions supported by t=
he
> > +     encoder for given coded pixel format.
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` for a raw pix=
el format
> > +     will include all possible frame buffer resolutions supported by t=
he
> > +     encoder for given raw pixel format and coded format currently set=
 on
> > +     ``CAPTURE``.
> > +
> > +4. Supported profiles and levels for given format, if applicable, may =
be
>
> format -> the coded format currently set on ``CAPTURE``
>

Ack.

> > +   queried using their respective controls via :c:func:`VIDIOC_QUERYCT=
RL`.
> > +
> > +5. Any additional encoder capabilities may be discovered by querying
> > +   their respective controls.
> > +
> > +Initialization
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. **Optional.** Enumerate supported formats and resolutions. See
> > +   `Querying capabilities` above.
>
> Can be dropped IMHO.
>

Ack.

> > +
> > +2. Set a coded format on the ``CAPTURE`` queue via :c:func:`VIDIOC_S_F=
MT`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +     ``pixelformat``
> > +         the coded format to be produced
> > +
> > +     ``sizeimage``
> > +         desired size of ``CAPTURE`` buffers; the encoder may adjust i=
t to
> > +         match hardware requirements
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``sizeimage``
> > +         adjusted size of ``CAPTURE`` buffers
> > +
> > +   .. warning::
> > +
> > +      Changing the ``CAPTURE`` format may change the currently set ``O=
UTPUT``
> > +      format. The encoder will derive a new ``OUTPUT`` format from the
> > +      ``CAPTURE`` format being set, including resolution, colorimetry
> > +      parameters, etc. If the client needs a specific ``OUTPUT`` forma=
t, it
> > +      must adjust it afterwards.
> > +
> > +3. **Optional.** Enumerate supported ``OUTPUT`` formats (raw formats f=
or
> > +   source) for the selected coded format via :c:func:`VIDIOC_ENUM_FMT`=
.
>
> Does this return the same set of formats as in the 'Querying Capabilities=
' phase?
>

It's actually an interesting question. At this point we wouldn't have
the OUTPUT resolution set yet, so that would be the same set as in the
initial query. If we set the resolution (with some arbitrary
pixelformat), it may become a subset...

> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``pixelformat``
> > +         raw format supported for the coded format currently selected =
on
> > +         the ``OUTPUT`` queue.
>
> OUTPUT -> CAPTURE
>

Ack.

> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +4. Set the raw source format on the ``OUTPUT`` queue via
> > +   :c:func:`VIDIOC_S_FMT`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     ``pixelformat``
> > +         raw format of the source
> > +
> > +     ``width``, ``height``
> > +         source resolution
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``width``, ``height``
> > +         may be adjusted by encoder to match alignment requirements, a=
s
> > +         required by the currently selected formats
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * Setting the source resolution will reset the selection rectangles=
 to their
> > +     default values, based on the new resolution, as described in the =
step 5
> > +     below.
> > +
> > +5. **Optional.** Set the visible resolution for the stream metadata vi=
a
> > +   :c:func:`VIDIOC_S_SELECTION` on the ``OUTPUT`` queue.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     ``target``
> > +         set to ``V4L2_SEL_TGT_CROP``
> > +
> > +     ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > +         visible rectangle; this must fit within the `V4L2_SEL_TGT_CRO=
P_BOUNDS`
> > +         rectangle and may be subject to adjustment to match codec and
> > +         hardware constraints
> > +
> > +   * **Return fields:**
> > +
> > +     ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > +         visible rectangle adjusted by the encoder
> > +
> > +   * The following selection targets are supported on ``OUTPUT``:
> > +
> > +     ``V4L2_SEL_TGT_CROP_BOUNDS``
> > +         equal to the full source frame, matching the active ``OUTPUT`=
`
> > +         format
> > +
> > +     ``V4L2_SEL_TGT_CROP_DEFAULT``
> > +         equal to ``V4L2_SEL_TGT_CROP_BOUNDS``
> > +
> > +     ``V4L2_SEL_TGT_CROP``
> > +         rectangle within the source buffer to be encoded into the
> > +         ``CAPTURE`` stream; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``
>
> Since this defaults to the CROP_DEFAULT rectangle this means that if you =
have
> a 16x16 macroblock size and you want to encode 1080p, you will always hav=
e to
> explicitly set the CROP rectangle to 1920x1080, right? Since the default =
will
> be 1088 instead of 1080.

Not necessarily. It depends on whether the encoder needs the source
buffers to be aligned to macroblocks or not.

>
> It is probably wise to explicitly mention this.
>

Sounds reasonable to add a note.

> > +
> > +     ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> > +         maximum rectangle within the coded resolution, which the crop=
ped
> > +         source frame can be output into; if the hardware does not sup=
port
>
> output -> composed
>

Ack.

> > +         composition or scaling, then this is always equal to the rect=
angle of
> > +         width and height matching ``V4L2_SEL_TGT_CROP`` and located a=
t (0, 0)
> > +
> > +     ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
> > +         equal to a rectangle of width and height matching
> > +         ``V4L2_SEL_TGT_CROP`` and located at (0, 0)
> > +
> > +     ``V4L2_SEL_TGT_COMPOSE``
> > +         rectangle within the coded frame, which the cropped source fr=
ame
> > +         is to be output into; defaults to
>
> output -> composed
>

Ack.

> > +         ``V4L2_SEL_TGT_COMPOSE_DEFAULT``; read-only on hardware witho=
ut
> > +         additional compose/scaling capabilities; resulting stream wil=
l
> > +         have this rectangle encoded as the visible rectangle in its
> > +         metadata
> > +
> > +   .. warning::
> > +
> > +      The encoder may adjust the crop/compose rectangles to the neares=
t
> > +      supported ones to meet codec and hardware requirements. The clie=
nt needs
> > +      to check the adjusted rectangle returned by :c:func:`VIDIOC_S_SE=
LECTION`.
> > +
> > +6. Allocate buffers for both ``OUTPUT`` and ``CAPTURE`` via
> > +   :c:func:`VIDIOC_REQBUFS`. This may be performed in any order.
> > +
> > +   * **Required fields:**
> > +
> > +     ``count``
> > +         requested number of buffers to allocate; greater than zero
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT`` or
> > +         ``CAPTURE``
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``count``
> > +          actual number of buffers allocated
> > +
> > +   .. warning::
> > +
> > +      The actual number of allocated buffers may differ from the ``cou=
nt``
> > +      given. The client must check the updated value of ``count`` afte=
r the
> > +      call returns.
> > +
> > +   .. note::
> > +
> > +      To allocate more than the minimum number of buffers (for pipelin=
e depth),
> > +      the client may query the ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT`` or
> > +      ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE`` control respectively, to ge=
t the
> > +      minimum number of buffers required by the encoder/format, and pa=
ss the
> > +      obtained value plus the number of additional buffers needed in t=
he
> > +      ``count`` field to :c:func:`VIDIOC_REQBUFS`.
>
> Does V4L2_CID_MIN_BUFFERS_FOR_CAPTURE make any sense for encoders?
>

Indeed, I don't think it makes much sense. Let me drop it.

> V4L2_CID_MIN_BUFFERS_FOR_OUTPUT can make sense depending on GOP size etc.
>

Yep.


> > +
> > +   Alternatively, :c:func:`VIDIOC_CREATE_BUFS` can be used to have mor=
e
> > +   control over buffer allocation.
> > +
> > +   * **Required fields:**
> > +
> > +     ``count``
> > +         requested number of buffers to allocate; greater than zero
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``count``
> > +         adjusted to the number of allocated buffers
> > +
> > +7. Begin streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
> > +   :c:func:`VIDIOC_STREAMON`. This may be performed in any order. The =
actual
> > +   encoding process starts when both queues start streaming.
> > +
> > +.. note::
> > +
> > +   If the client stops the ``CAPTURE`` queue during the encode process=
 and then
> > +   restarts it again, the encoder will begin generating a stream indep=
endent
> > +   from the stream generated before the stop. The exact constraints de=
pend
> > +   on the coded format, but may include the following implications:
> > +
> > +   * encoded frames produced after the restart must not reference any
> > +     frames produced before the stop, e.g. no long term references for
> > +     H.264,
> > +
> > +   * any headers that must be included in a standalone stream must be
> > +     produced again, e.g. SPS and PPS for H.264.
> > +
> > +Encoding
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This state is reached after the `Initialization` sequence finishes suc=
cesfully.
>
> successfully
>

Ack.

> > +In this state, client queues and dequeues buffers to both queues via
>
> client -> the client
>

Ack.

> > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following the standa=
rd
> > +semantics.
> > +
> > +The contents of encoded ``CAPTURE`` buffers depend on the active coded=
 pixel
>
> contents ... depend -> content ... depends
>

The plural sounds more natural to me to be honest.

> > +format and may be affected by codec-specific extended controls, as sta=
ted
> > +in the documentation of each format.
> > +
> > +Both queues operate independently, following standard behavior of V4L2=
 buffer
> > +queues and memory-to-memory devices. In addition, the order of encoded=
 frames
> > +dequeued from the ``CAPTURE`` queue may differ from the order of queui=
ng raw
> > +frames to the ``OUTPUT`` queue, due to properties of the selected code=
d format,
> > +e.g. frame reordering.
> > +
> > +The client must not assume any direct relationship between ``CAPTURE``=
 and
> > +``OUTPUT`` buffers and any specific timing of buffers becoming
> > +available to dequeue. Specifically,
> > +
> > +* a buffer queued to ``OUTPUT`` may result in more than 1 buffer produ=
ced on
> > +  ``CAPTURE`` (if returning an encoded frame allowed the encoder to re=
turn a
> > +  frame that preceded it in display, but succeeded it in the decode or=
der),
> > +
> > +* a buffer queued to ``OUTPUT`` may result in a buffer being produced =
on
> > +  ``CAPTURE`` later into encode process, and/or after processing furth=
er
> > +  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
> > +  reordering is used,
> > +
> > +* buffers may become available on the ``CAPTURE`` queue without additi=
onal
> > +  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because=
 of the
> > +  ``OUTPUT`` buffers queued in the past whose decoding results are onl=
y
> > +  available at later time, due to specifics of the decoding process,
> > +
> > +* buffers queued to ``OUTPUT`` may not become available to dequeue ins=
tantly
> > +  after being encoded into a corresponding ``CATPURE`` buffer, e.g. if=
 the
> > +  encoder needs to use the frame as a reference for encoding further f=
rames.
> > +
> > +.. note::
> > +
> > +   To allow matching encoded ``CAPTURE`` buffers with ``OUTPUT`` buffe=
rs they
> > +   originated from, the client can set the ``timestamp`` field of the
> > +   :c:type:`v4l2_buffer` struct when queuing an ``OUTPUT`` buffer. The
> > +   ``CAPTURE`` buffer(s), which resulted from encoding that ``OUTPUT``=
 buffer
> > +   will have their ``timestamp`` field set to the same value when dequ=
eued.
> > +
> > +   In addition to the straighforward case of one ``OUTPUT`` buffer pro=
ducing
> > +   one ``CAPTURE`` buffer, the following cases are defined:
> > +
> > +   * one ``OUTPUT`` buffer generates multiple ``CAPTURE`` buffers: the=
 same
> > +     ``OUTPUT`` timestamp will be copied to multiple ``CAPTURE`` buffe=
rs,
> > +
> > +   * the encoding order differs from the presentation order (i.e. the
> > +     ``CAPTURE`` buffers are out-of-order compared to the ``OUTPUT`` b=
uffers):
> > +     ``CAPTURE`` timestamps will not retain the order of ``OUTPUT`` ti=
mestamps
> > +     and thus monotonicity of the timestamps cannot be guaranteed.
> > +
> > +.. note::
> > +
> > +   To let the client distinguish between frame types (keyframes, inter=
mediate
> > +   frames; the exact list of types depends on the coded format), the
> > +   ``CAPTURE`` buffers will have corresponding flag bits set in their
> > +   :c:type:`v4l2_buffer` struct when dequeued. See the documentation o=
f
> > +   :c:type:`v4l2_buffer` and each coded pixel format for exact list of=
 flags
> > +   and their meanings.
>
> Is this required? (I think it should, but it isn't the case today).
>

At least V4L2_BUF_FLAG_KEYFRAME has been always required for Chromium,
as it's indispensable for any kind of real time streaming, e.g.
Hangouts. (Although technically the streaming layer could parse the
stream and pick it up itself...) I can see s5p-mfc, coda, venus and
mtk-vcodec supporting at least this one. mtk-vcodec doesn't seem to
support the other ones.

Should we make only the V4L2_BUF_FLAG_KEYFRAME mandatory, at least for now?

> Is the current set of buffer flags (Key/B/P frame) sufficient for the cur=
rent
> set of codecs?
>

No, there is no way to distinguish between I and IDR frames in H.264.
You can see more details on our issue tracker: crbug.com/868792.

> > +
> > +Encoding parameter changes
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > +
> > +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> > +parameters at any time. The availability of parameters is encoder-spec=
ific
> > +and the client must query the encoder to find the set of available con=
trols.
> > +
> > +The ability to change each parameter during encoding is encoder-specif=
ic, as per
> > +the standard semantics of the V4L2 control interface. The client may a=
ttempt
> > +setting a control of its interest during encoding and if the operation=
 fails
>
> I'd simplify this:
>
> The client may attempt to set a control during encoding...

Ack.

>
> > +with the -EBUSY error code, the ``CAPTURE`` queue needs to be stopped =
for the
> > +configuration change to be allowed (following the `Drain` sequence wil=
l be
> > +needed to avoid losing the already queued/encoded frames).
>
> Rephrase:
>
> ...to be allowed. To do this follow the `Drain` sequence to avoid losing =
the
> already queued/encoded frames.
>

How about "To do this, it may follow...", to keep client as the third
person convention?

> > +
> > +The timing of parameter updates is encoder-specific, as per the standa=
rd
> > +semantics of the V4L2 control interface. If the client needs to apply =
the
> > +parameters exactly at specific frame, using the Request API should be
>
> Change this to a reference to the Request API section.
>

Do you mean just adding a reference or some other changes too?

> > +considered, if supported by the encoder.
> > +
> > +Drain
> > +=3D=3D=3D=3D=3D
> > +
> > +To ensure that all the queued ``OUTPUT`` buffers have been processed a=
nd the
> > +related ``CAPTURE`` buffers output to the client, the client must foll=
ow the
>
> output -> are output
>
> or perhaps better (up to you): are given
>

Ack (went with the latter and updated the decoder too).

> > +drain sequence described below. After the drain sequence ends, the cli=
ent has
> > +received all encoded frames for all ``OUTPUT`` buffers queued before t=
he
> > +sequence was started.
> > +
> > +1. Begin the drain sequence by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``cmd``
> > +         set to ``V4L2_ENC_CMD_STOP``
> > +
> > +     ``flags``
> > +         set to 0
> > +
> > +     ``pts``
> > +         set to 0
> > +
> > +   .. warning::
> > +
> > +   The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE=
`` queues
> > +   are streaming. For compatibility reasons, the call to
> > +   :c:func:`VIDIOC_ENCODER_CMD` will not fail even if any of the queue=
s is not
> > +   streaming, but at the same time it will not initiate the `Drain` se=
quence
> > +   and so the steps described below would not be applicable.
> > +
> > +2. Any ``OUTPUT`` buffers queued by the client before the
> > +   :c:func:`VIDIOC_ENCODER_CMD` was issued will be processed and encod=
ed as
> > +   normal. The client must continue to handle both queues independentl=
y,
> > +   similarly to normal encode operation. This includes,
> > +
> > +   * queuing and dequeuing ``CAPTURE`` buffers, until a buffer marked =
with the
> > +     ``V4L2_BUF_FLAG_LAST`` flag is dequeued,
> > +
> > +     .. warning::
> > +
> > +        The last buffer may be empty (with :c:type:`v4l2_buffer`
> > +        ``bytesused`` =3D 0) and in such case it must be ignored by th=
e client,
>
> such -> that
>
> Check the previous patch as well if you used the phrase 'such case' and r=
eplace
> it with 'that case'.
>

Ack.

> > +        as it does not contain an encoded frame.
> > +
> > +     .. note::
> > +
> > +        Any attempt to dequeue more buffers beyond the buffer marked w=
ith
> > +        ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > +        :c:func:`VIDIOC_DQBUF`.
> > +
> > +   * dequeuing processed ``OUTPUT`` buffers, until all the buffers que=
ued
> > +     before the ``V4L2_ENC_CMD_STOP`` command are dequeued,
> > +
> > +   * dequeuing the ``V4L2_EVENT_EOS`` event, if the client subscribes =
to it.
> > +
> > +   .. note::
> > +
> > +      For backwards compatibility, the encoder will signal a ``V4L2_EV=
ENT_EOS``
> > +      event when the last the last frame has been decoded and all fram=
es are
>
> the last the last -> the last
>

Ack.

> > +      ready to be dequeued. It is a deprecated behavior and the client=
 must not
>
> is a -> is

Ack.

>
> > +      rely on it. The ``V4L2_BUF_FLAG_LAST`` buffer flag should be use=
d
> > +      instead.
>
> Question: should new codec drivers still implement the EOS event?
>

Good question. It's a userspace compatibility issue, so if we intend a
new codec driver to work with old userspace, it must do so. Perhaps up
to the driver author/maintainer?

> > +
> > +3. Once all ``OUTPUT`` buffers queued before the ``V4L2_ENC_CMD_STOP``=
 call and
> > +   the last ``CAPTURE`` buffer are dequeued, the encoder is stopped an=
d it will
> > +   accept, but not process any newly queued ``OUTPUT`` buffers until t=
he client
> > +   issues any of the following operations:
> > +
> > +   * ``V4L2_ENC_CMD_START`` - the encoder will resume operation normal=
ly,
>
> Perhaps mention that this does not reset the encoder? It's not immediatel=
y clear
> when reading this.
>

Ack.

> > +
> > +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON=
` on the
> > +     ``CAPTURE`` queue - the encoder will be reset (see the `Reset` se=
quence)
> > +     and then resume encoding,
> > +
> > +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON=
` on the
> > +     ``OUTPUT`` queue - the encoder will resume operation normally, ho=
wever any
> > +     source frames queued to the ``OUTPUT`` queue between ``V4L2_ENC_C=
MD_STOP``
> > +     and :c:func:`VIDIOC_STREAMOFF` will be discarded.
> > +
> > +.. note::
> > +
> > +   Once the drain sequence is initiated, the client needs to drive it =
to
> > +   completion, as described by the steps above, unless it aborts the p=
rocess by
> > +   issuing :c:func:`VIDIOC_STREAMOFF` on any of the ``OUTPUT`` or ``CA=
PTURE``
> > +   queues.  The client is not allowed to issue ``V4L2_ENC_CMD_START`` =
or
> > +   ``V4L2_ENC_CMD_STOP`` again while the drain sequence is in progress=
 and they
> > +   will fail with -EBUSY error code if attempted.
> > +
> > +   Although mandatory, the availability of encoder commands may be que=
ried
> > +   using :c:func:`VIDIOC_TRY_ENCODER_CMD`.
> > +
> > +Reset
> > +=3D=3D=3D=3D=3D
> > +
> > +The client may want to request the encoder to reinitialize the encodin=
g, so
> > +that the following stream data becomes independent from the stream dat=
a
> > +generated before. Depending on the coded format, that may imply that,
>
> that, -> that:
>

Ack. (And also few other places.)

> > +
> > +* encoded frames produced after the restart must not reference any fra=
mes
> > +  produced before the stop, e.g. no long term references for H.264,
> > +
> > +* any headers that must be included in a standalone stream must be pro=
duced
> > +  again, e.g. SPS and PPS for H.264.
> > +
> > +This can be achieved by performing the reset sequence.
> > +
> > +1. Perform the `Drain` sequence to ensure all the in-flight encoding f=
inishes
> > +   and respective buffers are dequeued.
> > +
> > +2. Stop streaming on the ``CAPTURE`` queue via :c:func:`VIDIOC_STREAMO=
FF`. This
> > +   will return all currently queued ``CAPTURE`` buffers to the client,=
 without
> > +   valid frame data.
> > +
> > +3. Start streaming on the ``CAPTURE`` queue via :c:func:`VIDIOC_STREAM=
ON` and
> > +   continue with regular encoding sequence. The encoded frames produce=
d into
> > +   ``CAPTURE`` buffers from now on will contain a standalone stream th=
at can be
> > +   decoded without the need for frames encoded before the reset sequen=
ce,
> > +   starting at the first ``OUTPUT`` buffer queued after issuing the
> > +   `V4L2_ENC_CMD_STOP` of the `Drain` sequence.
> > +
> > +This sequence may be also used to change encoding parameters for encod=
ers
> > +without the ability to change the parameters on the fly.
> > +
> > +Commit points
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Setting formats and allocating buffers triggers changes in the behavio=
r of the
> > +encoder.
> > +
> > +1. Setting the format on the ``CAPTURE`` queue may change the set of f=
ormats
> > +   supported/advertised on the ``OUTPUT`` queue. In particular, it als=
o means
> > +   that the ``OUTPUT`` format may be reset and the client must not rel=
y on the
> > +   previously set format being preserved.
> > +
> > +2. Enumerating formats on the ``OUTPUT`` queue always returns only for=
mats
> > +   supported for the current ``CAPTURE`` format.
> > +
> > +3. Setting the format on the ``OUTPUT`` queue does not change the list=
 of
> > +   formats available on the ``CAPTURE`` queue. An attempt to set the `=
`OUTPUT``
> > +   format that is not supported for the currently selected ``CAPTURE``=
 format
> > +   will result in the encoder adjusting the requested ``OUTPUT`` forma=
t to a
> > +   supported one.
> > +
> > +4. Enumerating formats on the ``CAPTURE`` queue always returns the ful=
l set of
> > +   supported coded formats, irrespectively of the current ``OUTPUT`` f=
ormat.
> > +
> > +5. While buffers are allocated on the ``CAPTURE`` queue, the client mu=
st not
> > +   change the format on the queue. Drivers will return the -EBUSY erro=
r code
> > +   for any such format change attempt.
> > +
> > +To summarize, setting formats and allocation must always start with th=
e
> > +``CAPTURE`` queue and the ``CAPTURE`` queue is the master that governs=
 the
> > +set of supported formats for the ``OUTPUT`` queue.
> > diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/m=
edia/uapi/v4l/devices.rst
> > index 12d43fe711cf..1822c66c2154 100644
> > --- a/Documentation/media/uapi/v4l/devices.rst
> > +++ b/Documentation/media/uapi/v4l/devices.rst
> > @@ -16,6 +16,7 @@ Interfaces
> >      dev-osd
> >      dev-codec
> >      dev-decoder
> > +    dev-encoder
> >      dev-effect
> >      dev-raw-vbi
> >      dev-sliced-vbi
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentati=
on/media/uapi/v4l/pixfmt-v4l2.rst
> > index ca5f2270a829..085089cd9577 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
> > @@ -37,6 +37,11 @@ Single-planar format structure
> >       inside the stream, when fed to a stateful mem2mem decoder, the fi=
elds
> >       may be zero to rely on the decoder to detect the right values. Fo=
r more
> >       details see :ref:`decoder` and format descriptions.
> > +
> > +     For compressed formats on the CAPTURE side of a stateful mem2mem
> > +     encoder, the fields must be zero, since the coded size is expecte=
d to
> > +     be calculated internally by the encoder itself, based on the OUTP=
UT
> > +     side. For more details see :ref:`encoder` and format descriptions=
.
>
> The encoder document doesn't actually mention this. I think it should, th=
ough.

Indeed. I'll make it say that the fields are "ignored (always zero)".

To be honest, I wanted to define them in a way that they would be
hardwired to the internal coded size selected by the driver, but it
just complicated things, since one would need to set the CAPTURE
format first, then the OUTPUT format, selection rectangles and only
then could read back the coded resolution from the CAPTURE format. It
would have also violated the assumption that CAPTURE format was not
expected to be altered by changing OUTPUT format.

>
> I'm a bit uncertain about this: the expected resolution might impact the
> sizeimage value: i.e. encoding 640x480 requires much less memory then
> encoding 4k video. If this is required to be 0x0, then the driver has to
> fill in a worst-case sizeimage value. It might make more sense to say tha=
t
> if a non-zero resolution is given, then the driver will attempt to
> calculate a sensible sizeimage value.

The driver would still be able to determine the sizeimage by the
internally known coded size, which it calculated based on OUTPUT
format, selection, codec constraints, etc. It's not something for the
userspace to provide (nor it would be able to provide).

Best regards,
Tomasz
