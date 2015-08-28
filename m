Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:33305 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbbH1OTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 10:19:53 -0400
Message-ID: <55E06DD5.3000102@xs4all.nl>
Date: Fri, 28 Aug 2015 16:19:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/2] [media] v4l2-subdev: create interfaces at MC
References: <cover.1440417725.git.mchehab@osg.samsung.com> <f6907dde703782c98eb67abb48a3409faaebfb61.1440417725.git.mchehab@osg.samsung.com>
In-Reply-To: <f6907dde703782c98eb67abb48a3409faaebfb61.1440417725.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Now that the Media Controller has support for interfaces,
> create them when v4l-subdev interfaces are created.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 5b0a30b9252b..1e5176c558bf 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -247,8 +247,22 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>  			goto clean_up;
>  		}
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> +		/* Needed just for backward compatibility with legacy MC API */
>  		sd->entity.info.dev.major = VIDEO_MAJOR;
>  		sd->entity.info.dev.minor = vdev->minor;
> +
> +		sd->intf_devnode = media_devnode_create(sd->entity.graph_obj.mdev,
> +							MEDIA_INTF_T_V4L_SUBDEV,
> +							0, VIDEO_MAJOR,
> +							vdev->minor,
> +							GFP_KERNEL);
> +		if (!sd->intf_devnode) {
> +			err = -ENOMEM;
> +			kfree(vdev);
> +			goto clean_up;
> +		}

Why not let __video_register_device() create the interface? It needs to do that
for all other device types as well. That would make much more sense rather than
having subdevs as a weird exception.

> +
> +		media_create_intf_link(&sd->entity, &sd->intf_devnode->intf, 0);

Linking the entity and interface together is the only thing that should happen here.

>  #endif
>  		sd->devnode = vdev;
>  	}
> @@ -286,6 +300,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	if (v4l2_dev->mdev) {
>  		media_entity_remove_links(&sd->entity);
> +		media_devnode_remove(sd->intf_devnode);

This can be removed as well in that case since it will be called from
video_unregister_device().

>  		media_device_unregister_entity(&sd->entity);
>  	}
>  #endif
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 370fc38c34f1..1aa44f11eeb5 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -584,6 +584,7 @@ struct v4l2_subdev_platform_data {
>  struct v4l2_subdev {
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_entity entity;
> +	struct media_intf_devnode *intf_devnode;
>  #endif
>  	struct list_head list;
>  	struct module *owner;
> 

Regards,

	Hans
