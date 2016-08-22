Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54297 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752401AbcHVMZE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:25:04 -0400
Subject: Re: [RFC v2 11/17] media: Add release callback for media device
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-12-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <38c5a57a-04ce-1109-ce73-1ba23e3cb1cb@xs4all.nl>
Date: Mon, 22 Aug 2016 14:24:59 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-12-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> The release callback may be used by the driver to signal the release of
> the media device. This makes it possible to embed a driver private struct
> to the same memory allocation.

This is a bit weird: you either add support for private data with a priv
pointer as in the previous patch, or you allow for larger structs.

Doing both doesn't seem right. In both cases you want the release callback,
so that's fine. But I think you should pick which method you want to keep
private data around.

I have a slight preference for a priv pointer, but I'm OK with either solution.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 11 ++++++++++-
>  include/media/media-device.h |  8 +++++++-
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 27d5214..7f90cb82 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -552,6 +552,9 @@ static void media_device_release(struct media_devnode *devnode)
>  	mutex_destroy(&mdev->graph_mutex);
>  	dev_dbg(devnode->parent, "Media device released\n");
>  
> +	if (mdev->release)
> +		mdev->release(mdev);
> +
>  	kfree(mdev);
>  }
>  
> @@ -699,10 +702,16 @@ void media_device_init(struct media_device *mdev)
>  }
>  EXPORT_SYMBOL_GPL(media_device_init);
>  
> -struct media_device *media_device_alloc(struct device *dev, void *priv)
> +struct media_device *media_device_alloc(struct device *dev, void *priv,
> +					size_t size)
>  {
>  	struct media_device *mdev;
>  
> +	if (!size)
> +		size = sizeof(*mdev);
> +	else if (WARN_ON(size < sizeof(*mdev)))
> +		return NULL;
> +
>  	dev = get_device(dev);
>  	if (!dev)
>  		return NULL;
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index cfcec1b..3b66232 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -152,6 +152,7 @@ struct media_device {
>  
>  	int (*link_notify)(struct media_link *link, u32 flags,
>  			   unsigned int notification);
> +	void (*release)(struct media_device *mdev);
>  };
>  
>  /* We don't need to include pci.h or usb.h here */
> @@ -203,15 +204,20 @@ void media_device_init(struct media_device *mdev);
>   *
>   * @dev:	The associated struct device pointer
>   * @priv:	pointer to a driver private data structure
> + * @size:	size of a driver structure containing the media device
>   *
>   * Allocate and initialise a media device. Returns a media device.
>   * The media device is refcounted, and this function returns a media
>   * device the refcount of which is one (1).
>   *
> + * The size parameter can be zero if the media_device is not embedded
> + * in another struct.
> + *
>   * References are taken and given using media_device_get() and
>   * media_device_put().
>   */
> -struct media_device *media_device_alloc(struct device *dev, void *priv);
> +struct media_device *media_device_alloc(struct device *dev, void *priv,
> +					size_t size);
>  
>  /**
>   * media_device_get() - Get a reference to a media device
> 
