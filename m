Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41193 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbbDGOB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 10:01:28 -0400
Date: Tue, 7 Apr 2015 15:01:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, alsa-devel@alsa-project.org,
	Jason Cooper <jason@lakedaemon.net>, linux-sh@vger.kernel.org,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	Mike Turquette <mturquette@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 10/14] ARM: orion: use clkdev_create()
Message-ID: <20150407140117.GN4027@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
 <E1Ye59d-0001BZ-Sv@rmk-PC.arm.linux.org.uk>
 <20150404001729.GA14824@lunn.ch>
 <5523D985.60800@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5523D985.60800@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 07, 2015 at 03:20:05PM +0200, Gregory CLEMENT wrote:
> Hi Andrew, Russell,
> 
> On 04/04/2015 02:17, Andrew Lunn wrote:
> > On Fri, Apr 03, 2015 at 06:13:13PM +0100, Russell King wrote:
> >> clkdev_create() is a shorter way to write clkdev_alloc() followed by
> >> clkdev_add().  Use this instead.
> >>
> >> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > 
> > Acked-by: Andrew Lunn <andrew@lunn.ch>
> 
> This change makes sens however what about Thomas' comment: removing
> orion_clkdev_add() entirely and directly using lkdev_create() all over
> the place:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/327294.html
> 
> Then what would be the path for this patch?
> 
> As there is a dependency on the 6th patch of this series: "clkdev: add
> clkdev_create() helper" which should be merged through the clk tree, I
> think the best option is that this patch would be also managed by the
> clk tree maintainer (I added them in CC).

Let me remind people that clkdev is *NOT* part of clk, and that I'm the
maintainer for clkdev.

I'm getting rather pissed off with people taking work away from me, even
when I'm named in the MAINTAINERS file.  These patches are going through
my tree unless there's a good reason for them not to.  They are _not_
going through the clk tree.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
