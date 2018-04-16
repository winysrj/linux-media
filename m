Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58292 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751169AbeDPPcd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 11:32:33 -0400
Subject: Re: [PATCHv2 17/17] media: v4l2-compat-ioctl32: fix several __user
 annotations
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
References: <55ced09a79ad9947c73187bfbcf85fac220a6d27.1523546545.git.mchehab@s-opensource.com>
 <a9fa4b6baa0d4f2ae05f5a03acb7c593563049b5.1523642814.git.mchehab@s-opensource.com>
 <5c0bb6fe-3148-b5ad-7b78-2a425369c48d@xs4all.nl>
 <20180416115027.2fbca161@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <15d2a218-ea3d-1732-acaa-2f4c189fabab@xs4all.nl>
Date: Mon, 16 Apr 2018 17:32:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180416115027.2fbca161@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2018 04:50 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 16 Apr 2018 14:03:45 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 04/13/2018 08:07 PM, Mauro Carvalho Chehab wrote:
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
>>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 32 ++++++++++++++-------------
>>>  1 file changed, 17 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>> index d03a44d89649..0b9dfe7dbfe7 100644
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
>>
>> This needs a comment (either here or before the get_user below). It really is a
>> pointer to userspace, but since videodev2.h has it without __user (since it is
>> copied to kernel space in v4l2-ioctl.c) we need to define it as a regular pointer
>> here and cast it to a __user pointer in the put_v4l2_plane32() call.
>>
>> This is not trivially obvious, so a comment would help a lot.
> 
> 
> 
>>
>>>  	compat_caddr_t p;
>>>  	int ret;
>>>  
>>> @@ -617,15 +617,14 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
>>>  
>>>  		if (num_planes == 0)
>>>  			return 0;
>>> -
>>> -		if (get_user(uplane, ((__force struct v4l2_plane __user **)&kp->m.planes)))
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
>>> @@ -675,7 +674,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
>>>  
>>>  	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
>>>  	    get_user(tmp, &up->base) ||
>>> -	    put_user((__force void *)compat_ptr(tmp), &kp->base) ||
>>> +	    put_user((void __force *)compat_ptr(tmp), &kp->base) ||
>>>  	    assign_in_user(&kp->capability, &up->capability) ||
>>>  	    assign_in_user(&kp->flags, &up->flags) ||
>>>  	    copy_in_user(&kp->fmt, &up->fmt, sizeof(kp->fmt)))
>>> @@ -690,7 +689,7 @@ static int put_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
>>>  
>>>  	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
>>>  	    get_user(base, &kp->base) ||
>>> -	    put_user(ptr_to_compat(base), &up->base) ||
>>> +	    put_user(ptr_to_compat((void __user *)base), &up->base) ||
>>>  	    assign_in_user(&up->capability, &kp->capability) ||
>>>  	    assign_in_user(&up->flags, &kp->flags) ||
>>>  	    copy_in_user(&up->fmt, &kp->fmt, sizeof(kp->fmt)))
>>> @@ -857,7 +856,7 @@ static int put_v4l2_ext_controls32(struct file *file,
>>>  				   struct v4l2_ext_controls32 __user *up)
>>>  {
>>>  	struct v4l2_ext_control32 __user *ucontrols;
>>> -	struct v4l2_ext_control __user *kcontrols;
>>> +	struct v4l2_ext_control *kcontrols;
>>>  	u32 count;
>>>  	u32 n;
>>>  	compat_caddr_t p;
>>> @@ -883,10 +882,12 @@ static int put_v4l2_ext_controls32(struct file *file,
>>>  		unsigned int size = sizeof(*ucontrols);
>>>  		u32 id;
>>>  
>>> -		if (get_user(id, &kcontrols->id) ||
>>> +		if (get_user(id, (unsigned int __user *)&kcontrols->id) ||
>>>  		    put_user(id, &ucontrols->id) ||
>>> -		    assign_in_user(&ucontrols->size, &kcontrols->size) ||
>>> -		    copy_in_user(&ucontrols->reserved2, &kcontrols->reserved2,
>>> +		    assign_in_user(&ucontrols->size,
>>> +				   (unsigned int __user *)&kcontrols->size) ||
>>> +		    copy_in_user(&ucontrols->reserved2,
>>> +				 (unsigned int __user *)&kcontrols->reserved2,
>>>  				 sizeof(ucontrols->reserved2)))
>>>  			return -EFAULT;
>>>  
>>> @@ -898,7 +899,8 @@ static int put_v4l2_ext_controls32(struct file *file,
>>>  		if (ctrl_is_pointer(file, id))
>>>  			size -= sizeof(ucontrols->value64);
>>>  
>>> -		if (copy_in_user(ucontrols, kcontrols, size))
>>> +		if (copy_in_user(ucontrols,
>>> +			         (unsigned int __user *)kcontrols, size))  
>>
>> This is rather ugly. Would it be better to do something like this:
>>
>> 	struct v4l2_ext_control __user *kcontrols
>> 	struct v4l2_ext_control *kcontrols_tmp;
>>
>> 	get_user(kcontrols_tmp, &kp->controls);
>> 	kcontrols = (void __user __force *)kcontrols_tmp;
> 
> Nah, having two pointers with the same value, one with __user and another
> one without it will make it really hard for people to review.
> 
>>
>> And then there is no need to change anything else.
>>
>> Regardless of the chosen solution, this needs comments to explain what is going
>> on here, just as with v4l2_buffer above.
> 
> Actually, the problem here happens before that. The problem
> here (and on the previous one) is that get_user() expects that
> the second argument to be a Kernelspace pointer.

You mean the first argument? I'm actually not entirely sure if this is
correct since __get_user calls __typeof__, but that might not know about
__user. Anyway, it does not really matter for this patch and the uaccess.h
code gives me a headache :-)

> 
> So, in this routine, it does (simplified):
> 
>         struct v4l2_ext_control32 __user *ucontrols;
>         struct v4l2_ext_control *kcontrols;
> 
> ...
> 	get_user(kcontrols, &kp->controls);
> 
> Then, every time it needs to get something related to it,
> it needs the __user, like here:
> 
> 	if (get_user(id, (unsigned int __user *)&kcontrols->id)
> 	...
> 
> In this specific case, only copy_in_user() was missing it; all the other
> __user casts are there already.
> 
> 
>> Note: the whole 'u<foo>' and 'k<foo>' naming is now hopelessly out of date and
>> confusing. It should really be '<foo>32' and '<foo>64' to denote 32 bit vs
>> 64 bit layout. The pointers are now always in userspace, so 'k<foo>' no longer
>> makes sense.
> 
> Yes, we need this change, but this should be at a separate patch.
> 
> I can do it, after we cleanup v4l2-compat-ioctl32.c from their namespace
> mess.

Of course, this is a separate patch.

> 
> 
>>
>>>  			return -EFAULT;
>>>  
>>>  		ucontrols++;
>>> @@ -954,7 +956,7 @@ static int get_v4l2_edid32(struct v4l2_edid __user *kp,
>>>  	    assign_in_user(&kp->start_block, &up->start_block) ||
>>>  	    assign_in_user(&kp->blocks, &up->blocks) ||
>>>  	    get_user(tmp, &up->edid) ||
>>> -	    put_user(compat_ptr(tmp), &kp->edid) ||
>>> +	    put_user((void __force *)compat_ptr(tmp), &kp->edid) ||
>>>  	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
>>>  		return -EFAULT;
>>>  	return 0;
>>> @@ -970,7 +972,7 @@ static int put_v4l2_edid32(struct v4l2_edid __user *kp,
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
>> Otherwise this patch looks good.
>>
>> Regards,
>>
>> 	Hans
> 
> Would be ok if I fold (or add as a separate patch) the enclosed diff?
> 
> Thanks,
> Mauro
> 
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 1057ab8ce2b6..5c3408bdfd89 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -617,6 +617,15 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
>  
>  		if (num_planes == 0)
>  			return 0;
> +		/*
> +		 * We needed to define uplane without user.
> +		 * The reason is that v4l2-ioctl.c copies it from userspace
> +		 * into Kernelspace, so it's definition at videodev2.h doesn't
> +		 * have an __user markup. That makes get_user() to do wrong
> +		 * casts, as pointed by smatch.
> +		 * So, instead, declare it as ks, and pass it as an userspace
> +		 * pointer to put_v4l2_plane32().
> +		 */

I would propose this text:

"We need to define uplane without __user, even though it does point
to data in userspace here. The reason is that v4l2-ioctl.c copies it from
userspace to kernelspace, so its definition in videodev2.h doesn't have a
__user markup. Defining uplane with __user causes smatch warnings, so
instead declare it without __user and cast it as a userspace pointer to
put_v4l2_plane32()."

(yes, it's 'a user'. See https://ell.stackexchange.com/questions/26986/why-a-user-instead-of-an-user)

>  		if (get_user(uplane, &kp->m.planes))
>  			return -EFAULT;
>  		if (get_user(p, &up->m.planes))
> @@ -861,6 +870,15 @@ static int put_v4l2_ext_controls32(struct file *file,
>  	u32 n;
>  	compat_caddr_t p;
>  
> +	/*
> +	 * We needed to define kcontrols without user.
> +	 * The reason is that v4l2-ioctl.c copies it from userspace
> +	 * into Kernelspace, so it's definition at videodev2.h doesn't
> +	 * have an __user markup. That makes get_user() & friends to do
> +	 * wrong casts, as pointed by smatch.
> +	 * So, instead, declare it as ks, and pass it as an userspace
> +	 * pointer where needed.
> +	 */

"We need to define kcontrols without __user, even though it does point
to data in userspace here. The reason is that v4l2-ioctl.c copies it from
userspace to kernelspace, so its definition in videodev2.h doesn't have a
__user markup. Defining kcontrols with __user causes smatch warnings, so
instead declare it without __user and cast it as a userspace pointer where
needed."

>  	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
>  	    assign_in_user(&up->which, &kp->which) ||
>  	    get_user(count, &kp->count) ||
> 
> 

Regards,

	Hans
