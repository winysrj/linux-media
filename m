Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:42900 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932237AbeFFJD7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 05:03:59 -0400
Received: by mail-vk0-f65.google.com with SMTP id s187-v6so3219504vke.9
        for <linux-media@vger.kernel.org>; Wed, 06 Jun 2018 02:03:58 -0700 (PDT)
Received: from mail-ua0-f174.google.com (mail-ua0-f174.google.com. [209.85.217.174])
        by smtp.gmail.com with ESMTPSA id k26-v6sm2915990uan.52.2018.06.06.02.03.56
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jun 2018 02:03:56 -0700 (PDT)
Received: by mail-ua0-f174.google.com with SMTP id n4-v6so3589407uad.6
        for <linux-media@vger.kernel.org>; Wed, 06 Jun 2018 02:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-2-tfiga@chromium.org>
 <CAAoAYcOJ5Q2rHqGEmcStxxXj423a3ddKOSzvwRV6R5-UxhM+Hg@mail.gmail.com>
In-Reply-To: <CAAoAYcOJ5Q2rHqGEmcStxxXj423a3ddKOSzvwRV6R5-UxhM+Hg@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 6 Jun 2018 18:03:43 +0900
Message-ID: <CAAFQd5AcBiGVZ=4V4qqMQtPtvNoT7EmQEDRmp_5mJ0amf2Vcpg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: dave.stevenson@raspberrypi.org,
        Pawel Osciak <posciak@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
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

Hi Dave,

Thanks for review! Please see my replies inline.

On Tue, Jun 5, 2018 at 10:10 PM Dave Stevenson
<dave.stevenson@raspberrypi.org> wrote:
>
> Hi Tomasz.
>
> Thanks for formalising this.
> I'm working on a stateful V4L2 codec driver on the Raspberry Pi and
> was having to deduce various implementation details from other
> drivers. I know how much we all tend to hate having to write
> documentation, but it is useful to have.

Agreed. Piles of other work showing up out of nowhere don't help either. :(

A lot of credits go to Pawel, who wrote down most of details discussed
earlier into a document that we used internally to implement Chrome OS
video stack and drivers. He unfortunately got flooded with loads of
other work and ran out of time to finalize it and produce something
usable as kernel documentation (time was needed especially in the old
DocBook xml days).

>
> On 5 June 2018 at 11:33, Tomasz Figa <tfiga@chromium.org> wrote:
> > Due to complexity of the video decoding process, the V4L2 drivers of
> > stateful decoder hardware require specific sequencies of V4L2 API calls
> > to be followed. These include capability enumeration, initialization,
> > decoding, seek, pause, dynamic resolution change, flush and end of
> > stream.
> >
> > Specifics of the above have been discussed during Media Workshops at
> > LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API that
> > originated at those events was later implemented by the drivers we alre=
ady
> > have merged in mainline, such as s5p-mfc or mtk-vcodec.
> >
> > The only thing missing was the real specification included as a part of
> > Linux Media documentation. Fix it now and document the decoder part of
> > the Codec API.
> >
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > ---
> >  Documentation/media/uapi/v4l/dev-codec.rst | 771 +++++++++++++++++++++
> >  Documentation/media/uapi/v4l/v4l2.rst      |  14 +-
> >  2 files changed, 784 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation=
/media/uapi/v4l/dev-codec.rst
> > index c61e938bd8dc..0483b10c205e 100644
> > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> > @@ -34,3 +34,774 @@ the codec and reprogram it whenever another file ha=
ndler gets access.
> >  This is different from the usual video node behavior where the video
> >  properties are global to the device (i.e. changing something through o=
ne
> >  file handle is visible through another file handle).
>
> I know this isn't part of the changes, but raises a question in
> v4l2-compliance (so probably one for Hans).
> testUnlimitedOpens tries opening the device 100 times. On a normal
> device this isn't a significant overhead, but when you're allocating
> resources on a per instance basis it quickly adds up.
> Internally I have state that has a limit of 64 codec instances (either
> encode or decode), so either I allocate at start_streaming and fail on
> the 65th one, or I fail on open. I generally take the view that
> failing early is a good thing.
> Opinions? Is 100 instances of an M2M device really sensible?

I don't think we can guarantee opening an arbitrary number of
instances. To add to your point about resource usage, this is
something that can be limited already on hardware or firmware level.
Another aspect is that the hardware is often rated to decode N streams
at resolution X by Y at Z fps, so it might not even make practical
sense to use it to decode M > N streams.

>
> > +This interface is generally appropriate for hardware that does not
> > +require additional software involvement to parse/partially decode/mana=
ge
> > +the stream before/after processing in hardware.
> > +
> > +Input data to the Stream API are buffers containing unprocessed video
> > +stream (Annex-B H264/H265 stream, raw VP8/9 stream) only. The driver i=
s
> > +expected not to require any additional information from the client to
> > +process these buffers, and to return decoded frames on the CAPTURE que=
ue
> > +in display order.
>
> This intersects with the question I asked on the list back in April
> but got no reply [1].
> Is there a requirement or expectation for the encoded data to be
> framed as a single encoded frame per buffer, or is feeding in full
> buffer sized chunks from a ES valid? It's not stated for the
> description of V4L2_PIX_FMT_H264 etc either.
> If not framed then anything assuming one-in one-out fails badly, but
> it's likely to fail anyway if the stream has reference frames.

I believe we agreed on the data to be framed. The details are
explained in "Decoding" session, but I guess it could actually belong
to the definition of each specific pixel format.

>
> This description is also exclusive to video decode, whereas the top
> section states "A V4L2 codec can compress, decompress, transform, or
> otherwise convert video data". Should it be in the decoder section
> below?

Yeah, looks like it should be moved indeed.

>
> Have I missed a statement of what the Stream API is and how it differs
> from any other API?

This is a leftover that I should have removed, since this document
continues to call this interface "Codec Interface".

