Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49651 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbbH1OZt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 10:25:49 -0400
Message-ID: <55E06F38.1070109@xs4all.nl>
Date: Fri, 28 Aug 2015 16:24:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] [media] v4l2-core: create MC interfaces for devnodes
References: <747fad94e8f62c1519ff2f033471cec63e3d49b3.1440421343.git.mchehab@osg.samsung.com>
In-Reply-To: <747fad94e8f62c1519ff2f033471cec63e3d49b3.1440421343.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/2015 03:19 PM, Mauro Carvalho Chehab wrote:
> All V4L2 device nodes should create an interface, if the
> Media Controller support is enabled.
> 
> Please notice that radio devices should not create an
> entity, as radio input/output is either via wires or
> via ALSA.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> ---
> 
> With this patch, V4L is now creating interfaces for all device nodes,
> using the proper types:
> 
> $ ./mc_nextgen_test |grep -e dev -e entity#[1-5]\\b -e entity#262\\b
> entity entity#1: au8522 19-0047, num pads = 3
> entity entity#2: Xceive XC5000, num pads = 1
> entity entity#3: au0828a video, num pads = 1
> entity entity#4: au0828a vbi, num pads = 1
> entity entity#5: Auvitek AU8522 QAM/8VSB Frontend, num pads = 2
> entity entity#262: dvb-demux, num pads = 257
> interface intf_devnode#1: video (81,0)
> interface intf_devnode#2: vbi (81,1)
> interface intf_devnode#3: v4l2_subdev (81,2)
> interface intf_devnode#4: frontend (212,0)
> interface intf_devnode#5: demux (212,1)
> interface intf_devnode#6: DVR (212,2)
> interface intf_devnode#7: dvbnet (212,3)
> link link#1: intf_devnode#1 and entity#3
> link link#2: intf_devnode#2 and entity#4
> link link#3: intf_devnode#3 and entity#2
> link link#4: intf_devnode#4 and entity#5
> link link#5: intf_devnode#5 and entity#262
> link link#1034: intf_devnode#4 and entity#2
> link link#1035: intf_devnode#6 and entity#262
> 
> However, it should be noticed that there are missing links there, as the
> interfaces intf_devnode#1: and intf_devnode#2: should also be linked to
> the analog entities (e. g. entity#1 to entity#5).
> 
> It is hard to implememt that, however, as some platform drivers don't
> have such connections. There are two issues to be solved here:
> 
> 1) how the V4L2 core will identify that it could automatically create
>    links to the other analog interfaces;
> 
> 2) Where to place such code.
> 
> Let's do it on separate patches.

Agreed.

I would add that we shouldn't attempt to be 100% perfect in automatically
creating links. If we can do 80-90% of the drivers that way, then that would
be great. The remaining drivers will then need to be modified manually.

