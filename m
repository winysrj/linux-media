Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:39535 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728223AbeHGJOX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 05:14:23 -0400
Received: by mail-yb0-f196.google.com with SMTP id c4-v6so6253264ybl.6
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 00:01:28 -0700 (PDT)
Received: from mail-yb0-f174.google.com (mail-yb0-f174.google.com. [209.85.213.174])
        by smtp.gmail.com with ESMTPSA id 63-v6sm343643ywd.8.2018.08.07.00.01.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 00:01:27 -0700 (PDT)
Received: by mail-yb0-f174.google.com with SMTP id n10-v6so1958614ybd.7
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 00:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-3-tfiga@chromium.org>
 <4168da98-fa01-ea2f-8162-385501e666be@xs4all.nl>
In-Reply-To: <4168da98-fa01-ea2f-8162-385501e666be@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 7 Aug 2018 15:54:00 +0900
Message-ID: <CAAFQd5BqtKFeJniNaqahi9h_zKR+rPrWUiyx004Z=MWDj7q++w@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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

Hi Hans,

On Wed, Jul 25, 2018 at 10:57 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 24/07/18 16:06, Tomasz Figa wrote:
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
>
> Due to the confusing use capture and output I wonder if it would be bette=
r to
> rephrase this as follows:
>
> "A video encoder takes raw video frames in display order and encodes them=
 into
> a bitstream. It generates complete chunks of the bitstream, including
> all metadata, headers, etc. The resulting bitstream does not require any =
further
> post-processing by the client."
>
> Something similar should be done for the decoder documentation.
>

First, thanks a lot for review!

Sounds good to me, it indeed feels much easier to read, thanks.

[snip]
> > +
> > +IDR
> > +   a type of a keyframe in H.264-encoded stream, which clears the list=
 of
> > +   earlier reference frames (DPBs)
>
> Same problem as with the previous patch: it doesn't say what IDR stands f=
or.
> It also refers to DPBs, but DPB is not part of this glossary.

Ack.

>
> Perhaps the glossary of the encoder/decoder should be combined.
>

There are some terms that have slightly different nuance between
encoder and decoder, so while it would be possible to just include
both meanings (as it was in RFC), I wonder if it wouldn't make it more
difficult to read, also given that it would move it to a separate
page. No strong opinion, though.

[snip]
> > +
> > +Initialization
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. *[optional]* Enumerate supported formats and resolutions. See
> > +   capability enumeration.
>
> capability enumeration. -> 'Querying capabilities' above.
>

Ack.

[snip]
> > +4. The client may set the raw source format on the ``OUTPUT`` queue vi=
a
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
> > +     ``num_planes`` (for _MPLANE)
> > +         set to number of planes for pixelformat
> > +
> > +     ``sizeimage``, ``bytesperline``
> > +         follow standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``width``, ``height``
> > +         may be adjusted by driver to match alignment requirements, as
> > +         required by the currently selected formats
> > +
> > +     ``sizeimage``, ``bytesperline``
> > +         follow standard semantics
> > +
> > +   * Setting the source resolution will reset visible resolution to th=
e
> > +     adjusted source resolution rounded up to the closest visible
> > +     resolution supported by the driver. Similarly, coded resolution w=
ill
>
> coded -> the coded

Ack.

>
> > +     be reset to source resolution rounded up to the closest coded
>
> reset -> set
> source -> the source

Ack.

>
> > +     resolution supported by the driver (typically a multiple of
> > +     macroblock size).
>
> The first sentence of this paragraph is very confusing. It needs a bit mo=
re work,
> I think.

Actually, this applies to all crop rectangles, not just visible
resolution. How about the following?

    Setting the source resolution will reset the crop rectangles to
default values
    corresponding to the new resolution, as described further in this docum=
ent.
    Similarly, the coded resolution will be reset to match source
resolution rounded up
    to the closest coded resolution supported by the driver (typically
a multiple of
    macroblock size).

>
> > +
> > +   .. note::
> > +
> > +      This step is not strictly required, since ``OUTPUT`` is expected=
 to
> > +      have a valid default format. However, the client needs to ensure=
 that
> > +      ``OUTPUT`` format matches its expectations via either
> > +      :c:func:`VIDIOC_S_FMT` or :c:func:`VIDIOC_G_FMT`, with the forme=
r
> > +      being the typical scenario, since the default format is unlikely=
 to
