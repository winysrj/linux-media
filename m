Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAD6C43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DE2D20645
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="LI7Bn2pb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391477AbfAOXlJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:41:09 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49356 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387904AbfAOXlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:41:09 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2DD5F530;
        Wed, 16 Jan 2019 00:41:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547595667;
        bh=rzYwbT3ncIJG6E/Ps1zHvZ8RveUMpOqLysavPfoXioA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LI7Bn2pbSYDtHFkFdWowjlyMOloTkpAD2QzLmqVZXgIKVUtGjJHd58Hd9pxSHarrN
         uxrzbST8PSJ8Pj6Y8zGgAgmN0RHgSbLqPSu1cz8g/OnqDvCund4XQa2BO6dD/bW3an
         WsklVUNh7ggB0ECKGbJRmKfwAXfomoJ5M9VsgbNs=
Date:   Wed, 16 Jan 2019 01:41:08 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 15/30] media: entity: Look for indirect routes
Message-ID: <20190115234108.GE31088@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-16-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-16-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:29AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Two pads are considered having an active route for the purpose of
> has_route() if an indirect active route can be found between the two pads.
> An simple example of this is that a source pad has an active route to
> another source pad if both of the pads have an active route to the same
> sink pad.
> 
> Make media_entity_has_route() return true in that case, and do not rely on
> drivers performing this by themselves.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/media-entity.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 42977634d7102852..e45fc2549017615a 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -240,6 +240,9 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
>  bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
>  			    unsigned int pad1)
>  {
> +	unsigned int i;
> +	bool has_route;
> +
>  	if (pad0 >= entity->num_pads || pad1 >= entity->num_pads)
>  		return false;
>  
> @@ -253,7 +256,34 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
>  	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
>  		swap(pad0, pad1);
>  
> -	return entity->ops->has_route(entity, pad0, pad1);
> +	has_route = entity->ops->has_route(entity, pad0, pad1);
> +	/* A direct route is returned immediately */
> +	if (has_route ||
> +	    (entity->pads[pad0].flags & MEDIA_PAD_FL_SINK &&
> +	     entity->pads[pad1].flags & MEDIA_PAD_FL_SOURCE))
> +		return true;

This will return true if pad0 is a sink and pad1 a source, regardless of
has_route. I don't think that was intended. return has_route; would be
an easy fix.

> +
> +	/* Look for indirect routes */
> +	for (i = 0; i < entity->num_pads; i++) {
> +		if (i == pad0 || i == pad1)
> +			continue;
> +
> +		/*
> +		 * There are no direct routes between same types of
> +		 * pads, so skip checking this route
> +		 */
> +		if (!((entity->pads[pad0].flags ^ entity->pads[i].flags) &
> +		      (MEDIA_PAD_FL_SOURCE | MEDIA_PAD_FL_SINK)))
> +			continue;
> +
> +		/* Is there an indirect route? */
> +		if (entity->ops->has_route(entity, i, pad0) &&
> +		    entity->ops->has_route(entity, i, pad1))
> +			return true;
> +	}

Isn't this best implemented in drivers ? I fear the complexity you need
here isn't worth it, especially given that you would also need to
support cases such as

Pads 0, 1 and 2 are sink, pads 3 and 4 are sources. has_route(0, 3),
has_route(1, 3), has_route(1, 4) and has_route(2, 4) are all true,
has_route(0, 4) and has_route(2, 3) are all false.
media_entity_has_route(0, 2) should return true.

> +	return false;
> +
>  }
>  EXPORT_SYMBOL_GPL(media_entity_has_route);
>  

-- 
Regards,

Laurent Pinchart
