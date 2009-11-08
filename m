Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbZKHDVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 22:21:18 -0500
Date: Sun, 8 Nov 2009 01:20:42 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules
 using  XC2028 and XC3028L tuners
Message-ID: <20091108012042.798835dd@pedra.chehab.org>
In-Reply-To: <1257645834.15927.634.camel@localhost>
References: <1257630476.15927.400.camel@localhost>
	<1257644240.6895.5.camel@palomino.walls.org>
	<829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
	<1257645834.15927.634.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

> > It's not clear to me what this MODULE_FIRMWARE is going to be used
> > for, but if it's for some sort of module dependency system, then it
> > definitely should *not* be a dependency for em28xx.  There are lots of
> > em28xx based devices that do not use the xc3028, and those users
> > should not be expected to go out and find/extract the firmware for
> > some tuner they don't have.
> 
> This information is currently used by initramfs builders to find
> required firmware files.  I also use this information in the Debian
> kernel upgrade script to warn if a currently loaded driver may require
> firmware in the new kernel version and the firmware is not installed.
> This is important during the transition of various drivers from built-in
> to separate firmware.
> 
> Neither of these uses applies to TV tuners, but the information may
> still be useful in installers.

> > Also, how does this approach handle the situation where there are two
> > different possible firmwares depending on the card using the firmware.
> >  As in the example above, you the xc3028 can require either the xc3028
> > or xc3028L firmware depending on the board they have.  Does this
> > change now result in both firmware images being required?
> 
> It really depends on how the information is used.  Given that there are
> many drivers that load different firmware files for different devices
> (or even support multiple different versions with different names), it
> would be rather stupid to treat these declaration as requirements.

I agree. An interesting case happens with devices that uses tda10046 DVB demods.
They have the firmware stored internally on their eeprom. Those firmwares can be
replaced by a different version loaded in ram, but, in general, they work
properly with the eeprom one. So, even having the firmware load code there,
the firmware at /lib/firmware is optional.

-

I don't see any reason why we should add MODULE_FIRMWARE for v4l/dvb devices.
As you said, its primary usage is focused on booting a machine, and none
of those devices would affect booting. 

As you pointed, the secondary usage doesn't seem to apply to those devices as
well, and seems to be distro-specific, since different distros use different
methods to check for firmware dependencies, generally relying at the package
metadata. To make things worse, several of those firmwares still don't have any
redistribution rights license that would be required for its inclusion on a distro
package.

Also, as this macro have no current usage that would make sense for those
drivers, I'm afraid that, as time goes by, people will simply forget to
keep it updated, since they'll need to add the same firmware name on two
different places.

That's said, for now, the better is to not add those macros for the devices
under /drivers/media. They'll just waste some space at the object file, and
require an additional maintenance care for no good reason.

Cheers,
Mauro