The other API is the "Stateless Codec Interface" mentioned below. As
opposed to the regular (stateful) Codec Interface, it would target the
hardware that do not store any decoding state for its own use, but
rather expects the software to provide necessary data for each chunk
of framed bitstream, such as headers parsed into predefined structures
(as per codec standard) or reference frame lists. With stateless API,
userspace would have to explicitly manage which buffers are used as
reference frames, reordering to display order and so on. It's a WiP
and is partially blocked by Request API, since it needs extra data to
be given in a per-buffer manner.

>
> [1] https://www.spinics.net/lists/linux-media/msg133102.html
>
> > +Performing software parsing, processing etc. of the stream in the driv=
er
> > +in order to support stream API is strongly discouraged. In such case u=
se
> > +of Stateless Codec Interface (in development) is preferred.
> > +
> > +Conventions and notation used in this document
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. The general V4L2 API rules apply if not specified in this document
> > +   otherwise.
> > +
> > +2. The meaning of words =E2=80=9Cmust=E2=80=9D, =E2=80=9Cmay=E2=80=9D,=
 =E2=80=9Cshould=E2=80=9D, etc. is as per RFC
> > +   2119.
> > +
> > +3. All steps not marked =E2=80=9Coptional=E2=80=9D are required.
> > +
> > +4. :c:func:`VIDIOC_G_EXT_CTRLS`, :c:func:`VIDIOC_S_EXT_CTRLS` may be u=
sed interchangeably with
> > +   :c:func:`VIDIOC_G_CTRL`, :c:func:`VIDIOC_S_CTRL`, unless specified =
otherwise.
> > +
> > +5. Single-plane API (see spec) and applicable structures may be used
> > +   interchangeably with Multi-plane API, unless specified otherwise.
> > +
> > +6. i =3D [a..b]: sequence of integers from a to b, inclusive, i.e. i =
=3D
> > +   [0..2]: i =3D 0, 1, 2.
> > +
> > +7. For OUTPUT buffer A, A=E2=80=99 represents a buffer on the CAPTURE =
queue
> > +   containing data (decoded or encoded frame/stream) that resulted
> > +   from processing buffer A.
> > +
> > +Glossary
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +CAPTURE
> > +   the destination buffer queue, decoded frames for
> > +   decoders, encoded bitstream for encoders;
> > +   ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
> > +   ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``
> > +
> > +client
> > +   application client communicating with the driver
> > +   implementing this API
> > +
> > +coded format
> > +   encoded/compressed video bitstream format (e.g.
> > +   H.264, VP8, etc.); see raw format; this is not equivalent to fourcc
> > +   (V4L2 pixelformat), as each coded format may be supported by multip=
le
> > +   fourccs (e.g. ``V4L2_PIX_FMT_H264``, ``V4L2_PIX_FMT_H264_SLICE``, e=
tc.)
> > +
> > +coded height
> > +   height for given coded resolution
> > +
> > +coded resolution
> > +   stream resolution in pixels aligned to codec
> > +   format and hardware requirements; see also visible resolution
> > +
> > +coded width
> > +   width for given coded resolution
> > +
> > +decode order
> > +   the order in which frames are decoded; may differ
> > +   from display (output) order if frame reordering (B frames) is activ=
e in
> > +   the stream; OUTPUT buffers must be queued in decode order; for fram=
e
> > +   API, CAPTURE buffers must be returned by the driver in decode order=
;
> > +
> > +display order
> > +   the order in which frames must be displayed
> > +   (outputted); for stream API, CAPTURE buffers must be returned by th=
e
> > +   driver in display order;
> > +
> > +EOS
> > +   end of stream
> > +
> > +input height
> > +   height in pixels for given input resolution
> > +
> > +input resolution
> > +   resolution in pixels of source frames being input
> > +   to the encoder and subject to further cropping to the bounds of vis=
ible
> > +   resolution
> > +
> > +input width
> > +   width in pixels for given input resolution
> > +
> > +OUTPUT
> > +   the source buffer queue, encoded bitstream for
> > +   decoders, raw frames for encoders; ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` o=
r
> > +   ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``
> > +
> > +raw format
> > +   uncompressed format containing raw pixel data (e.g.
> > +   YUV, RGB formats)
> > +
> > +resume point
> > +   a point in the bitstream from which decoding may
> > +   start/continue, without any previous state/data present, e.g.: a
> > +   keyframe (VPX) or SPS/PPS/IDR sequence (H.264); a resume point is
> > +   required to start decode of a new stream, or to resume decoding aft=
er a
> > +   seek;
> > +
> > +source buffer
> > +   buffers allocated for source queue
> > +
> > +source queue
> > +   queue containing buffers used for source data, i.e.
> > +
> > +visible height
> > +   height for given visible resolution
> > +
> > +visible resolution
> > +   stream resolution of the visible picture, in
> > +   pixels, to be used for display purposes; must be smaller or equal t=
o
> > +   coded resolution;
> > +
> > +visible width
> > +   width for given visible resolution
> > +
> > +Decoder
> > +=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Querying capabilities
> > +---------------------
> > +
> > +1. To enumerate the set of coded formats supported by the driver, the
> > +   client uses :c:func:`VIDIOC_ENUM_FMT` for OUTPUT. The driver must a=
lways
> > +   return the full set of supported formats, irrespective of the
> > +   format set on the CAPTURE queue.
> > +
> > +2. To enumerate the set of supported raw formats, the client uses
> > +   :c:func:`VIDIOC_ENUM_FMT` for CAPTURE. The driver must return only =
the
> > +   formats supported for the format currently set on the OUTPUT
> > +   queue.
> > +   In order to enumerate raw formats supported by a given coded
> > +   format, the client must first set that coded format on the
> > +   OUTPUT queue and then enumerate the CAPTURE queue.
> > +
> > +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect suppo=
rted
> > +   resolutions for a given format, passing its fourcc in
> > +   :c:type:`v4l2_frmivalenum` ``pixel_format``.
> > +
> > +   a. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for coded =
formats
> > +      must be maximums for given coded format for all supported raw
> > +      formats.
> > +
> > +   b. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for raw fo=
rmats must
> > +      be maximums for given raw format for all supported coded
> > +      formats.
>
> So in both these cases you expect index=3D0 to return a response with
> the type V4L2_FRMSIZE_TYPE_DISCRETE, and the maximum resolution?
> -EINVAL on any other index value?
> And I assume you mean maximum coded resolution, not visible resolution.
> Or is V4L2_FRMSIZE_TYPE_STEPWISE more appropriate? In which case the
> minimum is presumably a single macroblock, max is the max coded
> resolution, and step size is the macroblock size, at least on the
> CAPTURE side.

Codec size seems to make the most sense here, since that's what
corresponds to the amount of data the decoder needs to process. Let's
have it stated more explicitly.

My understanding is that VIDIOC_ENUM_FRAMESIZES maintains its regular
semantics here and which type of range is used would depend on the
hardware capabilities. This actually matches to what we have
implemented in Chromium video stack [1]. Let's state it more
explicitly as well.

[1] https://cs.chromium.org/chromium/src/media/gpu/v4l2/v4l2_device.cc?q=3D=
VIDIOC_ENUM_FRAMESIZES&sq=3Dpackage:chromium&g=3D0&l=3D279

>
> > +   c. The client should derive the supported resolution for a
> > +      combination of coded+raw format by calculating the
> > +      intersection of resolutions returned from calls to
> > +      :c:func:`VIDIOC_ENUM_FRAMESIZES` for the given coded and raw for=
mats.
> > +
> > +4. Supported profiles and levels for given format, if applicable, may =
be
> > +   queried using their respective controls via :c:func:`VIDIOC_QUERYCT=
RL`.
> > +
> > +5. The client may use :c:func:`VIDIOC_ENUM_FRAMEINTERVALS` to enumerat=
e maximum
> > +   supported framerates by the driver/hardware for a given
> > +   format+resolution combination.
> > +
> > +Initialization sequence
> > +-----------------------
> > +
> > +1. (optional) Enumerate supported OUTPUT formats and resolutions. See
> > +   capability enumeration.
> > +
> > +2. Set a coded format on the source queue via :c:func:`VIDIOC_S_FMT`
> > +
> > +   a. Required fields:
> > +
> > +      i.   type =3D OUTPUT
> > +
> > +      ii.  fmt.pix_mp.pixelformat set to a coded format
> > +
> > +      iii. fmt.pix_mp.width, fmt.pix_mp.height only if cannot be
> > +           parsed from the stream for the given coded format;
> > +           ignored otherwise;
> > +
> > +   b. Return values:
> > +
> > +      i.  EINVAL: unsupported format.
> > +
> > +      ii. Others: per spec
> > +
> > +   .. note::
> > +
> > +      The driver must not adjust pixelformat, so if
> > +      ``V4L2_PIX_FMT_H264`` is passed but only
> > +      ``V4L2_PIX_FMT_H264_SLICE`` is supported, S_FMT will return
> > +      -EINVAL. If both are acceptable by client, calling S_FMT for
> > +      the other after one gets rejected may be required (or use
> > +      :c:func:`VIDIOC_ENUM_FMT` to discover beforehand, see Capability
> > +      enumeration).
>
> I can't find V4L2_PIX_FMT_H264_SLICE in mainline. From trying to build
> Chromium I believe it's a Rockchip special. Is it being upstreamed?

This is a part of the stateless Codec Interface being in development.
We used to call it "Slice API" internally and so the name. It is not
specific to Rockchip, but rather the whole class of stateless codecs,
as I explained by the way of your another comment.

Any mention of it should be removed from the document for now.

> Or use V4L2_PIX_FMT_H264 vs V4L2_PIX_FMT_H264_NO_SC as the example?
> (I've just noticed I missed an instance of this further up as well).

Yeah, sounds like it would be a better example.

>
> > +3.  (optional) Get minimum number of buffers required for OUTPUT queue
> > +    via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to u=
se
> > +    more buffers than minimum required by hardware/format (see
> > +    allocation).
> > +
> > +    a. Required fields:
> > +
> > +       i. id =3D ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
> > +
> > +    b. Return values: per spec.
> > +
> > +    c. Return fields:
> > +
> > +       i. value: required number of OUTPUT buffers for the currently s=
et
> > +          format;
> > +
> > +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` o=
n OUTPUT
> > +    queue.
> > +
> > +    a. Required fields:
> > +
> > +       i.   count =3D n, where n > 0.
> > +
> > +       ii.  type =3D OUTPUT
> > +
> > +       iii. memory =3D as per spec
> > +
> > +    b. Return values: Per spec.
> > +
> > +    c. Return fields:
> > +
> > +       i. count: adjusted to allocated number of buffers
> > +
> > +    d. The driver must adjust count to minimum of required number of
> > +       source buffers for given format and count passed. The client
> > +       must check this value after the ioctl returns to get the
> > +       number of buffers allocated.
> > +
> > +    .. note::
> > +
> > +       Passing count =3D 1 is useful for letting the driver choose
> > +       the minimum according to the selected format/hardware
> > +       requirements.
> > +
> > +    .. note::
> > +
> > +       To allocate more than minimum number of buffers (for pipeline
> > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT)`` to
> > +       get minimum number of buffers required by the driver/format,
> > +       and pass the obtained value plus the number of additional
> > +       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
> > +
> > +5.  Begin parsing the stream for stream metadata via :c:func:`VIDIOC_S=
TREAMON` on
> > +    OUTPUT queue. This step allows the driver to parse/decode
> > +    initial stream metadata until enough information to allocate
> > +    CAPTURE buffers is found. This is indicated by the driver by
> > +    sending a ``V4L2_EVENT_SOURCE_CHANGE`` event, which the client
> > +    must handle.
> > +
> > +    a. Required fields: as per spec.
> > +
> > +    b. Return values: as per spec.
> > +
> > +    .. note::
> > +
> > +       Calling :c:func:`VIDIOC_REQBUFS`, :c:func:`VIDIOC_STREAMON`
> > +       or :c:func:`VIDIOC_G_FMT` on the CAPTURE queue at this time is =
not
> > +       allowed and must return EINVAL.
>
> I think you've just broken FFMpeg and Gstreamer with that statement.
>
> Gstreamer certainly doesn't subscribe to V4L2_EVENT_SOURCE_CHANGE but
> has already parsed the stream and set the output format to the correct
> resolution via S_FMT. IIRC it expects the driver to copy that across
> from output to capture which was an interesting niggle to find.
> FFMpeg does subscribe to V4L2_EVENT_SOURCE_CHANGE, although it seems
> to currently have a bug around coded resolution !=3D visible resolution
> when it gets the event.
>
> One has to assume that these have been working quite happily against
> various hardware platforms, so it seems a little unfair to just break
> them.

