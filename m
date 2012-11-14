Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2KNLKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 06:10:25 -0500
Date: Wed, 14 Nov 2012 12:10:15 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v8 1/6] video: add display_timing and videomode
Message-ID: <20121114111015.GB18579@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
 <20121114105634.GA31801@avionic-0098.mockup.avionic-design.de>
 <20121114105925.GA18579@pengutronix.de>
 <20121114110215.GA31999@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114110215.GA31999@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 12:02:15PM +0100, Thierry Reding wrote:
> On Wed, Nov 14, 2012 at 11:59:25AM +0100, Steffen Trumtrar wrote:
> > On Wed, Nov 14, 2012 at 11:56:34AM +0100, Thierry Reding wrote:
> > > On Mon, Nov 12, 2012 at 04:37:01PM +0100, Steffen Trumtrar wrote:
> > > [...]
> > > > diff --git a/drivers/video/display_timing.c b/drivers/video/display_timing.c
> > > [...]
> > > > +void display_timings_release(struct display_timings *disp)
> > > > +{
> > > > +	if (disp->timings) {
> > > > +		unsigned int i;
> > > > +
> > > > +		for (i = 0; i < disp->num_timings; i++)
> > > > +			kfree(disp->timings[i]);
> > > > +		kfree(disp->timings);
> > > > +	}
> > > > +	kfree(disp);
> > > > +}
> > > 
> > > I think this is still missing an EXPORT_SYMBOL_GPL. Otherwise it can't
> > > be used from modules.
> > > 
> > > Thierry
> > 
> > Yes. Just in time. I was just starting to type the send-email command ;-)
> 
> Great! In that case don't forget to also look at my other email before
> sending. =)
> 
Sure.


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
