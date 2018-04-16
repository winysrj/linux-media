Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:57691 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751206AbeDPMDy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:03:54 -0400
Subject: Re: [PATCHv2 17/17] media: v4l2-compat-ioctl32: fix several __user
 annotations
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
References: <55ced09a79ad9947c73187bfbcf85fac220a6d27.1523546545.git.mchehab@s-opensource.com>
 <a9fa4b6baa0d4f2ae05f5a03acb7c593563049b5.1523642814.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c0bb6fe-3148-b5ad-7b78-2a425369c48d@xs4all.nl>
Date: Mon, 16 Apr 2018 14:03:45 +0200
MIME-Version: 1.0
In-Reply-To: <a9fa4b6baa0d4f2ae05f5a03acb7c593563049b5.1523642814.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2018 08:07 PM, Mauro Carvalho Chehab wrote:
> Smatch report several issues with bad __user annotations:
> 
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:447:21: warning: incorrect type in argument 1 (different address spaces)
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:447:21:    expected void [noderef] <asn:1>*uptr
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:447:21:    got void *<noident>
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:621:21: warning: incorrect type in argument 1 (different address spaces)
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:621:21:    expected void const volatile [noderef] <asn:1>*<noident>
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:621:21:    got struct v4l2_plane [noderef] <asn:1>**<noident>
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:693:13: warning: incorrect type in argument 1 (different address spaces)
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:693:13:    expected void [noderef] <asn:1>*uptr
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:693:13:    got void *[assigned] base
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:871:13: warning: incorrect type in assignment (different address spaces)
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:871:13:    expected struct v4l2_ext_control [noderef] <asn:1>*kcontrols
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:871:13:    got struct v4l2_ext_control *<noident>
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:957:13: warning: incorrect type in assignment (different address spaces)
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:957:13:    expected unsigned char [usertype] *__pu_val
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:957:13:    got void [noderef] <asn:1>*
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:973:13: warning: incorrect type in argument 1 (different address spaces)
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:973:13:    expected void [noderef] <asn:1>*uptr
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:973:13:    got void *[assigned] edid
> 
> Fix them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 32 ++++++++++++++-------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index d03a44d89649..0b9dfe7dbfe7 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -443,8 +443,8 @@ static int put_v4l2_plane32(struct v4l2_plane __user *up,
>  			return -EFAULT;
>  		break;
>  	case V4L2_MEMORY_USERPTR:
> -		if (get_user(p, &up->m.userptr) ||
> -		    put_user((compat_ulong_t)ptr_to_compat((__force void *)p),
> +		if (get_user(p, &up->m.userptr)||
> +		    put_user((compat_ulong_t)ptr_to_compat((void __user *)p),
>  			     &up32->m.userptr))
>  			return -EFAULT;
>  		break;
> @@ -587,7 +587,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
>  	u32 length;
>  	enum v4l2_memory memory;
>  	struct v4l2_plane32 __user *uplane32;
> -	struct v4l2_plane __user *uplane;
> +	struct v4l2_plane *uplane;

This needs a comment (either here or before the get_user below). It really is a
pointer to userspace, but since videodev2.h has it without __user (since it is
copied to kernel space in v4l2-ioctl.c) we need to define it as a regular pointer
here and cast it to a __user pointer in the put_v4l2_plane32() call.

This is not trivially obvious, so a comment would help a lot.

>  	compat_caddr_t p;
>  	int ret;
>  
> @@ -617,15 +617,14 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
>  
>  		if (num_planes == 0)
>  			return 0;
> -
> -		if (get_user(uplane, ((__force struct v4l2_plane __user **)&kp->m.planes)))
> +		if (get_user(uplane, &kp->m.planes))
>  			return -EFAULT;
>  		if (get_user(p, &up->m.planes))
>  			return -EFAULT;
>  		uplane32 = compat_ptr(p);
>  
>  		while (num_planes--) {
> -			ret = put_v4l2_plane32(uplane, uplane32, memory);
> +			ret = put_v4l2_plane32((void __user *)uplane, uplane32, memory);
>  			if (ret)
>  				return ret;
>  			++uplane;
> @@ -675,7 +674,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
>  
>  	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
>  	    get_user(tmp, &up->base) ||
> -	    put_user((__force void *)compat_ptr(tmp), &kp->base) ||
> +	    put_user((void __force *)compat_ptr(tmp), &kp->base) ||
>  	    assign_in_user(&kp->capability, &up->capability) ||
>  	    assign_in_user(&kp->flags, &up->flags) ||
>  	    copy_in_user(&kp->fmt, &up->fmt, sizeof(kp->fmt)))
> @@ -690,7 +689,7 @@ static int put_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
>  
>  	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
>  	    get_user(base, &kp->base) ||
> -	    put_user(ptr_to_compat(base), &up->base) ||
> +	    put_user(ptr_to_compat((void __user *)base), &up->base) ||
>  	    assign_in_user(&up->capability, &kp->capability) ||
>  	    assign_in_user(&up->flags, &kp->flags) ||
>  	    copy_in_user(&up->fmt, &kp->fmt, sizeof(kp->fmt)))
> @@ -857,7 +856,7 @@ static int put_v4l2_ext_controls32(struct file *file,
>  				   struct v4l2_ext_controls32 __user *up)
>  {
>  	struct v4l2_ext_control32 __user *ucontrols;
> -	struct v4l2_ext_control __user *kcontrols;
> +	struct v4l2_ext_control *kcontrols;
>  	u32 count;
>  	u32 n;
>  	compat_caddr_t p;
> @@ -883,10 +882,12 @@ static int put_v4l2_ext_controls32(struct file *file,
>  		unsigned int size = sizeof(*ucontrols);
>  		u32 id;
>  
> -		if (get_user(id, &kcontrols->id) ||
> +		if (get_user(id, (unsigned int __user *)&kcontrols->id) ||
>  		    put_user(id, &ucontrols->id) ||
> -		    assign_in_user(&ucontrols->size, &kcontrols->size) ||
> -		    copy_in_user(&ucontrols->reserved2, &kcontrols->reserved2,
> +		    assign_in_user(&ucontrols->size,
> +				   (unsigned int __user *)&kcontrols->size) ||
> +		    copy_in_user(&ucontrols->reserved2,
> +				 (unsigned int __user *)&kcontrols->reserved2,
>  				 sizeof(ucontrols->reserved2)))
>  			return -EFAULT;
>  
> @@ -898,7 +899,8 @@ static int put_v4l2_ext_controls32(struct file *file,
>  		if (ctrl_is_pointer(file, id))
>  			size -= sizeof(ucontrols->value64);
>  
> -		if (copy_in_user(ucontrols, kcontrols, size))
> +		if (copy_in_user(ucontrols,
> +			         (unsigned int __user *)kcontrols, size))

This is rather ugly. Would it be better to do something like this:

	struct v4l2_ext_control __user *kcontrols
	struct v4l2_ext_control *kcontrols_tmp;

	get_user(kcontrols_tmp, &kp->controls);
	kcontrols = (void __user __force *)kcontrols_tmp;

And then there is no need to change anything else.

Regardless of the chosen solution, this needs comments to explain what is going
on here, just as with v4l2_buffer above.

Note: the whole 'u<foo>' and 'k<foo>' naming is now hopelessly out of date and
confusing. It should really be '<foo>32' and '<foo>64' to denote 32 bit vs
64 bit layout. The pointers are now always in userspace, so 'k<foo>' no longer
makes sense.

>  			return -EFAULT;
>  
>  		ucontrols++;
> @@ -954,7 +956,7 @@ static int get_v4l2_edid32(struct v4l2_edid __user *kp,
>  	    assign_in_user(&kp->start_block, &up->start_block) ||
>  	    assign_in_user(&kp->blocks, &up->blocks) ||
>  	    get_user(tmp, &up->edid) ||
> -	    put_user(compat_ptr(tmp), &kp->edid) ||
> +	    put_user((void __force *)compat_ptr(tmp), &kp->edid) ||
>  	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
>  		return -EFAULT;
>  	return 0;
> @@ -970,7 +972,7 @@ static int put_v4l2_edid32(struct v4l2_edid __user *kp,
>  	    assign_in_user(&up->start_block, &kp->start_block) ||
>  	    assign_in_user(&up->blocks, &kp->blocks) ||
>  	    get_user(edid, &kp->edid) ||
> -	    put_user(ptr_to_compat(edid), &up->edid) ||
> +	    put_user(ptr_to_compat((void __user *)edid), &up->edid) ||
>  	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
>  		return -EFAULT;
>  	return 0;
> 

Otherwise this patch looks good.

Regards,

	Hans