That's certainly not what existing drivers do and the examples would be:

- s5p-mfc (the first codec driver in upstream) and mtk-vcodec (merged
quite recently)
    It just ignores width/height and OUTPUT queue
      https://elixir.bootlin.com/linux/latest/source/drivers/media/platform=
/s5p-mfc/s5p_mfc_dec.c#L443
    and reports what the hardware parses from bitstream on CAPTURE:
      https://elixir.bootlin.com/linux/latest/source/drivers/media/platform=
/s5p-mfc/s5p_mfc_dec.c#L352

- mtk-vcodec (merged quite recently):
    It indeed accepts whatever is set on OUTPUT as some kind of defaults,
      https://elixir.bootlin.com/linux/latest/source/drivers/media/platform=
/mtk-vcodec/mtk_vcodec_dec.c#L856
    but those are overridden as soon as the headers are parsed
      https://elixir.bootlin.com/linux/latest/source/drivers/media/platform=
/mtk-vcodec/mtk_vcodec_dec.c#L989

However, the above probably doesn't prevent Gstreamer from working,
because both drivers would allow REQBUFS(CAPTURE) before the parsing
is done and luckily the resolution would match later after parsing.

> So I guess my question is what is the reasoning for rejecting these
> calls? If you know the resolution ahead of time, allocate buffers, and
> start CAPTURE streaming before the event then should you be wrong
> you're just going through the dynamic resolution change path described
> later. If you're correct then you've saved some setup time. It also
> avoids having to have a special startup case in the driver.

