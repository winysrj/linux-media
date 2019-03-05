Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9209AC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 19:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58436205F4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 19:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="PkA4iwrZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfCETwW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:52:22 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:40894 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfCETwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 14:52:22 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5C15D24A;
        Tue,  5 Mar 2019 20:52:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551815540;
        bh=QwSWCpocQIwRqPPyV6M8RRLeb9n+jB0Ixk/TsYEoWAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PkA4iwrZhqdWbEYp0n4uOhhgrNCtjFM3haQDUpNXFsxx8dcs6O0m/3ALq5cef6ulr
         bYUbl62q314Ds1XEkVvWoIJoQ3JGZChcnZk+tNu/SzOBKWuhGWwxHvAQz7xJt8Kk+W
         7bu2IhA0QertDlHp1atcWz28ZXMcQXRgmWy5IY9c=
Date:   Tue, 5 Mar 2019 21:52:14 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCHv2 7/9] v4l2-subdev: handle module refcounting here
Message-ID: <20190305195214.GH14928@pendragon.ideasonboard.com>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-8-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190305095847.21428-8-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

(CC'ing Sakari)

Thank you for the patch.

On Tue, Mar 05, 2019 at 10:58:45AM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The module ownership refcounting was done in media_entity_get/put,
> but that was very confusing and it did not work either in case an
> application had a v4l-subdevX device open and the module was
> unbound. When the v4l-subdevX device was closed the media_entity_put
> was never called and the module refcount was left one too high, making
> it impossible to unload it.
> 
> Since v4l2-subdev.c was the only place where media_entity_get/put was
> called, just move the functionality to v4l2-subdev.c and drop those
> confusing entity functions.

I wonder if we will later need to refcount media entities, but we can
reintroduce a different version of those two functions then, it doesn't
prevent their removal now.

Sakari, when working on lifetime management of objects in the media and
V4L2 core, did you come across a need to refcount entities ?

> Store the module in subdev_fh so module_put no longer depends on
> the media_entity struct.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/media-entity.c          | 28 ---------------------------
>  drivers/media/v4l2-core/v4l2-subdev.c | 22 +++++++++------------
>  include/media/media-entity.h          | 24 -----------------------
>  include/media/v4l2-subdev.h           |  1 +
>  4 files changed, 10 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 7b2a2cc95530..257f20d2fb8a 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -17,7 +17,6 @@
>   */
>  
>  #include <linux/bitmap.h>
> -#include <linux/module.h>
>  #include <linux/property.h>
>  #include <linux/slab.h>
>  #include <media/media-entity.h>
> @@ -588,33 +587,6 @@ void media_pipeline_stop(struct media_entity *entity)
>  }
>  EXPORT_SYMBOL_GPL(media_pipeline_stop);
>  
> -/* -----------------------------------------------------------------------------
> - * Module use count
> - */
> -
> -struct media_entity *media_entity_get(struct media_entity *entity)
> -{
> -	if (entity == NULL)
> -		return NULL;
> -
> -	if (entity->graph_obj.mdev->dev &&
> -	    !try_module_get(entity->graph_obj.mdev->dev->driver->owner))
> -		return NULL;
> -
> -	return entity;
> -}
> -EXPORT_SYMBOL_GPL(media_entity_get);
> -
> -void media_entity_put(struct media_entity *entity)
> -{
> -	if (entity == NULL)
> -		return;
> -
> -	if (entity->graph_obj.mdev->dev)
> -		module_put(entity->graph_obj.mdev->dev->driver->owner);
> -}
> -EXPORT_SYMBOL_GPL(media_entity_put);
> -
>  /* -----------------------------------------------------------------------------
>   * Links management
>   */
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index f5f0d71ec745..d75815ab0d7b 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -18,6 +18,7 @@
>  
>  #include <linux/ioctl.h>
>  #include <linux/mm.h>
> +#include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/videodev2.h>
> @@ -54,9 +55,6 @@ static int subdev_open(struct file *file)
>  	struct video_device *vdev = video_devdata(file);
>  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
>  	struct v4l2_subdev_fh *subdev_fh;
> -#if defined(CONFIG_MEDIA_CONTROLLER)
> -	struct media_entity *entity = NULL;
> -#endif
>  	int ret;
>  
>  	subdev_fh = kzalloc(sizeof(*subdev_fh), GFP_KERNEL);
> @@ -73,12 +71,15 @@ static int subdev_open(struct file *file)
>  	v4l2_fh_add(&subdev_fh->vfh);
>  	file->private_data = &subdev_fh->vfh;
>  #if defined(CONFIG_MEDIA_CONTROLLER)

