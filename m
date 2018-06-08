Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:44651 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbeFHKmZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 06:42:25 -0400
Received: by mail-vk0-f67.google.com with SMTP id x4-v6so7930832vkx.11
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 03:42:25 -0700 (PDT)
Received: from mail-ua0-f172.google.com (mail-ua0-f172.google.com. [209.85.217.172])
        by smtp.gmail.com with ESMTPSA id n4-v6sm1251665uak.30.2018.06.08.03.42.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Jun 2018 03:42:22 -0700 (PDT)
Received: by mail-ua0-f172.google.com with SMTP id s13-v6so5122407uad.2
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 03:42:22 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-2-tfiga@chromium.org>
 <c9904619e466ddc487f6df952e71c56c949f8767.camel@ndufresne.ca>
In-Reply-To: <c9904619e466ddc487f6df952e71c56c949f8767.camel@ndufresne.ca>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 8 Jun 2018 19:42:10 +0900
Message-ID: <CAAFQd5C=Wym_+W_n3kXHKAj8VXQneR+oNH9ct7bpLgTEY1ZZ3g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: nicolas@ndufresne.ca, Pawel Osciak <posciak@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Fri, Jun 8, 2018 at 2:31 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrot=
e:
>
> Thanks Tomasz for this work.
>
> The following is my first read review, please ignore my comments if
> they already have been mentioned by others or discussed, I'll catchup
> on the appropriate threads later on.

Thanks for review!

>
> Le mardi 05 juin 2018 =C3=A0 19:33 +0900, Tomasz Figa a =C3=A9crit :
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
>
> We should probably use HEVC instead of H265, as this is the name we
> have picked for that format.

Ack.

>
> > +expected not to require any additional information from the client to
> > +process these buffers, and to return decoded frames on the CAPTURE que=
ue
> > +in display order.
>
> It might confused some users with the fact that first buffer for non-
> bytestream formats is special and must contain only the headers (VP8/9
> and H264_NO_SC which is also known as H264 AVC, the format used in
> ISOMP4). Also, these formats must be framed by userspace, as it's not
> possible to divide the frames/nal later on. I would suggest to be a bit
> less strict in the introduction here.

I think we need to make a clear boundary between this stateful API and
the to-be-created stateless API. I agree, though, that the wording
might be a bit unfortunate and suggesting that userspace doesn't have
to do anything at all, just feet the buffers with bytes of bitstream.

As for VP8/9, I don't think it is true that the first buffer must
contain only the headers. As far as I can see, mtk-vcodec just keeps
the buffer in the queue for next run and s5p-mfc does the same for
H264 and H264_MVC, but currently has a bug (missing || clause in if)
that makes it not behave this way for VP8/9.

Pawel, any thoughts on this?

[snip]
> > +visible height
> > +   height for given visible resolution
>
> I do believe 'display width/height/resolution' is more common.
>

"Visible" sounds more common for me. :)

I guess we could cross reference one with another.

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
>
> As of today, GStreamer expects an initial state, before the first
> S_FMT(OUTPUT) that results in all possible formats regardless. Later
> on, after S_FMT(OUTPUT) + header buffers has been passed, a new
> enumeration is done, and is expected to return a subset (or the same
> list).

This kind of contradicts with the general principle of V4L2, which
says that there is some format set by default. With the above, that
would mean that e0 and e1 in the example below could be different.

e0 =3D VIDIOC_ENUM_FMT(CAPTURE)

G_FMT(OUTPUT, &x);
S_FMT(OUTPUT, &x);

e1 =3D VIDIOC_ENUM_FMT(CAPTURE)

> If a better output format then the one chosen by the driver is
> found, it will be tried, if not supported, it will simply keep the
> driver selected output format. This way, drivers don't need to do extra
> work if their output format is completely fixed by the input/headers.
> The only upstream driver that have this flexibility is CODA. To be
> fair, we don't in GStreamer need to know about the output format, it's
> simply exposed to fail earlier if users tries to connect to elements
> that are incompatible by nature. We could just remove that initial
> probing and it would still work as expected. I think probing all the
> output format is not that of a good idea, with the profiles and level
> it becomes all very complex.

It would simplify things a lot if we could agree on removing that
initial probing and restricting VIDIOC_ENUM_FMT() to until the
bitstream format is determined.

