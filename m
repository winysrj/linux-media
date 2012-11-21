Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59621 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2KUI23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 03:28:29 -0500
Date: Wed, 21 Nov 2012 09:28:22 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 0/6] of: add display helper
Message-ID: <20121121082822.GB14013@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1501232.SOApmW1MhU@avalon>
 <20121120181129.GI23204@pengutronix.de>
 <20121120193531.GB27186@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120193531.GB27186@avionic-0098.adnet.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 20, 2012 at 08:35:31PM +0100, Thierry Reding wrote:
> On Tue, Nov 20, 2012 at 07:11:29PM +0100, Robert Schwebel wrote:
> > On Tue, Nov 20, 2012 at 05:13:19PM +0100, Laurent Pinchart wrote:
> > > On Tuesday 20 November 2012 16:54:50 Steffen Trumtrar wrote:
> > > > Hi!
> > > > 
> > > > Changes since v11:
> > > > 	- make pointers const where applicable
> > > > 	- add reviewed-by Laurent Pinchart
> > > 
> > > Looks good to me.
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > Through which tree do you plan to push this ?
> > 
> > We have no idea yet, and none of the people on Cc: have volunteered
> > so far... what do you think?
> 
> The customary approach would be to take the patches through separate
> trees, but I think this particular series is sufficiently interwoven to
> warrant taking them all through one tree. However the least that we
> should do is collect Acked-by's from the other tree maintainers.
> 
> Given that most of the patches modify files in drivers/video, Florian's
> fbdev tree would be the most obvious candidate, right? If Florian agrees
> to take the patches, all we would need is David's Acked-by.
> 
> How does that sound?
> 
> Thierry

Hi!

That is exactly the way I thought this could happen.

Regards
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
