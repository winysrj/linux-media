Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37330 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388307AbeGXMLD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 08:11:03 -0400
Date: Tue, 24 Jul 2018 14:05:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 14/26] media: Convert entity ID allocation to new IDA API
Message-ID: <20180724110507.idyjc3vbbivwbxtb@valkosipuli.retiisi.org.uk>
References: <20180621212835.5636-1-willy@infradead.org>
 <20180621212835.5636-15-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180621212835.5636-15-willy@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 21, 2018 at 02:28:23PM -0700, Matthew Wilcox wrote:
> Removes a call to ida_pre_get().
> 
> Signed-off-by: Matthew Wilcox <willy@infradead.org>

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> ---
>  drivers/media/media-device.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index ae59c3177555..d51088bcd735 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -575,18 +575,12 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	entity->num_links = 0;
>  	entity->num_backlinks = 0;
>  
> -	if (!ida_pre_get(&mdev->entity_internal_idx, GFP_KERNEL))
> -		return -ENOMEM;
> -
> -	mutex_lock(&mdev->graph_mutex);
> -
> -	ret = ida_get_new_above(&mdev->entity_internal_idx, 1,
> -				&entity->internal_idx);
> -	if (ret < 0) {
> -		mutex_unlock(&mdev->graph_mutex);
> +	ret = ida_alloc_min(&mdev->entity_internal_idx, 1, GFP_KERNEL);
> +	if (ret < 0)
>  		return ret;
> -	}
> +	entity->internal_idx = ret;
>  
> +	mutex_lock(&mdev->graph_mutex);
>  	mdev->entity_internal_idx_max =
>  		max(mdev->entity_internal_idx_max, entity->internal_idx);
>  
> @@ -632,7 +626,7 @@ static void __media_device_unregister_entity(struct media_entity *entity)
>  	struct media_interface *intf;
>  	unsigned int i;
>  
> -	ida_simple_remove(&mdev->entity_internal_idx, entity->internal_idx);
> +	ida_free(&mdev->entity_internal_idx, entity->internal_idx);
>  
>  	/* Remove all interface links pointing to this entity */
>  	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