>
> > +
> > +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect suppo=
rted
> > +   resolutions for a given format, passing its fourcc in
> > +   :c:type:`v4l2_frmivalenum` ``pixel_format``.
>
> Good thing this is a may, since it's all very complex and not that
> useful with the levels and profiles. Userspace can figure-out really if
> needed.

Right...

>
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
> > +
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
> I think we'll need to add a section to help with that one. All drivers
> supports ranges in fps. Venus have this bug were it sets a range with a
> step of 1/1, but because we expose frame intervals instead of
> framerate, the result is not as expected. If you want an interval
> between 1 and 60 fps, that would be from 1/60s to 1/1s, there is no
> valid step that can be used, you are forced to use CONTINUOUS, or
> DISCRETE.

To be honest, I'm not sure what is the meaning of frame rate in case
of an m2m decoder. One thing that comes to my mind is performance
rating, but I wonder if this is something that we should be exposing
here, given that it would only apply to the case when there is only 1
decode instance running (since any further instances would degrade the
performance)...

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
>
> In the introduction, maybe we could say that we use OUTPUT and CAPTURE
> to mean both format (with and without MPLANE ?).
>
> > +
> > +      ii.  fmt.pix_mp.pixelformat set to a coded format
> > +
> > +      iii. fmt.pix_mp.width, fmt.pix_mp.height only if cannot be
> > +           parsed from the stream for the given coded format;
> > +           ignored otherwise;
>
> GStreamer passes the display size, as the display size found in the
> bitstream maybe not match the selected display size by the container
> (e.g. ISOMP4/Matroska). I'm not sure what drivers endup doing, it was
> not really thought through, we later query the selection to know the
> display size. We could follow this new rule by not passing anything and
> then simply picking the smallest from bitstream display size and
> container display size. I'm just giving a reference of what existing
> userspace may be doing at the moment, as we'll have to care about
> breaking existing software when implementing this.

At least in case of H264, it's possible to have display size that
rounded up to nearest macroblocks doesn't give coded size, i.e. there
are some full not-displayed macroblocks. In such case, it wouldn't be
possible to recover coded size from width/height given on OUTPUT, so
I'd suggest defining them as coded size.

>
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
> Ok, that's new, in GStreamer we validate that the format haven't been
> changed. Should be backward compatible though. What we don't do though
> is check back the OUTPUT format after setting the CAPTURE format, that
> would seem totally invalid. You mention that this isn't allowed later
> on, so that's great.
>
> > +
> > +3.  (optional) Get minimum number of buffers required for OUTPUT queue
> > +    via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to u=
se
> > +    more buffers than minimum required by hardware/format (see
> > +    allocation).
>
> I have never seen such restriction on a decoder, though it's optional
> here, so probably fine.

I don't think it's a restriction. I'd call it a hint that allows
userspace to allocate more buffers than strictly required and have
deeper queues. If there is a hardware restriction, it should be
imposed in vb2 .queue_setup() callback by altering the number of
buffers requested from REQBUFS.

>
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
>
> This raises a question, should V4L2_CID_MIN_BUFFERS_FOR_OUTPUT really
> be the minimum, or min+1. Since REQBUFS is likely to allocate min+1 to
> be efficient ? Allocating just the minimum, means that the decoder will
> always be idle while the userspace is handling an output.

It technically still allows the decoding to continue, so I'd leave this as =
is.

>
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
>
> GStreamer still uses legacy path, expecting G_FMT to block if there is
> headers in the queue. Do we want to document this legacy method or not
> ?

Would it break really bad if G_FMT stopped blocking? IMHO the less
legacy behavior, the better, but I'm afraid we need to maintain
compatibility here...

>
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
> > +
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
>
> Should not be optional if the driver have this restriction.

As before, this is not about hardware restrictions (which would be
handled at REQBUFS/queue_setup level), but an optimization hint for
userspace.

>
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
> > +
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
>
> There is no mention of timestamp passing and
> V4L2_BUF_FLAG_TIMESTAMP_COPY. These though are rather important
> respectively to match decoded frames with appropriate metadata and to
> discard stored metadata from the userspace queue.
>
> Unlike the suggestion here, most decoder are frame base, it would be
> nice to check if this is an actual firmware limitation in certain
> cases.

