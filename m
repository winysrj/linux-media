Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56771 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751465AbeECKaB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 06:30:01 -0400
Subject: Re: [RFCv12 PATCH 03/29] media-request: implement media requests
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180501090051.9321-1-hverkuil@xs4all.nl>
 <20180501090051.9321-4-hverkuil@xs4all.nl>
 <20180502222404.ksvbdv656dd2r75b@valkosipuli.retiisi.org.uk>
 <9e686118-f928-fb09-f319-d9484d92b8c1@xs4all.nl>
 <20180503101216.xramu7k6a77rx27u@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d20986d5-e3df-ee12-c49f-9b9d0f8f1d03@xs4all.nl>
Date: Thu, 3 May 2018 12:29:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180503101216.xramu7k6a77rx27u@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/18 12:12, Sakari Ailus wrote:
> On Thu, May 03, 2018 at 10:21:32AM +0200, Hans Verkuil wrote:
>> On 03/05/18 00:24, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Tue, May 01, 2018 at 11:00:25AM +0200, Hans Verkuil wrote:
> ...
>>>> +
>>>> +static int media_request_close(struct inode *inode, struct file *filp)
>>>> +{
>>>> +	struct media_request *req = filp->private_data;
>>>> +
>>>> +	media_request_put(req);
>>>
>>> A newline would be nice here.
>>
>> Why? I do not see it adding anything of value. Some of your other 'newline'
>> comments make it indeed more readable, but I don't see any benefit from it
>> here.
> 
> I'd think it's nice to have an empty line before return if it's detached
> from everything else.
> 
>>
>>>
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static unsigned int media_request_poll(struct file *filp,
>>>> +				       struct poll_table_struct *wait)
>>>> +{
>>>> +	struct media_request *req = filp->private_data;
>>>> +	unsigned long flags;
>>>> +	unsigned int ret = 0;
>>>> +	enum media_request_state state;
>>>> +
>>>> +	if (!(poll_requested_events(wait) & POLLPRI))
>>>> +		return 0;
>>>> +
>>>> +	spin_lock_irqsave(&req->lock, flags);
>>>> +	state = atomic_read(&req->state);
>>>> +
>>>> +	if (state == MEDIA_REQUEST_STATE_COMPLETE) {
>>>> +		ret = POLLPRI;
>>>> +		goto unlock;
>>>> +	}
>>>> +	if (state == MEDIA_REQUEST_STATE_IDLE) {
>>>
>>> Should this be just anything else than QUEUE or VALIDATING? You're missing
>>> CLEANING here, for instance.
>>
>> I changed it to != QUEUED. I don't think it is a good idea to include VALIDATING
>> in this. It only makes sense to poll for the result if the request is fully queued.
> 
> Sounds good.
> 
> ...
> 
>>>> +	/*
>>>> +	 * If the req_validate was successful, then we mark the state as QUEUED
>>>> +	 * and call req_queue. The reason we set the state first is that this
>>>> +	 * allows req_queue to unbind or complete the queued objects in case
>>>> +	 * they are immediately 'consumed'. State changes from QUEUED to another
>>>> +	 * state can only happen if either the driver changes the state or if
>>>> +	 * the user cancels the vb2 queue. The driver can only change the state
>>>> +	 * after each object is queued through the req_queue op (and note that
>>>> +	 * that op cannot fail), so setting the state to QUEUED up front is
>>>> +	 * safe.
>>>> +	 *
>>>> +	 * The other reason for changing the state is if the vb2 queue is
>>>> +	 * canceled, and that uses the req_queue_mutex which is still locked
>>>> +	 * while req_queue is called, so that's safe as well.
>>>> +	 */
>>>> +	atomic_set(&req->state,
>>>> +		   ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED);
>>>> +
>>>> +	if (!ret)
>>>> +		mdev->ops->req_queue(req);
>>>> +
>>>> +	mutex_unlock(&mdev->req_queue_mutex);
>>>> +
>>>> +	if (ret) {
>>>> +		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
>>>> +			req->debug_str, ret);
>>>> +	} else {
>>>> +		media_request_get(req);
>>>
>>> You'll need to get a reference before you queue the request. Otherwise it's
>>> possible that it completes before you get here, and you end up accessing
>>> released memory. The request refcount might be also under 0 before that
>>> though.
>>
>> No, that can't happen. This function implements the QUEUE ioctl, which can only
>> be called by userspace through the request fd, so there is always at least one
>> reference open.
> 
> Indeed, you're right.
> 
> The curly braces are unnecessary above btw.
> 
> ...
> 
>>>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>>>> index bcc6ec434f1f..ae846208be51 100644
>>>> --- a/include/media/media-device.h
>>>> +++ b/include/media/media-device.h
>>>> @@ -27,6 +27,7 @@
>>>>  
>>>>  struct ida;
>>>>  struct device;
>>>> +struct media_device;
>>>>  
>>>>  /**
>>>>   * struct media_entity_notify - Media Entity Notify
>>>> @@ -50,10 +51,22 @@ struct media_entity_notify {
>>>>   * struct media_device_ops - Media device operations
>>>>   * @link_notify: Link state change notification callback. This callback is
>>>>   *		 called with the graph_mutex held.
>>>> + * @req_alloc: Allocate a request
>>>> + * @req_free: Free a request
>>>> + * @req_validate: Validate a request, but do not queue yet
>>>> + * @req_queue: Queue a validated request, cannot fail. If something goes
>>>> + *	       wrong when queueing this request then it should be marked
>>>> + *	       as such internally in the driver and any related buffers
>>>> + *	       will eventually return to userspace with V4L2_BUF_FLAG_ERROR
>>>> + *	       set.
>>>
>>> Note that this is MC; I think the reference is fine but I'd make it
>>> explicit this is V4L2, and possibly that it's an example.
>>
>> I've changed the last line to:
>>
>> "must eventually return to vb2 with state VB2_BUF_STATE_ERROR."
>>
>> Since this is really a vb2 thing, not V4L2.
>>
>> It's not an example, based on what I know this should really be done like
>> this. If reality proves to be different, then the comment will need to change.
> 
> Yes, but this is not a place for VB2 documentation nor a conclusive
> document of what a failing queue operation would mean on whichever possible
> other non-MC subsystem. So the VB2 related matter here remains an example
> only.
> 
> We don't seem to have other than V4L2 using MC after more than five years
> but I'd still be wary of thinking this is bound to V4L2 only.
> 

It's all very tightly coupled to vb2 and I think we should just be honest in the
comment. Nor do I see this ever being used in other subsystems: they have their
own streaming etc. models.

I'll keep this in unless other people complain about this.

Regards,

	Hans
