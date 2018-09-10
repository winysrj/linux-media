Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57020 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbeIJRSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 13:18:35 -0400
Message-ID: <1c8d4fee5e9092c0c986e28e4650389672a67781.camel@collabora.com>
Subject: Re: [RFC PATCH] media: docs-rst: Document m2m stateless video
 decoder interface
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Date: Mon, 10 Sep 2018 08:24:37 -0400
In-Reply-To: <CAAFQd5ALyeeru36zVYjG6P2U_JWMgxiv0WPnF2DD2OHHd+nHbQ@mail.gmail.com>
References: <20180831074743.235010-1-acourbot@chromium.org>
         <CAAFQd5ALyeeru36zVYjG6P2U_JWMgxiv0WPnF2DD2OHHd+nHbQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-+yCSlYsKV5npbmcsj9FP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-+yCSlYsKV5npbmcsj9FP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 10 septembre 2018 =C3=A0 16:17 +0900, Tomasz Figa a =C3=A9crit :
> Hi Alex,
>=20
> +Maxime Ripard +Ezequiel Garcia +Nicolas Dufresne
>=20
> [Not snipping intentionally.]
>=20
> On Fri, Aug 31, 2018 at 4:48 PM Alexandre Courbot <acourbot@chromium.org>=
 wrote:
> >=20
> > This patch documents the protocol that user-space should follow when
> > communicating with stateless video decoders. It is based on the
> > following references:
> >=20
> > * The current protocol used by Chromium (converted from config store to
> >   request API)
> >=20
> > * The submitted Cedrus VPU driver
> >=20
> > As such, some things may not be entirely consistent with the current
> > state of drivers, so it would be great if all stakeholders could point
> > out these inconsistencies. :)
> >=20
> > This patch is supposed to be applied on top of the Request API V18 as
> > well as the memory-to-memory video decoder interface series by Tomasz
> > Figa.
> >=20
> > It should be considered an early RFC.
>=20
> Thanks a lot. I think this gives us a much better start already than
> what we had with stateful API without any documentation. :)
>=20
> Please see my comments inline.
>=20
> >=20
> > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > ---
> >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 413 ++++++++++++++++++
> >  Documentation/media/uapi/v4l/devices.rst      |   1 +
> >  .../media/uapi/v4l/extended-controls.rst      |  23 +
> >  3 files changed, 437 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.=
rst
> >=20
> > diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/D=
ocumentation/media/uapi/v4l/dev-stateless-decoder.rst
> > new file mode 100644
> > index 000000000000..bf7b13a8ee16
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > @@ -0,0 +1,413 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _stateless_decoder:
> > +
> > +**************************************************
> > +Memory-to-memory Stateless Video Decoder Interface
> > +**************************************************
> > +
> > +A stateless decoder is a decoder that works without retaining any kind=
 of state
> > +between processing frames. This means that each frame is decoded indep=
endently
> > +of any previous and future frames, and that the client is responsible =
for
> > +maintaining the decoding state and providing it to the driver. This is=
 in
> > +contrast to the stateful video decoder interface, where the hardware m=
aintains
> > +the decoding state and all the client has to do is to provide the raw =
encoded
> > +stream.
> > +
> > +This section describes how user-space ("the client") is expected to co=
mmunicate
> > +with such decoders in order to successfully decode an encoded stream. =
Compared
> > +to stateful codecs, the driver/client protocol is simpler, but cost of=
 this
> > +simplicity is extra complexity in the client which must maintain the d=
ecoding
> > +state.
> > +
> > +Querying capabilities
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. To enumerate the set of coded formats supported by the driver, the =
client
> > +   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
> > +
> > +   * The driver must always return the full set of supported formats f=
or the
> > +     currently set ``OUTPUT`` format, irrespective of the format curre=
ntly set
> > +     on the ``CAPTURE`` queue.
> > +
> > +2. To enumerate the set of supported raw formats, the client calls
> > +   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
> > +
> > +   * The driver must return only the formats supported for the format =
currently
> > +     active on the ``OUTPUT`` queue.
> > +
> > +   * In order to enumerate raw formats supported by a given coded form=
at, the
> > +     client must thus set that coded format on the ``OUTPUT`` queue fi=
rst, and
> > +     then enumerate the ``CAPTURE`` queue.
>=20
> One thing that we might want to note here is that available CAPTURE
> formats may depend on more factors than just current OUTPUT format.
> Depending on encoding options of the stream being decoded (e.g. VP9
> profile), the list of supported format might be limited to one of YUV
> 4:2:0, 4:2:2 or 4:4:4 family of formats, but might be any of them, if
> the hardware supports conversion.
>=20
> I was wondering whether we shouldn't require the client to set all the
> necessary initial codec-specific controls before querying CAPTURE
> formats, but since we don't have any compatibility constraints here,
> as opposed to the stateful API, perhaps we could just make CAPTURE
> queue completely independent and have a source change event raised if
> the controls set later make existing format invalid.
>=20
> I'd like to ask the userspace folks here (Nicolas?), whether:
> 1) we need to know the exact list of formats that are guaranteed to be
> supported for playing back the whole video, or
> 2) we're okay with some rough approximation here, or
> 3) maybe we don't even need to enumerate formats on CAPTURE beforehand?

