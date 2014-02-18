Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42181 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbaBRPCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 10:02:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: omap2: cm-t35: Add regulators and clock for camera sensor
Date: Tue, 18 Feb 2014 16:03:22 +0100
Message-ID: <3444638.OmucgL67eO@avalon>
In-Reply-To: <53036840.3050605@compulab.co.il>
References: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com> <9621770.WFqvfViqR7@avalon> <53036840.3050605@compulab.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Igor,

On Tuesday 18 February 2014 16:03:44 Igor Grinberg wrote:
> On 02/18/14 14:47, Laurent Pinchart wrote:
> > On Monday 10 February 2014 22:54:40 Laurent Pinchart wrote:
> >> The camera sensor will soon require regulators and clocks. Register
> >> fixed regulators for its VAA and VDD power supplies and a fixed rate
> >> clock for its master clock.
> > 
> > This patch is a prerequisite for a set of 4 patches that need to go
> > through the linux-media tree. It would simpler if it could go through the
> > same tree as well. Given that arch/arm/mach-omap2/board-cm-t35.c has seen
> > very little activity recently I believe the risk of conflict is pretty
> > low.
> 
> Indeed, as we work on DT stuff of cm-t35/3730 and pretty much stopped
> updating the board-cm-t35.c file.

DT support for the OMAP3 ISP is coming. Too slowly, but it's coming :-)

> > Tony, would
> > that be fine with you ?
> > 
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>

Thank you. Tony, could I get your ack as well to push this through Mauro's 
tree ?

> >> ---
> >> 
> >>  arch/arm/mach-omap2/board-cm-t35.c | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >> 
> >> diff --git a/arch/arm/mach-omap2/board-cm-t35.c
> >> b/arch/arm/mach-omap2/board-cm-t35.c index 8dd0ec8..018353d 100644
> >> --- a/arch/arm/mach-omap2/board-cm-t35.c
> >> +++ b/arch/arm/mach-omap2/board-cm-t35.c
> >> @@ -16,6 +16,8 @@
> >> 
> >>   *
> >>   */
> >> 
> >> +#include <linux/clk-provider.h>
> >> +#include <linux/clkdev.h>
> >> 
> >>  #include <linux/kernel.h>
> >>  #include <linux/init.h>
> >>  #include <linux/platform_device.h>
> >> 
> >> @@ -542,8 +544,22 @@ static struct isp_platform_data cm_t35_isp_pdata = {
> >> 
> >>  	.subdevs = cm_t35_isp_subdevs,
> >>  
> >>  };
> >> 
> >> +static struct regulator_consumer_supply cm_t35_camera_supplies[] = {
> >> +	REGULATOR_SUPPLY("vaa", "3-005d"),
> >> +	REGULATOR_SUPPLY("vdd", "3-005d"),
> >> +};
> >> +
> >> 
> >>  static void __init cm_t35_init_camera(void)
> >>  {
> >> 
> >> +	struct clk *clk;
> >> +
> >> +	clk = clk_register_fixed_rate(NULL, "mt9t001-clkin", NULL, 
CLK_IS_ROOT,
> >> +				      48000000);
> >> +	clk_register_clkdev(clk, NULL, "3-005d");
> >> +
> >> +	regulator_register_fixed(2, cm_t35_camera_supplies,
> >> +				 ARRAY_SIZE(cm_t35_camera_supplies));
> >> +
> >> 
> >>  	if (omap3_init_camera(&cm_t35_isp_pdata) < 0)
> >>  	
> >>  		pr_warn("CM-T3x: Failed registering camera device!\n");
> >>  
> >>  }

-- 
Regards,

Laurent Pinchart

