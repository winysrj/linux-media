Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36233 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbeJWMJM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 08:09:12 -0400
Received: by mail-yb1-f193.google.com with SMTP id w16-v6so4397551ybp.3
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 20:47:44 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id y130-v6sm4009007ywc.69.2018.10.22.20.47.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 20:47:42 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id v199-v6so2465100ywg.1
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 20:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20181019080928.208446-1-acourbot@chromium.org>
In-Reply-To: <20181019080928.208446-1-acourbot@chromium.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 23 Oct 2018 12:47:30 +0900
Message-ID: <CAAFQd5DbAEyP_wjNV_ogKSRrOE4co29kLUDJh4zU38JYhNiapw@mail.gmail.com>
Subject: Re: [RFC PATCH v3] media: docs-rst: Document m2m stateless video
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

On Fri, Oct 19, 2018 at 5:09 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> Thanks everyone for the feedback on v2! I have not replied to all the
> individual emails but hope this v3 will address some of the problems
> raised and become a continuation point for the topics still in
> discussion (probably during the ELCE Media Summit).

Thanks for your patch! Some further comments inline.

[snip]
> * The restriction of having to send full frames for each input buffer is
>   kept as-is. As Hans pointed, we currently have a hard limit of 32
>   buffers per queue, and it may be non-trivial to lift. Also some codecs
>   (at least Venus AFAIK) do have this restriction in hardware, so unless

Venus is a stateful decoder, so not very relevant for this interface.

However, Rockchip VPU is a stateless decoder that seems to have this
restriction. It seems to have only one base address and length
register and it seems to consume all the slices as laid out in the
original bitstream.

[snip]
> +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
> +   resolutions for a given format, passing desired pixel format in
> +   :c:type:`v4l2_frmsizeenum`'s ``pixel_format``.
> +
> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT`` queue
> +     must include all possible coded resolutions supported by the decoder
> +     for the current coded pixel format.
> +
> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE`` queue
> +     must include all possible frame buffer resolutions supported by the
> +     decoder for given raw pixel format and coded format currently set on
> +     ``OUTPUT`` queue.
> +
> +    .. note::
> +
> +       The client may derive the supported resolution range for a
> +       combination of coded and raw format by setting width and height of
> +       ``OUTPUT`` format to 0 and calculating the intersection of
> +       resolutions returned from calls to :c:func:`VIDIOC_ENUM_FRAMESIZES`
> +       for the given coded and raw formats.

I've dropped this note in the stateful version, because it would
return something that is contradictory to what S_FMT would accept - it
only accepts the resolution matching the current stream. It also
wouldn't work for decoders which have built-in scaling capability,
because typically the possible range scaling ratios is fixed, so the
maximum and minimum output resolution would depend on the source
resolution.

[snip]
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
> +.. note::
> +
> +   The API currently requires one frame of encoded data per ``OUTPUT`` buffer,
> +   even though some encoded formats may present their data in smaller chunks
> +   (e.g. H.264's frames can be made of several slices that can be processed
> +   independently). It is currently the responsibility of the client to gather
> +   the different parts of a frame into a single ``OUTPUT`` buffer, if required
> +   by the encoded format. This restriction may be lifted in the future.

And maybe we should explicitly say that it should be laid out the same
way as in the bitstream?

But now when I think of it, while still keeping the Rockchip VPU in
mind, AFAIR the slices in H.264 can arrive in separate packets, so
maybe the Rockchip VPU can just consume them separately too and in any
order, as long as they are laid out in a contiguous manner? The
hardware isn't unfortunately very well documented...

> +
> +``CAPTURE`` buffers must not be part of the request, and are queued
> +independently. The driver will always pick the least recently queued ``CAPTURE``
> +buffer and decode the frame into it. ``CAPTURE`` buffers will be returned in
> +decode order (i.e. the same order as ``OUTPUT`` buffers were submitted),
> +therefore it is trivial for the client to know which ``CAPTURE`` buffer will
> +be used for a given frame. This point is essential for referencing frames since
> +we use the ``CAPTURE`` buffer index for that.
> +
> +If the request is submitted without an ``OUTPUT`` buffer, then
> +:c:func:`MEDIA_REQUEST_IOC_QUEUE` will return ``-ENOENT``. If more than one
> +buffer is queued, or if some of the required controls are missing, then it will
> +return ``-EINVAL``. Decoding errors are signaled by the ``CAPTURE`` buffers
> +being dequeued carrying the ``V4L2_BUF_FLAG_ERROR`` flag. If a reference frame
> +has an error, then all other frames that refer to it will also have the
> +``V4L2_BUF_FLAG_ERROR`` flag set.

Perhaps we could want to specify whether those frames would be still
decoded or the whole request discarded?

[snip]
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

Hmm, technically it wouldn't need to reallocate the OUTPUT buffers. We
also should allow the case of the buffers being big enough for the new
resolution.

> +
> +Then perform the initialization sequence again, with the new resolution set
> +on the ``OUTPUT`` queue. Note that due to resolution constraints, a different
> +format may need to be picked on the ``CAPTURE`` queue.
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

I think we agreed for this whole section to go away, since a stateless
decoder wouldn't scan the bitstream for an EoS mark.

Best regards,
Tomasz
