Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:42980 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbeJRSEE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 14:04:04 -0400
Received: by mail-yw1-f68.google.com with SMTP id a197-v6so11558811ywh.9
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 03:03:47 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id 132-v6sm4596238ywt.2.2018.10.18.03.03.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 03:03:46 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id 184-v6so11608942ybg.1
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 03:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <9696282.0ldyWdpzWo@avalon>
In-Reply-To: <9696282.0ldyWdpzWo@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 18 Oct 2018 19:03:33 +0900
Message-ID: <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Oct 17, 2018 at 10:34 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> Thank you for the patch.

Thanks for your comments! Please see my replies inline.

>
> On Tuesday, 24 July 2018 17:06:20 EEST Tomasz Figa wrote:
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
> > diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst
> > b/Documentation/media/uapi/v4l/dev-decoder.rst new file mode 100644
> > index 000000000000..f55d34d2f860
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
> > @@ -0,0 +1,872 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _decoder:
> > +
> > +****************************************
> > +Memory-to-memory Video Decoder Interface
> > +****************************************
> > +
> > +Input data to a video decoder are buffers containing unprocessed video
> > +stream (e.g. Annex-B H.264/HEVC stream, raw VP8/9 stream). The driver =
is
> > +expected not to require any additional information from the client to
> > +process these buffers. Output data are raw video frames returned in di=
splay
> > +order.
> > +
> > +Performing software parsing, processing etc. of the stream in the driv=
er
> > +in order to support this interface is strongly discouraged. In case su=
ch
> > +operations are needed, use of Stateless Video Decoder Interface (in
> > +development) is strongly advised.
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
sed
> > +   interchangeably with :c:func:`VIDIOC_G_CTRL`, :c:func:`VIDIOC_S_CTR=
L`,
> > +   unless specified otherwise.
> > +
> > +5. Single-plane API (see spec) and applicable structures may be used
> > +   interchangeably with Multi-plane API, unless specified otherwise,
> > +   depending on driver capabilities and following the general V4L2
> > +   guidelines.
>
> How about also allowing VIDIOC_CREATE_BUFS where VIDIOC_REQBUFS is mentio=
ned ?
>

In my draft of v2, I explicitly described VIDIOC_CREATE_BUFS in any
step mentioning VIDIOC_REQBUFS. Do you think that's fine too?

> > +6. i =3D [a..b]: sequence of integers from a to b, inclusive, i.e. i =
=3D
> > +   [0..2]: i =3D 0, 1, 2.
> > +
> > +7. For ``OUTPUT`` buffer A, A=E2=80=99 represents a buffer on the ``CA=
PTURE`` queue
> > +   containing data (decoded frame/stream) that resulted from processin=
g +
> >  buffer A.
> > +
> > +Glossary
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +CAPTURE
> > +   the destination buffer queue; the queue of buffers containing decod=
ed
> > +   frames; ``V4L2_BUF_TYPE_VIDEO_CAPTURE```` or
> > +   ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``; data are captured from the
> > +   hardware into ``CAPTURE`` buffers
> > +
> > +client
> > +   application client communicating with the driver implementing this =
API
> > +
> > +coded format
> > +   encoded/compressed video bitstream format (e.g. H.264, VP8, etc.); =
see
> > +   also: raw format
> > +
> > +coded height
> > +   height for given coded resolution
> > +
> > +coded resolution
> > +   stream resolution in pixels aligned to codec and hardware requireme=
nts;
> > +   typically visible resolution rounded up to full macroblocks;
> > +   see also: visible resolution
> > +
> > +coded width
> > +   width for given coded resolution
> > +
> > +decode order
> > +   the order in which frames are decoded; may differ from display orde=
r if
> > +   coded format includes a feature of frame reordering; ``OUTPUT`` buf=
fers
> > +   must be queued by the client in decode order
> > +
> > +destination
> > +   data resulting from the decode process; ``CAPTURE``
> > +
> > +display order
> > +   the order in which frames must be displayed; ``CAPTURE`` buffers mu=
st be
> > +   returned by the driver in display order
> > +
> > +DPB
> > +   Decoded Picture Buffer; a H.264 term for a buffer that stores a pic=
ture
> > +   that is encoded or decoded and available for reference in further
> > +   decode/encode steps.
>
> By "encoded or decoded", do you mean "raw frames to be encoded (in the en=
coder
> use case) or decoded raw frames (in the decoder use case)" ? I think this
> should be clarified.
>

Actually it's a decoder-specific term, so changed both decoder and
encoder documents to:

DPB
   Decoded Picture Buffer; an H.264 term for a buffer that stores a decoded
   raw frame available for reference in further decoding steps.

Does it sound better now?

> > +EOS
> > +   end of stream
> > +
> > +IDR
> > +   a type of a keyframe in H.264-encoded stream, which clears the list=
 of
