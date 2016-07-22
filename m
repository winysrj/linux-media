Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:42825 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727AbcGVK2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 06:28:41 -0400
Subject: Re: [PATCH v3 4/5] media: Add flags to tell whether to take graph
 mutex for an IOCTL
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1469099686-10938-1-git-send-email-sakari.ailus@linux.intel.com>
 <1469099851-11026-1-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <24575888-0abf-cc2f-d1c0-8053c9c9fd2c@xs4all.nl>
Date: Fri, 22 Jul 2016 12:28:34 +0200
MIME-Version: 1.0
In-Reply-To: <1469099851-11026-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/21/2016 01:17 PM, Sakari Ailus wrote:
> New IOCTLs (especially for the request API) do not necessarily need the
> graph mutex acquired. Leave this up to the drivers.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/media-device.c | 47 ++++++++++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 87d17a0..6dfcc50 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -381,20 +381,25 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
>  	return 0;
>  }
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
> -#define MEDIA_IOC(__cmd, func)						\
> -	MEDIA_IOC_ARG(__cmd, func, copy_arg_from_user, copy_arg_to_user)
> +#define MEDIA_IOC(__cmd, func, fl)					\
> +	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
>  
>  /* the table is indexed by _IOC_NR(cmd) */
>  struct media_ioctl_info {
>  	unsigned int cmd;
> +	unsigned short flags;
>  	long (*fn)(struct media_device *dev, void *arg);
>  	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
>  	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
> @@ -435,9 +440,13 @@ static long __media_device_ioctl(
>  			goto out_free;
>  	}
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
>  	if (!ret && info->arg_to_user)
>  		ret = info->arg_to_user(arg, karg, cmd);
> @@ -450,11 +459,11 @@ out_free:
>  }
>  
>  static const struct media_ioctl_info ioctl_info[] = {
> -	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
> -	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
> -	MEDIA_IOC(ENUM_LINKS, media_device_enum_links),
> -	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
> -	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
> +	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
>  };
>  
>  static long media_device_ioctl(struct file *filp, unsigned int cmd,
> @@ -497,11 +506,11 @@ static long from_user_enum_links32(void *karg, void __user *uarg,
>  #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
>  
>  static const struct media_ioctl_info compat_ioctl_info[] = {
> -	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
> -	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
> -	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, from_user_enum_links32, NULL),
> -	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
> -	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
> +	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32, NULL),
> +	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
>  };
>  
>  static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
> 
