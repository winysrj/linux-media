Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58942 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaFMGrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 02:47:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, arm@kernel.org
Subject: Re: [PATCH] [media] staging: allow omap4iss to be modular
Date: Fri, 13 Jun 2014 08:47:34 +0200
Message-ID: <1830688.7p3Fp6u7a2@avalon>
In-Reply-To: <20140613053044.GG17845@atomide.com>
References: <5192928.MkINji4uKU@wuerfel> <1689719.caqIIBS1Wn@avalon> <20140613053044.GG17845@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Thursday 12 June 2014 22:30:44 Tony Lindgren wrote:
> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [140612 08:32]:
> > On Thursday 12 June 2014 08:15:35 Tony Lindgren wrote:
> >> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [140612 07:52]:
> >>> On Wednesday 11 June 2014 07:47:54 Tony Lindgren wrote:
> >>>> These should just use either pinctrl-single.c instead for muxing.
> >>>> Or if they are not mux registers, we do have the syscon mapping
> >>>> available in omap4.dtsi that pbias-regulator.c is already using.
> >>>> 
> >>>> Laurent, got any better ideas?
> >>> 
> >>> The ISS driver needs to write a single register, which contains
> >>> several independent fields. They thus need to be controlled by a
> >>> single driver. Some of them might be considered to be related to
> >>> pinmuxing (although I disagree on that), others are certainly not
> >>> about muxing (there are clock gate bits for instance).
> >>> 
> >>> Using the syscon mapping seems like the best option. I'll give it a
> >>> try.
> >> 
> >> OK if it's not strictly pinctrl related then let's not use
> >> pinctrl-single,bits for it. You may be able to implement one or more
> >> framework drivers for it for pinctrl/regulator/clock/transceiver
> >> whatever that register is doing.
> >> 
> >> In any case it's best to have that handling in a separate helper driver
> >> somewhere as it's a separate piece of hardware from the camera module.
> >> If it does not fit into any existing frameworks then it's best to have
> >> it in a separate driver with the camera driver.
> > 
> > The register contains the following fields that control the two CSI2 PHYs
> > (PHY1 and PHY2).
> > 
> > 31    CAMERARX_CSI22_LANEENABLE2   PHY2 Lane 2 (CSI22_DX2, CSI22_DY2)
> > Enable
> > 30    CAMERARX_CSI22_LANEENABLE1   PHY2 Lane 1 (CSI22_DX1, CSI22_DY1)
> > Enable
> > 29    CAMERARX_CSI22_LANEENABLE0   PHY2 Lane 0 (CSI22_DX0, CSI22_DY0)
> > Enable
> > 28    CAMERARX_CSI21_LANEENABLE4   PHY1 Lane 4 (CSI21_DX4, CSI21_DY4)
> > Enable
> > 27    CAMERARX_CSI21_LANEENABLE3   PHY1 Lane 3 (CSI21_DX3, CSI21_DY3)
> > Enable
> > 26    CAMERARX_CSI21_LANEENABLE2   PHY1 Lane 2 (CSI21_DX2, CSI21_DY2)
> > Enable
> > 25    CAMERARX_CSI21_LANEENABLE1   PHY1 Lane 1 (CSI21_DX1, CSI21_DY1)
> > Enable
> > 24    CAMERARX_CSI21_LANEENABLE0   PHY1 Lane 0 (CSI21_DX0, CSI21_DY0)
> > Enable
> > 21    CAMERARX_CSI22_CTRLCLKEN     PHY2 Clock Enable
> > 20:19 CAMERARX_CSI22_CAMMODE       PHY2 Mode (CCP2, CSI1, CSI2)
> > 18    CAMERARX_CSI21_CTRLCLKEN     PHY1 Clock Enable
> > 17:16 CAMERARX_CSI21_CAMMODE       PHY1 Mode (CCP2, CSI1, CSI2)
> > 
> > Bits 18 and 21 could be exposed through CCF. Bits 24 to 31 enable/disable
> > the CSI2 lanes, so it could be argued that they could be exposed through
> > the pinctrl framework. However, they need to be configured independently,
> > possibly at runtime. I'm thus not sure pinctrl would be a good idea. Bits
> > 17:16 and 20:19 don't fit in existing frameworks.
> 
> OK thanks for the info. Sounds like drivers/phy might be the right location
> for it then and then the phy driver can use the syscon regmap.
>
> > Given that this register is specific to the ISS, I think handling it as a
> > separate device through a separate driver would only complicate the
> > implementation without any real benefit.
> 
> Even though it's one register, it shoud still be treated separately from
> the camera driver. The problems with keeping the register access to the
> control module in the camera driver are at least following:
> 
> 1. They live in separate hardware modules that can be clocked separately

Actually I don't think that's true. The CSI2 PHY is part of the camera device, 
with all its registers but the one above in the camera device register space. 
For some weird reason a couple of bits were pushed to the control module, but 
that doesn't make the CSI2 PHY itself a separate device.

> 2. Doing a read-back to flush a posted write in one hardware module most
>    likely won't flush the write to other and that can lead into hard to
>    find mysterious bugs

The OMAP4 ISS driver can just read back the CAMERA_RX register, can't it ?

> 3. If we ever have a common system control module driver, we need to
>    rewrite all the system control module register tinkering in the drivers

Sure, but that's already the case today, as the OMAP4 ISS driver already 
accesses the control module register directly. I won't make that worse :-)

> So it's best to try to use an existing framework for it. That avoids tons of
> pain later on ;)

I agree, but I don't think the PHY framework would be the right abstraction. 
As explained above the CSI2 PHY is part of the OMAP4 ISS, so modeling its 
single control module register as a PHY would be a hack. 

-- 
Regards,

Laurent Pinchart

