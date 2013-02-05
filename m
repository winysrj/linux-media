Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38904 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3BESaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 13:30:17 -0500
Date: Tue, 5 Feb 2013 19:29:53 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	'Dave Airlie' <airlied@linux.ie>, linux-fbdev@vger.kernel.org,
	"'Mohammed, Afzal'" <afzal@ti.com>,
	'Stephen Warren' <swarren@wwwdotorg.org>,
	'Florian Tobias Schandinat' <FlorianSchandinat@gmx.de>,
	dri-devel@lists.freedesktop.org,
	'Tomi Valkeinen' <tomi.valkeinen@ti.com>,
	'Rob Herring' <robherring2@gmail.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	'Guennady Liakhovetski' <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v17 4/7] fbmon: add videomode helpers
Message-ID: <20130205182953.GC27438@pengutronix.de>
References: <1359104515-8907-1-git-send-email-s.trumtrar@pengutronix.de>
 <1359104515-8907-5-git-send-email-s.trumtrar@pengutronix.de>
 <003401ce005e$af665c50$0e3314f0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003401ce005e$af665c50$0e3314f0$%han@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Fri, Feb 01, 2013 at 06:29:50PM +0900, Jingoo Han wrote:
> On Friday, January 25, 2013 6:02 PM, Steffen Trumtrar wrote
> > 
> > +	fbmode->sync = 0;
> > +	fbmode->vmode = 0;
> > +	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> > +		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> > +	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> 
> Um, it seems to be a type. 'H'SYNC -> 'V'SYNC
> Thus, it would be changed as below:
> 
>     VESA_DMT_HSYNC_HIGH -> VESA_DMT_VSYNC_HIGH

Damn. You are right, that is a typo. But I guess some maintainer (Dave) really,
really wants to take the series now and this can wait for an -rc. No?!  ;-)

Thanks,
Steffen

> 
> > +		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
> > +	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
> > +		fbmode->vmode |= FB_VMODE_INTERLACED;
> > +	if (vm->data_flags & DISPLAY_FLAGS_DOUBLESCAN)
> > +		fbmode->vmode |= FB_VMODE_DOUBLE;
> > +	fbmode->flag = 0;
> > +

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
