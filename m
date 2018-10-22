Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44278 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbeJVO3a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 10:29:30 -0400
Received: by mail-yb1-f195.google.com with SMTP id x5-v6so15677788ybl.11
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:12:24 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id m125-v6sm8118664ywd.23.2018.10.21.23.12.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Oct 2018 23:12:21 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id d18-v6so1575724yba.4
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-3-tfiga@chromium.org>
 <2699352.udkuklTee2@avalon>
In-Reply-To: <2699352.udkuklTee2@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 22 Oct 2018 15:12:09 +0900
Message-ID: <CAAFQd5DkBLxtXcvs5b=HDmajibr9WG4gCyzMqkDPyoCXZHBKHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 18, 2018 at 12:19 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> Thank you for the patch.
>

Thanks for the review. I'll snip out the comments that I've already addressed.

> On Tuesday, 24 July 2018 17:06:21 EEST Tomasz Figa wrote:
[snip]
> > +Glossary
> > +========
>
> [snip]
>
> Let's try to share these two sections between the two documents.
>

Do you have any idea on how to include common contents in multiple
documentation pages (here encoder and decoder)?

> [snip]
>
> > +Initialization
> > +==============
> > +
> > +1. *[optional]* Enumerate supported formats and resolutions. See
> > +   capability enumeration.
> > +
> > +2. Set a coded format on the ``CAPTURE`` queue via :c:func:`VIDIOC_S_FMT`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +     ``pixelformat``
> > +         set to a coded format to be produced
> > +
> > +   * **Return fields:**
> > +
> > +     ``width``, ``height``
> > +         coded resolution (based on currently active ``OUTPUT`` format)
>
> Shouldn't userspace then set the resolution on the CAPTURE queue first ?
>

I don't think so. The resolution on the CAPTURE queue is the internal
coded size of the stream. It depends on the resolution of the OUTPUT
queue, selection rectangles and codec and hardware details.

Actually, I'm thinking whether we actually need to report it to the
userspace. I kept it this way to be consistent with decoders, but I
can't find any use case for it and the CAPTURE format could just
always have width and height set to 0, since it's just a compressed
bitstream.

> > +   .. note::
> > +
> > +      Changing ``CAPTURE`` format may change currently set ``OUTPUT``
> > +      format. The driver will derive a new ``OUTPUT`` format from
> > +      ``CAPTURE`` format being set, including resolution, colorimetry
> > +      parameters, etc. If the client needs a specific ``OUTPUT`` format,
> > +      it must adjust it afterwards.
>
> Doesn't this contradict the "based on currently active ``OUTPUT`` format"
> above ?
>

It might be worded a bit unfortunately indeed, but generally the
userspace doesn't set the width and height, so these values don't
affect the OUTPUT format.

> > +3. *[optional]* Enumerate supported ``OUTPUT`` formats (raw formats for
> > +   source) for the selected coded format via :c:func:`VIDIOC_ENUM_FMT`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     ``index``
> > +         follows standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``pixelformat``
> > +         raw format supported for the coded format currently selected on
> > +         the ``OUTPUT`` queue.
> > +
> > +4. The client may set the raw source format on the ``OUTPUT`` queue via
> > +   :c:func:`VIDIOC_S_FMT`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     ``pixelformat``
> > +         raw format of the source
> > +
> > +     ``width``, ``height``
> > +         source resolution
> > +
> > +     ``num_planes`` (for _MPLANE)
> > +         set to number of planes for pixelformat
> > +
> > +     ``sizeimage``, ``bytesperline``
> > +         follow standard semantics
> > +
> > +   * **Return fields:**
> > +
> > +     ``width``, ``height``
> > +         may be adjusted by driver to match alignment requirements, as
> > +         required by the currently selected formats
> > +
> > +     ``sizeimage``, ``bytesperline``
> > +         follow standard semantics
> > +
> > +   * Setting the source resolution will reset visible resolution to the
> > +     adjusted source resolution rounded up to the closest visible
> > +     resolution supported by the driver. Similarly, coded resolution will
> > +     be reset to source resolution rounded up to the closest coded
> > +     resolution supported by the driver (typically a multiple of
> > +     macroblock size).
> > +
> > +   .. note::
> > +
> > +      This step is not strictly required, since ``OUTPUT`` is expected to
> > +      have a valid default format. However, the client needs to ensure that
>
> s/needs to/must/

I've removed this note.

>
> > +      ``OUTPUT`` format matches its expectations via either
> > +      :c:func:`VIDIOC_S_FMT` or :c:func:`VIDIOC_G_FMT`, with the former
> > +      being the typical scenario, since the default format is unlikely to
> > +      be what the client needs.
> > +
> > +5. *[optional]* Set visible resolution for the stream metadata via
> > +   :c:func:`VIDIOC_S_SELECTION` on the ``OUTPUT`` queue.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     ``target``
> > +         set to ``V4L2_SEL_TGT_CROP``
> > +
> > +     ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > +         visible rectangle; this must fit within the framebuffer resolution
> > +         and might be subject to adjustment to match codec and hardware
> > +         constraints
>
> Just for my information, are there use cases for r.left != 0 or r.top != 0 ?
>

