Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51094 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932388AbcKVJqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 04:46:36 -0500
Subject: Re: [RFC v4 14/21] media device: Get the media device driver's device
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
 <1478613330-24691-14-git-send-email-sakari.ailus@linux.intel.com>
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8ead9627-c333-6808-9aa6-571bff1d93ab@xs4all.nl>
Date: Tue, 22 Nov 2016 10:46:31 +0100
MIME-Version: 1.0
In-Reply-To: <1478613330-24691-14-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/16 14:55, Sakari Ailus wrote:
> The struct device of the media device driver (i.e. not that of the media
> devnode) is pointed to by the media device. The struct device pointer is
> mostly used for debug prints.
>
> Ensure it will stay around as long as the media device does.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 2e52e44..648c64c 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -724,6 +724,7 @@ static void media_device_release(struct media_devnode *devnode)
>  	mdev->entity_internal_idx_max = 0;
>  	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
>  	mutex_destroy(&mdev->graph_mutex);
> +	put_device(mdev->dev);
>
>  	kfree(mdev);
>  }
> @@ -732,9 +733,15 @@ struct media_device *media_device_alloc(struct device *dev)
>  {
>  	struct media_device *mdev;
>
> +	dev = get_device(dev);
> +	if (!dev)
> +		return NULL;

I don't think this is right. When you allocate the media_device struct 
it should
just be initialized, but not have any side effects until it is actually 
registered.

When the device is registered the device_add call will increase the parent's
refcount as it should, thus ensuring it stays around for as long as is 
needed.

Regards,

	Hans

> +
>  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> -	if (!mdev)
> +	if (!mdev) {
> +		put_device(dev);
>  		return NULL;
> +	}
>
>  	mdev->dev = dev;
>  	media_device_init(mdev);
>
