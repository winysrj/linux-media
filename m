Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:41243 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbeJINDl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 09:03:41 -0400
Received: by mail-yb1-f193.google.com with SMTP id e16-v6so151928ybk.8
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 22:48:28 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id q126-v6sm6951198ywf.7.2018.10.08.22.48.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 22:48:26 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id 135-v6so154588ywo.8
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 22:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20181004081119.102575-1-acourbot@chromium.org>
In-Reply-To: <20181004081119.102575-1-acourbot@chromium.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 Oct 2018 14:48:13 +0900
Message-ID: <CAAFQd5Dof21_8ZK6mDHCm89oF-pTD=VN5hPC5Y9g_oLWi2UVng@mail.gmail.com>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On Thu, Oct 4, 2018 at 5:11 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> This patch documents the protocol that user-space should follow when
> communicating with stateless video decoders. It is based on the
> following references:
>
> * The current protocol used by Chromium (converted from config store to
>   request API)
>
> * The submitted Cedrus VPU driver
>
> As such, some things may not be entirely consistent with the current
> state of drivers, so it would be great if all stakeholders could point
> out these inconsistencies. :)
>
> This patch is supposed to be applied on top of the Request API V18 as
> well as the memory-to-memory video decoder interface series by Tomasz
> Figa.
>
> Changes since V1:
>
> * Applied fixes received as feedback,
> * Moved controls descriptions to the extended controls file,
> * Document reference frame management and referencing (need Hans' feedback on
>   that).
>

Please take a look at my comments inline.

> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  .../media/uapi/v4l/dev-stateless-decoder.rst  | 348 ++++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst      |   1 +
>  .../media/uapi/v4l/extended-controls.rst      |  25 ++
>  .../media/uapi/v4l/pixfmt-compressed.rst      |  54 ++-
>  4 files changed, 424 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
>
> diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> new file mode 100644
> index 000000000000..e54246df18d0
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> @@ -0,0 +1,348 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _stateless_decoder:
> +
> +**************************************************
> +Memory-to-memory Stateless Video Decoder Interface
> +**************************************************
> +
> +A stateless decoder is a decoder that works without retaining any kind of state
> +between processing frames. This means that each frame is decoded independently
> +of any previous and future frames,

nit: It sounds weird, because there are still dependencies between
frames, next frame may use previous frame as a reference. How about
dropping the whole

"each frame is decoded independently of any previous and future frames,"

and just making it

"This means that the client is responsible for maintaining all the
decoding state and providing it to the driver"?

> and that the client is responsible for
> +maintaining the decoding state and providing it to the driver. This is in
> +contrast to the stateful video decoder interface, where the hardware maintains
> +the decoding state and all the client has to do is to provide the raw encoded
> +stream.
> +
> +This section describes how user-space ("the client") is expected to communicate
> +with such decoders in order to successfully decode an encoded stream. Compared
> +to stateful codecs, the driver/client sequence is simpler, but the cost of this
> +simplicity is extra complexity in the client which must maintain a consistent
> +decoding state.
> +
> +Querying capabilities
> +=====================
> +
> +1. To enumerate the set of coded formats supported by the driver, the client
> +   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
> +
> +   * The driver must always return the full set of supported ``OUTPUT`` formats,
> +     irrespective of the format currently set on the ``CAPTURE`` queue.
> +
> +2. To enumerate the set of supported raw formats, the client calls
> +   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
> +
> +   * The driver must return only the formats supported for the format currently
> +     active on the ``OUTPUT`` queue.
> +
> +   * Depending on the currently set ``OUTPUT`` format, the set of supported raw
> +     formats may depend on the value of some controls (e.g. H264 or VP9
> +     profile). The client is responsible for making sure that these controls

I wouldn't explicitly mention profile here, since we already agreed
that profile actually is not very helpful. Perhaps more general "e.g.
parsed bitstream headers" would be better?

> +     are set to the desired value before querying the ``CAPTURE`` queue.
> +
> +   * In order to enumerate raw formats supported by a given coded format, the
> +     client must thus set that coded format on the ``OUTPUT`` queue first, then
> +     set any control listed on the format's description, and finally enumerate
> +     the ``CAPTURE`` queue.
> +
> +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
> +   resolutions for a given format, passing desired pixel format in
> +   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
> +
> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT`` queue
> +     must include all possible coded resolutions supported by the decoder
> +     for given coded pixel format.
> +
> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE`` queue
> +     must include all possible frame buffer resolutions supported by the
> +     decoder for given raw pixel format and coded format currently set on
> +     ``OUTPUT`` queue.

