Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33375 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbeJSQOh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 12:14:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id s4-v6so15547387plp.0
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2018 01:09:38 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH v3] media: docs-rst: Document m2m stateless video decoder interface
Date: Fri, 19 Oct 2018 17:09:28 +0900
Message-Id: <20181019080928.208446-1-acourbot@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks everyone for the feedback on v2! I have not replied to all the
individual emails but hope this v3 will address some of the problems
raised and become a continuation point for the topics still in
discussion (probably during the ELCE Media Summit).

This patch documents the protocol that user-space should follow when
communicating with stateless video decoders. It is based on the
following references:

* The current protocol used by Chromium (converted from config store to
  request API)

* The submitted Cedrus VPU driver

As such, some things may not be entirely consistent with the current
state of drivers, so it would be great if all stakeholders could point
out these inconsistencies. :)

This patch is supposed to be applied on top of the Request API V18 as
well as the memory-to-memory video decoder interface series by Tomasz
Figa.

Changes since v2:

* Specify that the frame header controls should be set prior to
  enumerating the CAPTURE queue, instead of the profile which as Paul
  and Tomasz pointed out is not enough to know which raw formats will be
  usable.
* Change V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM to
  V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS.
* Various rewording and rephrasing

Two points being currently discussed have not been changed in this
revision due to lack of better idea. Of course this is open to change:

* The restriction of having to send full frames for each input buffer is
  kept as-is. As Hans pointed, we currently have a hard limit of 32
  buffers per queue, and it may be non-trivial to lift. Also some codecs
  (at least Venus AFAIK) do have this restriction in hardware, so unless
  we want to do some buffer-rearranging in-kernel, it is probably better
  to keep the default behavior as-is. Finally, relaxing the rule should
  be easy enough if we add one extra control to query whether the
  hardware can work with slice units, as opposed to frame units.

* The other hot topic is the use of capture buffer indexes in order to
  reference frames. I understand the concerns, but I doesn't seem like
  we have come with a better proposal so far - and since capture buffers
  are essentially well, frames, using their buffer index to directly
  reference them doesn't sound too inappropriate to me. There is also
  the restriction that drivers must return capture buffers in queue
  order. Do we have any concrete example where this scenario would not
  work?

As usual, thanks for the insightful comments, and let's make sure we are
ready for a fruitful discussion during the Summit! :)

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 .../media/uapi/v4l/dev-stateless-decoder.rst  | 360 ++++++++++++++++++
 Documentation/media/uapi/v4l/devices.rst      |   1 +
 .../media/uapi/v4l/extended-controls.rst      |  25 ++
 .../media/uapi/v4l/pixfmt-compressed.rst      |  54 ++-
 4 files changed, 436 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst

diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
new file mode 100644
index 000000000000..d9a0092adcb7
--- /dev/null
+++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
@@ -0,0 +1,360 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _stateless_decoder:
+
+**************************************************
+Memory-to-memory Stateless Video Decoder Interface
+**************************************************
+
+A stateless decoder is a decoder that works without retaining any kind of state
+between processing frames. This means that each frame is decoded independently
+of any previous and future frames, and that the client is responsible for
+maintaining the decoding state and providing it to the driver. This is in
+contrast to the stateful video decoder interface, where the hardware maintains
+the decoding state and all the client has to do is to provide the raw encoded
+stream.
+
+This section describes how user-space ("the client") is expected to communicate
+with such decoders in order to successfully decode an encoded stream. Compared
+to stateful codecs, the driver/client sequence is simpler, but the cost of this
+simplicity is extra complexity in the client which must maintain a consistent
+decoding state.
+
+Querying capabilities
+=====================
+
+1. To enumerate the set of coded formats supported by the driver, the client
+   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
+
+   * The driver must always return the full set of supported ``OUTPUT`` formats,
+     irrespective of the format currently set on the ``CAPTURE`` queue.
+
+   * Simultaneously, the driver must restrain the set of values returned by
+     codec-specific capability controls (such as H.264 profiles) to the set
+     actually supported by the hardware.
+
+2. To enumerate the set of supported raw formats, the client calls
+   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
+
+   * The driver must return only the formats supported for the format currently
+     active on the ``OUTPUT`` queue.
+
+   * Depending on the currently set ``OUTPUT`` format, the set of supported raw
+     formats may depend on the value of some controls (e.g. parsed format
+     headers) which are codec-dependent. The client is responsible for making
+     sure that these controls are set before querying the ``CAPTURE`` queue.
+     Failure to do so will result in the default values for these controls being
+     used, and a returned set of formats that may not be usable for the media
+     the client is trying to decode.
+
+3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
+   resolutions for a given format, passing desired pixel format in
+   :c:type:`v4l2_frmsizeenum`'s ``pixel_format``.
+
+   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT`` queue
+     must include all possible coded resolutions supported by the decoder
+     for the current coded pixel format.
+
+   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE`` queue
+     must include all possible frame buffer resolutions supported by the
+     decoder for given raw pixel format and coded format currently set on
+     ``OUTPUT`` queue.
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
+   "Querying capabilities".
+
+2. Set the coded format on the ``OUTPUT`` queue via :c:func:`VIDIOC_S_FMT`
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
+         coded width and height parsed from the stream
+
+     other fields
+         follow standard semantics
+
+   .. note::
+
+      Changing ``OUTPUT`` format may change currently set ``CAPTURE``
+      format. The driver will derive a new ``CAPTURE`` format from the
+      ``OUTPUT`` format being set, including resolution, colorimetry
+      parameters, etc. If the client needs a specific ``CAPTURE`` format,
+      it must adjust it afterwards.
+
+3. Call :c:func:`VIDIOC_S_EXT_CTRLS` to set all the controls (parsed headers,
+   etc.) required by the ``OUTPUT`` format to enumerate the ``CAPTURE`` formats.
+
+4. Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get the format for the
+   destination buffers parsed/decoded from the bitstream.
+
+   * **Required fields:**
+
+     ``type``
+         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+   * **Returned fields:**
+
+     ``width``, ``height``
+         frame buffer resolution for the decoded frames
+
+     ``pixelformat``
+         pixel format for decoded frames
+
+     ``num_planes`` (for _MPLANE ``type`` only)
+         number of planes for pixelformat
+
+     ``sizeimage``, ``bytesperline``
+         as per standard semantics; matching frame buffer format
+
+   .. note::
+
+      The value of ``pixelformat`` may be any pixel format supported for the
+      ``OUTPUT`` format, based on the hardware capabilities. It is suggested
+      that driver chooses the preferred/optimal format for the current
+      configuration. For example, a YUV format may be preferred over an RGB
+      format, if an additional conversion step would be required for RGB.
+
+5. *[optional]* Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_ENUM_FMT` on
+   the ``CAPTURE`` queue. The client may use this ioctl to discover which
+   alternative raw formats are supported for the current ``OUTPUT`` format and
+   select one of them via :c:func:`VIDIOC_S_FMT`.
+
+   .. note::
+
+      The driver will return only formats supported for the currently selected
+      ``OUTPUT`` format, even if more formats may be supported by the driver in
+      general.
+
+      For example, a driver/hardware may support YUV and RGB formats for
+      resolutions 1920x1088 and lower, but only YUV for higher resolutions (due
+      to hardware limitations). After setting a resolution of 1920x1088 or lower
+      as the ``OUTPUT`` format, :c:func:`VIDIOC_ENUM_FMT` may return a set of
+      YUV and RGB pixel formats, but after setting a resolution higher than
+      1920x1088, the driver will not return RGB pixel formats, since they are
+      unsupported for this resolution.
+
+6. *[optional]* Choose a different ``CAPTURE`` format than suggested via
+   :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for the client to
+   choose a different format than selected/suggested by the driver in
+   :c:func:`VIDIOC_G_FMT`.
+
+    * **Required fields:**
+
+      ``type``
+          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
+
+      ``pixelformat``
+          a raw pixel format
+
+7. Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on
+   ``OUTPUT`` queue.
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
+    * The driver must adjust count to the minimum of required number of
+      ``OUTPUT`` buffers for the given format and requested count. The client
+      must check this value after the ioctl returns to get the number of buffers
+      allocated.
+
+    .. note::
+
+       To allocate more than the minimum number of buffers (for pipeline depth),
+       use c:func:`VIDIOC_G_CTRL` (``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to get
+       the minimum number of buffers required by the driver/format, and pass the
+       obtained value plus the number of additional buffers needed in count to
+       :c:func:`VIDIOC_REQBUFS`.
+
+8. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQBUFS` on the
+   ``CAPTURE`` queue.
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
+    * The driver must adjust count to the minimum of required number of
+      ``CAPTURE`` buffers for the current format, stream configuration and
+      requested count. The client must check this value after the ioctl
+      returns to get the number of buffers allocated.
+
+    .. note::
+
+       To allocate more than the minimum number of buffers (for pipeline depth),
+       use c:func:`VIDIOC_G_CTRL` (``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``) to get
+       the minimum number of buffers required by the driver/format, and pass the
+       obtained value plus the number of additional buffers needed in count to
+       :c:func:`VIDIOC_REQBUFS`.
+
+9. Allocate requests (likely one per ``OUTPUT`` buffer) via
+    :c:func:`MEDIA_IOC_REQUEST_ALLOC` on the media device.
+
+10. Start streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
+    :c:func:`VIDIOC_STREAMON`.
+
+Decoding
+========
+
+For each frame, the client is responsible for submitting a request to which the
+following is attached:
+
+* Exactly one frame worth of encoded data in a buffer submitted to the
+  ``OUTPUT`` queue,
+* All the controls relevant to the format being decoded (see below for details).
+
+.. note::
+
+   The API currently requires one frame of encoded data per ``OUTPUT`` buffer,
+   even though some encoded formats may present their data in smaller chunks
+   (e.g. H.264's frames can be made of several slices that can be processed
+   independently). It is currently the responsibility of the client to gather
+   the different parts of a frame into a single ``OUTPUT`` buffer, if required
+   by the encoded format. This restriction may be lifted in the future.
+
+``CAPTURE`` buffers must not be part of the request, and are queued
+independently. The driver will always pick the least recently queued ``CAPTURE``
+buffer and decode the frame into it. ``CAPTURE`` buffers will be returned in
+decode order (i.e. the same order as ``OUTPUT`` buffers were submitted),
+therefore it is trivial for the client to know which ``CAPTURE`` buffer will
+be used for a given frame. This point is essential for referencing frames since
+we use the ``CAPTURE`` buffer index for that.
+
+If the request is submitted without an ``OUTPUT`` buffer, then
+:c:func:`MEDIA_REQUEST_IOC_QUEUE` will return ``-ENOENT``. If more than one
+buffer is queued, or if some of the required controls are missing, then it will
+return ``-EINVAL``. Decoding errors are signaled by the ``CAPTURE`` buffers
+being dequeued carrying the ``V4L2_BUF_FLAG_ERROR`` flag. If a reference frame
+has an error, then all other frames that refer to it will also have the
+``V4L2_BUF_FLAG_ERROR`` flag set.
+
+The contents of source ``OUTPUT`` buffers, as well as the controls that must be
+set on the request, depend on active coded pixel format and might be affected by
+codec-specific extended controls, as stated in documentation of each format.
+
+Buffer management during decoding
+=================================
+Contrary to stateful decoder drivers, a stateless decoder driver does not
+perform any kind of buffer management. It only guarantees that ``CAPTURE``
+buffers will be dequeued in the same order as they are queued, and that
+``OUTPUT`` buffers will be processed in queue order. This allows user-space to
+know in advance which ``CAPTURE`` buffer will contain a given frame, and thus to
+use that buffer ID as the key to indicate a reference frame.
+
+This also means that user-space is fully responsible for not re-queuing a
+``CAPTURE`` buffer as long as it is used as a reference frame. Failure to do so
+will result in the reference frame's data being overwritten while still in use,
+and visual corruption of future frames.
+
+Note that this applies to all types of buffers, and not only to
+``V4L2_MEMORY_MMAP`` ones. Drivers supporting ``V4L2_MEMORY_DMABUF`` will
+typically maintain a map of buffer IDs to DMABUF handles for reference frame
+management. Queueing a buffer will result in the map entry to be overwritten
+with the new DMABUF handle submitted in the :c:func:`VIDIOC_QBUF` ioctl, and
+the previous DMABUF handles to be freed.
+
+Seek
+====
+In order to seek, the client just needs to submit requests using input buffers
+corresponding to the new stream position. It must however be aware that
+resolution may have changed and follow the dynamic resolution change sequence in
+that case. Also depending on the codec used, picture parameters (e.g. SPS/PPS
+for H.264) may have changed and the client is responsible for making sure that
+a valid state is sent to the kernel.
+
+The client is then free to ignore any returned ``CAPTURE`` buffer that comes
+from the pre-seek position.
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
+Dynamic resolution change
+=========================
+
+If the client detects a resolution change in the stream, it will need to perform
+the initialization sequence again with the new resolution:
+
+1. Wait until all submitted requests have completed and dequeue the
+   corresponding output buffers.
+
+2. Call :c:func:`VIDIOC_STREAMOFF` on both the ``OUTPUT`` and ``CAPTURE``
+   queues.
+
+3. Free all buffers by calling :c:func:`VIDIOC_REQBUFS` on the
+   ``OUTPUT`` and ``CAPTURE`` queues with a buffer count of zero.
+
+Then perform the initialization sequence again, with the new resolution set
+on the ``OUTPUT`` queue. Note that due to resolution constraints, a different
+format may need to be picked on the ``CAPTURE`` queue.
+
+Drain
+=====
+
+In order to drain the stream on a stateless decoder, the client just needs to
+wait until all the submitted requests are completed. There is no need to send a
+``V4L2_DEC_CMD_STOP`` command since requests are processed sequentially by the
+driver.
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
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index 1822c66c2154..a8e568eda7d8 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -16,6 +16,7 @@ Interfaces
     dev-osd
     dev-codec
     dev-decoder
