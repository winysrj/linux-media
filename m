Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:21617 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754619AbeDTLvY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 07:51:24 -0400
Subject: Re: [PATCH v2 4/4] media: v4l2-compat-ioctl32: better document the
 code
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>
References: <cover.1524155425.git.mchehab@s-opensource.com>
 <1735b780a4d8a2dd39249ae2b1926a364a208e7c.1524155425.git.mchehab@s-opensource.com>
 <e205ad55-feee-f532-58cb-fde56e59aad9@xs4all.nl>
 <20180420084455.29fb4a17@vento.lan>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <01d1e78d-f919-3749-94b3-321f4584d80e@cisco.com>
Date: Fri, 20 Apr 2018 13:51:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180420084455.29fb4a17@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/20/18 13:44, Mauro Carvalho Chehab wrote:
> Em Fri, 20 Apr 2018 13:16:00 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> Thanks for the review!
> 
>>> +/**
>>> + * do_video_ioctl() - Ancillary function with handles a compat32 ioctl call
>>> + *
>>> + * @file: pointer to &struct file with the file handler
>>> + * @cmd: ioctl to be called
>>> + * @arg: arguments passed from/to the ioctl handler
>>> + *
>>> + * This function is called when a 32 bits application calls a V4L2 ioctl
>>> + * and the Kernel is compiled with 64 bits.  
>>
>> Kernel -> kernel
> 
> Actually, in this case, "the Kernel" is referring to the "Linux Kernel",
> with is a particular, unique kernel. So, it should be on uppercase.

I'm fairly certain that's not how it works, but a native speaker should
pitch in on this. Anyway, it's not important :-)

Regards,

	Hans

> 
> The remaining notes are OK. I'm enclosing the following diff and
> resending this patch with it folded in a few.
> 
> Thanks,
> Mauro
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index c460fbcbc035..9611c3aae8ca 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -26,7 +26,7 @@
>   * assign_in_user() - Copy from one __user var to another one
>   *
>   * @to: __user var where data will be stored
> - * @from: __user var were data will be retrieved.
> + * @from: __user var where data will be retrieved.
>   *
>   * As this code very often needs to allocate userspace memory, it is easier
>   * to have a macro that will do both get_user() and put_user() at once.
> @@ -46,12 +46,12 @@
>   *		pointer with userspace data that is not tagged with __user.
>   *
>   * @__x: var where data will be stored
> - * @__ptr: var were data will be retrieved.
> + * @__ptr: var where data will be retrieved.
>   *
> - * Sometimes, we need to declare a pointer without __user, because it
> + * Sometimes we need to declare a pointer without __user because it
>   * comes from a pointer struct field that will be retrieved from userspace
>   * by the 64-bit native ioctl handler. This function ensures that the
> - * @__ptr will be casted to __user before calling get_user(), in order to
> + * @__ptr will be cast to __user before calling get_user() in order to
>   * avoid warnings with static code analyzers like smatch.
>   */
>  #define get_user_cast(__x, __ptr)					\
> @@ -60,16 +60,15 @@
>  })
>  
>  /**
> - * put_user_force() - Stores at the contents of a kernelspace local var
> + * put_user_force() - Stores the contents of a kernelspace local var
>   *		      into an userspace pointer, removing any __user cast.
>   *
>   * @__x: var where data will be stored
> - * @__ptr: var were data will be retrieved.
> + * @__ptr: var where data will be retrieved.
>   *
> - * As the compat32 code now handles with 32-bits and 64-bits __user
> - * structs, sometimes we need to remove the __user atributes from some data,
> - * by passing __force macro. This function ensures that the
> - * @__ptr will be casted with __force before calling put_user(), in order to
> + * Sometimes we need to remove the __user attribute from some data,
> + * by passing the __force macro. This function ensures that the
> + * @__ptr will be cast with __force before calling put_user(), in order to
>   * avoid warnings with static code analyzers like smatch.
>   */
>  #define put_user_force(__x, __ptr)					\
> @@ -81,7 +80,7 @@
>   * assign_in_user_cast() - Copy from one __user var to another one
>   *
>   * @to: __user var where data will be stored
> - * @from: var were data will be retrieved that needs to be cast to __user.
> + * @from: var where data will be retrieved that needs to be cast to __user.
>   *
>   * As this code very often needs to allocate userspace memory, it is easier
>   * to have a macro that will do both get_user_cast() and put_user() at once.
> @@ -1086,11 +1085,11 @@ static int put_v4l2_edid32(struct v4l2_edid __user *p64,
>  }
>  
>  /*
> - * List of ioctl's that require 32-bits/64-bits conversion
> + * List of ioctls that require 32-bits/64-bits conversion
>   *
>   * The V4L2 ioctls that aren't listed there don't have pointer arguments
>   * and the struct size is identical for both 32 and 64 bits versions, so
> - * don't need translations.
> + * they don't need translations.
>   */
>  
>  #define VIDIOC_G_FMT32		_IOWR('V',  4, struct v4l2_format32)
> @@ -1125,8 +1124,8 @@ static int put_v4l2_edid32(struct v4l2_edid __user *p64,
>   *	for calling the native 64-bits version of an ioctl.
>   *
>   * @size:	size of the structure itself to be allocated.
> - * @aux_space:	extra size needed to store "extra" data, e. g. space for
> - *		other __user data that comes pointed by fields inside the
> + * @aux_space:	extra size needed to store "extra" data, e.g. space for
> + *		other __user data that is pointed to fields inside the
>   *		structure.
>   * @new_p64:	pointer to a pointer to be filled with the allocated struct.
>   *
> @@ -1160,7 +1159,7 @@ static int alloc_userspace(unsigned int size, u32 aux_space,
>   * not private to some specific driver.
>   *
>   * It converts a 32-bits struct into a 64 bits one, calls the native 64-bits
> - * ioctl handles and fills back the 32-bits struct with the results of the
> + * ioctl handler and fills back the 32-bits struct with the results of the
>   * native call.
>   */
>  static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> @@ -1437,8 +1436,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>   * in order to deal with 32-bit calls on a 64-bits Kernel.
>   *
>   * This function calls do_video_ioctl() for non-private V4L2 ioctls.
> - * If the function is a private one, it calls, instead,
> - * vdev->fops->compat_ioctl32.
> + * If the function is a private one it calls vdev->fops->compat_ioctl32
> + * instead.
>   */
>  long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> 
