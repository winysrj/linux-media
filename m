Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:45602 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754035AbeFKH5E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 03:57:04 -0400
Received: by mail-yb0-f193.google.com with SMTP id x6-v6so6381129ybl.12
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2018 00:57:04 -0700 (PDT)
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com. [209.85.161.171])
        by smtp.gmail.com with ESMTPSA id z123-v6sm6351159ywd.85.2018.06.11.00.57.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jun 2018 00:57:03 -0700 (PDT)
Received: by mail-yw0-f171.google.com with SMTP id 81-v6so6024271ywb.6
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2018 00:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-3-tfiga@chromium.org>
 <32e8a7b8-5629-c089-7375-0513512784ff@xs4all.nl>
In-Reply-To: <32e8a7b8-5629-c089-7375-0513512784ff@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 11 Jun 2018 16:49:06 +0900
Message-ID: <CAAFQd5DOKoe_9qwBC3d-NncRxoOzGs9TfBSH1LUrKN6k-PPpHw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
 to Codec Interfaces
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jun 7, 2018 at 6:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 06/05/2018 12:33 PM, Tomasz Figa wrote:
[snip]
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
> > +      i.  type = CAPTURE
> > +
> > +      ii. fmt.pix_mp.pixelformat set to a coded format to be produced
> > +
> > +   b. Return values:
> > +
> > +      i.  EINVAL: unsupported format.
>
> I'm still not sure about returning an error in this case.
>
> And what should TRY_FMT do?
>
> Do you know what current codecs do? Return EINVAL or replace with a supported format?
>

s5p-mfc returns -EINVAL, while mtk-vcodec and coda seem to fall back
to current format.

> It would be nice to standardize on one rule or another.
>
> The spec says that it should always return a valid format, but not all drivers adhere
> to that. Perhaps we need to add a flag to let the driver signal the behavior of S_FMT
> to userspace.
>
> This is a long-standing issue with S_FMT, actually.
>

Agreed. I'd personally prefer agreeing on one pattern to simplify
things. I generally don't like the "negotiation hell" that the
fallback introduces, but with the general documentation clearly
stating such behavior, I'd be worried that returning an error actually
breaks some userspace.

[snip]
> > +Encoding
> > +--------
> > +
> > +This state is reached after a successful initialization sequence. In
> > +this state, client queues and dequeues buffers to both queues via
> > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, as per spec.
> > +
> > +Both queues operate independently. The client may queue and dequeue
> > +buffers to queues in any order and at any rate, also at a rate different
> > +for each queue. The client may queue buffers within the same queue in
> > +any order (V4L2 index-wise).
>
> I'd drop the whole 'in any order' in the text above. This has always been
> the case, and I think it is only confusing. I think what you really want
> to say is that both queues operate independently and quite possibly at
> different rates. So clients should operate them independently as well.

I think there are at least 3 different "in any order" in play:

1) the order of buffers being dequeued not matching the order of
queuing the buffers in the same queue (e.g. encoder keeping some
buffers as reference framebuffers)

2) possible difference in order of queuing raw frames to encoder
OUTPUT and dequeuing encoded bitstream from encoder CAPTURE,

3) the order of handling the queue/dequeue operations on both queues,
i.e. dequeue OUTPUT, queue OUTPUT, dequeue CAPTURE, queue CAPTURE,

4) the order of queuing buffers (indices) within the queue being up to
the client - this has always been the case indeed. The extra bit here
is that this keeps being true, even with having 2 queues.

I believe the text above refers to 3) and 4). I guess we can drop 4)
indeed and we actually may want to clearly state 1) and 2).

By the way, do we already have some place in the documentation that
mentions the bits that have always been the case? We could refer to it
instead.

>
>  It is recommended for the client to operate
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
> > +This specifically means that if the driver maintains a queue of buffers
> > +to be encoded and at the time of the call to :c:func:`VIDIOC_S_CTRL` not all the
> > +buffers in the queue are processed yet, the driver must not apply the
> > +change immediately, but schedule it for when the next buffer queued
> > +after the :c:func:`VIDIOC_S_CTRL` starts being processed.
>
> Is this what drivers do today? I thought it was applied immediately?
> This sounds like something for which you need the Request API.

