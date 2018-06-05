Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:43691 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbeFENmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 09:42:32 -0400
Received: by mail-ua0-f195.google.com with SMTP id z16-v6so1634383uaz.10
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 06:42:31 -0700 (PDT)
Received: from mail-ua0-f175.google.com (mail-ua0-f175.google.com. [209.85.217.175])
        by smtp.gmail.com with ESMTPSA id h47-v6sm47081202uaa.13.2018.06.05.06.42.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Jun 2018 06:42:29 -0700 (PDT)
Received: by mail-ua0-f175.google.com with SMTP id 59-v6so1645542uas.5
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 06:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-2-tfiga@chromium.org>
 <1528198888.4074.13.camel@pengutronix.de>
In-Reply-To: <1528198888.4074.13.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 5 Jun 2018 22:42:16 +0900
Message-ID: <CAAFQd5BKdqPWVREeuprWS43kPz7XZR5buiPUZY5UKhaaQCMOBg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Pawel Osciak <posciak@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
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

Hi Philipp,

Thanks a lot for review.

On Tue, Jun 5, 2018 at 8:41 PM Philipp Zabel <p.zabel@pengutronix.de> wrote=
:
>
> Hi Tomasz,
>
> On Tue, 2018-06-05 at 19:33 +0900, Tomasz Figa wrote:
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
> > +
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
> > +
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
>
> Is this a must-implement for drivers? coda currently doesn't implement
> enum-framesizes.

I'll leave this to Pawel. This might be one of the things that we
didn't get to implement in upstream in the end.

>
> > +
> > +   a. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for coded =
formats
> > +      must be maximums for given coded format for all supported raw
> > +      formats.
>
> I don't understand what maximums means in this context.
>
> If I have a decoder that can decode from 16x16 up to 1920x1088, should
> this return a continuous range from minimum frame size to maximum frame
> size?

Looks like the wording here is a bit off. It should be as you say +/-
alignment requirements, which can be specified by using
v4l2_frmsize_stepwise. Hardware that supports only a fixed set of
resolutions (if such exists), should use v4l2_frmsize_discrete.
Basically this should follow the standard description of
VIDIOC_ENUM_FRAMESIZES.

>
> > +   b. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for raw fo=
rmats must
> > +      be maximums for given raw format for all supported coded
> > +      formats.
>
> Same here, this is unclear to me.

Should be as above, i.e. according to standard operation of
VIDIOC_ENUM_FRAMESIZES.

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
>
> Same as above, is this must-implement for decoder drivers?

Leaving this to Pawel.

>
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
>
> When this is set, does this also update the format on the CAPTURE queue
> (i.e. would G_FMT(CAP), S_FMT(OUT), G_FMT(CAP) potentially return
> different CAP formats?) I think this should be explained here.

Yes, it would. Agreed that it should be explicitly mentioned here.

>
> What about colorimetry, does setting colorimetry here overwrite
> colorimetry information that may potentially be contained in the stream?

I'd say that if the hardware/driver can't report such information,
CAPTURE queue should report V4L2_COLORSPACE_DEFAULT and userspace
should take care of determining the right one (or using a default one)
on its own. This would eliminate the need to set anything on OUTPUT
queue.

Actually, when I think of it now, I wonder if we really should be
setting resolution here for bitstream formats that don't include
resolution, rather than on CAPTURE queue. Pawel, could you clarify
what was the intention here?

>
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
> > +
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
> What about devices that have a frame buffer registration step before
> stream start? For coda I need to know all CAPTURE buffers before I can
> start streaming, because there is no way to register them after
> STREAMON. Do I have to split the driver internally to do streamoff and
> restart when the capture queue is brought up?

Do you mean that the hardware requires registering framebuffers before
the headers are parsed and resolution is detected? That sounds quite
unusual.

Other drivers would:
1) parse the header on STREAMON(OUTPUT),
2) report resolution to userspace,
3) have framebuffers allocated in REQBUFS(CAPTURE),
4) register framebuffers in STREAMON(CAPTURE).

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
> > +
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
>
> This text is specific to multiplanar queues, what about singleplanar
> drivers?

Should be the same. There was "+5. Single-plane API (see spec) and
applicable structures may be used interchangeably with Multi-plane
API, unless specified otherwise." mentioned at the beginning of the
documentation, but I guess we could just make the description generic
instead.

>
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
> Typo, "The value ..."

Thanks, will fix.

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
> > +
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
>
> What about colorimetry? Should this and TRY_FMT only allow colorimetry
> that is parsed from the stream, if available, or that was set via
> S_FMT(OUT) as an override?

