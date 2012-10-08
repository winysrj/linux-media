Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49357 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JHMDj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:03:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
Date: Mon, 08 Oct 2012 14:04:19 +0200
Message-ID: <1479122.2xVsV4MZ4o@avalon>
In-Reply-To: <1349686878.3227.40.camel@deskari>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <Pine.LNX.4.64.1210081000530.11034@axis700.grange> <1349686878.3227.40.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Monday 08 October 2012 12:01:18 Tomi Valkeinen wrote:
> On Mon, 2012-10-08 at 10:25 +0200, Guennadi Liakhovetski wrote:
> > In general, I might be misunderstanding something, but don't we have to
> > distinguish between 2 types of information about display timings: (1) is
> > defined by the display controller requirements, is known to the display
> > driver and doesn't need to be present in timings DT. We did have some of
> > these parameters in board data previously, because we didn't have proper
> > display controller drivers... (2) is board specific configuration, and is
> > such it has to be present in DT.
> > 
> > In that way, doesn't "interlaced" belong to type (1) and thus doesn't need
> > to be present in DT?
> 
> As I see it, this DT data is about the display (most commonly LCD
> panel), i.e. what video mode(s) the panel supports. If things were done
> my way, the panel's supported timings would be defined in the driver for
> the panel, and DT would be left to describe board specific data, but
> this approach has its benefits.

What about dumb DPI panels ? They will all be supported by a single driver, 
would you have the driver contain information about all known DPI panels ? DT 
seems a good solution to me in this case.

For complex panels where the driver will support a single (or very few) model 
I agree that specifying the timings in DT isn't needed.

> Thus, if you connect an interlaced panel to your board, you need to tell
> the display controller that this panel requires interlace signal. Also,
> pixel clock source doesn't make sense in this context, as this doesn't
> describe the actual used configuration, but only what the panel
> supports.
> 
> Of course, if this is about describing the hardware, the default-mode
> property doesn't really fit in...

Maybe we should rename it to native-mode then ?

-- 
Regards,

Laurent Pinchart

