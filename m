Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56335 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbLFCoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 21:44:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] [media] uvcvideo: create pad links after subdev registration
Date: Sun, 06 Dec 2015 04:44:12 +0200
Message-ID: <2329250.FAlNbDTqBe@avalon>
In-Reply-To: <55ED9AD1.1090205@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com> <1441296036-20727-5-git-send-email-javier@osg.samsung.com> <55ED9AD1.1090205@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Monday 07 September 2015 16:10:25 Javier Martinez Canillas wrote:

[snip]

> From 8be356e77eeefdc5c0738dd429205f3398c5b76c Mon Sep 17 00:00:00 2001
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> Date: Thu, 3 Sep 2015 13:46:06 +0200
> Subject: [PATCH v2 4/5] [media] uvcvideo: create pad links after subdev
>  registration
> 
> The uvc driver creates the pads links before the media entity is
> registered with the media device. This doesn't work now that obj
> IDs are used to create links so the media_device has to be set.
> 
> Move entities registration logic before pads links creation.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
> Changes since v1:
>  - Don't try to register a UVC entity subdev for type UVC_TT_STREAMING.
> 
>  drivers/media/usb/uvc/uvc_entity.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_entity.c
> b/drivers/media/usb/uvc/uvc_entity.c index 429e428ccd93..7f82b65b238e
> 100644
> --- a/drivers/media/usb/uvc/uvc_entity.c
> +++ b/drivers/media/usb/uvc/uvc_entity.c
> @@ -26,6 +26,15 @@
>  static int uvc_mc_register_entity(struct uvc_video_chain *chain,
>         struct uvc_entity *entity)
>  {
> +       if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
> +               return 0;
> +
> +       return v4l2_device_register_subdev(&chain->dev->vdev,
> &entity->subdev);
> +}
> +
> +static int uvc_mc_create_pads_links(struct uvc_video_chain *chain,
> +                                   struct uvc_entity *entity)
> +{
>         const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
>         struct media_entity *sink;
>         unsigned int i;
> @@ -62,10 +71,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain
> *chain, return ret;
>         }
>  
> -       if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
> -               return 0;
> -
> -       return v4l2_device_register_subdev(&chain->dev->vdev,
> &entity->subdev);
> +       return 0;
>  }
>  
>  static struct v4l2_subdev_ops uvc_subdev_ops = {
> @@ -124,5 +130,14 @@ int uvc_mc_register_entities(struct uvc_video_chain
> *chain) }
>         }
>  
> +       list_for_each_entry(entity, &chain->entities, chain) {
> +               ret = uvc_mc_create_pads_links(chain, entity);

You can call this uvc_mc_create_links(), there's no other type of links in the 
driver.

> +               if (ret < 0) {
> +                       uvc_printk(KERN_INFO, "Failed to create pads links
> for "

Same here, I'd s/pad links/links/.

> +                                  "entity %u\n", entity->id);
> +                       return ret;
> +               }
> +       }

This creates three loops, and I think that's one too much. The reason why init 
and register are separate is that the latter creates links, which requires all 
entities to be initialized. If you move link create after registration I 
believe you can init and register in a single loop (just move the 
v4l2_device_register_subdev() call in the appropriate location in 
uvc_mc_init_entity()) and then create links in a second loop.

>         return 0;
>  }

-- 
Regards,

Laurent Pinchart

