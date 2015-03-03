Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49718 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932332AbbCCWKR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 17:10:17 -0500
Date: Wed, 4 Mar 2015 00:09:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 01/10] media: omap3isp: remove unused clkdev
Message-ID: <20150303220940.GX6539@valkosipuli.retiisi.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
 <20150302225336.GV6539@valkosipuli.retiisi.org.uk>
 <20150302235435.GF29584@n2100.arm.linux.org.uk>
 <8241179.DTounjB2Ur@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8241179.DTounjB2Ur@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Mar 03, 2015 at 02:39:14AM +0200, Laurent Pinchart wrote:
> Hi Russell,
> 
> On Monday 02 March 2015 23:54:35 Russell King - ARM Linux wrote:
> > (Combining replies...)
> > 
> > On Tue, Mar 03, 2015 at 12:53:37AM +0200, Sakari Ailus wrote:
> > > Hi Laurent and Russell,
> > > 
> > > On Tue, Mar 03, 2015 at 12:33:44AM +0200, Laurent Pinchart wrote:
> > > > Sakari, does it conflict with the omap3isp DT support ? If so, how would
> > > > you prefer to resolve the conflict ? Russell, would it be fine to merge
> > > > this through Mauro's tree ?
> > 
> > As other changes will depend on this, I'd prefer not to.  The whole
> > "make clk_get() return a unique struct clk" wasn't well tested, and
> > several places broke - and currently clk_add_alias() is broken as a
> > result of that.
> > 
> > I'm trying to get to the longer term solution, where clkdev internally
> > uses a struct clk_hw pointer rather than a struct clk pointer, and I
> > want to clean stuff up first.
> > 
> > If omap3isp needs to keep this code, then so be it - I'll come up with
> > a different patch improving its use of clkdev instead.
> 
> I'm totally fine with removing clkdev from the omap3isp driver if that's 
> easier for you, I'm just concerned about the merge conflict that will result.

There actually appears to be one more dependency, so four patches in total.

What we could also do is to rebase the omap3isp DT support set on top of
Russell's single patch. This way there probably would be no merge conflict,
assuming the patches are exactly the same, and you have no other patches
changing the omap3isp driver.

Alternatively we could postpone the DT support for the omap3isp, but I'd
rather want to avoid that.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
