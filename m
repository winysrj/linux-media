Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60709 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754577AbcHVMBv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:01:51 -0400
Subject: Re: [RFC v2 06/17] media: Dynamically allocate the media device
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-7-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b9aefadd-054e-bece-da6b-4f599d5173a2@xs4all.nl>
Date: Mon, 22 Aug 2016 14:01:44 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-7-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Allow allocating the media device dynamically. As the struct media_device
> embeds struct media_devnode, the lifetime of that object is that same than
> that of the media_device.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 22 ++++++++++++++++++++++
>  include/media/media-device.h | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index a431775..5a86d36 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -544,7 +544,15 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
>  
>  static void media_device_release(struct media_devnode *devnode)
>  {
> +	struct media_device *mdev = to_media_device(devnode);
> +
> +	ida_destroy(&mdev->entity_internal_idx);
> +	mdev->entity_internal_idx_max = 0;
> +	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
> +	mutex_destroy(&mdev->graph_mutex);
>  	dev_dbg(devnode->parent, "Media device released\n");
> +
> +	kfree(mdev);

Doesn't this break bisect? mdev is now freed, but media_device_alloc isn't
called yet.

That doesn't seem right.

Regards,

	Hans

>  }
>  
>  /**
> @@ -691,6 +699,20 @@ void media_device_init(struct media_device *mdev)
>  }
>  EXPORT_SYMBOL_GPL(media_device_init);
>  
> +struct media_device *media_device_alloc(void)
> +{
> +	struct media_device *mdev;
> +
> +	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> +	if (!mdev)
> +		return NULL;
> +
> +	media_device_init(mdev);
> +
> +	return mdev;
> +}
> +EXPORT_SYMBOL_GPL(media_device_alloc);
> +
>  void media_device_cleanup(struct media_device *mdev)
>  {
>  	ida_destroy(&mdev->entity_internal_idx);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 4eee613..d1d45ab 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -197,6 +197,42 @@ static inline __must_check int media_entity_enum_init(
>  void media_device_init(struct media_device *mdev);
>  
>  /**
> + * media_device_alloc() - Allocate and initialise a media device
> + *
> + * Allocate and initialise a media device. Returns a media device.
> + * The media device is refcounted, and this function returns a media
> + * device the refcount of which is one (1).
> + *
> + * References are taken and given using media_device_get() and
> + * media_device_put().
> + */
> +struct media_device *media_device_alloc(void);
> +
> +/**
> + * media_device_get() - Get a reference to a media device
> + *
> + * mdev: media device
> + */
> +#define media_device_get(mdev)						\
> +	do {								\
> +		dev_dbg((mdev)->dev, "%s: get media device %s\n",	\
> +			__func__, (mdev)->bus_info);			\
> +		get_device(&(mdev)->devnode.dev);			\
> +	} while (0)
> +
> +/**
> + * media_device_put() - Put a reference to a media device
> + *
> + * mdev: media device
> + */
> +#define media_device_put(mdev)						\
> +	do {								\
> +		dev_dbg((mdev)->dev, "%s: put media device %s\n",	\
> +			__func__, (mdev)->bus_info);			\
> +		put_device(&(mdev)->devnode.dev);			\
> +	} while (0)
> +
> +/**
>   * media_device_cleanup() - Cleanups a media device element
>   *
>   * @mdev:	pointer to struct &media_device
> @@ -425,6 +461,8 @@ void __media_device_usb_init(struct media_device *mdev,
>  			     const char *driver_name);
>  
>  #else
> +#define media_device_get(mdev) do { } while (0)
> +#define media_device_put(mdev) do { } while (0)
>  static inline int media_device_register(struct media_device *mdev)
>  {
>  	return 0;
> 
