Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58CAC282C6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87803218A6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kKFIHjMd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfAXKEk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:04:40 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42270 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727404AbfAXKEk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:04:40 -0500
Received: by mail-pf1-f196.google.com with SMTP id 64so2733005pfr.9
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 02:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bgl3hMHDTRKPIj4k25E850ksjTpXfVKCYLmuA5aZM4=;
        b=kKFIHjMdo2HOfL87aBACPCkWgDUxFJQDxVFubpPp4/SHpCEhrGT0CpyNJuiFH6w0Kg
         zRRD08jC0IPLH4XWcQcfsmHZ29M/dtbuLecQDUm7HpkW7iTnxLkOFJXuYotqHixZJ50I
         JKzgMLmaYF63Hs/W7N0WNy7G7sKbm0+q6dR1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bgl3hMHDTRKPIj4k25E850ksjTpXfVKCYLmuA5aZM4=;
        b=TbeE1JKEPxsaPVWZXXOclRfgbkzqT7LrQ4uqEN1xx9E3LKPVj4GvbJLqzVDmnmRX23
         2665TgzhnCv+FFUldPGxpmdlqMHTlPwj9HZ15uq6Ogz4747T4DGFOJKveDTYjESahM90
         0JbvthFh318yfgGp+yN5Q3tYx4588qSibt95DeKrf7PcGXzxJFtVUwoQP2dCIsPdbuIf
         hHm5p5Fc7Ou2oJ95S4RfGe/2NwiQ7kz26K6mDyn2DdjYr71OtQ883G1QrvWmNYnnEMYN
         QXI2GlaxKuvs1LY1ofRQhV6FCv45DYFaJc+DOqgjmwFQscGs8c7vKkHs9KGBM0NEvfCb
         zNKQ==
X-Gm-Message-State: AJcUukcmihHxIReX4MHnOD41Ki/Sp8v27B6ijp2GeC/MgGONodUaKMQY
        ArNICiOYFHvX1UH58yxBTpTphiQBjOJYnJDt
X-Google-Smtp-Source: ALg8bN7riIBbwGO9XIigihRE3U5/AYvUQ0oLSANPJ7RSnBNdxlpmZmHtFJ5Efx8JOcX2zVCc9MYQzw==
X-Received: by 2002:a63:a41:: with SMTP id z1mr5297206pgk.117.1548324277240;
        Thu, 24 Jan 2019 02:04:37 -0800 (PST)
Received: from tfiga.tok.corp.google.com ([2401:fa00:4:4:6d27:f13:a0fa:d4b6])
        by smtp.gmail.com with ESMTPSA id r66sm33533969pfk.157.2019.01.24.02.04.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:04:36 -0800 (PST)
From:   Tomasz Figa <tfiga@chromium.org>
To:     linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Tiffany=20Lin=20=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?q?Andrew-CT=20Chen=20=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH v3 1/2] media: docs-rst: Document memory-to-memory video decoder interface
Date:   Thu, 24 Jan 2019 19:04:18 +0900
Message-Id: <20190124100419.26492-2-tfiga@chromium.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190124100419.26492-1-tfiga@chromium.org>
References: <20190124100419.26492-1-tfiga@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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
 Documentation/media/uapi/v4l/dev-decoder.rst  | 1076 +++++++++++++++++
 Documentation/media/uapi/v4l/dev-mem2mem.rst  |    5 +
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
 Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
 6 files changed, 1135 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst

diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
new file mode 100644
index 000000000000..b7db2352ad41
--- /dev/null
+++ b/Documentation/media/uapi/v4l/dev-decoder.rst
@@ -0,0 +1,1076 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _decoder:
+
+*************************************************
+Memory-to-memory Stateful Video Decoder Interface
+*************************************************
+
+A stateful video decoder takes complete chunks of the bitstream (e.g. Annex-B
+H.264/HEVC stream, raw VP8/9 stream) and decodes them into raw video frames in
+display order. The decoder is expected not to require any additional information
+from the client to process these buffers.
+
+Performing software parsing, processing etc. of the stream in the driver in
+order to support this interface is strongly discouraged. In case such
+operations are needed, use of the Stateless Video Decoder Interface (in
+development) is strongly advised.
+
+Conventions and notation used in this document
+==============================================
+
+1. The general V4L2 API rules apply if not specified in this document
+   otherwise.
+
+2. The meaning of words "must", "may", "should", etc. is as per `RFC
+   2119 <https://tools.ietf.org/html/rfc2119>`_.
+
+3. All steps not marked "optional" are required.
+
+4. :c:func:`VIDIOC_G_EXT_CTRLS` and :c:func:`VIDIOC_S_EXT_CTRLS` may be used
+   interchangeably with :c:func:`VIDIOC_G_CTRL` and :c:func:`VIDIOC_S_CTRL`,
+   unless specified otherwise.
+
+5. Single-planar API (see :ref:`planar-apis`) and applicable structures may be
+   used interchangeably with multi-planar API, unless specified otherwise,
+   depending on decoder capabilities and following the general V4L2 guidelines.
+
+6. i = [a..b]: sequence of integers from a to b, inclusive, i.e. i =
+   [0..2]: i = 0, 1, 2.
+
+7. Given an ``OUTPUT`` buffer A, then A’ represents a buffer on the ``CAPTURE``
+   queue containing data that resulted from processing buffer A.
+
+.. _decoder-glossary:
+
+Glossary
+========
+
+CAPTURE
+   the destination buffer queue; for decoders, the queue of buffers containing
+   decoded frames; for encoders, the queue of buffers containing encoded
+   bitstream; ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
+   ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``; data is captured from the hardware
+   into ``CAPTURE`` buffers
+
+client
+   application client communicating with the decoder or encoder implementing
+   this interface
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
+   the order in which frames are decoded; may differ from display order if the
+   coded format includes a feature of frame reordering; for decoders,
+   ``OUTPUT`` buffers must be queued by the client in decode order; for
+   encoders ``CAPTURE`` buffers must be returned by the encoder in decode order
+
+destination
+   data resulting from the decode process; see ``CAPTURE``
+
+display order
+   the order in which frames must be displayed; for encoders, ``OUTPUT``
+   buffers must be queued by the client in display order; for decoders,
+   ``CAPTURE`` buffers must be returned by the decoder in display order
+
+DPB
+   Decoded Picture Buffer; an H.264 term for a buffer that stores a decoded
+   raw frame available for reference in further decoding steps.
+
+EOS
+   end of stream
+
+IDR
+   Instantaneous Decoder Refresh; a type of a keyframe in H.264-encoded stream,
+   which clears the list of earlier reference frames (DPBs)
+
+keyframe
+   an encoded frame that does not reference frames decoded earlier, i.e.
+   can be decoded fully on its own.
+
+macroblock
+   a processing unit in image and video compression formats based on linear
+   block transforms (e.g. H.264, VP8, VP9); codec-specific, but for most of
+   popular codecs the size is 16x16 samples (pixels)
+
+OUTPUT
+   the source buffer queue; for decoders, the queue of buffers containing
+   encoded bitstream; for encoders, the queue of buffers containing raw frames;
+   ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``; the
+   hardware is fed with data from ``OUTPUT`` buffers
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
+   data fed to the decoder or encoder; see ``OUTPUT``
+
+source height
+   height in pixels for given source resolution; relevant to encoders only
+
+source resolution
+   resolution in pixels of source frames being source to the encoder and
+   subject to further cropping to the bounds of visible resolution; relevant to
+   encoders only
+
+source width
+   width in pixels for given source resolution; relevant to encoders only
+
+SPS
+   Sequence Parameter Set; a type of metadata entity in H.264 bitstream
+
+stream metadata
+   additional (non-visual) information contained inside encoded bitstream;
+   for example: coded resolution, visible resolution, codec profile
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
+State machine
+=============
+
+.. kernel-render:: DOT
+   :alt: DOT digraph of decoder state machine
+   :caption: Decoder state machine
+
+   digraph decoder_state_machine {
+       node [shape = doublecircle, label="Decoding"] Decoding;
+
+       node [shape = circle, label="Initialization"] Initialization;
+       node [shape = circle, label="Capture\nsetup"] CaptureSetup;
+       node [shape = circle, label="Dynamic\nresolution\nchange"] ResChange;
+       node [shape = circle, label="Stopped"] Stopped;
+       node [shape = circle, label="Drain"] Drain;
+       node [shape = circle, label="Seek"] Seek;
+       node [shape = circle, label="End of stream"] EoS;
+
+       node [shape = point]; qi
+       qi -> Initialization [ label = "open()" ];
+
+       Initialization -> CaptureSetup [ label = "CAPTURE\nformat\nestablished" ];
+
+       CaptureSetup -> Stopped [ label = "CAPTURE\nbuffers\nready" ];
+
+       Decoding -> ResChange [ label = "Stream\nresolution\nchange" ];
+       Decoding -> Drain [ label = "V4L2_DEC_CMD_STOP" ];
+       Decoding -> EoS [ label = "EoS mark\nin the stream" ];
+       Decoding -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
+       Decoding -> Stopped [ label = "VIDIOC_STREAMOFF(CAPTURE)" ];
+       Decoding -> Decoding;
+
+       ResChange -> CaptureSetup [ label = "CAPTURE\nformat\nestablished" ];
+       ResChange -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
+
+       EoS -> Drain [ label = "Implicit\ndrain" ];
+
+       Drain -> Stopped [ label = "All CAPTURE\nbuffers dequeued\nor\nVIDIOC_STREAMOFF(CAPTURE)" ];
+       Drain -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
+
+       Seek -> Decoding [ label = "VIDIOC_STREAMON(OUTPUT)" ];
+       Seek -> Initialization [ label = "VIDIOC_REQBUFS(OUTPUT, 0)" ];
+
+       Stopped -> Decoding [ label = "V4L2_DEC_CMD_START\nor\nVIDIOC_STREAMON(CAPTURE)" ];
+       Stopped -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
+   }
+
+Querying capabilities
+=====================
+
+1. To enumerate the set of coded formats supported by the decoder, the
+   client may call :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
+
+   * The full set of supported formats will be returned, regardless of the
+     format set on ``CAPTURE``.
+
+2. To enumerate the set of supported raw formats, the client may call
+   :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
+
+   * Only the formats supported for the format currently active on ``OUTPUT``
+     will be returned.
+
+   * In order to enumerate raw formats supported by a given coded format,
+     the client must first set that coded format on ``OUTPUT`` and then
+     enumerate formats on ``CAPTURE``.
+
+3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
+   resolutions for a given format, passing desired pixel format in
+   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
+
+   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` for a coded pixel
+     format will include all possible coded resolutions supported by the
+     decoder for given coded pixel format.
+
+   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` for a raw pixel format
+     will include all possible frame buffer resolutions supported by the
+     decoder for given raw pixel format and the coded format currently set on
+     ``OUTPUT``.
+
+4. Supported profiles and levels for the coded format currently set on
+   ``OUTPUT``, if applicable, may be queried using their respective controls
+   via :c:func:`VIDIOC_QUERYCTRL`.
+
+Initialization
+==============
+
+1. Set the coded format on ``OUTPUT`` via :c:func:`VIDIOC_S_FMT`
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
+     ``sizeimage``
+         desired size of ``OUTPUT`` buffers; the decoder may adjust it to
+         match hardware requirements
+
+     other fields
+         follow standard semantics
+
+   * **Return fields:**
+
+     ``sizeimage``
+         adjusted size of ``OUTPUT`` buffers
+
+   * If width and height are set to non-zero values, the ``CAPTURE`` format
+     will be updated with an appropriate frame buffer resolution instantly.
+     However, for coded formats that include stream resolution information,
+     after the decoder is done parsing the information from the stream, it will
+     update the ``CAPTURE`` format with new values and signal a source change
+     event, regardless of whether they match the values set by the client or
+     not.
+
+   .. important::
+
+      Changing the ``OUTPUT`` format may change the currently set ``CAPTURE``
+      format. The decoder will derive a new ``CAPTURE`` format from the
+      ``OUTPUT`` format being set, including resolution, colorimetry
+      parameters, etc. If the client needs a specific ``CAPTURE`` format, it
+      must adjust it afterwards.
+
+2.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on
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
+    * **Return fields:**
+
+      ``count``
+          the actual number of buffers allocated
+
+    .. warning::
+
+       The actual number of allocated buffers may differ from the ``count``
+       given. The client must check the updated value of ``count`` after the
+       call returns.
+
+    Alternatively, :c:func:`VIDIOC_CREATE_BUFS` on the ``OUTPUT`` queue can be
+    used to have more control over buffer allocation.
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
+      ``format``
+          follows standard semantics
+
+    * **Return fields:**
+
+      ``count``
+          adjusted to the number of allocated buffers
+
+    .. warning::
+
+       The actual number of allocated buffers may differ from the ``count``
+       given. The client must check the updated value of ``count`` after the
+       call returns.
+
+3.  Start streaming on the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`.
+
+4.  **This step only applies to coded formats that contain resolution information
+    in the stream.** Continue queuing/dequeuing bitstream buffers to/from the
+    ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`. The
+    buffers will be processed and returned to the client in order, until
+    required metadata to configure the ``CAPTURE`` queue are found. This is
+    indicated by the decoder sending a ``V4L2_EVENT_SOURCE_CHANGE`` event with
+    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type.
+
+    * It is not an error if the first buffer does not contain enough data for
+      this to occur. Processing of the buffers will continue as long as more
+      data is needed.
+
+    * If data in a buffer that triggers the event is required to decode the
+      first frame, it will not be returned to the client, until the
+      initialization sequence completes and the frame is decoded.
+
+    * If the client sets width and height of the ``OUTPUT`` format to 0,
+      calling :c:func:`VIDIOC_G_FMT`, :c:func:`VIDIOC_S_FMT`,
+      :c:func:`VIDIOC_TRY_FMT` or :c:func:`VIDIOC_REQBUFS` on the ``CAPTURE``
+      queue will return the ``-EACCES`` error code, until the decoder
+      configures ``CAPTURE`` format according to stream metadata.
+
+    .. important::
+
+       Any client query issued after the decoder queues the event will return
+       values applying to the just parsed stream, including queue formats,
+       selection rectangles and controls.
+
+    .. note::
+
+       A client capable of acquiring stream parameters from the bitstream on
+       its own may attempt to set the width and height of the ``OUTPUT`` format
+       to non-zero values matching the coded size of the stream, skip this step
+       and continue with the `Capture setup` sequence. However, it must not
+       rely on any driver queries regarding stream parameters, such as
+       selection rectangles and controls, since the decoder has not parsed them
+       from the stream yet. If the values configured by the client do not match
+       those parsed by the decoder, a `Dynamic resolution change` will be
+       triggered to reconfigure them.
+
+    .. note::
+
+       No decoded frames are produced during this phase.
+
+5.  Continue with the `Capture setup` sequence.
+
+Capture setup
+=============
+
+1.  Call :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue to get format for the
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
+       The value of ``pixelformat`` may be any pixel format supported by the
+       decoder for the current stream. The decoder should choose a
+       preferred/optimal format for the default configuration. For example, a
+       YUV format may be preferred over an RGB format if an additional
+       conversion step would be required for the latter.
+
+2.  **Optional.** Acquire the visible resolution via
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
+          the visible rectangle; it must fit within the frame buffer resolution
+          returned by :c:func:`VIDIOC_G_FMT` on ``CAPTURE``.
+
+    * The following selection targets are supported on ``CAPTURE``:
+
+      ``V4L2_SEL_TGT_CROP_BOUNDS``
+          corresponds to the coded resolution of the stream
+
+      ``V4L2_SEL_TGT_CROP_DEFAULT``
+          the rectangle covering the part of the ``CAPTURE`` buffer that
+          contains meaningful picture data (visible area); width and height
+          will be equal to the visible resolution of the stream
+
+      ``V4L2_SEL_TGT_CROP``
+          the rectangle within the coded resolution to be output to
+          ``CAPTURE``; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``; read-only on
+          hardware without additional compose/scaling capabilities
+
+      ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
+          the maximum rectangle within a ``CAPTURE`` buffer, which the cropped
+          frame can be composed into; equal to ``V4L2_SEL_TGT_CROP`` if the
+          hardware does not support compose/scaling
+
+      ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
+          equal to ``V4L2_SEL_TGT_CROP``
+
+      ``V4L2_SEL_TGT_COMPOSE``
+          the rectangle inside a ``CAPTURE`` buffer into which the cropped
+          frame is written; defaults to ``V4L2_SEL_TGT_COMPOSE_DEFAULT``;
+          read-only on hardware without additional compose/scaling capabilities
+
+      ``V4L2_SEL_TGT_COMPOSE_PADDED``
+          the rectangle inside a ``CAPTURE`` buffer which is overwritten by the
+          hardware; equal to ``V4L2_SEL_TGT_COMPOSE`` if the hardware does not
+          write padding pixels
+
+    .. warning::
+
+       The values are guaranteed to be meaningful only after the decoder
+       successfully parses the stream metadata. The client must not rely on the
+       query before that happens.
+
+3.  Query the minimum number of buffers required for the ``CAPTURE`` queue via
+    :c:func:`VIDIOC_G_CTRL`. This enables the client to request more buffers
+    than the minimum required by hardware/format and achieve better pipelining.
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
+       The minimum number of buffers must be at least the number required to
+       successfully decode the current stream. This may for example be the
+       required DPB size for an H.264 stream given the parsed stream
+       configuration (resolution, level).
+
+    .. warning::
+
+       The value is guaranteed to be meaningful only after the decoder
+       successfully parses the stream metadata. The client must not rely on the
+       query before that happens.
+
+4.  **Optional.** Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_ENUM_FMT` on
+    the ``CAPTURE`` queue. Once the stream information is parsed and known, the
+    client may use this ioctl to discover which raw formats are supported for
+    given stream and select one of them via :c:func:`VIDIOC_S_FMT`.
+
+    .. important::
+
+       The decoder will return only formats supported for the currently
+       established coded format, as per the ``OUTPUT`` format and/or stream
+       metadata parsed in this initialization sequence, even if more formats
+       may be supported by the decoder in general. In other words, the set
+       returned will be a subset of the initial query mentioned in the
+       `Querying capabilities` section.
+
+       For example, a decoder may support YUV and RGB formats for resolutions
+       1920x1088 and lower, but only YUV for higher resolutions (due to
+       hardware limitations). After parsing a resolution of 1920x1088 or lower,
+       :c:func:`VIDIOC_ENUM_FMT` may return a set of YUV and RGB pixel formats,
+       but after parsing resolution higher than 1920x1088, the decoder will not
+       return RGB, unsupported for this resolution.
+
+       However, subsequent resolution change event triggered after
+       discovering a resolution change within the same stream may switch
+       the stream into a lower resolution and :c:func:`VIDIOC_ENUM_FMT`
+       would return RGB formats again in that case.
+
+5.  **Optional.** Set the ``CAPTURE`` format via :c:func:`VIDIOC_S_FMT` on the
+    ``CAPTURE`` queue. The client may choose a different format than
+    selected/suggested by the decoder in :c:func:`VIDIOC_G_FMT`.
+
+    * **Required fields:**
+
+      ``type``
+          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+      ``pixelformat``
+          a raw pixel format
+
+6.  If all the following conditions are met, the client may resume the decoding
+    instantly:
+
+    * ``sizeimage`` of the new format (determined in previous steps) is less
+      than or equal to the size of currently allocated buffers,
+
+    * the number of buffers currently allocated is greater than or equal to the
+      minimum number of buffers acquired in previous steps. To fulfill this
+      requirement, the client may use :c:func:`VIDIOC_CREATE_BUFS` to add new
+      buffers.
+
+    In that case, the remaining steps do not apply and the client may resume
+    the decoding by one of the following actions:
+
+    * if the ``CAPTURE`` queue is streaming, call :c:func:`VIDIOC_DECODER_CMD`
+      with the ``V4L2_DEC_CMD_START`` command,
+
+    * if the ``CAPTURE`` queue is not streaming, call :c:func:`VIDIOC_STREAMON`
+      on the ``CAPTURE`` queue.
+
+    However, if the client intends to change the buffer set, to lower
+    memory usage or for any other reasons, it may be achieved by following
+    the steps below.
+
+7.  **If the** ``CAPTURE`` **queue is streaming,** keep queuing and dequeuing
+    buffers on the ``CAPTURE`` queue until a buffer marked with the
+    ``V4L2_BUF_FLAG_LAST`` flag is dequeued.
+
+8.  **If the** ``CAPTURE`` **queue is streaming,** call :c:func:`VIDIOC_STREAMOFF`
+    on the ``CAPTURE`` queue to stop streaming.
+
+    .. warning::
+
+       The ``OUTPUT`` queue must remain streaming. Calling
+       :c:func:`VIDIOC_STREAMOFF` on it would abort the sequence and trigger a
+       seek.
+
+9.  **If the** ``CAPTURE`` **queue has buffers allocated,** free the ``CAPTURE``
+    buffers using :c:func:`VIDIOC_REQBUFS`.
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
+10. Allocate ``CAPTURE`` buffers via :c:func:`VIDIOC_REQBUFS` on the
+    ``CAPTURE`` queue.
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
+          actual number of buffers allocated
+
+    .. warning::
+
+       The actual number of allocated buffers may differ from the ``count``
+       given. The client must check the updated value of ``count`` after the
+       call returns.
+
+    .. note::
+
+       To allocate more than the minimum number of buffers (for pipeline
+       depth), the client may query the ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
+       control to get the minimum number of buffers required, and pass the
+       obtained value plus the number of additional buffers needed in the
+       ``count`` field to :c:func:`VIDIOC_REQBUFS`.
+
+    Alternatively, :c:func:`VIDIOC_CREATE_BUFS` on the ``CAPTURE`` queue can be
+    used to have more control over buffer allocation. For example, by
+    allocating buffers larger than the current ``CAPTURE`` format, future
+    resolution changes can be accommodated.
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
+      ``format``
+          a format representing the maximum framebuffer resolution to be
+          accommodated by newly allocated buffers
+
+    * **Return fields:**
+
+      ``count``
+          adjusted to the number of allocated buffers
+
+    .. warning::
+
+       The actual number of allocated buffers may differ from the ``count``
+       given. The client must check the updated value of ``count`` after the
+       call returns.
+
+    .. note::
+
+       To allocate buffers for a format different than parsed from the stream
+       metadata, the client must proceed as follows, before the metadata
+       parsing is initiated:
+
+       * set width and height of the ``OUTPUT`` format to desired coded resolution to
+         let the decoder configure the ``CAPTURE`` format appropriately,
+
+       * query the ``CAPTURE`` format using :c:func:`VIDIOC_G_FMT` and save it
+         until this step.
+
+       The format obtained in the query may be then used with
+       :c:func:`VIDIOC_CREATE_BUFS` in this step to allocate the buffers.
+
+11. Call :c:func:`VIDIOC_STREAMON` on the ``CAPTURE`` queue to start decoding
+    frames.
+
+Decoding
+========
+
+This state is reached after the `Capture setup` sequence finishes successfully.
+In this state, the client queues and dequeues buffers to both queues via
+:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following the standard
+semantics.
+
+The contents of the source ``OUTPUT`` buffers depend on the active coded pixel
+format and may be affected by codec-specific extended controls, as stated in
+the documentation of each format.
+
+Both queues operate independently, following the standard behavior of V4L2
+buffer queues and memory-to-memory devices. In addition, the order of decoded
+frames dequeued from the ``CAPTURE`` queue may differ from the order of queuing
+coded frames to the ``OUTPUT`` queue, due to properties of the selected coded
+format, e.g. frame reordering.
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
+  returning a decoded frame allowed the decoder to return a frame that
+  preceded it in decode, but succeeded it in the display order),
+
+* a buffer queued to ``OUTPUT`` may result in a buffer being produced on
+  ``CAPTURE`` later into decode process, and/or after processing further
+  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
+  reordering is used,
+
+* buffers may become available on the ``CAPTURE`` queue without additional
+  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because of the
+  ``OUTPUT`` buffers queued in the past whose decoding results are only
+  available at later time, due to specifics of the decoding process.
+
+.. note::
+
+   To allow matching decoded ``CAPTURE`` buffers with ``OUTPUT`` buffers they
+   originated from, the client can set the ``timestamp`` field of the
+   :c:type:`v4l2_buffer` struct when queuing an ``OUTPUT`` buffer. The
+   ``CAPTURE`` buffer(s), which resulted from decoding that ``OUTPUT`` buffer
+   will have their ``timestamp`` field set to the same value when dequeued.
+
+   In addition to the straightforward case of one ``OUTPUT`` buffer producing
+   one ``CAPTURE`` buffer, the following cases are defined:
+
+   * one ``OUTPUT`` buffer generates multiple ``CAPTURE`` buffers: the same
+     ``OUTPUT`` timestamp will be copied to multiple ``CAPTURE`` buffers,
+
+   * multiple ``OUTPUT`` buffers generate one ``CAPTURE`` buffer: timestamp of
+     the ``OUTPUT`` buffer queued last will be copied,
+
+   * the decoding order differs from the display order (i.e. the ``CAPTURE``
+     buffers are out-of-order compared to the ``OUTPUT`` buffers): ``CAPTURE``
+     timestamps will not retain the order of ``OUTPUT`` timestamps.
+
+During the decoding, the decoder may initiate one of the special sequences, as
+listed below. The sequences will result in the decoder returning all the
+``CAPTURE`` buffers that originated from all the ``OUTPUT`` buffers processed
+before the sequence started. Last of the buffers will have the
+``V4L2_BUF_FLAG_LAST`` flag set. To determine the sequence to follow, the client
+must check if there is any pending event and:
+
+* if a ``V4L2_EVENT_SOURCE_CHANGE`` event is pending, the `Dynamic resolution
+  change` sequence needs to be followed,
+
+* if a ``V4L2_EVENT_EOS`` event is pending, the `End of stream` sequence needs
+  to be followed.
+
+Some of the sequences can be intermixed with each other and need to be handled
+as they happen. The exact operation is documented for each sequence.
+
+Should a decoding error occur, it will be reported to the client with the level
+of details depending on the decoder capabilities. Specifically:
+
+* the CAPTURE buffer that contains the results of the failed decode operation
+  will be returned with the V4L2_BUF_FLAG_ERROR flag set,
+
+* if the decoder is able to precisely report the OUTPUT buffer that triggered
+  the error, such bufffer will be returned with the V4L2_BUF_FLAG_ERROR flag
+  set.
+
+In case of a fatal failure that does not allow the decoding to continue, any
+further opertions on corresponding decoder file handle will return the -EIO
+error code. The client may close the file handle and open a new one, or
+alternatively reinitialize the instance by stopping streaming on both queues,
+releasing all buffers and performing the Initialization sequence again.
+
+Seek
+====
+
+Seek is controlled by the ``OUTPUT`` queue, as it is the source of coded data.
+The seek does not require any specific operation on the ``CAPTURE`` queue, but
+it may be affected as per normal decoder operation.
+
+1. Stop the ``OUTPUT`` queue to begin the seek sequence via
+   :c:func:`VIDIOC_STREAMOFF`.
+
+   * **Required fields:**
+
+     ``type``
+         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
+
+   * The decoder will drop all the pending ``OUTPUT`` buffers and they must be
+     treated as returned to the client (following standard semantics).
+
+2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
+
+   * **Required fields:**
+
+     ``type``
+         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
+
+   * The decoder will start accepting new source bitstream buffers after the
+     call returns.
+
+3. Start queuing buffers containing coded data after the seek to the ``OUTPUT``
+   queue until a suitable resume point is found.
+
+   .. note::
+
+      There is no requirement to begin queuing coded data starting exactly
+      from a resume point (e.g. SPS or a keyframe). Any queued ``OUTPUT``
+      buffers will be processed and returned to the client until a suitable
+      resume point is found.  While looking for a resume point, the decoder
+      should not produce any decoded frames into ``CAPTURE`` buffers.
+
+      Some hardware is known to mishandle seeks to a non-resume point. Such an
+      operation may result in an unspecified number of corrupted decoded frames
+      being made available on the ``CAPTURE`` queue. Drivers must ensure that
+      no fatal decoding errors or crashes occur, and implement any necessary
+      handling and workarounds for hardware issues related to seek operations.
+
+   .. warning::
+
+      In case of the H.264 codec, the client must take care not to seek over a
+      change of SPS/PPS. Even though the target frame could be a keyframe, the
+      stale SPS/PPS inside decoder state would lead to undefined results when
+      decoding. Although the decoder must handle that case without a crash or a
+      fatal decode error, the client must not expect a sensible decode output.
+
+      If the hardware can detect such corrupted decoded frames, then
+      corresponding buffers will be returned to the client with the
+      V4L2_BUF_FLAG_ERROR set. See the `Decoding` section for further
+      description of decode error reporting.
+
+4. After a resume point is found, the decoder will start returning ``CAPTURE``
+   buffers containing decoded frames.
+
+.. important::
+
+   A seek may result in the `Dynamic resolution change` sequence being
+   iniitated, due to the seek target having decoding parameters different from
+   the part of the stream decoded before the seek. The sequence must be handled
+   as per normal decoder operation.
+
+.. warning::
+
+   It is not specified when the ``CAPTURE`` queue starts producing buffers
+   containing decoded data from the ``OUTPUT`` buffers queued after the seek,
+   as it operates independently from the ``OUTPUT`` queue.
+
+   The decoder may return a number of remaining ``CAPTURE`` buffers containing
+   decoded frames originating from the ``OUTPUT`` buffers queued before the
+   seek sequence is performed.
+
+   The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
+   ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` buffers
+   queued before the seek sequence may have matching ``CAPTURE`` buffers
+   produced.  For example, given the sequence of operations on the
+   ``OUTPUT`` queue:
+
+     QBUF(A), QBUF(B), STREAMOFF(), STREAMON(), QBUF(G), QBUF(H),
+
+   any of the following results on the ``CAPTURE`` queue is allowed:
+
+     {A’, B’, G’, H’}, {A’, G’, H’}, {G’, H’}.
+
+   To determine the CAPTURE buffer containing the first decoded frame after the
+   seek, the client may observe the timestamps to match the CAPTURE and OUTPUT
+   buffers or use V4L2_DEC_CMD_STOP and V4L2_DEC_CMD_START to drain the
+   decoder.
+
+.. note::
+
+   To achieve instantaneous seek, the client may restart streaming on the
+   ``CAPTURE`` queue too to discard decoded, but not yet dequeued buffers.
+
+Dynamic resolution change
+=========================
+
+Streams that include resolution metadata in the bitstream may require switching
+to a different resolution during the decoding.
+
+The sequence starts when the decoder detects a coded frame with one or more of
+the following parameters different from previously established (and reflected
+by corresponding queries):
+
+* coded resolution (``OUTPUT`` width and height),
+
+* visible resolution (selection rectangles),
+
+* the minimum number of buffers needed for decoding.
+
+Whenever that happens, the decoder must proceed as follows:
+
+1.  After encountering a resolution change in the stream, the decoder sends a
+    ``V4L2_EVENT_SOURCE_CHANGE`` event with source change type set to
+    ``V4L2_EVENT_SRC_CH_RESOLUTION``.
+
+    .. important::
+
+       Any client query issued after the decoder queues the event will return
+       values applying to the stream after the resolution change, including
+       queue formats, selection rectangles and controls.
+
+2.  The decoder will then process and decode all remaining buffers from before
+    the resolution change point.
+
+    * The last buffer from before the change must be marked with the
+      ``V4L2_BUF_FLAG_LAST`` flag, similarly to the `Drain` sequence above.
+
+    .. warning::
+
+       The last buffer may be empty (with :c:type:`v4l2_buffer` ``bytesused``
+       = 0) and in that case it must be ignored by the client, as it does not
+       contain a decoded frame.
+
+    .. note::
+
+       Any attempt to dequeue more buffers beyond the buffer marked with
+       ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
+       :c:func:`VIDIOC_DQBUF`.
+
+The client must continue the sequence as described below to continue the
+decoding process.
+
+1.  Dequeue the source change event.
+
+    .. important::
+
+       A source change triggers an implicit decoder drain, similar to the
+       explicit `Drain` sequence. The decoder is stopped after it completes.
+       The decoding process must be resumed with either a pair of calls to
+       :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
+       ``CAPTURE`` queue, or a call to :c:func:`VIDIOC_DECODER_CMD` with the
+       ``V4L2_DEC_CMD_START`` command.
+
+2.  Continue with the `Capture setup` sequence.
+
+.. note::
+
+   During the resolution change sequence, the ``OUTPUT`` queue must remain
+   streaming. Calling :c:func:`VIDIOC_STREAMOFF` on the ``OUTPUT`` queue would
+   abort the sequence and initiate a seek.
+
+   In principle, the ``OUTPUT`` queue operates separately from the ``CAPTURE``
+   queue and this remains true for the duration of the entire resolution change
+   sequence as well.
+
+   The client should, for best performance and simplicity, keep queuing/dequeuing
+   buffers to/from the ``OUTPUT`` queue even while processing this sequence.
+
+Drain
+=====
+
+To ensure that all queued ``OUTPUT`` buffers have been processed and related
+``CAPTURE`` buffers are given to the client, the client must follow the drain
+sequence described below. After the drain sequence ends, the client has
+received all decoded frames for all ``OUTPUT`` buffers queued before the
+sequence was started.
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
+   .. warning::
+
+      The sequence can be only initiated if both ``OUTPUT`` and ``CAPTURE``
+      queues are streaming. For compatibility reasons, the call to
+      :c:func:`VIDIOC_DECODER_CMD` will not fail even if any of the queues is
+      not streaming, but at the same time it will not initiate the `Drain`
+      sequence and so the steps described below would not be applicable.
+
+2. Any ``OUTPUT`` buffers queued by the client before the
+   :c:func:`VIDIOC_DECODER_CMD` was issued will be processed and decoded as
+   normal. The client must continue to handle both queues independently,
+   similarly to normal decode operation. This includes:
+
+   * handling any operations triggered as a result of processing those buffers,
+     such as the `Dynamic resolution change` sequence, before continuing with
+     the drain sequence,
+
+   * queuing and dequeuing ``CAPTURE`` buffers, until a buffer marked with the
+     ``V4L2_BUF_FLAG_LAST`` flag is dequeued,
+
+     .. warning::
+
+        The last buffer may be empty (with :c:type:`v4l2_buffer`
+        ``bytesused`` = 0) and in that case it must be ignored by the client,
+        as it does not contain a decoded frame.
+
+     .. note::
+
+        Any attempt to dequeue more buffers beyond the buffer marked with
+        ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
+        :c:func:`VIDIOC_DQBUF`.
+
+   * dequeuing processed ``OUTPUT`` buffers, until all the buffers queued
+     before the ``V4L2_DEC_CMD_STOP`` command are dequeued.
+
+   * dequeuing the ``V4L2_EVENT_EOS`` event, if the client subscribed to it.
+
+   .. note::
+
+      For backwards compatibility, the decoder will signal a ``V4L2_EVENT_EOS``
+      event when the last frame has been decoded and all frames are ready to be
+      dequeued. It is a deprecated behavior and the client must not rely on it.
+      The ``V4L2_BUF_FLAG_LAST`` buffer flag should be used instead.
+
+3. Once all the ``OUTPUT`` buffers queued before the ``V4L2_DEC_CMD_STOP`` call
+   are dequeued and the last ``CAPTURE`` buffer is dequeued, the decoder is
+   stopped and it will accept, but not process, any newly queued ``OUTPUT``
+   buffers until the client issues any of the following operations:
+
+   * ``V4L2_DEC_CMD_START`` - the decoder will not be reset and will resume
+     operation normally, with all the state from before the drain,
+
+   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
+     ``CAPTURE`` queue - the decoder will resume the operation normally,
+     however any ``CAPTURE`` buffers still in the queue will be returned to the
+     client,
+
+   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
+     ``OUTPUT`` queue - any pending source buffers will be returned to the
+     client and the `Seek` sequence will be triggered.
+
+.. note::
+
+   Once the drain sequence is initiated, the client needs to drive it to
+   completion, as described by the steps above, unless it aborts the process by
+   issuing :c:func:`VIDIOC_STREAMOFF` on any of the ``OUTPUT`` or ``CAPTURE``
+   queues.  The client is not allowed to issue ``V4L2_DEC_CMD_START`` or
+   ``V4L2_DEC_CMD_STOP`` again while the drain sequence is in progress and they
+   will fail with -EBUSY error code if attempted.
+
+   Although mandatory, the availability of decoder commands may be queried
+   using :c:func:`VIDIOC_TRY_DECODER_CMD`.
+
+End of stream
+=============
+
+If the decoder encounters an end of stream marking in the stream, the decoder
+will initiate the `Drain` sequence, which the client must handle as described
+above, skipping the initial :c:func:`VIDIOC_DECODER_CMD`.
+
+Commit points
+=============
+
+Setting formats and allocating buffers trigger changes in the behavior of the
+decoder.
+
+1. Setting the format on the ``OUTPUT`` queue may change the set of formats
+   supported/advertised on the ``CAPTURE`` queue. In particular, it also means
+   that the ``CAPTURE`` format may be reset and the client must not rely on the
+   previously set format being preserved.
+
+2. Enumerating formats on the ``CAPTURE`` queue always returns only formats
+   supported for the current ``OUTPUT`` format.
+
+3. Setting the format on the ``CAPTURE`` queue does not change the list of
+   formats available on the ``OUTPUT`` queue. An attempt to set the ``CAPTURE``
+   format that is not supported for the currently selected ``OUTPUT`` format
+   will result in the decoder adjusting the requested ``CAPTURE`` format to a
+   supported one.
+
+4. Enumerating formats on the ``OUTPUT`` queue always returns the full set of
+   supported coded formats, irrespectively of the current ``CAPTURE`` format.
+
+5. While buffers are allocated on the ``OUTPUT`` queue, the client must not
+   change the format on the queue. Drivers will return the -EBUSY error code
+   for any such format change attempt.
+
+To summarize, setting formats and allocation must always start with the
+``OUTPUT`` queue and the ``OUTPUT`` queue is the master that governs the
+set of supported formats for the ``CAPTURE`` queue.
diff --git a/Documentation/media/uapi/v4l/dev-mem2mem.rst b/Documentation/media/uapi/v4l/dev-mem2mem.rst
index 67a980818dc8..a0e06a88c872 100644
--- a/Documentation/media/uapi/v4l/dev-mem2mem.rst
+++ b/Documentation/media/uapi/v4l/dev-mem2mem.rst
@@ -13,6 +13,11 @@
 Video Memory-To-Memory Interface
 ********************************
 
