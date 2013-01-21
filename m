Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40609 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3AUNdw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 08:33:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 0/2] OMAP3 ISP: Simplify clock usage
Date: Mon, 21 Jan 2013 14:35:34 +0100
Message-ID: <3133387.jv7osGsLR0@avalon>
In-Reply-To: <20130115011015.23734.75232@quantum>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com> <20130115011015.23734.75232@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Monday 14 January 2013 17:10:15 Mike Turquette wrote:
> Quoting Laurent Pinchart (2013-01-08 05:43:52)
> 
> > Hello,
> > 
> > Now that the OMAP3 supports the common clock framework, clock rate
> > back-propagation is available for the ISP clocks. Instead of setting the
> > cam_mclk parent clock rate to control the cam_mclk clock rate, we can mark
> > the dpll4_m5x2_ck_3630 and cam_mclk clocks as supporting
> > back-propagation, and set the cam_mclk rate directly. This simplifies the
> > ISP clocks configuration.
>
> I'm pleased to see this feature get used on OMAP.  Plus your driver gets
> a negative diffstat :)
> 
> Reviewed-by: Mike Turquette <mturquette@linaro.org>

Thanks.

Would you like to take the arch/ patch in your tree, or should I push it 
through the linux-media tree along with the omap3isp patch ?

> > Laurent Pinchart (2):
> >   ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to
> >     dpll4_m5
> >   omap3isp: Set cam_mclk rate directly
> >  
> >  arch/arm/mach-omap2/cclock3xxx_data.c |   10 +++++++++-
> >  drivers/media/platform/omap3isp/isp.c |   18 ++----------------
> >  drivers/media/platform/omap3isp/isp.h |    8 +++-----
> >  3 files changed, 14 insertions(+), 22 deletions(-)

-- 
Regards,

Laurent Pinchart

