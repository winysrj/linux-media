Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45320 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752166AbeDRI5R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 04:57:17 -0400
Date: Wed, 18 Apr 2018 11:57:13 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Daniel Mentz <danielmentz@google.com>
Subject: Re: [PATCH] media: v4l2-compat-ioctl32: simplify casts
Message-ID: <20180418085713.3r7zihp2htdsiydn@paasikivi.fi.intel.com>
References: <fab4b7e40757bd966d5f94a6f1845897366fd048.1523975132.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fab4b7e40757bd966d5f94a6f1845897366fd048.1523975132.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Apr 17, 2018 at 10:25:37AM -0400, Mauro Carvalho Chehab wrote:
> Making the cast right for get_user/put_user is not trivial, as
> it needs to ensure that the types are the correct ones.
> 
> Improve it by using macros.
> 
> Tested with vivid with:
> 	$ sudo modprobe vivid no_error_inj=1
> 	$ v4l2-compliance-32bits -a -s10 >32bits && v4l2-compliance-64bits -a -s10 > 64bits && diff -U0 32bits 64bits
> 	--- 32bits	2018-04-17 11:18:29.141240772 -0300
> 	+++ 64bits	2018-04-17 11:18:40.635282341 -0300
> 	@@ -1 +1 @@
> 	-v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce, 32 bits
> 	+v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce, 64 bits
> 
> Using the latest version of v4l-utils with this patch applied:
> 	https://patchwork.linuxtv.org/patch/48746/
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 40 ++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 8c05dd9660d3..d2f0268427c2 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -30,6 +30,24 @@
>  	get_user(__assign_tmp, from) || put_user(__assign_tmp, to);	\
>  })
>  
> +#define get_user_cast(__x, __ptr)					\
> +({									\
> +	get_user(__x, (typeof(*__ptr) __user *)(__ptr));		\
> +})
> +
> +#define put_user_force(__x, __ptr)					\
> +({									\
> +	put_user((typeof(*__x) __force *)(__x), __ptr);			\
> +})
> +
> +#define assign_in_user_cast(to, from)					\
> +({									\
> +	typeof(*from) __assign_tmp;					\
> +									\
> +	get_user_cast(__assign_tmp, from) || put_user(__assign_tmp, to);\
> +})

I must say I like the approach. This makes it harder to get things wrong as
the compiler still does type checking.

About the naming --- I understand the postfix comes from the modifier used
in the put_user case but in the others the same approach would lead to
names such as get_user_user() which would look a bit confusing.

I presume the patch depends on another patch from you. Hans had comments on
that one that I think affect this one as well; could you add this one to
the same patchset?

> +
> +
>  static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	long ret = -ENOIOCTLCMD;
> @@ -543,8 +561,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *p64,
>  			return -EFAULT;
>  
>  		uplane = aux_buf;
> -		if (put_user((__force struct v4l2_plane *)uplane,
> -			     &p64->m.planes))
> +		if (put_user_force(uplane, &p64->m.planes))
>  			return -EFAULT;
>  
>  		while (num_planes--) {
> @@ -682,7 +699,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *p64,
>  
>  	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
>  	    get_user(tmp, &p32->base) ||
> -	    put_user((void __force *)compat_ptr(tmp), &p64->base) ||
> +	    put_user_force(compat_ptr(tmp), &p64->base) ||
>  	    assign_in_user(&p64->capability, &p32->capability) ||
>  	    assign_in_user(&p64->flags, &p32->flags) ||
>  	    copy_in_user(&p64->fmt, &p32->fmt, sizeof(p64->fmt)))
> @@ -831,8 +848,7 @@ static int get_v4l2_ext_controls32(struct file *file,
>  	if (aux_space < count * sizeof(*kcontrols))
>  		return -EFAULT;
>  	kcontrols = aux_buf;
> -	if (put_user((__force struct v4l2_ext_control *)kcontrols,
> -		     &p64->controls))
> +	if (put_user_force(kcontrols, &p64->controls))
>  		return -EFAULT;
>  
>  	for (n = 0; n < count; n++) {
> @@ -898,12 +914,11 @@ static int put_v4l2_ext_controls32(struct file *file,
>  		unsigned int size = sizeof(*ucontrols);
>  		u32 id;
>  
> -		if (get_user(id, (unsigned int __user *)&kcontrols->id) ||
> +		if (get_user_cast(id, &kcontrols->id) ||
>  		    put_user(id, &ucontrols->id) ||
> -		    assign_in_user(&ucontrols->size,
> -				   (unsigned int __user *)&kcontrols->size) ||
> +		    assign_in_user_cast(&ucontrols->size, &kcontrols->size) ||
>  		    copy_in_user(&ucontrols->reserved2,
> -				 (unsigned int __user *)&kcontrols->reserved2,
> +				 (void __user *)&kcontrols->reserved2,
>  				 sizeof(ucontrols->reserved2)))
>  			return -EFAULT;
>  
> @@ -916,7 +931,7 @@ static int put_v4l2_ext_controls32(struct file *file,
>  			size -= sizeof(ucontrols->value64);
>  
>  		if (copy_in_user(ucontrols,
> -			         (unsigned int __user *)kcontrols, size))
> +			         (void __user *)kcontrols, size))
>  			return -EFAULT;
>  
>  		ucontrols++;
> @@ -970,10 +985,9 @@ static int get_v4l2_edid32(struct v4l2_edid __user *p64,
>  	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
>  	    assign_in_user(&p64->pad, &p32->pad) ||
>  	    assign_in_user(&p64->start_block, &p32->start_block) ||
> -	    assign_in_user(&p64->blocks,
> -			   (unsigned char __user *)&p32->blocks) ||
> +	    assign_in_user_cast(&p64->blocks, &p32->blocks) ||
>  	    get_user(tmp, &p32->edid) ||
> -	    put_user((void __force *)compat_ptr(tmp), &p64->edid) ||
> +	    put_user_force(compat_ptr(tmp), &p64->edid) ||
>  	    copy_in_user(p64->reserved, p32->reserved, sizeof(p64->reserved)))
>  		return -EFAULT;
>  	return 0;
> -- 
> 2.14.3
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
