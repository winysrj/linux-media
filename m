Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43972 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbaBSRFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 12:05:53 -0500
Date: Wed, 19 Feb 2014 09:05:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: omap2: cm-t35: Add regulators and clock for
 camera sensor
Message-ID: <20140219170545.GC27263@atomide.com>
References: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <9621770.WFqvfViqR7@avalon>
 <53036840.3050605@compulab.co.il>
 <3444638.OmucgL67eO@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3444638.OmucgL67eO@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [140218 07:05]:
> Hi Igor,
> 
> On Tuesday 18 February 2014 16:03:44 Igor Grinberg wrote:
> > On 02/18/14 14:47, Laurent Pinchart wrote:
> > > On Monday 10 February 2014 22:54:40 Laurent Pinchart wrote:
> > >> The camera sensor will soon require regulators and clocks. Register
> > >> fixed regulators for its VAA and VDD power supplies and a fixed rate
> > >> clock for its master clock.
> > > 
> > > This patch is a prerequisite for a set of 4 patches that need to go
> > > through the linux-media tree. It would simpler if it could go through the
> > > same tree as well. Given that arch/arm/mach-omap2/board-cm-t35.c has seen
> > > very little activity recently I believe the risk of conflict is pretty
> > > low.
> > 
> > Indeed, as we work on DT stuff of cm-t35/3730 and pretty much stopped
> > updating the board-cm-t35.c file.
> 
> DT support for the OMAP3 ISP is coming. Too slowly, but it's coming :-)
> 
> > > Tony, would
> > > that be fine with you ?
> > > 
> > >> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Acked-by: Igor Grinberg <grinberg@compulab.co.il>
> 
> Thank you. Tony, could I get your ack as well to push this through Mauro's 
> tree ?

Sure, the board-*.c files will get removed soonish, but meanwhile:

Acked-by: Tony Lindgren <tony@atomide.com>
