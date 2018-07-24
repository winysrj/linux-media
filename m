Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38062 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388511AbeGXPNV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 11:13:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id k3-v6so2990249pgq.5
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2018 07:06:42 -0700 (PDT)
From: Tomasz Figa <tfiga@chromium.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Tiffany=20Lin=20=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?q?Andrew-CT=20Chen=20=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        ezequiel@collabora.com, Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH 1/2] media: docs-rst: Document memory-to-memory video decoder interface
Date: Tue, 24 Jul 2018 23:06:20 +0900
Message-Id: <20180724140621.59624-2-tfiga@chromium.org>
In-Reply-To: <20180724140621.59624-1-tfiga@chromium.org>
References: <20180724140621.59624-1-tfiga@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to complexity of the video decoding process, the V4L2 drivers of
stateful decoder hardware require specific sequences of V4L2 API calls
to be followed. These include capability enumeration, initialization,
decoding, seek, pause, dynamic resolution change, drain and end of
stream.

Specifics of the above have been discussed during Media Workshops at
LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
Conference Europe 2014 in Düsseldorf. The de facto Codec API that
originated at those events was later implemented by the drivers we already
have merged in mainline, such as s5p-mfc or coda.

The only thing missing was the real specification included as a part of
Linux Media documentation. Fix it now and document the decoder part of
the Codec API.

Signed-off-by: Tomasz Figa <tfiga@chromium.org>
---
 Documentation/media/uapi/v4l/dev-decoder.rst | 872 +++++++++++++++++++
 Documentation/media/uapi/v4l/devices.rst     |   1 +
 Documentation/media/uapi/v4l/v4l2.rst        |  10 +-
 3 files changed, 882 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst

diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
new file mode 100644
index 000000000000..f55d34d2f860
--- /dev/null
+++ b/Documentation/media/uapi/v4l/dev-decoder.rst
@@ -0,0 +1,872 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _decoder:
+
+****************************************
+Memory-to-memory Video Decoder Interface
+****************************************
+
+Input data to a video decoder are buffers containing unprocessed video
+stream (e.g. Annex-B H.264/HEVC stream, raw VP8/9 stream). The driver is
+expected not to require any additional information from the client to
+process these buffers. Output data are raw video frames returned in display
+order.
+
+Performing software parsing, processing etc. of the stream in the driver
+in order to support this interface is strongly discouraged. In case such
+operations are needed, use of Stateless Video Decoder Interface (in
+development) is strongly advised.
+
+Conventions and notation used in this document
+==============================================
+
+1. The general V4L2 API rules apply if not specified in this document
+   otherwise.
+
+2. The meaning of words “must”, “may”, “should”, etc. is as per RFC
+   2119.
+
+3. All steps not marked “optional” are required.
+
+4. :c:func:`VIDIOC_G_EXT_CTRLS`, :c:func:`VIDIOC_S_EXT_CTRLS` may be used
+   interchangeably with :c:func:`VIDIOC_G_CTRL`, :c:func:`VIDIOC_S_CTRL`,
+   unless specified otherwise.
+
+5. Single-plane API (see spec) and applicable structures may be used
+   interchangeably with Multi-plane API, unless specified otherwise,
+   depending on driver capabilities and following the general V4L2
+   guidelines.
+
+6. i = [a..b]: sequence of integers from a to b, inclusive, i.e. i =
+   [0..2]: i = 0, 1, 2.
+
+7. For ``OUTPUT`` buffer A, A’ represents a buffer on the ``CAPTURE`` queue
+   containing data (decoded frame/stream) that resulted from processing
+   buffer A.
+
+Glossary
+========
+
+CAPTURE
+   the destination buffer queue; the queue of buffers containing decoded
+   frames; ``V4L2_BUF_TYPE_VIDEO_CAPTURE```` or
+   ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``; data are captured from the
+   hardware into ``CAPTURE`` buffers
+
+client
+   application client communicating with the driver implementing this API
+
+coded format
+   encoded/compressed video bitstream format (e.g. H.264, VP8, etc.); see
+   also: raw format
+
+coded height
+   height for given coded resolution
+
+coded resolution
+   stream resolution in pixels aligned to codec and hardware requirements;
+   typically visible resolution rounded up to full macroblocks;
+   see also: visible resolution
+
+coded width
+   width for given coded resolution
+
+decode order
+   the order in which frames are decoded; may differ from display order if
+   coded format includes a feature of frame reordering; ``OUTPUT`` buffers
+   must be queued by the client in decode order
+
+destination
+   data resulting from the decode process; ``CAPTURE``
+
+display order
+   the order in which frames must be displayed; ``CAPTURE`` buffers must be
+   returned by the driver in display order
+
+DPB
+   Decoded Picture Buffer; a H.264 term for a buffer that stores a picture
+   that is encoded or decoded and available for reference in further
+   decode/encode steps.
+
+EOS
+   end of stream
+
+IDR
+   a type of a keyframe in H.264-encoded stream, which clears the list of
+   earlier reference frames (DPBs)
+
+keyframe
+   an encoded frame that does not reference frames decoded earlier, i.e.
+   can be decoded fully on its own.
+
+OUTPUT
+   the source buffer queue; the queue of buffers containing encoded
+   bitstream; ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or
+   ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``; the hardware is fed with data
+   from ``OUTPUT`` buffers
+
+PPS
+   Picture Parameter Set; a type of metadata entity in H.264 bitstream
+
+raw format
+   uncompressed format containing raw pixel data (e.g. YUV, RGB formats)
+
+resume point
+   a point in the bitstream from which decoding may start/continue, without
+   any previous state/data present, e.g.: a keyframe (VP8/VP9) or
+   SPS/PPS/IDR sequence (H.264); a resume point is required to start decode
+   of a new stream, or to resume decoding after a seek
+
+source
+   data fed to the decoder; ``OUTPUT``
+
+SPS
+   Sequence Parameter Set; a type of metadata entity in H.264 bitstream
+
+visible height
+   height for given visible resolution; display height
+
+visible resolution
+   stream resolution of the visible picture, in pixels, to be used for
+   display purposes; must be smaller or equal to coded resolution;
+   display resolution
+
+visible width
+   width for given visible resolution; display width
+
+Querying capabilities
+=====================
+
+1. To enumerate the set of coded formats supported by the driver, the
+   client may call :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
+
+   * The driver must always return the full set of supported formats,
+     irrespective of the format set on the ``CAPTURE``.
+
+2. To enumerate the set of supported raw formats, the client may call
+   :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
+
+   * The driver must return only the formats supported for the format
+     currently active on ``OUTPUT``.
+
+   * In order to enumerate raw formats supported by a given coded format,
+     the client must first set that coded format on ``OUTPUT`` and then
+     enumerate the ``CAPTURE`` queue.
+
+3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
+   resolutions for a given format, passing desired pixel format in
+   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
+
+   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT``
+     must include all possible coded resolutions supported by the decoder
+     for given coded pixel format.
+
+   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE``
+     must include all possible frame buffer resolutions supported by the
+     decoder for given raw pixel format and coded format currently set on
+     ``OUTPUT``.
+
+    .. note::
+
+       The client may derive the supported resolution range for a
+       combination of coded and raw format by setting width and height of
+       ``OUTPUT`` format to 0 and calculating the intersection of
+       resolutions returned from calls to :c:func:`VIDIOC_ENUM_FRAMESIZES`
+       for the given coded and raw formats.
+
+4. Supported profiles and levels for given format, if applicable, may be
+   queried using their respective controls via :c:func:`VIDIOC_QUERYCTRL`.
+
+Initialization
+==============
+
+1. *[optional]* Enumerate supported ``OUTPUT`` formats and resolutions. See
+   capability enumeration.
+
+2. Set the coded format on ``OUTPUT`` via :c:func:`VIDIOC_S_FMT`
+
+   * **Required fields:**
+
+     ``type``
+         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
+
+     ``pixelformat``
+         a coded pixel format
+
+     ``width``, ``height``
+         required only if cannot be parsed from the stream for the given
+         coded format; optional otherwise - set to zero to ignore
+
+     other fields
+         follow standard semantics
+
+   * For coded formats including stream resolution information, if width
+     and height are set to non-zero values, the driver will propagate the
+     resolution to ``CAPTURE`` and signal a source change event
+     instantly. However, after the decoder is done parsing the
+     information embedded in the stream, it will update ``CAPTURE``
+     format with new values and signal a source change event again, if
+     the values do not match.
+
+   .. note::
+
+      Changing ``OUTPUT`` format may change currently set ``CAPTURE``
+      format. The driver will derive a new ``CAPTURE`` format from
+      ``OUTPUT`` format being set, including resolution, colorimetry
+      parameters, etc. If the client needs a specific ``CAPTURE`` format,
+      it must adjust it afterwards.
+
+3.  *[optional]* Get minimum number of buffers required for ``OUTPUT``
+    queue via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to
+    use more buffers than minimum required by hardware/format.
+
+    * **Required fields:**
+
+      ``id``
+          set to ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
+
+    * **Return fields:**
+
+      ``value``
+          required number of ``OUTPUT`` buffers for the currently set
+          format
+
+4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on
+    ``OUTPUT``.
+
+    * **Required fields:**
+
+      ``count``
+          requested number of buffers to allocate; greater than zero
+
+      ``type``
+          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
+
+      ``memory``
+          follows standard semantics
+
+      ``sizeimage``
+          follows standard semantics; the client is free to choose any
+          suitable size, however, it may be subject to change by the
+          driver
+
+    * **Return fields:**
+
+      ``count``
+          actual number of buffers allocated
+
+    * The driver must adjust count to minimum of required number of
+      ``OUTPUT`` buffers for given format and count passed. The client must
+      check this value after the ioctl returns to get the number of
+      buffers allocated.
+
+    .. note::
+
+       To allocate more than minimum number of buffers (for pipeline
+       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to
+       get minimum number of buffers required by the driver/format,
+       and pass the obtained value plus the number of additional
+       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
+
+5.  Start streaming on ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`.
+
+6.  This step only applies to coded formats that contain resolution
+    information in the stream. Continue queuing/dequeuing bitstream
+    buffers to/from the ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and
+    :c:func:`VIDIOC_DQBUF`. The driver must keep processing and returning
+    each buffer to the client until required metadata to configure the
+    ``CAPTURE`` queue are found. This is indicated by the driver sending
+    a ``V4L2_EVENT_SOURCE_CHANGE`` event with
+    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type. There is no
+    requirement to pass enough data for this to occur in the first buffer
+    and the driver must be able to process any number.
+
+    * If data in a buffer that triggers the event is required to decode
+      the first frame, the driver must not return it to the client,
+      but must retain it for further decoding.
+
+    * If the client set width and height of ``OUTPUT`` format to 0, calling
+      :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue will return -EPERM,
+      until the driver configures ``CAPTURE`` format according to stream
+      metadata.
+
+    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` events and
+      the event is signaled, the decoding process will not continue until
+      it is acknowledged by either (re-)starting streaming on ``CAPTURE``,
+      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START``
+      command.
+
+    .. note::
+
+       No decoded frames are produced during this phase.
+
+7.  This step only applies to coded formats that contain resolution
+    information in the stream.
+    Receive and handle ``V4L2_EVENT_SOURCE_CHANGE`` from the driver
+    via :c:func:`VIDIOC_DQEVENT`. The driver must send this event once
+    enough data is obtained from the stream to allocate ``CAPTURE``
+    buffers and to begin producing decoded frames.
+
+    * **Required fields:**
+
+      ``type``
+          set to ``V4L2_EVENT_SOURCE_CHANGE``
+
+    * **Return fields:**
+
+      ``u.src_change.changes``
+          set to ``V4L2_EVENT_SRC_CH_RESOLUTION``
+
+    * Any client query issued after the driver queues the event must return
+      values applying to the just parsed stream, including queue formats,
+      selection rectangles and controls.
+
+8.  Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get format for the
+    destination buffers parsed/decoded from the bitstream.
+
+    * **Required fields:**
+
+      ``type``
+          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+    * **Return fields:**
+
+      ``width``, ``height``
+          frame buffer resolution for the decoded frames
+
+      ``pixelformat``
+          pixel format for decoded frames
+
+      ``num_planes`` (for _MPLANE ``type`` only)
+          number of planes for pixelformat
+
+      ``sizeimage``, ``bytesperline``
+          as per standard semantics; matching frame buffer format
+
+    .. note::
+
+       The value of ``pixelformat`` may be any pixel format supported and
+       must be supported for current stream, based on the information
+       parsed from the stream and hardware capabilities. It is suggested
+       that driver chooses the preferred/optimal format for given
+       configuration. For example, a YUV format may be preferred over an
+       RGB format, if additional conversion step would be required.
+
+9.  *[optional]* Enumerate ``CAPTURE`` formats via
+    :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE`` queue. Once the stream
+    information is parsed and known, the client may use this ioctl to
+    discover which raw formats are supported for given stream and select on
+    of them via :c:func:`VIDIOC_S_FMT`.
+
+    .. note::
+
+       The driver will return only formats supported for the current stream
+       parsed in this initialization sequence, even if more formats may be
+       supported by the driver in general.
+
+       For example, a driver/hardware may support YUV and RGB formats for
+       resolutions 1920x1088 and lower, but only YUV for higher
+       resolutions (due to hardware limitations). After parsing
+       a resolution of 1920x1088 or lower, :c:func:`VIDIOC_ENUM_FMT` may
+       return a set of YUV and RGB pixel formats, but after parsing
+       resolution higher than 1920x1088, the driver will not return RGB,
+       unsupported for this resolution.
+
+       However, subsequent resolution change event triggered after
+       discovering a resolution change within the same stream may switch
+       the stream into a lower resolution and :c:func:`VIDIOC_ENUM_FMT`
+       would return RGB formats again in that case.
+
+10.  *[optional]* Choose a different ``CAPTURE`` format than suggested via
+     :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for the
+     client to choose a different format than selected/suggested by the
+     driver in :c:func:`VIDIOC_G_FMT`.
+
+     * **Required fields:**
+
+       ``type``
+           a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+       ``pixelformat``
+           a raw pixel format
+
+     .. note::
+
+        Calling :c:func:`VIDIOC_ENUM_FMT` to discover currently available
+        formats after receiving ``V4L2_EVENT_SOURCE_CHANGE`` is useful to
+        find out a set of allowed formats for given configuration, but not
+        required, if the client can accept the defaults.
+
+11. *[optional]* Acquire visible resolution via
+    :c:func:`VIDIOC_G_SELECTION`.
+
+    * **Required fields:**
+
+      ``type``
+          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+      ``target``
+          set to ``V4L2_SEL_TGT_COMPOSE``
+
+    * **Return fields:**
+
+      ``r.left``, ``r.top``, ``r.width``, ``r.height``
+          visible rectangle; this must fit within frame buffer resolution
+          returned by :c:func:`VIDIOC_G_FMT`.
+
+    * The driver must expose following selection targets on ``CAPTURE``:
+
+      ``V4L2_SEL_TGT_CROP_BOUNDS``
+          corresponds to coded resolution of the stream
+
+      ``V4L2_SEL_TGT_CROP_DEFAULT``
+          a rectangle covering the part of the frame buffer that contains
+          meaningful picture data (visible area); width and height will be
+          equal to visible resolution of the stream
+
+      ``V4L2_SEL_TGT_CROP``
+          rectangle within coded resolution to be output to ``CAPTURE``;
+          defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``; read-only on hardware
+          without additional compose/scaling capabilities
+
+      ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
+          maximum rectangle within ``CAPTURE`` buffer, which the cropped
+          frame can be output into; equal to ``V4L2_SEL_TGT_CROP``, if the
+          hardware does not support compose/scaling
+
+      ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
+          equal to ``V4L2_SEL_TGT_CROP``
+
+      ``V4L2_SEL_TGT_COMPOSE``
+          rectangle inside ``OUTPUT`` buffer into which the cropped frame
+          is output; defaults to ``V4L2_SEL_TGT_COMPOSE_DEFAULT``;
+          read-only on hardware without additional compose/scaling
+          capabilities
+
+      ``V4L2_SEL_TGT_COMPOSE_PADDED``
+          rectangle inside ``OUTPUT`` buffer which is overwritten by the
+          hardware; equal to ``V4L2_SEL_TGT_COMPOSE``, if the hardware
+          does not write padding pixels
+
+12. *[optional]* Get minimum number of buffers required for ``CAPTURE``
+    queue via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to
+    use more buffers than minimum required by hardware/format.
+
+    * **Required fields:**
+
+      ``id``
+          set to ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
+
+    * **Return fields:**
+
+      ``value``
+          minimum number of buffers required to decode the stream parsed in
+          this initialization sequence.
+
+    .. note::
+
+       Note that the minimum number of buffers must be at least the number
+       required to successfully decode the current stream. This may for
+       example be the required DPB size for an H.264 stream given the
+       parsed stream configuration (resolution, level).
+
+13. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQBUFS`
+    on the ``CAPTURE`` queue.
+
+    * **Required fields:**
+
+      ``count``
+          requested number of buffers to allocate; greater than zero
+
+      ``type``
+          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+      ``memory``
+          follows standard semantics
+
+    * **Return fields:**
+
+      ``count``
+          adjusted to allocated number of buffers
+
+    * The driver must adjust count to minimum of required number of
+      destination buffers for given format and stream configuration and the
+      count passed. The client must check this value after the ioctl
+      returns to get the number of buffers allocated.
+
+    .. note::
+
+       To allocate more than minimum number of buffers (for pipeline
+       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``) to
+       get minimum number of buffers required, and pass the obtained value
+       plus the number of additional buffers needed in count to
+       :c:func:`VIDIOC_REQBUFS`.
+
+14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
+
+Decoding
+========
+
+This state is reached after a successful initialization sequence. In this
+state, client queues and dequeues buffers to both queues via
+:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
+semantics.
+
+Both queues operate independently, following standard behavior of V4L2
+buffer queues and memory-to-memory devices. In addition, the order of
+decoded frames dequeued from ``CAPTURE`` queue may differ from the order of
+queuing coded frames to ``OUTPUT`` queue, due to properties of selected
+coded format, e.g. frame reordering. The client must not assume any direct
+relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
+reported by :c:type:`v4l2_buffer` ``timestamp`` field.
+
+The contents of source ``OUTPUT`` buffers depend on active coded pixel
+format and might be affected by codec-specific extended controls, as stated
+in documentation of each format individually.
+
+The client must not assume any direct relationship between ``CAPTURE``
+and ``OUTPUT`` buffers and any specific timing of buffers becoming
+available to dequeue. Specifically:
+
+* a buffer queued to ``OUTPUT`` may result in no buffers being produced
+  on ``CAPTURE`` (e.g. if it does not contain encoded data, or if only
+  metadata syntax structures are present in it),
+
+* a buffer queued to ``OUTPUT`` may result in more than 1 buffer produced
+  on ``CAPTURE`` (if the encoded data contained more than one frame, or if
+  returning a decoded frame allowed the driver to return a frame that
+  preceded it in decode, but succeeded it in display order),
+
+* a buffer queued to ``OUTPUT`` may result in a buffer being produced on
+  ``CAPTURE`` later into decode process, and/or after processing further
+  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
+  reordering is used,
+
+* buffers may become available on the ``CAPTURE`` queue without additional
+  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because of
+  ``OUTPUT`` buffers being queued in the past and decoding result of which
+  being available only at later time, due to specifics of the decoding
+  process.
+
+Seek
+====
+
+Seek is controlled by the ``OUTPUT`` queue, as it is the source of
+bitstream data. ``CAPTURE`` queue remains unchanged/unaffected.
+
+1. Stop the ``OUTPUT`` queue to begin the seek sequence via
+   :c:func:`VIDIOC_STREAMOFF`.
+
+   * **Required fields:**
+
+     ``type``
+         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
+
+   * The driver must drop all the pending ``OUTPUT`` buffers and they are
+     treated as returned to the client (following standard semantics).
+
+2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
+
+   * **Required fields:**
+
+     ``type``
+         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
+
+   * The driver must be put in a state after seek and be ready to
+     accept new source bitstream buffers.
+
+3. Start queuing buffers to ``OUTPUT`` queue containing stream data after
+   the seek until a suitable resume point is found.
+
+   .. note::
+
+      There is no requirement to begin queuing stream starting exactly from
+      a resume point (e.g. SPS or a keyframe). The driver must handle any
+      data queued and must keep processing the queued buffers until it
+      finds a suitable resume point. While looking for a resume point, the
+      driver processes ``OUTPUT`` buffers and returns them to the client
+      without producing any decoded frames.
+
+      For hardware known to be mishandling seeks to a non-resume point,
+      e.g. by returning corrupted decoded frames, the driver must be able
+      to handle such seeks without a crash or any fatal decode error.
+
+4. After a resume point is found, the driver will start returning
+   ``CAPTURE`` buffers with decoded frames.
+
+   * There is no precise specification for ``CAPTURE`` queue of when it
+     will start producing buffers containing decoded data from buffers
+     queued after the seek, as it operates independently
+     from ``OUTPUT`` queue.
+
+     * The driver is allowed to and may return a number of remaining
+       ``CAPTURE`` buffers containing decoded frames from before the seek
+       after the seek sequence (STREAMOFF-STREAMON) is performed.
+
+     * The driver is also allowed to and may not return all decoded frames
+       queued but not decode before the seek sequence was initiated. For
+       example, given an ``OUTPUT`` queue sequence: QBUF(A), QBUF(B),
+       STREAMOFF(OUT), STREAMON(OUT), QBUF(G), QBUF(H), any of the
+       following results on the ``CAPTURE`` queue is allowed: {A’, B’, G’,
+       H’}, {A’, G’, H’}, {G’, H’}.
+
+   .. note::
+
+      To achieve instantaneous seek, the client may restart streaming on
+      ``CAPTURE`` queue to discard decoded, but not yet dequeued buffers.
+
+Pause
+=====
+
+In order to pause, the client should just cease queuing buffers onto the
+``OUTPUT`` queue. This is different from the general V4L2 API definition of
+pause, which involves calling :c:func:`VIDIOC_STREAMOFF` on the queue.
+Without source bitstream data, there is no data to process and the hardware
+remains idle.
+
+Conversely, using :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue indicates
+a seek, which
+
+1. drops all ``OUTPUT`` buffers in flight and
+2. after a subsequent :c:func:`VIDIOC_STREAMON`, will look for and only
+   continue from a resume point.
+
+This is usually undesirable for pause. The STREAMOFF-STREAMON sequence is
+intended for seeking.
+
+Similarly, ``CAPTURE`` queue should remain streaming as well, as the
+STREAMOFF-STREAMON sequence on it is intended solely for changing buffer
+sets.
+
+Dynamic resolution change
+=========================
+
+A video decoder implementing this interface must support dynamic resolution
+change, for streams, which include resolution metadata in the bitstream.
+When the decoder encounters a resolution change in the stream, the dynamic
+resolution change sequence is started.
+
+1.  After encountering a resolution change in the stream, the driver must
+    first process and decode all remaining buffers from before the
+    resolution change point.
+
+2.  After all buffers containing decoded frames from before the resolution
+    change point are ready to be dequeued on the ``CAPTURE`` queue, the
+    driver sends a ``V4L2_EVENT_SOURCE_CHANGE`` event for source change
+    type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
+
+    * The last buffer from before the change must be marked with
+      :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as in the
+      drain sequence. The last buffer might be empty (with
+      :c:type:`v4l2_buffer` ``bytesused`` = 0) and must be ignored by the
+      client, since it does not contain any decoded frame.
+
+    * Any client query issued after the driver queues the event must return
+      values applying to the stream after the resolution change, including
+      queue formats, selection rectangles and controls.
+
+    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` events and
+      the event is signaled, the decoding process will not continue until
+      it is acknowledged by either (re-)starting streaming on ``CAPTURE``,
+      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START``
+      command.
+
+    .. note::
+
+       Any attempts to dequeue more buffers beyond the buffer marked
+       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
+       :c:func:`VIDIOC_DQBUF`.
+
+3.  The client calls :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` to get the new
+    format information. This is identical to calling :c:func:`VIDIOC_G_FMT`
+    after ``V4L2_EVENT_SRC_CH_RESOLUTION`` in the initialization sequence
+    and should be handled similarly.
+
+    .. note::
+
+       It is allowed for the driver not to support the same pixel format as
+       previously used (before the resolution change) for the new
+       resolution. The driver must select a default supported pixel format,
+       return it, if queried using :c:func:`VIDIOC_G_FMT`, and the client
+       must take note of it.
+
+4.  The client acquires visible resolution as in initialization sequence.
+
+5.  *[optional]* The client is allowed to enumerate available formats and
+    select a different one than currently chosen (returned via
+    :c:func:`VIDIOC_G_FMT)`. This is identical to a corresponding step in
+    the initialization sequence.
+
+6.  *[optional]* The client acquires minimum number of buffers as in
+    initialization sequence.
+
+7.  If all the following conditions are met, the client may resume the
+    decoding instantly, by using :c:func:`VIDIOC_DECODER_CMD` with
+    ``V4L2_DEC_CMD_START`` command, as in case of resuming after the drain
+    sequence:
+
+    * ``sizeimage`` of new format is less than or equal to the size of
+      currently allocated buffers,
+
+    * the number of buffers currently allocated is greater than or equal to
+      the minimum number of buffers acquired in step 6.
+
+    In such case, the remaining steps do not apply.
+
+    However, if the client intends to change the buffer set, to lower
+    memory usage or for any other reasons, it may be achieved by following
+    the steps below.
+
+8.  After dequeuing all remaining buffers from the ``CAPTURE`` queue, the
+    client must call :c:func:`VIDIOC_STREAMOFF` on the ``CAPTURE`` queue.
+    The ``OUTPUT`` queue must remain streaming (calling STREAMOFF on it
+    would trigger a seek).
+
+9.  The client frees the buffers on the ``CAPTURE`` queue using
+    :c:func:`VIDIOC_REQBUFS`.
+
+    * **Required fields:**
+
+      ``count``
+          set to 0
+
+      ``type``
+          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+      ``memory``
+          follows standard semantics
+
+10. The client allocates a new set of buffers for the ``CAPTURE`` queue via
+    :c:func:`VIDIOC_REQBUFS`. This is identical to a corresponding step in
+    the initialization sequence.
+
+11. The client resumes decoding by issuing :c:func:`VIDIOC_STREAMON` on the
+    ``CAPTURE`` queue.
+
+During the resolution change sequence, the ``OUTPUT`` queue must remain
+streaming. Calling :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue would
+initiate a seek.
+
+The ``OUTPUT`` queue operates separately from the ``CAPTURE`` queue for the
+duration of the entire resolution change sequence. It is allowed (and
+recommended for best performance and simplicity) for the client to keep
+queuing/dequeuing buffers from/to ``OUTPUT`` queue even while processing
+this sequence.
+
+.. note::
+
+   It is also possible for this sequence to be triggered without a change
+   in coded resolution, if a different number of ``CAPTURE`` buffers is
+   required in order to continue decoding the stream or the visible
+   resolution changes.
+
+Drain
+=====
+
+To ensure that all queued ``OUTPUT`` buffers have been processed and
+related ``CAPTURE`` buffers output to the client, the following drain
+sequence may be followed. After the drain sequence is complete, the client
+has received all decoded frames for all ``OUTPUT`` buffers queued before
+the sequence was started.
+
+1. Begin drain by issuing :c:func:`VIDIOC_DECODER_CMD`.
+
+   * **Required fields:**
+
+     ``cmd``
+         set to ``V4L2_DEC_CMD_STOP``
+
+     ``flags``
+         set to 0
+
+     ``pts``
+         set to 0
+
+2. The driver must process and decode as normal all ``OUTPUT`` buffers
+   queued by the client before the :c:func:`VIDIOC_DECODER_CMD` was issued.
+   Any operations triggered as a result of processing these buffers
+   (including the initialization and resolution change sequences) must be
+   processed as normal by both the driver and the client before proceeding
+   with the drain sequence.
+
+3. Once all ``OUTPUT`` buffers queued before ``V4L2_DEC_CMD_STOP`` are
+   processed:
+
+   * If the ``CAPTURE`` queue is streaming, once all decoded frames (if
+     any) are ready to be dequeued on the ``CAPTURE`` queue, the driver
+     must send a ``V4L2_EVENT_EOS``. The driver must also set
+     ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer` ``flags`` field on the
+     buffer on the ``CAPTURE`` queue containing the last frame (if any)
+     produced as a result of processing the ``OUTPUT`` buffers queued
+     before ``V4L2_DEC_CMD_STOP``. If no more frames are left to be
+     returned at the point of handling ``V4L2_DEC_CMD_STOP``, the driver
+     must return an empty buffer (with :c:type:`v4l2_buffer`
+     ``bytesused`` = 0) as the last buffer with ``V4L2_BUF_FLAG_LAST`` set
+     instead. Any attempts to dequeue more buffers beyond the buffer marked
+     with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
+     :c:func:`VIDIOC_DQBUF`.
+
+   * If the ``CAPTURE`` queue is NOT streaming, no action is necessary for
+     ``CAPTURE`` queue and the driver must send a ``V4L2_EVENT_EOS``
+     immediately after all ``OUTPUT`` buffers in question have been
+     processed.
+
+4. At this point, decoding is paused and the driver will accept, but not
+   process any newly queued ``OUTPUT`` buffers until the client issues
+   ``V4L2_DEC_CMD_START`` or restarts streaming on any queue.
+
+* Once the drain sequence is initiated, the client needs to drive it to
+  completion, as described by the above steps, unless it aborts the process
+  by issuing :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue.  The client
+  is not allowed to issue ``V4L2_DEC_CMD_START`` or ``V4L2_DEC_CMD_STOP``
+  again while the drain sequence is in progress and they will fail with
+  -EBUSY error code if attempted.
+
+* Restarting streaming on ``OUTPUT`` queue will implicitly end the paused
+  state and reinitialize the decoder (similarly to the seek sequence).
+  Restarting ``CAPTURE`` queue will not affect an in-progress drain
+  sequence.
+
+* The drivers must also implement :c:func:`VIDIOC_TRY_DECODER_CMD`, as a
+  way to let the client query the availability of decoder commands.
+
+End of stream
+=============
+
+If the decoder encounters an end of stream marking in the stream, the
+driver must send a ``V4L2_EVENT_EOS`` event to the client after all frames
+are decoded and ready to be dequeued on the ``CAPTURE`` queue, with the
+:c:type:`v4l2_buffer` ``flags`` set to ``V4L2_BUF_FLAG_LAST``. This
+behavior is identical to the drain sequence triggered by the client via
+``V4L2_DEC_CMD_STOP``.
+
+Commit points
+=============
+
+Setting formats and allocating buffers triggers changes in the behavior
+of the driver.
+
+1. Setting format on ``OUTPUT`` queue may change the set of formats
+   supported/advertised on the ``CAPTURE`` queue. In particular, it also
+   means that ``CAPTURE`` format may be reset and the client must not
+   rely on the previously set format being preserved.
+
+2. Enumerating formats on ``CAPTURE`` queue must only return formats
+   supported for the ``OUTPUT`` format currently set.
+
+3. Setting/changing format on ``CAPTURE`` queue does not change formats
+   available on ``OUTPUT`` queue. An attempt to set ``CAPTURE`` format that
+   is not supported for the currently selected ``OUTPUT`` format must
+   result in the driver adjusting the requested format to an acceptable
+   one.
+
+4. Enumerating formats on ``OUTPUT`` queue always returns the full set of
+   supported coded formats, irrespective of the current ``CAPTURE``
+   format.
+
+5. After allocating buffers on the ``OUTPUT`` queue, it is not possible to
+   change format on it.
+
+To summarize, setting formats and allocation must always start with the
+``OUTPUT`` queue and the ``OUTPUT`` queue is the master that governs the
+set of supported formats for the ``CAPTURE`` queue.
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index fb7f8c26cf09..12d43fe711cf 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -15,6 +15,7 @@ Interfaces
     dev-output
     dev-osd
     dev-codec