+.. toctree::
+    :maxdepth: 1
+
+    dev-decoder
+
 A V4L2 memory-to-memory device can compress, decompress, transform, or
 otherwise convert video data from one format into another format, in memory.
 Such memory-to-memory devices set the ``V4L2_CAP_VIDEO_M2M`` or
diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
index 71eebfc6d853..caf14e440447 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
@@ -39,6 +39,11 @@ Single-planar format structure
 	to a multiple of the scale factor of any smaller planes. For
 	example when the image format is YUV 4:2:0, ``width`` and
 	``height`` must be multiples of two.
+
+	For compressed formats that contain the resolution information encoded
+	inside the stream, when fed to a stateful mem2mem decoder, the fields
+	may be zero to rely on the decoder to detect the right values. For more
+	details see :ref:`decoder` and format descriptions.
     * - __u32
       - ``pixelformat``
       - The pixel format or type of compression, set by the application.
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index 004ec00db6bd..97015b9b40b8 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -60,6 +60,10 @@ Authors, in alphabetical order:
 
   - Original author of the V4L2 API and documentation.
 
+- Figa, Tomasz <tfiga@chromium.org>
+
+  - Documented the memory-to-memory decoder interface.
+
 - H Schimek, Michael <mschimek@gmx.at>
 
   - Original author of the V4L2 API and documentation.
