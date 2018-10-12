Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55577 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbeJLQKv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 12:10:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id 206-v6so11499994wmb.5
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2018 01:39:27 -0700 (PDT)
Date: Fri, 12 Oct 2018 09:39:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD
 driver
Message-ID: <20181012083924.GW4939@dell>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-5-vz@mleia.com>
 <20181012060314.GU4939@dell>
 <63733d2e-f95e-8894-f2b0-0b551b5cfeeb@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63733d2e-f95e-8894-f2b0-0b551b5cfeeb@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Oct 2018, Vladimir Zapolskiy wrote:
> On 10/12/2018 09:03 AM, Lee Jones wrote:
> > On Tue, 09 Oct 2018, Vladimir Zapolskiy wrote:
> > 
> >> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >>
> >> The change adds I2C device driver for TI DS90Ux9xx de-/serializers,
> >> support of subdevice controllers is done in separate drivers, because
> >> not all IC functionality may be needed in particular situations, and
> >> this can be fine grained controlled in device tree.
> >>
> >> The development of the driver was a collaborative work, the
> >> contribution done by Balasubramani Vivekanandan includes:
> >> * original implementation of the driver based on a reference driver,
> >> * regmap powered interrupt controller support on serializers,
> >> * support of implicitly or improperly specified in device tree ICs,
> >> * support of device properties and attributes: backward compatible
> >>   mode, low frequency operation mode, spread spectrum clock generator.
> >>
> >> Contribution by Steve Longerbeam:
> >> * added ds90ux9xx_read_indirect() function,
> >> * moved number of links property and added ds90ux9xx_num_fpd_links(),
> >> * moved and updated ds90ux9xx_get_link_status() function to core driver,
> >> * added fpd_link_show device attribute.
> >>
> >> Sandeep Jain added support of pixel clock edge configuration.
> >>
> >> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >> ---
> >>  drivers/mfd/Kconfig           |  14 +
> >>  drivers/mfd/Makefile          |   1 +
> >>  drivers/mfd/ds90ux9xx-core.c  | 879 ++++++++++++++++++++++++++++++++++
> >>  include/linux/mfd/ds90ux9xx.h |  42 ++
> >>  4 files changed, 936 insertions(+)
> >>  create mode 100644 drivers/mfd/ds90ux9xx-core.c
> >>  create mode 100644 include/linux/mfd/ds90ux9xx.h
> >>
> >> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> >> index 8c5dfdce4326..a969fa123f64 100644
> >> --- a/drivers/mfd/Kconfig
> >> +++ b/drivers/mfd/Kconfig
> >> @@ -1280,6 +1280,20 @@ config MFD_DM355EVM_MSP
> >>  	  boards.  MSP430 firmware manages resets and power sequencing,
> >>  	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
> >>  
> >> +config MFD_DS90UX9XX
> >> +	tristate "TI DS90Ux9xx FPD-Link de-/serializer driver"
> >> +	depends on I2C && OF
> >> +	select MFD_CORE
> >> +	select REGMAP_I2C
> >> +	help
> >> +	  Say yes here to enable support for TI DS90UX9XX de-/serializer ICs.
> >> +
> >> +	  This driver provides basic support for setting up the de-/serializer
> >> +	  chips. Additional functionalities like connection handling to
> >> +	  remote de-/serializers, I2C bridging, pin multiplexing, GPIO
> >> +	  controller and so on are provided by separate drivers and should
> >> +	  enabled individually.
> > 
> > This is not an MFD driver.
> 
> Why do you think so? The representation of the ICs into device tree format
> of hardware description shows that this is a truly MFD driver with multiple
> IP subcomponents naturally mapped into MFD cells.

This driver does too much real work ('stuff') to be an MFD driver.
MFD drivers should not need to care of; links, gates, modes, pixels,
frequencies maps or properties.  Nor should they contain elaborate
sysfs structures to control the aforementioned 'stuff'.

Granted, there may be some code in there which could be appropriate
for an MFD driver.  However most of it needs moving out into a
function driver (or two).

> Basically it is possible to replace explicit of_platform_populate() by
> adding a "simple-mfd" compatible, if it is desired.
> 
> > After a 30 second Google of what this device actually does, perhaps
> > drivers/media might be a better fit?
> 
> I assume it would be quite unusual to add a driver with NO media functions
> and controls into drivers/media.

drivers/media may very well not be the correct place for this.  In my
30 second Google, I saw that this device has a lot to do with cameras,
hence my media association.

If *all* else fails, there is always drivers/misc, but this should be
avoided if at all possible.

> Laurent, can you please share your opinion?

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
