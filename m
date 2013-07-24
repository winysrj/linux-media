Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3GXScr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 14:32:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Date: Wed, 24 Jul 2013 20:32:03 +0200
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Tomasz Figa <t.figa@samsung.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	broonie@kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	kyungmin.park@samsung.com, balbi@ti.com, jg1.han@samsung.com,
	s.nawrocki@samsung.com, kgene.kim@samsung.com,
	grant.likely@linaro.org, tony@atomide.com, swarren@nvidia.com,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
	balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com,
	olof@lixom.net, Stephen Warren <swarren@wwwdotorg.org>,
	b.zolnierkie@samsung.com,
	Daniel Lezcano <daniel.lezcano@linaro.org>
References: <Pine.LNX.4.44L0.1307231708020.1304-100000@iolanthe.rowland.org> <5977067.8rykRgjgre@flatron>
In-Reply-To: <5977067.8rykRgjgre@flatron>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307242032.03597.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 23 July 2013, Tomasz Figa wrote:
> On Tuesday 23 of July 2013 17:14:20 Alan Stern wrote:
> > On Tue, 23 Jul 2013, Tomasz Figa wrote:
> > > Where would you want to have those phy_address arrays stored? There
> > > are no board files when booting with DT. Not even saying that you
> > > don't need to use any hacky schemes like this when you have DT that
> > > nicely specifies relations between devices.
> > 
> > If everybody agrees DT has a nice scheme for specifying relations
> > between devices, why not use that same scheme in the PHY core?
> 
> It is already used, for cases when consumer device has a DT node attached. 
> In non-DT case this kind lookup translates loosely to something that is 
> being done in regulator framework - you can't bind devices by pointers, 
> because you don't have those pointers, so you need to use device names.
> 

Sorry for jumping in to the middle of the discussion, but why does a *new*
framework even bother defining an interface for board files?

Can't we just drop any interfaces for platform data passing in the phy
framework and put the burden of adding those to anyone who actually needs
them? All the platforms we are concerned with here (exynos and omap,
plus new platforms) can be booted using DT anyway.

	Arnd