@@ -68,6 +72,10 @@ Authors, in alphabetical order:
 
   - Documented the Digital Video timings API.
 
+- Osciak, Pawel <posciak@chromium.org>
+
+  - Documented the memory-to-memory decoder interface.
+
 - Osciak, Pawel <pawel@osciak.com>
 
   - Designed and documented the multi-planar API.
@@ -92,7 +100,7 @@ Authors, in alphabetical order:
 
   - Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended control ioctls, major parts of the sliced VBI API, the MPEG encoder and decoder APIs and the DV Timings API.
 
-**Copyright** |copy| 1999-2016: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari.
+**Copyright** |copy| 1999-2018: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari, Tomasz Figa
 
 Except when explicitly stated as GPL, programming examples within this
 part can be used and distributed without restrictions.
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index ccf83b05afa7..a23ef1b194dc 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -56,14 +56,16 @@ The ``cmd`` field must contain the command code. Some commands use the
 
 A :ref:`write() <func-write>` or :ref:`VIDIOC_STREAMON`
 call sends an implicit START command to the decoder if it has not been
-started yet.
+started yet. Applies to both queues of mem2mem decoders.
 
 A :ref:`close() <func-close>` or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
 call of a streaming file descriptor sends an implicit immediate STOP
-command to the decoder, and all buffered data is discarded.
+command to the decoder, and all buffered data is discarded. Applies to both
+queues of mem2mem decoders.
 