> > +   earlier reference frames (DPBs)
> > +
> > +keyframe
> > +   an encoded frame that does not reference frames decoded earlier, i.=
e.
> > +   can be decoded fully on its own.
> > +
> > +OUTPUT
> > +   the source buffer queue; the queue of buffers containing encoded
> > +   bitstream; ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or
> > +   ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``; the hardware is fed with dat=
a
> > +   from ``OUTPUT`` buffers
> > +
> > +PPS
> > +   Picture Parameter Set; a type of metadata entity in H.264 bitstream
> > +
> > +raw format
> > +   uncompressed format containing raw pixel data (e.g. YUV, RGB format=
s)
> > +
> > +resume point
> > +   a point in the bitstream from which decoding may start/continue, wi=
thout
> > +   any previous state/data present, e.g.: a keyframe (VP8/VP9) or +
> > SPS/PPS/IDR sequence (H.264); a resume point is required to start decod=
e +
> >  of a new stream, or to resume decoding after a seek
> > +
> > +source
> > +   data fed to the decoder; ``OUTPUT``
> > +
> > +SPS
> > +   Sequence Parameter Set; a type of metadata entity in H.264 bitstrea=
m
> > +
> > +visible height
> > +   height for given visible resolution; display height
> > +
> > +visible resolution
> > +   stream resolution of the visible picture, in pixels, to be used for
> > +   display purposes; must be smaller or equal to coded resolution;
> > +   display resolution
> > +
> > +visible width
> > +   width for given visible resolution; display width
> > +
> > +Querying capabilities
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. To enumerate the set of coded formats supported by the driver, the
> > +   client may call :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
> > +
> > +   * The driver must always return the full set of supported formats,
> > +     irrespective of the format set on the ``CAPTURE``.
> > +
> > +2. To enumerate the set of supported raw formats, the client may call
> > +   :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
> > +
> > +   * The driver must return only the formats supported for the format
> > +     currently active on ``OUTPUT``.
> > +
> > +   * In order to enumerate raw formats supported by a given coded form=
at,
> > +     the client must first set that coded format on ``OUTPUT`` and the=
n
> > +     enumerate the ``CAPTURE`` queue.
>
> Maybe s/enumerate the/enumerate formats on the/ ?
>
> > +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect suppo=
rted
> > +   resolutions for a given format, passing desired pixel format in
> > +   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT``
> > +     must include all possible coded resolutions supported by the deco=
der
> > +     for given coded pixel format.
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE`=
`
> > +     must include all possible frame buffer resolutions supported by t=
he
> > +     decoder for given raw pixel format and coded format currently set=
 on
> > +     ``OUTPUT``.
> > +
> > +    .. note::
> > +
> > +       The client may derive the supported resolution range for a
> > +       combination of coded and raw format by setting width and height=
 of
> > +       ``OUTPUT`` format to 0 and calculating the intersection of
> > +       resolutions returned from calls to :c:func:`VIDIOC_ENUM_FRAMESI=
ZES`
> > +       for the given coded and raw formats.
>
> I'm confused by the note, I'm not sure to understand what you mean.
>

I'm actually going to remove this. This special case of 0 width and
height is not only ugly, but also wouldn't work with decoders that
actually can do scaling, because the scaling ratio range is often
constant, so the supported scaled frame sizes depend on the exact
coded format.

> > +4. Supported profiles and levels for given format, if applicable, may =
be
> > +   queried using their respective controls via :c:func:`VIDIOC_QUERYCT=
RL`.
> > +
> > +Initialization
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. *[optional]* Enumerate supported ``OUTPUT`` formats and resolutions=
. See
> > +   capability enumeration.
> > +
> > +2. Set the coded format on ``OUTPUT`` via :c:func:`VIDIOC_S_FMT`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     ``pixelformat``
> > +         a coded pixel format
> > +
> > +     ``width``, ``height``
> > +         required only if cannot be parsed from the stream for the giv=
en
> > +         coded format; optional otherwise - set to zero to ignore
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * For coded formats including stream resolution information, if wid=
th
> > +     and height are set to non-zero values, the driver will propagate =
the
> > +     resolution to ``CAPTURE`` and signal a source change event
> > +     instantly.
>
> Maybe s/instantly/immediately before returning from :c:func:`VIDIOC_S_FMT=
`/ ?
>
> > However, after the decoder is done parsing the
> > +     information embedded in the stream, it will update ``CAPTURE``
>
> s/update/update the/
>
> > +     format with new values and signal a source change event again, if
>
> s/, if/ if/
>
> > +     the values do not match.
> > +
> > +   .. note::
> > +
> > +      Changing ``OUTPUT`` format may change currently set ``CAPTURE``
>
> Do you have a particular dislike for definite articles ? :-) I would have
> written "Changing the ``OUTPUT`` format may change the currently set
> ``CAPTURE`` ...". I won't repeat the comment through the whole review, bu=
t
> many places seem to be missing a definite article.

Saving the^Wworld bandwidth one "the " at a time. ;)

Hans also pointed some of those and I should have most of the missing
ones added in my draft of v2. Thanks.

>
> > +      format. The driver will derive a new ``CAPTURE`` format from
> > +      ``OUTPUT`` format being set, including resolution, colorimetry
> > +      parameters, etc. If the client needs a specific ``CAPTURE`` form=
at,
> > +      it must adjust it afterwards.
> > +
> > +3.  *[optional]* Get minimum number of buffers required for ``OUTPUT``
> > +    queue via :c:func:`VIDIOC_G_CTRL`. This is useful if client intend=
s to
> > +    use more buffers than minimum required by hardware/format.
> > +
> > +    * **Required fields:**
> > +
> > +      ``id``
> > +          set to ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
> > +
> > +    * **Return fields:**
> > +
> > +      ``value``
> > +          required number of ``OUTPUT`` buffers for the currently set
> > +          format
>
> s/required/required minimum/

I made it "the minimum number of [...] buffers required".