> 
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 44b330589787..472117f32c05 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -713,6 +713,78 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  			BASE_VIDIOC_PRIVATE);
>  }
>  
> +
> +static int video_register_media_controller(struct video_device *vdev, int type)
> +{
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	u32 entity_type, intf_type;
> +	int ret;
> +	bool create_entity = true;
> +
> +	if (!vdev->v4l2_dev->mdev)
> +		return 0;
> +
> +	switch (type) {
> +	case VFL_TYPE_GRABBER:
> +		intf_type = MEDIA_INTF_T_V4L_VIDEO;
> +		entity_type = MEDIA_ENT_T_V4L2_VIDEO;
> +		break;
> +	case VFL_TYPE_VBI:
> +		intf_type = MEDIA_INTF_T_V4L_VBI;
> +		entity_type = MEDIA_ENT_T_V4L2_VBI;
> +		break;
> +	case VFL_TYPE_SDR:
> +		intf_type = MEDIA_INTF_T_V4L_SWRADIO;
> +		entity_type = MEDIA_ENT_T_V4L2_SWRADIO;
> +		break;
> +	case VFL_TYPE_RADIO:
> +		intf_type = MEDIA_INTF_T_V4L_RADIO;
> +		/*
> +		 * Radio doesn't have an entity at the V4L2 side to represent
> +		 * radio input or output. Instead, the audio input/output goes
> +		 * via either physical wires or ALSA.
> +		 */
> +		create_entity = false;
> +		break;
> +	default: /* Only type left is subdevs */
> +		/* Subdevs are created via v4l2_device_register_subdev_nodes */

As mentioned in the other patch: why can't you create the interface for subdevs
as well?

> +		return 0;
> +	}
> +
> +	if (create_entity) {
> +		vdev->entity.type = entity_type;
> +		vdev->entity.name = vdev->name;
> +		vdev->entity.info.dev.major = VIDEO_MAJOR;
> +		vdev->entity.info.dev.minor = vdev->minor;
> +
> +		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
> +						   &vdev->entity);
> +		if (ret < 0) {
> +			printk(KERN_WARNING
> +				"%s: media_device_register_entity failed\n",
> +				__func__);
> +			return ret;
> +		}
> +	}
> +
> +	vdev->intf_devnode = media_devnode_create(vdev->v4l2_dev->mdev,
> +						  intf_type,
> +						  0, VIDEO_MAJOR,
> +						  vdev->minor,
> +						  GFP_KERNEL);
> +	if (!vdev->intf_devnode)
> +		return -ENOMEM;
> +
> +	if (create_entity)
> +		media_create_intf_link(&vdev->entity,
> +				       &vdev->intf_devnode->intf, 0);
> +
> +	/* FIXME: how to create the other interface links? */
> +
> +#endif
> +	return 0;
> +}
> +
>  /**
>   *	__video_register_device - register video4linux devices
>   *	@vdev: video device structure we want to register
> @@ -908,22 +980,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  	/* Increase v4l2_device refcount */
>  	v4l2_device_get(vdev->v4l2_dev);
>  
> -#if defined(CONFIG_MEDIA_CONTROLLER)
>  	/* Part 5: Register the entity. */
> -	if (vdev->v4l2_dev->mdev &&
> -	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
> -		vdev->entity.type = MEDIA_ENT_T_V4L2_VIDEO;
> -		vdev->entity.name = vdev->name;
> -		vdev->entity.info.dev.major = VIDEO_MAJOR;
> -		vdev->entity.info.dev.minor = vdev->minor;
> -		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
> -			&vdev->entity);
> -		if (ret < 0)
> -			printk(KERN_WARNING
> -			       "%s: media_device_register_entity failed\n",
> -			       __func__);
> -	}
> -#endif
> +	ret = video_register_media_controller(vdev, type);
> +
>  	/* Part 6: Activate this minor. The char device can now be used. */
>  	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
>  

I'm missing changes to v4l2_device_release() to clean up the interface and
entity.

> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 1e5176c558bf..2124a0e793f3 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -251,18 +251,18 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>  		sd->entity.info.dev.major = VIDEO_MAJOR;
>  		sd->entity.info.dev.minor = vdev->minor;
>  
> -		sd->intf_devnode = media_devnode_create(sd->entity.graph_obj.mdev,
> +		vdev->intf_devnode = media_devnode_create(sd->entity.graph_obj.mdev,
>  							MEDIA_INTF_T_V4L_SUBDEV,
>  							0, VIDEO_MAJOR,
>  							vdev->minor,
>  							GFP_KERNEL);
> -		if (!sd->intf_devnode) {
> +		if (!vdev->intf_devnode) {
>  			err = -ENOMEM;
>  			kfree(vdev);
>  			goto clean_up;
>  		}
>  
> -		media_create_intf_link(&sd->entity, &sd->intf_devnode->intf, 0);
> +		media_create_intf_link(&sd->entity, &vdev->intf_devnode->intf, 0);
>  #endif
>  		sd->devnode = vdev;
>  	}
> @@ -282,6 +282,7 @@ EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_nodes);
>  void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_device *v4l2_dev;
> +	struct video_device *vdev = sd->devnode;
>  
>  	/* return if it isn't registered */
>  	if (sd == NULL || sd->v4l2_dev == NULL)
> @@ -300,7 +301,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	if (v4l2_dev->mdev) {
>  		media_entity_remove_links(&sd->entity);
> -		media_devnode_remove(sd->intf_devnode);
> +		media_devnode_remove(vdev->intf_devnode);
>  		media_device_unregister_entity(&sd->entity);
>  	}
>  #endif
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index acbcd2f5fe7f..eeabf20e87a6 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -86,6 +86,7 @@ struct video_device
>  {
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_entity entity;
> +	struct media_intf_devnode *intf_devnode;
>  #endif
>  	/* device ops */
>  	const struct v4l2_file_operations *fops;
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1aa44f11eeb5..370fc38c34f1 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -584,7 +584,6 @@ struct v4l2_subdev_platform_data {
>  struct v4l2_subdev {
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_entity entity;
> -	struct media_intf_devnode *intf_devnode;
>  #endif
>  	struct list_head list;
>  	struct module *owner;
> 

Regards,

	Hans