We might need Pawel or Hans to comment on this, as I believe it has
been decided to be like this in earlier Media Workshops.

I personally don't see what would go wrong if we allow that and handle
a fallback using the dynamic resolution change flow. Maybe except the
need to rework the s5p-mfc driver.

>
> > +6.  This step only applies for coded formats that contain resolution
> > +    information in the stream.
> > +    Continue queuing/dequeuing bitstream buffers to/from the
> > +    OUTPUT queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`.=
 The driver
> > +    must keep processing and returning each buffer to the client
> > +    until required metadata to send a ``V4L2_EVENT_SOURCE_CHANGE``
> > +    for source change type ``V4L2_EVENT_SRC_CH_RESOLUTION`` is
> > +    found. There is no requirement to pass enough data for this to
> > +    occur in the first buffer and the driver must be able to
> > +    process any number
>
> So back to my earlier question, we're supporting tiny fragments of
> frames here? Or is the thought that you can pick up anywhere in a
> stream and the decoder will wait for the required resume point?

I think this is precisely about the hardware/driver discarding
bitstream frames until a frame containing resolution data is found. So
that would be the latter, I believe.

>
> > +    a. Required fields: as per spec.
> > +
> > +    b. Return values: as per spec.
> > +
> > +    c. If data in a buffer that triggers the event is required to deco=
de
> > +       the first frame, the driver must not return it to the client,
> > +       but must retain it for further decoding.
> > +
> > +    d. Until the resolution source event is sent to the client, callin=
g
> > +       :c:func:`VIDIOC_G_FMT` on the CAPTURE queue must return -EINVAL=
.
> > +
> > +    .. note::
> > +
> > +       No decoded frames are produced during this phase.
> > +
> > +7.  This step only applies for coded formats that contain resolution
> > +    information in the stream.
> > +    Receive and handle ``V4L2_EVENT_SOURCE_CHANGE`` from the driver
> > +    via :c:func:`VIDIOC_DQEVENT`. The driver must send this event once
> > +    enough data is obtained from the stream to allocate CAPTURE
> > +    buffers and to begin producing decoded frames.
> > +
> > +    a. Required fields:
> > +
> > +       i. type =3D ``V4L2_EVENT_SOURCE_CHANGE``
> > +
> > +    b. Return values: as per spec.
> > +
> > +    c. The driver must return u.src_change.changes =3D
> > +       ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > +
> > +8.  This step only applies for coded formats that contain resolution
> > +    information in the stream.
> > +    Call :c:func:`VIDIOC_G_FMT` for CAPTURE queue to get format for th=
e
> > +    destination buffers parsed/decoded from the bitstream.
> > +
> > +    a. Required fields:
> > +
> > +       i. type =3D CAPTURE
> > +
> > +    b. Return values: as per spec.
> > +
> > +    c. Return fields:
> > +
> > +       i.   fmt.pix_mp.width, fmt.pix_mp.height: coded resolution
> > +            for the decoded frames
> > +
> > +       ii.  fmt.pix_mp.pixelformat: default/required/preferred by
> > +            driver pixelformat for decoded frames.
> > +
> > +       iii. num_planes: set to number of planes for pixelformat.
> > +
> > +       iv.  For each plane p =3D [0, num_planes-1]:
> > +            plane_fmt[p].sizeimage, plane_fmt[p].bytesperline as
> > +            per spec for coded resolution.
> > +
> > +    .. note::
> > +
> > +       Te value of pixelformat may be any pixel format supported,
>
> s/Te/The

Ack.

>
> > +       and must
> > +       be supported for current stream, based on the information
> > +       parsed from the stream and hardware capabilities. It is
> > +       suggested that driver chooses the preferred/optimal format
> > +       for given configuration. For example, a YUV format may be
> > +       preferred over an RGB format, if additional conversion step
> > +       would be required.
> > +
> > +9.  (optional) Enumerate CAPTURE formats via :c:func:`VIDIOC_ENUM_FMT`=
 on
> > +    CAPTURE queue.
> > +    Once the stream information is parsed and known, the client
> > +    may use this ioctl to discover which raw formats are supported
> > +    for given stream and select on of them via :c:func:`VIDIOC_S_FMT`.
> > +
> > +    a. Fields/return values as per spec.
> > +
> > +    .. note::
> > +
> > +       The driver must return only formats supported for the
> > +       current stream parsed in this initialization sequence, even
> > +       if more formats may be supported by the driver in general.
> > +       For example, a driver/hardware may support YUV and RGB
> > +       formats for resolutions 1920x1088 and lower, but only YUV for
> > +       higher resolutions (e.g. due to memory bandwidth
> > +       limitations). After parsing a resolution of 1920x1088 or
> > +       lower, :c:func:`VIDIOC_ENUM_FMT` may return a set of YUV and RG=
B
> > +       pixelformats, but after parsing resolution higher than
> > +       1920x1088, the driver must not return (unsupported for this
> > +       resolution) RGB.
>
> There are some funny cases here then.
> Whilst memory bandwidth may limit the resolution that can be decoded
> in real-time, for a transcode use case you haven't got a real-time
> requirement. Enforcing this means you can never transcode that
> resolution to RGB.

I think the above is not about performance, but the general hardware
ability to decode into such format. The bandwidth might be just not
enough to even process one frame leading to some bus timeouts for
example. The history of hardware design knows a lot of funny cases. :)

> Actually I can't see any information related to frame rates being
> passed in other than timestamps, therefore the driver hasn't got
> sufficient information to make a sensible call based on memory
> bandwidth.

Again, I believe this is not about frame rate, but rather one-shot
bandwidth needed to fetch 1 frame data without breaking things.

> Perhaps it's just that the example of memory bandwidth being the
> limitation is a bad one.

Yeah, it might just be a not very good example. It could as well be
just a fixed size static memory inside the codec hardware, which would
obviously be capable of holding less pixels for 32-bit RGBx than
12-bit (in average) YUV420.

>
> > +       However, subsequent resolution change event
> > +       triggered after discovering a resolution change within the
> > +       same stream may switch the stream into a lower resolution;
> > +       :c:func:`VIDIOC_ENUM_FMT` must return RGB formats again in that=
 case.
> > +
> > +10.  (optional) Choose a different CAPTURE format than suggested via
> > +     :c:func:`VIDIOC_S_FMT` on CAPTURE queue. It is possible for the c=
lient
> > +     to choose a different format than selected/suggested by the
> > +     driver in :c:func:`VIDIOC_G_FMT`.
> > +
> > +     a. Required fields:
> > +
> > +        i.  type =3D CAPTURE
> > +
> > +        ii. fmt.pix_mp.pixelformat set to a coded format
> > +
> > +     b. Return values:
> > +
> > +        i. EINVAL: unsupported format.
> > +
> > +     c. Calling :c:func:`VIDIOC_ENUM_FMT` to discover currently availa=
ble formats
> > +        after receiving ``V4L2_EVENT_SOURCE_CHANGE`` is useful to find
> > +        out a set of allowed pixelformats for given configuration,
> > +        but not required.
> > +
> > +11.  (optional) Acquire visible resolution via :c:func:`VIDIOC_G_SELEC=
TION`.
> > +
> > +    a. Required fields:
> > +
> > +       i.  type =3D CAPTURE
> > +
> > +       ii. target =3D ``V4L2_SEL_TGT_CROP``
> > +
> > +    b. Return values: per spec.
> > +
> > +    c. Return fields
> > +
> > +       i. r.left, r.top, r.width, r.height: visible rectangle; this mu=
st
> > +          fit within coded resolution returned from :c:func:`VIDIOC_G_=
FMT`.
> > +
> > +12. (optional) Get minimum number of buffers required for CAPTURE queu=
e
> > +    via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to u=
se
> > +    more buffers than minimum required by hardware/format (see
> > +    allocation).
> > +
> > +    a. Required fields:
> > +
> > +       i. id =3D ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
> > +
> > +    b. Return values: per spec.
> > +
> > +    c. Return fields:
> > +
> > +       i. value: minimum number of buffers required to decode the stre=
am
> > +          parsed in this initialization sequence.
> > +
> > +    .. note::
> > +
> > +       Note that the minimum number of buffers must be at least the
> > +       number required to successfully decode the current stream.
> > +       This may for example be the required DPB size for an H.264
> > +       stream given the parsed stream configuration (resolution,
> > +       level).
> > +
> > +13. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQB=
UFS` on the
> > +    CAPTURE queue.
> > +
> > +    a. Required fields:
> > +
> > +       i.   count =3D n, where n > 0.
> > +
> > +       ii.  type =3D CAPTURE
> > +
> > +       iii. memory =3D as per spec
> > +
> > +    b. Return values: Per spec.
> > +
> > +    c. Return fields:
> > +
> > +       i. count: adjusted to allocated number of buffers.
> > +
> > +    d. The driver must adjust count to minimum of required number of
> > +       destination buffers for given format and stream configuration
> > +       and the count passed. The client must check this value after
> > +       the ioctl returns to get the number of buffers allocated.
> > +
> > +    .. note::
> > +
> > +       Passing count =3D 1 is useful for letting the driver choose
> > +       the minimum.
> > +
> > +    .. note::
> > +
> > +       To allocate more than minimum number of buffers (for pipeline
> > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE)`` to
> > +       get minimum number of buffers required, and pass the obtained
> > +       value plus the number of additional buffers needed in count
> > +       to :c:func:`VIDIOC_REQBUFS`.
> > +
> > +14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
> > +
> > +    a. Required fields: as per spec.
> > +
> > +    b. Return values: as per spec.
> > +
> > +Decoding
> > +--------
> > +
> > +This state is reached after a successful initialization sequence. In
> > +this state, client queues and dequeues buffers to both queues via
> > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, as per spec.
> > +
> > +Both queues operate independently. The client may queue and dequeue
> > +buffers to queues in any order and at any rate, also at a rate differe=
nt
> > +for each queue. The client may queue buffers within the same queue in
> > +any order (V4L2 index-wise). It is recommended for the client to opera=
te
> > +the queues independently for best performance.
>
> Only recommended sounds like a great case for clients to treat codecs
> as one-in one-out, and then fall over if you get extra header byte
> frames in the stream.

