Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57641 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbbCCAjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 19:39:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, alsa-devel@alsa-project.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 01/10] media: omap3isp: remove unused clkdev
Date: Tue, 03 Mar 2015 02:39:14 +0200
Message-ID: <8241179.DTounjB2Ur@avalon>
In-Reply-To: <20150302235435.GF29584@n2100.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk> <20150302225336.GV6539@valkosipuli.retiisi.org.uk> <20150302235435.GF29584@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Monday 02 March 2015 23:54:35 Russell King - ARM Linux wrote:
> (Combining replies...)
> 
> On Tue, Mar 03, 2015 at 12:53:37AM +0200, Sakari Ailus wrote:
> > Hi Laurent and Russell,
> > 
> > On Tue, Mar 03, 2015 at 12:33:44AM +0200, Laurent Pinchart wrote:
> > > Sakari, does it conflict with the omap3isp DT support ? If so, how would
> > > you prefer to resolve the conflict ? Russell, would it be fine to merge
> > > this through Mauro's tree ?
> 
> As other changes will depend on this, I'd prefer not to.  The whole
> "make clk_get() return a unique struct clk" wasn't well tested, and
> several places broke - and currently clk_add_alias() is broken as a
> result of that.
> 
> I'm trying to get to the longer term solution, where clkdev internally
> uses a struct clk_hw pointer rather than a struct clk pointer, and I
> want to clean stuff up first.
> 
> If omap3isp needs to keep this code, then so be it - I'll come up with
> a different patch improving its use of clkdev instead.

I'm totally fine with removing clkdev from the omap3isp driver if that's 
easier for you, I'm just concerned about the merge conflict that will result.

-- 
Regards,

Laurent Pinchart