+    dev-stateless-decoder
     dev-encoder
     dev-effect
     dev-raw-vbi
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index a9252225b63e..afffb64c47d0 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -810,6 +810,31 @@ enum v4l2_mpeg_video_bitrate_mode -
     otherwise the decoder expects a single frame in per buffer.
     Applicable to the decoder, all codecs.
 
+.. _v4l2-mpeg-h264:
+
+``V4L2_CID_MPEG_VIDEO_H264_SPS``
+    Instance of struct v4l2_ctrl_h264_sps, containing the SPS of to use with
+    the next queued frame. Applicable to the H.264 stateless decoder.
+
+``V4L2_CID_MPEG_VIDEO_H264_PPS``
+    Instance of struct v4l2_ctrl_h264_pps, containing the PPS of to use with
+    the next queued frame. Applicable to the H.264 stateless decoder.
+
+``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX``
+    Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the scaling
+    matrix to use when decoding the next queued frame. Applicable to the H.264
+    stateless decoder.
+
+``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS``
+    Array of struct v4l2_ctrl_h264_slice_param, containing at least as many
+    entries as there are slices in the corresponding ``OUTPUT`` buffer.
+    Applicable to the H.264 stateless decoder.
+
+``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM``
+    Instance of struct v4l2_ctrl_h264_decode_param, containing the high-level
+    decoding parameters for a H.264 frame. Applicable to the H.264 stateless
+    decoder.
+
 ``V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE (boolean)``
     Enable writing sample aspect ratio in the Video Usability
     Information. Applicable to the H264 encoder.
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index a86b59f770dd..c68af3313cfb 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -35,6 +35,42 @@ Compressed Formats
       - ``V4L2_PIX_FMT_H264``
       - 'H264'
       - H264 video elementary stream with start codes.
