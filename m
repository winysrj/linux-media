Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:7004 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab3JBOVX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 10:21:23 -0400
Message-ID: <524C2BE0.9040608@linux.intel.com>
Date: Wed, 02 Oct 2013 17:21:20 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 3/4] v4l: vb2: Return POLLERR when polling for events
 and none are subscribed
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-4-git-send-email-sakari.ailus@linux.intel.com> <524C26D5.10606@xs4all.nl>
In-Reply-To: <524C26D5.10606@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your comments.

Hans Verkuil wrote:
> On 10/02/13 15:45, Sakari Ailus wrote:
>> The current implementation allowed polling for events even if none were
>> subscribed. This may be troublesome in multi-threaded applications
>> where the
>> thread handling the subscription is different from the one that
>> handles the
>> events.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c
>> index 79acf5e..c5dc903 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -2011,6 +2011,9 @@ unsigned int vb2_poll(struct vb2_queue *q,
>> struct file *file, poll_table *wait)
>>
>>           if (v4l2_event_pending(fh))
>>               res = POLLPRI;
>> +
>> +        if (!v4l2_event_has_subscribed(fh))
>> +            return POLLERR | POLLPRI;
>
> What should happen if you poll for both POLLPRI and POLLIN and one of
> the two would normally return POLLERR? Should that error condition be
> ignored?
>
> I'm not sure, frankly.

I think you just need to go to see what does VIDIOC_DQBUF / 
VIDIOC_DQEVENT return. If you're using select(2) you won't know about 
POLLERR explicitly anyway: there's a bit for read, write and exceptions 
but not for errors.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
