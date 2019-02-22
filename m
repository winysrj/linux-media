Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA228C4360F
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 12:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADBA2075A
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 12:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="nf+lgo16"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfBVMSS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:18:18 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:34226 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVMSS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 07:18:18 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B505E2D2;
        Fri, 22 Feb 2019 13:18:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550837895;
        bh=mdlTJH2DBAeJPNW7NoySfBriTGhwjqjAkYPkrV4Esbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nf+lgo16icFCjqsJ4NlNMaHnS7YP7RAdylI0BTRaWfUbKu6uN56DS9j0PQ3Hs6t15
         ICWKhWE7T9VG8rq7/LR7Et/SXxOzm7UcjGCgTYBUJDVM5sjmljaj72/5nLdSuJyFjP
         qZ/eLGkvic7gtLRZ5eC1c7EqWFX4DKn3KfPNTLKU=
Date:   Fri, 22 Feb 2019 14:18:11 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 09/30] media: entity: Swap pads if route is checked
 from source to sink
Message-ID: <20190222121811.GU3522@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
 <20190115225743.GH28397@pendragon.ideasonboard.com>
 <20190122151506.fnlfvwtoq7qunz45@paasikivi.fi.intel.com>
 <20190122152030.GB11461@pendragon.ideasonboard.com>
 <20190218092107.omddljghnv3l2ss6@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190218092107.omddljghnv3l2ss6@uno.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Mon, Feb 18, 2019 at 10:21:07AM +0100, Jacopo Mondi wrote:
> On Tue, Jan 22, 2019 at 05:20:30PM +0200, Laurent Pinchart wrote:
> > On Tue, Jan 22, 2019 at 05:15:06PM +0200, Sakari Ailus wrote:
> >> On Wed, Jan 16, 2019 at 12:57:43AM +0200, Laurent Pinchart wrote:
> >>>>
> >>>> This way the pads are always passed to the has_route() op sink pad first.
> >>>> Makes sense.
> >>>
> >>> Is there anything in the API that mandates one pad to be a sink and the
> >>> other pad to the a source ? I had designed the operation to allow
> >>> sink-sink and source-source connections to be checked too.
> >>
> >> Do you have a use case in mind for sink--sink or source--source routes? The
> >> routes are about flows of data, so I'd presume only source--sink or
> >> sink--source routes are meaningful.
> >>
> >> If you did, then the driver would have to handle that by itself. This still
> >> simplifies the implementation for drivers that do not.
> >
> > I don't have use cases for such routes, but we use the has_route
> > operation when traversing pipelines, and at that point we need to get
> > all the internally connected pads. In another patch in this series you
> > implement a helper function that handles this, but its implementation
> > isn't complete. I explained in my review of that patch that I fear a
> > correct generic implementation would become quite complex, while the
> > complexity should be easy to handle on the driver side as the code can
> > then be specialized for the case at hand.
> >
> 
> As a compromise, in v3 I'm thinking of maintaining support for the
> most common case of two sources connected to the same sink, as
> Sakari's patch does, but let more complex cases be handled by the
> driver implementation of has_route().
> 
> Ack?

I fear this will be confusing for subdevs, as they would have to
implement part of the operation.

Could it be that the subdev has_route operation isn't the best API for
the job, if it gets that complex ? I wonder if it would be easier to
create another operation that takes a pad index as argument, and returns
the list of pads (possibly as a bitmask ?) or connected pads.
media_entity_has_route() could easily be implemented on top of that, and
these new semantics may be easier for subdevs to implement.

> >>> If your goal is to simplify the implementation of the .has_route()
> >>> operation in drivers, I would instead sort pad0 and pad1 by value.
> >>
> >> That'd be another option to make the order deterministic for the driver.
> >> I'm fine with that as well.
> 
> In v3 I have taken both suggestions in: try the "sink then source" order
> first, then order by index in case the pads are of the same time. This
> needs to be documented in has_route() operation definition though.
> 
> Would that be fine with you?

I think that's the worst of both worlds from a subdev point of view :-)

> >>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >>>> ---
> >>>>  drivers/media/media-entity.c | 4 ++++
> >>>>  1 file changed, 4 insertions(+)
> >>>>
> >>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> >>>> index 3c0e7425c8983b45..33f00e35ccd92c6f 100644
> >>>> --- a/drivers/media/media-entity.c
> >>>> +++ b/drivers/media/media-entity.c
> >>>> @@ -249,6 +249,10 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> >>>>  	if (!entity->ops || !entity->ops->has_route)
> >>>>  		return true;
> >>>>
> >>>> +	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
> >>>> +	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> >>>> +		swap(pad0, pad1);
> >>>> +
> >>>>  	return entity->ops->has_route(entity, pad0, pad1);
> >>>>  }
> >>>>  EXPORT_SYMBOL_GPL(media_entity_has_route);

-- 
Regards,

Laurent Pinchart