>
> > +
> > +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` o=
n
> > +    ``OUTPUT``.
> > +
> > +    * **Required fields:**
> > +
> > +      ``count``
> > +          requested number of buffers to allocate; greater than zero
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +      ``memory``
> > +          follows standard semantics
> > +
> > +      ``sizeimage``
> > +          follows standard semantics; the client is free to choose any
> > +          suitable size, however, it may be subject to change by the
> > +          driver
> > +
> > +    * **Return fields:**
> > +
> > +      ``count``
> > +          actual number of buffers allocated
> > +
> > +    * The driver must adjust count to minimum of required number of
> > +      ``OUTPUT`` buffers for given format and count passed.
>
> Isn't it the maximum, not the minimum ?
>

It's actually neither. All we can generally say here is that the
number will be adjusted and the client must note it.

> > The client must
> > +      check this value after the ioctl returns to get the number of
> > +      buffers allocated.
> > +
> > +    .. note::
> > +
> > +       To allocate more than minimum number of buffers (for pipeline
> > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to
> > +       get minimum number of buffers required by the driver/format,
> > +       and pass the obtained value plus the number of additional
> > +       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
> > +
> > +5.  Start streaming on ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`.
> > +
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
> That's a pretty harsh handling for this condition. What's the rationale f=
or
> returning -EPERM instead of for instance succeeding with width and height=
 set
> to 0 ?

I don't like it, but the error condition must stay for compatibility
reasons as that's what current drivers implement and applications
expect. (Technically current drivers would return -EINVAL, but we
concluded that existing applications don't care about the exact value,
so we can change it to make more sense.)

