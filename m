Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46694 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbeJLUji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 16:39:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD driver
Date: Fri, 12 Oct 2018 16:07:16 +0300
Message-ID: <2403149.qmrOGLNKPu@avalon>
In-Reply-To: <3b22c550-0cba-60d7-a8ed-400265c8a9f6@mentor.com>
References: <20181008211205.2900-1-vz@mleia.com> <20181012083924.GW4939@dell> <3b22c550-0cba-60d7-a8ed-400265c8a9f6@mentor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

On Friday, 12 October 2018 14:24:08 EEST Vladimir Zapolskiy wrote:
> On 10/12/2018 11:39 AM, Lee Jones wrote:
> > On Fri, 12 Oct 2018, Vladimir Zapolskiy wrote:
> >> On 10/12/2018 09:03 AM, Lee Jones wrote:
> >>> On Tue, 09 Oct 2018, Vladimir Zapolskiy wrote:
> >>>> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >>>> 
> >>>> The change adds I2C device driver for TI DS90Ux9xx de-/serializers,
> >>>> support of subdevice controllers is done in separate drivers, because
> >>>> not all IC functionality may be needed in particular situations, and
> >>>> this can be fine grained controlled in device tree.
> >>>> 
> >>>> The development of the driver was a collaborative work, the
> >>>> contribution done by Balasubramani Vivekanandan includes:
> >>>> * original implementation of the driver based on a reference driver,
> >>>> * regmap powered interrupt controller support on serializers,
> >>>> * support of implicitly or improperly specified in device tree ICs,
> >>>> * support of device properties and attributes: backward compatible
> >>>> 
> >>>>   mode, low frequency operation mode, spread spectrum clock generator.
> >>>> 
> >>>> Contribution by Steve Longerbeam:
> >>>> * added ds90ux9xx_read_indirect() function,
> >>>> * moved number of links property and added ds90ux9xx_num_fpd_links(),
> >>>> * moved and updated ds90ux9xx_get_link_status() function to core
> >>>> driver,
> >>>> * added fpd_link_show device attribute.
> >>>> 
> >>>> Sandeep Jain added support of pixel clock edge configuration.
> >>>> 
> >>>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >>>> ---
> >>>> 
> >>>>  drivers/mfd/Kconfig           |  14 +
> >>>>  drivers/mfd/Makefile          |   1 +
> >>>>  drivers/mfd/ds90ux9xx-core.c  | 879 ++++++++++++++++++++++++++++++++++
> >>>>  include/linux/mfd/ds90ux9xx.h |  42 ++
> >>>>  4 files changed, 936 insertions(+)
> >>>>  create mode 100644 drivers/mfd/ds90ux9xx-core.c
> >>>>  create mode 100644 include/linux/mfd/ds90ux9xx.h
> >>>> 
> >>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> >>>> index 8c5dfdce4326..a969fa123f64 100644
> >>>> --- a/drivers/mfd/Kconfig
> >>>> +++ b/drivers/mfd/Kconfig
> >>>> @@ -1280,6 +1280,20 @@ config MFD_DM355EVM_MSP
> >>>> 
> >>>>  	  boards.  MSP430 firmware manages resets and power sequencing,
> >>>>  	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
> >>>> 
> >>>> +config MFD_DS90UX9XX
> >>>> +	tristate "TI DS90Ux9xx FPD-Link de-/serializer driver"
> >>>> +	depends on I2C && OF
> >>>> +	select MFD_CORE
> >>>> +	select REGMAP_I2C
> >>>> +	help
> >>>> +	  Say yes here to enable support for TI DS90UX9XX de-/serializer 
ICs.
> >>>> +
> >>>> +	  This driver provides basic support for setting up the
> >>>> de-/serializer
> >>>> +	  chips. Additional functionalities like connection handling to
> >>>> +	  remote de-/serializers, I2C bridging, pin multiplexing, GPIO
> >>>> +	  controller and so on are provided by separate drivers and should
> >>>> +	  enabled individually.
> >>> 
> >>> This is not an MFD driver.
> >> 
> >> Why do you think so? The representation of the ICs into device tree
> >> format of hardware description shows that this is a truly MFD driver with
> >> multiple IP subcomponents naturally mapped into MFD cells.
> > 
> > This driver does too much real work ('stuff') to be an MFD driver.
> > MFD drivers should not need to care of; links, gates, modes, pixels,
> > frequencies maps or properties.  Nor should they contain elaborate
> > sysfs structures to control the aforementioned 'stuff'.
> 
> What is the reason why device drivers for sort of multimedia ICs like
> WL1273, WM8994 and other numerous codecs are found in drivers/mfd?

I won't comment on those because I don't know them (Lee might have a better 
knowledge in this area), but let's not rule out historical mistakes, that we 
may not want to repeat.

> If the same reason can not be applied to this DS90Ux9xx driver, why?
> 
> > Granted, there may be some code in there which could be appropriate
> > for an MFD driver.  However most of it needs moving out into a
> > function driver (or two).
> > 
> >> Basically it is possible to replace explicit of_platform_populate() by
> >> adding a "simple-mfd" compatible, if it is desired.
> >> 
> >>> After a 30 second Google of what this device actually does, perhaps
> >>> drivers/media might be a better fit?
> >> 
> >> I assume it would be quite unusual to add a driver with NO media
> >> functions and controls into drivers/media.
> > 
> > drivers/media may very well not be the correct place for this.  In my
> > 30 second Google, I saw that this device has a lot to do with cameras,
> > hence my media association.
> 
> Well, the argument is similar to the statement that Google says that
> camera sensors *can* be connected to NXP i.MX6 SoC, thus arch/arm/mach-imx
> contents should be placed into drivers/media

If there are any camera drivers in arch/arm/mach-imx, they should certainly be 
moved.

> A few TI DS90Ux9xx *cell* drivers may be added to drivers/media, but it is
> out of the scope of the current series, which is completely integral per se,
> and actually the cover letter says that the series of drivers immediately
> allows to output video over DRM to panels, but the discussion is around
> sensors by some reason.

Possibly because a quick search for more information about the device returned 
camera use cases. Let's not focus on that.

> But I hope it won't be seen as a misleading reason to consider to add the
> MFD driver into drivers/gpu/drm

Not a misleading one, a very good one :-) This should go in drivers/gpu/drm/
bridge/.

> > If *all* else fails, there is always drivers/misc, but this should be
> > avoided if at all possible.
> 
> drivers/misc does not sound like a proper place for the MFD driver...

drivers/misc/ isn't right either.

> >> Laurent, can you please share your opinion?

-- 
Regards,

Laurent Pinchart
