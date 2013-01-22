Return-path: <linux-media-owner@vger.kernel.org>
Received: from utopia.booyaka.com ([74.50.51.50]:41021 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3AVC5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 21:57:23 -0500
Date: Tue, 22 Jan 2013 02:57:22 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Tony Lindgren <tony@atomide.com>,
	Mike Turquette <mturquette@linaro.org>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 0/2] OMAP3 ISP: Simplify clock usage
In-Reply-To: <4222427.SJZRgZMHGN@avalon>
Message-ID: <alpine.DEB.2.00.1301220256040.25789@utopia.booyaka.com>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com> <3133387.jv7osGsLR0@avalon> <20130121171812.GJ15361@atomide.com> <4222427.SJZRgZMHGN@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 21 Jan 2013, Laurent Pinchart wrote:

> OK. The omap3isp patch can go through Paul's tree as well, it won't conflict 
> with other changes to the driver in this merge window.
> 
> Paul, can you take both patches together ? If so I'll send you a pull request.

Yes I'll take them, as long as they won't cause conflicts outside of 
arch/arm/mach-omap2.  Otherwise the OMAP3 ISP patch should wait until the 
early v3.9-rc integration fixes timeframe.


- Paul