I think the meaning of "operating the queues independently" is a bit
different here, e.g. from separate threads.

But agreed that we need to make sure that the documentation explicitly
says that there is neither one-in one-out guarantee nor 1:1 relation
between OUT and CAP buffers, if it doesn't say it already.

>
> > +Source OUTPUT buffers must contain:
> > +
> > +-  H.264/AVC: one or more complete NALUs of an Annex B elementary
> > +   stream; one buffer does not have to contain enough data to decode
> > +   a frame;
>
> This appears to be answering my earlier question, but doesn't it
> belong in the definition of V4L2_PIX_FMT_H264 rather than buried in
> the codec description?
> I'm OK with that choice, but you are closing off the use case of
> effectively cat'ing an ES into the codec to be decoded.

I think it would indeed make sense to make this behavior a part of the
pixel format. Pawel, what do you think?

>
> There's the other niggle of how to specify sizeimage in the
> pixelformat for compressed data. I have never seen a satisfactory
> answer in most of the APIs I've encountered (*). How big can an
> I-frame be in a random stream? It may be a very badly coded stream,
> but if other decoders can cope, then it's the decoder that can't which
> will be seen to be buggy.

That's a very good question. I think we just empirically came up with
some values that seem to work in Chromium:
https://cs.chromium.org/chromium/src/media/gpu/v4l2/v4l2_slice_video_decode=
_accelerator.h?rcl=3Deed597a7f14cb03cd7db9d9722820dddd86b4c41&l=3D102
https://cs.chromium.org/chromium/src/media/gpu/v4l2/v4l2_video_decode_accel=
erator.cc?rcl=3Deed597a7f14cb03cd7db9d9722820dddd86b4c41&l=3D2241

