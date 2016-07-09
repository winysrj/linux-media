Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38791 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbcGITr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 15:47:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v2 4/5] media: Add flags to tell whether to take graph mutex for an IOCTL
Date: Sat, 09 Jul 2016 22:47:27 +0300
Message-ID: <489373310.0knWWKXo7K@avalon>
In-Reply-To: <1462360855-23354-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com> <1462360855-23354-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday 04 May 2016 14:20:54 Sakari Ailus wrote:
> New IOCTLs (especially for the request API) do not necessarily need the
> graph mutex acquired. Leave this up to the drivers.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 47 +++++++++++++++++++++++-----------------
>  1 file changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 39fe07f..8aef5b8 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -390,21 +390,26 @@ static long copy_arg_to_user_nop(void __user *uarg,
> void *karg, }
>  #endif
> 
> -#define MEDIA_IOC_ARG(__cmd, func, from_user, to_user)	\
> -	[_IOC_NR(MEDIA_IOC_##__cmd)] = {		\
> -		.cmd = MEDIA_IOC_##__cmd,		\
> +/* Do acquire the graph mutex */
> +#define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
> +
> +#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> +	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
> +		.cmd = MEDIA_IOC_##__cmd,				\
>  		.fn = (long (*)(struct media_device *, void *))func,	\
> -		.arg_from_user = from_user,		\
> -		.arg_to_user = to_user,			\
> +		.flags = fl,						\
> +		.arg_from_user = from_user,				\
> +		.arg_to_user = to_user,					\
>  	}
> 
> -#define MEDIA_IOC(__cmd, func)						
\
> -	MEDIA_IOC_ARG(__cmd, func, copy_arg_from_user, copy_arg_to_user)
> +#define MEDIA_IOC(__cmd, func, fl)					\
> +	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
> 
>  /* the table is indexed by _IOC_NR(cmd) */
>  struct media_ioctl_info {
>  	unsigned int cmd;
>  	long (*fn)(struct media_device *dev, void *arg);
> +	unsigned short flags;
>  	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int 
cmd);
>  	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
>  };
> @@ -449,9 +454,13 @@ static long __media_device_ioctl(
> 
>  	info->arg_from_user(karg, arg, cmd);
> 
> -	mutex_lock(&dev->graph_mutex);
> +	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
> +		mutex_lock(&dev->graph_mutex);
> +
>  	ret = info->fn(dev, karg);
> -	mutex_unlock(&dev->graph_mutex);
> +
> +	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
> +		mutex_unlock(&dev->graph_mutex);
> 
>  	if (ret)
>  		return ret;
> @@ -460,11 +469,11 @@ static long __media_device_ioctl(
>  }
> 
>  static const struct media_ioctl_info ioctl_info[] = {
> -	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
> -	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
> -	MEDIA_IOC(ENUM_LINKS, media_device_enum_links),
> -	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
> -	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
> +	MEDIA_IOC(DEVICE_INFO, media_device_get_info,
> MEDIA_IOC_FL_GRAPH_MUTEX),

do we really need to acquire the graph mutex for this ioctl ?

> +	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities,
> MEDIA_IOC_FL_GRAPH_MUTEX), +	MEDIA_IOC(ENUM_LINKS, media_device_enum_links,
> MEDIA_IOC_FL_GRAPH_MUTEX), +	MEDIA_IOC(SETUP_LINK, media_device_setup_link,
> MEDIA_IOC_FL_GRAPH_MUTEX), +	MEDIA_IOC(G_TOPOLOGY,
> media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX), };
> 
>  static long media_device_ioctl(struct file *filp, unsigned int cmd,
> @@ -510,11 +519,11 @@ static long from_user_enum_links32(void *karg, void
> __user *uarg, #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, 
struct
> media_links_enum32)
> 
>  static const struct media_ioctl_info compat_ioctl_info[] = {
> -	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
> -	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
> -	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links,
> from_user_enum_links32, copy_arg_to_user_nop), -	MEDIA_IOC(SETUP_LINK,
> media_device_setup_link),
> -	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
> +	MEDIA_IOC(DEVICE_INFO, media_device_get_info, 
MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities,
> MEDIA_IOC_FL_GRAPH_MUTEX), +	MEDIA_IOC_ARG(ENUM_LINKS32,
> media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32,
> copy_arg_to_user_nop), +	MEDIA_IOC(SETUP_LINK, media_device_setup_link,
> MEDIA_IOC_FL_GRAPH_MUTEX), +	MEDIA_IOC(G_TOPOLOGY,
> media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX), };
> 
>  static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,

-- 
Regards,

Laurent Pinchart

