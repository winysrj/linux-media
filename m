Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57530 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2IDJYw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 05:24:52 -0400
Date: Tue, 4 Sep 2012 11:24:46 +0200
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
Message-ID: <20120904092446.GN24458@pengutronix.de>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1345164583-18924-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345164583-18924-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Aug 17, 2012 at 02:49:39AM +0200, Laurent Pinchart wrote:
> +/**
> + * panel_get_modes - Get video modes supported by the panel
> + * @panel: The panel
> + * @modes: Pointer to an array of modes
> + *
> + * Fill the modes argument with a pointer to an array of video modes. The array
> + * is owned by the panel.
> + *
> + * Return the number of supported modes on success (including 0 if no mode is
> + * supported) or a negative error code otherwise.
> + */
> +int panel_get_modes(struct panel *panel, const struct fb_videomode **modes)
> +{
> +	if (!panel->ops || !panel->ops->get_modes)
> +		return 0;
> +
> +	return panel->ops->get_modes(panel, modes);
> +}
> +EXPORT_SYMBOL_GPL(panel_get_modes);

You have seen my of videomode helper proposal. One result there was that
we want to have ranges for the margin/synclen fields. Does it make sense
to base this new panel framework on a more sophisticated internal
reprentation of the panel parameters? This could then be converted to
struct fb_videomode / struct drm_display_mode as needed. This would also
make it more suitable for drm drivers which are not interested in struct
fb_videomode.

Related to this I suggest to change the API to be able to iterate over
the different modes, like:

struct videomode *panel_get_mode(struct panel *panel, int num);

This was we do not have to have an array of modes in memory, which may
be a burden for some panel drivers.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
