Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:34289 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753104AbeDPTmE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 15:42:04 -0400
Subject: Re: [PATCHv2 6/9] media: add 'index' to struct media_v2_pad
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
 <20180416132121.46205-7-hverkuil@xs4all.nl>
 <20180416150335.66f6ab12@vento.lan> <20180416150956.22b5b021@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b04f9c6a-78ef-3e22-be01-fa757823c13e@xs4all.nl>
Date: Mon, 16 Apr 2018 21:41:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180416150956.22b5b021@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2018 08:09 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 16 Apr 2018 15:03:35 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
>> Em Mon, 16 Apr 2018 15:21:18 +0200
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> From: Hans Verkuil <hansverk@cisco.com>
>>>
>>> The v2 pad structure never exposed the pad index, which made it impossible
>>> to call the MEDIA_IOC_SETUP_LINK ioctl, which needs that information.
>>>
>>> It is really trivial to just expose this information, so implement this.  
>>
>> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> Err... I looked on it too fast... See my comments below.
> 
> The same applies to patch 8/9.
> 
>>>
>>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>>> ---
>>>  drivers/media/media-device.c | 1 +
>>>  include/uapi/linux/media.h   | 7 ++++++-
>>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>> index dca1e5a3e0f9..73ffea3e81c9 100644
>>> --- a/drivers/media/media-device.c
>>> +++ b/drivers/media/media-device.c
>>> @@ -331,6 +331,7 @@ static long media_device_get_topology(struct media_device *mdev,
>>>  		kpad.id = pad->graph_obj.id;
>>>  		kpad.entity_id = pad->entity->graph_obj.id;
>>>  		kpad.flags = pad->flags;
>>> +		kpad.index = pad->index;
>>>  
>>>  		if (copy_to_user(upad, &kpad, sizeof(kpad)))
>>>  			ret = -EFAULT;
>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>>> index ac08acffdb65..15f7f432f808 100644
>>> --- a/include/uapi/linux/media.h
>>> +++ b/include/uapi/linux/media.h
>>> @@ -310,11 +310,16 @@ struct media_v2_interface {
>>>  	};
>>>  } __attribute__ ((packed));
>>>  
>>> +/* Appeared in 4.18.0 */
>>> +#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
>>> +	((media_version) >= 0x00041200)
>>> +
> 
> I don't like this, for a couple of reasons:
> 
> 1) it has a magic number on it, with is actually a parsed
>    version of LINUX_VERSION() macro;

I can/should change that to KERNEL_VERSION().

> 
> 2) it sounds really weird to ship a header file with a new
>    kernel version meant to provide backward compatibility with
>    older versions;
> 
> 3) this isn't any different than:
> 
> 	#define MEDIA_V2_PAD_HAS_INDEX -1
> 
> I think we need to think a little bit more about that.

What typically happens is that applications (like those in v4l-utils
for example) copy the headers locally. So they are compiled with the headers
of a specific kernel version, but they can run with very different kernels.

This is normal for distros where you can install different kernel versions
without needing to modify applications.

In fact, we (Cisco) use the latest v4l-utils code on kernels ranging between
2.6.39 to 4.10 (I think that's the latest one in use).

The media version tells you whether or not the kernel supports this feature.
I don't see another way of doing this.

In most other cases we can just say that if the field value is 0, then it
should not be used. Unfortunately, 0 is a valid value for the pad index, for
the entity flags and for the entity function (some drivers set it to
MEDIA_ENT_F_UNKNOWN, which has value 0). This last one is most unfortunate,
since this should never have happened and would have been detected if we had
proper compliance tools.

Regards,

	Hans

> 
> 
>>>  struct media_v2_pad {
>>>  	__u32 id;
>>>  	__u32 entity_id;
>>>  	__u32 flags;
>>> -	__u32 reserved[5];
>>> +	__u32 index;
>>> +	__u32 reserved[4];
>>>  } __attribute__ ((packed));
>>>  
>>>  struct media_v2_link {  
>>
>>
>>
>> Thanks,
>> Mauro
> 
> 
> 
> Thanks,
> Mauro
> 
