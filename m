Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E569C282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49EA9217F4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfAVPg7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:36:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:29701 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728699AbfAVPg7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:36:59 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 07:36:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="129775748"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2019 07:36:56 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 01E57205C8; Tue, 22 Jan 2019 17:36:55 +0200 (EET)
Date:   Tue, 22 Jan 2019 17:36:55 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 12/30] media: entity: Add an iterator helper for
 connected pads
Message-ID: <20190122153655.q3p3k2zpxtoug4qe@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-13-niklas.soderlund+renesas@ragnatech.se>
 <20190115232405.GA31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115232405.GA31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Jan 16, 2019 at 01:24:05AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:26AM +0100, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Add a helper macro for iterating over pads that are connected through
> > enabled routes. This can be used to find all the connected pads within an
> > entity, for instance starting from the pad which has been obtained during
> > the graph walk.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  include/media/media-entity.h | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 9540d2af80f19805..4bb1b568e1ac4795 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -936,6 +936,33 @@ __must_check int media_graph_walk_init(
> >  bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> >  			    unsigned int pad1);
> >  
> > +static inline struct media_pad *__media_entity_for_routed_pads_next(
> > +	struct media_pad *start, struct media_pad *iter)
> > +{
> > +	struct media_entity *entity = start->entity;
> > +
> > +	while (iter < &entity->pads[entity->num_pads] &&
> > +	       !media_entity_has_route(entity, start->index, iter->index))
> > +		iter++;
> > +
> > +	return iter;
> 
> Returning a pointer past the end of the array is asking for trouble. I
> think we should return NULL in that case, and adapt the check in
> media_entity_for_routed_pads() accordingly.

Well, that pointer never gets used, in a similar manner than simply looping
over an array. I wouldn't change that --- this function is also integrally
a part of media_entity_for_each_routed_pad() implementation below.

> 
> > +}
> > +
> > +/**
> > + * media_entity_for_routed_pads - Iterate over entity pads connected by routes
> > + *
> > + * @start: The stating pad
> 
> s/stating/starting/
> 
> > + * @iter: The iterator pad
> > + *
> > + * Iterate over all pads connected through routes from a given pad
> > + * within an entity. The iteration will include the starting pad itself.
> > + */
> > +#define media_entity_for_routed_pads(start, iter)			\
> 
> Maybe media_entity_for_each_routed_pad() ? Or just

I'd prefer this one: we have media_entity_ prefix for pretty much
everything that handles entities.

> for_each_entity_routed_pad() ?
> 
> > +	for (iter = __media_entity_for_routed_pads_next(		\
> 
> And how about __media_entity_next_routed_pad() ?

Yes.

> 
> > +		     start, (start)->entity->pads);			\
> > +	     iter < &(start)->entity->pads[(start)->entity->num_pads];	\
> > +	     iter = __media_entity_for_routed_pads_next(start, iter + 1))
> > +
> >  /**
> >   * media_graph_walk_cleanup - Release resources used by graph walk.
> >   *
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
