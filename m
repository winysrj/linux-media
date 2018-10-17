Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40690 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQXQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 19:16:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin =?utf-8?B?KOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?utf-8?B?KOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        ezequiel@collabora.com
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video encoder interface
Date: Wed, 17 Oct 2018 18:19:57 +0300
Message-ID: <2699352.udkuklTee2@avalon>
In-Reply-To: <20180724140621.59624-3-tfiga@chromium.org>
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-3-tfiga@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thank you for the patch.

On Tuesday, 24 July 2018 17:06:21 EEST Tomasz Figa wrote:
> Due to complexity of the video encoding process, the V4L2 drivers of
> stateful encoder hardware require specific sequences of V4L2 API calls
> to be followed. These include capability enumeration, initialization,
> encoding, encode parameters change, drain and reset.
>=20
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in D=FCsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or coda.
>=20
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the encoder part of
> the Codec API.
>=20
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-encoder.rst | 550 +++++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst     |   1 +
>  Documentation/media/uapi/v4l/v4l2.rst        |   2 +
>  3 files changed, 553 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst
>=20
> diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst
> b/Documentation/media/uapi/v4l/dev-encoder.rst new file mode 100644
> index 000000000000..28be1698e99c
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-encoder.rst
> @@ -0,0 +1,550 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _encoder:
> +
> +****************************************
> +Memory-to-memory Video Encoder Interface
> +****************************************
> +
> +Input data to a video encoder are raw video frames in display order
> +to be encoded into the output bitstream. Output data are complete chunks=
 of
> +valid bitstream, including all metadata, headers, etc. The resulting
> stream
> +must not need any further post-processing by the client.
> +
> +Performing software stream processing, header generation etc. in the dri=
ver
> +in order to support this interface is strongly discouraged. In case such
> +operations are needed, use of Stateless Video Encoder Interface (in

s/use of/use of the/

(and in various places below, as pointed out in the review of patch 1/2)

> +development) is strongly advised.
> +
> +Conventions and notation used in this document
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[snip]

> +Glossary
> +=3D=3D=3D=3D=3D=3D=3D=3D

[snip]

Let's try to share these two sections between the two documents.

[snip]

> +Initialization
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +1. *[optional]* Enumerate supported formats and resolutions. See
> +   capability enumeration.
> +
> +2. Set a coded format on the ``CAPTURE`` queue via :c:func:`VIDIOC_S_FMT`
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> +
> +     ``pixelformat``
> +         set to a coded format to be produced
> +
> +   * **Return fields:**
> +
> +     ``width``, ``height``
> +         coded resolution (based on currently active ``OUTPUT`` format)

Shouldn't userspace then set the resolution on the CAPTURE queue first ?

> +   .. note::
> +
> +      Changing ``CAPTURE`` format may change currently set ``OUTPUT``
> +      format. The driver will derive a new ``OUTPUT`` format from
> +      ``CAPTURE`` format being set, including resolution, colorimetry
> +      parameters, etc. If the client needs a specific ``OUTPUT`` format,
> +      it must adjust it afterwards.

Doesn't this contradict the "based on currently active ``OUTPUT`` format"=20
above ?

> +3. *[optional]* Enumerate supported ``OUTPUT`` formats (raw formats for
> +   source) for the selected coded format via :c:func:`VIDIOC_ENUM_FMT`.
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> +
> +     ``index``
> +         follows standard semantics
> +
> +   * **Return fields:**
> +
> +     ``pixelformat``
> +         raw format supported for the coded format currently selected on
> +         the ``OUTPUT`` queue.
> +
> +4. The client may set the raw source format on the ``OUTPUT`` queue via
> +   :c:func:`VIDIOC_S_FMT`.
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> +
> +     ``pixelformat``
> +         raw format of the source
> +
> +     ``width``, ``height``
> +         source resolution
> +
> +     ``num_planes`` (for _MPLANE)
> +         set to number of planes for pixelformat
> +
> +     ``sizeimage``, ``bytesperline``
> +         follow standard semantics
> +
> +   * **Return fields:**
> +
> +     ``width``, ``height``
> +         may be adjusted by driver to match alignment requirements, as
> +         required by the currently selected formats
> +
> +     ``sizeimage``, ``bytesperline``
> +         follow standard semantics
> +
> +   * Setting the source resolution will reset visible resolution to the
> +     adjusted source resolution rounded up to the closest visible
> +     resolution supported by the driver. Similarly, coded resolution will
> +     be reset to source resolution rounded up to the closest coded
> +     resolution supported by the driver (typically a multiple of
> +     macroblock size).
> +
> +   .. note::
> +
> +      This step is not strictly required, since ``OUTPUT`` is expected to
> +      have a valid default format. However, the client needs to ensure t=
hat

