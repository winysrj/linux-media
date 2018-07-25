Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:50174 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbeGYPJd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 11:09:33 -0400
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        ezequiel@collabora.com
References: <20180724140621.59624-1-tfiga@chromium.org>
 <20180724140621.59624-3-tfiga@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4168da98-fa01-ea2f-8162-385501e666be@xs4all.nl>
Date: Wed, 25 Jul 2018 15:57:42 +0200
MIME-Version: 1.0
In-Reply-To: <20180724140621.59624-3-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/07/18 16:06, Tomasz Figa wrote:
> Due to complexity of the video encoding process, the V4L2 drivers of
> stateful encoder hardware require specific sequences of V4L2 API calls
> to be followed. These include capability enumeration, initialization,
> encoding, encode parameters change, drain and reset.
> 
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or coda.
> 
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the encoder part of
> the Codec API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-encoder.rst | 550 +++++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst     |   1 +
>  Documentation/media/uapi/v4l/v4l2.rst        |   2 +
>  3 files changed, 553 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst
> 
> diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst b/Documentation/media/uapi/v4l/dev-encoder.rst
> new file mode 100644
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
> +to be encoded into the output bitstream. Output data are complete chunks of
> +valid bitstream, including all metadata, headers, etc. The resulting stream
> +must not need any further post-processing by the client.

Due to the confusing use capture and output I wonder if it would be better to
rephrase this as follows:

"A video encoder takes raw video frames in display order and encodes them into
a bitstream. It generates complete chunks of the bitstream, including
all metadata, headers, etc. The resulting bitstream does not require any further
post-processing by the client."

Something similar should be done for the decoder documentation.

> +
> +Performing software stream processing, header generation etc. in the driver
> +in order to support this interface is strongly discouraged. In case such
> +operations are needed, use of Stateless Video Encoder Interface (in
> +development) is strongly advised.
> +
> +Conventions and notation used in this document
> +==============================================
> +
> +1. The general V4L2 API rules apply if not specified in this document
> +   otherwise.
> +
> +2. The meaning of words “must”, “may”, “should”, etc. is as per RFC
> +   2119.
> +
> +3. All steps not marked “optional” are required.
> +
> +4. :c:func:`VIDIOC_G_EXT_CTRLS`, :c:func:`VIDIOC_S_EXT_CTRLS` may be used
> +   interchangeably with :c:func:`VIDIOC_G_CTRL`, :c:func:`VIDIOC_S_CTRL`,
> +   unless specified otherwise.
> +
> +5. Single-plane API (see spec) and applicable structures may be used
> +   interchangeably with Multi-plane API, unless specified otherwise,
> +   depending on driver capabilities and following the general V4L2
> +   guidelines.
> +
> +6. i = [a..b]: sequence of integers from a to b, inclusive, i.e. i =
> +   [0..2]: i = 0, 1, 2.
> +
> +7. For ``OUTPUT`` buffer A, A’ represents a buffer on the ``CAPTURE`` queue
> +   containing data (encoded frame/stream) that resulted from processing
> +   buffer A.
> +
> +Glossary
> +========
> +
> +CAPTURE
> +   the destination buffer queue; the queue of buffers containing encoded
> +   bitstream; ``V4L2_BUF_TYPE_VIDEO_CAPTURE```` or
> +   ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``; data are captured from the
> +   hardware into ``CAPTURE`` buffers
> +
> +client
> +   application client communicating with the driver implementing this API
> +
> +coded format
> +   encoded/compressed video bitstream format (e.g. H.264, VP8, etc.);
> +   see also: raw format
> +
> +coded height
> +   height for given coded resolution
> +
> +coded resolution
> +   stream resolution in pixels aligned to codec and hardware requirements;
> +   typically visible resolution rounded up to full macroblocks; see also:
> +   visible resolution
> +
> +coded width
> +   width for given coded resolution
> +
> +decode order
> +   the order in which frames are decoded; may differ from display order if
> +   coded format includes a feature of frame reordering; ``CAPTURE`` buffers
> +   must be returned by the driver in decode order
> +
> +display order
> +   the order in which frames must be displayed; ``OUTPUT`` buffers must be
> +   queued by the client in display order
> +
> +IDR
> +   a type of a keyframe in H.264-encoded stream, which clears the list of
> +   earlier reference frames (DPBs)