As Hans pointed out in his review of my series, VIDIOC_ENUM_FRAMESIZES
doesn't have a queue type argument. It's "key" argument is the
pixelformat.

> +
> +    .. note::
> +
> +       The client may derive the supported resolution range for a
> +       combination of coded and raw format by setting width and height of
> +       ``OUTPUT`` format to 0 and calculating the intersection of
> +       resolutions returned from calls to :c:func:`VIDIOC_ENUM_FRAMESIZES`
> +       for the given coded and raw formats.
> +
> +4. Supported profiles and levels for given format, if applicable, may be
> +   queried using their respective controls via :c:func:`VIDIOC_QUERYCTRL`.
> +
> +Initialization
> +==============
> +
> +1. *[optional]* Enumerate supported ``OUTPUT`` formats and resolutions. See
> +   capability enumeration.
> +
> +2. Set the coded format on the ``OUTPUT`` queue via :c:func:`VIDIOC_S_FMT`
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> +
> +     ``pixelformat``
> +         a coded pixel format
> +
> +     ``width``, ``height``
> +         coded width and height parsed from the stream
> +
> +     other fields
> +         follow standard semantics
> +
> +   .. note::
> +
> +      Changing ``OUTPUT`` format may change currently set ``CAPTURE``
> +      format. The driver will derive a new ``CAPTURE`` format from
> +      ``OUTPUT`` format being set, including resolution, colorimetry
> +      parameters, etc. If the client needs a specific ``CAPTURE`` format,
> +      it must adjust it afterwards.
> +
> +3. Call :c:func:`VIDIOC_S_EXT_CTRLS` to set all the controls (profile, etc)
> +   required by the ``OUTPUT`` format to enumerate the ``CAPTURE`` formats.
> +
> +4. Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get format for the
> +   destination buffers parsed/decoded from the bitstream.
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> +
> +   * **Return fields:**
> +
> +     ``width``, ``height``
> +         frame buffer resolution for the decoded frames
> +
> +     ``pixelformat``
> +         pixel format for decoded frames
> +
> +     ``num_planes`` (for _MPLANE ``type`` only)
> +         number of planes for pixelformat
> +
> +     ``sizeimage``, ``bytesperline``
> +         as per standard semantics; matching frame buffer format
> +
> +   .. note::
> +
> +      The value of ``pixelformat`` may be any pixel format supported for the
> +      ``OUTPUT`` format, based on the hardware capabilities. It is suggested
> +      that driver chooses the preferred/optimal format for given configuration.
> +      For example, a YUV format may be preferred over an RGB format, if
> +      additional conversion step would be required.

Not related to this patch, but maybe we should consider some format
flags returned by VIDIOC_ENUM_FMT, which would tell the userspace that
a format might be slower due to extra processing? Or maybe the order
of returned formats should be sorted by efficiency descending?

