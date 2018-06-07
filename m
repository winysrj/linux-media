Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:42724 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbeFGH2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 03:28:00 -0400
Received: by mail-vk0-f68.google.com with SMTP id s187-v6so5423795vke.9
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 00:28:00 -0700 (PDT)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com. [209.85.213.54])
        by smtp.gmail.com with ESMTPSA id d189-v6sm5933285vka.3.2018.06.07.00.27.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Jun 2018 00:27:58 -0700 (PDT)
Received: by mail-vk0-f54.google.com with SMTP id x4-v6so5420875vkx.11
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 00:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-2-tfiga@chromium.org>
 <1528198888.4074.13.camel@pengutronix.de> <CAAFQd5BKdqPWVREeuprWS43kPz7XZR5buiPUZY5UKhaaQCMOBg@mail.gmail.com>
 <1528281896.3438.6.camel@pengutronix.de>
In-Reply-To: <1528281896.3438.6.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 7 Jun 2018 16:27:46 +0900
Message-ID: <CAAFQd5Bk2VVdPW2C9erQ-vgWDV5ySZH+WeWGyqtrzNug2F1SuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 6, 2018 at 7:45 PM Philipp Zabel <p.zabel@pengutronix.de> wrote=
:
>
> On Tue, 2018-06-05 at 22:42 +0900, Tomasz Figa wrote:
> [...]
> > > > +   a. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for co=
ded formats
> > > > +      must be maximums for given coded format for all supported ra=
w
> > > > +      formats.
> > >
> > > I don't understand what maximums means in this context.
> > >
> > > If I have a decoder that can decode from 16x16 up to 1920x1088, shoul=
d
> > > this return a continuous range from minimum frame size to maximum fra=
me
> > > size?
> >
> > Looks like the wording here is a bit off. It should be as you say +/-
> > alignment requirements, which can be specified by using
> > v4l2_frmsize_stepwise. Hardware that supports only a fixed set of
> > resolutions (if such exists), should use v4l2_frmsize_discrete.
> > Basically this should follow the standard description of
> > VIDIOC_ENUM_FRAMESIZES.
>
> Should this contain coded sizes or visible sizes?

Since it relates to the format of the queue and we are considering
setting coded size there for formats/hardware for which it can't be
obtained from the stream, I'd say this one should be coded as well.
This is also how we interpret them in Chromium video stack.

>
> > >
> > > > +   b. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for ra=
w formats must
> > > > +      be maximums for given raw format for all supported coded
> > > > +      formats.
> > >
> > > Same here, this is unclear to me.
> >
> > Should be as above, i.e. according to standard operation of
> > VIDIOC_ENUM_FRAMESIZES.
>
> How about just:
>
>    a. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for coded for=
mats
>       must contain all possible (coded?) frame sizes for the given coded =
format
>       for all supported raw formats.

I wouldn't mention raw formats here, since what's supported will
actually depend on coded format.

>
>    b. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for raw forma=
ts
>       must contain all possible coded frame sizes for the given raw forma=
t
>       for all supported encoded formats.

I'd say that this should be "for currently set coded format", because
otherwise userspace would have no way to find the real supported range
for the codec it wants to decode.

>
> And then a note somewhere that explains that coded frame sizes are
> usually visible frame size rounded up to macro block size, possibly a
> link to the coded resolution glossary.

Agreed on the note.

I'm not yet sure about the link, because it might just clutter the
source text. I think the reader would be looking through the document
from the top anyway, so should be able to notice the glossary and
scroll back to it, if necessary.

>
> [...]
> > Actually, when I think of it now, I wonder if we really should be
> > setting resolution here for bitstream formats that don't include
> > resolution, rather than on CAPTURE queue. Pawel, could you clarify
> > what was the intention here?
>
> Setting the resolution here makes it possible to start streaming,
> allocate buffers on both queues etc. without relying on the hardware to
> actually parse the headers. If we are given the right information, the
> first source change event will just confirm the currently set
> resolution.

I think the same could be achievable by userspace setting the format
on CAPTURE, rather than OUTPUT.

However, I guess it just depends on the convention we agree on. If we
decide that coded formats are characterized by width/height that
represent coded size, I guess we might just set it on OUTPUT and make
the format on CAPTURE read-only (unless the hardware supports some
kind of transformations). If we decide so, then we would also have to:
 - update OUTPUT format on initial bitstream parse and dynamic
resolution change,
 - for encoder, make CAPTURE format correspond to coded size of
encoded bitstream.

It sounds quite reasonable to me and it might not even conflict (too
much) with what existing drivers and userspace do.

