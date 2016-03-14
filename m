Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbcCNPeQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 11:34:16 -0400
Subject: Re: [PATCH 6/7] [media] gspca: fix a v4l2-compliance failure during
 VIDIOC_REQBUFS
To: Antonio Ospite <ao2@ao2.it>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
 <1457539401-11515-7-git-send-email-ao2@ao2.it> <56E18AAD.9010600@redhat.com>
 <20160314160233.68566d15c5a73f6efced01c3@ao2.it>
Cc: Linux Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <56E6D9F3.4050102@redhat.com>
Date: Mon, 14 Mar 2016 16:34:11 +0100
MIME-Version: 1.0
In-Reply-To: <20160314160233.68566d15c5a73f6efced01c3@ao2.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 14-03-16 16:02, Antonio Ospite wrote:
> On Thu, 10 Mar 2016 15:54:37 +0100
> Hans de Goede <hdegoede@redhat.com> wrote:
>
>> Hi,
>>
>> On 09-03-16 17:03, Antonio Ospite wrote:
>>> When calling VIDIOC_REQBUFS v4l2-compliance fails with this message:
>>>
>>>     fail: v4l2-test-buffers.cpp(476): q.reqbufs(node, 1)
>>>     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>>>
>>> By looking at the v4l2-compliance code the failure happens when trying
>>> to request V4L2_MEMORY_USERPTR buffers without freeing explicitly the
>>> previously allocated V4L2_MEMORY_MMAP buffers.
>>>
>>> This would suggest that when changing the memory field in struct
>>> v4l2_requestbuffers the driver is supposed to free automatically any
>>> previous allocated buffers, and looking for inspiration at the code in
>>> drivers/media/v4l2-core/videobuf2-core.c::vb2_core_reqbufs() seems to
>>> confirm this interpretation; however gspca is just returning -EBUSY in
>>> this case.
>>>
>>> Removing the special handling for the case of a different memory value
>>> fixes the compliance failure.
>>>
>>> Signed-off-by: Antonio Ospite <ao2@ao2.it>
>>> ---
>>>
>>> This should be safe, but I'd really like a comment from someone with a more
>>> global knowledge of v4l2.
>>>
>>> If my interpretation about how drivers should behave when the value of the
>>> memory field changes is correct, I could send also a documentation update for
>>> Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
>>>
>>> Just let me know.
>>>
>>> Thanks,
>>>      Antonio
>>>
>>>
>>>    drivers/media/usb/gspca/gspca.c | 7 -------
>>>    1 file changed, 7 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
>>> index 84b0d6a..915b6c7 100644
>>> --- a/drivers/media/usb/gspca/gspca.c
>>> +++ b/drivers/media/usb/gspca/gspca.c
>>> @@ -1402,13 +1402,6 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>>>    	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
>>>    		return -ERESTARTSYS;
>>>
>>> -	if (gspca_dev->memory != GSPCA_MEMORY_NO
>>> -	    && gspca_dev->memory != GSPCA_MEMORY_READ
>>> -	    && gspca_dev->memory != rb->memory) {
>>> -		ret = -EBUSY;
>>> -		goto out;
>>> -	}
>>> -
>>
>> reqbufs is used internally and this change will allow changing
>> gspca_dev->memory from USERPTR / MMAP to GSPCA_MEMORY_READ
>> please replace this check with a check to only allow
>> rb->memory to be GSPCA_MEMORY_READ when coming from GSPCA_MEMORY_NO
>> or GSPCA_MEMORY_READ
>>
>
> OK, thanks, I'll take a look again later this week.
>
> In the meantime, if patches from 1 to 5 are OK, can we have them merged
> so I will just resubmit the last two in the set?

Not sure when I'll have time to do this, I would prefer to also take
v2 of patch 6 and 7 while at it. But I agree that there is no need
to pick op patches 1 - 5. I'll pick them up from patchwork when I've
time.

Regards,

Hans
