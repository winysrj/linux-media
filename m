Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49179 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750892AbcHVMFN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:05:13 -0400
Subject: Re: [RFC v2 07/17] media: Split initialisation and adding device
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-8-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3f658f69-e1c7-4f50-f656-d602e4e979f4@xs4all.nl>
Date: Mon, 22 Aug 2016 14:05:07 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-8-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> As registering a device node of an entity belonging to a media device
> will require a reference to the struct device. Taking that reference is
> only possible once the device has been initialised, which took place only
> when it was registered. Split this in two, and initialise the device when
> the media device is allocated.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/media-device.c          |  1 +
>  drivers/media/media-devnode.c         | 15 ++++++++++-----
>  drivers/media/platform/omap3isp/isp.c |  4 +++-
>  include/media/media-devnode.h         | 15 +++++++++++----
>  4 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 5a86d36..d527491 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -707,6 +707,7 @@ struct media_device *media_device_alloc(void)
>  	if (!mdev)
>  		return NULL;
>  
> +	media_devnode_init(&mdev->devnode);
>  	media_device_init(mdev);
>  
>  	return mdev;
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index 7481c96..aa8030b 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -219,6 +219,11 @@ static const struct file_operations media_devnode_fops = {
>  	.llseek = no_llseek,
>  };
>  
> +void media_devnode_init(struct media_devnode *devnode)
> +{
> +	device_initialize(&devnode->dev);
> +}
> +
>  int __must_check media_devnode_register(struct media_devnode *devnode,
>  					struct module *owner)
>  {
> @@ -256,7 +261,7 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
>  	if (devnode->parent)
>  		devnode->dev.parent = devnode->parent;
>  	dev_set_name(&devnode->dev, "media%d", devnode->minor);
> -	ret = device_register(&devnode->dev);
> +	ret = device_add(&devnode->dev);
>  	if (ret < 0) {
>  		pr_err("%s: device_register failed\n", __func__);
>  		goto error;
> @@ -291,7 +296,7 @@ void media_devnode_unregister(struct media_devnode *devnode)
>  /*
>   *	Initialise media for linux
>   */
> -static int __init media_devnode_init(void)
> +static int __init media_devnode_module_init(void)
>  {
>  	int ret;
>  
> @@ -313,14 +318,14 @@ static int __init media_devnode_init(void)
>  	return 0;
>  }
>  
> -static void __exit media_devnode_exit(void)
> +static void __exit media_devnode_module_exit(void)
>  {
>  	bus_unregister(&media_bus_type);
>  	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
>  }
>  
> -subsys_initcall(media_devnode_init);
> -module_exit(media_devnode_exit)
> +subsys_initcall(media_devnode_module_init);
> +module_exit(media_devnode_module_exit)
>  
>  MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
>  MODULE_DESCRIPTION("Device node registration for media drivers");
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 5d54e2c..aa32537 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1726,8 +1726,10 @@ static int isp_register_entities(struct isp_device *isp)
>  		goto done;
>  
>  done:
> -	if (ret < 0)
> +	if (ret < 0) {
>  		isp_unregister_entities(isp);
> +		media_device_put(&isp->media_dev);
> +	}
>  
>  	return ret;
>  }
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index a0f6823..5253a4b 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -102,6 +102,17 @@ struct media_devnode {
>  #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
>  
>  /**
> + * media_devnode_init - initialise a media devnode
> + *
> + * @devnode: struct media_devnode we want to initialise
> + *
> + * Initialise a media devnode. Note that after initialising the media
> + * devnode is refcounted. Releaseing references to it may be done
> + * using put_device.
> + */
> +void media_devnode_init(struct media_devnode *devnode);
> +
> +/**
>   * media_devnode_register - register a media device node
>   *
>   * @devnode: struct media_devnode we want to register a device node
> @@ -112,10 +123,6 @@ struct media_devnode {
>   * or if the registration of the device node fails.
>   *
>   * Zero is returned on success.
> - *
> - * Note that if the media_devnode_register call fails, the release() callback of
> - * the media_devnode structure is *not* called, so the caller is responsible for
> - * freeing any data.
>   */
>  int __must_check media_devnode_register(struct media_devnode *devnode,
>  					struct module *owner);
> 