Same problem as with the previous patch: it doesn't say what IDR stands for.
It also refers to DPBs, but DPB is not part of this glossary.

Perhaps the glossary of the encoder/decoder should be combined.

> +
> +keyframe
> +   an encoded frame that does not reference frames decoded earlier, i.e.
> +   can be decoded fully on its own.
> +
> +macroblock
> +   a processing unit in image and video compression formats based on linear
> +   block transforms (e.g. H264, VP8, VP9); codec-specific, but for most of
> +   popular codecs the size is 16x16 samples (pixels)
> +
> +OUTPUT
> +   the source buffer queue; the queue of buffers containing raw frames;
> +   ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or
> +   ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``; the hardware is fed with data
> +   from ``OUTPUT`` buffers
> +
> +PPS
> +   Picture Parameter Set; a type of metadata entity in H.264 bitstream
> +
> +raw format
> +   uncompressed format containing raw pixel data (e.g. YUV, RGB formats)
> +
> +resume point
> +   a point in the bitstream from which decoding may start/continue, without
> +   any previous state/data present, e.g.: a keyframe (VP8/VP9) or
> +   SPS/PPS/IDR sequence (H.264); a resume point is required to start decode
> +   of a new stream, or to resume decoding after a seek
> +
> +source
> +   data fed to the encoder; ``OUTPUT``
> +
> +source height
> +   height in pixels for given source resolution
> +
> +source resolution
> +   resolution in pixels of source frames being source to the encoder and
> +   subject to further cropping to the bounds of visible resolution
> +
> +source width
> +   width in pixels for given source resolution
> +
> +SPS
> +   Sequence Parameter Set; a type of metadata entity in H.264 bitstream
> +
> +stream metadata
> +   additional (non-visual) information contained inside encoded bitstream;
> +   for example: coded resolution, visible resolution, codec profile
> +
> +visible height
> +   height for given visible resolution; display height
> +
> +visible resolution
> +   stream resolution of the visible picture, in pixels, to be used for
> +   display purposes; must be smaller or equal to coded resolution;
> +   display resolution
> +
> +visible width
> +   width for given visible resolution; display width
> +
> +Querying capabilities
> +=====================
> +
> +1. To enumerate the set of coded formats supported by the driver, the
> +   client may call :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
> +
> +   * The driver must always return the full set of supported formats,
> +     irrespective of the format set on the ``OUTPUT`` queue.
> +
> +2. To enumerate the set of supported raw formats, the client may call
> +   :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
> +
> +   * The driver must return only the formats supported for the format
> +     currently active on ``CAPTURE``.
> +
> +   * In order to enumerate raw formats supported by a given coded format,
> +     the client must first set that coded format on ``CAPTURE`` and then
> +     enumerate the ``OUTPUT`` queue.
> +
> +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
> +   resolutions for a given format, passing desired pixel format in
> +   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
> +
> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE``
> +     must include all possible coded resolutions supported by the encoder
> +     for given coded pixel format.
> +
> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT``
> +     queue must include all possible frame buffer resolutions supported
> +     by the encoder for given raw pixel format and coded format currently
> +     set on ``CAPTURE``.
> +
> +4. Supported profiles and levels for given format, if applicable, may be
> +   queried using their respective controls via :c:func:`VIDIOC_QUERYCTRL`.
> +
> +5. Any additional encoder capabilities may be discovered by querying
> +   their respective controls.
> +
> +Initialization
> +==============
> +
> +1. *[optional]* Enumerate supported formats and resolutions. See
> +   capability enumeration.

capability enumeration. -> 'Querying capabilities' above.

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
> +
> +   .. note::
> +
> +      Changing ``CAPTURE`` format may change currently set ``OUTPUT``
> +      format. The driver will derive a new ``OUTPUT`` format from
> +      ``CAPTURE`` format being set, including resolution, colorimetry
> +      parameters, etc. If the client needs a specific ``OUTPUT`` format,
> +      it must adjust it afterwards.
> +
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

coded -> the coded

> +     be reset to source resolution rounded up to the closest coded

