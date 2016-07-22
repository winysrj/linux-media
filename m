Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57030 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333AbcGVK2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 06:28:21 -0400
Subject: Re: [PATCH v3 2/5] media: Unify IOCTL handler calling
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1469099686-10938-1-git-send-email-sakari.ailus@linux.intel.com>
 <1469099686-10938-3-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6a69db28-5217-3d60-9d10-1387353c60fd@xs4all.nl>
Date: Fri, 22 Jul 2016 12:28:15 +0200
MIME-Version: 1.0
In-Reply-To: <1469099686-10938-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/21/2016 01:14 PM, Sakari Ailus wrote:
> Each IOCTL handler can be listed in an array instead of using a large and
> cumbersome switch. Do that.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/media-device.c | 81 +++++++++++++-------------------------------
>  1 file changed, 23 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 3ac526d..6fd9b77 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -419,12 +419,16 @@ static long media_device_get_topology(struct media_device *mdev,
>  	return 0;
>  }
>  
> -#define MEDIA_IOC(__cmd) \
> -	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
> +#define MEDIA_IOC(__cmd, func)						\
> +	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
> +		.cmd = MEDIA_IOC_##__cmd,				\
> +		.fn = (long (*)(struct media_device *, void __user *))func,    \
> +	}
>  
>  /* the table is indexed by _IOC_NR(cmd) */
>  struct media_ioctl_info {
>  	unsigned int cmd;
> +	long (*fn)(struct media_device *dev, void __user *arg);
>  };
>  
>  static inline long is_valid_ioctl(const struct media_ioctl_info *info,
> @@ -440,53 +444,28 @@ static long __media_device_ioctl(
>  {
>  	struct media_devnode *devnode = media_devnode_data(filp);
>  	struct media_device *dev = devnode->media_dev;
> +	const struct media_ioctl_info *info;
>  	long ret;
>  
>  	ret = is_valid_ioctl(info_array, info_array_len, cmd);
>  	if (ret)
>  		return ret;
>  
> +	info = &info_array[_IOC_NR(cmd)];
> +
>  	mutex_lock(&dev->graph_mutex);
> -	switch (cmd) {
> -	case MEDIA_IOC_DEVICE_INFO:
> -		ret = media_device_get_info(dev,
> -				(struct media_device_info __user *)arg);
> -		break;
> -
> -	case MEDIA_IOC_ENUM_ENTITIES:
> -		ret = media_device_enum_entities(dev,
> -				(struct media_entity_desc __user *)arg);
> -		break;
> -
> -	case MEDIA_IOC_ENUM_LINKS:
> -		ret = media_device_enum_links(dev,
> -				(struct media_links_enum __user *)arg);
> -		break;
> -
> -	case MEDIA_IOC_SETUP_LINK:
> -		ret = media_device_setup_link(dev,
> -				(struct media_link_desc __user *)arg);
> -		break;
> -
> -	case MEDIA_IOC_G_TOPOLOGY:
> -		ret = media_device_get_topology(dev,
> -				(struct media_v2_topology __user *)arg);
> -		break;
> -
> -	default:
> -		ret = -ENOIOCTLCMD;
> -	}
> +	ret = info->fn(dev, arg);
>  	mutex_unlock(&dev->graph_mutex);
>  
>  	return ret;
>  }
>  
>  static const struct media_ioctl_info ioctl_info[] = {
> -	MEDIA_IOC(DEVICE_INFO),
> -	MEDIA_IOC(ENUM_ENTITIES),
> -	MEDIA_IOC(ENUM_LINKS),
> -	MEDIA_IOC(SETUP_LINK),
> -	MEDIA_IOC(G_TOPOLOGY),
> +	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
> +	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
> +	MEDIA_IOC(ENUM_LINKS, media_device_enum_links),
> +	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
> +	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
>  };
>  
>  static long media_device_ioctl(struct file *filp, unsigned int cmd,
> @@ -528,33 +507,19 @@ static long media_device_enum_links32(struct media_device *mdev,
>  #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
>  
>  static const struct media_ioctl_info compat_ioctl_info[] = {
> -	MEDIA_IOC(DEVICE_INFO),
> -	MEDIA_IOC(ENUM_ENTITIES),
> -	MEDIA_IOC(ENUM_LINKS32),
> -	MEDIA_IOC(SETUP_LINK),
> -	MEDIA_IOC(G_TOPOLOGY),
> +	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
> +	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
> +	MEDIA_IOC(ENUM_LINKS32, media_device_enum_links32),
> +	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
> +	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
>  };
>  
>  static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
>  				      unsigned long arg)
>  {
> -	struct media_devnode *devnode = media_devnode_data(filp);
> -	struct media_device *dev = devnode->media_dev;
> -	long ret;
> -
> -	switch (cmd) {
> -	case MEDIA_IOC_ENUM_LINKS32:
> -		mutex_lock(&dev->graph_mutex);
> -		ret = media_device_enum_links32(dev,
> -				(struct media_links_enum32 __user *)arg);
> -		mutex_unlock(&dev->graph_mutex);
> -		break;
> -
> -	default:
> -		return media_device_ioctl(filp, cmd, arg);
> -	}
> -
> -	return ret;
> +	return __media_device_ioctl(
> +		filp, cmd, (void __user *)arg,
> +		compat_ioctl_info, ARRAY_SIZE(compat_ioctl_info));
>  }
>  #endif /* CONFIG_COMPAT */
>  
> 
