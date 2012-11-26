Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41895 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab2KZPkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 10:40:15 -0500
Date: Mon, 26 Nov 2012 16:39:58 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCHv15 2/7] video: add display_timing and videomode
Message-ID: <20121126153958.GA30791@pengutronix.de>
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353920848-1705-3-git-send-email-s.trumtrar@pengutronix.de>
 <50B36286.7010704@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B36286.7010704@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 26, 2012 at 02:37:26PM +0200, Tomi Valkeinen wrote:
> On 2012-11-26 11:07, Steffen Trumtrar wrote:
> 
> > +/*
> > + * Subsystem independent description of a videomode.
> > + * Can be generated from struct display_timing.
> > + */
> > +struct videomode {
> > +	u32 pixelclock;		/* pixelclock in Hz */
> 
> I don't know if this is of any importance, but the linux clock framework
> manages clock rates with unsigned long. Would it be better to use the
> same type here?
> 

Hm, I don't know. Anyone? u32 should be large enough for a pixelclock.

> > +	u32 hactive;
> > +	u32 hfront_porch;
> > +	u32 hback_porch;
> > +	u32 hsync_len;
> > +
> > +	u32 vactive;
> > +	u32 vfront_porch;
> > +	u32 vback_porch;
> > +	u32 vsync_len;
> > +
> > +	u32 hah;		/* hsync active high */
> > +	u32 vah;		/* vsync active high */
> > +	u32 de;			/* data enable */
> > +	u32 pixelclk_pol;
> 
> What values will these 4 have? Aren't these booleans?
> 
> The data enable comment should be "data enable active high".
> 
> The next patch says in the devtree binding documentation that the values
> may be on/off/ignored. Is that represented here somehow, i.e. values are
> 0/1/2 or so? If not, what does it mean if the value is left out from
> devtree data, meaning "not used on hardware"?
>

Hm, I think you might be right here. It is no problem in the DT part of the code.
The properties are optional, left out means "not used on hardware".
But this does not propagate correctly to the videomode. I should set the fields
to -EINVAL in case they are omitted, than everything should work nicely.

> There's also a "doubleclk" value mentioned in the devtree bindings doc,
> but not shown here.
> 

Argh. That slipped through. I have patches that add this property to all
structs and the devicetree binding. But it is not supposed to be in this
series, because I want to at least have the binding stable for now.

> I think this videomode struct is the one that display drivers are going
> to use (?), in addition to the display_timing, so it would be good to
> document it well.
> 

Yes. Maybe I have to put more of the devicetree documentation in the code.

Regards,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
