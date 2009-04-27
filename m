Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110813.mail.gq1.yahoo.com ([67.195.13.236]:48639 "HELO
	web110813.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756659AbZD0Mol convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 08:44:41 -0400
Message-ID: <405485.44210.qm@web110813.mail.gq1.yahoo.com>
Date: Mon, 27 Apr 2009 05:44:40 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel module
To: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Tue, 4/21/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel module
> To: "Trent Piepho" <xyzzy@speakeasy.org>
> Cc: "Uri Shkolnik" <urishk@yahoo.com>, linux-media@vger.kernel.org
> Date: Tuesday, April 21, 2009, 9:10 PM
> On Tue, 21 Apr 2009 10:54:40 -0700
> (PDT)
> Trent Piepho <xyzzy@speakeasy.org>
> wrote:
> 
> > On Tue, 21 Apr 2009, Uri Shkolnik wrote:
> > > --- On Tue, 4/21/09, Trent Piepho <xyzzy@speakeasy.org>
> wrote:
> > > > From: Trent Piepho <xyzzy@speakeasy.org>
> > > > Subject: Re: [PATCH] [0904_14] Siano:
> assemble all components to one kernel module
> > > > To: "Uri Shkolnik" <urishk@yahoo.com>
> > > > Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
> "LinuxML" <linux-media@vger.kernel.org>
> > > > Date: Tuesday, April 21, 2009, 6:17 AM
> > > > On Mon, 20 Apr 2009, Uri Shkolnik
> > > > wrote:
> > > > >
> > > > > "better to have the BUS configurable,
> e. g. just
> > > > because you have USB interface, it doesn't
> mean that you
> > > > want siano for USB, instead of using SDIO."
> > > > >
> > > > > Since the module is using dynamic
> registration, I
> > > > don't find it a problem.
> > > > > When the system has both USB and SDIO
> buses, both USB
> > > > and SDIO interface driver will be compiled
> and linked to the
> > > > module. When a Siano based device (or
> multiple Siano
> > > > devices) will be connected, they will be
> register internally
> > > > in the core and activated. Any combination
> is allow
> > > > (multiple SDIO, multiple USB and any mix).
> > > >
> > > > This is not the way linux drivers normally
> work. 
> > > > Usually there are
> > > > multiple modules so that only the ones that
> need to be
> > > > loaded are loaded.
> > > > It sounds like you are designing this to be
> custom compiled
> > > > for each
> > > > system, but that's not usually they way
> things work.
> > >
> > > I think I didn't express myself clearly.
> > >
> > > Lets say that someone build a kernel X.
> > > This kernel has (from all buses) only USB. The
> Siano module will build with USB interface driver at this
> system.
> > >
> > > If the system includes SDIO and OMAP SPI/SPP, the
> module build will discard the USB interface driver, but the
> SDIO and the OMAP SPI will be built.
> 
> The patch you've provided just merge everything. If you're
> proposing a newer
> model, you should send a patchset with the complete Kbuild
> refactor. For now,
> it is better to postpone this patch until we merge
> non-kbuild changes.
> 
> > Can you name another driver that works this way? 
> It is considered better
> > to build a new module for a different interface. 
> That way one can decide
> > at run time if the interface is needed or not and only
> load the module if
> > needed.  If everything is built into one module
> then one must decide at
> > compile time what interfaces to support.  But it
> is often the case that
> > kernels are compiled on different systems than run
> them.
> 
> This model also sounds different to me from what I've seen
> so far.
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Hi,

Lets review some other DVB enabled modules

1) PLUTO Kconfig

config DVB_PLUTO2
	tristate "Pluto2 cards"
	depends on DVB_CORE && PCI && I2C
	select I2C_ALGOBIT
	select DVB_TDA1004X
	help
	  Support for PCI cards based on the Pluto2 FPGA like the Satelco
	  Easywatch Mobile Terrestrial DVB-T Receiver.

	  Since these cards have no MPEG decoder onboard, they transmit
	  only compressed MPEG data over the PCI bus, so you need
	  an external software decoder to watch TV on your computer.

	  Say Y or M if you own such a device and want to use it.


As we can see, it depends on PCI and I2C (and DVB_CORE, but that is outside the current discussion), which means, that if the target system lacks either PCI or I2C (and many Linux target do not have those) the entire Pluto module will not be built, even if selected.

DM1105 - similar case.

TTUSB_BUDGET -

config DVB_TTUSB_BUDGET
	tristate "Technotrend/Hauppauge Nova-USB devices"
	depends on DVB_CORE && USB && I2C && PCI
	select DVB_CX22700 if !DVB_FE_CUSTOMISE
	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
	select DVB_VES1820 if !DVB_FE_CUSTOMISE
	select DVB_TDA8083 if !DVB_FE_CUSTOMISE
	select DVB_STV0299 if !DVB_FE_CUSTOMISE
	select DVB_STV0297 if !DVB_FE_CUSTOMISE
	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
	help
	  Support for external USB adapters designed by Technotrend and
	  produced by Hauppauge, shipped under the brand name 'Nova-USB'.

	  These devices don't have a MPEG decoder built in, so you need
	  an external software decoder to watch TV.

	  Say Y if you own such a device and want to use it.

This module while not be build (even if chosen) on target system that lacks USB stack (additional to PCI and I2C).

There are many many other examples.

First, SMS (Siano based device) requires at least one available bus (either USB, SDIO, SPI/SPP, HIF/Parallel, TS_I2C, ....), not a combination like the TTUSB. (Note, if multiple buses available, the module can use them simultaneously, for example - two different instances (SDIO and USB) dongles may co-exist on the same system). 

There is no reason to prevent some systems which have only SDIO interface to work if there is no USB and vice versa. 

Only if there are no supported (by SMS) buses at all, the drive will not be built.

Second, in order to reduce module size, there is no need to compile and link to the binary module a bus interface component that will never be used, more than that, if there are no suitable (external) headers, the build process will fail.
So, the Kconfig and Makefile need to ensure that the module will be built and function OK on target systems which have full set AND subset of the total supported buses (by SMS). 

Uri 




      