reset -> set
source -> the source

> +     resolution supported by the driver (typically a multiple of
> +     macroblock size).

The first sentence of this paragraph is very confusing. It needs a bit more work,
I think.

> +
> +   .. note::
> +
> +      This step is not strictly required, since ``OUTPUT`` is expected to
> +      have a valid default format. However, the client needs to ensure that
> +      ``OUTPUT`` format matches its expectations via either
> +      :c:func:`VIDIOC_S_FMT` or :c:func:`VIDIOC_G_FMT`, with the former
> +      being the typical scenario, since the default format is unlikely to
> +      be what the client needs.

Hmm. I'm not sure if this note should be included. It's good practice to always
set the output format. I think the note confuses more than that it helps. IMHO.

> +
> +5. *[optional]* Set visible resolution for the stream metadata via

Set -> Set the

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
> +         visible rectangle; this must fit within the framebuffer resolution

Should that be "source resolution"? Or the resolution returned by "CROP_BOUNDS"?

> +         and might be subject to adjustment to match codec and hardware
> +         constraints
> +
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
> +
> +     ``V4L2_SEL_TGT_CROP_DEFAULT``
> +         suggested cropping rectangle that covers the whole source picture
> +
> +     ``V4L2_SEL_TGT_CROP``
> +         rectangle within the source buffer to be encoded into the
> +         ``CAPTURE`` stream; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``
> +
> +     ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> +         maximum rectangle within the coded resolution, which the cropped
> +         source frame can be output into; always equal to (0, 0)x(width of
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
> +         always equal to coded resolution of the stream, as selected by the
> +         encoder based on source resolution and crop/compose rectangles

Are there codec drivers that support composition? I can't remember seeing any.

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

I'd rephrase this:

	The driver must adjust ``count`` to the maximum of ``count`` and
	the required number of buffers for the given format.

Note that this is set to the maximum, not minimum.

> The client must
> +     check this value after the ioctl returns to get the number of
> +     buffers actually allocated.
> +
> +   .. note::
> +
> +      To allocate more than minimum number of buffers (for pipeline

than -> than the

> +      depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) or
> +      G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``), respectively,
> +      to get the minimum number of buffers required by the
> +      driver/format, and pass the obtained value plus the number of
> +      additional buffers needed in count field to :c:func:`VIDIOC_REQBUFS`.

count -> the ``count``

> +
> +7. Begin streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
> +   :c:func:`VIDIOC_STREAMON`. This may be performed in any order. Actual

Actual -> The actual

> +   encoding process starts when both queues start streaming.
> +
> +.. note::
> +
> +   If the client stops ``CAPTURE`` during the encode process and then
> +   restarts it again, the encoder will be expected to generate a stream
> +   independent from the stream generated before the stop. Depending on the
> +   coded format, that may imply that:
> +
> +   * encoded frames produced after the restart must not reference any
> +     frames produced before the stop, e.g. no long term references for
> +     H264,
> +
> +   * any headers that must be included in a standalone stream must be
> +     produced again, e.g. SPS and PPS for H264.
> +
> +Encoding
> +========
> +
> +This state is reached after a successful initialization sequence. In
> +this state, client queues and dequeues buffers to both queues via
> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
> +semantics.
> +
> +Both queues operate independently, following standard behavior of V4L2
> +buffer queues and memory-to-memory devices. In addition, the order of
> +encoded frames dequeued from ``CAPTURE`` queue may differ from the order of
> +queuing raw frames to ``OUTPUT`` queue, due to properties of selected coded
> +format, e.g. frame reordering. The client must not assume any direct
> +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
> +reported by :c:type:`v4l2_buffer` ``timestamp``.

Same question as for the decoder: are you sure about that?

> +
> +Encoding parameter changes
> +==========================
> +
> +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> +parameters at any time. The availability of parameters is driver-specific
> +and the client must query the driver to find the set of available controls.
> +
> +The ability to change each parameter during encoding of is driver-specific,

Remove spurious 'of'

> +as per standard semantics of the V4L2 control interface. The client may

per -> per the

> +attempt setting a control of its interest during encoding and if it the

Remove spurious 'it'

