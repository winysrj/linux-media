Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45749 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbeHHFEO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 01:04:14 -0400
Received: by mail-yw1-f68.google.com with SMTP id 139-v6so499394ywg.12
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 19:46:52 -0700 (PDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id b135-v6sm3424744ywh.24.2018.08.07.19.46.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 19:46:50 -0700 (PDT)
Received: by mail-yw1-f52.google.com with SMTP id j68-v6so526408ywg.1
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 19:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
In-Reply-To: <20180724140621.59624-2-tfiga@chromium.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 8 Aug 2018 11:46:38 +0900
Message-ID: <CAAFQd5Ays_3EEDNDrNn2JFzVA7f7+hOzxFNBdYYKMw+uHZvqog@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
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
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Tue, Aug 7, 2018 at 5:32 AM Maxime Jourdan <maxi.jourdan@wanadoo.fr> wro=
te:
>
> Hi Tomasz,
>
> Sorry for sending this email only to you, I subscribed to linux-media
> after you posted this and I'm not sure how to respond to everybody.
>

No worries. Let me reply with other recipients added back. Thanks for
your comments.

> I'm currently developing a V4L2 M2M decoder driver for Amlogic SoCs so
> my comments are somewhat biased towards it
> (https://github.com/Elyotna/linux)
>
> > +Seek
> > +=3D=3D=3D=3D
> > +
> > +Seek is controlled by the ``OUTPUT`` queue, as it is the source of
> > +bitstream data. ``CAPTURE`` queue remains unchanged/unaffected.
> > +
> > +1. Stop the ``OUTPUT`` queue to begin the seek sequence via
> > +   :c:func:`VIDIOC_STREAMOFF`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +   * The driver must drop all the pending ``OUTPUT`` buffers and they =
are
> > +     treated as returned to the client (following standard semantics).
> > +
> > +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +   * The driver must be put in a state after seek and be ready to
> > +     accept new source bitstream buffers.
> > +
> > +3. Start queuing buffers to ``OUTPUT`` queue containing stream data af=
ter
> > +   the seek until a suitable resume point is found.
> > +
> > +   .. note::
> > +
> > +      There is no requirement to begin queuing stream starting exactly=
 from
> > +      a resume point (e.g. SPS or a keyframe). The driver must handle =
any
> > +      data queued and must keep processing the queued buffers until it
> > +      finds a suitable resume point. While looking for a resume point,=
 the
> > +      driver processes ``OUTPUT`` buffers and returns them to the clie=
nt
> > +      without producing any decoded frames.
> > +
> > +      For hardware known to be mishandling seeks to a non-resume point=
,
> > +      e.g. by returning corrupted decoded frames, the driver must be a=
ble
> > +      to handle such seeks without a crash or any fatal decode error.
>
> This is unfortunately my case, apart from parsing the bitstream
> manually - which is a no-no -, there is no way to know when I'll be
> writing in an IDR frame to the HW bitstream parser. I think it would
> be much preferable that the client starts sending in an IDR frame for
> sure.

Most of the hardware, which have upstream drivers, deal with this
correctly and there is existing user space that relies on this, so we
cannot simply add such requirement. However, when sending your driver
upstream, feel free to include a patch that adds a read-only control
that tells the user space that it needs to do seeks to resume points.
Obviously this will work only with user space aware of this
requirement, but I don't think we can do anything better here.

>
> > +4. After a resume point is found, the driver will start returning
> > +   ``CAPTURE`` buffers with decoded frames.
> > +
> > +   * There is no precise specification for ``CAPTURE`` queue of when i=
t
> > +     will start producing buffers containing decoded data from buffers
> > +     queued after the seek, as it operates independently
> > +     from ``OUTPUT`` queue.
> > +
> > +     * The driver is allowed to and may return a number of remaining
> > +       ``CAPTURE`` buffers containing decoded frames from before the s=
eek
> > +       after the seek sequence (STREAMOFF-STREAMON) is performed.
> > +
> > +     * The driver is also allowed to and may not return all decoded fr=
ames
> > +       queued but not decode before the seek sequence was initiated. F=
or
> > +       example, given an ``OUTPUT`` queue sequence: QBUF(A), QBUF(B),
> > +       STREAMOFF(OUT), STREAMON(OUT), QBUF(G), QBUF(H), any of the
> > +       following results on the ``CAPTURE`` queue is allowed: {A=E2=80=
=99, B=E2=80=99, G=E2=80=99,
> > +       H=E2=80=99}, {A=E2=80=99, G=E2=80=99, H=E2=80=99}, {G=E2=80=99,=
 H=E2=80=99}.
> > +
> > +   .. note::
> > +
> > +      To achieve instantaneous seek, the client may restart streaming =
on
> > +      ``CAPTURE`` queue to discard decoded, but not yet dequeued buffe=
rs.
>
> Overall, I think Drain followed by V4L2_DEC_CMD_START is a more
> applicable scenario for seeking.
> Heck, simply starting to queue buffers at the seek - starting with an
> IDR - without doing any kind of streamon/off or cmd_start(stop) will
> do the trick.

Why do you think so?

For a seek, as expected by a typical device user, the result should be
discarding anything already queued and just start decoding new frames
as soon as possible.

Actually, this section doesn't describe any specific sequence, just
possible ways to do a seek using existing primitives.

Best regards,
Tomasz