s/needs to/must/

> +      ``OUTPUT`` format matches its expectations via either
> +      :c:func:`VIDIOC_S_FMT` or :c:func:`VIDIOC_G_FMT`, with the former
> +      being the typical scenario, since the default format is unlikely to
> +      be what the client needs.
> +
> +5. *[optional]* Set visible resolution for the stream metadata via
> +   :c:func:`VIDIOC_S_SELECTION` on the ``OUTPUT`` queue.
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> +
> +     ``target``
> +         set to ``V4L2_SEL_TGT_CROP``
> +
> +     ``r.left``, ``r.top``, ``r.width``, ``r.height``
> +         visible rectangle; this must fit within the framebuffer resolut=
ion
> +         and might be subject to adjustment to match codec and hardware
> +         constraints

Just for my information, are there use cases for r.left !=3D 0 or r.top !=
=3D 0 ?

> +   * **Return fields:**
> +
> +     ``r.left``, ``r.top``, ``r.width``, ``r.height``
> +         visible rectangle adjusted by the driver
> +
> +   * The driver must expose following selection targets on ``OUTPUT``:
> +
> +     ``V4L2_SEL_TGT_CROP_BOUNDS``
> +         maximum crop bounds within the source buffer supported by the
> +         encoder

Will this always match the format on the OUTPUT queue, or can it differ ?

> +     ``V4L2_SEL_TGT_CROP_DEFAULT``
> +         suggested cropping rectangle that covers the whole source pictu=
re

How can the driver know what to report here, apart from the same value as=20
V4L2_SET_TGT_CROP_BOUNDS ?

> +     ``V4L2_SEL_TGT_CROP``
> +         rectangle within the source buffer to be encoded into the
> +         ``CAPTURE`` stream; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``
> +
> +     ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> +         maximum rectangle within the coded resolution, which the cropped
> +         source frame can be output into; always equal to (0, 0)x(width =
of
> +         ``V4L2_SEL_TGT_CROP``, height of ``V4L2_SEL_TGT_CROP``), if the
> +         hardware does not support compose/scaling
> +
> +     ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
> +         equal to ``V4L2_SEL_TGT_CROP``
> +
> +     ``V4L2_SEL_TGT_COMPOSE``
> +         rectangle within the coded frame, which the cropped source frame
> +         is to be output into; defaults to
> +         ``V4L2_SEL_TGT_COMPOSE_DEFAULT``; read-only on hardware without
> +         additional compose/scaling capabilities; resulting stream will
> +         have this rectangle encoded as the visible rectangle in its
> +         metadata
> +
> +     ``V4L2_SEL_TGT_COMPOSE_PADDED``
> +         always equal to coded resolution of the stream, as selected by =
the
> +         encoder based on source resolution and crop/compose rectangles
> +
> +   .. note::
> +
> +      The driver may adjust the crop/compose rectangles to the nearest
> +      supported ones to meet codec and hardware requirements.
> +
> +6. Allocate buffers for both ``OUTPUT`` and ``CAPTURE`` via
> +   :c:func:`VIDIOC_REQBUFS`. This may be performed in any order.
> +
> +   * **Required fields:**
> +
> +     ``count``
> +         requested number of buffers to allocate; greater than zero
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT`` or
> +         ``CAPTURE``
> +
> +     ``memory``
> +         follows standard semantics
> +
> +   * **Return fields:**
> +
> +     ``count``
> +         adjusted to allocated number of buffers
> +
> +   * The driver must adjust count to minimum of required number of
> +     buffers for given format and count passed.

s/minimum/maximum/ ?

