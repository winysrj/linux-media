Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44983 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2JEQjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 12:39:06 -0400
Date: Fri, 5 Oct 2012 18:38:58 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
Message-ID: <20121005163858.GD2053@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
 <506DD9B4.40409@wwwdotorg.org>
 <20121005161620.GB2053@pengutronix.de>
 <506F0911.1050808@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506F0911.1050808@wwwdotorg.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 05, 2012 at 10:21:37AM -0600, Stephen Warren wrote:
> On 10/05/2012 10:16 AM, Steffen Trumtrar wrote:
> > On Thu, Oct 04, 2012 at 12:47:16PM -0600, Stephen Warren wrote:
> >> On 10/04/2012 11:59 AM, Steffen Trumtrar wrote:
> ...
> >>> +	for_each_child_of_node(timings_np, entry) {
> >>> +		struct signal_timing *st;
> >>> +
> >>> +		st = of_get_display_timing(entry);
> >>> +
> >>> +		if (!st)
> >>> +			continue;
> >>
> >> I wonder if that shouldn't be an error?
> > 
> > In the sense of a pr_err not a -EINVAL I presume?! It is a little bit quiet in
> > case of a faulty spec, that is right.
> 
> I did mean return an error; if we try to parse something and can't,
> shouldn't we return an error?
> 
> I suppose it may be possible to limp on and use whatever subset of modes
> could be parsed and drop the others, which is what this code does, but
> the code after the loop would definitely return an error if zero timings
> were parseable.

If a display supports multiple modes, I think it is better to have a working
mode (even if it is not the preferred one) than have none at all.
If there is no mode at all, that should be an error, right.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
