Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:41873 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab1DLMdK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 08:33:10 -0400
Message-ID: <4DA44718.1090501@maxwell.research.nokia.com>
Date: Tue, 12 Apr 2011 15:35:36 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Don't register media entities for subdev device
 nodes
References: <1302531990-5395-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1302531990-5395-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Subdevs already have their own entity, don't register as second one when
> registering the subdev device node.

Thanks for the patch!

Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/v4l2-dev.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 498e674..6dc7196 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -389,7 +389,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>  	video_get(vdev);
>  	mutex_unlock(&videodev_lock);
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
> +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> +	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
>  		entity = media_entity_get(&vdev->entity);
>  		if (!entity) {
>  			ret = -EBUSY;
> @@ -415,7 +416,8 @@ err:
>  	/* decrease the refcount in case of an error */
>  	if (ret) {
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> +		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> +		    vdev->vfl_type != VFL_TYPE_SUBDEV)
>  			media_entity_put(entity);
>  #endif
>  		video_put(vdev);
> @@ -437,7 +439,8 @@ static int v4l2_release(struct inode *inode, struct file *filp)
>  			mutex_unlock(vdev->lock);
>  	}
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> +	    vdev->vfl_type != VFL_TYPE_SUBDEV)
>  		media_entity_put(&vdev->entity);
>  #endif
>  	/* decrease the refcount unconditionally since the release()
> @@ -686,7 +689,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	/* Part 5: Register the entity. */
> -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
> +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> +	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
>  		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
>  		vdev->entity.name = vdev->name;
>  		vdev->entity.v4l.major = VIDEO_MAJOR;
> @@ -733,7 +737,8 @@ void video_unregister_device(struct video_device *vdev)
>  		return;
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> +	    vdev->vfl_type != VFL_TYPE_SUBDEV)
>  		media_device_unregister_entity(&vdev->entity);
>  #endif
>  


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