> +
> +5. *[optional]* Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_ENUM_FMT` on
> +   ``CAPTURE`` queue. The client may use this ioctl to discover which
> +   alternative raw formats are supported for the current ``OUTPUT`` format and
> +   select one of them via :c:func:`VIDIOC_S_FMT`.
> +
> +   .. note::
> +
> +      The driver will return only formats supported for the currently selected
> +      ``OUTPUT`` format, even if more formats may be supported by the driver in
> +      general.
> +
> +      For example, a driver/hardware may support YUV and RGB formats for
> +      resolutions 1920x1088 and lower, but only YUV for higher resolutions (due
> +      to hardware limitations). After setting a resolution of 1920x1088 or lower
> +      as the ``OUTPUT`` format, :c:func:`VIDIOC_ENUM_FMT` may return a set of
> +      YUV and RGB pixel formats, but after setting a resolution higher than
> +      1920x1088, the driver will not return RGB, unsupported for this
> +      resolution.
> +
> +6. *[optional]* Choose a different ``CAPTURE`` format than suggested via
> +   :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for the client to
> +   choose a different format than selected/suggested by the driver in
> +   :c:func:`VIDIOC_G_FMT`.
> +
> +    * **Required fields:**
> +
> +      ``type``
> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> +
> +      ``pixelformat``
> +          a raw pixel format
> +
> +7. Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on
> +   ``OUTPUT`` queue.
> +
> +    * **Required fields:**
> +
> +      ``count``
> +          requested number of buffers to allocate; greater than zero
> +
> +      ``type``
> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> +
> +      ``memory``
> +          follows standard semantics
> +
> +      ``sizeimage``
> +          follows standard semantics; the client is free to choose any
> +          suitable size, however, it may be subject to change by the
> +          driver
> +
> +    * **Return fields:**
> +
> +      ``count``
> +          actual number of buffers allocated
> +
> +    * The driver must adjust count to minimum of required number of ``OUTPUT``
> +      buffers for given format and count passed. The client must check this
> +      value after the ioctl returns to get the number of buffers allocated.
> +
> +    .. note::
> +
> +       To allocate more than minimum number of buffers (for pipeline depth), use
> +       G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to get minimum number of
> +       buffers required by the driver/format, and pass the obtained value plus
> +       the number of additional buffers needed in count to
> +       :c:func:`VIDIOC_REQBUFS`.

This control probably doesn't make sense for stateless decoders,
because the userspace already knows everything about the stream needed
to know how many buffers would be optimal (e.g. DPB count).

> +
> +8. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQBUFS` on the
> +   ``CAPTURE`` queue.
> +
> +    * **Required fields:**
> +
> +      ``count``
> +          requested number of buffers to allocate; greater than zero
> +
> +      ``type``
> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> +
> +      ``memory``
> +          follows standard semantics
> +
> +    * **Return fields:**
> +
> +      ``count``
> +          adjusted to allocated number of buffers
> +
> +    * The driver must adjust count to minimum of required number of
> +      destination buffers for given format and stream configuration and the
> +      count passed. The client must check this value after the ioctl
> +      returns to get the number of buffers allocated.
> +
> +    .. note::
> +
> +       To allocate more than minimum number of buffers (for pipeline
> +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``) to
> +       get minimum number of buffers required, and pass the obtained value
> +       plus the number of additional buffers needed in count to
> +       :c:func:`VIDIOC_REQBUFS`.

Same here. I wouldn't mention this control.

> +
> +9. Allocate requests (likely one per ``OUTPUT`` buffer) via
> +    :c:func:`MEDIA_IOC_REQUEST_ALLOC` on the media device.
> +
> +10. Start streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
> +    :c:func:`VIDIOC_STREAMON`.
> +
> +Decoding
> +========
> +
> +For each frame, the client is responsible for submitting a request to which the
> +following is attached:
> +
> +* Exactly one frame worth of encoded data in a buffer submitted to the
> +  ``OUTPUT`` queue,
> +* All the controls relevant to the format being decoded (see below for details).
> +
> +``CAPTURE`` buffers must not be part of the request, but must be queued
> +independently. The driver will pick one of the queued ``CAPTURE`` buffers and
> +decode the frame into it. Although the client has no control over which
> +``CAPTURE`` buffer will be used with a given ``OUTPUT`` buffer, it is guaranteed
> +that ``CAPTURE`` buffers will be returned in decode order (i.e. the same order
> +as ``OUTPUT`` buffers were submitted), so it is trivial to associate a dequeued
> +``CAPTURE`` buffer to its originating request and ``OUTPUT`` buffer.
> +
> +If the request is submitted without an ``OUTPUT`` buffer, then
> +:c:func:`MEDIA_REQUEST_IOC_QUEUE` will return ``-ENOENT``. If more than one
> +buffer is queued, or if some of the required controls are missing, then it will
> +return ``-EINVAL``. Decoding errors are signaled by the ``CAPTURE`` buffers
> +being dequeued carrying the ``V4L2_BUF_FLAG_ERROR`` flag. If the reference frame
> +has an error, then all other frames that refer to it will also set the
> +``V4L2_BUF_FLAG_ERROR`` flag.

Should we also return respective OUTPUT buffer with ERROR flag too?