> > +      be what the client needs.
>
> Hmm. I'm not sure if this note should be included. It's good practice to =
always
> set the output format. I think the note confuses more than that it helps.=
 IMHO.
>

I agree with you on that. In RFC, Philipp noticed that technically
S_FMT is not mandatory and that there might be some use case where the
already set format matches client's expectation. I've added this note
to cover that. Philipp, do you still think we need it?

> > +
> > +5. *[optional]* Set visible resolution for the stream metadata via
>
> Set -> Set the
>

Ack.

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
> > +         visible rectangle; this must fit within the framebuffer resol=
ution
>
> Should that be "source resolution"? Or the resolution returned by "CROP_B=
OUNDS"?
>

Referring to V4L2_SEL_TGT_CROP_BOUNDS rather than some arbitrary
resolution is better indeed, will change.

> > +         and might be subject to adjustment to match codec and hardwar=
e
> > +         constraints
> > +
> > +   * **Return fields:**
> > +
> > +     ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > +         visible rectangle adjusted by the driver
> > +
> > +   * The driver must expose following selection targets on ``OUTPUT``:
> > +
> > +     ``V4L2_SEL_TGT_CROP_BOUNDS``
> > +         maximum crop bounds within the source buffer supported by the
> > +         encoder
> > +
> > +     ``V4L2_SEL_TGT_CROP_DEFAULT``
> > +         suggested cropping rectangle that covers the whole source pic=
ture
> > +
> > +     ``V4L2_SEL_TGT_CROP``
> > +         rectangle within the source buffer to be encoded into the
> > +         ``CAPTURE`` stream; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``
> > +
> > +     ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> > +         maximum rectangle within the coded resolution, which the crop=
ped
> > +         source frame can be output into; always equal to (0, 0)x(widt=
h of
> > +         ``V4L2_SEL_TGT_CROP``, height of ``V4L2_SEL_TGT_CROP``), if t=
he
> > +         hardware does not support compose/scaling
> > +
> > +     ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
> > +         equal to ``V4L2_SEL_TGT_CROP``
> > +
> > +     ``V4L2_SEL_TGT_COMPOSE``
> > +         rectangle within the coded frame, which the cropped source fr=
ame
> > +         is to be output into; defaults to
> > +         ``V4L2_SEL_TGT_COMPOSE_DEFAULT``; read-only on hardware witho=
ut
> > +         additional compose/scaling capabilities; resulting stream wil=
l
> > +         have this rectangle encoded as the visible rectangle in its
> > +         metadata
> > +
> > +     ``V4L2_SEL_TGT_COMPOSE_PADDED``
> > +         always equal to coded resolution of the stream, as selected b=
y the
> > +         encoder based on source resolution and crop/compose rectangle=
s
>
> Are there codec drivers that support composition? I can't remember seeing=
 any.
>

Hmm, I was convinced that MFC could scale and we just lacked support
in the driver, but I checked the documentation and it doesn't seem to
be able to do so. I guess we could drop the COMPOSE rectangles for
now, until we find any hardware that can do scaling or composing on
the fly.

> > +
> > +   .. note::
> > +
> > +      The driver may adjust the crop/compose rectangles to the nearest
> > +      supported ones to meet codec and hardware requirements.
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
> > +     ``memory``
> > +         follows standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``count``
> > +         adjusted to allocated number of buffers
> > +
> > +   * The driver must adjust count to minimum of required number of
> > +     buffers for given format and count passed.
>
> I'd rephrase this:
>
>         The driver must adjust ``count`` to the maximum of ``count`` and
>         the required number of buffers for the given format.
>
> Note that this is set to the maximum, not minimum.
>

Good catch. Will fix it.

> > The client must
> > +     check this value after the ioctl returns to get the number of
> > +     buffers actually allocated.
> > +
> > +   .. note::
> > +
> > +      To allocate more than minimum number of buffers (for pipeline
>
> than -> than the
>

Ack.

> > +      depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) or
> > +      G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``), respectively,
> > +      to get the minimum number of buffers required by the
> > +      driver/format, and pass the obtained value plus the number of
> > +      additional buffers needed in count field to :c:func:`VIDIOC_REQB=
UFS`.
>
> count -> the ``count``
>

Ack.

> > +
> > +7. Begin streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
> > +   :c:func:`VIDIOC_STREAMON`. This may be performed in any order. Actu=
al
>
> Actual -> The actual
>

Ack.

