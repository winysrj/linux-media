Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41005 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbbDGMmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 08:42:42 -0400
Date: Tue, 7 Apr 2015 13:42:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	alsa-devel@alsa-project.org, linux-sh@vger.kernel.org,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Mack <daniel@zonque.org>, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 03/14] clkdev: get rid of redundant clk_add_alias()
 prototype in linux/clk.h
Message-ID: <20150407124225.GI4027@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
 <E1Ye593-0001B1-W4@rmk-PC.arm.linux.org.uk>
 <87lhi8rrmd.fsf@free.fr>
 <5522D8B5.7050205@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5522D8B5.7050205@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 06, 2015 at 12:04:21PM -0700, Stephen Boyd wrote:
> On 04/04/15 05:43, Robert Jarzmik wrote:
> > Russell King <rmk+kernel@arm.linux.org.uk> writes:
> >
> >> clk_add_alias() is provided by clkdev, and is not part of the clk API.
> >> Howver, it is prototyped in two locations: linux/clkdev.h and
> >> linux/clk.h.  This is a mess.  Get rid of the redundant and unnecessary
> >> version in linux/clk.h.
> >>
> >> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>
> >
> > Actually, this serie fixes a regression I've seen in linux-next, and which was
> > triggering the Oops in [1] on lubbock. With your serie, the kernel boots fine.
> >
> >
> 
> Is this with the lubbock_defconfig? Is it a regression in 4.0-rc series
> or is it due to some pending -next patches interacting with the per-user
> clock patches? It looks like the latter because __clk_get_hw() should be
> inlined on lubbock_defconfig where CONFIG_COMMON_CLK=n.

It's a regression with anything that uses clk_add_alias() or which
open codes the aliasing of clocks, or registration of clocks into
clkdev.  It's quite nasty.

The problem is that the way you updated clkdev, by adding __clk_get_hw()
at clk_get() time, the struct clk which we're passing in there could
well have been already clk_put()'d, and therefore freed, and no longer
valid.

It's a regression ever since the per-user clk patches went in, caused
_entirely_ by those patches.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
