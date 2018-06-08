Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:33398 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeFHJDv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 05:03:51 -0400
Received: by mail-ua0-f194.google.com with SMTP id m21-v6so8434354uan.0
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 02:03:51 -0700 (PDT)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com. [209.85.213.51])
        by smtp.gmail.com with ESMTPSA id y43-v6sm11407608uah.39.2018.06.08.02.03.48
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Jun 2018 02:03:48 -0700 (PDT)
Received: by mail-vk0-f51.google.com with SMTP id d74-v6so7499508vke.10
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 02:03:48 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-2-tfiga@chromium.org>
 <83bebfbc-6cd4-fb9b-48c3-7b82846837be@xs4all.nl>
In-Reply-To: <83bebfbc-6cd4-fb9b-48c3-7b82846837be@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 8 Jun 2018 18:03:36 +0900
Message-ID: <CAAFQd5Dd_ehFJxLVakprRgA+W-adkRhB=QY1wcz=Of0=OpX3Dg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
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

Hi Hans,

On Thu, Jun 7, 2018 at 5:48 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Tomasz,
>
> First of all: thank you very much for working on this. It's a big missing=
 piece of
> information, so filling this in is very helpful.

Thanks for review!

>
> On 06/05/2018 12:33 PM, Tomasz Figa wrote:
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
> To what extent does the information in this patch series apply specifical=
ly to
> video (de)compression hardware and to what extent it is applicable for an=
y m2m
> device? It looks like most if not all is specific to video (de)compressio=
n hw
> and not to e.g. a simple deinterlacer.

It is specifically written for stateful codecs, i.e. those that can
work on bitstream directly.

>
> Ideally there would be a common section first describing the requirements=
 for
> all m2m devices, followed by an encoder and decoder section going into de=
tails
> for those specific devices.

I wonder if we can say too much in general about "all m2m devices".
The simple m2m devices (scalers, deinterlacers) do not have much in
common with codecs that operate in a quite complicated manner (and so
need all the things defined below).

This brings quite an interesting question of whether we can really
call such simple m2m device "a V4L2 codec" as the original text of
dev-codec.rst does. I guess it depends on the convention we agree on,
but I personally have only heard the term "codec" in context of
audio/video/etc. compression.

>
> I also think that we need an additional paragraph somewhere at the beginn=
ing
> of the Codec Interface chapter that explains more clearly that OUTPUT buf=
fers
> send data to the hardware to be processed and that CAPTURE buffers contai=
ns
> the processed data. It is always confusing for newcomers to understand th=
at
> in V4L2 this is seen from the point of view of the CPU.

I believe this is included in the glossary below, although using a
slightly different wording that doesn't involve CPU.

[snip]
> > +
> > +EOS
> > +   end of stream
> > +
> > +input height
> > +   height in pixels for given input resolution
>
> 'input' is a confusing name. Because I think this refers to the resolutio=
n
> set for the OUTPUT buffer. How about renaming this to 'source'?
>
> I.e.: an OUTPUT buffer contains the source data for the hardware. The cap=
ture
> buffer contains the sink data from the hardware.

Yes, indeed, "source" sounds more logical.

>
> > +
> > +input resolution
> > +   resolution in pixels of source frames being input
>
> "source resolution
>         resolution in pixels of source frames passed"
>
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
>
> "OUTPUT buffers allocated..."

Ack.

>
> > +
> > +source queue
> > +   queue containing buffers used for source data, i.e.
>
> Line suddenly ends.
>
> I'd say: "queue containing OUTPUT buffers"

Ack.

[snip]
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
> This needs to be documented in S_FMT as well.
>
> What will TRY_FMT do? Return EINVAL as well, or replace the pixelformat?
>
> Should this be a general rule for output devices that S_FMT (and perhaps =
TRY_FMT)
> fail with EINVAL if the pixelformat is not supported? There is something =
to be
> said for that.

I think this was covered by other reviewers already and I believe we
should stick to the general semantics of TRY_/S_FMT, which are
specified to never return error if unsupported values are given (and
silently adjust to supported ones). I don't see any reason to make
codecs different from that - userspace can just check if the pixel
format matches what was set.