+    dev-decoder
     dev-effect
     dev-raw-vbi
     dev-sliced-vbi
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index b89e5621ae69..65dc096199ad 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -53,6 +53,10 @@ Authors, in alphabetical order:
 
   - Original author of the V4L2 API and documentation.
 
+- Figa, Tomasz <tfiga@chromium.org>
+
+  - Documented the memory-to-memory decoder interface.
+
 - H Schimek, Michael <mschimek@gmx.at>
 
   - Original author of the V4L2 API and documentation.
@@ -61,6 +65,10 @@ Authors, in alphabetical order:
 
   - Documented the Digital Video timings API.
 
+- Osciak, Pawel <posciak@chromium.org>
+
+  - Documented the memory-to-memory decoder interface.
+
 - Osciak, Pawel <pawel@osciak.com>
 
   - Designed and documented the multi-planar API.
@@ -85,7 +93,7 @@ Authors, in alphabetical order:
 
   - Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended control ioctls, major parts of the sliced VBI API, the MPEG encoder and decoder APIs and the DV Timings API.
 
-**Copyright** |copy| 1999-2016: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari.
+**Copyright** |copy| 1999-2018: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari, Tomasz Figa
 
 Except when explicitly stated as GPL, programming examples within this
 part can be used and distributed without restrictions.
-- 
2.18.0.233.g985f88cf7e-goog