> The client must
> +     check this value after the ioctl returns to get the number of
> +     buffers actually allocated.
> +
> +   .. note::
> +
> +      To allocate more than minimum number of buffers (for pipeline
> +      depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) or
> +      G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``), respectively,
> +      to get the minimum number of buffers required by the
> +      driver/format, and pass the obtained value plus the number of
> +      additional buffers needed in count field to :c:func:`VIDIOC_REQBUF=
S`.
> +
> +7. Begin streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
> +   :c:func:`VIDIOC_STREAMON`. This may be performed in any order. Actual
> +   encoding process starts when both queues start streaming.
> +
> +.. note::
> +
> +   If the client stops ``CAPTURE`` during the encode process and then
> +   restarts it again, the encoder will be expected to generate a stream
> +   independent from the stream generated before the stop. Depending on t=
he
> +   coded format, that may imply that:
> +
> +   * encoded frames produced after the restart must not reference any
> +     frames produced before the stop, e.g. no long term references for
> +     H264,
> +
> +   * any headers that must be included in a standalone stream must be
> +     produced again, e.g. SPS and PPS for H264.

s/H264/H.264/

(and in other places too)

> +Encoding
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This state is reached after a successful initialization sequence. In
> +this state, client queues and dequeues buffers to both queues via
> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
> +semantics.
> +
> +Both queues operate independently, following standard behavior of V4L2
> +buffer queues and memory-to-memory devices. In addition, the order of
> +encoded frames dequeued from ``CAPTURE`` queue may differ from the order=
 of
> +queuing raw frames to ``OUTPUT`` queue, due to properties of selected
> coded
> +format, e.g. frame reordering. The client must not assume any direct
> +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
> +reported by :c:type:`v4l2_buffer` ``timestamp``.
> +
> +Encoding parameter changes
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> +parameters at any time. The availability of parameters is driver-specific
> +and the client must query the driver to find the set of available contro=
ls.
> +
> +The ability to change each parameter during encoding of is driver-specif=
ic,
> +as per standard semantics of the V4L2 control interface. The client may
> +attempt setting a control of its interest during encoding and if it the
> +operation fails with the -EBUSY error code, ``CAPTURE`` queue needs to be
> +stopped for the configuration change to be allowed (following the drain
> +sequence will be  needed to avoid losing already queued/encoded frames).
> +
> +The timing of parameter update is driver-specific, as per standard
> +semantics of the V4L2 control interface. If the client needs to apply the
> +parameters exactly at specific frame and the encoder supports it, using
> +Request API should be considered.
> +
> +Drain
> +=3D=3D=3D=3D=3D
> +
> +To ensure that all queued ``OUTPUT`` buffers have been processed and
> +related ``CAPTURE`` buffers output to the client, the following drain
> +sequence may be followed. After the drain sequence is complete, the clie=
nt
> +has received all encoded frames for all ``OUTPUT`` buffers queued before
> +the sequence was started.
> +
> +1. Begin drain by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> +
> +   * **Required fields:**
> +
> +     ``cmd``
> +         set to ``V4L2_ENC_CMD_STOP``
> +
> +     ``flags``
> +         set to 0
> +
> +     ``pts``
> +         set to 0
> +
> +2. The driver must process and encode as normal all ``OUTPUT`` buffers
> +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issu=
ed.
> +
> +3. Once all ``OUTPUT`` buffers queued before ``V4L2_ENC_CMD_STOP`` are
> +   processed:
> +
> +   * Once all decoded frames (if any) are ready to be dequeued on the
> +     ``CAPTURE`` queue

I understand this condition to be equivalent to the main step 3 condition. =
I=20
would thus write it as

"At this point all decoded frames (if any) are ready to be dequeued on the=
=20
``CAPTURE`` queue. The driver must send a ``V4L2_EVENT_EOS``."

