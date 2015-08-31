Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34805 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbbHaKbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 06:31:12 -0400
Message-ID: <55E42CB8.6010706@xs4all.nl>
Date: Mon, 31 Aug 2015 12:30:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 16/55] [media] media: Don't accept early-created links
References: <cover.1440902901.git.mchehab@osg.samsung.com> <31329e1be748d26ce5a90fe050ba15b8d1e5aff1.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <31329e1be748d26ce5a90fe050ba15b8d1e5aff1.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Links are graph objects that represent the links of two already
> existing objects in the graph.
> 
> While with the current implementation, it is possible to create
> the links earlier, It doesn't make any sense to allow linking
> two objects when they are not both created.
> 
> So, remove the code that would be handling those early-created
> links and add a BUG_ON() to ensure that.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

The code is OK, so:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

But shouldn't this go *after* the omap3isp fixes? After this patch the
omap3isp will call BUG_ON, and that's not what you want.

It is also not clear if the omap3isp driver is the only one that has this
'create link before objects' problem. I would expect that the omap4 staging
driver has the same issue and possibly others as well.

Did someone look at that?

Regards,

	Hans

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 138b18416460..0d85c6c28004 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -443,13 +443,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
>  	list_add_tail(&entity->list, &mdev->entities);
>  
> -	/*
> -	 * Initialize objects at the links
> -	 * in the case where links got created before entity register
> -	 */
> -	for (i = 0; i < entity->num_links; i++)
> -		media_gobj_init(mdev, MEDIA_GRAPH_LINK,
> -				&entity->links[i].graph_obj);
>  	/* Initialize objects at the pads */
>  	for (i = 0; i < entity->num_pads; i++)
>  		media_gobj_init(mdev, MEDIA_GRAPH_PAD,
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 01946baa32d5..9f8e0145db7a 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -161,6 +161,8 @@ void media_gobj_init(struct media_device *mdev,
>  			   enum media_gobj_type type,
>  			   struct media_gobj *gobj)
>  {
> +	BUG_ON(!mdev);
> +
>  	gobj->mdev = mdev;
>  
>  	/* Create a per-type unique object ID */
> 