-These ioctls are optional, not all drivers may support them. They were
-introduced in Linux 3.3.
+In principle, these ioctls are optional, not all drivers may support them. They were
+introduced in Linux 3.3. They are, however, mandatory for stateful mem2mem decoders
+(as further documented in :ref:`decoder`).
 
 
 .. tabularcolumns:: |p{1.1cm}|p{2.4cm}|p{1.2cm}|p{1.6cm}|p{10.6cm}|
@@ -167,26 +169,36 @@ introduced in Linux 3.3.
 	``V4L2_DEC_CMD_RESUME`` for that. This command has one flag:
 	``V4L2_DEC_CMD_START_MUTE_AUDIO``. If set, then audio will be
 	muted when playing back at a non-standard speed.
+
+	For stateful mem2mem decoders, the command may be also used to restart
+	the decoder in case of an implicit stop initiated by the decoder
+	itself, without the ``V4L2_DEC_CMD_STOP`` being called explicitly.
+	No flags or other arguments are accepted in case of mem2mem decoders.
+	See :ref:`decoder` for more details.
     * - ``V4L2_DEC_CMD_STOP``
       - 1
       - Stop the decoder. When the decoder is already stopped, this
 	command does nothing. This command has two flags: if
 	``V4L2_DEC_CMD_STOP_TO_BLACK`` is set, then the decoder will set
 	the picture to black after it stopped decoding. Otherwise the last
