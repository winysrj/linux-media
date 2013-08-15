Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54108 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757969Ab3HOOpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 10:45:41 -0400
Date: Thu, 15 Aug 2013 15:45:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Rob Landley <rob@landley.net>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH] media: st-rc: Add ST remote control driver
Message-ID: <20130815144527.GC32421@e106331-lin.cambridge.arm.com>
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
 <20130815084900.GA28366@e106331-lin.cambridge.arm.com>
 <520CD029.7090602@st.com>
 <20130815132911.GB32421@e106331-lin.cambridge.arm.com>
 <520CE056.7010002@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520CE056.7010002@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 15, 2013 at 03:06:14PM +0100, Srinivas KANDAGATLA wrote:
> On 15/08/13 14:29, Mark Rutland wrote:
> > On Thu, Aug 15, 2013 at 01:57:13PM +0100, Srinivas KANDAGATLA wrote:
> >> Thanks Mark for your comments.
> >>
> >> On 15/08/13 09:49, Mark Rutland wrote:
> >>> On Wed, Aug 14, 2013 at 06:27:01PM +0100, Srinivas KANDAGATLA wrote:
> >>>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >>>>
> >>>> This patch adds support to ST RC driver, which is basically a IR/UHF
> >>>> receiver and transmitter. This IP is common across all the ST parts for
> >>>> settop box platforms. IRB is embedded in ST COMMS IP block.
> >>>> It supports both Rx & Tx functionality.
> >>>>
> >>>> In this driver adds only Rx functionality via LIRC codec.
> >>>
> >>> Is there anything that additionally needs to be in the dt to support Tx
> >>> functionality?
> >>
> >> We need an additional boolean property for TX enable.
> > 
> > Why? Becuase you might not have something wired up for Tx?
> Yes.
> > 
> > What needs to be present physically for Tx support?
> An IR transmitter LEDs need to be physically connected.

Ok.

> Also driver need to know about this to setup the IP to do tx.
> > 
> >>
> >> +
> >>
> >> Two more configurable parameters for TX sub-carrier frequency and
> >> duty-cycle. By default driver can set the sub carrier frequency to be
> >> 38Khz and duty cycle as 50%.
> >> However I don't have strong use case to make these configurable.
> >>
> >> So, I think just one boolean property to enable tx should be Ok.
> >>
> >>
> >>>> +Device-Tree bindings for ST IR and UHF receiver
> >>>> +
> >>>> +Required properties:
> >>>> +       - compatible: should be "st,rc".
> >>>
> >>> That "rc" should be made more specific, and it seems like this is a
> >>> subset of a larger block of IP (the ST COMMS IP block). Is this really a
> >>> standalone piece of hardware, or is it always in the larger comms block?
> >> COMMS block is a collection of communication peripherals, and IRB(Infra
> >> red blaster) is always part of the COMMS block.
> >>
> >> May renaming the compatible to "st,comms-rc" might be more clear.
> > 
> > Given the actual name of the hardware seems to include "irb", I think
> > "irb" makes more sense than "rc" in the compatible string. Is there no
> > more specific name than "Infra Red Blaster"?
> 
> There is'nt, its always referred as IRB.
> 
> I will rename the compatible to "st,comms-irb" does this sound Ok?

That sounds fine.

> > 
> >>
> >>>
> >>> What's the full name of this unit as it appears in documentation?
> >> It is always refered as the Communication sub-system (COMMS) which is a
> >> collection of communication peripherals like UART, I2C, SPI, IRB.
> > 
> > Ok, are those separate IP blocks within a container, or is anything
> > shared? Does the COMMS block have any registers shared between those
> > units, for example?
> No, registers are not shared across the IP blocks.

Good to know.