>
> > +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` events =
and
> > +      the event is signaled, the decoding process will not continue un=
til
> > +      it is acknowledged by either (re-)starting streaming on ``CAPTUR=
E``,
> > +      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START``
> > +      command.
> > +
> > +    .. note::
> > +
> > +       No decoded frames are produced during this phase.
> > +
> > +7.  This step only applies to coded formats that contain resolution
> > +    information in the stream.
> > +    Receive and handle ``V4L2_EVENT_SOURCE_CHANGE`` from the driver
> > +    via :c:func:`VIDIOC_DQEVENT`. The driver must send this event once
> > +    enough data is obtained from the stream to allocate ``CAPTURE``
> > +    buffers and to begin producing decoded frames.
>
> Doesn't the last sentence belong to step 6 (where it's already explained =
to
> some extent) ?
>
> > +
> > +    * **Required fields:**
> > +
> > +      ``type``
> > +          set to ``V4L2_EVENT_SOURCE_CHANGE``
>
> Isn't the type field set by the driver ?
>
> > +    * **Return fields:**
> > +
> > +      ``u.src_change.changes``
> > +          set to ``V4L2_EVENT_SRC_CH_RESOLUTION``
> > +
> > +    * Any client query issued after the driver queues the event must r=
eturn
> > +      values applying to the just parsed stream, including queue forma=
ts,
> > +      selection rectangles and controls.
>
> To align with the wording used so far, I would say that "the driver must"
> return values applying to the just parsed stream.
>
> I think I would also move this to step 6, as it's related to queuing the
> event, not dequeuing it.

As I've rephrased the whole document to be more userspace-oriented,
this step is actually going away. Step 6 will have a note about driver
behavior.

>
> > +8.  Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get format fo=
r the
> > +    destination buffers parsed/decoded from the bitstream.
> > +
> > +    * **Required fields:**
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +    * **Return fields:**
> > +
> > +      ``width``, ``height``
> > +          frame buffer resolution for the decoded frames
> > +
> > +      ``pixelformat``
> > +          pixel format for decoded frames
> > +
> > +      ``num_planes`` (for _MPLANE ``type`` only)
> > +          number of planes for pixelformat
> > +
> > +      ``sizeimage``, ``bytesperline``
> > +          as per standard semantics; matching frame buffer format
> > +
> > +    .. note::
> > +
> > +       The value of ``pixelformat`` may be any pixel format supported =
and
> > +       must be supported for current stream, based on the information
> > +       parsed from the stream and hardware capabilities. It is suggest=
ed
> > +       that driver chooses the preferred/optimal format for given
>
> In compliance with RFC 2119, how about using "Drivers should choose" inst=
ead
> of "It is suggested that driver chooses" ?

The whole paragraph became:

       The value of ``pixelformat`` may be any pixel format supported by th=
e
       decoder for the current stream. It is expected that the decoder choo=
ses
       a preferred/optimal format for the default configuration. For exampl=
e, a
       YUV format may be preferred over an RGB format, if additional conver=
sion
       step would be required.

>
> > +       configuration. For example, a YUV format may be preferred over =
an
> > +       RGB format, if additional conversion step would be required.
> > +
> > +9.  *[optional]* Enumerate ``CAPTURE`` formats via
> > +    :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE`` queue. Once the stream
> > +    information is parsed and known, the client may use this ioctl to
> > +    discover which raw formats are supported for given stream and sele=
ct on
>
> s/select on/select one/

Done.

>
> > +    of them via :c:func:`VIDIOC_S_FMT`.
> > +
> > +    .. note::
> > +
> > +       The driver will return only formats supported for the current s=
tream
> > +       parsed in this initialization sequence, even if more formats ma=
y be
> > +       supported by the driver in general.
> > +
> > +       For example, a driver/hardware may support YUV and RGB formats =
for
> > +       resolutions 1920x1088 and lower, but only YUV for higher
> > +       resolutions (due to hardware limitations). After parsing
> > +       a resolution of 1920x1088 or lower, :c:func:`VIDIOC_ENUM_FMT` m=
ay
> > +       return a set of YUV and RGB pixel formats, but after parsing
> > +       resolution higher than 1920x1088, the driver will not return RG=
B,
> > +       unsupported for this resolution.
> > +
> > +       However, subsequent resolution change event triggered after
> > +       discovering a resolution change within the same stream may swit=
ch
> > +       the stream into a lower resolution and :c:func:`VIDIOC_ENUM_FMT=
`
> > +       would return RGB formats again in that case.
> > +
> > +10.  *[optional]* Choose a different ``CAPTURE`` format than suggested=
 via
> > +     :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for t=
he
> > +     client to choose a different format than selected/suggested by th=
e
>
> And here, "A client may choose" ?
>
> > +     driver in :c:func:`VIDIOC_G_FMT`.
> > +
> > +     * **Required fields:**
> > +
> > +       ``type``
> > +           a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +       ``pixelformat``
> > +           a raw pixel format
> > +
> > +     .. note::
> > +
> > +        Calling :c:func:`VIDIOC_ENUM_FMT` to discover currently availa=
ble
> > +        formats after receiving ``V4L2_EVENT_SOURCE_CHANGE`` is useful=
 to
> > +        find out a set of allowed formats for given configuration, but=
 not
> > +        required, if the client can accept the defaults.
>
> s/required/required,/

That would become "[...]but not required,, if the client[...]". Is
that your suggestion? ;)

>
> > +
> > +11. *[optional]* Acquire visible resolution via
> > +    :c:func:`VIDIOC_G_SELECTION`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``target``
> > +          set to ``V4L2_SEL_TGT_COMPOSE``
> > +
> > +    * **Return fields:**
> > +
> > +      ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > +          visible rectangle; this must fit within frame buffer resolut=
ion
> > +          returned by :c:func:`VIDIOC_G_FMT`.
> > +
> > +    * The driver must expose following selection targets on ``CAPTURE`=
`:
> > +
> > +      ``V4L2_SEL_TGT_CROP_BOUNDS``
> > +          corresponds to coded resolution of the stream
> > +
> > +      ``V4L2_SEL_TGT_CROP_DEFAULT``
> > +          a rectangle covering the part of the frame buffer that conta=
ins
> > +          meaningful picture data (visible area); width and height wil=
l be
> > +          equal to visible resolution of the stream
> > +
> > +      ``V4L2_SEL_TGT_CROP``
> > +          rectangle within coded resolution to be output to ``CAPTURE`=
`;
> > +          defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``; read-only on hard=
ware
> > +          without additional compose/scaling capabilities
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> > +          maximum rectangle within ``CAPTURE`` buffer, which the cropp=
ed
> > +          frame can be output into; equal to ``V4L2_SEL_TGT_CROP``, if=
 the
> > +          hardware does not support compose/scaling
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
> > +          equal to ``V4L2_SEL_TGT_CROP``
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE``
> > +          rectangle inside ``OUTPUT`` buffer into which the cropped fr=
ame
>
> s/OUTPUT/CAPTURE/ ?
>
> > +          is output; defaults to ``V4L2_SEL_TGT_COMPOSE_DEFAULT``;
>
> and "is captured" or "is written" ?
>
> > +          read-only on hardware without additional compose/scaling
> > +          capabilities
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE_PADDED``
> > +          rectangle inside ``OUTPUT`` buffer which is overwritten by t=
he
>
> Here too ?
>
> > +          hardware; equal to ``V4L2_SEL_TGT_COMPOSE``, if the hardware
>
> s/, if/ if/

Ack +3

>
> > +          does not write padding pixels
> > +
> > +12. *[optional]* Get minimum number of buffers required for ``CAPTURE`=
`
> > +    queue via :c:func:`VIDIOC_G_CTRL`. This is useful if client intend=
s to
> > +    use more buffers than minimum required by hardware/format.
> > +
> > +    * **Required fields:**
> > +
> > +      ``id``
> > +          set to ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
> > +
> > +    * **Return fields:**
> > +
> > +      ``value``
> > +          minimum number of buffers required to decode the stream pars=
ed in
> > +          this initialization sequence.
> > +
> > +    .. note::
> > +
> > +       Note that the minimum number of buffers must be at least the nu=
mber
> > +       required to successfully decode the current stream. This may fo=
r
> > +       example be the required DPB size for an H.264 stream given the
> > +       parsed stream configuration (resolution, level).
> > +
> > +13. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQB=
UFS`
> > +    on the ``CAPTURE`` queue.
> > +
> > +    * **Required fields:**
> > +
> > +      ``count``
> > +          requested number of buffers to allocate; greater than zero
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``memory``
> > +          follows standard semantics
> > +
> > +    * **Return fields:**
> > +
> > +      ``count``
> > +          adjusted to allocated number of buffers
> > +
> > +    * The driver must adjust count to minimum of required number of
>
> s/minimum/maximum/ ?
>
> Should we also mentioned that if count > minimum, the driver may addition=
ally
> limit the number of buffers based on internal limits (such as maximum mem=
ory
> consumption) ?

I made it less specific:

    * The count will be adjusted by the decoder to match the stream and har=
