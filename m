Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38767 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbbKWQUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 11:20:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [media-workshop] [PATCH v8.4 81/83] [media] media-entity: init pads on entity init if was registered before
Date: Mon, 23 Nov 2015 18:20:55 +0200
Message-ID: <2341331.P6c9pT8HFp@avalon>
In-Reply-To: <1444668252-2303-82-git-send-email-mchehab@osg.samsung.com>
References: <1444668252-2303-1-git-send-email-mchehab@osg.samsung.com> <1444668252-2303-82-git-send-email-mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

(Replying to linux-media instead of media-workshop, I can't find this patch in 
my linux-media folder)

Thank you for the patch.

On Monday 12 October 2015 13:44:10 Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> If an entity is registered with a media device before is initialized
> with media_device_register_entity(), the number of pads won't be set
> so media_device_register_entity() won't create pad objects and add
> it to the media device pads list.
> 
> Do this at entity initialization time if the entity was registered
> before so the graph is complete and correct regardless of the order
> in which the entities are initialized and registered.

We now have two places where the pads graph objects are initialized and that 
looks like a bug to me as media_gobj_init() allocates IDs and, even worse, 
adds the entity to the media device entities list.

We need to standardize on where graph objects are initialized across the 
different kind of objects and document this clearly otherwise drivers will get 
it wrong.

> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
>  drivers/media/media-entity.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index f28265864b76..2c984fb7d497 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -238,6 +238,7 @@ int
>  media_entity_init(struct media_entity *entity, u16 num_pads,
>  		  struct media_pad *pads)
>  {
> +	struct media_device *mdev = entity->graph_obj.mdev;
>  	unsigned int i;
> 
>  	entity->group_id = 0;
> @@ -246,11 +247,20 @@ media_entity_init(struct media_entity *entity, u16
> num_pads, entity->num_pads = num_pads;
>  	entity->pads = pads;
> 
> +	if (mdev)
> +		spin_lock(&mdev->lock);
> +
>  	for (i = 0; i < num_pads; i++) {
>  		pads[i].entity = entity;
>  		pads[i].index = i;
> +		if (mdev)
> +			media_gobj_init(mdev, MEDIA_GRAPH_PAD,
> +					&entity->pads[i].graph_obj);
>  	}
> 
> +	if (mdev)
> +		spin_unlock(&mdev->lock);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(media_entity_init);

-- 
Regards,

Laurent Pinchart