> > +   encoding process starts when both queues start streaming.
> > +
> > +.. note::
> > +
> > +   If the client stops ``CAPTURE`` during the encode process and then
> > +   restarts it again, the encoder will be expected to generate a strea=
m
> > +   independent from the stream generated before the stop. Depending on=
 the
> > +   coded format, that may imply that:
> > +
> > +   * encoded frames produced after the restart must not reference any
> > +     frames produced before the stop, e.g. no long term references for
> > +     H264,
> > +
> > +   * any headers that must be included in a standalone stream must be
> > +     produced again, e.g. SPS and PPS for H264.
> > +
> > +Encoding
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This state is reached after a successful initialization sequence. In
> > +this state, client queues and dequeues buffers to both queues via
> > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
> > +semantics.
> > +
> > +Both queues operate independently, following standard behavior of V4L2
> > +buffer queues and memory-to-memory devices. In addition, the order of
> > +encoded frames dequeued from ``CAPTURE`` queue may differ from the ord=
er of
> > +queuing raw frames to ``OUTPUT`` queue, due to properties of selected =
coded
> > +format, e.g. frame reordering. The client must not assume any direct
> > +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
> > +reported by :c:type:`v4l2_buffer` ``timestamp``.
>
> Same question as for the decoder: are you sure about that?
>

I think it's the same answer here. That's why we have the timestamp
copy mechanism, right?

> > +
> > +Encoding parameter changes
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > +
> > +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> > +parameters at any time. The availability of parameters is driver-speci=
fic
> > +and the client must query the driver to find the set of available cont=
rols.
> > +
> > +The ability to change each parameter during encoding of is driver-spec=
ific,
>
> Remove spurious 'of'
>
> > +as per standard semantics of the V4L2 control interface. The client ma=
y
>
> per -> per the
>
> > +attempt setting a control of its interest during encoding and if it th=
e
>
> Remove spurious 'it'
>
> > +operation fails with the -EBUSY error code, ``CAPTURE`` queue needs to=
 be
>
> ``CAPTURE`` -> the ``CAPTURE``
>
> > +stopped for the configuration change to be allowed (following the drai=
n
> > +sequence will be  needed to avoid losing already queued/encoded frames=
).
>
> losing -> losing the
>
> > +
> > +The timing of parameter update is driver-specific, as per standard
>
> update -> updates
> per -> per the
>
> > +semantics of the V4L2 control interface. If the client needs to apply =
the
> > +parameters exactly at specific frame and the encoder supports it, usin=
g
>
> using -> using the

Ack +6

>
> > +Request API should be considered.
>
> This makes the assumption that the Request API will be merged at about th=
e
> same time as this document. Which is at the moment a reasonable assumptio=
n,
> to be fair.
>

We can easily remove this, if it doesn't happen, but I'd prefer not to
need to. ;)

> > +
> > +Drain
> > +=3D=3D=3D=3D=3D
> > +
> > +To ensure that all queued ``OUTPUT`` buffers have been processed and
> > +related ``CAPTURE`` buffers output to the client, the following drain
>
> related -> the related
>

Ack.

