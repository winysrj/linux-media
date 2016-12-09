Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50217 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933390AbcLIPTV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 10:19:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH v2 5/9] media: Use single quotes to quote entity names
Date: Fri, 09 Dec 2016 17:19:46 +0200
Message-ID: <2728859.u4HyMZ8Mmz@avalon>
In-Reply-To: <1481295222-14743-6-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com> <1481295222-14743-6-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 09 Dec 2016 16:53:38 Sakari Ailus wrote:
> Instead of double quotes, use single quotes to quote entity names. Using
> single quotes is consistent with the English language and is also in line
> with the practices across the kernel.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-entity.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 1de28ce..5064ba0 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -444,7 +444,7 @@ __must_check int __media_pipeline_start(struct
> media_entity *entity, ret = entity->ops->link_validate(link);
>  			if (ret < 0 && ret != -ENOIOCTLCMD) {
>  				dev_dbg(entity->graph_obj.mdev->dev,
> -					"link validation failed for \"%s\":%u 
-> \"%s\":%u, error %d\n",
> +					"link validation failed for '%s':%u -> 
'%s':%u, error %d\n",
>  					link->source->entity->name,
>  					link->source->index,
>  					entity->name, link->sink->index, ret);
> @@ -458,7 +458,7 @@ __must_check int __media_pipeline_start(struct
> media_entity *entity, if (!bitmap_full(active, entity->num_pads)) {
>  			ret = -ENOLINK;
>  			dev_dbg(entity->graph_obj.mdev->dev,
> -				"\"%s\":%u must be connected by an enabled 
link\n",
> +				"'%s':%u must be connected by an enabled 
link\n",
>  				entity->name,
>  				(unsigned)find_first_zero_bit(
>  					active, entity->num_pads));

-- 
Regards,

Laurent Pinchart

