Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34093 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754196AbcHVL4q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 07:56:46 -0400
Subject: Re: [RFC v2 04/17] media: Remove useless curly braces and parentheses
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-5-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <47b3f4d9-82dc-4ab3-ea11-775bde742f48@xs4all.nl>
Date: Mon, 22 Aug 2016 13:56:39 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-5-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/media-device.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index a1cd50f..8bdc316 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -596,9 +596,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  			       &entity->pads[i].graph_obj);
>  
>  	/* invoke entity_notify callbacks */
> -	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
> -		(notify)->notify(entity, notify->notify_data);
> -	}
> +	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list)
> +		notify->notify(entity, notify->notify_data);
>  
>  	if (mdev->entity_internal_idx_max
>  	    >= mdev->pm_count_walk.ent_enum.idx_max) {
> 
