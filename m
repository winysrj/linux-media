Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56340 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbbLFCqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 21:46:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/5] [media] v4l: vsp1: create pad links after subdev registration
Date: Sun, 06 Dec 2015 04:46:14 +0200
Message-ID: <2189762.YSqxXoib1X@avalon>
In-Reply-To: <1441296036-20727-3-git-send-email-javier@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com> <1441296036-20727-3-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Thursday 03 September 2015 18:00:33 Javier Martinez Canillas wrote:
> The vsp1 driver creates the pads links before the media entities are
> registered with the media device. This doesn't work now that object
> IDs are used to create links so the media_device has to be set.
> 
> Move entities registration logic before pads links creation.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  drivers/media/platform/vsp1/vsp1_drv.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> b/drivers/media/platform/vsp1/vsp1_drv.c index 9cd94a76a9ed..2aa427d3ff39
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -250,6 +250,14 @@ static int vsp1_create_entities(struct vsp1_device
> *vsp1) list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
>  	}
> 
> +	/* Register all subdevs. */
> +	list_for_each_entry(entity, &vsp1->entities, list_dev) {
> +		ret = v4l2_device_register_subdev(&vsp1->v4l2_dev,
> +						  &entity->subdev);
> +		if (ret < 0)
> +			goto done;
> +	}
> +
>  	/* Create links. */
>  	list_for_each_entry(entity, &vsp1->entities, list_dev) {
>  		if (entity->type == VSP1_ENTITY_LIF ||
> @@ -269,14 +277,6 @@ static int vsp1_create_entities(struct vsp1_device
> *vsp1) return ret;
>  	}
> 
> -	/* Register all subdevs. */
> -	list_for_each_entry(entity, &vsp1->entities, list_dev) {
> -		ret = v4l2_device_register_subdev(&vsp1->v4l2_dev,
> -						  &entity->subdev);
> -		if (ret < 0)
> -			goto done;
> -	}
> -
>  	ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
> 
>  done:

-- 
Regards,

Laurent Pinchart

