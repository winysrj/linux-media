Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43542 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752597AbcHVM00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:26:26 -0400
Subject: Re: [RFC v2 14/17] media-device: Postpone graph object removal until
 free
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-15-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5b2909aa-a1c3-3806-d1f0-168fa283108c@xs4all.nl>
Date: Mon, 22 Aug 2016 14:26:08 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-15-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> The media device itself will be unregistered based on it being unbound and
> driver's remove callback being called. The graph objects themselves may
> still be in use; rely on the media device release callback to release
> them.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/media-device.c | 44 ++++++++++++++++++++------------------------
>  1 file changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 0656daf..cbbc397 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -756,6 +756,26 @@ EXPORT_SYMBOL_GPL(media_device_cleanup);
>  static void media_device_release(struct media_devnode *devnode)
>  {
>  	struct media_device *mdev = to_media_device(devnode);
> +	struct media_entity *entity;
> +	struct media_entity *next;
> +	struct media_interface *intf, *tmp_intf;
> +	struct media_entity_notify *notify, *nextp;
> +
> +	/* Remove all entities from the media device */
> +	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> +		__media_device_unregister_entity(entity);
> +
> +	/* Remove all entity_notify callbacks from the media device */
> +	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
> +		__media_device_unregister_entity_notify(mdev, notify);
> +
> +	/* Remove all interfaces from the media device */
> +	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
> +				 graph_obj.list) {
> +		__media_remove_intf_links(intf);
> +		media_gobj_destroy(&intf->graph_obj);
> +		kfree(intf);
> +	}
>  
>  	ida_destroy(&mdev->entity_internal_idx);
>  	mdev->entity_internal_idx_max = 0;
> @@ -800,38 +820,14 @@ EXPORT_SYMBOL_GPL(__media_device_register);
>  
>  void media_device_unregister(struct media_device *mdev)
>  {
> -	struct media_entity *entity;
> -	struct media_entity *next;
> -	struct media_interface *intf, *tmp_intf;
> -	struct media_entity_notify *notify, *nextp;
> -
>  	if (mdev == NULL)
>  		return;
>  
>  	mutex_lock(&mdev->graph_mutex);
> -
> -	/* Check if mdev was ever registered at all */
>  	if (!media_devnode_is_registered(&mdev->devnode)) {
>  		mutex_unlock(&mdev->graph_mutex);
>  		return;
>  	}
> -
> -	/* Remove all entities from the media device */
> -	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> -		__media_device_unregister_entity(entity);
> -
> -	/* Remove all entity_notify callbacks from the media device */
> -	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
> -		__media_device_unregister_entity_notify(mdev, notify);
> -
> -	/* Remove all interfaces from the media device */
> -	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
> -				 graph_obj.list) {
> -		__media_remove_intf_links(intf);
> -		media_gobj_destroy(&intf->graph_obj);
> -		kfree(intf);
> -	}
> -
>  	mutex_unlock(&mdev->graph_mutex);
>  
>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> 
