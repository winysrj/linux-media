Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:45787 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbeHGIUg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 04:20:36 -0400
Received: by mail-yb0-f194.google.com with SMTP id h127-v6so6202959ybg.12
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 23:07:53 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id w143-v6sm626990yww.49.2018.08.06.23.07.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Aug 2018 23:07:50 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id s68-v6so1506303ywg.2
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 23:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-3-tfiga@chromium.org>
 <1532526073.4879.6.camel@pengutronix.de>
In-Reply-To: <1532526073.4879.6.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 7 Aug 2018 15:07:38 +0900
Message-ID: <CAAFQd5D1ciXvfngmJfsNee+8VCb8jjOtjgL9XyVV8qDY+9fhuQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Wed, Jul 25, 2018 at 10:41 PM Philipp Zabel <p.zabel@pengutronix.de> wro=
te:
>
> On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
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
>
> Thanks a lot for the update,

Thanks for review!

> > ---
> >  Documentation/media/uapi/v4l/dev-encoder.rst | 550 +++++++++++++++++++
> >  Documentation/media/uapi/v4l/devices.rst     |   1 +
> >  Documentation/media/uapi/v4l/v4l2.rst        |   2 +
> >  3 files changed, 553 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst b/Documentati=
on/media/uapi/v4l/dev-encoder.rst
> > new file mode 100644
> > index 000000000000..28be1698e99c
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/dev-encoder.rst
> > @@ -0,0 +1,550 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _encoder:
> > +
> > +****************************************
> > +Memory-to-memory Video Encoder Interface
> > +****************************************
> > +
> > +Input data to a video encoder are raw video frames in display order
> > +to be encoded into the output bitstream. Output data are complete chun=
ks of
> > +valid bitstream, including all metadata, headers, etc. The resulting s=
tream
> > +must not need any further post-processing by the client.
> > +
> > +Performing software stream processing, header generation etc. in the d=
river
> > +in order to support this interface is strongly discouraged. In case su=
ch
> > +operations are needed, use of Stateless Video Encoder Interface (in
> > +development) is strongly advised.
> > +
> [...]
> > +
> > +Commit points
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Setting formats and allocating buffers triggers changes in the behavio=
r
> > +of the driver.
> > +
> > +1. Setting format on ``CAPTURE`` queue may change the set of formats
> > +   supported/advertised on the ``OUTPUT`` queue. In particular, it als=
o
> > +   means that ``OUTPUT`` format may be reset and the client must not
> > +   rely on the previously set format being preserved.
>
> Since the only property of the CAPTURE format that can be set directly
> via S_FMT is the pixelformat, should this be made explicit?
>
> 1. Setting pixelformat on ``CAPTURE`` queue may change the set of
>    formats supported/advertised on the ``OUTPUT`` queue. In particular,
>    it also means that ``OUTPUT`` format may be reset and the client
>    must not rely on the previously set format being preserved.
>
> ?
>
> > +2. Enumerating formats on ``OUTPUT`` queue must only return formats
> > +   supported for the ``CAPTURE`` format currently set.
>
> Same here, as it usually is the codec selected by CAPTURE pixelformat
> that determines the supported OUTPUT pixelformats and resolutions.
>
> 2. Enumerating formats on ``OUTPUT`` queue must only return formats
>    supported for the ``CAPTURE`` pixelformat currently set.
>
> This could prevent the possible misconception that the CAPTURE
> width/height might in any form limit the OUTPUT format, when in fact it
> is determined by it.
>
> > +3. Setting/changing format on ``OUTPUT`` queue does not change formats
> > +   available on ``CAPTURE`` queue.
>
> 3. Setting/changing format on the ``OUTPUT`` queue does not change
>    pixelformats available on the ``CAPTURE`` queue.
>
> ?
>
> Because setting OUTPUT width/height or CROP SELECTION very much limits
> the possible values of CAPTURE width/height.
>
> Maybe 'available' in this context should be specified somewhere to mean
> 'returned by ENUM_FMT and allowed by S_FMT/TRY_FMT'.
>
> > +   An attempt to set ``OUTPUT`` format that
> > +   is not supported for the currently selected ``CAPTURE`` format must
> > +   result in the driver adjusting the requested format to an acceptabl=
e
> > +   one.
>
>    An attempt to set ``OUTPUT`` format that is not supported for the
>
> currently selected ``CAPTURE`` pixelformat must result in the driver
>
> adjusting the requested format to an acceptable one.
>
> > +4. Enumerating formats on ``CAPTURE`` queue always returns the full se=
t of
> > +   supported coded formats, irrespective of the current ``OUTPUT``
> > +   format.
> > +
> > +5. After allocating buffers on the ``CAPTURE`` queue, it is not possib=
le to
> > +   change format on it.
> > +
> > +To summarize, setting formats and allocation must always start with th=
e
> > +``CAPTURE`` queue and the ``CAPTURE`` queue is the master that governs=
 the
> > +set of supported formats for the ``OUTPUT`` queue.
>
> To summarize, setting formats and allocation must always start with
> setting the encoded pixelformat on the ``CAPTURE`` queue. The
> ``CAPTURE`` queue is the master that governs the set of supported
> formats for the ``OUTPUT`` queue.
>
> Or is this too verbose?

I'm personally okay with making this "pixel format" specifically, but
I thought we wanted to extend this later to other things, such as
colorimetry. Would it introduce any problems if we keep it more
general?

To avoid any ambiguities, we could add a table that lists all the
state accessible by user space, which would clearly mark CAPTURE
width/height as fixed by the driver.

Best regards,
Tomasz
