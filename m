Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44137 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdB1Nng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:43:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/6] media: Remove useless curly braces and parentheses
Date: Tue, 28 Feb 2017 15:42:33 +0200
Message-ID: <2466463.oxEMyDkfDD@avalon>
In-Reply-To: <1487604142-27610-6-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com> <1487604142-27610-6-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 20 Feb 2017 17:22:21 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 760e3e4..c51e2e5 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -591,9 +591,8 @@ int __must_check media_device_register_entity(struct
> media_device *mdev, &entity->pads[i].graph_obj);
> 
>  	/* invoke entity_notify callbacks */
> -	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
> -		(notify)->notify(entity, notify->notify_data);
> -	}
> +	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list)
> +		notify->notify(entity, notify->notify_data);
> 
>  	if (mdev->entity_internal_idx_max
> 
>  	    >= mdev->pm_count_walk.ent_enum.idx_max) {

-- 
Regards,

Laurent Pinchart
