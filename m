Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50030 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757221AbbCCXJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 18:09:48 -0500
Date: Wed, 4 Mar 2015 01:09:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 01/10] media: omap3isp: remove unused clkdev
Message-ID: <20150303230913.GZ6539@valkosipuli.retiisi.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
 <E1YSTnC-0001JU-CX@rmk-PC.arm.linux.org.uk>
 <118780170.u6ZO5zJrEk@avalon>
 <20150302225336.GV6539@valkosipuli.retiisi.org.uk>
 <20150302235435.GF29584@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150302235435.GF29584@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Mon, Mar 02, 2015 at 11:54:35PM +0000, Russell King - ARM Linux wrote:
> (Combining replies...)
> 
> On Tue, Mar 03, 2015 at 12:53:37AM +0200, Sakari Ailus wrote:
> > Hi Laurent and Russell,
> > 
> > On Tue, Mar 03, 2015 at 12:33:44AM +0200, Laurent Pinchart wrote:
> > > Sakari, does it conflict with the omap3isp DT support ? If so, how would you 
> > > prefer to resolve the conflict ? Russell, would it be fine to merge this 
> > > through Mauro's tree ?
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

I discussed this with Laurent and the two options we thought are

- You provide a stable branch on which I can rebase the patches, in order
  to avoid a merge conflict or

- We ignore the conflict and let Stephen Rothwell handle it. The conflict
  itself is relatively simple to resolve.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