>
> [...]
> > > What about devices that have a frame buffer registration step before
> > > stream start? For coda I need to know all CAPTURE buffers before I ca=
n
> > > start streaming, because there is no way to register them after
> > > STREAMON. Do I have to split the driver internally to do streamoff an=
d
> > > restart when the capture queue is brought up?
> >
> > Do you mean that the hardware requires registering framebuffers before
> > the headers are parsed and resolution is detected? That sounds quite
> > unusual.
>
> I meant that, but I was mistaken. For coda that is just how the driver
> currently works, but it is not required by the hardware.
>
> > Other drivers would:
> > 1) parse the header on STREAMON(OUTPUT),
>
> coda has a SEQ_INIT command, which parses the headers, and a
> SET_FRAME_BUF command that registers allocated (internal) buffers.
> Both are currently done during streamon, but it should be possible to
> split this up. SET_FRAME_BUF can be only issued once between SEQ_INIT
> and SEQ_END, but it is a separate command.
>
> > 2) report resolution to userspace,
> > 3) have framebuffers allocated in REQBUFS(CAPTURE),
> > 4) register framebuffers in STREAMON(CAPTURE).
>
> coda has a peculiarity in that the registered frame buffers are internal
> only, and another part of the codec (copy/rotator) or another part of
> the SoC (VDOA) copies those frames into the CAPTURE buffers that don't
> have to be registered at all in advance in a separate step. But it
> should still be possible to do the internal buffer allocation and
> registration in the right places.

Out of curiosity, why is that? Couldn't the internal frame buffers be
just directly exposed to userspace with the agreement that userspace
doesn't write to them, as s5p-mfc does? Actually, s5p-mfc hw seems to
include a similar mode that includes a copy/rotate step, but it only
imposes higher bandwidth requirements.

>
> [...]
> > Should be the same. There was "+5. Single-plane API (see spec) and
> > applicable structures may be used interchangeably with Multi-plane
> > API, unless specified otherwise." mentioned at the beginning of the
> > documentation, but I guess we could just make the description generic
> > instead.
>
> Yes, please. Especially when using this as a reference during driver
> development, it would be very helpful to have all relevant information
> in place or at least referenced, instead of having to read and memorize
> the whole document linearly.

Ack.

>
> [...]
> > > Isn't CROP supposed to be set on the OUTPUT queue only and COMPOSE on
> > > the CAPTURE queue?
> >
> > Why? Both CROP and COMPOSE can be used on any queue, if supported by
> > given interface.
> >
> > However, on codecs, since OUTPUT queue is a bitstream, I don't think
> > selection makes sense there.
> >
> > > I would expect COMPOSE/COMPOSE_DEFAULT to be set to the visible
> > > rectangle and COMPOSE_PADDED to be set to the rectangle that the
> > > hardware actually overwrites.
> >
> > Yes, that's a good point. I'd also say that CROP/CROP_DEFAULT should
> > be set to the visible rectangle as well, to allow adding handling for
> > cases when the hardware can actually do further cropping.
>
> Should CROP_BOUNDS be set to visible rectangle or to the coded
> rectangle? This is related the question to whether coded G/S_FMT should
> handle coded sizes or visible sizes.

I'd say that the format on CAPTURE should represent framebuffer size,
which might be hardware specific and not necessarily equal to coded
size. This would also enable allocating bigger framebuffers beforehand
to avoid reallocation for resolution changes.

If we want to make selection consistent with CAPTURE format, we should
probably have CROP_BOUNDS equal to framebuffer resolution. I'm not
sure how it would work for hardware that can't do any transformations,
e.g. those where CROP =3D=3D CROP_DEFAULT =3D=3D COMPOSE =3D=3D COMPOSE_DEF=
AULT =3D=3D
visible size. I couldn't find in the spec whether it is allowed for
CROP_BOUNDS to report a rectangle unsupported by CROP.

>
> For video capture devices, the cropping bounds should represent those
> pixels that can be sampled. If we can 'sample' the coded pixels beyond
> the visible rectangle, should decoders behave the same?
>
> I think Documentation/media/uapi/v4l/selection-api-004.rst is missing a
> section about mem2mem devices and/or codecs to clarify this.

Ack. I guess we should add something there.

[snip]
> > >
> > > > +subsequent :c:func:`VIDIOC_STREAMON` will look for and only contin=
ue from a
> > > > +resume point. This is usually undesirable for pause. The
> > > > +STREAMOFF-STREAMON sequence is intended for seeking.
> > > > +
> > > > +Similarly, CAPTURE queue should remain streaming as well, as the
> > > > +STREAMOFF-STREAMON sequence on it is intended solely for changing =
buffer
> > > > +sets
> > > > +
> > > > +Dynamic resolution change
> > > > +-------------------------
> > > > +
> > > > +When driver encounters a resolution change in the stream, the dyna=
mic
> > > > +resolution change sequence is started.
> > >
> > > Must all drivers support dynamic resolution change?
> >
> > I'd say no, but I guess that would mean that the driver never
> > encounters it, because hardware wouldn't report it.
> >
> > I wonder would happen in such case, though. Obviously decoding of such
> > stream couldn't continue without support in the driver.
>
> GStreamer supports decoding of variable resolution streams without
> driver support by just stopping and restarting streaming completely.

