Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDFAC282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD87217FA
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfAVP4F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:56:05 -0500
Received: from mga06.intel.com ([134.134.136.31]:16330 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbfAVP4F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:56:05 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 07:56:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="116515534"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jan 2019 07:56:02 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 84529205C8; Tue, 22 Jan 2019 17:56:01 +0200 (EET)
Date:   Tue, 22 Jan 2019 17:56:01 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 15/30] media: entity: Look for indirect routes
Message-ID: <20190122155600.xb7jtgcll6brdpjj@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-16-niklas.soderlund+renesas@ragnatech.se>
 <20190115234108.GE31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115234108.GE31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Jan 16, 2019 at 01:41:08AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:29AM +0100, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Two pads are considered having an active route for the purpose of
> > has_route() if an indirect active route can be found between the two pads.
> > An simple example of this is that a source pad has an active route to
> > another source pad if both of the pads have an active route to the same
> > sink pad.
> > 
> > Make media_entity_has_route() return true in that case, and do not rely on
> > drivers performing this by themselves.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/media-entity.c | 32 +++++++++++++++++++++++++++++++-
> >  1 file changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 42977634d7102852..e45fc2549017615a 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -240,6 +240,9 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
> >  bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> >  			    unsigned int pad1)
> >  {
> > +	unsigned int i;
> > +	bool has_route;
> > +
> >  	if (pad0 >= entity->num_pads || pad1 >= entity->num_pads)
> >  		return false;
> >  
> > @@ -253,7 +256,34 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> >  	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> >  		swap(pad0, pad1);
> >  
> > -	return entity->ops->has_route(entity, pad0, pad1);
> > +	has_route = entity->ops->has_route(entity, pad0, pad1);
> > +	/* A direct route is returned immediately */
> > +	if (has_route ||
> > +	    (entity->pads[pad0].flags & MEDIA_PAD_FL_SINK &&
> > +	     entity->pads[pad1].flags & MEDIA_PAD_FL_SOURCE))
> > +		return true;
> 
> This will return true if pad0 is a sink and pad1 a source, regardless of
> has_route. I don't think that was intended. return has_route; would be
> an easy fix.

Good find. Yes, I think the condition apart from has_route itself is to be
dropped.

> 
> > +
> > +	/* Look for indirect routes */
> > +	for (i = 0; i < entity->num_pads; i++) {
> > +		if (i == pad0 || i == pad1)
> > +			continue;
> > +
> > +		/*
> > +		 * There are no direct routes between same types of
> > +		 * pads, so skip checking this route
> > +		 */
> > +		if (!((entity->pads[pad0].flags ^ entity->pads[i].flags) &
> > +		      (MEDIA_PAD_FL_SOURCE | MEDIA_PAD_FL_SINK)))
> > +			continue;
> > +
> > +		/* Is there an indirect route? */
> > +		if (entity->ops->has_route(entity, i, pad0) &&
> > +		    entity->ops->has_route(entity, i, pad1))
> > +			return true;
> > +	}
> 
> Isn't this best implemented in drivers ? I fear the complexity you need
> here isn't worth it, especially given that you would also need to
> support cases such as
> 
> Pads 0, 1 and 2 are sink, pads 3 and 4 are sources. has_route(0, 3),
> has_route(1, 3), has_route(1, 4) and has_route(2, 4) are all true,
> has_route(0, 4) and has_route(2, 3) are all false.
> media_entity_has_route(0, 2) should return true.

Yes, this is not entirely generic, but it'd cover the vast majority of the
cases. It needs to be documented as such. I'd keep it, to avoid drivers
from having to cope with checks for two source pads when both are routed to
a common sink. I presume this is one of the most common cases. I'm also
fine with dropping it for now, to keep the API simple. But we should then
reconsider this if that'd simplify drivers.

> 
> > +	return false;
> > +
> >  }
> >  EXPORT_SYMBOL_GPL(media_entity_has_route);
> >  
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
