Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28678 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755882Ab3AURSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 12:18:16 -0500
Date: Mon, 21 Jan 2013 09:18:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 0/2] OMAP3 ISP: Simplify clock usage
Message-ID: <20130121171812.GJ15361@atomide.com>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20130115011015.23734.75232@quantum>
 <3133387.jv7osGsLR0@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3133387.jv7osGsLR0@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [130121 05:37]:
> Hi Mike,
> 
> On Monday 14 January 2013 17:10:15 Mike Turquette wrote:
> > Quoting Laurent Pinchart (2013-01-08 05:43:52)
> > 
> > > Hello,
> > > 
> > > Now that the OMAP3 supports the common clock framework, clock rate
> > > back-propagation is available for the ISP clocks. Instead of setting the
> > > cam_mclk parent clock rate to control the cam_mclk clock rate, we can mark
> > > the dpll4_m5x2_ck_3630 and cam_mclk clocks as supporting
> > > back-propagation, and set the cam_mclk rate directly. This simplifies the
> > > ISP clocks configuration.
> >
> > I'm pleased to see this feature get used on OMAP.  Plus your driver gets
> > a negative diffstat :)
> > 
> > Reviewed-by: Mike Turquette <mturquette@linaro.org>
> 
> Thanks.
> 
> Would you like to take the arch/ patch in your tree, or should I push it 
> through the linux-media tree along with the omap3isp patch ?

The arch/arm/*omap* clock changes need to be queued by Paul to avoid
potential stupid merge conflicts when the clock data gets moved to
live under drivers/clk/omap.

Regards,

Tony
