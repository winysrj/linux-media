Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745A6C282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 425F82054F
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="pcfvrgfv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfAVPiu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:38:50 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49868 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbfAVPiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:38:50 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7118053E;
        Tue, 22 Jan 2019 16:38:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1548171528;
        bh=SIpxkrTqT21QwTlsV128R3cPJru1761JgPUI7ORlJys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pcfvrgfvKZHd/uat8U2ZQbe/Gl2FR12VGFft6lPIMZZeCZUcr5SZ8ZWlVvnU3DB7k
         g2YOKqRN17nRZFuVhVJJ7Ecd0Z6ErPduUf3vXu5aESlM+hv+BEUJYOmnzUxcbz2smM
         XEgppax17o/MW9uEgdcCgfEc229P13pkqQM46y44=
Date:   Tue, 22 Jan 2019 17:38:48 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 12/30] media: entity: Add an iterator helper for
 connected pads
Message-ID: <20190122153848.GD11461@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-13-niklas.soderlund+renesas@ragnatech.se>
 <20190115232405.GA31088@pendragon.ideasonboard.com>
 <20190122153655.q3p3k2zpxtoug4qe@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190122153655.q3p3k2zpxtoug4qe@paasikivi.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Tue, Jan 22, 2019 at 05:36:55PM +0200, Sakari Ailus wrote:
> On Wed, Jan 16, 2019 at 01:24:05AM +0200, Laurent Pinchart wrote:
> > On Fri, Nov 02, 2018 at 12:31:26AM +0100, Niklas Söderlund wrote:
> >> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> 
> >> Add a helper macro for iterating over pads that are connected through
> >> enabled routes. This can be used to find all the connected pads within an
> >> entity, for instance starting from the pad which has been obtained during
> >> the graph walk.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >> ---
> >>  include/media/media-entity.h | 27 +++++++++++++++++++++++++++
> >>  1 file changed, 27 insertions(+)
> >> 
> >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> >> index 9540d2af80f19805..4bb1b568e1ac4795 100644
> >> --- a/include/media/media-entity.h
> >> +++ b/include/media/media-entity.h
> >> @@ -936,6 +936,33 @@ __must_check int media_graph_walk_init(
> >>  bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> >>  			    unsigned int pad1);
> >>  
> >> +static inline struct media_pad *__media_entity_for_routed_pads_next(
> >> +	struct media_pad *start, struct media_pad *iter)
> >> +{
> >> +	struct media_entity *entity = start->entity;
> >> +
> >> +	while (iter < &entity->pads[entity->num_pads] &&
> >> +	       !media_entity_has_route(entity, start->index, iter->index))
> >> +		iter++;
> >> +
> >> +	return iter;
> > 
> > Returning a pointer past the end of the array is asking for trouble. I
> > think we should return NULL in that case, and adapt the check in
> > media_entity_for_routed_pads() accordingly.
> 
> Well, that pointer never gets used, in a similar manner than simply looping
> over an array. I wouldn't change that --- this function is also integrally
> a part of media_entity_for_each_routed_pad() implementation below.

I know it doesn't get used, but it's still asking for trouble, it will
be easy to use it by mistake. Returning NULL would be clearer.

> >> +}
> >> +
> >> +/**
> >> + * media_entity_for_routed_pads - Iterate over entity pads connected by routes
> >> + *
> >> + * @start: The stating pad
> > 
> > s/stating/starting/
> > 
> >> + * @iter: The iterator pad
> >> + *
> >> + * Iterate over all pads connected through routes from a given pad
> >> + * within an entity. The iteration will include the starting pad itself.
> >> + */
> >> +#define media_entity_for_routed_pads(start, iter)			\
> > 
> > Maybe media_entity_for_each_routed_pad() ? Or just
> 
> I'd prefer this one: we have media_entity_ prefix for pretty much
> everything that handles entities.

It's a bit long, but OK.

> > for_each_entity_routed_pad() ?
> > 
> >> +	for (iter = __media_entity_for_routed_pads_next(		\
> > 
> > And how about __media_entity_next_routed_pad() ?
> 
> Yes.
> 
> > 
> >> +		     start, (start)->entity->pads);			\
> >> +	     iter < &(start)->entity->pads[(start)->entity->num_pads];	\
> >> +	     iter = __media_entity_for_routed_pads_next(start, iter + 1))
> >> +
> >>  /**
> >>   * media_graph_walk_cleanup - Release resources used by graph walk.
> >>   *

-- 
Regards,

Laurent Pinchart
