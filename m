Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:65271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1IEOTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 10:19:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Date: Mon, 5 Sep 2011 16:19:35 +0200
Cc: Luciano Coelho <coelho@ti.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <201109021643.14275.arnd@arndb.de> <20110905144134.2c80c4b9@endymion.delvare>
In-Reply-To: <20110905144134.2c80c4b9@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051619.35553.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 September 2011, Jean Delvare wrote:
> As said before, I'm not sure. Yes, it makes it easier to select misc
> device drivers from Kconfig files. But it also makes it impossible to
> deselect all misc device drivers at once.
> 
> I think that what we really need is the implementation in the Kconfig
> system of smart selects, i.e. whenever an entry is selected, everything
> it depends on gets selected as well. I don't know how feasible this is,
> but if it can be done then I'd prefer this to your proposal.
> 
> Meanwhile, I am not in favor of applying your patch. The benefit is
> relatively small IMHO (misc device drivers are rarely selected) and
> there is one significant drawback.

Before I made this patch, I started a different one that added about
a dozen 'select MISC_DEVICES' statements sprinkled all over the kernel
in order to silence the Kconfig warnings.

The problem is that whenever you select that option, the misc directory
suddenly becomes visible when it was disabled before, and things like
'oldconfig' will start asking about all other misc drivers as well.

I think it would simply be more consistent to have it enabled all
the time. Well, even better would be to move the bulk of the misc
drivers to a proper location sorted by their subsystems. A lot of them
should never have been merged in their current state IMHO.

> That being said, I'm not the one to decide, so if you can convince
> someone with more power (aka Andrew Morton)...

I think I should finally do what has been  talked about a few times and
formally become the maintainer of drivers/char and drivers/misc ;-)

The problem is that I'm not actually a good maintainer, but maybe it's
better to just have someone instead of falling back to Andrew or
some random subsystem maintainer to send any patches for drivers/misc.

> >  config AD525X_DPOT
> >       tristate "Analog Devices Digital Potentiometers"
> > @@ -344,6 +328,12 @@ config ISL29020
> >         This driver can also be built as a module.  If so, the module
> >         will be called isl29020.
> >  
> > +config SENSORS_LIS3LV02D
> > +     tristate
> > +     depends on INPUT
> > +     select INPUT_POLLDEV
> > +     default n
> > +
> 
> If you patch gets applied, then this one would better be moved to
> drivers/misc/lis3lv02d/Kconfig.

Ah, that's true.

	Arnd
