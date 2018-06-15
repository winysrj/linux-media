Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54500 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936193AbeFONO6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 09:14:58 -0400
Subject: Re: [PATCHv2 6/9] media: add 'index' to struct media_v2_pad
To: Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
 <20180416132121.46205-7-hverkuil@xs4all.nl>
 <20180416150335.66f6ab12@vento.lan> <20180416150956.22b5b021@vento.lan>
 <b04f9c6a-78ef-3e22-be01-fa757823c13e@xs4all.nl>
 <a8a09731-76bb-8bd9-ad16-43640d3de8ed@xs4all.nl>
 <20180417085554.067d9168@vento.lan>
 <dca4777d-e8c8-8ea5-ea64-54120997158d@xs4all.nl>
 <20180417091500.3f101620@vento.lan>
 <d9a20108-94d1-e14b-630e-6d54f4a0e5ad@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9c948d13-744c-97ee-3d10-5604f5f00910@xs4all.nl>
Date: Fri, 15 Jun 2018 15:14:56 +0200
MIME-Version: 1.0
In-Reply-To: <d9a20108-94d1-e14b-630e-6d54f4a0e5ad@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/04/18 14:19, Hans Verkuil wrote:
> On 04/17/18 14:16, Mauro Carvalho Chehab wrote:
>> Em Tue, 17 Apr 2018 14:01:06 +0200
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> On 04/17/18 13:55, Mauro Carvalho Chehab wrote:
>>>> Em Tue, 17 Apr 2018 11:59:40 +0200
>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>   
>>>>> On 04/16/18 21:41, Hans Verkuil wrote:  
>>>>>> On 04/16/2018 08:09 PM, Mauro Carvalho Chehab wrote:    
>>>>>>> Em Mon, 16 Apr 2018 15:03:35 -0300
>>>>>>> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
>>>>>>>    
>>>>>>>> Em Mon, 16 Apr 2018 15:21:18 +0200
>>>>>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>>>>>    
>>>>>>>>> From: Hans Verkuil <hansverk@cisco.com>
>>>>>>>>>
>>>>>>>>> The v2 pad structure never exposed the pad index, which made it impossible
>>>>>>>>> to call the MEDIA_IOC_SETUP_LINK ioctl, which needs that information.
>>>>>>>>>
>>>>>>>>> It is really trivial to just expose this information, so implement this.      
>>>>>>>>
>>>>>>>> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>    
>>>>>>>
>>>>>>> Err... I looked on it too fast... See my comments below.
>>>>>>>
>>>>>>> The same applies to patch 8/9.
>>>>>>>    
>>>>>>>>>
>>>>>>>>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>>>>>>>>> ---
>>>>>>>>>  drivers/media/media-device.c | 1 +
>>>>>>>>>  include/uapi/linux/media.h   | 7 ++++++-
>>>>>>>>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>>>>>>>> index dca1e5a3e0f9..73ffea3e81c9 100644
>>>>>>>>> --- a/drivers/media/media-device.c
>>>>>>>>> +++ b/drivers/media/media-device.c
>>>>>>>>> @@ -331,6 +331,7 @@ static long media_device_get_topology(struct media_device *mdev,
>>>>>>>>>  		kpad.id = pad->graph_obj.id;
>>>>>>>>>  		kpad.entity_id = pad->entity->graph_obj.id;
>>>>>>>>>  		kpad.flags = pad->flags;
>>>>>>>>> +		kpad.index = pad->index;
>>>>>>>>>  
>>>>>>>>>  		if (copy_to_user(upad, &kpad, sizeof(kpad)))
>>>>>>>>>  			ret = -EFAULT;
>>>>>>>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>>>>>>>>> index ac08acffdb65..15f7f432f808 100644
>>>>>>>>> --- a/include/uapi/linux/media.h
>>>>>>>>> +++ b/include/uapi/linux/media.h
>>>>>>>>> @@ -310,11 +310,16 @@ struct media_v2_interface {
>>>>>>>>>  	};
>>>>>>>>>  } __attribute__ ((packed));
>>>>>>>>>  
>>>>>>>>> +/* Appeared in 4.18.0 */
>>>>>>>>> +#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
>>>>>>>>> +	((media_version) >= 0x00041200)
>>>>>>>>> +    
>>>>>>>
>>>>>>> I don't like this, for a couple of reasons:
>>>>>>>
>>>>>>> 1) it has a magic number on it, with is actually a parsed
>>>>>>>    version of LINUX_VERSION() macro;    
>>>>>>
>>>>>> I can/should change that to KERNEL_VERSION().  
>>>>
>>>> I don't think so. The macro is not there at include/uapi.
>>>>   
>>>>>>     
>>>>>>>
>>>>>>> 2) it sounds really weird to ship a header file with a new
>>>>>>>    kernel version meant to provide backward compatibility with
>>>>>>>    older versions;
>>>>>>>
>>>>>>> 3) this isn't any different than:
>>>>>>>
>>>>>>> 	#define MEDIA_V2_PAD_HAS_INDEX -1
>>>>>>>
>>>>>>> I think we need to think a little bit more about that.    
>>>>>>
>>>>>> What typically happens is that applications (like those in v4l-utils
>>>>>> for example) copy the headers locally. So they are compiled with the headers
>>>>>> of a specific kernel version, but they can run with very different kernels.
>>>>>>
>>>>>> This is normal for distros where you can install different kernel versions
>>>>>> without needing to modify applications.
>>>>>>
>>>>>> In fact, we (Cisco) use the latest v4l-utils code on kernels ranging between
>>>>>> 2.6.39 to 4.10 (I think that's the latest one in use).  
>>>>
>>>> Well, if you use a macro, the "compat" code at v4l-utils (or whatever other
>>>> app you use) will be assuming the specific Kernel version you used when you
>>>> built it, with is probably not what you want.
>>>>
>>>> The way of checking if a feature is there or not is, instead, to ask for
>>>> the media version via MEDIA_IOC_DEVICE_INFO. It should provide the
>>>> media API version.
>>>>
>>>> This is already filled with:
>>>> 	info->media_version = LINUX_VERSION_CODE;
>>>>
>>>> So, all we need to do is to document that the new fields are available only
>>>> for such version or above and add such check at v4l-utils.  
>>>
>>> Yes, and that's what you stick in the macro argument:
>>>
>>> 	ioctl(fd, MEDIA_IOC_DEVICE_INFO, &info);
>>> 	if (MEDIA_V2_PAD_HAS_INDEX(info.media_version)) {
>>> 		// I can use the index field
>>> 	}
>>>
>>> I think I did not document this clearly.
>>
>> Ok, makes sense. It should be better documented, IMO.
>>
>> Still have an issue with KERNEL_VERSION: this macro doesn't exist
>> anymore on any Kernel header files. It is produced dynamically
>> at /Makefile:
>>
>> 	define filechk_version.h
>> 		(echo \#define LINUX_VERSION_CODE $(shell                         \
>> 		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
>> 		echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
>> 	endef
>>
>> Btw, this likely means that this is already broken:
>>
>> include/uapi/linux/media.h:#define MEDIA_API_VERSION                    KERNEL_VERSION(0, 1, 0)
>>
>> as userspace won't be able to evaluate it.
>>
>> We could hardcode its value, as you proposed, but, IMHO, that sucks.
> 
> This might be why I hardcoded it :-)
> 
> I personally don't have a problem with hardcoding it. In the end, it's just a number.

How about this:

/* Appeared in 4.18.0 */
#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
       ((media_version) >= ((4 << 16) | (18 << 8) | 0))

It's better than 0x00041200, and it works in the absence of KERNEL_VERSION.

Regards,

	Hans
