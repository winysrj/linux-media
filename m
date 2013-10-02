Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45369 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab3JBOt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 10:49:58 -0400
Message-ID: <524C3280.5030406@linux.intel.com>
Date: Wed, 02 Oct 2013 17:49:36 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 4/4] v4l: events: Don't sleep in dequeue if none are
 subscribed
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-5-git-send-email-sakari.ailus@linux.intel.com> <524C27F6.4040002@xs4all.nl> <524C2B30.9050605@linux.intel.com> <524C2F9A.80806@xs4all.nl>
In-Reply-To: <524C2F9A.80806@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
...
>>>> +        if (!subscribed) {
>>>> +            ret = -EIO;
>>>
>>> Shouldn't this be -ENOENT?
>>
>> If I use -ENOENT, having no events subscribed is indistinguishable
>> form no events pending condition. Combine that with using select(2),
>> and you can no longer distinguish having no events subscribed from
>> the case where you got an event but someone else (another thread or
>> process) dequeued it.
>
> OK, but then your commit message is out of sync with the actual patch since
> the commit log says ENOENT.
>
>> -EIO makes that explicit --- this also mirrors the behaviour of
>> VIDIOC_DQBUF. (And it must be documented as well, which is missing
>> from the patch currently.)
>
> I don't like using EIO for this. EIO generally is returned if a hardware
> error or an unexpected hardware condition occurs. How about -ENOMSG? Or
> perhaps EPIPE? (As in: "the pipe containing events is gone").

Thinking about this some more, -ENOENT is probably what we should 
return. *But* when there are no events to dequeue, we should instead 
return -EAGAIN (i.e. EWOULDBLOCK) which VIDIOC_DQBUF also uses.

However I'm not sure if anything depends on -ENOENT currently (probably 
not really) so changing this might require some consideration. No error 
codes are currently defined for VIDIOC_DQEVENT; was planning to fix that 
while we're at this.

-- 
Cheers,

Sakari Ailus
sakari.ailus@linux.intel.com
