Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:46376 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754549AbeDTLQF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 07:16:05 -0400
Subject: Re: [PATCH v2 4/4] media: v4l2-compat-ioctl32: better document the
 code
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>
References: <cover.1524155425.git.mchehab@s-opensource.com>
 <1735b780a4d8a2dd39249ae2b1926a364a208e7c.1524155425.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e205ad55-feee-f532-58cb-fde56e59aad9@xs4all.nl>
Date: Fri, 20 Apr 2018 13:16:00 +0200
MIME-Version: 1.0
In-Reply-To: <1735b780a4d8a2dd39249ae2b1926a364a208e7c.1524155425.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A bunch of typo, grammar and style fixes below. Looks good otherwise.

On 04/19/18 18:33, Mauro Carvalho Chehab wrote:
> This file does a lot of non-trivial struff. Document it using
> kernel-doc markups where needed and improve the comments inside
> do_video_ioctl().
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 166 +++++++++++++++++++++++++-
>  1 file changed, 160 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index d2f0268427c2..777ed179af5f 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -22,7 +22,18 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-ioctl.h>
>  
> -/* Use the same argument order as copy_in_user */
> +/**
> + * assign_in_user() - Copy from one __user var to another one
> + *
> + * @to: __user var where data will be stored
> + * @from: __user var were data will be retrieved.

were -> where

> + *
> + * As this code very often needs to allocate userspace memory, it is easier
> + * to have a macro that will do both get_user() and put_user() at once.
> + *
> + * This function complements the macros defined at asm-generic/uaccess.h.
> + * It uses the same argument order as copy_in_user()
> + */
>  #define assign_in_user(to, from)					\
>  ({									\
>  	typeof(*from) __assign_tmp;					\
> @@ -30,16 +41,57 @@
>  	get_user(__assign_tmp, from) || put_user(__assign_tmp, to);	\
>  })
>  
> +/**
> + * get_user_cast() - Stores at a kernelspace local var the contents from a
> + *		pointer with userspace data that is not tagged with __user.
> + *
> + * @__x: var where data will be stored
> + * @ptr: var were data will be retrieved.

were -> where

> + *
> + * Sometimes, we need to declare a pointer without __user, because it

The two commas in this sentence can be dropped.

> + * comes from a pointer struct field that will be retrieved from userspace
> + * by the 64-bit native ioctl handler. This function ensures that the
> + * @ptr will be casted to __user before calling get_user(), in order to

casted -> cast

The comma can be dropped.

> + * avoid warnings with static code analyzers like smatch.
> + */
>  #define get_user_cast(__x, __ptr)					\
>  ({									\
>  	get_user(__x, (typeof(*__ptr) __user *)(__ptr));		\
>  })
>  
> +/**
> + * put_user_force() - Stores at the contents of a kernelspace local var

s/at//

> + *		      into an userspace pointer, removing any __user cast.
> + *
> + * @__x: var where data will be stored
> + * @ptr: var were data will be retrieved.

were -> where

> + *
> + * As the compat32 code now handles with 32-bits and 64-bits __user

I don't understand this first line. Perhaps this line up to the comma
below should just be dropped? And instead start with 'Sometimes we need to...'.

> + * structs, sometimes we need to remove the __user atributes from some data,

atributes -> attribute

> + * by passing __force macro. This function ensures that the

'by passing the __force macro'

> + * @ptr will be casted with __force before calling put_user(), in order to

casted -> cast

> + * avoid warnings with static code analyzers like smatch.
> + */
>  #define put_user_force(__x, __ptr)					\
>  ({									\
>  	put_user((typeof(*__x) __force *)(__x), __ptr);			\
>  })
>  
> +/**
> + * assign_in_user_cast() - Copy from one __user var to another one
> + *
> + * @to: __user var where data will be stored
> + * @from: var were data will be retrieved that needs to be cast to __user.

were -> where

> + *
> + * As this code very often needs to allocate userspace memory, it is easier
> + * to have a macro that will do both get_user_cast() and put_user() at once.
> + *
> + * This function should be used instead of assign_in_user() when the @from
> + * variable was not declared as __user. See get_user_cast() for more details.
> + *
> + * This function complements the macros defined at asm-generic/uaccess.h.
> + * It uses the same argument order as copy_in_user()
> + */
>  #define assign_in_user_cast(to, from)					\
>  ({									\
>  	typeof(*from) __assign_tmp;					\
> @@ -47,7 +99,16 @@
>  	get_user_cast(__assign_tmp, from) || put_user(__assign_tmp, to);\
>  })
>  
> -
> +/**
> + * native_ioctl - Ancillary function that calls the native 64 bits ioctl
> + * handler.
> + *
> + * @file: pointer to &struct file with the file handler
> + * @cmd: ioctl to be called
> + * @arg: arguments passed from/to the ioctl handler
> + *
> + * This function calls the native ioctl handler at v4l2-dev, e. g. v4l2_ioctl()
> + */
>  static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	long ret = -ENOIOCTLCMD;
> @@ -59,6 +120,21 @@ static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  }
>  
>  
> +/*
> + * Per-ioctl data copy handlers.
> + *
> + * Those come in pairs, with a get_v4l2_foo() and a put_v4l2_foo() routine,
> + * where "v4l2_foo" is the name of the V4L2 struct.
> + *
> + * They basically get two __user pointers, one with a 32-bits struct that
> + * came from the userspace call and a 64-bits struct, also allocated as
> + * userspace, but filled internally by do_video_ioctl().
> + *
> + * For ioctls that have pointers inside it, the functions will also
> + * receive an ancillary buffer with extra space, used to pass extra
> + * data to the routine.
> + */
> +
>  struct v4l2_clip32 {
>  	struct v4l2_rect        c;
>  	compat_caddr_t		next;
> @@ -1009,6 +1085,13 @@ static int put_v4l2_edid32(struct v4l2_edid __user *p64,
>  	return 0;
>  }
>  
> +/*
> + * List of ioctl's that require 32-bits/64-bits conversion

ioctl's -> ioctls

> + *
> + * The V4L2 ioctls that aren't listed there don't have pointer arguments
> + * and the struct size is identical for both 32 and 64 bits versions, so
> + * don't need translations.

don't -> they don't

> + */
>  
>  #define VIDIOC_G_FMT32		_IOWR('V',  4, struct v4l2_format32)
>  #define VIDIOC_S_FMT32		_IOWR('V',  5, struct v4l2_format32)
> @@ -1037,6 +1120,21 @@ static int put_v4l2_edid32(struct v4l2_edid __user *p64,
>  #define VIDIOC_G_OUTPUT32	_IOR ('V', 46, s32)
>  #define VIDIOC_S_OUTPUT32	_IOWR('V', 47, s32)
>  
> +/**
> + * alloc_userspace() - Allocates a 64-bits userspace pointer compatible
> + *	for calling the native 64-bits version of an ioctl.
> + *
> + * @size:	size of the structure itself to be allocated.
> + * @aux_space:	extra size needed to store "extra" data, e. g. space for

e. g. -> e.g.

> + *		other __user data that comes pointed by fields inside the

comes pointer -> is pointed to

> + *		structure.
> + * @new_p64:	pointer to a pointer to be filled with the allocated struct.
> + *
> + * Return:
> + *
> + * if it can't allocate memory, either -ENOMEM or -EFAULT will be returned.
> + * Zero otherwise.
> + */
>  static int alloc_userspace(unsigned int size, u32 aux_space,
>  			   void __user **new_p64)
>  {
> @@ -1048,6 +1146,23 @@ static int alloc_userspace(unsigned int size, u32 aux_space,
>  	return 0;
>  }
>  
> +/**
> + * do_video_ioctl() - Ancillary function with handles a compat32 ioctl call
> + *
> + * @file: pointer to &struct file with the file handler
> + * @cmd: ioctl to be called
> + * @arg: arguments passed from/to the ioctl handler
> + *
> + * This function is called when a 32 bits application calls a V4L2 ioctl
> + * and the Kernel is compiled with 64 bits.

Kernel -> kernel

> + *
> + * This function is called by v4l2_compat_ioctl32() when the function is
> + * not private to some specific driver.
> + *
> + * It converts a 32-bits struct into a 64 bits one, calls the native 64-bits
> + * ioctl handles and fills back the 32-bits struct with the results of the

handles -> handler

> + * native call.
> + */
>  static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	void __user *p32 = compat_ptr(arg);
> @@ -1057,7 +1172,9 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	int compatible_arg = 1;
>  	long err = 0;
>  
> -	/* First, convert the command. */
> +	/*
> +	 * 1. When struct size is different, converts the command.
> +	 */
>  	switch (cmd) {
>  	case VIDIOC_G_FMT32: cmd = VIDIOC_G_FMT; break;
>  	case VIDIOC_S_FMT32: cmd = VIDIOC_S_FMT; break;
> @@ -1086,6 +1203,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_S_EDID32: cmd = VIDIOC_S_EDID; break;
>  	}
>  
> +	/*
> +	 * 2. Allocates a 64-bits userspace pointer to store the
> +	 * values of the ioctl and copy data from the 32-bits __user
> +	 * argument into it.
> +	 */
>  	switch (cmd) {
>  	case VIDIOC_OVERLAY:
>  	case VIDIOC_STREAMON:
> @@ -1208,6 +1330,15 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * 3. Calls the native 64-bits ioctl handler.
> +	 *
> +	 * For the functions where a conversion was not needed,
> +	 * compatible_arg is true, and it will call it with the arguments
> +	 * provided by userspace and stored at @p32 var.
> +	 *
> +	 * Otherwise, it will pass the newly allocated @new_p64 argument.
> +	 */
>  	if (compatible_arg)
>  		err = native_ioctl(file, cmd, (unsigned long)p32);
>  	else
> @@ -1217,9 +1348,14 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		return err;
>  
>  	/*
> -	 * Special case: even after an error we need to put the
> -	 * results back for these ioctls since the error_idx will
> -	 * contain information on which control failed.
> +	 * 4. Special case: even after an error we need to put the
> +	 * results back for some ioctls.
> +	 *
> +	 * In the case of EXT_CTRLS, the error_idx will contain information
> +	 * on which control failed.
> +	 *
> +	 * In the case of S_EDID, the driver can return E2BIG and set
> +	 * the blocks to maximum allowed value.
>  	 */
>  	switch (cmd) {
>  	case VIDIOC_G_EXT_CTRLS:
> @@ -1236,6 +1372,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * 5. Copy the data returned at the 64 bits userspace pointer to
> +	 * the original 32 bits structure.
> +	 */
>  	switch (cmd) {
>  	case VIDIOC_S_INPUT:
>  	case VIDIOC_S_OUTPUT:
> @@ -1286,6 +1426,20 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	return err;
>  }
>  
> +/**
> + * v4l2_compat_ioctl32() - Handles a compat32 ioctl call
> + *
> + * @file: pointer to &struct file with the file handler
> + * @cmd: ioctl to be called
> + * @arg: arguments passed from/to the ioctl handler
> + *
> + * This function is meant to be used as .compat_ioctl fops at v4l2-dev.c
> + * in order to deal with 32-bit calls on a 64-bits Kernel.
> + *
> + * This function calls do_video_ioctl() for non-private V4L2 ioctls.
> + * If the function is a private one, it calls, instead,
> + * vdev->fops->compat_ioctl32.

If the function is a private one it calls vdev->fops->compat_ioctl32 instead.

> + */
>  long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct video_device *vdev = video_devdata(file);
> 

Regards,

	Hans
