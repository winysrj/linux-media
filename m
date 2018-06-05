Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33606 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbeFEMiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 08:38:12 -0400
Received: by mail-vk0-f65.google.com with SMTP id 200-v6so1287028vkc.0
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 05:38:12 -0700 (PDT)
Received: from mail-vk0-f42.google.com (mail-vk0-f42.google.com. [209.85.213.42])
        by smtp.gmail.com with ESMTPSA id x32-v6sm7037510uad.45.2018.06.05.05.38.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Jun 2018 05:38:11 -0700 (PDT)
Received: by mail-vk0-f42.google.com with SMTP id e67-v6so1274878vke.7
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 05:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-3-tfiga@chromium.org>
 <1528199628.4074.15.camel@pengutronix.de>
In-Reply-To: <1528199628.4074.15.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 5 Jun 2018 21:31:56 +0900
Message-ID: <CAAFQd5DYu+Oehr1UUvvdmWk7toO0i_=NFgvZcAKQ8ZURKy51fA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
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

Thanks for review!

On Tue, Jun 5, 2018 at 8:53 PM Philipp Zabel <p.zabel@pengutronix.de> wrote=
:
>
> On Tue, 2018-06-05 at 19:33 +0900, Tomasz Figa wrote:
> > Due to complexity of the video encoding process, the V4L2 drivers of
> > stateful encoder hardware require specific sequencies of V4L2 API calls
> > to be followed. These include capability enumeration, initialization,
> > encoding, encode parameters change and flush.
> >
> > Specifics of the above have been discussed during Media Workshops at
> > LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API that
> > originated at those events was later implemented by the drivers we alre=
ady
> > have merged in mainline, such as s5p-mfc or mtk-vcodec.
> >
> > The only thing missing was the real specification included as a part of
> > Linux Media documentation. Fix it now and document the encoder part of
> > the Codec API.
> >
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > ---
> >  Documentation/media/uapi/v4l/dev-codec.rst | 313 +++++++++++++++++++++
> >  1 file changed, 313 insertions(+)
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation=
/media/uapi/v4l/dev-codec.rst
> > index 0483b10c205e..325a51bb09df 100644
> > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> > @@ -805,3 +805,316 @@ of the driver.
> >  To summarize, setting formats and allocation must always start with th=
e
> >  OUTPUT queue and the OUTPUT queue is the master that governs the set o=
f
> >  supported formats for the CAPTURE queue.
> > +
> > +Encoder
> > +=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Querying capabilities
> > +---------------------
> > +
> > +1. To enumerate the set of coded formats supported by the driver, the
> > +   client uses :c:func:`VIDIOC_ENUM_FMT` for CAPTURE. The driver must =
always
> > +   return the full set of supported formats, irrespective of the
> > +   format set on the OUTPUT queue.
> > +
> > +2. To enumerate the set of supported raw formats, the client uses
> > +   :c:func:`VIDIOC_ENUM_FMT` for OUTPUT queue. The driver must return =
only
> > +   the formats supported for the format currently set on the
> > +   CAPTURE queue.
> > +   In order to enumerate raw formats supported by a given coded
> > +   format, the client must first set that coded format on the
> > +   CAPTURE queue and then enumerate the OUTPUT queue.
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
> > +
> > +6. Any additional encoder capabilities may be discovered by querying
> > +   their respective controls.
> > +
> > +.. note::
> > +
> > +   Full format enumeration requires enumerating all raw formats
> > +   on the OUTPUT queue for all possible (enumerated) coded formats on
> > +   CAPTURE queue (setting each format on the CAPTURE queue before each
> > +   enumeration on the OUTPUT queue.
> > +
> > +Initialization
> > +--------------
> > +
> > +1. (optional) Enumerate supported formats and resolutions. See
> > +   capability enumeration.
> > +
> > +2. Set a coded format on the CAPTURE queue via :c:func:`VIDIOC_S_FMT`
> > +
> > +   a. Required fields:
> > +
> > +      i.  type =3D CAPTURE
> > +
> > +      ii. fmt.pix_mp.pixelformat set to a coded format to be produced
> > +
> > +   b. Return values:
> > +
> > +      i.  EINVAL: unsupported format.
> > +
> > +      ii. Others: per spec
> > +
> > +   c. Return fields:
> > +
> > +      i. fmt.pix_mp.width, fmt.pix_mp.height should be 0.
> > +
> > +   .. note::
> > +
> > +      After a coded format is set, the set of raw formats
> > +      supported as source on the OUTPUT queue may change.
>
> So setting CAPTURE potentially also changes OUTPUT format?

Yes, but at this point userspace hasn't yet set the desired format.

> If the encoded stream supports colorimetry information, should that
> information be taken from the CAPTURE queue?

What's colorimetry? Is it something that is included in
v4l2_pix_format(_mplane)? Is it something that can vary between raw
input and encoded output?

>
> > +3. (optional) Enumerate supported OUTPUT formats (raw formats for
> > +   source) for the selected coded format via :c:func:`VIDIOC_ENUM_FMT`=
.
> > +
> > +   a. Required fields:
> > +
> > +      i.  type =3D OUTPUT
> > +
> > +      ii. index =3D per spec
> > +
> > +   b. Return values: per spec
> > +
> > +   c. Return fields:
> > +
> > +      i. pixelformat: raw format supported for the coded format
> > +         currently selected on the OUTPUT queue.
> > +
> > +4. Set a raw format on the OUTPUT queue and visible resolution for the
> > +   source raw frames via :c:func:`VIDIOC_S_FMT` on the OUTPUT queue.
>
> Isn't this optional? If S_FMT(CAP) already sets OUTPUT to a valid
> format, just G_FMT(OUT) should be valid here as well.

Technically it would be valid indeed, but that would be unlikely what
the client needs, given that it probably already has some existing raw
frames (at certain resolution) to encode.

>
> > +
> > +   a. Required fields:
> > +
> > +      i.   type =3D OUTPUT
> > +
> > +      ii.  fmt.pix_mp.pixelformat =3D raw format to be used as source =
of
> > +           encode
> > +
> > +      iii. fmt.pix_mp.width, fmt.pix_mp.height =3D input resolution
> > +           for the source raw frames
>
> These are specific to multiplanar drivers. The same should apply to
> singleplanar drivers.

Right. In general I'd be interested in getting some suggestions in how
to write this kind of descriptions nicely and consistent with other
kernel documentation.

>
> > +
> > +      iv.  num_planes: set to number of planes for pixelformat.
> > +
> > +      v.   For each plane p =3D [0, num_planes-1]:
> > +           plane_fmt[p].sizeimage, plane_fmt[p].bytesperline: as
> > +           per spec for input resolution.
> > +
> > +   b. Return values: as per spec.
> > +
> > +   c. Return fields:
> > +
> > +      i.  fmt.pix_mp.width, fmt.pix_mp.height =3D may be adjusted by
> > +          driver to match alignment requirements, as required by the
> > +          currently selected formats.
> > +
> > +      ii. For each plane p =3D [0, num_planes-1]:
> > +          plane_fmt[p].sizeimage, plane_fmt[p].bytesperline: as
> > +          per spec for the adjusted input resolution.
> > +
> > +   d. Setting the input resolution will reset visible resolution to th=
e
> > +      adjusted input resolution rounded up to the closest visible
> > +      resolution supported by the driver. Similarly, coded size will
> > +      be reset to input resolution rounded up to the closest coded
> > +      resolution supported by the driver (typically a multiple of
> > +      macroblock size).
> > +
> > +5. (optional) Set visible size for the stream metadata via
> > +   :c:func:`VIDIOC_S_SELECTION` on the OUTPUT queue.
> > +
> > +   a. Required fields:
> > +
> > +      i.   type =3D OUTPUT
> > +
> > +      ii.  target =3D ``V4L2_SEL_TGT_CROP``
> > +
> > +      iii. r.left, r.top, r.width, r.height: visible rectangle; this
> > +           must fit within coded resolution returned from
> > +           :c:func:`VIDIOC_S_FMT`.
> > +
> > +   b. Return values: as per spec.
> > +
> > +   c. Return fields:
> > +
> > +      i. r.left, r.top, r.width, r.height: visible rectangle adjusted =
by
> > +         the driver to match internal constraints.
> > +
> > +   d. This resolution must be used as the visible resolution in the
> > +      stream metadata.
> > +
> > +   .. note::
> > +
> > +      The driver might not support arbitrary values of the
> > +      crop rectangle and will adjust it to the closest supported
> > +      one.
> > +
> > +6. Allocate buffers for both OUTPUT and CAPTURE queues via
> > +   :c:func:`VIDIOC_REQBUFS`. This may be performed in any order.
> > +
> > +   a. Required fields:
> > +
> > +      i.   count =3D n, where n > 0.
> > +
> > +      ii.  type =3D OUTPUT or CAPTURE
> > +
> > +      iii. memory =3D as per spec
> > +
> > +   b. Return values: Per spec.
> > +
> > +   c. Return fields:
> > +
> > +      i. count: adjusted to allocated number of buffers
> > +
> > +   d. The driver must adjust count to minimum of required number of
> > +      buffers for given format and count passed. The client must
> > +      check this value after the ioctl returns to get the number of
> > +      buffers actually allocated.
> > +
> > +   .. note::
> > +
> > +      Passing count =3D 1 is useful for letting the driver choose the
> > +      minimum according to the selected format/hardware
> > +      requirements.
> > +
> > +   .. note::
> > +
> > +      To allocate more than minimum number of buffers (for pipeline
> > +      depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT)`` or
> > +      G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE)``, respectively,
> > +      to get the minimum number of buffers required by the
> > +      driver/format, and pass the obtained value plus the number of
> > +      additional buffers needed in count field to :c:func:`VIDIOC_REQB=
UFS`.
> > +
> > +7. Begin streaming on both OUTPUT and CAPTURE queues via
> > +   :c:func:`VIDIOC_STREAMON`. This may be performed in any order.
>
> Actual encoding starts once both queues are streaming

