Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36384 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755284AbdCGN77 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 08:59:59 -0500
Received: by mail-lf0-f41.google.com with SMTP id y193so1173795lfd.3
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 05:59:41 -0800 (PST)
Date: Tue, 7 Mar 2017 12:15:51 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: entity: Swap pads if route is checked from
 source to sink
Message-ID: <20170307111551.GJ20587@bigcity.dyn.berto.se>
References: <1478599875-27700-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1478599875-27700-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On 2016-11-08 12:11:15 +0200, Sakari Ailus wrote:
> This way the pads are always passed to the has_route() op sink pad first.
> Makes sense.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Niklas,
> 
> This should make it easier to implement the has_route() op in drivers.
> 
> Feel free to merge this to "[PATCH 02/32] media: entity: Add
> media_entity_has_route() function" if you like, or add separately after
> the second patch.

I choose to append this as a separated patch on top of Laurents patches 
and include all 3 in my next R-Car VIN series.

> 
>  drivers/media/media-entity.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 747adcb..520f3f6 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -254,6 +254,10 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
>  	if (!entity->ops || !entity->ops->has_route)
>  		return true;
>  
> +	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
> +	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> +		swap(pad0, pad1);
> +
>  	return entity->ops->has_route(entity, pad0, pad1);
>  }
>  EXPORT_SYMBOL_GPL(media_entity_has_route);
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
