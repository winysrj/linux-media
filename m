Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60849 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaFMNQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 09:16:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, arm@kernel.org
Subject: Re: [PATCH] [media] staging: allow omap4iss to be modular
Date: Fri, 13 Jun 2014 15:17:03 +0200
Message-ID: <1617959.7Fmtm9uMby@avalon>
In-Reply-To: <20140613111011.GT17845@atomide.com>
References: <5192928.MkINji4uKU@wuerfel> <1709586.iO4riM1soY@avalon> <20140613111011.GT17845@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Friday 13 June 2014 04:10:12 Tony Lindgren wrote:
> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [140613 03:30]:
> > On Friday 13 June 2014 00:53:25 Tony Lindgren wrote:
> > > * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [140612 23:48]:
> > > > On Thursday 12 June 2014 22:30:44 Tony Lindgren wrote:
> > > > > 1. They live in separate hardware modules that can be clocked
> > > > > separately
> > > > 
> > > > Actually I don't think that's true. The CSI2 PHY is part of the camera
> > > > device, with all its registers but the one above in the camera device
> > > > register space. For some weird reason a couple of bits were pushed to
> > > > the control module, but that doesn't make the CSI2 PHY itself a
> > > > separate device.
> > > 
> > > Yes they are separate. Anything in the system control module is
> > > a separate hardware module from the other devices. So in this case
> > > the CSI2 PHY is part of the system control module, not the camera
> > > module.
> > 
> > Section 8.2.3 ("ISS CSI2 PHY") of the OMAP4460 TRM (revision AA) documents
> > the CSI2 PHY is being part of the ISS, with three PHY registers in the
> > ISS register space (not counting the PHY interrupt and status bits in
> > several other ISS registers) and one register in the system control
> > module register space. It's far from clear which power domain(s) is (are)
> > involved.
>
> OK I see. The register in the system control module just contains some
> pin and clock related resources for the phy.

And the configuration of the PHY mode (CCP2, CSI1 or CSI2). It really seems 
like random bits :-)

> > > > > 2. Doing a read-back to flush a posted write in one hardware module
> > > > >    most likely won't flush the write to other and that can lead into
> > > > >    hard to find mysterious bugs
> > > > 
> > > > The OMAP4 ISS driver can just read back the CAMERA_RX register, can't
> > > > it ?
> > > 
> > > Right, but you would have to do readbacks both from the phy register and
> > > camera register to ensure writes get written. It's best to keep the
> > > logic completely separate especially considering that they can be
> > > clocked separately.
> > > 
> > > > > 3. If we ever have a common system control module driver, we need to
> > > > >    rewrite all the system control module register tinkering in the
> > > > >    drivers
> > > > 
> > > > Sure, but that's already the case today, as the OMAP4 ISS driver
> > > > already accesses the control module register directly. I won't make
> > > > that worse :-)
> > > 
> > > Well it's in staging for a reason :)
> > > 
> > > > > So it's best to try to use an existing framework for it. That avoids
> > > > > tons of pain later on ;)
> > > > 
> > > > I agree, but I don't think the PHY framework would be the right
> > > > abstraction. As explained above the CSI2 PHY is part of the OMAP4 ISS,
> > > > so modeling its single control module register as a PHY would be a
> > > > hack.
> > > 
> > > Well that register belongs to the system control module, not the
> > > camera module. It's not like the camera IO space is out of registers
> > > or something! :)
> > 
> > The PHY has 3 registers in the ISS I/O space and one register in the
> > control module I/O space. I have no idea why they've split it that way.
> > The clock enable bits are especially "interested", the source clock
> > (CAM_PHY_CTRL_FCLK) comes from the ISS as documented in section 8.1.1
> > ("ISS Integration"), is gated by the control module (the gated clock is
> > called CTRLCLK) and then goes back to the ISS CSI2 PHY (it's mentioned in
> > the CSI2 PHY "REGISTER1" documentation).
> > 
> > > We're already handling similar control module phy cases, see for
> > > example drivers/phy/phy-omap-control.c. Maybe you have most of the
> > > code already there?
> > 
> > I'm afraid not. For PHYs that are in the system control module that
> > solution is perfectly fine, but the CSI2 PHY isn't (or at least not all
> > of it).
> > 
> > I would be fine with writing a separate PHY driver if the PHY was
> > completely separate. As the documentation doesn't make it clear which
> > part of the hardware belongs to which module, matching the software
> > implementation with an unknown hardware implementation would be pretty
> > difficult :-)
> 
> Yeah it seems the phy driver would still have to use the pin resources
> in the system control module.
> 
> > If you have a couple of minutes to spare and can look at the CSI2 PHY
> > documentation in the TRM, you might be more successful than me figuring
> > out how the hardware is implemented.
> 
> Took a look and it seems the phy is split into two parts. So probably
> using the syscon mapping for the register in scm are is a good start.
> At least then there's some protection from drivers tinkering directly
> with the system control modules.

That's my plan.

> Maybe s	ee what drivers/regulator/pbias-regulator.c is doing with
> syscon to see if that works? Moving that to some phy driver later on
> should be trivial if needed :)

I'll have a look, but I'm not sure whether the same approach will be possible.

-- 
Regards,

Laurent Pinchart

