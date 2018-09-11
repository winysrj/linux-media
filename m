Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36587 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbeIKNjA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 09:39:00 -0400
Received: by mail-it0-f67.google.com with SMTP id u13-v6so448016iti.1
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2018 01:40:44 -0700 (PDT)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com. [209.85.214.41])
        by smtp.gmail.com with ESMTPSA id c3-v6sm115420itd.8.2018.09.11.01.40.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Sep 2018 01:40:43 -0700 (PDT)
Received: by mail-it0-f41.google.com with SMTP id e14-v6so469208itf.1
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2018 01:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <20180831074743.235010-1-acourbot@chromium.org>
 <b8a80df8-fd07-6820-3021-670c360ff306@xs4all.nl> <38b32d24-6957-4bee-9168-b3afbfcae083@xs4all.nl>
 <a5c47693-4d66-1afc-9053-45bbbbef9d7c@xs4all.nl>
In-Reply-To: <a5c47693-4d66-1afc-9053-45bbbbef9d7c@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 11 Sep 2018 17:40:31 +0900
Message-ID: <CAPBb6MXrEPz7Z60zUp-m4pWUB7t9p1iFSqqp9s4Gjqj9i3v4sA@mail.gmail.com>
Subject: Re: [RFC PATCH] media: docs-rst: Document m2m stateless video decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 10, 2018 at 9:49 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 09/10/2018 01:57 PM, Hans Verkuil wrote:
> > On 09/10/2018 01:25 PM, Hans Verkuil wrote:
> >>> +
> >>> +Decoding
> >>> +========
> >>> +
> >>> +For each frame, the client is responsible for submitting a request to which the
> >>> +following is attached:
> >>> +
> >>> +* Exactly one frame worth of encoded data in a buffer submitted to the
> >>> +  ``OUTPUT`` queue,
> >>> +* All the controls relevant to the format being decoded (see below for details).
> >>> +
> >>> +``CAPTURE`` buffers must not be part of the request, but must be queued
> >>> +independently. The driver will pick one of the queued ``CAPTURE`` buffers and
> >>> +decode the frame into it. Although the client has no control over which
> >>> +``CAPTURE`` buffer will be used with a given ``OUTPUT`` buffer, it is guaranteed
> >>> +that ``CAPTURE`` buffers will be returned in decode order (i.e. the same order
> >>> +as ``OUTPUT`` buffers were submitted), so it is trivial to associate a dequeued
> >>> +``CAPTURE`` buffer to its originating request and ``OUTPUT`` buffer.
> >>> +
> >>> +If the request is submitted without an ``OUTPUT`` buffer or if one of the
> >>> +required controls are missing, then :c:func:`MEDIA_REQUEST_IOC_QUEUE` will return
> >>> +``-EINVAL``.
> >>
> >> Not entirely true: if buffers are missing, then ENOENT is returned. Missing required
> >> controls or more than one OUTPUT buffer will result in EINVAL. This per the latest
> >> Request API changes.
> >>
> >>  Decoding errors are signaled by the ``CAPTURE`` buffers being
> >>> +dequeued carrying the ``V4L2_BUF_FLAG_ERROR`` flag.
> >>
> >> Add here that if the reference frame had an error, then all other frames that refer
> >> to it should also set the ERROR flag. It is up to userspace to decide whether or
> >> not to drop them (part of the frame might still be valid).
> >>
> >> I am not sure whether this should be documented, but there are some additional
> >> restrictions w.r.t. reference frames:
> >>
> >> Since decoders need access to the decoded reference frames there are some corner
> >> cases that need to be checked:
> >>
> >> 1) V4L2_MEMORY_USERPTR cannot be used for the capture queue: the driver does not
> >>    know when a malloced but dequeued buffer is freed, so the reference frame
> >>    could suddenly be gone.
> >>
> >> 2) V4L2_MEMORY_DMABUF can be used, but drivers should check that the dma buffer is
> >>    still available AND increase the dmabuf refcount while it is used by the HW.
> >>
> >> 3) What to do if userspace has requeued a buffer containing a reference frame,
> >>    and you want to decode a B/P-frame that refers to that buffer? We need to
> >>    check against that: I think that when you queue a capture buffer whose index
> >>    is used in a pending request as a reference frame, than that should fail with
> >>    an error. And trying to queue a request referring to a buffer that has been
> >>    requeued should also fail.
> >>
> >> We might need to add some support for this in v4l2-mem2mem.c or vb2.
> >>
> >> We will have similar (but not quite identical) issues with stateless encoders.
> >
> > Related to this is the question whether buffer indices that are used to refer
> > to reference frames should refer to the capture or output queue.
> >
> > Using capture indices works if you never queue more than one request at a time:
> > you know exactly what the capture buffer index is of the decoded I-frame, and
> > you can use that in the following requests.
> >
> > But if multiple requests are queued, then you don't necessarily know to which
> > capture buffer an I-frame will be decoded, so then you can't provide this index
> > to following B/P-frames. This puts restrictions on userspace: you can only
> > queue B/P-frames once you have decoded the I-frame. This might be perfectly
> > acceptable, though.

IIUC at the moment we are indeed using CAPTURE buffer indexes, e.g:

.. flat-table:: struct v4l2_ctrl_mpeg2_slice_params
  ..
      - ``backward_ref_index``
      - Index for the V4L2 buffer to use as backward reference, used
with
       B-coded and P-coded frames.

So I wonder how is the user-space currently exercising Cedrus doing
here? Waiting for each frame used as a reference to be dequeued?

> >
> > Using output buffer indices will work (the driver will know to which capture
> > buffer index the I-frames mapped), but it requires that the output buffer that
> > contained a reference frame isn't requeued, since that means that the driver
> > will lose this mapping. I think this will make things too confusing, though.
> >
> > A third option is that you don't refer to reference frames by buffer index,
> > but instead by some other counter (sequence counter, perhaps?).
>
> Definitely not sequence number, since it has the same problem as buffer index.
>
> This could be a value relative to the frame you are trying to decode: i.e. 'use
> the capture buffer from X frames ago'. This makes it index independent and is
> still easy to keep track of inside the driver and application.

Sounds like that would work, although the driver would need to
maintain a history of processed frames indexes. We will still need to
make sure that frames referenced have not been re-queued in the
meantime.

Drivers (or the to-be-designed codec framework?) will also need to be
handle the case where user-space did not allocate enough buffers to
hold all the reference frames and the frame to be decoded...

Sorry, I have more questions than answers I'm afraid.