dware
      requirements. The client must check the final value after the ioctl
      returns to get the number of buffers allocated.

>
> > +      destination buffers for given format and stream configuration an=
d the
> > +      count passed. The client must check this value after the ioctl
> > +      returns to get the number of buffers allocated.
> > +
> > +    .. note::
> > +
> > +       To allocate more than minimum number of buffers (for pipeline
> > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``) to
> > +       get minimum number of buffers required, and pass the obtained v=
alue
> > +       plus the number of additional buffers needed in count to
> > +       :c:func:`VIDIOC_REQBUFS`.
> > +
> > +14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
> > +
> > +Decoding
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This state is reached after a successful initialization sequence. In t=
his
> > +state, client queues and dequeues buffers to both queues via
> > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
> > +semantics.
> > +
> > +Both queues operate independently, following standard behavior of V4L2
> > +buffer queues and memory-to-memory devices. In addition, the order of
> > +decoded frames dequeued from ``CAPTURE`` queue may differ from the ord=
er of
> > +queuing coded frames to ``OUTPUT`` queue, due to properties of selecte=
d
> > +coded format, e.g. frame reordering. The client must not assume any di=
rect
> > +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
> > +reported by :c:type:`v4l2_buffer` ``timestamp`` field.
> > +
> > +The contents of source ``OUTPUT`` buffers depend on active coded pixel
> > +format and might be affected by codec-specific extended controls, as s=
tated
>
> s/might/may/
>
> > +in documentation of each format individually.
> > +
> > +The client must not assume any direct relationship between ``CAPTURE``
> > +and ``OUTPUT`` buffers and any specific timing of buffers becoming
> > +available to dequeue. Specifically:
> > +
> > +* a buffer queued to ``OUTPUT`` may result in no buffers being produce=
d
> > +  on ``CAPTURE`` (e.g. if it does not contain encoded data, or if only
> > +  metadata syntax structures are present in it),
> > +
> > +* a buffer queued to ``OUTPUT`` may result in more than 1 buffer produ=
ced
> > +  on ``CAPTURE`` (if the encoded data contained more than one frame, o=
r if
> > +  returning a decoded frame allowed the driver to return a frame that
> > +  preceded it in decode, but succeeded it in display order),
> > +
> > +* a buffer queued to ``OUTPUT`` may result in a buffer being produced =
on
> > +  ``CAPTURE`` later into decode process, and/or after processing furth=
er
> > +  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
> > +  reordering is used,
> > +
> > +* buffers may become available on the ``CAPTURE`` queue without additi=
onal
>
> s/buffers/Buffers/
>

I don't think the items should be capitalized here.

> > +  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because=
 of
> > +  ``OUTPUT`` buffers being queued in the past and decoding result of w=
hich
> > +  being available only at later time, due to specifics of the decoding
> > +  process.
>
> I understand what you mean, but the wording is weird to my eyes. How abou=
t
>
> * Buffers may become available on the ``CAPTURE`` queue without additiona=
l
> buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because of
> ``OUTPUT`` buffers queued in the past whose decoding results are only
> available at later time, due to specifics of the decoding process.

Done, thanks.

>
> > +Seek
> > +=3D=3D=3D=3D
> > +
> > +Seek is controlled by the ``OUTPUT`` queue, as it is the source of
> > +bitstream data. ``CAPTURE`` queue remains unchanged/unaffected.
>
> I assume that a seek may result in a source resolution change event, in w=
hich
> case the capture queue will be affected. How about stating here that
> controlling seek doesn't require any specific operation on the capture qu=
eue,
> but that the capture queue may be affected as per normal decoder operatio=
n ?
> We may also want to mention the event as an example.

Done. I've also added a general section about decoder-initialized
sequences in the Decoding section.

>
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
>
> What do you mean by "a state after seek" ?
>

   * The decoder will start accepting new source bitstream buffers after th=
e
     call returns.

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
>
> s/stream/buffers/ ?

Perhaps "stream data"? The buffers don't have a resume point, the stream do=
es.

>
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
> This should be true for any hardware, there should never be any crash or =
fatal
> decode error. I'd write it as
>
> Some hardware is known to mishandle seeks to a non-resume point. Such an
> operation may result in an unspecified number of corrupted decoded frames
> being made available on ``CAPTURE``. Drivers must ensure that no fatal
> decoding errors or crashes occur, and implement any necessary handling an=
d
> work-arounds for hardware issues related to seek operations.
>

Done.

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
>
> s/is allowed to and may/may/
>
> > +       ``CAPTURE`` buffers containing decoded frames from before the s=
eek
> > +       after the seek sequence (STREAMOFF-STREAMON) is performed.
>
> Shouldn't all these buffers be returned when STREAMOFF is called on the O=
UTPUT
> side ?

The queues are independent, so STREAMOFF on OUTPUT would only return
the OUTPUT buffers.

That's why there is the note suggesting that the application may also
stop streaming on CAPTURE to avoid stale frames being returned.

>
> > +     * The driver is also allowed to and may not return all decoded fr=
ames
>
> s/is also allowed to and may not return/may also not return/
>
> > +       queued but not decode before the seek sequence was initiated. F=
or
>
> s/not decode/not decoded/
>
> > +       example, given an ``OUTPUT`` queue sequence: QBUF(A), QBUF(B),
> > +       STREAMOFF(OUT), STREAMON(OUT), QBUF(G), QBUF(H), any of the
> > +       following results on the ``CAPTURE`` queue is allowed: {A=E2=80=
=99, B=E2=80=99, G=E2=80=99,
> > +       H=E2=80=99}, {A=E2=80=99, G=E2=80=99, H=E2=80=99}, {G=E2=80=99,=
 H=E2=80=99}.
