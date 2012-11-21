Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56190 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2KUNRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 08:17:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
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
Date: Wed, 21 Nov 2012 14:18:05 +0100
Message-ID: <2518217.KnCDQR760l@avalon>
In-Reply-To: <20121121082822.GB14013@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <20121120193531.GB27186@avionic-0098.adnet.avionic-design.de> <20121121082822.GB14013@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 November 2012 09:28:22 Steffen Trumtrar wrote:
> On Tue, Nov 20, 2012 at 08:35:31PM +0100, Thierry Reding wrote:
> > On Tue, Nov 20, 2012 at 07:11:29PM +0100, Robert Schwebel wrote:
> > > On Tue, Nov 20, 2012 at 05:13:19PM +0100, Laurent Pinchart wrote:
> > > > On Tuesday 20 November 2012 16:54:50 Steffen Trumtrar wrote:
> > > > > Hi!
> > > > > 
> > > > > Changes since v11:
> > > > > 	- make pointers const where applicable
> > > > > 	- add reviewed-by Laurent Pinchart
> > > > 
> > > > Looks good to me.
> > > > 
> > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > 
> > > > Through which tree do you plan to push this ?
> > > 
> > > We have no idea yet, and none of the people on Cc: have volunteered
> > > so far... what do you think?
> > 
> > The customary approach would be to take the patches through separate
> > trees, but I think this particular series is sufficiently interwoven to
> > warrant taking them all through one tree. However the least that we
> > should do is collect Acked-by's from the other tree maintainers.
> > 
> > Given that most of the patches modify files in drivers/video, Florian's
> > fbdev tree would be the most obvious candidate, right? If Florian agrees
> > to take the patches, all we would need is David's Acked-by.
> > 
> > How does that sound?
> > 
> > Thierry
> 
> Hi!
> 
> That is exactly the way I thought this could happen.

Sounds good to me as well.

-- 
Regards,

Laurent Pinchart

