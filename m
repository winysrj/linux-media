Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52543 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751291AbeCVQ2j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 12:28:39 -0400
Subject: Re: [RFC] Request API
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
References: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
 <CAAFQd5DQ1iH6XA1DvJ3vi4MZejqza1Yjcxxp_HDfu5eDD9f3jw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <015c0c34-c628-5381-480c-878b1d50b4e2@xs4all.nl>
Date: Thu, 22 Mar 2018 17:28:33 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DQ1iH6XA1DvJ3vi4MZejqza1Yjcxxp_HDfu5eDD9f3jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/18 15:47, Tomasz Figa wrote:
> Hi Hans,
> 
> On Thu, Mar 22, 2018 at 11:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> RFC Request API
>> ---------------
>>
>> This document proposes the public API for handling requests.
>>
>> There has been some confusion about how to do this, so this summarizes the
>> current approach based on conversations with the various stakeholders today
>> (Sakari, Alexandre Courbot, Tomasz Figa and myself).
>>
>> The goal is to finalize this so the Request API patch series work can
>> continue.
> 
> Thanks a lot. The proposal looks reasonable to me, with few small
> comments inline.
> 
>>
>> 1) Additions to the media API
>>
>>    Allocate an empty request object:
>>
>>    #define MEDIA_IOC_REQUEST_ALLOC _IOW('|', 0x05, __s32 *)
>>
>>    This will return a file descriptor representing the request or an error
>>    if it can't allocate the request.
>>
>>    If the pointer argument is NULL, then this will just return 0 (if this ioctl
>>    is implemented) or -ENOTTY otherwise. This can be used to test whether this
>>    ioctl is supported or not without actually having to allocate a request.
>>
>> 2) Operations on the request fd
>>
>>    You can queue (aka submit) or reinit a request by calling these ioctls on the request fd:
>>
>>    #define MEDIA_REQUEST_IOC_QUEUE   _IO('|',  128)
>>    #define MEDIA_REQUEST_IOC_REINIT  _IO('|',  129)
>>
>>    Note: the original proposal from Alexandre used IOC_SUBMIT instead of
>>    IOC_QUEUE. I have a slight preference for QUEUE since that implies that the
>>    request end up in a queue of requests. That's less obvious with SUBMIT. I
>>    have no strong opinion on this, though.
> 
> +1 for QUEUE, which also sounds more consistent terminology used for buffers.
> 
>>
>>    With REINIT you reset the state of the request as if you had just allocated
>>    it. You cannot REINIT a request if the request is queued but not yet completed.
>>    It will return -EBUSY in that case.
>>
>>    Calling QUEUE if the request is already queued or completed will return -EBUSY
>>    as well. Or would -EPERM be better? I'm open to suggestions. Either error code
>>    will work, I think.
>>
>>    You can poll the request fd to wait for it to complete. A request is complete
>>    if all the associated buffers are available for dequeuing and all the associated
>>    controls (such as controls containing e.g. statistics) are updated with their
>>    final values.
>>
>>    To free a request you close the request fd. Note that it may still be in
>>    use internally, so this has to be refcounted.
>>
>>    Requests only contain the changes since the previously queued request or
>>    since the current hardware state if no other requests are queued.
> 
> Does this mean that a request is tied to certain hardware state from
> some point of time? (allocation? queue?) How does it affect the
> ability to create multiple requests beforehand, without queuing any?
> 
> My original understanding was that a request would be more like a set
> of state change actions (S_CTRL, QBUF), that would apply over any
> state that is there at request execution time. As such, requests could
> be prepared beforehand (or in parallel), without worrying about
> current driver state, and then possibly used in a cyclic fashion.

Almost correct, except that it applies over any state that is there at
request queue time. Easiest it probably to give an example:

Say you have two controls: C1 and C2. They are initialized in the driver
to 0.

You allocate three requests: R1, R2 and R3.

You set control C1 to 1 in R1 and to 3 in R3.
You never set control C2 in the request.

Now you queue requests R1, R2 and R3.

When R1 is applied it sets C1 to 1. When R2 is applied it doesn't change
anything. When R3 is applied it sets C1 to 3.

Calling VIDIOC_G_EXT_CTRLS for R1 will give C1 = 1 and C2 = 0. R2 returns
C1 = 1 and C2 = 0 and R3 returns C1 = 3 and C2 = 0.

So each request just has the diff against the previously queued request or
(if the control in question has never been set in any of the queued requests)
it returns the current HW value.

Note that this is not yet implemented in the control framework. I have a good
idea how to do this, but I'm waiting for a stable patch series to work on.

I believe today in the v4 patch series all the controls are just cloned when
you allocate a request, right? That's just a temporary solution that will be
replaced later using the approach detailed above.

