Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab1ISPGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 11:06:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mfd: Combine MFD_SUPPORT and MFD_CORE
Date: Mon, 19 Sep 2011 17:06:01 +0200
Cc: Luciano Coelho <coelho@ti.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Tony Lindgren <tony@atomide.com>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <1314643307-17780-1-git-send-email-coelho@ti.com> <20110915171634.GD3523@ponder.secretlab.ca>
In-Reply-To: <20110915171634.GD3523@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109191706.01569.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 15 September 2011, Grant Likely wrote:
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 21574bd..1836cdf 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -2,10 +2,9 @@
> >  # Multifunction miscellaneous devices
> >  #
> >  
> > -menuconfig MFD_SUPPORT
> > -     bool "Multifunction device drivers"
> > +menuconfig MFD_CORE
> > +     tristate "Multifunction device drivers"
> >       depends on HAS_IOMEM
> > -     default y
> 
> Looks like there is a bug here.  Kconfig symbols with dependencies
> (HAS_IOMEM) must not ever be selected by other symbols because Kconfig
> doesn't implement a way to resolve them.  This patch means that every
> "select MFD_CORE" just assumes that HAS_IOMEM is also selected.

That is probably a fair assumption though. Almost all architectures
set HAS_IOMEM unconditionally, and the other ones (probably just s390)
would not select MFD_CORE.

Note that Samuel already took the other patch in the end, so it doesn't
matter. The patch I posted encloses the entire directory in "if HAS_IOMEM".

	Arnd
