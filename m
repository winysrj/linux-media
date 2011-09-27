Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1I0LlE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 07:41:04 -0400
Message-ID: <4E81B646.2010400@redhat.com>
Date: Tue, 27 Sep 2011 08:40:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <4E805E6E.3080007@redhat.com> <011201cc7c3e$798c5bc0$6ca51340$%szyprowski@samsung.com> <4E807E67.3000508@redhat.com> <000001cc7cee$c465d350$4d3179f0$%szyprowski@samsung.com>
In-Reply-To: <000001cc7cee$c465d350$4d3179f0$%szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-09-2011 05:23, Marek Szyprowski escreveu:
> Hello,
> 
> On Monday, September 26, 2011 3:30 PM Mauro Carvalho Chehab wrote:
> 
>> Em 26-09-2011 08:21, Marek Szyprowski escreveu:
>>> Hello,
>>>
>>> On Monday, September 26, 2011 1:14 PM Mauro Carvalho Chehab wrote:
>>>
>>>>> Scott Jiang (1):
>>>>>       vb2: add vb2_get_unmapped_area in vb2 core
>>>>
>>>>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>>>>> index ea55c08..977410b 100644
>>>>> --- a/include/media/videobuf2-core.h
>>>>> +++ b/include/media/videobuf2-core.h
>>>>> @@ -309,6 +309,13 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
>>>>>  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
>>>>>
>>>>>  int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
>>>>> +#ifndef CONFIG_MMU
>>>>> +unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>>>>> +				    unsigned long addr,
>>>>> +				    unsigned long len,
>>>>> +				    unsigned long pgoff,
>>>>> +				    unsigned long flags);
>>>>> +#endif
>>>>>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
>>>>>  size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
>>>>>  		loff_t *ppos, int nonblock);
>>>>
>>>> This sounds me like a hack, as it is passing the problem of working with a non-mmu
>>>> capable hardware to the driver, inserting architecture-dependent bits on them.
>>>>
>>>> The proper way to do it is to provide a vb2 core support to handle the non-mmu case
>>>> inside it.
>>>
>>> This is exactly what this patch does - it provides generic vb2 implementation for
>>> fops->get_unmapped_area callback which any vb2 ready driver can use. This operation
>>> is used only on NON-MMU systems. Please check drivers/media/video/v4l2-dev.c file and
>>> the implementation of get_unmapped_area there. Similar code is used by uvc driver.
>>
>> At least there, there is a:
>> #ifdef CONFIG_MMU
>> #define v4l2_get_unmapped_area NULL
>> #else
>> ...
>> #endif
>>
>> block, so, in thesis, a driver can be written to support both cases without inserting
>> #ifdefs inside it.
> 
> videobuf2 functions are not meant to be used as direct callbacks in fops so defining it
> as NULL makes no sense at all.
> 
>> Ideally, I would prefer if all those iommu-specific calls would be inside the core.
>> A driver should not need to do anything special in order to support a different
>> (sub)architecture.
> 
> It is not about IOMMU at all. Some (embedded) systems don't have MMU at all. Drivers on
> such systems cannot do regular mmap operation. Instead it is emulated with 
> get_unmapped_area fops callback and some (u)libC magic. This patch just provides
> vb2_get_unmapped_area function. Drivers have to call it from their respective
> my_driver_get_unmapped_area() function provided in its fops. Implementing it makes
> sense only on NO-MMU systems. I really see no other way of dealing with this.

Ok. Feel free to add this patch again on a next request.

Thanks,
Mauro
> 
> Best regards

