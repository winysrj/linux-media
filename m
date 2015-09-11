Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34363 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbbIKOUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:20:04 -0400
Message-ID: <55F2E2CB.9010504@xs4all.nl>
Date: Fri, 11 Sep 2015 16:18:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 51/55] [media] remove interface links at media_entity_unregister()
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <ce03152d3a7f156ff3fe9a3ff15a8d9530e0307a.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ce03152d3a7f156ff3fe9a3ff15a8d9530e0307a.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Interface links connected to an entity should be removed
> before being able of removing the entity.

I'd replace that with:

...before the entity itself can be removed.

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 96a476eeb16e..7c37aeab05bb 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -638,14 +638,30 @@ void media_device_unregister_entity(struct media_entity *entity)
>  		return;
>  
>  	spin_lock(&mdev->lock);
> +
> +	/* Remove interface links with this entity on it */
> +	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
> +		if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY

I honestly think that the media_type() check can be removed. I think I
mentioned it before. Not important enough to withhold the Ack, though.

> +		    && link->entity == entity) {
> +			media_gobj_remove(&link->graph_obj);
> +			kfree(link);
> +		}
> +	}
> +
> +	/* Remove all data links that belong to this entity */
>  	list_for_each_entry_safe(link, tmp, &entity->links, list) {
>  		media_gobj_remove(&link->graph_obj);
>  		list_del(&link->list);
>  		kfree(link);
>  	}
> +
> +	/* Remove all pads that belong to this entity */
>  	for (i = 0; i < entity->num_pads; i++)
>  		media_gobj_remove(&entity->pads[i].graph_obj);
> +
> +	/* Remove the entity */
>  	media_gobj_remove(&entity->graph_obj);
> +
>  	spin_unlock(&mdev->lock);
>  	entity->graph_obj.mdev = NULL;
>  }
> 

