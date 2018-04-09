Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45046 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753599AbeDIVN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 17:13:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Que <sque@chromium.org>
Cc: mchehab@kernel.org, viro@zeniv.linux.org.uk,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] v4l2-core: Rename array 'video_driver' to 'video_drivers'
Date: Tue, 10 Apr 2018 00:13:29 +0300
Message-ID: <3074650.Mf9NpMS9vO@avalon>
In-Reply-To: <20180409194738.186758-1-sque@chromium.org>
References: <20180409194738.186758-1-sque@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thank you for the patch.

On Monday, 9 April 2018 22:47:38 EEST Simon Que wrote:
> Improves code clarity in two ways:
> 1. The plural name makes it more clear that it is an array.
> 2. The name of the array is now no longer identical to the struct type
> name, so it is easier to find in the code.
> 
> Signed-off-by: Simon Que <sque@chromium.org>

I like this and agree with the two reasons you have given.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> b/drivers/media/v4l2-core/v4l2-dev.c index 0301fe426a43..8d5f7cfe1695
> 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -91,7 +91,7 @@ ATTRIBUTE_GROUPS(video_device);
>  /*
>   *	Active devices
>   */
> -static struct video_device *video_device[VIDEO_NUM_DEVICES];
> +static struct video_device *video_devices[VIDEO_NUM_DEVICES];
>  static DEFINE_MUTEX(videodev_lock);
>  static DECLARE_BITMAP(devnode_nums[VFL_TYPE_MAX], VIDEO_NUM_DEVICES);
> 
> @@ -173,14 +173,14 @@ static void v4l2_device_release(struct device *cd)
>  	struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
> 
>  	mutex_lock(&videodev_lock);
> -	if (WARN_ON(video_device[vdev->minor] != vdev)) {
> +	if (WARN_ON(video_devices[vdev->minor] != vdev)) {
>  		/* should not happen */
>  		mutex_unlock(&videodev_lock);
>  		return;
>  	}
> 
>  	/* Free up this device for reuse */
> -	video_device[vdev->minor] = NULL;
> +	video_devices[vdev->minor] = NULL;
> 
>  	/* Delete the cdev on this minor as well */
>  	cdev_del(vdev->cdev);
> @@ -229,7 +229,7 @@ static struct class video_class = {
> 
>  struct video_device *video_devdata(struct file *file)
>  {
> -	return video_device[iminor(file_inode(file))];
> +	return video_devices[iminor(file_inode(file))];
>  }
>  EXPORT_SYMBOL(video_devdata);
> 
> @@ -493,9 +493,9 @@ static int get_index(struct video_device *vdev)
>  	bitmap_zero(used, VIDEO_NUM_DEVICES);
> 
>  	for (i = 0; i < VIDEO_NUM_DEVICES; i++) {
> -		if (video_device[i] != NULL &&
> -		    video_device[i]->v4l2_dev == vdev->v4l2_dev) {
> -			set_bit(video_device[i]->index, used);
> +		if (video_devices[i] != NULL &&
> +		    video_devices[i]->v4l2_dev == vdev->v4l2_dev) {
> +			set_bit(video_devices[i]->index, used);
>  		}
>  	}
> 
> @@ -929,7 +929,7 @@ int __video_register_device(struct video_device *vdev,
>  	/* The device node number and minor numbers are independent, so
>  	   we just find the first free minor number. */
>  	for (i = 0; i < VIDEO_NUM_DEVICES; i++)
> -		if (video_device[i] == NULL)
> +		if (video_devices[i] == NULL)
>  			break;
>  	if (i == VIDEO_NUM_DEVICES) {
>  		mutex_unlock(&videodev_lock);
> @@ -942,9 +942,9 @@ int __video_register_device(struct video_device *vdev,
>  	devnode_set(vdev);
> 
>  	/* Should not happen since we thought this minor was free */
> -	WARN_ON(video_device[vdev->minor] != NULL);
> +	WARN_ON(video_devices[vdev->minor] != NULL);
>  	vdev->index = get_index(vdev);
> -	video_device[vdev->minor] = vdev;
> +	video_devices[vdev->minor] = vdev;
>  	mutex_unlock(&videodev_lock);
> 
>  	if (vdev->ioctl_ops)
> @@ -999,7 +999,7 @@ int __video_register_device(struct video_device *vdev,
>  	mutex_lock(&videodev_lock);
>  	if (vdev->cdev)
>  		cdev_del(vdev->cdev);
> -	video_device[vdev->minor] = NULL;
> +	video_devices[vdev->minor] = NULL;
>  	devnode_clear(vdev);
>  	mutex_unlock(&videodev_lock);
>  	/* Mark this video device as never having been registered. */

-- 
Regards,

Laurent Pinchart
