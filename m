Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50653 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2JEHQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 03:16:15 -0400
Date: Fri, 5 Oct 2012 09:15:59 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, TomiValkeinen@pengutronix.de
Message-ID: <20121005071559.GH23204@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<tomi.valkeinen@ti.com>, pza
Bcc:
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
Reply-To:
In-Reply-To: <Pine.LNX.4.64.1210042307300.3744@axis700.grange>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:13:09 up 103 days, 22:24, 36 users,  load average: 0,57, 0,60,
 0,61

On Thu, Oct 04, 2012 at 11:35:35PM +0200, Guennadi Liakhovetski wrote:
> > +optional properties:
> > + - hsync-active-high (bool): Hsync pulse is active high
> > + - vsync-active-high (bool): Vsync pulse is active high
>
> For the above two we also considered using bool properties but eventually
> settled down with integer ones:
>
> - hsync-active = <1>
>
> for active-high and 0 for active low. This has the added advantage of
> being able to omit this property in the .dts, which then doesn't mean,
> that the polarity is active low, but rather, that the hsync line is not
> used on this hardware. So, maybe it would be good to use the same binding
> here too?

Philipp, this is the same argumentation as we discussed yesterday for
the dual-link LVDS option, so that one could be modelled in a similar
way.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
