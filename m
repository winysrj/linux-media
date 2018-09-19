Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35193 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbeISPzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 11:55:13 -0400
Received: by mail-yw1-f66.google.com with SMTP id 14-v6so2048382ywe.2
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 03:18:00 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id u191-v6sm1983699ywc.0.2018.09.19.03.17.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Sep 2018 03:17:57 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id 184-v6so2145521ybg.1
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 03:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl> <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
In-Reply-To: <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 19 Sep 2018 19:17:44 +0900
Message-ID: <CAAFQd5Ba+8_wpCr2D2OUSRt-PbRUPk4MV1OxMzEetntL169fBA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
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

Hi Hans,

On Thu, Jul 26, 2018 at 7:20 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> Hi Hans,
>
> On Wed, Jul 25, 2018 at 8:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > Hi Tomasz,
> >
> > Many, many thanks for working on this! It's a great document and when d=
one
> > it will be very useful indeed.
> >
> > Review comments follow...
>
> Thanks for review!
>
> >
> > On 24/07/18 16:06, Tomasz Figa wrote:
[snip]
> > > +13. Allocate destination (raw format) buffers via :c:func:`VIDIOC_RE=
QBUFS`
> > > +    on the ``CAPTURE`` queue.
> > > +
> > > +    * **Required fields:**
> > > +
> > > +      ``count``
> > > +          requested number of buffers to allocate; greater than zero
> > > +
> > > +      ``type``
> > > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > > +
> > > +      ``memory``
> > > +          follows standard semantics
> > > +
> > > +    * **Return fields:**
> > > +
> > > +      ``count``
> > > +          adjusted to allocated number of buffers
> > > +
> > > +    * The driver must adjust count to minimum of required number of
> > > +      destination buffers for given format and stream configuration =
and the
> > > +      count passed. The client must check this value after the ioctl
> > > +      returns to get the number of buffers allocated.
> > > +
> > > +    .. note::
> > > +
> > > +       To allocate more than minimum number of buffers (for pipeline
> > > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``) to
> > > +       get minimum number of buffers required, and pass the obtained=
 value
> > > +       plus the number of additional buffers needed in count to
> > > +       :c:func:`VIDIOC_REQBUFS`.
> >
> >
> > I think we should mention here the option of using VIDIOC_CREATE_BUFS i=
n order
> > to allocate buffers larger than the current CAPTURE format in order to =
accommodate
> > future resolution changes.
>
> Ack.
>

I'm about to add a paragraph to describe this, but there is one detail
to iron out.

The VIDIOC_CREATE_BUFS ioctl accepts a v4l2_format struct. Userspace
needs to fill in this struct and the specs says that

  "Usually this will be done using the VIDIOC_TRY_FMT or VIDIOC_G_FMT
ioctls to ensure that the requested format is supported by the
driver."

However, in case of a decoder, those calls would fixup the format to
match the currently parsed stream, which would likely resolve to the
current coded resolution (~hardware alignment). How do we get a format
for the desired maximum resolution?

[snip].
> > > +
> > > +     * The driver is also allowed to and may not return all decoded =
frames
[snip]
> > > +       queued but not decode before the seek sequence was initiated.=
 For
> >
> > Very confusing sentence. I think you mean this:
> >
> >           The driver may not return all decoded frames that where ready=
 for
> >           dequeueing from before the seek sequence was initiated.
> >
> > Is this really true? Once decoded frames are marked as buffer_done by t=
he
> > driver there is no reason for them to be removed. Or you mean something=
 else
> > here, e.g. the frames are decoded, but the buffers not yet given back t=
o vb2.
> >
>
> Exactly "the frames are decoded, but the buffers not yet given back to
> vb2", for example, if reordering takes place. However, if one stops
> streaming before dequeuing all buffers, they are implicitly returned
> (reset to the state after REQBUFS) and can't be dequeued anymore, so
> the frames are lost, even if the driver returned them. I guess the
> sentence was really unfortunate indeed.
>

Actually, that's not the only case.

The documentation is written from userspace point of view. Queuing an
OUTPUT buffer is not equivalent to having it decoded (and a CAPTURE
buffer given back to vb2). If the userspace queues a buffer and then
stops streaming, the buffer might have been still waiting in the
queue, for decoding of previous buffers to finish.

So basically by "queued frames" I meant "OUTPUT buffers queued by
userspace and not sent to the hardware yet" and by "decoded frames" I
meant "CAPTURE buffers containing matching frames given back to vb2".

How about rewording like this:

     * The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
       ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` buffe=
rs
       queued before the seek may have matching ``CAPTURE`` buffers produce=
d.
       For example, [...]

> > > +       example, given an ``OUTPUT`` queue sequence: QBUF(A), QBUF(B)=
,
> > > +       STREAMOFF(OUT), STREAMON(OUT), QBUF(G), QBUF(H), any of the
> > > +       following results on the ``CAPTURE`` queue is allowed: {A=E2=
=80=99, B=E2=80=99, G=E2=80=99,
> > > +       H=E2=80=99}, {A=E2=80=99, G=E2=80=99, H=E2=80=99}, {G=E2=80=
=99, H=E2=80=99}.
> > > +
> > > +   .. note::
> > > +
> > > +      To achieve instantaneous seek, the client may restart streamin=
g on
> > > +      ``CAPTURE`` queue to discard decoded, but not yet dequeued buf=
fers.

Best regards,
Tomasz