I think those buffers becoming "available on the CAPTURE queue without
additional buffers queued to OUTPUT" would actually result from some
buffers queued to OUTPUT in the past, but being delayed perhaps due to
some nuances of given codec.

Pawel, any further insights?

>
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
>
> I have some doubts that this actually works. What you describe here is
> a flush/reset seqeuence. The drivers I have worked with totally forgets
> about their state after STREAMOFF on any queues. The initialization
> process need to happen again. Though, adding this support with just
> resetting the OUTPUT queue should be backward compatible. GStreamer
> always STREAMOFF on both sides.

I believe this should work with s5p-mfc and mtk-vcodec, +/- the
general bugginess of s5p-mfc stop_streaming handling.

>
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
>
> Also, in practice it is totally un-reliable to start from random point.
>  Some decoder will produce corrupted frame, some will wait, you never
> known. Seek code in ffmpeg, gstreamer, vlc, etc. always pick a good
> sync point. Then marks the extra as "decode only", hence the need for
> matching input/output for metadata, and drops the extra.

Are you sure that drivers of codecs which produce corrupted frames
couldn't be fixed to catch such (by some error signaled from hw) and
not return to userspace?

> > +
> > +      -  The driver is allowed to and may return a number of remaining=
 CAPTURE
> > +         buffers containing decoded frames from before the seek after =
the
> > +         seek sequence (STREAMOFF-STREAMON) is performed.
>
> This is not a proper seek. That's probably why we also streamoff the
> capture queue to get rid of these ancient buffers. This seems only
> useful if you are trying to do seamless seeking (aka non flushing
> seek), which is a very niche use case.

Good point. When user moves the seek bar in the player, we don't care
about the already queued buffers anymore, we just want to start
decoding from the new point as fast as possible.

Pawel, any thoughts?

>
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
> It's a bit more complicated, if the resolution goes bigger, the encoded
> buffer size needed to fit a full frame may be bidger. Reallocation of
> the output queue may be needed. In some memory constraint device, we'll
> also want to reallocate if it's going smaller. FFMPEG implement
> something clever for selected the size, CODA driver does the same but
> in the driver. It's a bit of a mess.
>
> In the long term, for gapless change (specially with CMA) we might want
> to support using larger buffer in the CAPTURE queue to avoid
> reallocation. OMX supports this.

Agreed. Although I wonder if all hardware can equally support it
(s5p-mfc does, though).

>
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
>
> Perhaps the driver should be queried for the new display resolution
> through G_SELECTION ?
>

That's true. Actually, I guess that there might be a case when coded
resolution doesn't change but visible changes.

> > +
> > +Flush
> > +-----
> > +
> > +Flush is the process of draining the CAPTURE queue of any remaining
>
> Ok, call this Drain if it's the process of draining, it's really
> confusing as GStreamer makes a distinction between flush (getting rid
> of, like a reset) and draining (which involved displaying the
> remaining, but stop producing new data).

Drain sounds good to me.

>
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
>
> I have never used the EOS event, and I bet many drivers don't implement
> it, why is that a must ?

Coda, venus, s5p-mfc do. The event is defined for this purpose, so it
should be consistently supported.

>
> > +      set ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer` ``flags`` fi=
eld on the
>
> In MFC we don't know, so we use the other method, EPIPE, there will be
> no FLAG_LAST on MFC, it's just not possible with that firmware. So
> FLAG_LAST is preferred, EPIPE is the fallback.

That's not true. s5p-mfc marks last buffer with V4L2_BUF_FLAG_LAST:
https://elixir.bootlin.com/linux/latest/source/drivers/media/platform/s5p-m=
fc/s5p_mfc.c#L223

We use MFC in production on Exynos 5250 and 5420 devices and it seems
to work fine.

>
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
>
> I never heard of such a thing as an implicit EOS, can you elaborate ?

I think this is about EOS coming from the stream versus EOS coming
from userspace (triggered by CMD_STOP).

>
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
>
> That's great clarification !

As per other replies, we actually should implement the standard
semantics of TRY_/S_FMT and have the driver adjust to a supported
setting.

Best regards,
Tomasz
