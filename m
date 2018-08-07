Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34771 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388573AbeHGJVx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 05:21:53 -0400
Received: by mail-yw1-f66.google.com with SMTP id j68-v6so4562014ywg.1
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 00:08:57 -0700 (PDT)
Received: from mail-yb0-f171.google.com (mail-yb0-f171.google.com. [209.85.213.171])
        by smtp.gmail.com with ESMTPSA id o2-v6sm289647ywb.18.2018.08.07.00.08.56
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 00:08:56 -0700 (PDT)
Received: by mail-yb0-f171.google.com with SMTP id d18-v6so2335080ybq.5
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 00:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <318f609c-7a28-ef65-e8be-08107981b623@xs4all.nl>
In-Reply-To: <318f609c-7a28-ef65-e8be-08107981b623@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 7 Aug 2018 16:08:44 +0900
Message-ID: <CAAFQd5DoXgMGU2wekJMM39NGkwSQqbQVbQ=XmM_pxqGEYKK9gA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>, nicolas@ndufresne.ca
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 30, 2018 at 9:52 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 07/24/2018 04:06 PM, Tomasz Figa wrote:
> > Due to complexity of the video decoding process, the V4L2 drivers of
> > stateful decoder hardware require specific sequences of V4L2 API calls
> > to be followed. These include capability enumeration, initialization,
> > decoding, seek, pause, dynamic resolution change, drain and end of
> > stream.
> >
> > Specifics of the above have been discussed during Media Workshops at
> > LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API that
> > originated at those events was later implemented by the drivers we alre=
ady
> > have merged in mainline, such as s5p-mfc or coda.
> >
> > The only thing missing was the real specification included as a part of
> > Linux Media documentation. Fix it now and document the decoder part of
> > the Codec API.
> >
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > ---
> >  Documentation/media/uapi/v4l/dev-decoder.rst | 872 +++++++++++++++++++
> >  Documentation/media/uapi/v4l/devices.rst     |   1 +
> >  Documentation/media/uapi/v4l/v4l2.rst        |  10 +-
> >  3 files changed, 882 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentati=
on/media/uapi/v4l/dev-decoder.rst
> > new file mode 100644
> > index 000000000000..f55d34d2f860
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
> > @@ -0,0 +1,872 @@
>
> <snip>
>
> > +6.  This step only applies to coded formats that contain resolution
> > +    information in the stream. Continue queuing/dequeuing bitstream
> > +    buffers to/from the ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and
> > +    :c:func:`VIDIOC_DQBUF`. The driver must keep processing and return=
ing
> > +    each buffer to the client until required metadata to configure the
> > +    ``CAPTURE`` queue are found. This is indicated by the driver sendi=
ng
> > +    a ``V4L2_EVENT_SOURCE_CHANGE`` event with
> > +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type. There is no
> > +    requirement to pass enough data for this to occur in the first buf=
fer
> > +    and the driver must be able to process any number.
> > +
> > +    * If data in a buffer that triggers the event is required to decod=
e
> > +      the first frame, the driver must not return it to the client,
> > +      but must retain it for further decoding.
> > +
> > +    * If the client set width and height of ``OUTPUT`` format to 0, ca=
lling
> > +      :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue will return -EPE=
RM,
> > +      until the driver configures ``CAPTURE`` format according to stre=
am
> > +      metadata.
>
> What about calling TRY/S_FMT on the capture queue: will this also return =
-EPERM?
> I assume so.

We should make it so indeed, to make things consistent.

On another note, I don't really like this -EPERM here, as one could
just see that the format is 0x0 and know that it's not valid. This is
only needed for legacy userspace that doesn't handle the source change
event in initial stream parsing and just checks whether G_FMT returns
an error instead.

Nicolas, for more insight here.

Best regards,
Tomasz