>
> Related to the previous point, shouldn't this be moved to step 1 ?

I've made it a general warning after the whole sequence.

>
> > +   .. note::
> > +
> > +      To achieve instantaneous seek, the client may restart streaming =
on
> > +      ``CAPTURE`` queue to discard decoded, but not yet dequeued buffe=
rs.
> > +
> > +Pause
> > +=3D=3D=3D=3D=3D
> > +
> > +In order to pause, the client should just cease queuing buffers onto t=
he
> > +``OUTPUT`` queue. This is different from the general V4L2 API definiti=
on of
> > +pause, which involves calling :c:func:`VIDIOC_STREAMOFF` on the queue.
> > +Without source bitstream data, there is no data to process and the
> > hardware +remains idle.
> > +
> > +Conversely, using :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue indic=
ates
> > +a seek, which
> > +
> > +1. drops all ``OUTPUT`` buffers in flight and
> > +2. after a subsequent :c:func:`VIDIOC_STREAMON`, will look for and onl=
y
> > +   continue from a resume point.
> > +
> > +This is usually undesirable for pause. The STREAMOFF-STREAMON sequence=
 is
> > +intended for seeking.
> > +
> > +Similarly, ``CAPTURE`` queue should remain streaming as well, as the
> > +STREAMOFF-STREAMON sequence on it is intended solely for changing buff=
er
> > +sets.
>
> And also to drop decoded buffers for instant seek ?
>

I've dropped the Pause section completely. It doesn't provide any
useful information IMHO and only doubles with the general semantics of
mem2mem devices.

> > +Dynamic resolution change
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > +
> > +A video decoder implementing this interface must support dynamic resol=
ution
> > +change, for streams, which include resolution metadata in the bitstrea=
m.
>
> s/for streams, which/for streams that/
>
> > +When the decoder encounters a resolution change in the stream, the dyn=
amic
> > +resolution change sequence is started.
> > +
> > +1.  After encountering a resolution change in the stream, the driver m=
ust
> > +    first process and decode all remaining buffers from before the
> > +    resolution change point.
> > +
> > +2.  After all buffers containing decoded frames from before the resolu=
tion
> > +    change point are ready to be dequeued on the ``CAPTURE`` queue, th=
e
> > +    driver sends a ``V4L2_EVENT_SOURCE_CHANGE`` event for source chang=
e
> > +    type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > +
> > +    * The last buffer from before the change must be marked with
> > +      :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as i=
n the
> > +      drain sequence. The last buffer might be empty (with
> > +      :c:type:`v4l2_buffer` ``bytesused`` =3D 0) and must be ignored b=
y the
> > +      client, since it does not contain any decoded frame.
> > +
> > +    * Any client query issued after the driver queues the event must r=
eturn
> > +      values applying to the stream after the resolution change, inclu=
ding
> > +      queue formats, selection rectangles and controls.
> > +
> > +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` events =
and
> > +      the event is signaled, the decoding process will not continue un=
til
> > +      it is acknowledged by either (re-)starting streaming on ``CAPTUR=
E``,
> > +      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START``
> > +      command.
>
> This usage of V4L2_DEC_CMD_START isn't aligned with the documentation of =
the
> command. I'm not opposed to this, but I think the use cases of decoder
> commands for codecs should be explained in the VIDIOC_DECODER_CMD
> documentation. What bothers me in particular is usage of V4L2_DEC_CMD_STA=
RT to
> restart the decoder, while no V4L2_DEC_CMD_STOP has been issued. Should w=
e add
> a section that details the decoder state machine with the implicit and
> explicit ways in which it is started and stopped ?

Yes, we should probably extend the VIDIOC_DECODER_CMD documentation.

As for diagrams, they would indeed be nice to have, but maybe we could
add them in a follow up patch?

>
> I would also reference step 7 here.
>
> > +    .. note::
> > +
> > +       Any attempts to dequeue more buffers beyond the buffer marked
> > +       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > +       :c:func:`VIDIOC_DQBUF`.
> > +
> > +3.  The client calls :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` to get the=
 new
> > +    format information. This is identical to calling :c:func:`VIDIOC_G=
_FMT`
> > +    after ``V4L2_EVENT_SRC_CH_RESOLUTION`` in the initialization seque=
nce
> > +    and should be handled similarly.
>
> As the source resolution change event is mentioned in multiple places, ho=
w
> about extracting the related ioctls sequence to a specific section, and
> referencing it where needed (at least from the initialization sequence an=
d
> here) ?

I made the text here refer to the Initialization sequence.