I'd say this depend on the hardware. If it can convert the video into
desired color space, it could be allowed.

>
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
>
> Isn't CROP supposed to be set on the OUTPUT queue only and COMPOSE on
> the CAPTURE queue?

Why? Both CROP and COMPOSE can be used on any queue, if supported by
given interface.

However, on codecs, since OUTPUT queue is a bitstream, I don't think
selection makes sense there.

> I would expect COMPOSE/COMPOSE_DEFAULT to be set to the visible
> rectangle and COMPOSE_PADDED to be set to the rectangle that the
> hardware actually overwrites.

Yes, that's a good point. I'd also say that CROP/CROP_DEFAULT should
be set to the visible rectangle as well, to allow adding handling for
cases when the hardware can actually do further cropping.

>
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
> > +
> > +Source OUTPUT buffers must contain:
> > +
> > +-  H.264/AVC: one or more complete NALUs of an Annex B elementary
> > +   stream; one buffer does not have to contain enough data to decode
> > +   a frame;
>
> What if the hardware only supports handling complete frames?

Pawel, could you help with this?

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
>
> Does this mean that to achieve instantaneous seeks the driver has to
> flush its CAPTURE queue internally when a seek is issued?

That's a good point. I'd say that we might actually want the userspace
to restart the capture queue in such case. Pawel, do you have any
opinion on this?

>
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
>
> What about pending CAPTURE buffers that the client may not yet have
> dequeued?

Just as written here: nothing happens to them, since the "CAPTURE
queue remains unchanged/unaffected". :)

>
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
>
> Oh, ok. That answers my last question above.
>
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
> > +remains idle. Conversely, using :c:func:`VIDIOC_STREAMOFF` on OUTPUT q=
ueue
> > +indicates a seek, which 1) drops all buffers in flight and 2) after a
>
> "... 1) drops all OUTPUT buffers in flight ... " ?

Yeah, although it's kind of inferred from the standard behavior of
VIDIOC_STREAMOFF on given queue.

>
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
>
> Must all drivers support dynamic resolution change?

I'd say no, but I guess that would mean that the driver never
encounters it, because hardware wouldn't report it.

I wonder would happen in such case, though. Obviously decoding of such
stream couldn't continue without support in the driver.

>
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
> > +
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
>
> What about the OUTPUT queue resolution, does it change as well?

There shouldn't be resolution associated with OUTPUT queue, because
pixel format is bitstream, not raw frame.

>
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
>
> Can steps 4. and 5. be done in reverse order (i.e. first G_FMT and then
> REQBUFS(0))?
> If the client already has buffers allocated that are large enough to
> contain decoded buffers in the new resolution, it might be preferable to
> just keep them instead of reallocating.

I think we had some thoughts on similar cases. Pawel, do you recall
what was the problem?

I agree though, that it would make sense to keep the buffers, if they
are big enough.

>
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
> > +
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
>
> Ok. Is the same true about the contained colorimetry? What should happen
> if the stream contains colorimetry information that differs from
> S_FMT(OUT) colorimetry?

As I explained close to the top, IMHO we shouldn't be setting
colorimetry on OUTPUT queue.

>
> > +2. Enumerating formats on CAPTURE queue must only return CAPTURE forma=
ts
> > +   supported for the OUTPUT format currently set.
> > +
> > +3. Setting/changing format on CAPTURE queue does not change formats
> > +   available on OUTPUT queue. An attempt to set CAPTURE format that
> > +   is not supported for the currently selected OUTPUT format must
> > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
>
> Is this limited to the pixel format? Surely setting out of bounds
> width/height or incorrect colorimetry should not result in EINVAL but
> still be corrected by the driver?

That doesn't sound right to me indeed. The driver should fix up
S_FMT(CAPTURE), including pixel format or anything else. It must only
not alter OUTPUT settings.

>
> > +4. Enumerating formats on OUTPUT queue always returns a full set of
> > +   supported formats, irrespective of the current format selected on
> > +   CAPTURE queue.
> > +
> > +5. After allocating buffers on the OUTPUT queue, it is not possible to
> > +   change format on it.
>
> So even after source change events the OUTPUT queue still keeps the
> initial OUTPUT format?

It would basically only have pixelformat (fourcc) assigned to it,
since bitstream formats are not video frames, but just sequences of
bytes. I don't think it makes sense to change e.g. from H264 to VP8
during streaming.

Best regards,
Tomasz
