Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56370 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbbLFDN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 22:13:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 16/55] [media] media: Don't accept early-created links
Date: Sun, 06 Dec 2015 05:13:42 +0200
Message-ID: <4429074.sB9E7s8GZM@avalon>
In-Reply-To: <7c566a41726e8ba88873b427912ca7797c63ec2f.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <7c566a41726e8ba88873b427912ca7797c63ec2f.1441540862.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 09:02:47 Mauro Carvalho Chehab wrote:
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
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 138b18416460..0d85c6c28004 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -443,13 +443,6 @@ int __must_check media_device_register_entity(struct
> media_device *mdev, media_gobj_init(mdev, MEDIA_GRAPH_ENTITY,
> &entity->graph_obj);
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
> index 27fce6224972..0926f08be981 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -161,6 +161,8 @@ void media_gobj_init(struct media_device *mdev,
>  			   enum media_gobj_type type,
>  			   struct media_gobj *gobj)
>  {
> +	BUG_ON(!mdev);
> +

Please use a WARN_ON() and return (and possibly make the function return an 
int error code), we don't want to panic completely for this.

>  	gobj->mdev = mdev;
> 
>  	/* Create a per-type unique object ID */

-- 
Regards,

Laurent Pinchart