>
> > +    .. note::
> > +
> > +       It is allowed for the driver not to support the same pixel form=
at as
>
> "Drivers may not support ..."
>
> > +       previously used (before the resolution change) for the new
> > +       resolution. The driver must select a default supported pixel fo=
rmat,
> > +       return it, if queried using :c:func:`VIDIOC_G_FMT`, and the cli=
ent
> > +       must take note of it.
> > +
> > +4.  The client acquires visible resolution as in initialization sequen=
ce.
> > +
> > +5.  *[optional]* The client is allowed to enumerate available formats =
and
>
> s/is allowed to/may/
>
> > +    select a different one than currently chosen (returned via
> > +    :c:func:`VIDIOC_G_FMT)`. This is identical to a corresponding step=
 in
> > +    the initialization sequence.
> > +
> > +6.  *[optional]* The client acquires minimum number of buffers as in
> > +    initialization sequence.
> > +
> > +7.  If all the following conditions are met, the client may resume the
> > +    decoding instantly, by using :c:func:`VIDIOC_DECODER_CMD` with
> > +    ``V4L2_DEC_CMD_START`` command, as in case of resuming after the d=
rain
> > +    sequence:
> > +
> > +    * ``sizeimage`` of new format is less than or equal to the size of
> > +      currently allocated buffers,
> > +
> > +    * the number of buffers currently allocated is greater than or equ=
al to
> > +      the minimum number of buffers acquired in step 6.
> > +
> > +    In such case, the remaining steps do not apply.
> > +
> > +    However, if the client intends to change the buffer set, to lower
> > +    memory usage or for any other reasons, it may be achieved by follo=
wing
> > +    the steps below.
> > +
> > +8.  After dequeuing all remaining buffers from the ``CAPTURE`` queue,
>
> This is optional, isn't it ?
>

I wouldn't call it optional, since it depends on what the client does
and what the decoder supports. That's why the point above just states
that the remaining steps do not apply.

Also added a note:

       To fulfill those requirements, the client may attempt to use
       :c:func:`VIDIOC_CREATE_BUFS` to add more buffers. However, due to
       hardware limitations, the decoder may not support adding buffers at =
this
       point and the client must be able to handle a failure using the step=
s
       below.

> > the
> > +    client must call :c:func:`VIDIOC_STREAMOFF` on the ``CAPTURE`` que=
ue.
> > +    The ``OUTPUT`` queue must remain streaming (calling STREAMOFF on i=
t
>
> :c:func:`VIDIOC_STREAMOFF`
>
> > +    would trigger a seek).
> > +
> > +9.  The client frees the buffers on the ``CAPTURE`` queue using
> > +    :c:func:`VIDIOC_REQBUFS`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``count``
> > +          set to 0
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``memory``
> > +          follows standard semantics
> > +
> > +10. The client allocates a new set of buffers for the ``CAPTURE`` queu=
e via
> > +    :c:func:`VIDIOC_REQBUFS`. This is identical to a corresponding ste=
p in
> > +    the initialization sequence.
> > +
> > +11. The client resumes decoding by issuing :c:func:`VIDIOC_STREAMON` o=
n the
> > +    ``CAPTURE`` queue.
> > +
> > +During the resolution change sequence, the ``OUTPUT`` queue must remai=
n
> > +streaming. Calling :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue woul=
d
> > +initiate a seek.
> > +
> > +The ``OUTPUT`` queue operates separately from the ``CAPTURE`` queue fo=
r the
> > +duration of the entire resolution change sequence. It is allowed (and
> > +recommended for best performance and simplicity) for the client to kee=
p
>
> "The client should (for best performance and simplicity) keep ..."
>
> > +queuing/dequeuing buffers from/to ``OUTPUT`` queue even while processi=
ng
>
> s/from\to/to\/from/
>
> > +this sequence.
> > +
> > +.. note::
> > +
> > +   It is also possible for this sequence to be triggered without a cha=
nge
>
> "This sequence may be triggered ..."
>
> > +   in coded resolution, if a different number of ``CAPTURE`` buffers i=
s
> > +   required in order to continue decoding the stream or the visible
> > +   resolution changes.
> > +
> > +Drain
> > +=3D=3D=3D=3D=3D
> > +
> > +To ensure that all queued ``OUTPUT`` buffers have been processed and
> > +related ``CAPTURE`` buffers output to the client, the following drain
> > +sequence may be followed. After the drain sequence is complete, the cl=
ient
> > +has received all decoded frames for all ``OUTPUT`` buffers queued befo=
re
> > +the sequence was started.
> > +
> > +1. Begin drain by issuing :c:func:`VIDIOC_DECODER_CMD`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``cmd``
> > +         set to ``V4L2_DEC_CMD_STOP``
> > +
> > +     ``flags``
> > +         set to 0
> > +
> > +     ``pts``
> > +         set to 0
> > +
> > +2. The driver must process and decode as normal all ``OUTPUT`` buffers
> > +   queued by the client before the :c:func:`VIDIOC_DECODER_CMD` was is=
sued.
> > +   Any operations triggered as a result of processing these buffers
> > +   (including the initialization and resolution change sequences) must=
 be
> > +   processed as normal by both the driver and the client before procee=
ding
> > +   with the drain sequence.
> > +
> > +3. Once all ``OUTPUT`` buffers queued before ``V4L2_DEC_CMD_STOP`` are
> > +   processed:
> > +
> > +   * If the ``CAPTURE`` queue is streaming, once all decoded frames (i=
f
> > +     any) are ready to be dequeued on the ``CAPTURE`` queue, the drive=
r
> > +     must send a ``V4L2_EVENT_EOS``.
>
> s/\./event./
>
> Is the event sent on the OUTPUT or CAPTURE queue ? I assume the latter, s=
hould
> it be explicitly documented ?
>

AFAICS, there is no queue type indication in the v4l2_event struct.

In any case, I've removed this event, because existing drivers don't
implement it for the drain sequence and it also makes it more
consistent, since events would be only signaled for decoder-initiated
sequences. It would also allow distinguishing between an EOS mark in
the stream (event signaled) or end of a drain sequence (no event).

> > The driver must also set
> > +     ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer` ``flags`` field o=
n the
> > +     buffer on the ``CAPTURE`` queue containing the last frame (if any=
)
> > +     produced as a result of processing the ``OUTPUT`` buffers queued
> > +     before ``V4L2_DEC_CMD_STOP``. If no more frames are left to be
> > +     returned at the point of handling ``V4L2_DEC_CMD_STOP``, the driv=
er
> > +     must return an empty buffer (with :c:type:`v4l2_buffer`
> > +     ``bytesused`` =3D 0) as the last buffer with ``V4L2_BUF_FLAG_LAST=
`` set
> > +     instead. Any attempts to dequeue more buffers beyond the buffer m=
arked
> > +     with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > +     :c:func:`VIDIOC_DQBUF`.
> > +
> > +   * If the ``CAPTURE`` queue is NOT streaming, no action is necessary=
 for
> > +     ``CAPTURE`` queue and the driver must send a ``V4L2_EVENT_EOS``
> > +     immediately after all ``OUTPUT`` buffers in question have been
> > +     processed.
>
> What is the use case for this ? Can't we just return an error if decoder =
isn't
> streaming ?
>

Actually this is wrong. We want the queued OUTPUT buffers to be
processed and decoded, so if the CAPTURE queue is not yet set up
(initialization sequence not completed yet), handling the
initialization sequence first will be needed as a part of the drain
sequence. I've updated the document with that.

> > +4. At this point, decoding is paused and the driver will accept, but n=
ot
> > +   process any newly queued ``OUTPUT`` buffers until the client issues
> > +   ``V4L2_DEC_CMD_START`` or restarts streaming on any queue.
> > +
> > +* Once the drain sequence is initiated, the client needs to drive it t=
o
> > +  completion, as described by the above steps, unless it aborts the pr=
ocess
> > +  by issuing :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue.  The clie=
nt
> > +  is not allowed to issue ``V4L2_DEC_CMD_START`` or ``V4L2_DEC_CMD_STO=
P``
> > +  again while the drain sequence is in progress and they will fail wit=
h
> > +  -EBUSY error code if attempted.
>
> While this seems OK to me, I think drivers will need help to implement al=
l the
> corner cases correctly without race conditions.

We went through the possible list of corner cases and concluded that
there is no use in handling them, especially considering how much they
would complicate both the userspace and the drivers. Not even
mentioning some hardware, like s5p-mfc, which actually has a dedicated
flush operation, that needs to complete before the decoder can switch
back to normal mode.

>
> > +* Restarting streaming on ``OUTPUT`` queue will implicitly end the pau=
sed
> > +  state and reinitialize the decoder (similarly to the seek sequence).
> > +  Restarting ``CAPTURE`` queue will not affect an in-progress drain
> > +  sequence.
> > +
> > +* The drivers must also implement :c:func:`VIDIOC_TRY_DECODER_CMD`, as=
 a
> > +  way to let the client query the availability of decoder commands.
> > +
> > +End of stream
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +If the decoder encounters an end of stream marking in the stream, the
> > +driver must send a ``V4L2_EVENT_EOS`` event
>
> On which queue ?
>

Hmm?

> > to the client after all frames
> > +are decoded and ready to be dequeued on the ``CAPTURE`` queue, with th=
e
> > +:c:type:`v4l2_buffer` ``flags`` set to ``V4L2_BUF_FLAG_LAST``. This
> > +behavior is identical to the drain sequence triggered by the client vi=
a
> > +``V4L2_DEC_CMD_STOP``.
> > +
> > +Commit points
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Setting formats and allocating buffers triggers changes in the behavio=
r
>
> s/triggers/trigger/
>
> > +of the driver.
> > +
> > +1. Setting format on ``OUTPUT`` queue may change the set of formats
> > +   supported/advertised on the ``CAPTURE`` queue. In particular, it al=
so
> > +   means that ``CAPTURE`` format may be reset and the client must not
> > +   rely on the previously set format being preserved.
> > +
> > +2. Enumerating formats on ``CAPTURE`` queue must only return formats
> > +   supported for the ``OUTPUT`` format currently set.
> > +
> > +3. Setting/changing format on ``CAPTURE`` queue does not change format=
s
>
> Why not just "Setting format" ?
>
> > +   available on ``OUTPUT`` queue. An attempt to set ``CAPTURE`` format=
 that
> > +   is not supported for the currently selected ``OUTPUT`` format must
> > +   result in the driver adjusting the requested format to an acceptabl=
e
> > +   one.
> > +
> > +4. Enumerating formats on ``OUTPUT`` queue always returns the full set=
 of
> > +   supported coded formats, irrespective of the current ``CAPTURE``
> > +   format.
> > +
> > +5. After allocating buffers on the ``OUTPUT`` queue, it is not possibl=
e to
> > +   change format on it.
>
> I'd phrase this as
>
> "While buffers are allocated on the ``OUTPUT`` queue, clients must not ch=
ange
> the format on the queue. Drivers must return <error code> for any such fo=
rmat
> change attempt."

Done, thanks.

Best regards,
Tomasz
