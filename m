Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41445 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2JGNhv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 09:37:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
	devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Date: Sun, 07 Oct 2012 15:38:33 +0200
Message-ID: <1865954.iaNNHHSnLW@avalon>
In-Reply-To: <20121005155121.GA2053@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <506DDA94.1090702@wwwdotorg.org> <20121005155121.GA2053@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

On Friday 05 October 2012 17:51:21 Steffen Trumtrar wrote:
> On Thu, Oct 04, 2012 at 12:51:00PM -0600, Stephen Warren wrote:
> > On 10/04/2012 11:59 AM, Steffen Trumtrar wrote:
> > > Get videomode from devicetree in a format appropriate for the
> > > backend. drm_display_mode and fb_videomode are supported atm.
> > > Uses the display signal timings from of_display_timings
> > > 
> > > +++ b/drivers/of/of_videomode.c
> > > 
> > > +int videomode_from_timing(struct display_timings *disp, struct
> > > videomode *vm,
> > > 
> > > +	st = display_timings_get(disp, index);
> > > +
> > > +	if (!st) {
> > 
> > It's a little odd to leave a blank line between those two lines.
> 
> Hm, well okay. That can be remedied
> 
> > Only half of the code in this file seems OF-related; the routines to
> > convert a timing to a videomode or drm display mode seem like they'd be
> > useful outside device tree, so I wonder if putting them into
> > of_videomode.c is the correct thing to do. Still, it's probably not a
> > big deal.
> 
> I am not sure, what the appropriate way to do this is. I can split it up
> (again).

I think it would make sense to move them to their respective subsystems.

-- 
Regards,

Laurent Pinchart
