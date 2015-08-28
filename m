Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39641 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbbH1ONy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 10:13:54 -0400
Message-ID: <55E06C6A.7060202@xs4all.nl>
Date: Fri, 28 Aug 2015 16:12:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] [media] media-entity: unregister entity links
References: <cover.1440417725.git.mchehab@osg.samsung.com> <9f06472def6af978f3adb5481f68aa068a714419.1440417725.git.mchehab@osg.samsung.com>
In-Reply-To: <9f06472def6af978f3adb5481f68aa068a714419.1440417725.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Add functions to explicitly unregister all entity links.
> This function is called automatically when an entity
> link is destroyed.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index fc6bb48027ab..7e6fb5a86b21 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -896,6 +896,7 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
>  
>  void media_devnode_remove(struct media_intf_devnode *devnode)
>  {
> +	media_remove_intf_links(&devnode->intf);
>  	media_gobj_remove(&devnode->intf.graph_obj);
>  	kfree(devnode);
>  }
> @@ -937,3 +938,25 @@ void media_remove_intf_link(struct media_link *link)
>  	mutex_unlock(&link->graph_obj.mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_remove_intf_link);
> +
> +void __media_remove_intf_links(struct media_interface *intf)
> +{
> +	struct media_link *link, *tmp;
> +
> +	list_for_each_entry_safe(link, tmp, &intf->links, list)
> +		media_remove_intf_link(link);
> +
> +}
> +EXPORT_SYMBOL_GPL(__media_remove_intf_links);
> +
> +void media_remove_intf_links(struct media_interface *intf)
> +{
> +	/* Do nothing if the intf is not registered. */
> +	if (intf->graph_obj.mdev == NULL)
> +		return;
> +
> +	mutex_lock(&intf->graph_obj.mdev->graph_mutex);
> +	__media_remove_intf_links(intf);
> +	mutex_unlock(&intf->graph_obj.mdev->graph_mutex);
> +}
> +EXPORT_SYMBOL_GPL(media_remove_intf_links);
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index d89ceaf7bcc4..8c26934c97fe 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -318,6 +318,9 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
>  					    struct media_interface *intf,
>  					    u32 flags);
>  void media_remove_intf_link(struct media_link *link);
> +void __media_remove_intf_links(struct media_interface *intf);
> +void media_remove_intf_links(struct media_interface *intf);
> +
>  
>  #define media_entity_call(entity, operation, args...)			\
>  	(((entity)->ops && (entity)->ops->operation) ?			\
> 

