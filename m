Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50759 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbcFQQVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 12:21:12 -0400
Subject: Re: [PATCH v2.1 5/5] media: Support variable size IOCTL arguments
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1462360855-23354-6-git-send-email-sakari.ailus@linux.intel.com>
 <1462403217-4584-1-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57642371.4010400@xs4all.nl>
Date: Fri, 17 Jun 2016 18:21:05 +0200
MIME-Version: 1.0
In-Reply-To: <1462403217-4584-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/05/2016 01:06 AM, Sakari Ailus wrote:
> Instead of checking for a strict size for the IOCTL arguments, place
> minimum and maximum limits.
> 
> As an additional bonus, IOCTL handlers will be able to check whether the
> caller actually set (using the argument size) the field vs. assigning it
> to zero. Separate macro can be provided for that.
> 
> This will be easier for applications as well since there is no longer the
> problem of setting the reserved fields zero, or at least it is a lesser
> problem.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I think it is important to have exact matches instead of using a min-max range.
Issues related to alignment problems on different architectures (32/64 bits,
how padding in struct is handled, etc.) that could cause a different size should
be caught by the validation check. Any size other than this discrete list of
allowed sizes is an indication that something is seriously wrong on the kernel or
userspace side.

If we get ioctls that have a variable-sized array at the end, then that should
be signaled differently in the media_ioctl_info struct. We'll handle that when
that happens.

Regards,

	Hans

> ---
> since v2:
> 
> - Use a list of supported argument sizes instead of a minimum value.
> 
>  drivers/media/media-device.c | 52 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index e88e6d3..5cfeccf 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -393,32 +393,71 @@ static long copy_arg_to_user_nop(void __user *uarg, void *karg,
>  /* Do acquire the graph mutex */
>  #define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
>  
> -#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> +#define MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz, from_user, to_user)	\
>  	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
>  		.cmd = MEDIA_IOC_##__cmd,				\
>  		.fn = (long (*)(struct media_device *, void *))func,	\
>  		.flags = fl,						\
> +		.alt_arg_sizes = alt_sz,				\
>  		.arg_from_user = from_user,				\
>  		.arg_to_user = to_user,					\
>  	}
>  
> -#define MEDIA_IOC(__cmd, func, fl)					\
> -	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
> +#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> +	MEDIA_IOC_SZ_ARG(__cmd, func, fl, NULL, from_user, to_user)
> +
> +#define MEDIA_IOC_SZ(__cmd, func, fl, alt_sz)			\
> +	MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz,		\
> +			 copy_arg_from_user, copy_arg_to_user)
> +
> +#define MEDIA_IOC(__cmd, func, fl)				\
> +	MEDIA_IOC_ARG(__cmd, func, fl,				\
> +		      copy_arg_from_user, copy_arg_to_user)
>  
>  /* the table is indexed by _IOC_NR(cmd) */
>  struct media_ioctl_info {
>  	unsigned int cmd;
>  	long (*fn)(struct media_device *dev, void *arg);
>  	unsigned short flags;
> +	const unsigned short *alt_arg_sizes;
>  	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
>  	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
>  };
>  
> +#define MASK_IOC_SIZE(cmd) \
> +	((cmd) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
> +
>  static inline long is_valid_ioctl(const struct media_ioctl_info *info,
>  				  unsigned int len, unsigned int cmd)
>  {
> -	return (_IOC_NR(cmd) >= len
> -		|| info[_IOC_NR(cmd)].cmd != cmd) ? -ENOIOCTLCMD : 0;
> +	const unsigned short *alt_arg_sizes;
> +
> +	if (unlikely(_IOC_NR(cmd) >= len))
> +		return -ENOIOCTLCMD;
> +
> +	info += _IOC_NR(cmd);
> +
> +	if (info->cmd == cmd)
> +		return 0;
> +
> +	/*
> +	 * Verify that the size-dependent patch of the IOCTL command
> +	 * matches and that the size does not exceed the principal
> +	 * argument size.
> +	 */
> +	if (unlikely(MASK_IOC_SIZE(info->cmd) != MASK_IOC_SIZE(cmd)
> +		     || _IOC_SIZE(info->cmd) < _IOC_SIZE(cmd)))
> +		return -ENOIOCTLCMD;
> +
> +	alt_arg_sizes = info->alt_arg_sizes;
> +	if (unlikely(!alt_arg_sizes))
> +		return -ENOIOCTLCMD;
> +
> +	for (; *alt_arg_sizes; alt_arg_sizes++)
> +		if (_IOC_SIZE(cmd) == *alt_arg_sizes)
> +			return 0;
> +
> +	return -ENOIOCTLCMD;
>  }
>  
>  static long __media_device_ioctl(
> @@ -445,6 +484,9 @@ static long __media_device_ioctl(
>  
>  	info->arg_from_user(karg, arg, cmd);
>  
> +	/* Set the rest of the argument struct to zero */
> +	memset(karg + _IOC_SIZE(cmd), 0, _IOC_SIZE(info->cmd) - _IOC_SIZE(cmd));
> +
>  	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
>  		mutex_lock(&dev->graph_mutex);
>  
> 
