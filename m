Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27250 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab3JBOS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 10:18:28 -0400
Message-ID: <524C2B30.9050605@linux.intel.com>
Date: Wed, 02 Oct 2013 17:18:24 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 4/4] v4l: events: Don't sleep in dequeue if none are
 subscribed
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-5-git-send-email-sakari.ailus@linux.intel.com> <524C27F6.4040002@xs4all.nl>
In-Reply-To: <524C27F6.4040002@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments!

Hans Verkuil wrote:
> On 10/02/13 15:45, Sakari Ailus wrote:
>> Dequeueing events was is entirely possible even if none are subscribed,
>> leading to sleeping indefinitely. Fix this by returning -ENOENT when no
>> events are subscribed.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   drivers/media/v4l2-core/v4l2-event.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-event.c
>> b/drivers/media/v4l2-core/v4l2-event.c
>> index b53897e..553a800 100644
>> --- a/drivers/media/v4l2-core/v4l2-event.c
>> +++ b/drivers/media/v4l2-core/v4l2-event.c
>> @@ -77,10 +77,17 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct
>> v4l2_event *event,
>>           mutex_unlock(fh->vdev->lock);
>>
>>       do {
>> -        ret = wait_event_interruptible(fh->wait,
>> -                           fh->navailable != 0);
>> +        bool subscribed;
>
> Can you add an empty line here?

Sure.

>> +        ret = wait_event_interruptible(
>> +            fh->wait,
>> +            fh->navailable != 0 ||
>> +            !(subscribed = v4l2_event_has_subscribed(fh)));
>>           if (ret < 0)
>>               break;
>> +        if (!subscribed) {
>> +            ret = -EIO;
>
> Shouldn't this be -ENOENT?

If I use -ENOENT, having no events subscribed is indistinguishable form 
no events pending condition. Combine that with using select(2), and you 
can no longer distinguish having no events subscribed from the case 
where you got an event but someone else (another thread or process) 
dequeued it.

-EIO makes that explicit --- this also mirrors the behaviour of 
VIDIOC_DQBUF. (And it must be documented as well, which is missing from 
the patch currently.)

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com

