Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F17AC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADD0120866
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="H5/aWrvG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfAOXNj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:13:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49134 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbfAOXNj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:13:39 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9F887530;
        Wed, 16 Jan 2019 00:13:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547594016;
        bh=uR5Q58gkz0Z+yX+Lf84SMa+SJhmnoeVjgNaGPgoZ6/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H5/aWrvGy1B7a+HouQa5S8wnvSl12ZS5P6aZajp59/t4xfswoqEv60Laf1FmnbUNR
         HH5h7Jy1ofSKFeW1H+4Nt03R9glsr63YedIsAz6mc+KFJnBRwmI1VdaMWLKn67H14/
         sDqnuy7rdgIZ1OqQO09ApvoFJmV7arNGqYdb8XRA=
Date:   Wed, 16 Jan 2019 01:13:37 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 11/30] media: entity: Skip link validation for pads to
 which there is no route to
Message-ID: <20190115231337.GI28397@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-12-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-12-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:25AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Links are validated along the pipeline which is about to start streaming.
> Not all the pads in entities that are traversed along that pipeline are
> part of the pipeline, however. Skip the link validation for such pads.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-entity.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 4d10bc186e1e7a10..cdf3805dec755ec5 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -493,6 +493,11 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
>  			struct media_pad *other_pad = link->sink->entity == entity
>  				? link->sink : link->source;
>  
> +			/* Ignore pads to which there is no route. */
> +			if (!media_entity_has_route(entity, pad->index,
> +						    other_pad->index))
> +				continue;
> +
>  			/* Mark that a pad is connected by a link. */
>  			bitmap_clear(has_no_links, other_pad->index, 1);
>  

-- 
Regards,

Laurent Pinchart
