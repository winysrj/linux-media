Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41461 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752019AbeCVRWh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 13:22:37 -0400
Subject: Re: [RFC] Request API
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
References: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
 <1521736580.18466.3.camel@ndufresne.ca>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8d6f1a84-0113-dad5-29b4-3474976fd1e1@xs4all.nl>
Date: Thu, 22 Mar 2018 18:22:29 +0100
MIME-Version: 1.0
In-Reply-To: <1521736580.18466.3.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2018 05:36 PM, Nicolas Dufresne wrote:
> Le jeudi 22 mars 2018 à 15:18 +0100, Hans Verkuil a écrit :
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
>>
>> 1) Additions to the media API
>>
>>    Allocate an empty request object:
>>
>>    #define MEDIA_IOC_REQUEST_ALLOC _IOW('|', 0x05, __s32 *)
> 
> I see this is MEDIA_IOC namespace, I thought that there was an opening
> for m2m (codec) to not have to expose a media node. Is this still the
> case ?

Allocating requests will have to be done via the media device and codecs will
therefor register a media device as well.

However, it is an open question if we want to have what is basically a shortcut
V4L2 ioctl like VIDIOC_REQUEST_ALLOC so applications that deal with stateless
codecs do not have to open the media device just to allocate a request.

I guess that whether or not you want that depends on how open you are for
practical considerations in an API.

I've asked Alexandre to add this V4L2 ioctl as a final patch in the series
and we can decide later on whether or not to accept it.

Sorry, I wanted to mention this in the RFC as a note at the end, but I forgot.

> 
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
> 
> I think it's worth to understand that this would mimic DRM Atomic
> interface. The reason atomic operation can be tried like this is
> because it's not possible to generically represent all the constraints.
> So this would only be useful we we do have this issue.

Right. I don't think this is needed for codecs, so I'd leave this out for
now. It can always be added later.

Regards,

	Hans

> 
>>
>> - If due to performance reasons we will have to allocate/queue/reinit multiple
>>   requests with a single ioctl, then we will have to add new ioctls to the
>>   media device. At this moment in time it is not clear that this is really
>>   needed and it certainly isn't needed for the stateless codec support that
>>   we are looking at now.
>>
>> Regards,
>>
>> 	Hans
