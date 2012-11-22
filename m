Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56916 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2KVSjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:39:46 -0500
Date: Thu, 22 Nov 2012 10:10:59 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
	"Manjunathappa, Prakash" <prakash.pm@ti.com>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v12 2/6] video: add of helper for videomode
Message-ID: <20121122091059.GA4428@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-3-git-send-email-s.trumtrar@pengutronix.de>
 <A73F36158E33644199EB82C5EC81C7BC3E9FA7A0@DBDE01.ent.ti.com>
 <20121121114843.GC14013@pengutronix.de>
 <20121121115236.GA8886@avionic-0098.adnet.avionic-design.de>
 <50ACED4A.5040806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ACED4A.5040806@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Wed, Nov 21, 2012 at 09:03:38AM -0600, Rob Herring wrote:
> On 11/21/2012 05:52 AM, Thierry Reding wrote:
> > On Wed, Nov 21, 2012 at 12:48:43PM +0100, Steffen Trumtrar wrote:
> >> Hi!
> >>
> >> On Wed, Nov 21, 2012 at 10:12:43AM +0000, Manjunathappa, Prakash wrote:
> >>> Hi Steffen,
> >>>
> >>> On Tue, Nov 20, 2012 at 21:24:52, Steffen Trumtrar wrote:
> >>>> +/**
> >>>> + * of_get_display_timings - parse all display_timing entries from a device_node
> >>>> + * @np: device_node with the subnodes
> >>>> + **/
> >>>> +struct display_timings *of_get_display_timings(const struct device_node *np)
> >>>> +{
> >>>> +	struct device_node *timings_np;
> >>>> +	struct device_node *entry;
> >>>> +	struct device_node *native_mode;
> >>>> +	struct display_timings *disp;
> >>>> +
> >>>> +	if (!np) {
> >>>> +		pr_err("%s: no devicenode given\n", __func__);
> >>>> +		return NULL;
> >>>> +	}
> >>>> +
> >>>> +	timings_np = of_find_node_by_name(np, "display-timings");
> >>>
> >>> I get below build warnings on this line
> >>> drivers/video/of_display_timing.c: In function 'of_get_display_timings':
> >>> drivers/video/of_display_timing.c:109:2: warning: passing argument 1 of 'of_find_node_by_name' discards qualifiers from pointer target type
> >>> include/linux/of.h:167:28: note: expected 'struct device_node *' but argument is of type 'const struct device_node *'
> >>>
> >>>> + * of_display_timings_exists - check if a display-timings node is provided
> >>>> + * @np: device_node with the timing
> >>>> + **/
> >>>> +int of_display_timings_exists(const struct device_node *np)
> >>>> +{
> >>>> +	struct device_node *timings_np;
> >>>> +
> >>>> +	if (!np)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	timings_np = of_parse_phandle(np, "display-timings", 0);
> >>>
> >>> Also here:
> >>> drivers/video/of_display_timing.c: In function 'of_display_timings_exists':
> >>> drivers/video/of_display_timing.c:209:2: warning: passing argument 1 of 'of_parse_phandle' discards qualifiers from pointer target type
> >>> include/linux/of.h:258:28: note: expected 'struct device_node *' but argument is of type 'const struct device_node *'
> >>>
> >>
> >> The warnings are because the of-functions do not use const pointers where they
> >> should. I had two options: don't use const pointers even if they should be and
> >> have no warnings or use const pointers and have a correct API. (Third option:
> >> send patches for of-functions). I chose the second option.
> > 
> > Maybe a better approach would be a combination of 1 and 3: don't use
> > const pointers for struct device_node for now and bring the issue up
> > with the OF maintainers, possibly with patches attached that fix the
> > problematic functions.
> 
> Why does this need to be const? Since some DT functions increment
> refcount the node, I'm not sure that making struct device_node const in
> general is right thing to do. I do think it should be okay for
> of_parse_phandle.
> 

Okay, that seems right. I went a little to far with const'ing.
I will send a patch for of_parse_phandle as this function does
not seem to change the pointer it is given, but returns a new one
on which the refcount gets incremented.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
