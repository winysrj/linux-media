Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F89C43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E831320896
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="jnsgllBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391428AbfAOXYH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:24:07 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49200 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfAOXYH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:24:07 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 92335530;
        Wed, 16 Jan 2019 00:24:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547594644;
        bh=sDkKmaBujt27jMk8+S1qnYZfRIPYi7y9/6kUReHJO8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jnsgllBfCNlTlnfBYFYKwDKW06yb4Wk/Vmqt3N50E9uI1ToG4PzgsPil6x1kiXrGX
         Ye1e5XN1+fGNQs4KEi1LqNTtcVbhhX3RS2PzdkLVWcp77EbCPO9fSrrNffMd2wDbUq
         Em5eOL5aC9KaKdBUHXldu8Im/837IirdC+ENaiS4=
Date:   Wed, 16 Jan 2019 01:24:05 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 12/30] media: entity: Add an iterator helper for
 connected pads
Message-ID: <20190115232405.GA31088@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-13-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-13-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:26AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Add a helper macro for iterating over pads that are connected through
> enabled routes. This can be used to find all the connected pads within an
> entity, for instance starting from the pad which has been obtained during
> the graph walk.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  include/media/media-entity.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 9540d2af80f19805..4bb1b568e1ac4795 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -936,6 +936,33 @@ __must_check int media_graph_walk_init(
>  bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
>  			    unsigned int pad1);
>  
> +static inline struct media_pad *__media_entity_for_routed_pads_next(
> +	struct media_pad *start, struct media_pad *iter)
> +{
> +	struct media_entity *entity = start->entity;
> +
> +	while (iter < &entity->pads[entity->num_pads] &&
> +	       !media_entity_has_route(entity, start->index, iter->index))
> +		iter++;
> +
> +	return iter;

Returning a pointer past the end of the array is asking for trouble. I
think we should return NULL in that case, and adapt the check in
media_entity_for_routed_pads() accordingly.

> +}
> +
> +/**
> + * media_entity_for_routed_pads - Iterate over entity pads connected by routes
> + *
> + * @start: The stating pad

s/stating/starting/

> + * @iter: The iterator pad
> + *
> + * Iterate over all pads connected through routes from a given pad
> + * within an entity. The iteration will include the starting pad itself.
> + */
> +#define media_entity_for_routed_pads(start, iter)			\

Maybe media_entity_for_each_routed_pad() ? Or just
for_each_entity_routed_pad() ?

> +	for (iter = __media_entity_for_routed_pads_next(		\

And how about __media_entity_next_routed_pad() ?

> +		     start, (start)->entity->pads);			\
> +	     iter < &(start)->entity->pads[(start)->entity->num_pads];	\
> +	     iter = __media_entity_for_routed_pads_next(start, iter + 1))
> +
>  /**
>   * media_graph_walk_cleanup - Release resources used by graph walk.
>   *

-- 
Regards,

Laurent Pinchart
