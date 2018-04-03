Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33794 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbeDCOzC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 10:55:02 -0400
Received: by mail-lf0-f49.google.com with SMTP id c78-v6so20669573lfh.1
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2018 07:55:01 -0700 (PDT)
Date: Tue, 3 Apr 2018 16:54:59 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v7 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180403145458.GL26532@bigcity.dyn.berto.se>
References: <20180326133456.16584-1-maxime.ripard@bootlin.com>
 <20180326133456.16584-3-maxime.ripard@bootlin.com>
 <20180329123534.GB26532@bigcity.dyn.berto.se>
 <20180403134859.73r3usnf6foyxncu@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180403134859.73r3usnf6foyxncu@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On 2018-04-03 15:48:59 +0200, Maxime Ripard wrote:
> Hi Niklas,
> 
> On Thu, Mar 29, 2018 at 02:35:34PM +0200, Niklas Söderlund wrote:
> > > +	/*
> > > +	 * Create a static mapping between the CSI virtual channels
> > > +	 * and the input streams.
> > > +	 *
> > > +	 * This should be enhanced, but v4l2 lacks the support for
> > > +	 * changing that mapping dynamically at the moment.
> > > +	 *
> > > +	 * We're protected from the userspace setting up links at the
> > > +	 * same time by the upper layer having called
> > > +	 * media_pipeline_start().
> > > +	 */
> > > +	list_for_each_entry(link, &entity->links, list) {
> > 
> > I wonder is this list_for_each_entry() really needed? Can't you simply 
> > iterate over all sink pads as with the loop bellow but drop the pad == 
> > link->sink check? Maybe I'm missing something.
> 
> This was a review made by Sakari here:
> https://patchwork.linuxtv.org/patch/44422/
> 
> The idea is that we need to know if the pad is enabled, and as far as
> I know this information is only stored at the link level, not at the
> pad level.

Ahh I see, you are correct.

> 
> > Apart from this and the small nit-picks (one more bellow) I think this 
> > patch is fine. Once I understand this I be happy to add my tag to this 
> > change, great work!
> 
> Is this a reviewed by? :)

Yes, I now understand what I did not before :-) Feel free to add my

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> 
> > I also think you shall consider to add a MAINTAINERS record for the RX 
> > and TX drivers. Maybe one entry for both drivers as they live in the 
> > same directory but I think one of the two should add it :-)
> 
> Right, I'll do it, thanks!
> Maxime
> 
> -- 
> Maxime Ripard, Bootlin (formerly Free Electrons)
> Embedded Linux and Kernel engineering
> https://bootlin.com



-- 
Regards,
Niklas Söderlund