> 
>>
>> 3) To associate a v4l2 buffer with a request the 'reserved' field in struct
>>    v4l2_buffer is used to store the request fd. Buffers won't be 'prepared'
>>    until the request is queued since the request may contain information that
>>    is needed to prepare the buffer.
>>
>>    Queuing a buffer without a request after a buffer with a request is equivalent
>>    to queuing a request containing just that buffer and nothing else. I.e. it will
>>    just use whatever values the hardware has at the time of processing.
>>
>> 4) To associate v4l2 controls with a request we take the first of the
>>    'reserved[2]' array elements in struct v4l2_ext_controls and use it to store
>>    the request fd.
>>
>>    When querying a control value from a request it will return the newest
>>    value in the list of pending requests, or the current hardware value if
>>    is not set in any of the pending requests.
> 
> What does it mean to "query a control value from a request"? The first
> thing that comes to my mind is checking the value that was earlier set
> to that particular request (and maybe -EBUSY if it wasn't set?).

Calling VIDIOC_G_EXT_CTRLS with a non-zero request_fd.

It's useful to refer to what was discussed in Prague:

"A request object is essentially created empty from the point of view of the
user. Only values that are changed in the request are part of the request,
other values remain unchanged (unless those values change due to a
side-effect of setting a request value). When a request completes, make a
copy of the volatile controls (since that's the value at that point in
time). This is needed for auto-<whatever> functions that need to know such
volatile values."

Once a request has been queued it is fairly easy: VIDIOC_G_EXT_CTRLS
will return the values as will be applied, either by the request or an
already pending request, or the hardware.

Once the request completed it will return the values at the moment of
completion (including copies of the volatile controls at that moment).

Where I am uncertain is what to return when the request hasn't been
queued yet. If a control is not set in the request, what do I return?
It is not unreasonable to return only those controls that are part of
the request and an error for other controls.

Hmm, I wish I could draw this on a whiteboard...

> 
> Perhaps we need to consider few separate cases here:
> 
>  1) Query control value within a request. Would return the value that
> was earlier set to that particular request (and maybe -EBUSY if it
> wasn't set?). Perhaps done with v4l2_ext_controls::which set to
> V4L2_CTRL_WHICH_REQUEST and v4l2_ext_controls::reserved[2] to FD of
> the request in question.

I see no reason to use 'WHICH_REQUEST'. If request_fd is non-zero,
then it automatically refers to that request.

So while not queued I would just return the value that was set earlier
and an error for values not set. But I am open for discussion.

Once it is queued the framework will know the value of each control
since it has the information of the full queue of requests and you can
query all controls.

> 
>  2) Query value of the control at the newest pending request in
> request queue. Would return the current hardware value if is not set
> in any of the pending requests. Now, this could be as well done with
> v4l2_ext_controls::which set to just V4L2_CTRL_WHICH_CUR, because the
> meaning would be the same - the value used with operations queued from
> now on. On the other hand, for compatibility (?), one could keep
> V4L2_CTRL_WHICH_CUR with its current meaning of current hardware state
> and define a new enum, say V4L2_CTRL_WHICH_CUR_REQUEST.

If request_fd is not set, then VIDIOC_G_EXT_CTRLS will always return the
current hardware state. Otherwise it will return the value of the control
as will be applied or was applied (if the request completed) by that request.

> 
>  3) Query current hardware value. I'm not sure if there is any
> practical usage, given 2), because even if we can read current value,
> it might instantly change, if next queued requests is launched. In my
> personal opinion, 2) could just be used as behavior for
> V4L2_CTRL_WHICH_CUR, if requests are used.

I don't see the problem here. If you want the current HW value you use
VIDIOC_G_EXT_CTRLS without a request fd. That's how it works today,
and that won't change.

> 
>>
>>    Setting controls without specifying a request fd will just act like it does
>>    today: the hardware is immediately updated. This can cause race conditions
>>    if the same control is also specified in a queued request: it is not defined
>>    which will be set first. It is therefor not a good idea to set the same
>>    control directly as well as set it as part of a request.
>>
>> Notes:
>>
>> - Earlier versions of this API had a TRY command as well to validate the
>>   request. I'm not sure that is useful so I dropped it, but it can easily
>>   be added if there is a good use-case for it. Traditionally within V4L the
>>   TRY ioctl will also update wrong values to something that works, but that
>>   is not the intention here as far as I understand it. So the validation
>>   step can also be done when the request is queued and, if it fails, it will
>>   just return an error.
>>
>> - If due to performance reasons we will have to allocate/queue/reinit multiple
>>   requests with a single ioctl, then we will have to add new ioctls to the
>>   media device. At this moment in time it is not clear that this is really
>>   needed and it certainly isn't needed for the stateless codec support that
>>   we are looking at now.
> 
> An alternative, maybe a bit crazy, idea would be to allow adding
> MEDIA_REQUEST_IOC_QUEUE ioctl to the request itself. This would be
> similar to the idea of indirect command buffers in the graphics (GPU)
> land. It could for example look like this:
> 
> // One time initialization
> bulk_fd = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
> for (i = 0; i < N; ++i) {
>     fd[i] = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
>     // Add some state
>     ioctl(fd[i], MEDIA_IOC_REQUEST_QUEUE, { .request = bulk_fd });
> }
> 
> // Do some work
> 
> ioctl(bulk_fd, MEDIA_IOC_REQUEST_QUEUE); // Queues all the requests at once

That doesn't reduce the number of ioctl calls :-)

If we want to do that, then we needs ioctls like this:

(yeah, bogus syntax, but it gets the idea across)

__s32 fd_vector[10];

ioctl(media_fd, MEDIA_IOC_REQUEST_BULK_ALLOC, { .n_fds = 10, .fds = fd_vector })
ioctl(media_fd, MEDIA_IOC_REQUEST_BULK_QUEUE, { .n_fds = 10, .fds = fd_vector })
ioctl(media_fd, MEDIA_IOC_REQUEST_BULK_REINIT, { .n_fds = 10, .fds = fd_vector })

Regards,

	Hans