Pawel, any background behind those?

>
> (* ) OpenMAX IL is the exception as you can pass partial frames with
> appropriate values in nFlags. Not many other positives one can say
> about IL though.
>
> > +-  VP8/VP9: one or more complete frames.
> > +
> > +No direct relationship between source and destination buffers and the
> > +timing of buffers becoming available to dequeue should be assumed in t=
he
> > +Stream API. Specifically:
> > +
> > +-  a buffer queued to OUTPUT queue may result in no buffers being
> > +   produced on the CAPTURE queue (e.g. if it does not contain
> > +   encoded data, or if only metadata syntax structures are present
> > +   in it), or one or more buffers produced on the CAPTURE queue (if
> > +   the encoded data contained more than one frame, or if returning a
> > +   decoded frame allowed the driver to return a frame that preceded
> > +   it in decode, but succeeded it in display order)
> > +
> > +-  a buffer queued to OUTPUT may result in a buffer being produced on
> > +   the CAPTURE queue later into decode process, and/or after
> > +   processing further OUTPUT buffers, or be returned out of order,
> > +   e.g. if display reordering is used
> > +
> > +-  buffers may become available on the CAPTURE queue without additiona=
l
> > +   buffers queued to OUTPUT (e.g. during flush or EOS)
> > +
> > +Seek
> > +----
> > +
> > +Seek is controlled by the OUTPUT queue, as it is the source of bitstre=
am
> > +data. CAPTURE queue remains unchanged/unaffected.
> > +
> > +1. Stop the OUTPUT queue to begin the seek sequence via
> > +   :c:func:`VIDIOC_STREAMOFF`.
> > +
> > +   a. Required fields:
> > +
> > +      i. type =3D OUTPUT
> > +
> > +   b. The driver must drop all the pending OUTPUT buffers and they are
> > +      treated as returned to the client (as per spec).
> > +
> > +2. Restart the OUTPUT queue via :c:func:`VIDIOC_STREAMON`
> > +
> > +   a. Required fields:
> > +
> > +      i. type =3D OUTPUT
> > +
> > +   b. The driver must be put in a state after seek and be ready to
> > +      accept new source bitstream buffers.
> > +
> > +3. Start queuing buffers to OUTPUT queue containing stream data after
> > +   the seek until a suitable resume point is found.
> > +
> > +   .. note::
> > +
> > +      There is no requirement to begin queuing stream
> > +      starting exactly from a resume point (e.g. SPS or a keyframe).
> > +      The driver must handle any data queued and must keep processing
> > +      the queued buffers until it finds a suitable resume point.
> > +      While looking for a resume point, the driver processes OUTPUT
> > +      buffers and returns them to the client without producing any
> > +      decoded frames.
> > +
> > +4. After a resume point is found, the driver will start returning
> > +   CAPTURE buffers with decoded frames.
> > +
> > +   .. note::
> > +
> > +      There is no precise specification for CAPTURE queue of when it
> > +      will start producing buffers containing decoded data from
> > +      buffers queued after the seek, as it operates independently
> > +      from OUTPUT queue.
> > +
> > +      -  The driver is allowed to and may return a number of remaining=
 CAPTURE
> > +         buffers containing decoded frames from before the seek after =
the
> > +         seek sequence (STREAMOFF-STREAMON) is performed.
> > +
> > +      -  The driver is also allowed to and may not return all decoded =
frames
> > +         queued but not decode before the seek sequence was initiated.
> > +         E.g. for an OUTPUT queue sequence: QBUF(A), QBUF(B),
> > +         STREAMOFF(OUT), STREAMON(OUT), QBUF(G), QBUF(H), any of the
> > +         following results on the CAPTURE queue is allowed: {A=E2=80=
=99, B=E2=80=99, G=E2=80=99,
> > +         H=E2=80=99}, {A=E2=80=99, G=E2=80=99, H=E2=80=99}, {G=E2=80=
=99, H=E2=80=99}.
> > +
> > +Pause
> > +-----
> > +
> > +In order to pause, the client should just cease queuing buffers onto t=
he
> > +OUTPUT queue. This is different from the general V4L2 API definition o=
f
> > +pause, which involves calling :c:func:`VIDIOC_STREAMOFF` on the queue.=
 Without
> > +source bitstream data, there is not data to process and the hardware
>
> s/not/no

Ack.