> > +sequence may be followed. After the drain sequence is complete, the cl=
ient
> > +has received all encoded frames for all ``OUTPUT`` buffers queued befo=
re
> > +the sequence was started.
> > +
> > +1. Begin drain by issuing :c:func:`VIDIOC_ENCODER_CMD`.
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
> > +2. The driver must process and encode as normal all ``OUTPUT`` buffers
> > +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was is=
sued.
> > +
> > +3. Once all ``OUTPUT`` buffers queued before ``V4L2_ENC_CMD_STOP`` are
> > +   processed:
> > +
> > +   * Once all decoded frames (if any) are ready to be dequeued on the
> > +     ``CAPTURE`` queue the driver must send a ``V4L2_EVENT_EOS``. The
> > +     driver must also set ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buff=
er`
> > +     ``flags`` field on the buffer on the ``CAPTURE`` queue containing=
 the
> > +     last frame (if any) produced as a result of processing the ``OUTP=
UT``
> > +     buffers queued before
> > +     ``V4L2_ENC_CMD_STOP``.
>
> Hmm, this is somewhat awkward phrasing. Can you take another look at this=
?
>

How about this?

3. Once all ``OUTPUT`` buffers queued before ``V4L2_ENC_CMD_STOP`` are
   processed:

   * The driver returns all ``CAPTURE`` buffers corresponding to processed
     ``OUTPUT`` buffers, if any. The last buffer must have
``V4L2_BUF_FLAG_LAST``
     set in its :c:type:`v4l2_buffer` ``flags`` field.

   * The driver sends a ``V4L2_EVENT_EOS`` event.

> > +
> > +   * If no more frames are left to be returned at the point of handlin=
g
> > +     ``V4L2_ENC_CMD_STOP``, the driver must return an empty buffer (wi=
th
> > +     :c:type:`v4l2_buffer` ``bytesused`` =3D 0) as the last buffer wit=
h
> > +     ``V4L2_BUF_FLAG_LAST`` set.
> > +
> > +   * Any attempts to dequeue more buffers beyond the buffer marked wit=
h
> > +     ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error code returne=
d by
> > +     :c:func:`VIDIOC_DQBUF`.
> > +
> > +4. At this point, encoding is paused and the driver will accept, but n=
ot
> > +   process any newly queued ``OUTPUT`` buffers until the client issues
>
> issues -> issues a
>

Ack.

[snip]
> > +Commit points
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Setting formats and allocating buffers triggers changes in the behavio=
r
> > +of the driver.
> > +
> > +1. Setting format on ``CAPTURE`` queue may change the set of formats
>
> format -> the format
>
> > +   supported/advertised on the ``OUTPUT`` queue. In particular, it als=
o
> > +   means that ``OUTPUT`` format may be reset and the client must not
>
> that -> that the
>
> > +   rely on the previously set format being preserved.
> > +
> > +2. Enumerating formats on ``OUTPUT`` queue must only return formats
>
> on -> on the
>
> > +   supported for the ``CAPTURE`` format currently set.
>
> 'for the current ``CAPTURE`` format.'
>
> > +
> > +3. Setting/changing format on ``OUTPUT`` queue does not change formats
>
> format -> the format
> on -> on the
>
> > +   available on ``CAPTURE`` queue. An attempt to set ``OUTPUT`` format=
 that
>
> on -> on the
> set -> set the
>
> > +   is not supported for the currently selected ``CAPTURE`` format must
> > +   result in the driver adjusting the requested format to an acceptabl=
e
> > +   one.
> > +
> > +4. Enumerating formats on ``CAPTURE`` queue always returns the full se=
t of
>
> on -> on the
>
> > +   supported coded formats, irrespective of the current ``OUTPUT``
> > +   format.
> > +
> > +5. After allocating buffers on the ``CAPTURE`` queue, it is not possib=
le to
> > +   change format on it.
>
> format -> the format
>

Ack +7

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
> > diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/medi=
a/uapi/v4l/v4l2.rst
> > index 65dc096199ad..2ef6693b9499 100644
> > --- a/Documentation/media/uapi/v4l/v4l2.rst
> > +++ b/Documentation/media/uapi/v4l/v4l2.rst
> > @@ -56,6 +56,7 @@ Authors, in alphabetical order:
> >  - Figa, Tomasz <tfiga@chromium.org>
> >
> >    - Documented the memory-to-memory decoder interface.
> > +  - Documented the memory-to-memory encoder interface.
> >
> >  - H Schimek, Michael <mschimek@gmx.at>
> >
> > @@ -68,6 +69,7 @@ Authors, in alphabetical order:
> >  - Osciak, Pawel <posciak@chromium.org>
> >
> >    - Documented the memory-to-memory decoder interface.
> > +  - Documented the memory-to-memory encoder interface.
> >
> >  - Osciak, Pawel <pawel@osciak.com>
> >
> >
>
> One general comment:
>
> you often talk about 'the driver must', e.g.:
>
> "The driver must process and encode as normal all ``OUTPUT`` buffers
> queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued."
>
> But this is not a driver specification, it is an API specification.
>
> I think it would be better to phrase it like this:
>
> "All ``OUTPUT`` buffers queued by the client before the :c:func:`VIDIOC_E=
NCODER_CMD`
> was issued will be processed and encoded as normal."
>
> (or perhaps even 'shall' if you want to be really formal)
>
> End-users do not really care what drivers do, they want to know what the =
API does,
> and that implies rules for drivers.

While I see the point, I'm not fully convinced that it makes the
documentation easier to read. We defined "client" for the purpose of
not using the passive form too much, so possibly we could also define
"driver" in the glossary. Maybe it's just me, but I find that
referring directly to both sides of the API and using the active form
is much easier to read.

Possibly just replacing "driver" with "encoder" would ease your concern?

Best regards,
Tomasz