mtk-vcodec seems to implement the above, while s5p-mfc, coda, venus
don't seem to be doing so.

> > +
> > +Flush
> > +-----
> > +
> > +Flush is the process of draining the CAPTURE queue of any remaining
> > +buffers. After the flush sequence is complete, the client has received
> > +all encoded frames for all OUTPUT buffers queued before the sequence was
> > +started.
> > +
> > +1. Begin flush by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> > +
> > +   a. Required fields:
> > +
> > +      i. cmd = ``V4L2_ENC_CMD_STOP``
> > +
> > +2. The driver must process and encode as normal all OUTPUT buffers
> > +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued.
>
> Note: TRY_ENCODER_CMD should also be supported, likely via a standard helper
> in v4l2-mem2mem.c.

Ack.

>
> > +
> > +3. Once all OUTPUT buffers queued before ``V4L2_ENC_CMD_STOP`` are
> > +   processed:
> > +
> > +   a. Once all decoded frames (if any) are ready to be dequeued on the
> > +      CAPTURE queue, the driver must send a ``V4L2_EVENT_EOS``. The
> > +      driver must also set ``V4L2_BUF_FLAG_LAST`` in
> > +      :c:type:`v4l2_buffer` ``flags`` field on the buffer on the CAPTURE queue
> > +      containing the last frame (if any) produced as a result of
> > +      processing the OUTPUT buffers queued before
> > +      ``V4L2_ENC_CMD_STOP``. If no more frames are left to be
> > +      returned at the point of handling ``V4L2_ENC_CMD_STOP``, the
> > +      driver must return an empty buffer (with
> > +      :c:type:`v4l2_buffer` ``bytesused`` = 0) as the last buffer with
> > +      ``V4L2_BUF_FLAG_LAST`` set instead.
> > +      Any attempts to dequeue more buffers beyond the buffer
> > +      marked with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE
> > +      error from :c:func:`VIDIOC_DQBUF`.
> > +
> > +4. At this point, encoding is paused and the driver will accept, but not
> > +   process any newly queued OUTPUT buffers until the client issues
> > +   ``V4L2_ENC_CMD_START`` or :c:func:`VIDIOC_STREAMON`.
>
> STREAMON on which queue? Shouldn't there be a STREAMOFF first?
>

Yes, STREAMOFF is implied here, since it's not possible to STREAMON on
an already streaming queue. It is mentioned only because the general
encoder command documentation states that STREAMON includes an
implicit START command.

> > +
> > +Once the flush sequence is initiated, the client needs to drive it to
> > +completion, as described by the above steps, unless it aborts the
> > +process by issuing :c:func:`VIDIOC_STREAMOFF` on OUTPUT queue. The client is not
> > +allowed to issue ``V4L2_ENC_CMD_START`` or ``V4L2_ENC_CMD_STOP`` again
> > +while the flush sequence is in progress.
> > +
> > +Issuing :c:func:`VIDIOC_STREAMON` on OUTPUT queue will implicitly restart
> > +encoding.
>
> This feels wrong. Calling STREAMON on a queue that is already streaming does nothing
> according to the spec.

That would be contradicting to
https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-encoder-cmd.html,
which says that

  "A read() or VIDIOC_STREAMON call sends an implicit START command to
the encoder if it has not been started yet."

> I think you should either call CMD_START or STREAMOFF/ON on
> the OUTPUT queue. Of course, calling STREAMOFF first will dequeue any queued OUTPUT
> buffers that were queued since ENC_CMD_STOP was called. But that's normal behavior
> for STREAMOFF.

I think it would be kind of inconsistent for userspace, since STREAMON
would return 0 in both cases, but it would issue the implicit START
only if STREAMOFF was called before. Perhaps it could be made saner by
saying that "STREAMOFF resets the stop condition and thus encoding
would continue normally after a matching STREAMON".

Best regards,
Tomasz