-	image will repeat. mem2mem decoders will stop producing new frames
-	altogether. They will send a ``V4L2_EVENT_EOS`` event when the
-	last frame has been decoded and all frames are ready to be
-	dequeued and will set the ``V4L2_BUF_FLAG_LAST`` buffer flag on
-	the last buffer of the capture queue to indicate there will be no
-	new buffers produced to dequeue. This buffer may be empty,
-	indicated by the driver setting the ``bytesused`` field to 0. Once
-	the ``V4L2_BUF_FLAG_LAST`` flag was set, the
-	:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
-	but return an ``EPIPE`` error code. If
+	image will repeat. If
 	``V4L2_DEC_CMD_STOP_IMMEDIATELY`` is set, then the decoder stops
 	immediately (ignoring the ``pts`` value), otherwise it will keep
 	decoding until timestamp >= pts or until the last of the pending
 	data from its internal buffers was decoded.
+
+	A stateful mem2mem decoder will proceed with decoding the source
+	buffers pending before the command is issued and then stop producing
+	new frames. It will send a ``V4L2_EVENT_EOS`` event when the last frame
+	has been decoded and all frames are ready to be dequeued and will set
+	the ``V4L2_BUF_FLAG_LAST`` buffer flag on the last buffer of the
+	capture queue to indicate there will be no new buffers produced to
+	dequeue. This buffer may be empty, indicated by the driver setting the
+	``bytesused`` field to 0. Once the buffer with the
+	``V4L2_BUF_FLAG_LAST`` flag set was dequeued, the :ref:`VIDIOC_DQBUF
+	<VIDIOC_QBUF>` ioctl will not block anymore, but return an ``EPIPE``
+	error code. No flags or other arguments are accepted in case of mem2mem
+	decoders.  See :ref:`decoder` for more details.
     * - ``V4L2_DEC_CMD_PAUSE``
       - 2
       - Pause the decoder. When the decoder has not been started yet, the
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index e35a9caff652..78980efc0bab 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -60,6 +60,13 @@ devices that is either the struct
 member. When the requested buffer type is not supported drivers return
 an ``EINVAL`` error code.
 
+A stateful mem2mem decoder will not allow operations on the
+``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``
+buffer type until the corresponding ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or
+``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` buffer type is configured. If such an
+operation is attempted, drivers return an ``EACCES`` error code. Refer to
+:ref:`decoder` for more details.
+
 To change the current format parameters applications initialize the
 ``type`` field and all fields of the respective ``fmt`` union member.
 For details see the documentation of the various devices types in
@@ -157,6 +164,13 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
+EACCES
+    The format is not accessible until another buffer type is configured.
+    Relevant for the V4L2_BUF_TYPE_VIDEO_CAPTURE and
+    V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE buffer types of mem2mem decoders, which
+    require the format of V4L2_BUF_TYPE_VIDEO_OUTPUT or
+    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer type to be configured first.
+
 EINVAL
     The struct :c:type:`v4l2_format` ``type`` field is
     invalid or the requested buffer type not supported.
-- 
2.20.1.321.g9e740568ce-goog