> > 
> >>
> >>>
> >>>> +       - st,uhfmode: boolean property to indicate if reception is in UHF.
> >>>
> >>> That's not a very clear name. Is this a physical property of the device
> >>> (i.e. it's wired to either an IR receiver or a UHF receiver), or is this
> >>> a choice as to how it's used at runtime?
> >>
> >> Its both, some boards have IR and others UHF receivers, So it becomes
> >> board choice here.

Ok, so we can never have both wired up simultaneously? Any board will
have only one of the two wired up (and the other will be unusable
becasue it's not wired up).

> > 
> > When you say it's both, what do you mean? Is it possible for a unit to
> > be wired with both IR and UHF support simultaneously, even if the Linux
> > driver can't handle that?
> > 
> I meant that this property is physical property of the device(board
> wired up to either IR or UHF receiver) and also choice on how the IP is
> configured.
> 
> > The dt should encode information about the hardware, not the way you
> > intend to use the hardware at the present moment in time.
> Ok.
> > 
> >> And also the driver has different register set for UHF receiver and IR
> >> receiver. This options selects which registers to use depending on mode
> >> of reception.
> > 
> > Ok, but that's an implementation issue. If you described that IR *may*
> > be used, and UHF *may* be used, the driver can choose what to do based
> > on that.
> > 
> >>
> >>>
> >>> If it's fixed property of how the device is wired, it might make more
> >>> sense to have a string mode property that's either "uhf" or "infared".
> >>
> >> Am ok with either approaches.
> > 
> > It sounds like we may need separate properties as mentioned above, or a
> > supported-modes list, perhaps.
> 
> I think having rx-mode and tx-mode properties makes more sense rather
> than supported-modes.
> 
> like:
> rx-mode = "uhf";
> 
> or
> 
> rx-mode = "infrared";
> 
> Similarly tx-mode.

That makes sense to me.

> 
> > 
> >>
> >>>
> >>>> +       - reg: base physical address of the controller and length of memory
> >>>> +       mapped  region.
> >>>> +       - interrupts: interrupt number to the cpu. The interrupt specifier
> >>>> +       format depends on the interrupt controller parent.
> >>>> +
> >>>> +Example node:
> >>>> +
> >>>> +       rc: rc@fe518000 {
> >>>> +               compatible      = "st,rc";
> >>>> +               reg             = <0xfe518000 0x234>;
> >>>> +               interrupts      =  <0 203 0>;
> >>>> +       };
> >>>> +
> >>>
> >>> [...]
> >>>
> >>>> +++ b/drivers/media/rc/st_rc.c
> >>>> @@ -0,0 +1,371 @@
> >>>> +/*
> >>>> + * Copyright (C) 2013 STMicroelectronics Limited
> >>>> + * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or modify
> >>>> + * it under the terms of the GNU General Public License as published by
> >>>> + * the Free Software Foundation; either version 2 of the License, or
> >>>> + * (at your option) any later version.
> >>>> + */
> >>>> +#include <linux/kernel.h>
> >>>> +#include <linux/clk.h>
> >>>> +#include <linux/interrupt.h>
> >>>> +#include <linux/module.h>
> >>>> +#include <linux/of.h>
> >>>> +#include <linux/platform_device.h>
> >>>> +#include <media/rc-core.h>
> >>>> +#include <linux/pinctrl/consumer.h>
> >>>> +
> >>>> +struct st_rc_device {
> >>>> +       struct device                   *dev;
> >>>> +       int                             irq;
> >>>> +       int                             irq_wake;
> >>>> +       struct clk                      *sys_clock;
> >>>> +       void                            *base;  /* Register base address */
> >>>> +       void                            *rx_base;/* RX Register base address */
> >>>> +       struct rc_dev                   *rdev;
> >>>> +       bool                            overclocking;
> >>>> +       int                             sample_mult;
> >>>> +       int                             sample_div;
> >>>> +       bool                            rxuhfmode;
> >>>> +};
> >>>
> >>> [...]
> >>>
> >>>> +static void st_rc_hardware_init(struct st_rc_device *dev)
> >>>> +{
> >>>> +       int baseclock, freqdiff;
> >>>> +       unsigned int rx_max_symbol_per = MAX_SYMB_TIME;
> >>>> +       unsigned int rx_sampling_freq_div;
> >>>> +
> >>>> +       clk_prepare_enable(dev->sys_clock);
> >>>
> >>> This clock should be defined in the binding.
> >> Clock is coming for the device tree only.
> >>
> >> I can add the clock and pinctrl bindings to the documentation if it
> >> makes it more clear.
> > 
> > If we need clocks and pinctrl, they should be described form the start.
> > Given we already have the infrastructure, there's no reason not to. Not
> > doing so will only lead to headaches later as we try to keep bindings
> > stable.
> > 
> Ok, I will document them in bindings.
> 

Cheers.

Mark.
