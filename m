Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18A5C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 07:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F4D72177E
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 07:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7ELxfNm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbfA2H5t (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:57:49 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:37032 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfA2H5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 02:57:48 -0500
Received: by mail-vs1-f65.google.com with SMTP id n13so11453277vsk.4
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 23:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=nu3ozRnctBrYYyMVgy42UYMUL46uJXomdQnSkLDQ65E=;
        b=j7ELxfNmBey6zickUeyBAI88L+9JACbFdMHo0xDiJw0uLksp5m8TMF1Y1/VVvsfG+x
         o+slVEVwiDuiaJljlXhZbrhL+IQiD8u+A0rZWK82hgnd1wxkgKCv9A6i3TUIhWwvhWPA
         sGPIm/w+i3s6SICpRLZLmIcs24bXfwk9DvyjFPbDNgNbGbAgXrIbJ0KhVWur3fNmIlfO
         qQ2Ytx+L/2U2aGuftBURdAzhRueyoc+d4+BIYOKuNeZbqIszw+iHXh8xhH5+fwmO9awH
         5uibMpu4MrUIB1NhxW1JvX2HboXl+gkArwCI8G7DhVLNxE7IKsYZqOU7RnocokDw1ftF
         syOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=nu3ozRnctBrYYyMVgy42UYMUL46uJXomdQnSkLDQ65E=;
        b=p/mZHpVB0ngYIHW2mvdQ4SShU1Djf3zfosPfjhxPXrKJVEZrpA2F6jzKUR9VMZ/vHK
         omiXBCHYtBwih2yGlEB6V680u6XCSUdqKjO7WaAYBiwxWC3fwHIcMQ9yxsX2HxdaeRyT
         2ShxV4qMzUpGPobd7G4hrU8xWkFv5FDgy38f8JHOCluA0tkzf51G1C6p/z7R/amZ/gjv
         mk3TV1d5j1MNTWyCevibETwSvOKie62Tmog1B2KYCczWpAV0Zyc5Ppn/0dctdAZQNJTi
         FaJjpl6CqJlKo25AXAgMLkOTXhLFtOMwpSKeMBy0Ujmqr6UHbvlEF/TN0V7wLqqdMeyh
         GEgg==
X-Gm-Message-State: AJcUukdgVYTwOlHARLJCtQnaBo7nSoscTQh5p7H8nllItkT0dOm73Mfo
        objqx/b8VBHFGZB+VL7QrNRDi2xhDZU8zMGh7BDuUftbuew=
X-Google-Smtp-Source: ALg8bN5tnquqKpLX7BI3dUx7AerCuOok/gq/LO3OErYYloKj2g+bFIoCm/9ea2v6xnmMYoR2wj2Rd1SNCQ/VHB402YM=
X-Received: by 2002:a67:385a:: with SMTP id f87mr10221371vsa.179.1548748666394;
 Mon, 28 Jan 2019 23:57:46 -0800 (PST)
MIME-Version: 1.0
References: <20190122062616.164838-1-acourbot@chromium.org>
In-Reply-To: <20190122062616.164838-1-acourbot@chromium.org>
From:   Dafna Hirschfeld <dafna3@gmail.com>
Date:   Tue, 29 Jan 2019 09:57:34 +0200
Message-ID: <CAJ1myNQ6Opjfjbd-nc3Fs7xFAwjZvKnduBsrpYb1zBw9RsWgHQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: docs-rst: Document m2m stateless video decoder interface
To:     Alexandre Courbot <acourbot@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 8:27 AM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> Documents the protocol that user-space should follow when
> communicating with stateless video decoders.
>
> The stateless video decoding API makes use of the new request and tags
> APIs. While it has been implemented with the Cedrus driver so far, it
> should probably still be considered staging for a short while.
>
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
> Changes since v1:
>
> * Use timestamps instead of tags to reference frames,
> * Applied Paul's suggestions to not require one frame worth of data per OUTPUT
>   buffer
>
> One of the effects of requiring sub-frame units to be submitted per request is
> that the stateless decoders are not exactly "stateless" anymore: if a frame is
> made of several slices, then the decoder must keep track of the buffer in which
> the current frame is being decoded between requests, and all the slices for the
> current frame must be submitted before we can consider decoding the next one.
>
> Also if we decide to force clients to submit one slice per request, then doesn't
> some of the H.264 controls need to change? For instance, in the current v2
> there is still a v4l2_ctrl_h264_decode_param::num_slices member. It is used in
> Chromium to specify the number of slices given to the
> V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS control, but is apparently ignored by the
> Cedrus driver. Maxime, can you comment on this?
>
>  Documentation/media/uapi/v4l/dev-codec.rst    |   5 +
>  .../media/uapi/v4l/dev-stateless-decoder.rst  | 378 ++++++++++++++++++
>  2 files changed, 383 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
>
> diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
> index b5e017c17834..6ce38045d3c8 100644
> --- a/Documentation/media/uapi/v4l/dev-codec.rst
> +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> @@ -13,6 +13,11 @@
>  Codec Interface
>  ***************
>
> +.. toctree::
> +    :maxdepth: 1
> +
> +    dev-stateless-decoder
> +
>  A V4L2 codec can compress, decompress, transform, or otherwise convert
>  video data from one format into another format, in memory. Typically
>  such devices are memory-to-memory devices (i.e. devices with the
> diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> new file mode 100644
> index 000000000000..148b1751dd20
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> @@ -0,0 +1,378 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _stateless_decoder:
> +
> +**************************************************
> +Memory-to-memory Stateless Video Decoder Interface
> +**************************************************
> +
> +A stateless decoder is a decoder that works without retaining any kind of state
> +between processing frames. This means that each frame is decoded independently
> +of any previous and future frames, and that the client is responsible for
> +maintaining the decoding state and providing it to the decoder with each
> +decoding request. This is in contrast to the stateful video decoder interface,
> +where the hardware and driver maintain the decoding state and all the client
> +has to do is to provide the raw encoded stream.
> +
> +This section describes how user-space ("the client") is expected to communicate
> +with such decoders in order to successfully decode an encoded stream. Compared
> +to stateful codecs, the decoder/client sequence is simpler, but the cost of
> +this simplicity is extra complexity in the client which must maintain a
> +consistent decoding state.
> +
> +Stateless decoders make use of the request API. A stateless decoder must thus
> +expose the ``V4L2_BUF_CAP_SUPPORTS_REQUESTS`` capability on its ``OUTPUT`` queue
> +when :c:func:`VIDIOC_REQBUFS` or :c:func:`VIDIOC_CREATE_BUFS` are invoked.
> +
> +Querying capabilities
> +=====================
> +
> +1. To enumerate the set of coded formats supported by the decoder, the client
> +   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
> +
> +   * The driver must always return the full set of supported ``OUTPUT`` formats,
> +     irrespective of the format currently set on the ``CAPTURE`` queue.
> +
> +   * Simultaneously, the driver must restrain the set of values returned by
> +     codec-specific capability controls (such as H.264 profiles) to the set
> +     actually supported by the hardware.
> +
> +2. To enumerate the set of supported raw formats, the client calls
> +   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
> +
> +   * The driver must return only the formats supported for the format currently
> +     active on the ``OUTPUT`` queue.
> +
> +   * Depending on the currently set ``OUTPUT`` format, the set of supported raw
> +     formats may depend on the value of some controls (e.g. parsed format
> +     headers) which are codec-dependent. The client is responsible for making
> +     sure that these controls are set before querying the ``CAPTURE`` queue.
> +     Failure to do so will result in the default values for these controls being
> +     used, and a returned set of formats that may not be usable for the media
> +     the client is trying to decode.
> +
> +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
> +   resolutions for a given format, passing desired pixel format in
> +   :c:type:`v4l2_frmsizeenum`'s ``pixel_format``.
> +
> +4. Supported profiles and levels for the current ``OUTPUT`` format, if
> +   applicable, may be queried using their respective controls via
> +   :c:func:`VIDIOC_QUERYCTRL`.
> +
> +Initialization
> +==============
> +
> +1. Set the coded format on the ``OUTPUT`` queue via :c:func:`VIDIOC_S_FMT`.
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``.
> +
> +     ``pixelformat``
> +         a coded pixel format.
> +
> +     ``width``, ``height``
> +         coded width and height parsed from the stream.
> +
> +     other fields
> +         follow standard semantics.
> +
> +   .. note::
> +
> +      Changing the ``OUTPUT`` format may change the currently set ``CAPTURE``
> +      format. The driver will derive a new ``CAPTURE`` format from the
> +      ``OUTPUT`` format being set, including resolution, colorimetry
> +      parameters, etc. If the client needs a specific ``CAPTURE`` format,
> +      it must adjust it afterwards.
> +
> +2. Call :c:func:`VIDIOC_S_EXT_CTRLS` to set all the controls (parsed headers,
> +   etc.) required by the ``OUTPUT`` format to enumerate the ``CAPTURE`` formats.
> +
> +3. Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get the format for the
> +   destination buffers parsed/decoded from the bitstream.
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``.
> +
> +   * **Returned fields:**
> +
> +     ``width``, ``height``
> +         frame buffer resolution for the decoded frames.
> +
> +     ``pixelformat``
> +         pixel format for decoded frames.
> +
> +     ``num_planes`` (for _MPLANE ``type`` only)
> +         number of planes for pixelformat.
> +
> +     ``sizeimage``, ``bytesperline``
> +         as per standard semantics; matching frame buffer format.
> +
> +   .. note::
> +
> +      The value of ``pixelformat`` may be any pixel format supported for the
> +      ``OUTPUT`` format, based on the hardware capabilities. It is suggested
> +      that driver chooses the preferred/optimal format for the current
> +      configuration. For example, a YUV format may be preferred over an RGB
> +      format, if an additional conversion step would be required for RGB.
> +
> +4. *[optional]* Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_ENUM_FMT` on
> +   the ``CAPTURE`` queue. The client may use this ioctl to discover which
> +   alternative raw formats are supported for the current ``OUTPUT`` format and
> +   select one of them via :c:func:`VIDIOC_S_FMT`.
> +
> +   .. note::
> +
> +      The driver will return only formats supported for the currently selected
> +      ``OUTPUT`` format, even if more formats may be supported by the decoder in
> +      general.
> +
> +      For example, a decoder may support YUV and RGB formats for
> +      resolutions 1920x1088 and lower, but only YUV for higher resolutions (due
> +      to hardware limitations). After setting a resolution of 1920x1088 or lower
> +      as the ``OUTPUT`` format, :c:func:`VIDIOC_ENUM_FMT` may return a set of
> +      YUV and RGB pixel formats, but after setting a resolution higher than
> +      1920x1088, the driver will not return RGB pixel formats, since they are
> +      unsupported for this resolution.
> +
> +5. *[optional]* Choose a different ``CAPTURE`` format than suggested via
> +   :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for the client to
> +   choose a different format than selected/suggested by the driver in
> +   :c:func:`VIDIOC_G_FMT`.
> +
> +    * **Required fields:**
> +
> +      ``type``
> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``.
> +
> +      ``pixelformat``
> +          a raw pixel format.
> +
> +6. Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on
> +   ``OUTPUT`` queue.
> +
> +    * **Required fields:**
> +
> +      ``count``
> +          requested number of buffers to allocate; greater than zero.
> +
> +      ``type``
> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``.
> +
> +      ``memory``
> +          follows standard semantics.
> +
> +    * **Return fields:**
> +
> +      ``count``
> +          actual number of buffers allocated.
> +
> +    * If required, the driver will adjust ``count`` to be equal or bigger to the
> +      minimum of required number of ``OUTPUT`` buffers for the given format and
> +      requested count. The client must check this value after the ioctl returns
> +      to get the actual number of buffers allocated.
> +
> +7. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQBUFS` on the
> +   ``CAPTURE`` queue.
> +
> +    * **Required fields:**
> +
> +      ``count``
> +          requested number of buffers to allocate; greater than zero. The client
> +          is responsible for deducing the minimum number of buffers required
> +          for the stream to be properly decoded (taking e.g. reference frames
> +          into account) and pass an equal or bigger number.
> +
> +      ``type``
> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``.
> +
> +      ``memory``
> +          follows standard semantics. ``V4L2_MEMORY_USERPTR`` is not supported
> +          for ``CAPTURE`` buffers.
> +
> +    * **Return fields:**
> +
> +      ``count``
> +          adjusted to allocated number of buffers, in case the codec requires
> +          more buffers than requested.
> +
> +    * The driver must adjust count to the minimum of required number of
> +      ``CAPTURE`` buffers for the current format, stream configuration and
> +      requested count. The client must check this value after the ioctl
> +      returns to get the number of buffers allocated.
> +
> +8. Allocate requests (likely one per ``OUTPUT`` buffer) via
> +    :c:func:`MEDIA_IOC_REQUEST_ALLOC` on the media device.
> +
> +9. Start streaming on both ``OUTPUT`` and ``CAPTURE`` queues via
> +    :c:func:`VIDIOC_STREAMON`.
> +
> +Decoding
> +========
> +
> +For each frame, the client is responsible for submitting a request to which the
> +following is attached:
> +
> +* The minimum amount of encoded data that can be independently decoded must be
> +  provided into a buffer submitted to the ``OUTPUT`` queue. What constitutes the
> +  "minimum amount of encoded data" is codec-dependent ; for H.264 this would be
> +  a slice, for VP8 a frame.
> +* All the metadata needed to decode the submitted encoded data, in the form of
> +  controls relevant to the format being decoded.
> +
> +The contents of the source ``OUTPUT`` buffer, as well as the controls that must
> +be set on the request, depend on the active coded pixel format and might be
> +affected by codec-specific extended controls, as stated in documentation of each
> +format.
> +
> +A typical frame would thus be decoded by repeating the following sequence until
> +all the units of a frame are submitted:
> +
> +1. Queue an ``OUTPUT`` buffer containing one unit worth of encoded bitstream
> +   data for the decoding request, using :c:func:`VIDIOC_QBUF`.
> +
> +    * **Required fields:**
> +
> +      ``index``
> +          index of the buffer being queued.
> +
> +      ``type``
> +          type of the buffer.
> +
> +      ``bytesused``
> +          number of bytes taken by the encoded data frame in the buffer.
> +
> +      ``flags``
> +          the ``V4L2_BUF_FLAG_REQUEST_FD`` flag must be set.
> +
> +      ``request_fd``
> +          must be set to the file descriptor of the decoding request.
> +
> +      ``timestamp``
> +          must be set to a unique value per frame. This value will be propagated
> +          into the decoded frame buffer and can also be used to specify this
> +          frame as the reference of another. If a frame is made of several
> +          units, then their ``OUTPUT`` buffers must all bear the same timestamp.
> +          Starting a new frame before all the encoded units of the current frame
> +          are queued will result in the frame being returned partially decoded,
> +          with the ``V4L2_BUF_FLAG_ERROR`` flag set.
> +
> +2. Set the codec-specific controls for the decoding request, using
> +   :c:func:`VIDIOC_S_EXT_CTRLS`.
> +
> +    * **Required fields:**
> +
> +      ``which``
> +          must be ``V4L2_CTRL_WHICH_REQUEST_VAL``.
> +
> +      ``request_fd``
> +          must be set to the file descriptor of the decoding request.
> +
> +      other fields
> +          other fields are set as usual when setting controls. The ``controls``
> +          array must contain all the codec-specific controls required to decode
> +          a frame.
> +
> +   .. note::
> +
> +      It is possible to specify the controls in different invocations of
> +      :c:func:`VIDIOC_S_EXT_CTRLS`, or to overwrite a previously set control, as
> +      long as ``request_fd`` and ``which`` are properly set. The controls state
> +      at the moment of request submission is the one that will be considered.
> +
> +   .. note::
> +
> +      The order in which steps 1 and 2 take place is interchangeable.
> +
> +3. Submit the request by invoking :c:func:`MEDIA_IOC_REQUEST_QUEUE` on the

typo? ,MEDIA_IOC_REQUEST_QUEUE instead of MEDIA_REQUEST_IOC_QUEUE

Dafna

> +   request FD.
> +
> +    If the request is submitted without an ``OUTPUT`` buffer, or if some of the
> +    required controls are missing from the request, then
> +    :c:func:`MEDIA_REQUEST_IOC_QUEUE` will return ``-ENOENT``. If more than one
> +    ``OUTPUT`` buffer is queued, then it will return ``-EINVAL``.
> +    :c:func:`MEDIA_REQUEST_IOC_QUEUE` returning non-zero means that no
> +    ``CAPTURE`` buffer will be produced for this request.
> +
> +``CAPTURE`` buffers must not be part of the request, and are queued
> +independently. They are returned in decode order (i.e. the same order as coded
> +frames were submitted to the ``OUTPUT`` queue).
> +
> +Runtime decoding errors are signaled by the dequeued ``CAPTURE`` buffers
> +carrying the ``V4L2_BUF_FLAG_ERROR`` flag. If a decoded reference frame has an
> +error, then all following decoded frames that refer to it also have the
> +``V4L2_BUF_FLAG_ERROR`` flag set, although the decoder will still try to
> +produce a (likely corrupted) frame.
> +
> +Buffer management while decoding
> +================================
> +Contrary to stateful decoders, a stateless decoder does not perform any kind of
> +buffer management: it only guarantees that dequeued ``CAPTURE`` buffer can be
> +used by the client for as long as they are not queued again. "Used" here
> +encompasses using the buffer for compositing, display, or as a reference frame
> +to decode a subsequent frame.
> +
> +A frame can be used as reference by converting its timestamp into nanoseconds,
> +and storing it into the relevant member of a codec-dependent control structure.
> +The :c:func:`v4l2_timeval_to_ns` function must be used to perform that
> +conversion. The timestamp of a frame can be used to reference it as soon as all
> +its units of encoded data are successfully submitted to the ``OUTPUT`` queue.
> +However, a decoded buffer containing a reference frame must not be queued to the
> +``CAPTURE`` queue again before all the decoded frames referencing it have been
> +dequeued, since queuing a ``CAPTURE`` buffer resets its timestamp.
> +
> +When queuing a decoding request, the driver will increase the reference count of
> +all the resources associated with reference frames. This means that the client
> +can e.g. close the DMABUF file descriptors of the reference frame buffers if it
> +won't need it afterwards, as long as the V4L2 ``CAPTURE`` buffer of the
> +reference frame is not re-queued before all referencing frames are decoded.
> +
> +Seeking
> +=======
> +In order to seek, the client just needs to submit requests using input buffers
> +corresponding to the new stream position. It must however be aware that
> +resolution may have changed and follow the dynamic resolution change sequence in
> +that case. Also depending on the codec used, picture parameters (e.g. SPS/PPS
> +for H.264) may have changed and the client is responsible for making sure that a
> +valid state is sent to the decoder.
> +
> +The client is then free to ignore any returned ``CAPTURE`` buffer that comes
> +from the pre-seek position.
> +
> +Pause
> +=====
> +
> +In order to pause, the client can just cease queuing buffers onto the ``OUTPUT``
> +queue. Without source bitstream data, there is no data to process and the codec
> +will remain idle.
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
> +3. Free all ``CAPTURE`` buffers by calling :c:func:`VIDIOC_REQBUFS` on the
> +   ``CAPTURE`` queue with a buffer count of zero.
> +
> +4. Perform the initialization sequence again (minus the allocation of
> +   ``OUTPUT`` buffers), with the new resolution set on the ``OUTPUT`` queue.
> +   Note that due to resolution constraints, a different format may need to be
> +   picked on the ``CAPTURE`` queue.
> +
> +Drain
> +=====
> +
> +In order to drain the stream on a stateless decoder, the client just needs to
> +wait until all the submitted requests are completed. There is no need to send a
> +``V4L2_DEC_CMD_STOP`` command since requests are processed sequentially by the
> +decoder.
> --
> 2.20.1.321.g9e740568ce-goog
>
