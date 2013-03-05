Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45788 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CEJZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 04:25:08 -0500
Date: Tue, 5 Mar 2013 10:24:53 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Dave Airlie <airlied@linux.ie>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Rob Clark <robdclark@gmail.com>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>,
	"Mohammed, Afzal" <afzal@ti.com>, kernel@pengutronix.de
Subject: Re: [PATCH v17 2/7] video: add display_timing and videomode
Message-ID: <20130305092453.GB7042@pengutronix.de>
References: <1359104515-8907-1-git-send-email-s.trumtrar@pengutronix.de>
 <1359104515-8907-3-git-send-email-s.trumtrar@pengutronix.de>
 <51223615.4090709@iki.fi>
 <512E2A1B.6040704@ti.com>
 <20130227160540.GA10491@pengutronix.de>
 <512E30BD.7010603@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E30BD.7010603@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Wed, Feb 27, 2013 at 06:13:49PM +0200, Tomi Valkeinen wrote:
> On 2013-02-27 18:05, Steffen Trumtrar wrote:
> > Ah, sorry. Forgot to answer this.
> > 
> > On Wed, Feb 27, 2013 at 05:45:31PM +0200, Tomi Valkeinen wrote:
> >> Ping.
> >>
> >> On 2013-02-18 16:09, Tomi Valkeinen wrote:
> >>> Hi Steffen,
> >>>
> >>> On 2013-01-25 11:01, Steffen Trumtrar wrote:
> >>>
> >>>> +/* VESA display monitor timing parameters */
> >>>> +#define VESA_DMT_HSYNC_LOW		BIT(0)
> >>>> +#define VESA_DMT_HSYNC_HIGH		BIT(1)
> >>>> +#define VESA_DMT_VSYNC_LOW		BIT(2)
> >>>> +#define VESA_DMT_VSYNC_HIGH		BIT(3)
> >>>> +
> >>>> +/* display specific flags */
> >>>> +#define DISPLAY_FLAGS_DE_LOW		BIT(0)	/* data enable flag */
> >>>> +#define DISPLAY_FLAGS_DE_HIGH		BIT(1)
> >>>> +#define DISPLAY_FLAGS_PIXDATA_POSEDGE	BIT(2)	/* drive data on pos. edge */
> >>>> +#define DISPLAY_FLAGS_PIXDATA_NEGEDGE	BIT(3)	/* drive data on neg. edge */
> >>>> +#define DISPLAY_FLAGS_INTERLACED	BIT(4)
> >>>> +#define DISPLAY_FLAGS_DOUBLESCAN	BIT(5)
> >>>
> >>> <snip>
> >>>
> >>>> +	unsigned int dmt_flags;	/* VESA DMT flags */
> >>>> +	unsigned int data_flags; /* video data flags */
> >>>
> >>> Why did you go for this approach? To be able to represent
> >>> true/false/not-specified?
> >>>
> > 
> > We decided somewhere between v3 and v8 (I think), that those flags can be
> > high/low/ignored.
> 
> Okay. Why aren't they enums, though? That always makes more clear which
> defines are to be used with which fields.
> 

Hm...

> >>> Would it be simpler to just have "flags" field? What does it give us to
> >>> have those two separately?
> >>>
> > 
> > I decided to split them, so it is clear that some flags are VESA defined and
> > the others are "invented" for the display-timings framework and may be
> > extended.
> 
> Hmm... Okay. Is it relevant that they are VESA defined? It just feels to
> complicate handling the flags =).
> 
> >>> Should the above say raising edge/falling edge instead of positive
> >>> edge/negative edge?
> >>>
> > 
> > Hm, I used posedge/negedge because it is shorter (and because of my Verilog past
> > pretty natural to me :-) ). I don't know what others are thinking though.
> 
> I guess it's quite clear, but it's still different terms than used
> elsewhere, e.g. documentation for videomodes.
> 
> Another thing I noticed while using the new videomode, display_timings.h
> has a few names that are quite short and generic. Like "TE_MIN", which
> is now a global define. And "timing_entry". Either name could be well
> used internally in some .c file, and could easily clash.
> 

Yes. You are correct.
Everyone using this is welcome to send patches now :-)

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