[snip]
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
> I dislike EINVAL here. It is too generic. Also, the passed arguments can =
be
> perfectly valid, you just aren't in the right state. EPERM might be bette=
r.

The problem of hardware that can't parse the resolution or software
that wants to pre-allocate buffers was brought up in different
replies. I think we might want to revise this in general, but I agree
that EPERM sounds better than EINVAL in this context.

>
> > +
> > +6.  This step only applies for coded formats that contain resolution
> > +    information in the stream.
> > +    Continue queuing/dequeuing bitstream buffers to/from the
> > +    OUTPUT queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`.=
 The driver
> > +    must keep processing and returning each buffer to the client
> > +    until required metadata to send a ``V4L2_EVENT_SOURCE_CHANGE``
> > +    for source change type ``V4L2_EVENT_SRC_CH_RESOLUTION`` is
> > +    found.
>
> This sentence is confusing. It's not clear what you mean here.

The point is that userspace needs to keep providing new bitstream data
until the header can be parsed.

>
>  There is no requirement to pass enough data for this to
> > +    occur in the first buffer and the driver must be able to
> > +    process any number
>
> Missing period at the end of the sentence.
>
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
>
> EPERM?

Ack. +/- the problem of userspace that wants to pre-allocate CAPTURE queue.

Although when I think of it now, such userspace would set coded
resolution on OUTPUT queue and then driver could instantly signal
source change event on CAPTURE queue even before the hardware finishes
the parsing. If what the hardware parses doesn't match what the
userspace set, yet another event would be signaled.

>
> > +
> > +    .. note::
> > +
> > +       No decoded frames are produced during this phase.
> > +
> > +7.  This step only applies for coded formats that contain resolution
>
> applies to  (same elsewhere)
>
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
>
> Or replace it with a supported format. I'm inclined to do that instead of
> returning EINVAL.

Agreed.

>
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
>
> I don't think this is the right selection target to use, but I think othe=
rs
> commented on that already.

Yes, Philipp brought this topic before and we had some further
exchange on it, which I think would benefit from you taking a look. :)

>
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
>
> Is DPB in the glossary?

Need to add indeed.

[snip]
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
>
> SPS, keyframe: are they in the glossary?

Will add.

[snip]
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
>
> Drivers should set the V4L2_DEC_CMD_STOP_IMMEDIATELY flag since I doubt a=
ny
> m2m driver supports stopping at a specific pts.

The documentation says:

"If V4L2_DEC_CMD_STOP_IMMEDIATELY is set, then the decoder stops
immediately (ignoring the pts value), otherwise it will keep decoding
until timestamp >=3D pts or until the last of the pending data from its
internal buffers was decoded."

also for the pts field:

"Stop playback at this pts or immediately if the playback is already
past that timestamp. Leave to 0 if you want to stop after the last
frame was decoded."

What we want the decoder to do here is to "keep decoding [...] until
the last of the pending data from its internal buffers was decoded",
which looks like something happening exactly without
V4L2_DEC_CMD_STOP_IMMEDIATELY when pts is set to 0.

>
> They should also support VIDIOC_DECODER_CMD_TRY!

Agreed.

>
> You can probably make default implementations in v4l2-mem2mem.c since the=
 only
> thing that I expect is supported is the STOP command with the STOP_IMMEDI=
ATELY
> flag set.

Is there any useful case for STOP_IMMEDIATELY with m2m decoders? The
only thing I can think of is some kind of power management trick that
could stop the decoder until the client collect enough OUTPUT buffers
to make it process in longer batch. Still, that could be done by the
client just holding on with QBUF(OUTPUT) until enough data to fill the
desired number of buffers is collected.

[snip]
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
> > +   available on OUTPUT queue.
>
> True.
>
>  An attempt to set CAPTURE format that
> > +   is not supported for the currently selected OUTPUT format must
> > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
>
> I'm not sure about that. I believe it is valid to replace it with the
> first supported pixelformat. TRY_FMT certainly should do that.

As above, we probably should stay consistent with general semantics.

Best regards,
Tomasz
