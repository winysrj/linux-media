Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39785 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbbIILh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 07:37:28 -0400
Message-ID: <55F019DA.8090802@xs4all.nl>
Date: Wed, 09 Sep 2015 13:36:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 1/2] [media] media_entity: remove gfp_flags argument
References: <cover.1441798267.git.mchehab@osg.samsung.com> <a00239aa63f30980876da9fa563bb86a80caa7c6.1441798267.git.mchehab@osg.samsung.com>
In-Reply-To: <a00239aa63f30980876da9fa563bb86a80caa7c6.1441798267.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/15 13:32, Mauro Carvalho Chehab wrote:
> We should not be creating device nodes at IRQ contexts. So,
> the only flags we'll be using will be GFP_KERNEL. Let's
> remove the gfp_flags, in order to make the interface simpler.
> 
> If we ever need it, it would be easy to revert those changes.
> 
> While here, remove an extra blank line.
> 
> Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index e9f24c1479dd..60828a9537a0 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -379,8 +379,7 @@ static int dvb_register_media_device(struct dvb_device *dvbdev,
>  
>  	dvbdev->intf_devnode = media_devnode_create(dvbdev->adapter->mdev,
>  						    intf_type, 0,
> -						    DVB_MAJOR, minor,
> -						    GFP_KERNEL);
> +						    DVB_MAJOR, minor);
>  
>  	if (!dvbdev->intf_devnode)
>  		return -ENOMEM;
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 4868b8269204..f28265864b76 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -887,12 +887,11 @@ static void media_interface_init(struct media_device *mdev,
>  
>  struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
>  						u32 type, u32 flags,
> -						u32 major, u32 minor,
> -						gfp_t gfp_flags)
> +						u32 major, u32 minor)
>  {
>  	struct media_intf_devnode *devnode;
>  
> -	devnode = kzalloc(sizeof(*devnode), gfp_flags);
> +	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
>  	if (!devnode)
>  		return NULL;
>  
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 430aa2330d07..982255d2063f 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -777,8 +777,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  	vdev->intf_devnode = media_devnode_create(vdev->v4l2_dev->mdev,
>  						  intf_type,
>  						  0, VIDEO_MAJOR,
> -						  vdev->minor,
> -						  GFP_KERNEL);
> +						  vdev->minor);
>  	if (!vdev->intf_devnode) {
>  		media_device_unregister_entity(&vdev->entity);
>  		return -ENOMEM;
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 9cbb10079024..44ab153c37fc 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -71,7 +71,6 @@ struct media_gobj {
>  	struct list_head	list;
>  };
>  
> -
>  struct media_pipeline {
>  };
>  
> @@ -373,8 +372,7 @@ void media_entity_pipeline_stop(struct media_entity *entity);
>  struct media_intf_devnode *
>  __must_check media_devnode_create(struct media_device *mdev,
>  				  u32 type, u32 flags,
> -				  u32 major, u32 minor,
> -				  gfp_t gfp_flags);
> +				  u32 major, u32 minor);
>  void media_devnode_remove(struct media_intf_devnode *devnode);
>  struct media_link *
>  __must_check media_create_intf_link(struct media_entity *entity,
> 
