Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39870 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3AUSw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 13:52:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/2] OMAP3 ISP: Simplify clock usage
Date: Mon, 21 Jan 2013 19:54:38 +0100
Message-ID: <4222427.SJZRgZMHGN@avalon>
In-Reply-To: <20130121171812.GJ15361@atomide.com>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com> <3133387.jv7osGsLR0@avalon> <20130121171812.GJ15361@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Monday 21 January 2013 09:18:12 Tony Lindgren wrote:
> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [130121 05:37]:
> > On Monday 14 January 2013 17:10:15 Mike Turquette wrote:
> > > Quoting Laurent Pinchart (2013-01-08 05:43:52)
> > > 
> > > > Hello,
> > > > 
> > > > Now that the OMAP3 supports the common clock framework, clock rate
> > > > back-propagation is available for the ISP clocks. Instead of setting
> > > > the cam_mclk parent clock rate to control the cam_mclk clock rate, we
> > > > can mark the dpll4_m5x2_ck_3630 and cam_mclk clocks as supporting
> > > > back-propagation, and set the cam_mclk rate directly. This simplifies
> > > > the ISP clocks configuration.
> > > 
> > > I'm pleased to see this feature get used on OMAP.  Plus your driver gets
> > > a negative diffstat :)
> > > 
> > > Reviewed-by: Mike Turquette <mturquette@linaro.org>
> > 
> > Thanks.
> > 
> > Would you like to take the arch/ patch in your tree, or should I push it
> > through the linux-media tree along with the omap3isp patch ?
> 
> The arch/arm/*omap* clock changes need to be queued by Paul to avoid
> potential stupid merge conflicts when the clock data gets moved to
> live under drivers/clk/omap.

OK. The omap3isp patch can go through Paul's tree as well, it won't conflict 
with other changes to the driver in this merge window.

Paul, can you take both patches together ? If so I'll send you a pull request.

-- 
Regards,

Laurent Pinchart