On a side note, do you think it's time to select MEDIA_CONTROLLER
unconditionally ?

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> -	if (sd->v4l2_dev->mdev) {
> -		entity = media_entity_get(&sd->entity);
> -		if (!entity) {
> +	if (sd->v4l2_dev->mdev && sd->entity.graph_obj.mdev->dev) {
> +		struct module *owner;
> +
> +		owner = sd->entity.graph_obj.mdev->dev->driver->owner;
> +		if (!try_module_get(owner)) {
>  			ret = -EBUSY;
>  			goto err;
>  		}
> +		subdev_fh->owner = owner;
>  	}
>  #endif
>  
> @@ -91,9 +92,7 @@ static int subdev_open(struct file *file)
>  	return 0;
>  
>  err:
> -#if defined(CONFIG_MEDIA_CONTROLLER)
> -	media_entity_put(entity);
> -#endif
> +	module_put(subdev_fh->owner);
>  	v4l2_fh_del(&subdev_fh->vfh);
>  	v4l2_fh_exit(&subdev_fh->vfh);
>  	subdev_fh_free(subdev_fh);
> @@ -111,10 +110,7 @@ static int subdev_close(struct file *file)
>  
>  	if (sd->internal_ops && sd->internal_ops->close)
>  		sd->internal_ops->close(sd, subdev_fh);
> -#if defined(CONFIG_MEDIA_CONTROLLER)
> -	if (sd->v4l2_dev->mdev)
> -		media_entity_put(&sd->entity);
> -#endif
> +	module_put(subdev_fh->owner);
>  	v4l2_fh_del(vfh);
>  	v4l2_fh_exit(vfh);
>  	subdev_fh_free(subdev_fh);
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index e5f6960d92f6..3cbad42e3693 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -864,19 +864,6 @@ struct media_link *media_entity_find_link(struct media_pad *source,
>   */
>  struct media_pad *media_entity_remote_pad(const struct media_pad *pad);
>  
> -/**
> - * media_entity_get - Get a reference to the parent module
> - *
> - * @entity: The entity
> - *
> - * Get a reference to the parent media device module.
> - *
> - * The function will return immediately if @entity is %NULL.
> - *
> - * Return: returns a pointer to the entity on success or %NULL on failure.
> - */
> -struct media_entity *media_entity_get(struct media_entity *entity);
> -
>  /**
>   * media_entity_get_fwnode_pad - Get pad number from fwnode
>   *
> @@ -916,17 +903,6 @@ __must_check int media_graph_walk_init(
>   */
>  void media_graph_walk_cleanup(struct media_graph *graph);
>  
> -/**
> - * media_entity_put - Release the reference to the parent module
> - *
> - * @entity: The entity
> - *
> - * Release the reference count acquired by media_entity_get().
> - *
> - * The function will return immediately if @entity is %NULL.
> - */
> -void media_entity_put(struct media_entity *entity);
> -
>  /**
>   * media_graph_walk_start - Start walking the media graph at a
>   *	given entity
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 2f2d1c8947e6..33ba56f3dc1f 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -905,6 +905,7 @@ struct v4l2_subdev {
>   */
>  struct v4l2_subdev_fh {
>  	struct v4l2_fh vfh;
> +	struct module *owner;
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	struct v4l2_subdev_pad_config *pad;
>  #endif

-- 
Regards,

Laurent Pinchart
