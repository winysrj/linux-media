Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58705 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2JVHka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 03:40:30 -0400
Date: Mon, 22 Oct 2012 09:40:24 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Rob Herring <robherring2@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
Message-ID: <20121022074024.GB12967@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
 <20121020195950.GA13902@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121020195950.GA13902@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 20, 2012 at 09:59:51PM +0200, Thierry Reding wrote:
> On Thu, Oct 04, 2012 at 07:59:19PM +0200, Steffen Trumtrar wrote:
> [...]
> > diff --git a/include/linux/of_display_timings.h b/include/linux/of_display_timings.h
> [...]
> > +struct display_timings {
> > +	unsigned int num_timings;
> > +	unsigned int default_timing;
> > +
> > +	struct signal_timing **timings;
> > +};
> > +
> > +struct timing_entry {
> > +	u32 min;
> > +	u32 typ;
> > +	u32 max;
> > +};
> > +
> > +struct signal_timing {
> 
> I'm slightly confused by the naming here. signal_timing seems overly
> generic in this context. Is there any reason why this isn't called
> display_timing or even display_mode?
> 

You are right. I actually already changed that, for the same reasons.
It will be called display_timing in the next version, as I think that's what it really
is.

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
