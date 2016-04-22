Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50229 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbcDVMhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 08:37:13 -0400
Subject: Re: [PATCH] media: vb2: Fix regression on poll() for RW mode
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1461230116-6909-1-git-send-email-ricardo.ribalda@gmail.com>
 <5719EC8D.2000500@xs4all.nl> <20160422093141.7f9191bc@recife.lan>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Junghak Sung <jh1009.sung@samsung.com>, stable@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571A1AF3.3040507@xs4all.nl>
Date: Fri, 22 Apr 2016 14:37:07 +0200
MIME-Version: 1.0
In-Reply-To: <20160422093141.7f9191bc@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2016 02:31 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 22 Apr 2016 11:19:09 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Ricardo,
>>
>> On 04/21/2016 11:15 AM, Ricardo Ribalda Delgado wrote:
>>> When using a device is read/write mode, vb2 does not handle properly the
>>> first select/poll operation. It allways return POLLERR.
>>>
>>> The reason for this is that when this code has been refactored, some of
>>> the operations have changed their order, and now fileio emulator is not
>>> started by poll, due to a previous check.
>>>
>>> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
>>> Cc: Junghak Sung <jh1009.sung@samsung.com>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 49d8ab9feaf2 ("media] media: videobuf2: Separate vb2_poll()")
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> ---
>>>  drivers/media/v4l2-core/videobuf2-core.c | 8 ++++++++
>>>  drivers/media/v4l2-core/videobuf2-v4l2.c | 8 --------
>>>  2 files changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>> index 5d016f496e0e..199c65dbe330 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>> @@ -2298,6 +2298,14 @@ unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
>>>  		return POLLERR;
>>>  
>>>  	/*
>>> +	 * For compatibility with vb1: if QBUF hasn't been called yet, then
>>> +	 * return POLLERR as well. This only affects capture queues, output
>>> +	 * queues will always initialize waiting_for_buffers to false.
>>> +	 */
>>> +	if (q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))
>>> +		return POLLERR;  
>>
>> The problem I have with this is that this should be specific to V4L2. The only
>> reason we do this is that we had to stay backwards compatible with vb1.
>>
>> This is the reason this code was placed in videobuf2-v4l2.c. But you are correct
>> that this causes a regression, and I see no other choice but to put it in core.c.
>>
>> That said, I would still only honor this when called from v4l2, so I suggest that
>> a new flag 'check_waiting_for_buffers' is added that is only set in vb2_queue_init
>> in videobuf2-v4l2.c.
>>
>> So the test above becomes:
>>
>> 	if (q->check_waiting_for_buffers && q->waiting_for_buffers &&
>> 	    (req_events & (POLLIN | POLLRDNORM)))
>>
>> It's not ideal, but at least this keeps this v4l2 specific.
> 
> I don't like the above approach, for two reasons:
> 
> 1) it is not obvious that this is V4L2 specific from the code;

s/check_waiting_for_buffers/v4l2_needs_to_wait_for_buffers/

> 
> 2) we should not mess the core due to some V4L2 mess.

Well, the only other alternative I see is to split vb2_core_poll() into two
since the check has to happen in the middle. The v4l2 code would call core_poll1(),
then do the check and afterwards call core_poll2(). And that would really be ugly.
I would probably NACK that.

Better ideas are welcome.

Regards,

	Hans
