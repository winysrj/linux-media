Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:31325 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbeDQLEf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 07:04:35 -0400
Subject: Re: [PATCH 4/5] media: v4l2-compat-ioctl32: fix several __user
 annotations
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1523960171.git.mchehab@s-opensource.com>
 <510d0652872c612db21be8b846755f80e3cc4588.1523960171.git.mchehab@s-opensource.com>
 <a150928f-c236-4751-b704-7ce71fd56bc2@cisco.com>
 <20180417075358.61a878c8@vento.lan>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <b3ed6478-9cf5-478d-067b-5d325dfeaadd@cisco.com>
Date: Tue, 17 Apr 2018 13:04:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180417075358.61a878c8@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/18 12:53, Mauro Carvalho Chehab wrote:
> Em Tue, 17 Apr 2018 12:33:11 +0200
> Hans Verkuil <hansverk@cisco.com> escreveu:
> 
>> On 04/17/18 12:20, Mauro Carvalho Chehab wrote:
>>> Smatch report several issues with bad __user annotations:
>>>
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:447:21: warning: incorrect type in argument 1 (different address spaces)
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:447:21:    expected void [noderef] <asn:1>*uptr
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:447:21:    got void *<noident>
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:621:21: warning: incorrect type in argument 1 (different address spaces)
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:621:21:    expected void const volatile [noderef] <asn:1>*<noident>
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:621:21:    got struct v4l2_plane [noderef] <asn:1>**<noident>
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:693:13: warning: incorrect type in argument 1 (different address spaces)
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:693:13:    expected void [noderef] <asn:1>*uptr
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:693:13:    got void *[assigned] base
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:871:13: warning: incorrect type in assignment (different address spaces)
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:871:13:    expected struct v4l2_ext_control [noderef] <asn:1>*kcontrols
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:871:13:    got struct v4l2_ext_control *<noident>
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:957:13: warning: incorrect type in assignment (different address spaces)
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:957:13:    expected unsigned char [usertype] *__pu_val
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:957:13:    got void [noderef] <asn:1>*
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:973:13: warning: incorrect type in argument 1 (different address spaces)
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:973:13:    expected void [noderef] <asn:1>*uptr
>>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:973:13:    got void *[assigned] edid
>>>
>>> Fix them.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 51 ++++++++++++++++++---------
>>>  1 file changed, 35 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>> index d03a44d89649..c951ac3faf46 100644
>>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>> @@ -443,8 +443,8 @@ static int put_v4l2_plane32(struct v4l2_plane __user *up,
>>>  			return -EFAULT;
>>>  		break;
>>>  	case V4L2_MEMORY_USERPTR:
>>> -		if (get_user(p, &up->m.userptr) ||
>>> -		    put_user((compat_ulong_t)ptr_to_compat((__force void *)p),
>>> +		if (get_user(p, &up->m.userptr)||
>>> +		    put_user((compat_ulong_t)ptr_to_compat((void __user *)p),
>>>  			     &up32->m.userptr))
>>>  			return -EFAULT;
>>>  		break;
>>> @@ -587,7 +587,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
>>>  	u32 length;
>>>  	enum v4l2_memory memory;
>>>  	struct v4l2_plane32 __user *uplane32;
>>> -	struct v4l2_plane __user *uplane;
>>> +	struct v4l2_plane *uplane;
>>>  	compat_caddr_t p;
>>>  	int ret;
>>>  
>>> @@ -617,15 +617,22 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
>>>  
>>>  		if (num_planes == 0)
>>>  			return 0;
>>> -
>>> -		if (get_user(uplane, ((__force struct v4l2_plane __user **)&kp->m.planes)))
>>> +		/* We need to define uplane without __user, even though
>>> +		 * it does point to data in userspace here. The reason is
>>> +		 * that v4l2-ioctl.c copies it from userspace to kernelspace,
>>> +		 * so its definition in videodev2.h doesn't have a
>>> +		 * __user markup. Defining uplane with __user causes
>>> +		 * smatch warnings, so instead declare it without __user
>>> +		 * and cast it as a userspace pointer to put_v4l2_plane32().
>>> +		 */
>>> +		if (get_user(uplane, &kp->m.planes))
>>>  			return -EFAULT;
>>>  		if (get_user(p, &up->m.planes))
>>>  			return -EFAULT;
>>>  		uplane32 = compat_ptr(p);
>>>  
>>>  		while (num_planes--) {
>>> -			ret = put_v4l2_plane32(uplane, uplane32, memory);
>>> +			ret = put_v4l2_plane32((void __user *)uplane, uplane32, memory);
>>>  			if (ret)
>>>  				return ret;
>>>  			++uplane;
>>> @@ -675,7 +682,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
>>>  
>>>  	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
>>>  	    get_user(tmp, &up->base) ||
>>> -	    put_user((__force void *)compat_ptr(tmp), &kp->base) ||
>>> +	    put_user((void __force *)compat_ptr(tmp), &kp->base) ||
>>>  	    assign_in_user(&kp->capability, &up->capability) ||
>>>  	    assign_in_user(&kp->flags, &up->flags) ||
>>>  	    copy_in_user(&kp->fmt, &up->fmt, sizeof(kp->fmt)))
>>> @@ -690,7 +697,7 @@ static int put_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
>>>  
>>>  	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
>>>  	    get_user(base, &kp->base) ||
>>> -	    put_user(ptr_to_compat(base), &up->base) ||
>>> +	    put_user(ptr_to_compat((void __user *)base), &up->base) ||
>>>  	    assign_in_user(&up->capability, &kp->capability) ||
>>>  	    assign_in_user(&up->flags, &kp->flags) ||
>>>  	    copy_in_user(&up->fmt, &kp->fmt, sizeof(kp->fmt)))
>>> @@ -857,11 +864,19 @@ static int put_v4l2_ext_controls32(struct file *file,
>>>  				   struct v4l2_ext_controls32 __user *up)
>>>  {
>>>  	struct v4l2_ext_control32 __user *ucontrols;
>>> -	struct v4l2_ext_control __user *kcontrols;
>>> +	struct v4l2_ext_control *kcontrols;
>>>  	u32 count;
>>>  	u32 n;
>>>  	compat_caddr_t p;
>>>  
>>> +	/*
>>> +	 * We need to define kcontrols without __user, even though it does
>>> +	 * point to data in userspace here. The reason is that v4l2-ioctl.c
>>> +	 * copies it from userspace to kernelspace, so its definition in
>>> +	 * videodev2.h doesn't have a __user markup. Defining kcontrols
>>> +	 * with __user causes smatch warnings, so instead declare it
>>> +	 * without __user and cast it as a userspace pointer where needed.
>>> +	 */
>>>  	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
>>>  	    assign_in_user(&up->which, &kp->which) ||
>>>  	    get_user(count, &kp->count) ||
>>> @@ -883,10 +898,12 @@ static int put_v4l2_ext_controls32(struct file *file,
>>>  		unsigned int size = sizeof(*ucontrols);
>>>  		u32 id;
>>>  
>>> -		if (get_user(id, &kcontrols->id) ||
>>> +		if (get_user(id, (unsigned int __user *)&kcontrols->id) ||  
>>
>> Why use 'unsigned int' instead of u32? It's defined as __u32 in the header,
>> so let's keep this consistent.
> 
> Makes sense.
> 
> It should be noticed, however, that, on all other similar casts that are
> already there, it uses unsigned int:
> 
> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:          unsigned int size = sizeof(*ucontrols);
> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:          err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:          if (!err && assign_in_user((unsigned int __user *)up_native,
> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:          err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:                             ((unsigned int __user *)up_native)))
> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
> 
> So, I tried to be consistent with that.

Those casts are probably very old and they should be fixed at some point.

> 
>>
>>>  		    put_user(id, &ucontrols->id) ||
>>> -		    assign_in_user(&ucontrols->size, &kcontrols->size) ||
>>> -		    copy_in_user(&ucontrols->reserved2, &kcontrols->reserved2,
>>> +		    assign_in_user(&ucontrols->size,
>>> +				   (unsigned int __user *)&kcontrols->size) ||  
>>
>> Same here.
>>
>>> +		    copy_in_user(&ucontrols->reserved2,
>>> +				 (unsigned int __user *)&kcontrols->reserved2,  
>>
>> This can be a void __user *.
> 
> We should be very careful changing it to void. When I tested the first
> version of this patchset, I noticed that the results produced by one
> ioctl were different with v4l2-compliance, between 32/64 bits version,
> because the type of the cast was wrong.
> 
> So, it should really match the type of the fields that will be copying,
> as otherwise we may have troubles.

copy_in_user has void * arguments, and it is just a memcpy effectively.
There is no point in sticking to the field types (and it doesn't do that
either in this code).

> 
> (same applies to your similar comments below)
> 
>>
>>>  				 sizeof(ucontrols->reserved2)))
>>>  			return -EFAULT;
>>>  
>>> @@ -898,7 +915,8 @@ static int put_v4l2_ext_controls32(struct file *file,
>>>  		if (ctrl_is_pointer(file, id))
>>>  			size -= sizeof(ucontrols->value64);
>>>  
>>> -		if (copy_in_user(ucontrols, kcontrols, size))
>>> +		if (copy_in_user(ucontrols,
>>> +			         (unsigned int __user *)kcontrols, size))  
>>
>> void __user *
>>
>>>  			return -EFAULT;
>>>  
>>>  		ucontrols++;
>>> @@ -952,9 +970,10 @@ static int get_v4l2_edid32(struct v4l2_edid __user *kp,
>>>  	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
>>>  	    assign_in_user(&kp->pad, &up->pad) ||
>>>  	    assign_in_user(&kp->start_block, &up->start_block) ||
>>> -	    assign_in_user(&kp->blocks, &up->blocks) ||
>>> +	    assign_in_user(&kp->blocks,
>>> +			   (unsigned char __user *)&up->blocks) ||  
>>
>> ->blocks is a u32, so this should be a u32 cast as well.  

Be aware that the unsigned char * cast is actually a bug: it will clamp the
u32 'blocks' value to a u8.

Regards,

	Hans

>>
>>>  	    get_user(tmp, &up->edid) ||
>>> -	    put_user(compat_ptr(tmp), &kp->edid) ||
>>> +	    put_user((void __force *)compat_ptr(tmp), &kp->edid) ||
>>>  	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
>>>  		return -EFAULT;
>>>  	return 0;
>>> @@ -970,7 +989,7 @@ static int put_v4l2_edid32(struct v4l2_edid __user *kp,
>>>  	    assign_in_user(&up->start_block, &kp->start_block) ||
>>>  	    assign_in_user(&up->blocks, &kp->blocks) ||
>>>  	    get_user(edid, &kp->edid) ||
>>> -	    put_user(ptr_to_compat(edid), &up->edid) ||
>>> +	    put_user(ptr_to_compat((void __user *)edid), &up->edid) ||
>>>  	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
>>>  		return -EFAULT;
>>>  	return 0;
>>>   
>>
>> Regards,
>>
>> 	Hans
> 
> 
> 
> Thanks,
> Mauro
> 
