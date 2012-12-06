Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36506 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2LFKH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 05:07:27 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so339752wib.1
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2012 02:07:25 -0800 (PST)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv15 2/7] video: add display_timing and videomode
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
	devicetree-discuss@lists.ozlabs.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
In-Reply-To: <20121126153958.GA30791@pengutronix.de>
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de> <1353920848-1705-3-git-send-email-s.trumtrar@pengutronix.de> <50B36286.7010704@ti.com> <20121126153958.GA30791@pengutronix.de>
Date: Thu, 06 Dec 2012 10:07:18 +0000
Message-Id: <20121206100718.C5C263E0EA4@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Nov 2012 16:39:58 +0100, Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
> On Mon, Nov 26, 2012 at 02:37:26PM +0200, Tomi Valkeinen wrote:
> > On 2012-11-26 11:07, Steffen Trumtrar wrote:
> > 
> > > +/*
> > > + * Subsystem independent description of a videomode.
> > > + * Can be generated from struct display_timing.
> > > + */
> > > +struct videomode {
> > > +	u32 pixelclock;		/* pixelclock in Hz */
> > 
> > I don't know if this is of any importance, but the linux clock framework
> > manages clock rates with unsigned long. Would it be better to use the
> > same type here?
> > 
> 
> Hm, I don't know. Anyone? u32 should be large enough for a pixelclock.

4GHz is a pretty large pixel clock. I have no idea how conceivable it is
that hardware will get to that speed. However, if it will ever be
larger, then you'll need to account for that in the DT binding so that
the pixel clock can be specified using 2 cells.

g.
