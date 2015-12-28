Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60368 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbbL1KFi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 05:05:38 -0500
Date: Mon, 28 Dec 2015 08:05:29 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	javier@osg.samsung.com, hverkuil@xs4all.nl,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	=?UTF-8?B?QmVub8OudA==?= Cousson <bcousson@baylibre.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/23] Unrestricted media entity ID range support
Message-ID: <20151228080529.4bc9f076@recife.lan>
In-Reply-To: <26879584.9P9vDMYfPM@avalon>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
	<20151216140301.GO17128@valkosipuli.retiisi.org.uk>
	<20151223103242.44deaea4@recife.lan>
	<26879584.9P9vDMYfPM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Dec 2015 19:11:36 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Wednesday 23 December 2015 10:32:42 Mauro Carvalho Chehab wrote:
> > Em Wed, 16 Dec 2015 16:03:01 +0200 Sakari Ailus escreveu:
> > > On Wed, Dec 16, 2015 at 03:32:15PM +0200, Sakari Ailus wrote:
> > > > This is the third version of the unrestricted media entity ID range
> > > > support set. I've taken Mauro's comments into account and fixed a number
> > > > of bugs as well (omap3isp memory leak and omap4iss stream start).
> > > 
> > > Javier: Mauro told me you might have OMAP4 hardware. Would you be able to
> > > test the OMAP4 ISS with these patches?
> > > 
> > > Thanks.
> > 
> > Sakari,
> > 
> > Testing with OMAP4 is not possible. The driver is broken: it doesn't
> > support DT, and the required pdata definition is missing.
> 
> What do you mean by missing ? struct iss_platform_data is defined in 
> include/media/omap4iss.h.
> 

As this driver is not DT, the platform data has to be part of the Kernel
tree for the driver to work. However, there are no board-specific data nor
any documentation about how to do that inside the Kernel tree. 
That means  that this driver won't work without some OOT patch.

So, on its current state, it is broken. It should either be
converted to DT and have the needed board definitions added to the
existing dts files or be removed.

Another possible approach would be to have a patch like the one
Javier and I tried to craft by adding the needed platform data
into arch/arm/mach-omap2/pdata-quirks.c, but I guess it is better
to just use DT instead.

Regards,
Mauro
