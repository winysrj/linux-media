Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41029 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbbDGMpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 08:45:45 -0400
Date: Tue, 7 Apr 2015 13:45:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	sakari.ailus@iki.fi
Subject: Re: [PATCH 07/14] media: omap3isp: remove unused clkdev
Message-ID: <20150407124536.GK4027@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
 <36620233.VbNiGUfDRt@avalon>
 <20150405142034.GG4027@n2100.arm.linux.org.uk>
 <1894989.AGoQvgsks0@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1894989.AGoQvgsks0@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 07, 2015 at 12:42:52PM +0300, Laurent Pinchart wrote:
> Hello Russell,
> 
> On Sunday 05 April 2015 15:20:34 Russell King - ARM Linux wrote:
> > On Sat, Apr 04, 2015 at 12:44:35AM +0300, Laurent Pinchart wrote:
> > > Hi Russell,
> > > 
> > > Thank you for the patch;
> > > 
> > > On Friday 03 April 2015 18:12:58 Russell King wrote:
> > > > No merged platform supplies xclks via platform data.  As we want to
> > > > slightly change the clkdev interface, rather than fixing this unused
> > > > code, remove it instead.
> > > > 
> > > > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > with one caveat though : it conflicts with patches queued for v4.1 in the
> > > media tree. I'll post a rebased version in a reply to your e-mail. How
> > > would you like to handle the conflict ?
> > 
> > How bad is the conflict?
> 
> It's not too bad, it's mostly a context-related conflict. There are two 
> additional lines to remove (plus the associated comment) from isp_xclk_init(), 
> as your patch makes a loop now terminate with if (condition) continue;. Those 
> two lines could be removed later, keeping them doesn't break anything.

I think it's fine to take it through the media tree as the series doesn't
have any dependencies on this patch.  It was merely attempting to get rid
of stuff so that we could move closer to clkdev dealing with a clk_hw
rather than a struct clk - but I never made it that far with the series.
Maybe at a later date... :)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