>
> > +remains idle. Conversely, using :c:func:`VIDIOC_STREAMOFF` on OUTPUT q=
ueue
> > +indicates a seek, which 1) drops all buffers in flight and 2) after a
> > +subsequent :c:func:`VIDIOC_STREAMON` will look for and only continue f=
rom a
> > +resume point. This is usually undesirable for pause. The
> > +STREAMOFF-STREAMON sequence is intended for seeking.
> > +
> > +Similarly, CAPTURE queue should remain streaming as well, as the
> > +STREAMOFF-STREAMON sequence on it is intended solely for changing buff=
er
> > +sets
> > +
> > +Dynamic resolution change
> > +-------------------------
> > +
> > +When driver encounters a resolution change in the stream, the dynamic
> > +resolution change sequence is started.
> > +
> > +1.  On encountering a resolution change in the stream. The driver must
> > +    first process and decode all remaining buffers from before the
> > +    resolution change point.
> > +
> > +2.  After all buffers containing decoded frames from before the
> > +    resolution change point are ready to be dequeued on the
> > +    CAPTURE queue, the driver sends a ``V4L2_EVENT_SOURCE_CHANGE``
> > +    event for source change type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > +    The last buffer from before the change must be marked with
> > +    :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as in =
the flush
> > +    sequence.
>
> How does the driver ensure the last buffer gets that flag? You may not
> have had the new header bytes queued to the OUTPUT queue before the
> previous frame has been decoded and dequeued on the CAPTURE queue.
> Empty buffer with the flag set?

Yes, an empty buffer. I think that was explained by the way of the
general flush sequence later. We should state it here as well.

>
> > +    .. note::
> > +
> > +       Any attempts to dequeue more buffers beyond the buffer marked
> > +       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > +       :c:func:`VIDIOC_DQBUF`.
> > +
> > +3.  After dequeuing all remaining buffers from the CAPTURE queue, the
> > +    client must call :c:func:`VIDIOC_STREAMOFF` on the CAPTURE queue. =
The
> > +    OUTPUT queue remains streaming (calling STREAMOFF on it would
> > +    trigger a seek).
> > +    Until STREAMOFF is called on the CAPTURE queue (acknowledging
> > +    the event), the driver operates as if the resolution hasn=E2=80=99=
t
> > +    changed yet, i.e. :c:func:`VIDIOC_G_FMT`, etc. return previous
> > +    resolution.
> > +
> > +4.  The client frees the buffers on the CAPTURE queue using
> > +    :c:func:`VIDIOC_REQBUFS`.
> > +
> > +    a. Required fields:
> > +
> > +       i.   count =3D 0
> > +
> > +       ii.  type =3D CAPTURE
> > +
> > +       iii. memory =3D as per spec
> > +
> > +5.  The client calls :c:func:`VIDIOC_G_FMT` for CAPTURE to get the new=
 format