> the driver must send a ``V4L2_EVENT_EOS``. The
> +     driver must also set ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer`
> +     ``flags`` field on the buffer on the ``CAPTURE`` queue containing t=
he
> +     last frame (if any) produced as a result of processing the ``OUTPUT=
``
> +     buffers queued before

Unneeded line break ?

> +     ``V4L2_ENC_CMD_STOP``.
> +
> +   * If no more frames are left to be returned at the point of handling
> +     ``V4L2_ENC_CMD_STOP``, the driver must return an empty buffer (with
> +     :c:type:`v4l2_buffer` ``bytesused`` =3D 0) as the last buffer with
> +     ``V4L2_BUF_FLAG_LAST`` set.
> +
> +   * Any attempts to dequeue more buffers beyond the buffer marked with
> +     ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error code returned =
by
> +     :c:func:`VIDIOC_DQBUF`.
> +
> +4. At this point, encoding is paused and the driver will accept, but not
> +   process any newly queued ``OUTPUT`` buffers until the client issues
> +   ``V4L2_ENC_CMD_START`` or restarts streaming on any queue.
> +
> +* Once the drain sequence is initiated, the client needs to drive it to
> +  completion, as described by the above steps, unless it aborts the proc=
ess
> +  by issuing :c:func:`VIDIOC_STREAMOFF` on ``CAPTURE`` queue.  The client
> +  is not allowed to issue ``V4L2_ENC_CMD_START`` or ``V4L2_ENC_CMD_STOP``
> +  again while the drain sequence is in progress and they will fail with
> +  -EBUSY error code if attempted.
> +
> +* Restarting streaming on ``CAPTURE`` queue will implicitly end the paus=
ed
> +  state and make the encoder continue encoding, as long as other encoding
> +  conditions are met. Restarting ``OUTPUT`` queue will not affect an
> +  in-progress drain sequence.

The last sentence seems to contradict the "on any queue" part of step 4. Wh=
at=20
happens if the client restarts streaming on the OUTPUT queue while a drain=
=20
sequence is in progress ?

> +* The drivers must also implement :c:func:`VIDIOC_TRY_ENCODER_CMD`, as a
> +  way to let the client query the availability of encoder commands.
> +
> +Reset
> +=3D=3D=3D=3D=3D
> +
> +The client may want to request the encoder to reinitialize the encoding,
> +so that the stream produced becomes independent from the stream generated
> +before. Depending on the coded format, that may imply that:
> +
> +* encoded frames produced after the restart must not reference any frames
> +  produced before the stop, e.g. no long term references for H264,
> +
> +* any headers that must be included in a standalone stream must be produ=
ced
> +  again, e.g. SPS and PPS for H264.
> +
> +This can be achieved by performing the reset sequence.
> +
> +1. *[optional]* If the client is interested in encoded frames resulting
> +   from already queued source frames, it needs to perform the Drain
> +   sequence. Otherwise, the reset sequence would cause the already
> +   encoded and not dequeued encoded frames to be lost.
> +
> +2. Stop streaming on ``CAPTURE`` queue via :c:func:`VIDIOC_STREAMOFF`. T=
his
> +   will return all currently queued ``CAPTURE`` buffers to the client,
> +   without valid frame data.
> +
> +3. *[optional]* Restart streaming on ``OUTPUT`` queue via
> +   :c:func:`VIDIOC_STREAMOFF` followed by :c:func:`VIDIOC_STREAMON` to
> +   drop any source frames enqueued to the encoder before the reset
> +   sequence. This is useful if the client requires the new stream to beg=
in
> +   at specific source frame. Otherwise, the new stream might include
> +   frames encoded from source frames queued before the reset sequence.
> +
> +4. Restart streaming on ``CAPTURE`` queue via :c:func:`VIDIOC_STREAMON` =
and
> +   continue with regular encoding sequence. The encoded frames produced
> +   into ``CAPTURE`` buffers from now on will contain a standalone stream
> +   that can be decoded without the need for frames encoded before the re=
set
> +   sequence.
> +
> +Commit points
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Setting formats and allocating buffers triggers changes in the behavior
> +of the driver.
> +
> +1. Setting format on ``CAPTURE`` queue may change the set of formats
> +   supported/advertised on the ``OUTPUT`` queue. In particular, it also
> +   means that ``OUTPUT`` format may be reset and the client must not
> +   rely on the previously set format being preserved.
> +
> +2. Enumerating formats on ``OUTPUT`` queue must only return formats
> +   supported for the ``CAPTURE`` format currently set.
> +
> +3. Setting/changing format on ``OUTPUT`` queue does not change formats

Just "Setting" ?

> +   available on ``CAPTURE`` queue. An attempt to set ``OUTPUT`` format t=
hat
> +   is not supported for the currently selected ``CAPTURE`` format must
> +   result in the driver adjusting the requested format to an acceptable
> +   one.
> +
> +4. Enumerating formats on ``CAPTURE`` queue always returns the full set =
of
> +   supported coded formats, irrespective of the current ``OUTPUT``
> +   format.
> +
> +5. After allocating buffers on the ``CAPTURE`` queue, it is not possible=
 to
> +   change format on it.
> +
> +To summarize, setting formats and allocation must always start with the
> +``CAPTURE`` queue and the ``CAPTURE`` queue is the master that governs t=
he
> +set of supported formats for the ``OUTPUT`` queue.

[snip]

=2D-=20
Regards,

Laurent Pinchart