I think that's the only thing possible with vb2, since it gives
buffers to the driver when streaming starts on given queue.

> and stops as soon
> as the first queue receives STREAMOFF?

Given that STREAMOFF is supposed to drop all the buffers from the
queue, it should be so +/- finishing what's already queued to the
hardware, if it cannot be cancelled.

I guess we should say this more explicitly.

>
> > +Encoding
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
> > +Source OUTPUT buffers must contain full raw frames in the selected
> > +OUTPUT format, exactly one frame per buffer.
> > +
> > +Encoding parameter changes
> > +--------------------------
> > +
> > +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> > +parameters at any time. The driver must apply the new setting starting
> > +at the next frame queued to it.
> > +
> > +This specifically means that if the driver maintains a queue of buffer=
s
> > +to be encoded and at the time of the call to :c:func:`VIDIOC_S_CTRL` n=
ot all the
> > +buffers in the queue are processed yet, the driver must not apply the
> > +change immediately, but schedule it for when the next buffer queued
> > +after the :c:func:`VIDIOC_S_CTRL` starts being processed.
>
> Does this mean that hardware that doesn't support changing parameters at
> runtime at all must stop streaming and restart streaming internally with
> every parameter change? Or is it acceptable to not allow the controls to
> be changed during streaming?

That's a good question. I'd be leaning towards the latter (not allow),
as to keep kernel code simple, but maybe we could have others
(especially Pawel) comment on this.