How about screen capture, where you select the part of the screen to
encode, or arbitrary cropping of camera frames?

> > +   * **Return fields:**
> > +
> > +     ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > +         visible rectangle adjusted by the driver
> > +
> > +   * The driver must expose following selection targets on ``OUTPUT``:
> > +
> > +     ``V4L2_SEL_TGT_CROP_BOUNDS``
> > +         maximum crop bounds within the source buffer supported by the
> > +         encoder
>
> Will this always match the format on the OUTPUT queue, or can it differ ?

Yes. I've reworded it as follows:

     ``V4L2_SEL_TGT_CROP_BOUNDS``
         equal to the full source frame, matching the active ``OUTPUT``
         format

>
> > +     ``V4L2_SEL_TGT_CROP_DEFAULT``
> > +         suggested cropping rectangle that covers the whole source picture
>
> How can the driver know what to report here, apart from the same value as
> V4L2_SET_TGT_CROP_BOUNDS ?
>

I've made them equal in v2 indeed.

[snip]
> > +Drain
> > +=====
> > +
> > +To ensure that all queued ``OUTPUT`` buffers have been processed and
> > +related ``CAPTURE`` buffers output to the client, the following drain
> > +sequence may be followed. After the drain sequence is complete, the client
> > +has received all encoded frames for all ``OUTPUT`` buffers queued before
> > +the sequence was started.
> > +
> > +1. Begin drain by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``cmd``
> > +         set to ``V4L2_ENC_CMD_STOP``
> > +
> > +     ``flags``
> > +         set to 0
> > +
> > +     ``pts``
> > +         set to 0
> > +
> > +2. The driver must process and encode as normal all ``OUTPUT`` buffers
> > +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued.
> > +
> > +3. Once all ``OUTPUT`` buffers queued before ``V4L2_ENC_CMD_STOP`` are
> > +   processed:
> > +
> > +   * Once all decoded frames (if any) are ready to be dequeued on the
> > +     ``CAPTURE`` queue
>
> I understand this condition to be equivalent to the main step 3 condition. I
> would thus write it as
>
> "At this point all decoded frames (if any) are ready to be dequeued on the
> ``CAPTURE`` queue. The driver must send a ``V4L2_EVENT_EOS``."
>
> > the driver must send a ``V4L2_EVENT_EOS``. The
> > +     driver must also set ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer`
> > +     ``flags`` field on the buffer on the ``CAPTURE`` queue containing the
> > +     last frame (if any) produced as a result of processing the ``OUTPUT``
> > +     buffers queued before
>
> Unneeded line break ?
>

The whole sequence has been completely rewritten in v2, hopefully
addressing your comments. Please take a look when I post the new
revision.

> > +     ``V4L2_ENC_CMD_STOP``.
> > +
> > +   * If no more frames are left to be returned at the point of handling
> > +     ``V4L2_ENC_CMD_STOP``, the driver must return an empty buffer (with
> > +     :c:type:`v4l2_buffer` ``bytesused`` = 0) as the last buffer with
> > +     ``V4L2_BUF_FLAG_LAST`` set.
> > +
> > +   * Any attempts to dequeue more buffers beyond the buffer marked with
> > +     ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error code returned by
> > +     :c:func:`VIDIOC_DQBUF`.
> > +
> > +4. At this point, encoding is paused and the driver will accept, but not
> > +   process any newly queued ``OUTPUT`` buffers until the client issues
> > +   ``V4L2_ENC_CMD_START`` or restarts streaming on any queue.
> > +
> > +* Once the drain sequence is initiated, the client needs to drive it to
> > +  completion, as described by the above steps, unless it aborts the process
> > +  by issuing :c:func:`VIDIOC_STREAMOFF` on ``CAPTURE`` queue.  The client
> > +  is not allowed to issue ``V4L2_ENC_CMD_START`` or ``V4L2_ENC_CMD_STOP``
> > +  again while the drain sequence is in progress and they will fail with
> > +  -EBUSY error code if attempted.
> > +
> > +* Restarting streaming on ``CAPTURE`` queue will implicitly end the paused
> > +  state and make the encoder continue encoding, as long as other encoding
> > +  conditions are met. Restarting ``OUTPUT`` queue will not affect an
> > +  in-progress drain sequence.
>
> The last sentence seems to contradict the "on any queue" part of step 4. What
> happens if the client restarts streaming on the OUTPUT queue while a drain
> sequence is in progress ?
>

v2 states that the sequence is aborted in case of any of the queues is stopped.

Best regards,
Tomasz
