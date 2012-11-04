Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45125 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2KDQxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 11:53:32 -0500
Date: Sun, 4 Nov 2012 17:53:18 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v7 1/8] video: add display_timing struct and helpers
Message-ID: <20121104165318.GA5894@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-2-git-send-email-s.trumtrar@pengutronix.de>
 <20121101200842.GA13137@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101200842.GA13137@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 01, 2012 at 09:08:42PM +0100, Thierry Reding wrote:
> On Wed, Oct 31, 2012 at 10:28:01AM +0100, Steffen Trumtrar wrote:
> [...]
> > +void timings_release(struct display_timings *disp)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < disp->num_timings; i++)
> > +		kfree(disp->timings[i]);
> > +}
> > +
> > +void display_timings_release(struct display_timings *disp)
> > +{
> > +	timings_release(disp);
> > +	kfree(disp->timings);
> > +}
> 
> I'm not quite sure I understand how these are supposed to be used. The
> only use-case where a struct display_timings is dynamically allocated is
> for the OF helpers. In that case, wouldn't it be more useful to have a
> function that frees the complete structure, including the struct
> display_timings itself? Something like this, which has all of the above
> rolled into one:
> 
> 	void display_timings_free(struct display_timings *disp)
> 	{
> 		if (disp->timings) {
> 			unsigned int i;
> 
> 			for (i = 0; i < disp->num_timings; i++)
> 				kfree(disp->timings[i]);
> 		}
> 
> 		kfree(disp->timings);
> 		kfree(disp);
> 	}
> 

Well, you are right. They can be rolled into one function.
The extra function call is useless and as it seems confusing.

Regards,
Steffen

> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
