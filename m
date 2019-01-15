Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE337C43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52CB20866
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Pv5yLhzK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391096AbfAOWHQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:07:16 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48690 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390958AbfAOWHO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 17:07:14 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5339E530;
        Tue, 15 Jan 2019 23:07:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547590032;
        bh=cAzNYW0paCEC9dI7jqdo+KOhIYakFhSYcZjwqUNESgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pv5yLhzKB6CR1dp5xRDcy5OHSy7Gdxc6FsyUm+hO82gkHBr8msFCgPc+u73WZbAcG
         F9TLd4JEnL9hxc2ZGGkeAeVG6vCrfX8m2S88FqzyqBa1h/4tM0ELkoAOaRqkLFpXRA
         4KsI3GXeG6FgbDjwVu6LcAdjWKp10afyy56nheio=
Date:   Wed, 16 Jan 2019 00:07:13 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 02/30] media: entity: Use pads instead of entities in
 the media graph walk stack
Message-ID: <20190115220713.GC28397@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-3-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Another small comment.

On Fri, Nov 02, 2018 at 12:31:16AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Change the media graph walk stack structure to use media pads instead of
> using media entities. In addition to the entity, the pad contains the
> information which pad in the entity are being dealt with.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/media-entity.c | 53 ++++++++++++++++++------------------
>  include/media/media-entity.h |  6 ++--
>  2 files changed, 29 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 2bbc07de71aa5e6d..892e64a0a9d8ec42 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -237,40 +237,39 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
>   * Graph traversal
>   */
>  
> -static struct media_entity *
> -media_entity_other(struct media_entity *entity, struct media_link *link)
> +static struct media_pad *
> +media_entity_other(struct media_pad *pad, struct media_link *link)

Shouldn't this now be called media_pad_other() ?

>  {
> -	if (link->source->entity == entity)
> -		return link->sink->entity;
> +	if (link->source == pad)
> +		return link->sink;
>  	else
> -		return link->source->entity;
> +		return link->source;
>  }

[snip]

-- 
Regards,

Laurent Pinchart
