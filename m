Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60849 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab1FQKUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 06:20:23 -0400
Message-ID: <4DFB2C0E.4040100@ti.com>
Date: Fri, 17 Jun 2011 15:57:26 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Subject: Re: [PATCH] omap_vout: Added check in reqbuf & mmap for buf_size
 allocation
References: <hvaibhav@ti.com> <1308255249-18762-1-git-send-email-hvaibhav@ti.com> <4DFB1445.3000102@ti.com> <19F8576C6E063C45BE387C64729E739404E30727E0@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E30727E0@dbde02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Friday 17 June 2011 03:33 PM, Hiremath, Vaibhav wrote:
>
>> -----Original Message-----
>> From: Taneja, Archit
>> Sent: Friday, June 17, 2011 2:16 PM
>> To: Hiremath, Vaibhav
>> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl
>> Subject: Re: [PATCH] omap_vout: Added check in reqbuf&  mmap for buf_size
>> allocation
>>
>> Hi,
>>
>> On Friday 17 June 2011 01:44 AM, Hiremath, Vaibhav wrote:
>>> From: Vaibhav Hiremath<hvaibhav@ti.com>
>>>
>>> The usecase where, user allocates small size of buffer
>>> through bootargs (video1_bufsize/video2_bufsize) and later from
>> application
>>> tries to set the format which requires larger buffer size, driver
>> doesn't
>>> check for insufficient buffer size and allows application to map extra
>> buffer.
>>> This leads to kernel crash, when user application tries to access memory
>>> beyond the allocation size.
>>
>> Query: Why do we pass the bufsize as bootargs in the first place? Is it
>> needed at probe time?
>>
> [Hiremath, Vaibhav] Yes, look out for variable (video1_bufsize/video2_bufsize) in code.

Yes, but why do we need to allocate some fixed size buffers at boot 
time? Is it done because it makes our allocation happens faster during 
reqbufs? Or is it required for VRFB?

Could you explain the reason/startegy behind allocating buffers of a 
particular size at boot time?

Thanks,
Archit

>
> Thanks,
> Vaibhav
>
>> Thanks,
>> Archit
>>
>>>
>>> Added check in both mmap and reqbuf call back function,
>>> and return error if the size of the buffer allocated by user through
>>> bootargs is less than the S_FMT size.
>>>
>>> Signed-off-by: Vaibhav Hiremath<hvaibhav@ti.com>
>>> ---
>>>    drivers/media/video/omap/omap_vout.c |   16 ++++++++++++++++
>>>    1 files changed, 16 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/media/video/omap/omap_vout.c
>> b/drivers/media/video/omap/omap_vout.c
>>> index 3bc909a..343b50c 100644
>>> --- a/drivers/media/video/omap/omap_vout.c
>>> +++ b/drivers/media/video/omap/omap_vout.c
>>> @@ -678,6 +678,14 @@ static int omap_vout_buffer_setup(struct
>> videobuf_queue *q, unsigned int *count,
>>>    	startindex = (vout->vid == OMAP_VIDEO1) ?
>>>    		video1_numbuffers : video2_numbuffers;
>>>
>>> +	/* Check the size of the buffer */
>>> +	if (*size>   vout->buffer_size) {
>>> +		v4l2_err(&vout->vid_dev->v4l2_dev,
>>> +				"buffer allocation mismatch [%u] [%u]\n",
>>> +				*size, vout->buffer_size);
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>>    	for (i = startindex; i<   *count; i++) {
>>>    		vout->buffer_size = *size;
>>>
>>> @@ -856,6 +864,14 @@ static int omap_vout_mmap(struct file *file, struct
>> vm_area_struct *vma)
>>>    				(vma->vm_pgoff<<   PAGE_SHIFT));
>>>    		return -EINVAL;
>>>    	}
>>> +	/* Check the size of the buffer */
>>> +	if (size>   vout->buffer_size) {
>>> +		v4l2_err(&vout->vid_dev->v4l2_dev,
>>> +				"insufficient memory [%lu] [%u]\n",
>>> +				size, vout->buffer_size);
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>>    	q->bufs[i]->baddr = vma->vm_start;
>>>
>>>    	vma->vm_flags |= VM_RESERVED;
>>> --
>>> 1.6.2.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
>

