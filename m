Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43574 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbeJ2Szd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 14:55:33 -0400
Received: by mail-yw1-f67.google.com with SMTP id j75-v6so3099834ywj.10
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 03:07:34 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id g66-v6sm7437570ywg.22.2018.10.29.03.07.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Oct 2018 03:07:32 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id a128-v6so3096545ywg.9
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 03:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-2-tfiga@chromium.org>
 <31c175d6-b1e9-f8d7-0b8b-821271a59a70@linaro.org> <CAAFQd5CcFDqWDoRiESjVp2bw16Pm_aoOy44kVx5iYFve18jKSg@mail.gmail.com>
In-Reply-To: <CAAFQd5CcFDqWDoRiESjVp2bw16Pm_aoOy44kVx5iYFve18jKSg@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 29 Oct 2018 19:07:19 +0900
Message-ID: <CAAFQd5C6q4RsXWYpbeyBZR88bKa_roMh=DDTBN3NFKHod+Y2+g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 29, 2018 at 7:06 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> Hi Stanimir,
>
> On Mon, Oct 29, 2018 at 6:45 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
> >
> > Hi Tomasz,
> >
> > On 10/22/2018 05:48 PM, Tomasz Figa wrote:
> > > Due to complexity of the video decoding process, the V4L2 drivers of
> > > stateful decoder hardware require specific sequences of V4L2 API call=
s
> > > to be followed. These include capability enumeration, initialization,
> > > decoding, seek, pause, dynamic resolution change, drain and end of
> > > stream.
> > >
> > > Specifics of the above have been discussed during Media Workshops at
> > > LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > > Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API tha=
t
> > > originated at those events was later implemented by the drivers we al=
ready
> > > have merged in mainline, such as s5p-mfc or coda.
> > >
> > > The only thing missing was the real specification included as a part =
of
> > > Linux Media documentation. Fix it now and document the decoder part o=
f
> > > the Codec API.
> > >
> > > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > > ---
> > >  Documentation/media/uapi/v4l/dev-decoder.rst  | 1082 +++++++++++++++=
++
> > >  Documentation/media/uapi/v4l/devices.rst      |    1 +
> > >  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
> > >  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
> > >  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
> > >  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
> > >  6 files changed, 1137 insertions(+), 15 deletions(-)
> > >  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> > >
> > > diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documenta=
tion/media/uapi/v4l/dev-decoder.rst
> > > new file mode 100644
> > > index 000000000000..09c7a6621b8e
> > > --- /dev/null
> > > +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
> >
> > <cut>
> >
> > > +Capture setup
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> >
> > <cut>
> >
> > > +
> > > +2.  **Optional.** Acquire the visible resolution via
> > > +    :c:func:`VIDIOC_G_SELECTION`.
> > > +
> > > +    * **Required fields:**
> > > +
> > > +      ``type``
> > > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > > +
> > > +      ``target``
> > > +          set to ``V4L2_SEL_TGT_COMPOSE``
> > > +
> > > +    * **Return fields:**
> > > +
> > > +      ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > > +          the visible rectangle; it must fit within the frame buffer=
 resolution
> > > +          returned by :c:func:`VIDIOC_G_FMT` on ``CAPTURE``.
> > > +
> > > +    * The following selection targets are supported on ``CAPTURE``:
> > > +
> > > +      ``V4L2_SEL_TGT_CROP_BOUNDS``
> > > +          corresponds to the coded resolution of the stream
> > > +
> > > +      ``V4L2_SEL_TGT_CROP_DEFAULT``
> > > +          the rectangle covering the part of the ``CAPTURE`` buffer =
that
> > > +          contains meaningful picture data (visible area); width and=
 height
> > > +          will be equal to the visible resolution of the stream
> > > +
> > > +      ``V4L2_SEL_TGT_CROP``
> > > +          the rectangle within the coded resolution to be output to
> > > +          ``CAPTURE``; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``; re=
ad-only on
> > > +          hardware without additional compose/scaling capabilities
> >
> > Hans should correct me if I'm wrong but V4L2_SEL_TGT_CROP_xxx are
> > applicable over OUTPUT queue type?
>
> There is no such restriction. CROP selection targets of an OUTPUT
> queue apply to the video stream read from the buffers, COMPOSE targets
> of an OUTPUT queue apply to the output of the queue and input to the
> processing block (hardware) in case of mem2mem devices, then CROP
> targets of a CAPTURE queue apply to the output of the processing and
> SELECTION targets of a CAPTURE queue apply to the stream written to

I mean, COMPOSE targets. Sorry for the noise.

> the buffers.
>
> For a decoder, the OUTPUT stream is just a sequence of bytes, so
> selection API doesn't apply to it. The processing (decoding) produces
> a video stream and so the necessary selection capabilities are exposed
> on the CAPTURE queue.
>
> Best regards,
> Tomasz
