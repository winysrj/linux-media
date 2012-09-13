Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49548 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628Ab2IMLaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 07:30:00 -0400
Date: Thu, 13 Sep 2012 13:29:54 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC 1/5] video: Add generic display panel core
Message-ID: <20120913112954.GI6180@pengutronix.de>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1345164583-18924-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120904092446.GN24458@pengutronix.de>
 <224585745.5E32B1Gv1v@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <224585745.5E32B1Gv1v@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2012 at 03:40:40AM +0200, Laurent Pinchart wrote:
> Hi Sascha,
> 
> > > +int panel_get_modes(struct panel *panel, const struct fb_videomode
> > > **modes)
> > > +{
> > > +	if (!panel->ops || !panel->ops->get_modes)
> > > +		return 0;
> > > +
> > > +	return panel->ops->get_modes(panel, modes);
> > > +}
> > > +EXPORT_SYMBOL_GPL(panel_get_modes);
> > 
> > You have seen my of videomode helper proposal. One result there was that
> > we want to have ranges for the margin/synclen fields. Does it make sense
> > to base this new panel framework on a more sophisticated internal
> > reprentation of the panel parameters?
> 
> I think it does, yes. We need a common video mode structure, and the panel 
> framework should use it. I'll try to rebase my patches on top of your 
> proposal. Have you posted the latest version ?

V2 is the newest version. I'd like to implement ranges for the display
timings which then makes for a new common video mode structure, which
then could be used by drm and fbdev, probably with helper functions to
convert from common videomode to drm/fbdev specific variants.

> 
> > This could then be converted to struct fb_videomode / struct
> > drm_display_mode as needed. This would also make it more suitable for drm
> > drivers which are not interested in struct fb_videomode.
> > 
> > Related to this I suggest to change the API to be able to iterate over
> > the different modes, like:
> > 
> > struct videomode *panel_get_mode(struct panel *panel, int num);
> > 
> > This was we do not have to have an array of modes in memory, which may
> > be a burden for some panel drivers.
> 
> I currently have mixed feelings about this. Both approaches have pros and 
> cons. Iterating over the modes would be more complex for drivers that use 
> panels, and would be race-prone if the modes can change at runtime (OK, this 
> isn't supported by the current panel API proposal).

I just remember that the array approach was painful when I worked on an
fbdev driver some time ago. There some possible modes came from platform_data,
other modes were default modes in the driver and all had to be merged
into a single array. I don't remember the situation exactly, but it
would have been simpler if it had been a list instead of an array.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