While Gst do try and make an initial list of formats before setting the
capture sink format (for stateful case), I don't think this is really
required. So specially for stateless, feel free to require a format,
level, profile, tier, etc. before one can enumerate the formats. I will
likely drop that initial probe in a near future, it also speed up the
startup time.

>=20
> To be honest, I'm not sure 1) is even possible, since the resolution
> (or some other stream parameters) could change mid-stream.
>=20
> > +
> > +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect suppo=
rted
> > +   resolutions for a given format, passing desired pixel format in
> > +   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT``=
 queue
> > +     must include all possible coded resolutions supported by the deco=
der
> > +     for given coded pixel format.
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE`=
` queue
> > +     must include all possible frame buffer resolutions supported by t=
he
> > +     decoder for given raw pixel format and coded format currently set=
 on
> > +     ``OUTPUT`` queue.
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
> > +
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
> > +2. Set the coded format on the ``OUTPUT`` queue via :c:func:`VIDIOC_S_=
FMT`
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
> > +         parsed width and height of the coded format
>=20
> Perhaps "coded width and height parsed from the stream" could be a bit
> more clear?
>=20
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   .. note::
> > +
> > +      Changing ``OUTPUT`` format may change currently set ``CAPTURE``
> > +      format. The driver will derive a new ``CAPTURE`` format from
> > +      ``OUTPUT`` format being set, including resolution, colorimetry
> > +      parameters, etc. If the client needs a specific ``CAPTURE`` form=
at,
> > +      it must adjust it afterwards.
> > +
> > +3. *[optional]* Get minimum number of buffers required for ``OUTPUT``
> > +   queue via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends=
 to
> > +   use more buffers than minimum required by hardware/format.
> > +
> > +   * **Required fields:**
> > +
> > +     ``id``
> > +         set to ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
> > +
> > +   * **Return fields:**
> > +
> > +     ``value``
> > +         required number of ``OUTPUT`` buffers for the currently set
> > +         format
>=20
> I'm not very sure if this is useful for stateless API, but no strong opin=
ion.
>=20
> > +
> > +4. Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get format for=
 the