> +
> +The contents of source ``OUTPUT`` buffers, as well as the controls that must be
> +set on the request, depend on active coded pixel format and might be affected by
> +codec-specific extended controls, as stated in documentation of each format.
> +Currently supported formats are:
> +

Should I take this as: currently whatever format you take, it's unsupported? ;)

> +Buffer management during decoding
> +=================================
> +Contrary to stateful decoder drivers, a stateless decoder driver does not
> +perform any kind of buffer management. In particular, it guarantees that
> +``CAPTURE`` buffers will be dequeued in the same order as they are queued. This
> +allows user-space to know in advance which ``CAPTURE`` buffer will contain a
> +given frame, and thus to use that buffer ID as the key to indicate a reference
> +frame.
> +
> +This also means that user-space is fully responsible for not queuing a given
> +``CAPTURE`` buffer for as long as it is used as a reference frame. Failure to do
> +so will overwrite the reference frame's data while it is still in use, and
> +result in visual corruption of future frames.
> +
> +Note that this applies to all types of buffers, and not only to
> +``V4L2_MEMORY_MMAP`` ones, as drivers supporting ``V4L2_MEMORY_DMABUF`` will
> +typically maintain a map of buffer IDs to DMABUF handles for reference frame
> +management. Queueing a buffer will result in the map entry to be overwritten
> +with the new DMABUF handle submitted in the :c:func:`VIDIOC_QBUF` ioctl.
> +
> +Seek
> +====
> +In order to seek, the client just needs to submit requests using input buffers
> +corresponding to the new stream position. It must however be aware that
> +resolution may have changed and follow the dynamic resolution change sequence in
> +that case. Also depending on the codec used, picture parameters (e.g. SPS/PPS
> +for H.264) may have changed and the client is responsible for making sure that
> +a valid state is sent to the kernel.
> +
> +The client is then free to ignore any returned ``CAPTURE`` buffer that comes
> +from the pre-seek position.

I think it could actually make sense to just stop and reinitialize
everything for a seek, because typically you would want to just skip
any frames pending in vb2 queues and decode the next frame after seek
as soon as possible. As a side effect, there wouldn't be divergence
left between same-resolution and different-resolution seeks.

> +
> +Pause
> +=====
> +
> +In order to pause, the client should just cease queuing buffers onto the
> +``OUTPUT`` queue. This is different from the general V4L2 API definition of
> +pause, which involves calling :c:func:`VIDIOC_STREAMOFF` on the queue.
> +Without source bitstream data, there is no data to process and the hardware
> +remains idle.
> +
> +Dynamic resolution change
> +=========================
> +
> +If the client detects a resolution change in the stream, it will need to perform
> +the initialization sequence again with the new resolution:
> +
> +1. Wait until all submitted requests have completed and dequeue the
> +   corresponding output buffers.
> +
> +2. Call :c:func:`VIDIOC_STREAMOFF` on both the ``OUTPUT`` and ``CAPTURE``
> +   queues.
> +
> +3. Free all buffers by calling :c:func:`VIDIOC_REQBUFS` on the
> +   ``OUTPUT`` and ``CAPTURE`` queues with a buffer count of zero.
> +
> +Then perform the initialization sequence again, with the new resolution set
> +on the ``OUTPUT`` queue. Note that due to resolution constraints, a different
> +format may need to be picked on the ``CAPTURE`` queue.

With my comment to the seek sequence, one could just merge "Seek" and
"Dynamic resolution change" into one section.

> +
> +Drain
> +=====
> +
> +In order to drain the stream on a stateless decoder, the client just needs to
> +wait until all the submitted requests are completed. There is no need to send a
> +``V4L2_DEC_CMD_STOP`` command since requests are processed sequentially by the
> +driver.
> +
> +End of stream
> +=============
> +
> +If the decoder encounters an end of stream marking in the stream, the
> +driver must send a ``V4L2_EVENT_EOS`` event to the client after all frames
> +are decoded and ready to be dequeued on the ``CAPTURE`` queue, with the
> +:c:type:`v4l2_buffer` ``flags`` set to ``V4L2_BUF_FLAG_LAST``. This
> +behavior is identical to the drain sequence triggered by the client via
> +``V4L2_DEC_CMD_STOP``.

I think we agreed to remove this section, because a stateless decoder
doesn't detect EOS on its own - the client does.

Best regards,
Tomasz
