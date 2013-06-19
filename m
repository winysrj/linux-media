Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:63979 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSRUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 13:20:23 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Alexandre Courbot <acourbot@nvidia.com>
Cc: kishon@ti.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] video: exynos_dsi: Use generic PHY driver
Date: Wed, 19 Jun 2013 19:20:19 +0200
Message-ID: <1584349.5UScq5Ic6l@flatron>
In-Reply-To: <51C1E61C.8030808@samsung.com>
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com> <1502179.yCdHZgQgqV@flatron> <51C1E61C.8030808@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 19 of June 2013 19:10:52 Sylwester Nawrocki wrote:
> On 06/16/2013 11:15 PM, Tomasz Figa wrote:
> > On Friday 14 of June 2013 19:45:49 Sylwester Nawrocki wrote:
> >> > Use the generic PHY API instead of the platform callback to control
> >> > the MIPI DSIM DPHY.
> >> > 
> >> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> > ---
> >> > 
> >> >  drivers/video/display/source-exynos_dsi.c |   36
> >> > 
> >> > +++++++++-------------------- include/video/exynos_dsi.h
> >> > 
> >> > |    5 ----
> >> >  
> >> >  2 files changed, 11 insertions(+), 30 deletions(-)
> > 
> > Yes, this is what I was really missing a lot while developing this
> > driver.
> > 
> > Definitely looks good! It's a shame we don't have this driver in
> > mainline yet ;)
> 
> Yes, I should have mentioned in the cover letter this patch depends
> on modified version of this [1] patch set of yours. I'll drop this
> patch and will update the driver staying in mainline now, but I won't
> be able to test it, on a non-dt platform.
> 
> I guess even some pre-eliminary display (panel) API would be helpful.
> The CDF development seems to have been stalled for some time. I wonder
> if we could first have something that works for limited set of devices
> and be extending it gradually, rather than living with zero support
> for displays on DT based ARM platforms.

Well, the problem is that once we define a binding for displays, we will 
have to keep support for this binding even if we decide to change 
something.

But as I discussed with Laurent and Alexandre at LinuxCon Japan, we should 
be able to reuse V4L2 bindings for our purposes, so someone just needs to 
code a proof of concept implementation that doesn't necessarily provide 
full functionality yet, but allows to make something work. Probably based 
on already posted RFC versions of CDF.

CCed Laurent and Alexandre, as they might be able to shed even more light 
on this.

Best regards,
Tomasz

> 
> [1] http://www.spinics.net/lists/linux-fbdev/msg09689.html
> 
> Regards,
> Sylwester