> > +   destination buffers parsed/decoded from the bitstream.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +   * **Return fields:**
> > +
> > +     ``width``, ``height``
> > +         frame buffer resolution for the decoded frames
> > +
> > +     ``pixelformat``
> > +         pixel format for decoded frames
> > +
> > +     ``num_planes`` (for _MPLANE ``type`` only)
> > +         number of planes for pixelformat
> > +
> > +     ``sizeimage``, ``bytesperline``
> > +         as per standard semantics; matching frame buffer format
> > +
> > +   .. note::
> > +
> > +      The value of ``pixelformat`` may be any pixel format supported f=
or the
> > +      ``OUTPUT`` format, based on the hardware capabilities. It is sug=
gested
> > +      that driver chooses the preferred/optimal format for given confi=
guration.
> > +      For example, a YUV format may be preferred over an RGB format, i=
f
> > +      additional conversion step would be required.
> > +
> > +5. *[optional]* Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_ENUM=
_FMT` on
> > +   ``CAPTURE`` queue. The client may use this ioctl to discover which
> > +   alternative raw formats are supported for the current ``OUTPUT`` fo=
rmat and
> > +   select one of them via :c:func:`VIDIOC_S_FMT`.
> > +
> > +   .. note::
> > +
> > +      The driver will return only formats supported for the currently =
selected
> > +      ``OUTPUT`` format, even if more formats may be supported by the =
driver in
> > +      general.
> > +
> > +      For example, a driver/hardware may support YUV and RGB formats f=
or
> > +      resolutions 1920x1088 and lower, but only YUV for higher resolut=
ions (due
> > +      to hardware limitations). After setting a resolution of 1920x108=
8 or lower
> > +      as the ``OUTPUT`` format, :c:func:`VIDIOC_ENUM_FMT` may return a=
 set of
> > +      YUV and RGB pixel formats, but after setting a resolution higher=
 than
> > +      1920x1088, the driver will not return RGB, unsupported for this
> > +      resolution.
> > +
> > +6. *[optional]* Choose a different ``CAPTURE`` format than suggested v=
ia
> > +   :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for the=
 client to
> > +   choose a different format than selected/suggested by the driver in
> > +   :c:func:`VIDIOC_G_FMT`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``pixelformat``
> > +          a raw pixel format
> > +
> > +    .. note::
> > +
> > +       Calling :c:func:`VIDIOC_ENUM_FMT` to discover currently availab=
le
> > +       formats after receiving ``V4L2_EVENT_SOURCE_CHANGE`` is useful =
to find
> > +       out a set of allowed formats for given configuration, but not r=
equired,
> > +       if the client can accept the defaults.
>=20
> V4L2_EVENT_SOURCE_CHANGE was not mentioned in earlier steps. I suppose
> it's a leftover from the stateful API? :)
>=20
> Still, I think we may eventually need source change events, because of
> the reasons I mentioned above.
>=20
> > +
> > +7. *[optional]* Get minimum number of buffers required for ``CAPTURE``=
 queue via
> > +   :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to use mo=
re buffers
> > +   than minimum required by hardware/format.
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
ed in this
> > +          initialization sequence.
> > +
> > +    .. note::
> > +
> > +       Note that the minimum number of buffers must be at least the nu=
mber
> > +       required to successfully decode the current stream. This may fo=
r example
> > +       be the required DPB size for an H.264 stream given the parsed s=
tream
> > +       configuration (resolution, level).
>=20
> I'm not sure if this really makes sense for stateless API, because DPB
> management is done by the client, so it already has all the data to
> know how many buffers would be needed/optimal.
>=20
> > +
> > +8. Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on
> > +   ``OUTPUT`` queue.
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
> > +    * The driver must adjust count to minimum of required number of ``=
OUTPUT``
> > +      buffers for given format and count passed. The client must check=
 this
> > +      value after the ioctl returns to get the number of buffers alloc=
ated.
> > +
> > +    .. note::
> > +
> > +       To allocate more than minimum number of buffers (for pipeline d=
epth), use
> > +       G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to get minimum numb=
er of
> > +       buffers required by the driver/format, and pass the obtained va=
lue plus
> > +       the number of additional buffers needed in count to
> > +       :c:func:`VIDIOC_REQBUFS`.
> > +
> > +9. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQBU=
FS` on the
> > +   ``CAPTURE`` queue.
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
> > +10. Allocate requests (likely one per ``OUTPUT`` buffer) via
> > +    :c:func:`MEDIA_IOC_REQUEST_ALLOC` on the media device.
> > +
> > +11. Start streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
> > +    :c:func:`VIDIOC_STREAMON`.
> > +
> > +Decoding
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +For each frame, the client is responsible for submitting a request to =
which the
> > +following is attached:
> > +
> > +* Exactly one frame worth of encoded data in a buffer submitted to the
> > +  ``OUTPUT`` queue,
>=20
> Just to make sure, in case of H.264, that would include all the slices
> of the frame in one buffer, right?
>=20
> > +* All the controls relevant to the format being decoded (see below for=
 details).
> > +
> > +``CAPTURE`` buffers must not be part of the request, but must be queue=
d
> > +independently. The driver will pick one of the queued ``CAPTURE`` buff=
ers and
> > +decode the frame into it. Although the client has no control over whic=
h
> > +``CAPTURE`` buffer will be used with a given ``OUTPUT`` buffer, it is =
guaranteed
> > +that ``CAPTURE`` buffers will be returned in decode order (i.e. the sa=
me order
> > +as ``OUTPUT`` buffers were submitted), so it is trivial to associate a=
 dequeued
> > +``CAPTURE`` buffer to its originating request and ``OUTPUT`` buffer.
> > +
> > +If the request is submitted without an ``OUTPUT`` buffer or if one of =
the
> > +required controls are missing, then :c:func:`MEDIA_REQUEST_IOC_QUEUE` =
will return
> > +``-EINVAL``.
>=20
> As per some of the other discussion threads we had before (and I
> linked to in my previous reply), we might want one of the following:
> 1) precisely define the list of controls needed with the
> fine-granularity of all possible stream feature combinations,
> 2) make only some very basic controls mandatory and never fail if
> other controls are not specified.
>=20
> IMHO 2) has a potential to lead to userspace relying on undefined
> behavior with some controls not being set (for
> laziness/simplicity/whatever excuse the author can think of), so I'd
> personally go with 1)...
>=20
> > Decoding errors are signaled by the ``CAPTURE`` buffers being
> > +dequeued carrying the ``V4L2_BUF_FLAG_ERROR`` flag.
> > +
> > +The contents of source ``OUTPUT`` buffers, as well as the controls tha=
t must be
> > +set on the request, depend on active coded pixel format and might be a=
ffected by
> > +codec-specific extended controls, as stated in documentation of each f=
ormat
> > +individually.
> > +
> > +MPEG-2 buffer content and controls
> > +----------------------------------
> > +The following information is valid when the ``OUTPUT`` queue is set to=
 the