What about userspace that doesn't parse the stream on its own? Do we
want to impose the requirement of full bitstream parsing even for
hardware that can just do it itself?

>
> > >
> > > > +1.  On encountering a resolution change in the stream. The driver =
must
> > > > +    first process and decode all remaining buffers from before the
> > > > +    resolution change point.
> > > > +
> > > > +2.  After all buffers containing decoded frames from before the
> > > > +    resolution change point are ready to be dequeued on the
> > > > +    CAPTURE queue, the driver sends a ``V4L2_EVENT_SOURCE_CHANGE``
> > > > +    event for source change type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > > > +    The last buffer from before the change must be marked with
> > > > +    :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as=
 in the flush
> > > > +    sequence.
> > > > +
> > > > +    .. note::
> > > > +
> > > > +       Any attempts to dequeue more buffers beyond the buffer mark=
ed
> > > > +       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error f=
rom
> > > > +       :c:func:`VIDIOC_DQBUF`.
> > > > +
> > > > +3.  After dequeuing all remaining buffers from the CAPTURE queue, =
the
> > > > +    client must call :c:func:`VIDIOC_STREAMOFF` on the CAPTURE que=
ue. The
> > > > +    OUTPUT queue remains streaming (calling STREAMOFF on it would
> > > > +    trigger a seek).
> > > > +    Until STREAMOFF is called on the CAPTURE queue (acknowledging
> > > > +    the event), the driver operates as if the resolution hasn=E2=
=80=99t
> > > > +    changed yet, i.e. :c:func:`VIDIOC_G_FMT`, etc. return previous
> > > > +    resolution.
> > >
> > > What about the OUTPUT queue resolution, does it change as well?
> >
> > There shouldn't be resolution associated with OUTPUT queue, because
> > pixel format is bitstream, not raw frame.
>
> So the width and height field may just contain bogus values for coded
> formats?

This is probably as per the convention we agree on, as I mentioned
above. If we assume that coded formats are characterized by coded
size, then width and height would indeed have to always contain the
coded size (and it would change after dynamic resolution change).

>
> [...]
> > > Ok. Is the same true about the contained colorimetry? What should hap=
pen
> > > if the stream contains colorimetry information that differs from
> > > S_FMT(OUT) colorimetry?
> >
> > As I explained close to the top, IMHO we shouldn't be setting
> > colorimetry on OUTPUT queue.
>
> Does that mean that if userspace sets those fields though, we correct to
> V4L2_COLORSPACE_DEFAULT and friends? Or just accept anything and ignore
> it?

As I mentioned in other comments, I rethought this and we should be
okay with having colorimetry (and properties) set on OUTPUT queue.

>
> > > > +2. Enumerating formats on CAPTURE queue must only return CAPTURE f=
ormats
> > > > +   supported for the OUTPUT format currently set.
> > > > +
> > > > +3. Setting/changing format on CAPTURE queue does not change format=
s
> > > > +   available on OUTPUT queue. An attempt to set CAPTURE format tha=
t
> > > > +   is not supported for the currently selected OUTPUT format must
> > > > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
> > >
> > > Is this limited to the pixel format? Surely setting out of bounds
> > > width/height or incorrect colorimetry should not result in EINVAL but
> > > still be corrected by the driver?
> >
> > That doesn't sound right to me indeed. The driver should fix up
> > S_FMT(CAPTURE), including pixel format or anything else. It must only
> > not alter OUTPUT settings.
>
> That's what I would have expected as well.
>
> > >
> > > > +4. Enumerating formats on OUTPUT queue always returns a full set o=
f
> > > > +   supported formats, irrespective of the current format selected =
on
> > > > +   CAPTURE queue.
> > > > +
> > > > +5. After allocating buffers on the OUTPUT queue, it is not possibl=
e to
> > > > +   change format on it.
> > >
> > > So even after source change events the OUTPUT queue still keeps the
> > > initial OUTPUT format?
> >
> > It would basically only have pixelformat (fourcc) assigned to it,
> > since bitstream formats are not video frames, but just sequences of
> > bytes. I don't think it makes sense to change e.g. from H264 to VP8
> > during streaming.
>
> What should the width and height format fields be set to then? Is there
> a precedent for this? Capture devices that produce compressed output
> usually set width and height to the visible resolution.

s5p-mfc (the first upstream codec driver) always sets them to 0. That
might be fixed if we agree on a consistent convention, though.

Best regards,
Tomasz