> > +    information.
> > +    This is identical to calling :c:func:`VIDIOC_G_FMT` after
> > +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` in the initialization
> > +    sequence and should be handled similarly.
> > +
> > +    .. note::
> > +
> > +       It is allowed for the driver not to support the same
> > +       pixelformat as previously used (before the resolution change)
> > +       for the new resolution. The driver must select a default
> > +       supported pixelformat and return it from :c:func:`VIDIOC_G_FMT`=
, and
> > +       client must take note of it.
> > +
> > +6.  (optional) The client is allowed to enumerate available formats an=
d
> > +    select a different one than currently chosen (returned via
> > +    :c:func:`VIDIOC_G_FMT)`. This is identical to a corresponding step=
 in
> > +    the initialization sequence.
> > +
> > +7.  (optional) The client acquires visible resolution as in
> > +    initialization sequence.
> > +
> > +8.  (optional) The client acquires minimum number of buffers as in
> > +    initialization sequence.
> > +
> > +9.  The client allocates a new set of buffers for the CAPTURE queue vi=
a
> > +    :c:func:`VIDIOC_REQBUFS`. This is identical to a corresponding ste=
p in
> > +    the initialization sequence.
> > +
> > +10. The client resumes decoding by issuing :c:func:`VIDIOC_STREAMON` o=
n the
> > +    CAPTURE queue.
> > +
> > +During the resolution change sequence, the OUTPUT queue must remain
> > +streaming. Calling :c:func:`VIDIOC_STREAMOFF` on OUTPUT queue will ini=
tiate seek.
> > +
> > +The OUTPUT queue operates separately from the CAPTURE queue for the
> > +duration of the entire resolution change sequence. It is allowed (and
> > +recommended for best performance and simplcity) for the client to keep
> > +queuing/dequeuing buffers from/to OUTPUT queue even while processing
> > +this sequence.
> > +
> > +.. note::
> > +
> > +   It is also possible for this sequence to be triggered without
> > +   change in resolution if a different number of CAPTURE buffers is
> > +   required in order to continue decoding the stream.
> > +
> > +Flush
> > +-----
> > +
> > +Flush is the process of draining the CAPTURE queue of any remaining
> > +buffers. After the flush sequence is complete, the client has received
> > +all decoded frames for all OUTPUT buffers queued before the sequence w=
as
> > +started.
> > +
> > +1. Begin flush by issuing :c:func:`VIDIOC_DECODER_CMD`.
> > +
> > +   a. Required fields:
> > +
> > +      i. cmd =3D ``V4L2_DEC_CMD_STOP``
> > +
> > +2. The driver must process and decode as normal all OUTPUT buffers
> > +   queued by the client before the :c:func:`VIDIOC_DECODER_CMD` was
> > +   issued.
> > +   Any operations triggered as a result of processing these
> > +   buffers (including the initialization and resolution change
> > +   sequences) must be processed as normal by both the driver and
> > +   the client before proceeding with the flush sequence.
> > +
> > +3. Once all OUTPUT buffers queued before ``V4L2_DEC_CMD_STOP`` are
> > +   processed:
> > +
> > +   a. If the CAPTURE queue is streaming, once all decoded frames (if
> > +      any) are ready to be dequeued on the CAPTURE queue, the
> > +      driver must send a ``V4L2_EVENT_EOS``. The driver must also
> > +      set ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer` ``flags`` fi=
eld on the
> > +      buffer on the CAPTURE queue containing the last frame (if
> > +      any) produced as a result of processing the OUTPUT buffers
> > +      queued before ``V4L2_DEC_CMD_STOP``. If no more frames are
> > +      left to be returned at the point of handling
> > +      ``V4L2_DEC_CMD_STOP``, the driver must return an empty buffer
> > +      (with :c:type:`v4l2_buffer` ``bytesused`` =3D 0) as the last buf=
fer with
> > +      ``V4L2_BUF_FLAG_LAST`` set instead.
> > +      Any attempts to dequeue more buffers beyond the buffer
> > +      marked with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE
> > +      error from :c:func:`VIDIOC_DQBUF`.
>
> I guess that answers my earlier question on resolution change when
> there are no CAPTURE buffers left to be delivered.
>
> > +   b. If the CAPTURE queue is NOT streaming, no action is necessary fo=
r
> > +      CAPTURE queue and the driver must send a ``V4L2_EVENT_EOS``
> > +      immediately after all OUTPUT buffers in question have been
> > +      processed.
> > +
> > +4. To resume, client may issue ``V4L2_DEC_CMD_START``.
> > +
> > +End of stream
> > +-------------
> > +
> > +When an explicit end of stream is encountered by the driver in the
> > +stream, it must send a ``V4L2_EVENT_EOS`` to the client after all fram=
es
> > +are decoded and ready to be dequeued on the CAPTURE queue, with the
> > +:c:type:`v4l2_buffer` ``flags`` set to ``V4L2_BUF_FLAG_LAST``. This be=
havior is
> > +identical to the flush sequence as if triggered by the client via
> > +``V4L2_DEC_CMD_STOP``.
> > +
> > +Commit points
> > +-------------
> > +
> > +Setting formats and allocating buffers triggers changes in the behavio=
r
> > +of the driver.
> > +
> > +1. Setting format on OUTPUT queue may change the set of formats
> > +   supported/advertised on the CAPTURE queue. It also must change
> > +   the format currently selected on CAPTURE queue if it is not
> > +   supported by the newly selected OUTPUT format to a supported one.
> > +
> > +2. Enumerating formats on CAPTURE queue must only return CAPTURE forma=
ts
> > +   supported for the OUTPUT format currently set.
> > +
> > +3. Setting/changing format on CAPTURE queue does not change formats
> > +   available on OUTPUT queue. An attempt to set CAPTURE format that
> > +   is not supported for the currently selected OUTPUT format must
> > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
> > +
> > +4. Enumerating formats on OUTPUT queue always returns a full set of
> > +   supported formats, irrespective of the current format selected on
> > +   CAPTURE queue.
> > +
> > +5. After allocating buffers on the OUTPUT queue, it is not possible to
> > +   change format on it.
> > +
> > +To summarize, setting formats and allocation must always start with th=
e
> > +OUTPUT queue and the OUTPUT queue is the master that governs the set o=
f
> > +supported formats for the CAPTURE queue.
> > diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/medi=
a/uapi/v4l/v4l2.rst
> > index b89e5621ae69..563d5b861d1c 100644
> > --- a/Documentation/media/uapi/v4l/v4l2.rst
> > +++ b/Documentation/media/uapi/v4l/v4l2.rst
> > @@ -53,6 +53,10 @@ Authors, in alphabetical order:
> >
> >    - Original author of the V4L2 API and documentation.
> >
> > +- Figa, Tomasz <tfiga@chromium.org>
> > +
> > +  - Documented parts of the V4L2 (stateful) Codec Interface. Migrated =
from Google Docs to kernel documentation.
> > +
> >  - H Schimek, Michael <mschimek@gmx.at>
> >
> >    - Original author of the V4L2 API and documentation.
> > @@ -65,6 +69,10 @@ Authors, in alphabetical order:
> >
> >    - Designed and documented the multi-planar API.
> >
> > +- Osciak, Pawel <posciak@chromium.org>
> > +
> > +  - Documented the V4L2 (stateful) Codec Interface.
> > +
> >  - Palosaari, Antti <crope@iki.fi>
> >
> >    - SDR API.
> > @@ -85,7 +93,7 @@ Authors, in alphabetical order:
> >
> >    - Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended =
control ioctls, major parts of the sliced VBI API, the MPEG encoder and dec=
oder APIs and the DV Timings API.
> >
> > -**Copyright** |copy| 1999-2016: Bill Dirks, Michael H. Schimek, Hans V=
erkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Ch=
ehab, Pawel Osciak, Sakari Ailus & Antti Palosaari.
> > +**Copyright** |copy| 1999-2018: Bill Dirks, Michael H. Schimek, Hans V=
erkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Ch=
ehab, Pawel Osciak, Sakari Ailus & Antti Palosaari, Tomasz Figa.
> >
> >  Except when explicitly stated as GPL, programming examples within this
> >  part can be used and distributed without restrictions.
> > @@ -94,6 +102,10 @@ part can be used and distributed without restrictio=
ns.
> >  Revision History
> >  ****************
> >
> > +:revision: TBD / TBD (*tf*)
> > +
> > +Add specification of V4L2 Codec Interface UAPI.
> > +
> >  :revision: 4.10 / 2016-07-15 (*rr*)
> >
> >  Introduce HSV formats.
> > --
> > 2.17.1.1185.g55be947832-goog
>
> Related to an earlier comment, whilst the driver has to support
> multiple instances, there is no arbitration over the overall decode
> rate with regard real-time performance.
> I know our hardware is capable of 1080P60, but there's no easy way to
> stop someone trying to decode 2 1080P60 streams simultaneously. From a
> software perspective it'll do it, but not in real-time. I'd assume
> most other platforms will give the similar behaviour.
> Is it worth adding a note that real-time performance is not guaranteed
> should multiple instances be running simultaneously, or a comment made
> somewhere about expected performance? Or enforce it by knowing the max
> data rates and analysing the level of each stream (please no)?

This is a very interesting problem in general.

I believe we don't really do anything like the latter in Chromium and
if someone tries to play too many videos, they would just start
dropping frames. (Pawel, correct me if I'm wrong.) It's actually
exactly what would happen if one starts too many videos with software
decoder running on CPU (and possibly with less instances).

Best regards,
Tomasz
