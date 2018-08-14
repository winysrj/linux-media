Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:34813 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731697AbeHNNh1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 09:37:27 -0400
Subject: Re: [PATCHv17 16/34] v4l2-ctrls: add
 v4l2_ctrl_request_hdl_find/put/ctrl_find functions
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-17-hverkuil@xs4all.nl>
 <20180813080703.4ce872c1@coco.lan>
 <ef84cba0-52d4-b532-8469-ff4fdc10192d@xs4all.nl>
 <20180814055533.41959406@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <512b80e0-1e90-be2d-6115-2d57739707d6@xs4all.nl>
Date: Tue, 14 Aug 2018 12:50:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180814055533.41959406@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/08/18 10:55, Mauro Carvalho Chehab wrote:
> Em Tue, 14 Aug 2018 10:45:57 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 13/08/18 13:07, Mauro Carvalho Chehab wrote:
>>> Em Sat,  4 Aug 2018 14:45:08 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>   
>>>> If a driver needs to find/inspect the controls set in a request then
>>>> it can use these functions.
>>>>
>>>> E.g. to check if a required control is set in a request use this in the
>>>> req_validate() implementation:
>>>>
>>>> 	int res = -EINVAL;
>>>>
>>>> 	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
>>>> 	if (hdl) {
>>>> 		if (v4l2_ctrl_request_hdl_ctrl_find(hdl, ctrl_id))
>>>> 			res = 0;
>>>> 		v4l2_ctrl_request_hdl_put(hdl);
>>>> 	}
>>>> 	return res;
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-ctrls.c | 25 ++++++++++++++++
>>>>  include/media/v4l2-ctrls.h           | 44 +++++++++++++++++++++++++++-
>>>>  2 files changed, 68 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>>>> index 86a6ae54ccaa..2a30be824491 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>>>> @@ -2976,6 +2976,31 @@ static const struct media_request_object_ops req_ops = {
>>>>  	.release = v4l2_ctrl_request_release,
>>>>  };
>>>>  
>>>> +struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
>>>> +					struct v4l2_ctrl_handler *parent)
>>>> +{
>>>> +	struct media_request_object *obj;
>>>> +
>>>> +	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_VALIDATING &&
>>>> +		    req->state != MEDIA_REQUEST_STATE_QUEUED))
>>>> +		return NULL;
>>>> +
>>>> +	obj = media_request_object_find(req, &req_ops, parent);
>>>> +	if (obj)
>>>> +		return container_of(obj, struct v4l2_ctrl_handler, req_obj);
>>>> +	return NULL;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_find);
>>>> +
>>>> +struct v4l2_ctrl *
>>>> +v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id)
>>>> +{
>>>> +	struct v4l2_ctrl_ref *ref = find_ref_lock(hdl, id);
>>>> +
>>>> +	return (ref && ref->req == ref) ? ref->ctrl : NULL;  
>>>
>>> Doesn't those helper functions (including this one) be serialized?  
>>
>> v4l2_ctrl_request_hdl_find() checks the request state to ensure this:
>> it is either VALIDATING (then the req_queue_mutex is locked) or QUEUED
>> and then it is under control of the driver. Of course, in that case the
>> driver should make sure that it doesn't complete the request in the
>> middle of calling this function. If a driver does that, then it is a driver
>> bug.
> 
> Please document it then, as I guess anyone that didn't worked at the
> request API patchset wouldn't guess when the driver needs to take
> the lock themselves.
> 
> From what I'm understanding, the driver needs to take the lock only
> when it is running a code that it is not called from an ioctl.
> right?

Drivers never take req_queue_mutex themselves. If they call this function
when in state QUEUED, then they might need to take a driver-specific mutex
or spinlock that protects against the request being completed by an
interrupt handler.

I very much doubt that this function is ever called when in QUEUED state,
the typical use-case is to call this during validation or when queuing
a validated request. In both cases there is no need to do any locking
since it is guaranteed that no control objects will be added/deleted during
that phase.

I've extended the req_queue documentation in media-device.h with
two extra sentences at the end:

 * @req_queue: Queue a validated request, cannot fail. If something goes
 *             wrong when queueing this request then it should be marked
 *             as such internally in the driver and any related buffers
 *             must eventually return to vb2 with state VB2_BUF_STATE_ERROR.
 *             The req_queue_mutex lock is held when this op is called.
 *             It is important that vb2 buffer objects are queued last after
 *             all other object types are queued: queueing a buffer kickstarts
 *             the request processing, so all other objects related to the
 *             request (and thus the buffer) must be available to the driver.
 *             And once a buffer is queued, then the driver can complete
 *             or delete objects from the request before req_queue exits.

This is important information that wasn't documented.

So nobody can add/remove objects from a request while in the req_validate()
callback. And nobody can add/remove objects from a request while in req_queue()
and non-buffer objects are queued.

Only once buffer objects are queued can objects be completed or removed from
the request and you have to be careful about that.

vb2_request_queue() does the right thing there: notice the list_for_each_entry_safe()
when iterating over the objects for buffers to queue.

Now, that said it is possible that the objects list contains non-buffer objects
after a buffer object: let's say that the objects list has four objects:

N1 B2 N3 N4

Where the Nx objects are non-buffer objects and B2 is a buffer object.

First N1/3/4 are queued to the driver, then the list is walked again using
list_for_each_entry_safe() and B2 is queued to the driver which immediately
deletes the buffer. list_for_each_entry_safe() only works if only B2 can
be deleted by the driver. If the driver would also delete e.g. N3, then
list_for_each_entry_safe() would fail.

This is OK in the current implementation since control objects are never
deleted, only completed (i.e. they stay in the object list until the request
is deleted by the application).

Still, we might get other object types where this is not the case anymore.

I have modified the code to add buffer objects to the end of the list and
non-buffer objects to the beginning of the list (an extra argument to
the media_request_object_bind function).

This avoids this corner case altogether, and it also avoids having to
walk the list twice.

So in the example above the objects list will now look like this:

N1 N3 N4 B2

Regards,

	Hans
