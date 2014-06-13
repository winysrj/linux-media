Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49000 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752577AbaFMHxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 03:53:34 -0400
Date: Fri, 13 Jun 2014 00:53:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, arm@kernel.org
Subject: Re: [PATCH] [media] staging: allow omap4iss to be modular
Message-ID: <20140613075325.GO17845@atomide.com>
References: <5192928.MkINji4uKU@wuerfel>
 <1689719.caqIIBS1Wn@avalon>
 <20140613053044.GG17845@atomide.com>
 <1830688.7p3Fp6u7a2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1830688.7p3Fp6u7a2@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [140612 23:48]:
> On Thursday 12 June 2014 22:30:44 Tony Lindgren wrote:
> > 
> > 1. They live in separate hardware modules that can be clocked separately
> 
> Actually I don't think that's true. The CSI2 PHY is part of the camera device, 
> with all its registers but the one above in the camera device register space. 
> For some weird reason a couple of bits were pushed to the control module, but 
> that doesn't make the CSI2 PHY itself a separate device.

Yes they are separate. Anything in the system control module is
a separate hardware module from the other devices. So in this case
the CSI2 PHY is part of the system control module, not the camera
module.

> > 2. Doing a read-back to flush a posted write in one hardware module most
> >    likely won't flush the write to other and that can lead into hard to
> >    find mysterious bugs
> 
> The OMAP4 ISS driver can just read back the CAMERA_RX register, can't it ?

Right, but you would have to do readbacks both from the phy register and
camera register to ensure writes get written. It's best to keep the
logic completely separate especially considering that they can be
clocked separately.

> > 3. If we ever have a common system control module driver, we need to
> >    rewrite all the system control module register tinkering in the drivers
> 
> Sure, but that's already the case today, as the OMAP4 ISS driver already 
> accesses the control module register directly. I won't make that worse :-)

Well it's in staging for a reason :)
 
> > So it's best to try to use an existing framework for it. That avoids tons of
> > pain later on ;)
> 
> I agree, but I don't think the PHY framework would be the right abstraction. 
> As explained above the CSI2 PHY is part of the OMAP4 ISS, so modeling its 
> single control module register as a PHY would be a hack. 

Well that register belongs to the system control module, not the
camera module. It's not like the camera IO space is out of registers
or something! :)

We're already handling similar control module phy cases, see for
example drivers/phy/phy-omap-control.c. Maybe you have most of the
code already there?

Regards,

Tony

