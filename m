Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39989 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755279AbcKVJ7l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 04:59:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
Subject: Re: [RFC v4 04/21] media: Remove useless curly braces and parentheses
Date: Tue, 22 Nov 2016 11:59:58 +0200
Message-ID: <2803950.MCC7dsW08n@avalon>
In-Reply-To: <1478613330-24691-4-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com> <1478613330-24691-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 08 Nov 2016 15:55:13 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 0e07300..bb19c04 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -594,9 +594,8 @@ int __must_check media_device_register_entity(struct
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

