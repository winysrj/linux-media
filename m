Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3722 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3JCJtn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 05:49:43 -0400
Message-ID: <524D3DA8.80705@xs4all.nl>
Date: Thu, 03 Oct 2013 11:49:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 4/4] v4l: events: Don't sleep in dequeue if none are
 subscribed
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-5-git-send-email-sakari.ailus@linux.intel.com> <524C27F6.4040002@xs4all.nl> <524C2B30.9050605@linux.intel.com> <524C2F9A.80806@xs4all.nl> <524C3280.5030406@linux.intel.com>
In-Reply-To: <524C3280.5030406@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/13 16:49, Sakari Ailus wrote:
> Hans Verkuil wrote:
> ...
>>>>> +        if (!subscribed) {
>>>>> +            ret = -EIO;
>>>>
>>>> Shouldn't this be -ENOENT?
>>>
>>> If I use -ENOENT, having no events subscribed is indistinguishable
>>> form no events pending condition. Combine that with using select(2),
>>> and you can no longer distinguish having no events subscribed from
>>> the case where you got an event but someone else (another thread or
>>> process) dequeued it.
>>
>> OK, but then your commit message is out of sync with the actual patch since
>> the commit log says ENOENT.
>>
>>> -EIO makes that explicit --- this also mirrors the behaviour of
>>> VIDIOC_DQBUF. (And it must be documented as well, which is missing
>>> from the patch currently.)
>>
>> I don't like using EIO for this. EIO generally is returned if a hardware
>> error or an unexpected hardware condition occurs. How about -ENOMSG? Or
>> perhaps EPIPE? (As in: "the pipe containing events is gone").
> 
> Thinking about this some more, -ENOENT is probably what we should
> return. *But* when there are no events to dequeue, we should instead
> return -EAGAIN (i.e. EWOULDBLOCK) which VIDIOC_DQBUF also uses.
> 
> However I'm not sure if anything depends on -ENOENT currently
> (probably not really) so changing this might require some
> consideration. No error codes are currently defined for
> VIDIOC_DQEVENT; was planning to fix that while we're at this.
> 

Urgh, this is messy. In non-blocking mode DQEVENT should indeed return
-EAGAIN if you have subscribed events but no events are pending.

If you have no subscribed events, then -ENOENT would be IMHO the most
suitable return value.

This means that DQEVENT's behavior changes in the non-blocking case.
On the other hand, this is actually what you would expect based on the
EAGAIN description in the spec: "It is also returned when the ioctl
would need to wait for an event, but the device was opened in non-blocking
mode."

That said, I don't think we can change it. It's been around for too long
and you have no idea how it is used in embedded systems that are out there
(and that's where you would see this used in practice).

I would just document the ENOENT error code (perhaps with a note that it
should have been EAGAIN) and add a new error (EPERM?) for when no events
are subscribed.

Regards,

	Hans