> > +``V4L2_PIX_FMT_MPEG2_SLICE`` format.
>=20
> Perhaps we should document the controls there instead? I think that
> was the conclusion from the discussions over the stateful API.
>=20
> > +
> > +The ``OUTPUT`` buffer must contain all the macroblock slices of a give=
n frame,
> > +i.e. if a frame requires several macroblock slices to be entirely deco=
ded, then
> > +all these slices must be provided. In addition, the following controls=
 must be
> > +set on the request:
> > +
> > +V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS
> > +   Slice parameters (one per slice) for the current frame.
> > +
>=20
> How do we know how many slices are included in current frame?
>=20
> > +Optional controls:
> > +
> > +V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION
> > +   Quantization matrices for the current frame.
>=20
> What happens if it's not specified?
>=20
> > +
> > +H.264 buffer content and controls
> > +---------------------------------
> > +The following information is valid when the ``OUTPUT`` queue is set to=
 the
> > +``V4L2_PIX_FMT_H264_SLICE`` format.
>=20
> Ditto.
>=20
> > +
> > +The ``OUTPUT`` buffer must contain all the macroblock slices of a give=
n frame,
> > +i.e. if a frame requires several macroblock slices to be entirely deco=
ded, then
> > +all these slices must be provided. In addition, the following controls=
 must be
> > +set on the request:
> > +
> > +V4L2_CID_MPEG_VIDEO_H264_SPS
> > +   Instance of struct v4l2_ctrl_h264_sps, containing the SPS of to use=
 with the
> > +   frame.
> > +
> > +V4L2_CID_MPEG_VIDEO_H264_PPS
> > +   Instance of struct v4l2_ctrl_h264_pps, containing the PPS of to use=
 with the
> > +   frame.
> > +
> > +V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX
> > +   Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the sc=
aling
> > +   matrix to use when decoding the frame.
> > +
> > +V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM
> > +   Array of struct v4l2_ctrl_h264_slice_param, containing at least as =
many
> > +   entries as there are slices in the corresponding ``OUTPUT`` buffer.
> > +
> > +V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM
> > +   Instance of struct v4l2_ctrl_h264_decode_param, containing the high=
-level
> > +   decoding parameters for a H.264 frame.
> > +
> > +Seek
> > +=3D=3D=3D=3D
> > +In order to seek, the client just needs to submit requests using input=
 buffers
> > +corresponding to the new stream position. It must however be aware tha=
t
> > +resolution may have changed and follow the dynamic resolution change p=
rotocol in
>=20
> nit: We tend to call it "sequence" rather than "protocol" in other docume=
nts.
>=20
> > +that case. Also depending on the codec used, picture parameters (e.g. =
SPS/PPS
> > +for H.264) may have changed and the client is responsible for making s=
ure that
> > +a valid state is sent to the kernel.
> > +
> > +The client is then free to ignore any returned ``CAPTURE`` buffer that=
 comes
> > +from the pre-seek position.
> > +
> > +Pause
> > +=3D=3D=3D=3D=3D
> > +
> > +In order to pause, the client should just cease queuing buffers onto t=
he
> > +``OUTPUT`` queue. This is different from the general V4L2 API definiti=
on of
> > +pause, which involves calling :c:func:`VIDIOC_STREAMOFF` on the queue.
> > +Without source bitstream data, there is no data to process and the har=
dware
> > +remains idle.
>=20
> This behavior is by design of memory-to-memory devices, so I'm not
> sure we really need this section. Perhaps we could move it to a
> separate document which explains m2m basics.
>=20
> > +
> > +Dynamic resolution change
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > +
> > +If the client detects a resolution change in the stream, it may need t=
o
> > +reallocate the ``CAPTURE`` buffers to fit the new size.
> > +
> > +1. Wait until all submitted requests have completed and dequeue the
> > +   corresponding output buffers.
> > +
> > +2. Call :c:func:`VIDIOC_STREAMOFF` on the ``CAPTURE`` queue.
> > +
> > +3. Free all ``CAPTURE`` buffers by calling :c:func:`VIDIOC_REQBUFS` on=
 the
