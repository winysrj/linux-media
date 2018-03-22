Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:40095 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754319AbeCVOsR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 10:48:17 -0400
Received: by mail-vk0-f54.google.com with SMTP id x5so5367395vkd.7
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 07:48:16 -0700 (PDT)
Received: from mail-ua0-f173.google.com (mail-ua0-f173.google.com. [209.85.217.173])
        by smtp.gmail.com with ESMTPSA id a9sm1318202uaa.44.2018.03.22.07.48.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Mar 2018 07:48:15 -0700 (PDT)
Received: by mail-ua0-f173.google.com with SMTP id l21so275199uak.1
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 07:48:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
References: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 22 Mar 2018 23:47:53 +0900
Message-ID: <CAAFQd5DQ1iH6XA1DvJ3vi4MZejqza1Yjcxxp_HDfu5eDD9f3jw@mail.gmail.com>
Subject: Re: [RFC] Request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Mar 22, 2018 at 11:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> RFC Request API
> ---------------
>
> This document proposes the public API for handling requests.
>
> There has been some confusion about how to do this, so this summarizes the
> current approach based on conversations with the various stakeholders today
> (Sakari, Alexandre Courbot, Tomasz Figa and myself).
>
> The goal is to finalize this so the Request API patch series work can
> continue.

Thanks a lot. The proposal looks reasonable to me, with few small
comments inline.

>
> 1) Additions to the media API
>
>    Allocate an empty request object:
>
>    #define MEDIA_IOC_REQUEST_ALLOC _IOW('|', 0x05, __s32 *)
>
>    This will return a file descriptor representing the request or an error
>    if it can't allocate the request.
>
>    If the pointer argument is NULL, then this will just return 0 (if this ioctl
>    is implemented) or -ENOTTY otherwise. This can be used to test whether this
>    ioctl is supported or not without actually having to allocate a request.
>
> 2) Operations on the request fd
>
>    You can queue (aka submit) or reinit a request by calling these ioctls on the request fd:
>
>    #define MEDIA_REQUEST_IOC_QUEUE   _IO('|',  128)
>    #define MEDIA_REQUEST_IOC_REINIT  _IO('|',  129)
>
>    Note: the original proposal from Alexandre used IOC_SUBMIT instead of
>    IOC_QUEUE. I have a slight preference for QUEUE since that implies that the
>    request end up in a queue of requests. That's less obvious with SUBMIT. I
>    have no strong opinion on this, though.

+1 for QUEUE, which also sounds more consistent terminology used for buffers.

>
>    With REINIT you reset the state of the request as if you had just allocated
>    it. You cannot REINIT a request if the request is queued but not yet completed.
>    It will return -EBUSY in that case.
>
>    Calling QUEUE if the request is already queued or completed will return -EBUSY
>    as well. Or would -EPERM be better? I'm open to suggestions. Either error code
>    will work, I think.
>
>    You can poll the request fd to wait for it to complete. A request is complete
>    if all the associated buffers are available for dequeuing and all the associated
>    controls (such as controls containing e.g. statistics) are updated with their
>    final values.
>
>    To free a request you close the request fd. Note that it may still be in
>    use internally, so this has to be refcounted.
>
>    Requests only contain the changes since the previously queued request or
>    since the current hardware state if no other requests are queued.

Does this mean that a request is tied to certain hardware state from
some point of time? (allocation? queue?) How does it affect the
ability to create multiple requests beforehand, without queuing any?

My original understanding was that a request would be more like a set
of state change actions (S_CTRL, QBUF), that would apply over any
state that is there at request execution time. As such, requests could
be prepared beforehand (or in parallel), without worrying about
current driver state, and then possibly used in a cyclic fashion.

>
> 3) To associate a v4l2 buffer with a request the 'reserved' field in struct
>    v4l2_buffer is used to store the request fd. Buffers won't be 'prepared'
>    until the request is queued since the request may contain information that
>    is needed to prepare the buffer.
>
>    Queuing a buffer without a request after a buffer with a request is equivalent
>    to queuing a request containing just that buffer and nothing else. I.e. it will
>    just use whatever values the hardware has at the time of processing.
>
> 4) To associate v4l2 controls with a request we take the first of the
>    'reserved[2]' array elements in struct v4l2_ext_controls and use it to store
>    the request fd.
>
>    When querying a control value from a request it will return the newest
>    value in the list of pending requests, or the current hardware value if
>    is not set in any of the pending requests.

What does it mean to "query a control value from a request"? The first
thing that comes to my mind is checking the value that was earlier set
to that particular request (and maybe -EBUSY if it wasn't set?).

Perhaps we need to consider few separate cases here:

 1) Query control value within a request. Would return the value that
was earlier set to that particular request (and maybe -EBUSY if it
wasn't set?). Perhaps done with v4l2_ext_controls::which set to
V4L2_CTRL_WHICH_REQUEST and v4l2_ext_controls::reserved[2] to FD of
the request in question.

 2) Query value of the control at the newest pending request in
request queue. Would return the current hardware value if is not set
in any of the pending requests. Now, this could be as well done with
v4l2_ext_controls::which set to just V4L2_CTRL_WHICH_CUR, because the
meaning would be the same - the value used with operations queued from
now on. On the other hand, for compatibility (?), one could keep
V4L2_CTRL_WHICH_CUR with its current meaning of current hardware state
and define a new enum, say V4L2_CTRL_WHICH_CUR_REQUEST.

 3) Query current hardware value. I'm not sure if there is any
practical usage, given 2), because even if we can read current value,
it might instantly change, if next queued requests is launched. In my
personal opinion, 2) could just be used as behavior for
V4L2_CTRL_WHICH_CUR, if requests are used.

>
>    Setting controls without specifying a request fd will just act like it does
>    today: the hardware is immediately updated. This can cause race conditions
>    if the same control is also specified in a queued request: it is not defined
>    which will be set first. It is therefor not a good idea to set the same
>    control directly as well as set it as part of a request.
>
> Notes:
>
> - Earlier versions of this API had a TRY command as well to validate the
>   request. I'm not sure that is useful so I dropped it, but it can easily
>   be added if there is a good use-case for it. Traditionally within V4L the
>   TRY ioctl will also update wrong values to something that works, but that
>   is not the intention here as far as I understand it. So the validation
>   step can also be done when the request is queued and, if it fails, it will
>   just return an error.
>
> - If due to performance reasons we will have to allocate/queue/reinit multiple
>   requests with a single ioctl, then we will have to add new ioctls to the
>   media device. At this moment in time it is not clear that this is really
>   needed and it certainly isn't needed for the stateless codec support that
>   we are looking at now.

An alternative, maybe a bit crazy, idea would be to allow adding
MEDIA_REQUEST_IOC_QUEUE ioctl to the request itself. This would be
similar to the idea of indirect command buffers in the graphics (GPU)
land. It could for example look like this:

// One time initialization
bulk_fd = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
for (i = 0; i < N; ++i) {
    fd[i] = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
    // Add some state
    ioctl(fd[i], MEDIA_IOC_REQUEST_QUEUE, { .request = bulk_fd });
}

// Do some work

ioctl(bulk_fd, MEDIA_IOC_REQUEST_QUEUE); // Queues all the requests at once

Best regards,
Tomasz