+    * .. _V4L2-PIX-FMT-H264-SLICE:
+
+      - ``V4L2_PIX_FMT_H264_SLICE``
+      - 'H264'
+      - H264 parsed slice data, as extracted from the H264 bitstream.
+        This format is adapted for stateless video decoders using the M2M and
+        Request APIs.
+
+        ``OUTPUT`` buffers must contain all the macroblock slices of a given
+        frame, i.e. if a frame requires several macroblock slices to be entirely
+        decoded, then all these slices must be provided. In addition, the
+        following metadata controls must be set on the request for each frame:
+
+        V4L2_CID_MPEG_VIDEO_H264_SPS
+           Instance of struct v4l2_ctrl_h264_sps, containing the SPS of to use
+           with the frame.
+
+        V4L2_CID_MPEG_VIDEO_H264_PPS
+           Instance of struct v4l2_ctrl_h264_pps, containing the PPS of to use
+           with the frame.
+
+        V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX
+           Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the
+           scaling matrix to use when decoding the frame.
+
+        V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS
+           Array of struct v4l2_ctrl_h264_slice_param, containing at least as
+           many entries as there are slices in the corresponding ``OUTPUT``
+           buffer.
+
+        V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM
+           Instance of struct v4l2_ctrl_h264_decode_param, containing the
+           high-level decoding parameters for a H.264 frame.
+
+        See the :ref:`associated Codec Control IDs <v4l2-mpeg-h264>` for the
+        format of these controls.
     * .. _V4L2-PIX-FMT-H264-NO-SC:
 
       - ``V4L2_PIX_FMT_H264_NO_SC``
@@ -67,10 +103,20 @@ Compressed Formats
       - MPEG-2 parsed slice data, as extracted from the MPEG-2 bitstream.
 	This format is adapted for stateless video decoders that implement a
 	MPEG-2 pipeline (using the Memory to Memory and Media Request APIs).
-	Metadata associated with the frame to decode is required to be passed
-	through the ``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS`` control and
-	quantization matrices can optionally be specified through the
-	``V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION`` control.
+
+        ``OUTPUT`` buffers must contain all the macroblock slices of a given
+        frame, i.e. if a frame requires several macroblock slices to be entirely
+        decoded, then all these slices must be provided. In addition, the
+        following metadata controls must be set on the request for each frame:
+
+        V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS
+          Slice parameters (one per slice) for the current frame.
+
+        Optional controls:
+
+        V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION
+          Quantization matrices for the current frame.
+
 	See the :ref:`associated Codec Control IDs <v4l2-mpeg-mpeg2>`.
 	Buffers associated with this pixel format must contain the appropriate
 	number of macroblocks to decode a full corresponding frame.
-- 
2.19.1.568.g152ad8e336-goog