>
> > +Flush
> > +-----
> > +
> > +Flush is the process of draining the CAPTURE queue of any remaining
> > +buffers. After the flush sequence is complete, the client has received
> > +all encoded frames for all OUTPUT buffers queued before the sequence w=
as
> > +started.
> > +
> > +1. Begin flush by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> > +
> > +   a. Required fields:
> > +
> > +      i. cmd =3D ``V4L2_ENC_CMD_STOP``
> > +
> > +2. The driver must process and encode as normal all OUTPUT buffers
> > +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was is=
sued.
> > +
> > +3. Once all OUTPUT buffers queued before ``V4L2_ENC_CMD_STOP`` are
> > +   processed:
> > +
> > +   a. Once all decoded frames (if any) are ready to be dequeued on the
> > +      CAPTURE queue, the driver must send a ``V4L2_EVENT_EOS``. The
> > +      driver must also set ``V4L2_BUF_FLAG_LAST`` in
> > +      :c:type:`v4l2_buffer` ``flags`` field on the buffer on the CAPTU=
RE queue
> > +      containing the last frame (if any) produced as a result of
> > +      processing the OUTPUT buffers queued before
> > +      ``V4L2_ENC_CMD_STOP``. If no more frames are left to be
> > +      returned at the point of handling ``V4L2_ENC_CMD_STOP``, the
> > +      driver must return an empty buffer (with
> > +      :c:type:`v4l2_buffer` ``bytesused`` =3D 0) as the last buffer wi=
th
> > +      ``V4L2_BUF_FLAG_LAST`` set instead.
> > +      Any attempts to dequeue more buffers beyond the buffer
> > +      marked with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE
> > +      error from :c:func:`VIDIOC_DQBUF`.
> > +
> > +4. At this point, encoding is paused and the driver will accept, but n=
ot
> > +   process any newly queued OUTPUT buffers until the client issues
> > +   ``V4L2_ENC_CMD_START`` or :c:func:`VIDIOC_STREAMON`.
> > +
> > +Once the flush sequence is initiated, the client needs to drive it to
> > +completion, as described by the above steps, unless it aborts the
> > +process by issuing :c:func:`VIDIOC_STREAMOFF` on OUTPUT queue. The cli=
ent is not
> > +allowed to issue ``V4L2_ENC_CMD_START`` or ``V4L2_ENC_CMD_STOP`` again
> > +while the flush sequence is in progress.
> > +
> > +Issuing :c:func:`VIDIOC_STREAMON` on OUTPUT queue will implicitly rest=
art
> > +encoding.
>
> Only if CAPTURE is already streaming?

