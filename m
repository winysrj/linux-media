Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50210 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2JEPvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 11:51:32 -0400
Date: Fri, 5 Oct 2012 17:51:21 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Message-ID: <20121005155121.GA2053@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-3-git-send-email-s.trumtrar@pengutronix.de>
 <506DDA94.1090702@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506DDA94.1090702@wwwdotorg.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 04, 2012 at 12:51:00PM -0600, Stephen Warren wrote:
> On 10/04/2012 11:59 AM, Steffen Trumtrar wrote:
> > Get videomode from devicetree in a format appropriate for the
> > backend. drm_display_mode and fb_videomode are supported atm.
> > Uses the display signal timings from of_display_timings
> 
> > +++ b/drivers/of/of_videomode.c
> 
> > +int videomode_from_timing(struct display_timings *disp, struct videomode *vm,
> 
> > +	st = display_timings_get(disp, index);
> > +
> > +	if (!st) {
> 
> It's a little odd to leave a blank line between those two lines.

Hm, well okay. That can be remedied

> 
> Only half of the code in this file seems OF-related; the routines to
> convert a timing to a videomode or drm display mode seem like they'd be
> useful outside device tree, so I wonder if putting them into
> of_videomode.c is the correct thing to do. Still, it's probably not a
> big deal.
> 

I am not sure, what the appropriate way to do this is. I can split it up (again).


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
