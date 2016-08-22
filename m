Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43533 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751168AbcHVM00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:26:26 -0400
Subject: Re: [RFC v2 12/17] v4l: Acquire a reference to the media device for
 every video device
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-13-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e737280e-95b0-af13-27d1-cb8207d3da02@xs4all.nl>
Date: Mon, 22 Aug 2016 14:25:25 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-13-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> The video device depends on the existence of its media device --- if there
> is one. Acquire a reference to it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index e6da353..cda04ff 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -171,6 +171,9 @@ static void v4l2_device_release(struct device *cd)
>  {
>  	struct video_device *vdev = to_video_device(cd);
>  	struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_device *mdev = v4l2_dev->mdev;
> +#endif
>  
>  	mutex_lock(&videodev_lock);
>  	if (WARN_ON(video_device[vdev->minor] != vdev)) {
> @@ -193,8 +196,8 @@ static void v4l2_device_release(struct device *cd)
>  
>  	mutex_unlock(&videodev_lock);
>  
> -#if defined(CONFIG_MEDIA_CONTROLLER)
> -	if (v4l2_dev->mdev) {
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	if (mdev) {
>  		/* Remove interfaces and interface links */
>  		media_devnode_remove(vdev->intf_devnode);
>  		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
> @@ -220,6 +223,11 @@ static void v4l2_device_release(struct device *cd)
>  	/* Decrease v4l2_device refcount */
>  	if (v4l2_dev)
>  		v4l2_device_put(v4l2_dev);
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	if (mdev)
> +		media_device_put(mdev);
> +#endif
>  }
>  
>  static struct class video_class = {
> @@ -808,6 +816,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  
>  	/* FIXME: how to create the other interface links? */
>  
> +	media_device_get(vdev->v4l2_dev->mdev);
>  #endif
>  	return 0;
>  }
> 
