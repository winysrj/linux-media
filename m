Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54686 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbbHYHLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 03:11:44 -0400
Message-ID: <55DC1501.5000208@xs4all.nl>
Date: Tue, 25 Aug 2015 09:10:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 15/44] [media] media: get rid of an unused code
References: <cover.1440359643.git.mchehab@osg.samsung.com> <5ccb3df9166af331070f546a7d3c522d65964919.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <5ccb3df9166af331070f546a7d3c522d65964919.1440359643.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> This code is not used in practice. Get rid of it before
> start converting links to lists.

I assume the reason is that links are always created *after*
entities are registered?

Can you add that to this commit log?

With that change:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
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
> 