> > +   ``CAPTURE`` queue with a buffer count of zero.
> > +
> > +4. Set the new format and resolution on the ``CAPTURE`` queue.
> > +
> > +5. Allocate new ``CAPTURE`` buffers for the new resolution.
> > +
> > +6. Call :c:func:`VIDIOC_STREAMON` on the ``CAPTURE`` queue to resume t=
he stream.
> > +
> > +The client can then start queueing new ``CAPTURE`` buffers and submit =
requests
> > +to decode the next buffers at the new resolution.
>=20
> There is some inconsistency here. In initialization sequence, we set
> OUTPUT format to coded width and height and had the driver set a sane
> default CAPTURE format. What happens to OUTPUT format? It definitely
> wouldn't make sense if it stayed at the initial coded size.
>=20
> > +
> > +Drain
> > +=3D=3D=3D=3D=3D
> > +
> > +In order to drain the stream on a stateless decoder, the client just n=
eeds to
> > +wait until all the submitted requests are completed. There is no need =
to send a
> > +``V4L2_DEC_CMD_STOP`` command since requests are processed sequentiall=
y by the
> > +driver.
>=20
> Is there a need to include this section? I feel like it basically says
> "Drain sequence: There is no drain sequence." ;)
>=20
> > +
> > +End of stream
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +If the decoder encounters an end of stream marking in the stream, the
> > +driver must send a ``V4L2_EVENT_EOS`` event to the client after all fr=
ames
> > +are decoded and ready to be dequeued on the ``CAPTURE`` queue, with th=
e
> > +:c:type:`v4l2_buffer` ``flags`` set to ``V4L2_BUF_FLAG_LAST``. This
> > +behavior is identical to the drain sequence triggered by the client vi=
a
> > +``V4L2_DEC_CMD_STOP``.
>=20
> The client parses the stream, so it should be also responsible for end
> of stream handling. There isn't anything to be signaled by the driver
> here (nor the driver could actually signal), so I'd just remove this
> section completely.
>=20
> > diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/m=
edia/uapi/v4l/devices.rst
> > index 1822c66c2154..a8e568eda7d8 100644
> > --- a/Documentation/media/uapi/v4l/devices.rst
> > +++ b/Documentation/media/uapi/v4l/devices.rst
> > @@ -16,6 +16,7 @@ Interfaces
> >      dev-osd
> >      dev-codec
> >      dev-decoder
> > +    dev-stateless-decoder
> >      dev-encoder
> >      dev-effect
> >      dev-raw-vbi
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Docum=
entation/media/uapi/v4l/extended-controls.rst
> > index a9252225b63e..c0411ebf4c12 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -810,6 +810,29 @@ enum v4l2_mpeg_video_bitrate_mode -
> >      otherwise the decoder expects a single frame in per buffer.
> >      Applicable to the decoder, all codecs.
> >=20
> > +``V4L2_CID_MPEG_VIDEO_H264_SPS``
> > +    Instance of struct v4l2_ctrl_h264_sps, containing the SPS of to us=
e with
> > +    the next queued frame. Applicable to the H.264 stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_PPS``
> > +    Instance of struct v4l2_ctrl_h264_pps, containing the PPS of to us=
e with
> > +    the next queued frame. Applicable to the H.264 stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX``
> > +    Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the s=
caling
> > +    matrix to use when decoding the next queued frame. Applicable to t=
he H.264
> > +    stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM``
> > +    Array of struct v4l2_ctrl_h264_slice_param, containing at least as=
 many
> > +    entries as there are slices in the corresponding ``OUTPUT`` buffer=
.
> > +    Applicable to the H.264 stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM``
> > +    Instance of struct v4l2_ctrl_h264_decode_param, containing the hig=
h-level
> > +    decoding parameters for a H.264 frame. Applicable to the H.264 sta=
teless
> > +    decoder.
> > +
>=20
> This seems to be roughly the same as in "H.264 buffer content and
> controls". IMHO we should just keep the controls described here and
> make the other file just cross reference to these descriptions.
>=20
> Also, I guess this would eventually end up in the patch that adds
> those controls and is just included here for RFC purposes, right?
>=20
> Best regards,
> Tomasz

--=-+yCSlYsKV5npbmcsj9FP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW5ZihQAKCRBxUwItrAao
HJzMAJ9RU3kEUUAmHI5fr0cx2mhPpQXkcwCgjT3jdgonGIEYbPr2Ry73MPdAJa4=
=ODvd
-----END PGP SIGNATURE-----

--=-+yCSlYsKV5npbmcsj9FP--