Yes, I'd say so, to be consistent with initial streaming start. I
guess we should state this explicitly.

>
> >  :c:func:`VIDIOC_STREAMON` and :c:func:`VIDIOC_STREAMOFF` on CAPTURE qu=
eue will
> > +not affect the flush sequence, allowing the client to change CAPTURE
> > +buffer set if needed.
> > +
> > +Commit points
> > +-------------
> > +
> > +Setting formats and allocating buffers triggers changes in the behavio=
r
> > +of the driver.
> > +
> > +1. Setting format on CAPTURE queue may change the set of formats
> > +   supported/advertised on the OUTPUT queue. It also must change the
> > +   format currently selected on OUTPUT queue if it is not supported
> > +   by the newly selected CAPTURE format to a supported one.
>
> Should TRY_FMT on the OUTPUT queue only return formats that can be
> transformed into the currently set format on the capture queue?
> (That is, after setting colorimetry on the CAPTURE queue, will
> TRY_FMT(OUT) always return that colorimetry?)

Yes, that's my understanding. This way we avoid the "negotiation
hell", which would cause both queues to fight with each other, if
userspace keeps setting incompatible settings.

>
> > +2. Enumerating formats on OUTPUT queue must only return OUTPUT formats
> > +   supported for the CAPTURE format currently set.
> > +
> > +3. Setting/changing format on OUTPUT queue does not change formats
> > +   available on CAPTURE queue. An attempt to set OUTPUT format that
> > +   is not supported for the currently selected CAPTURE format must
> > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
>
> Same as for decoding, is this limited to pixel format? Why isn't the
> pixel format corrected to a supported choice? What about
> width/height/colorimetry?

Width/height/colorimetry(Do you mean color space?) is a part of
v4l2_pix_format(_mplane). I believe that's what this point was about.

I'd say that we should have 1 master queue, which would enforce the
constraints and the 2 points above mark the OUTPUT queue as such. This
way we avoid the "negotiation" hell as I mentioned above and we can be
sure that the driver commits to some format on given queue, e.g.

S_FMT(OUTPUT, o_0)
o_1 =3D G_FMT(OUTPUT)
S_FMT(CAPTURE, c_0)
c_1 =3D G_FMT(CAPTURE)

At this point we can be sure that OUTPUT queue will operate with
exactly format o_1 and CAPTURE queue with exactly c_1.

Best regards,
Tomasz