> +operation fails with the -EBUSY error code, ``CAPTURE`` queue needs to be

``CAPTURE`` -> the ``CAPTURE``

> +stopped for the configuration change to be allowed (following the drain
> +sequence will be  needed to avoid losing already queued/encoded frames).

losing -> losing the

> +
> +The timing of parameter update is driver-specific, as per standard

update -> updates
per -> per the

> +semantics of the V4L2 control interface. If the client needs to apply the
> +parameters exactly at specific frame and the encoder supports it, using

using -> using the

> +Request API should be considered.

This makes the assumption that the Request API will be merged at about the
same time as this document. Which is at the moment a reasonable assumption,
to be fair.

> +
> +Drain
> +=====
> +
> +To ensure that all queued ``OUTPUT`` buffers have been processed and
> +related ``CAPTURE`` buffers output to the client, the following drain

related -> the related

> +sequence may be followed. After the drain sequence is complete, the client
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
> +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued.
> +
> +3. Once all ``OUTPUT`` buffers queued before ``V4L2_ENC_CMD_STOP`` are
> +   processed:
> +
> +   * Once all decoded frames (if any) are ready to be dequeued on the
> +     ``CAPTURE`` queue the driver must send a ``V4L2_EVENT_EOS``. The
> +     driver must also set ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer`
> +     ``flags`` field on the buffer on the ``CAPTURE`` queue containing the
> +     last frame (if any) produced as a result of processing the ``OUTPUT``
> +     buffers queued before
> +     ``V4L2_ENC_CMD_STOP``.

Hmm, this is somewhat awkward phrasing. Can you take another look at this?

> +
> +   * If no more frames are left to be returned at the point of handling
> +     ``V4L2_ENC_CMD_STOP``, the driver must return an empty buffer (with
> +     :c:type:`v4l2_buffer` ``bytesused`` = 0) as the last buffer with
> +     ``V4L2_BUF_FLAG_LAST`` set.
> +
> +   * Any attempts to dequeue more buffers beyond the buffer marked with
> +     ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error code returned by
> +     :c:func:`VIDIOC_DQBUF`.
> +
> +4. At this point, encoding is paused and the driver will accept, but not
> +   process any newly queued ``OUTPUT`` buffers until the client issues

issues -> issues a

> +   ``V4L2_ENC_CMD_START`` or restarts streaming on any queue.
> +
> +* Once the drain sequence is initiated, the client needs to drive it to
> +  completion, as described by the above steps, unless it aborts the process
> +  by issuing :c:func:`VIDIOC_STREAMOFF` on ``CAPTURE`` queue.  The client
> +  is not allowed to issue ``V4L2_ENC_CMD_START`` or ``V4L2_ENC_CMD_STOP``
> +  again while the drain sequence is in progress and they will fail with
> +  -EBUSY error code if attempted.
> +
> +* Restarting streaming on ``CAPTURE`` queue will implicitly end the paused
> +  state and make the encoder continue encoding, as long as other encoding
> +  conditions are met. Restarting ``OUTPUT`` queue will not affect an
> +  in-progress drain sequence.
> +
> +* The drivers must also implement :c:func:`VIDIOC_TRY_ENCODER_CMD`, as a
> +  way to let the client query the availability of encoder commands.
> +
> +Reset
> +=====
> +
> +The client may want to request the encoder to reinitialize the encoding,
> +so that the stream produced becomes independent from the stream generated
> +before. Depending on the coded format, that may imply that:
> +
> +* encoded frames produced after the restart must not reference any frames
> +  produced before the stop, e.g. no long term references for H264,
> +
> +* any headers that must be included in a standalone stream must be produced
> +  again, e.g. SPS and PPS for H264.
> +
> +This can be achieved by performing the reset sequence.
> +
> +1. *[optional]* If the client is interested in encoded frames resulting
> +   from already queued source frames, it needs to perform the Drain
> +   sequence. Otherwise, the reset sequence would cause the already
> +   encoded and not dequeued encoded frames to be lost.
> +
> +2. Stop streaming on ``CAPTURE`` queue via :c:func:`VIDIOC_STREAMOFF`. This
> +   will return all currently queued ``CAPTURE`` buffers to the client,
> +   without valid frame data.
> +
> +3. *[optional]* Restart streaming on ``OUTPUT`` queue via
> +   :c:func:`VIDIOC_STREAMOFF` followed by :c:func:`VIDIOC_STREAMON` to
> +   drop any source frames enqueued to the encoder before the reset
> +   sequence. This is useful if the client requires the new stream to begin
> +   at specific source frame. Otherwise, the new stream might include
> +   frames encoded from source frames queued before the reset sequence.
> +
> +4. Restart streaming on ``CAPTURE`` queue via :c:func:`VIDIOC_STREAMON` and
> +   continue with regular encoding sequence. The encoded frames produced
> +   into ``CAPTURE`` buffers from now on will contain a standalone stream
> +   that can be decoded without the need for frames encoded before the reset
> +   sequence.
> +
> +Commit points
> +=============
> +
> +Setting formats and allocating buffers triggers changes in the behavior
> +of the driver.
> +
> +1. Setting format on ``CAPTURE`` queue may change the set of formats

format -> the format

> +   supported/advertised on the ``OUTPUT`` queue. In particular, it also
> +   means that ``OUTPUT`` format may be reset and the client must not

that -> that the

> +   rely on the previously set format being preserved.
> +
> +2. Enumerating formats on ``OUTPUT`` queue must only return formats

on -> on the

> +   supported for the ``CAPTURE`` format currently set.

'for the current ``CAPTURE`` format.'

> +
> +3. Setting/changing format on ``OUTPUT`` queue does not change formats

format -> the format
on -> on the

> +   available on ``CAPTURE`` queue. An attempt to set ``OUTPUT`` format that

on -> on the
set -> set the

> +   is not supported for the currently selected ``CAPTURE`` format must
> +   result in the driver adjusting the requested format to an acceptable
> +   one.
> +
> +4. Enumerating formats on ``CAPTURE`` queue always returns the full set of

on -> on the

> +   supported coded formats, irrespective of the current ``OUTPUT``
> +   format.
> +
> +5. After allocating buffers on the ``CAPTURE`` queue, it is not possible to
> +   change format on it.

format -> the format

> +
> +To summarize, setting formats and allocation must always start with the
> +``CAPTURE`` queue and the ``CAPTURE`` queue is the master that governs the
> +set of supported formats for the ``OUTPUT`` queue.
> diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
> index 12d43fe711cf..1822c66c2154 100644
> --- a/Documentation/media/uapi/v4l/devices.rst
> +++ b/Documentation/media/uapi/v4l/devices.rst
> @@ -16,6 +16,7 @@ Interfaces
>      dev-osd
>      dev-codec
>      dev-decoder
> +    dev-encoder
>      dev-effect
>      dev-raw-vbi
>      dev-sliced-vbi
> diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
> index 65dc096199ad..2ef6693b9499 100644
> --- a/Documentation/media/uapi/v4l/v4l2.rst
> +++ b/Documentation/media/uapi/v4l/v4l2.rst
> @@ -56,6 +56,7 @@ Authors, in alphabetical order:
>  - Figa, Tomasz <tfiga@chromium.org>
>  
>    - Documented the memory-to-memory decoder interface.
> +  - Documented the memory-to-memory encoder interface.
>  
>  - H Schimek, Michael <mschimek@gmx.at>
>  
> @@ -68,6 +69,7 @@ Authors, in alphabetical order:
>  - Osciak, Pawel <posciak@chromium.org>
>  
>    - Documented the memory-to-memory decoder interface.
> +  - Documented the memory-to-memory encoder interface.
>  
>  - Osciak, Pawel <pawel@osciak.com>
>  
> 

One general comment:

you often talk about 'the driver must', e.g.:

"The driver must process and encode as normal all ``OUTPUT`` buffers
queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued."

But this is not a driver specification, it is an API specification.

I think it would be better to phrase it like this:

"All ``OUTPUT`` buffers queued by the client before the :c:func:`VIDIOC_ENCODER_CMD`
was issued will be processed and encoded as normal."

(or perhaps even 'shall' if you want to be really formal)

End-users do not really care what drivers do, they want to know what the API does,
and that implies rules for drivers.

Regards,

	Hans
