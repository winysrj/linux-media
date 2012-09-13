Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab2IMKQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
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
Date: Thu, 13 Sep 2012 03:40:40 +0200
Message-ID: <224585745.5E32B1Gv1v@avalon>
In-Reply-To: <20120904092446.GN24458@pengutronix.de>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <1345164583-18924-2-git-send-email-laurent.pinchart@ideasonboard.com> <20120904092446.GN24458@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Tuesday 04 September 2012 11:24:46 Sascha Hauer wrote:
> Hi Laurent,
> 
> On Fri, Aug 17, 2012 at 02:49:39AM +0200, Laurent Pinchart wrote:
> > +/**
> > + * panel_get_modes - Get video modes supported by the panel
> > + * @panel: The panel
> > + * @modes: Pointer to an array of modes
> > + *
> > + * Fill the modes argument with a pointer to an array of video modes. The
> > array
> > + * is owned by the panel.
> > + *
> > + * Return the number of supported modes on success (including 0 if no
> > mode is
> > + * supported) or a negative error code otherwise.
> > + */
> > +int panel_get_modes(struct panel *panel, const struct fb_videomode
> > **modes)
> > +{
> > +	if (!panel->ops || !panel->ops->get_modes)
> > +		return 0;
> > +
> > +	return panel->ops->get_modes(panel, modes);
> > +}
> > +EXPORT_SYMBOL_GPL(panel_get_modes);
> 
> You have seen my of videomode helper proposal. One result there was that
> we want to have ranges for the margin/synclen fields. Does it make sense
> to base this new panel framework on a more sophisticated internal
> reprentation of the panel parameters?

I think it does, yes. We need a common video mode structure, and the panel 
framework should use it. I'll try to rebase my patches on top of your 
proposal. Have you posted the latest version ?

> This could then be converted to struct fb_videomode / struct
> drm_display_mode as needed. This would also make it more suitable for drm
> drivers which are not interested in struct fb_videomode.
> 
> Related to this I suggest to change the API to be able to iterate over
> the different modes, like:
> 
> struct videomode *panel_get_mode(struct panel *panel, int num);
> 
> This was we do not have to have an array of modes in memory, which may
> be a burden for some panel drivers.

I currently have mixed feelings about this. Both approaches have pros and 
cons. Iterating over the modes would be more complex for drivers that use 
panels, and would be race-prone if the modes can change at runtime (OK, this 
isn't supported by the current panel API proposal).

-- 
Regards,

Laurent Pinchart

