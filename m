Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:49350 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZD1S6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 14:58:37 -0400
Date: Tue, 28 Apr 2009 11:58:36 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Uri Shkolnik <urishk@yahoo.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel
 module
In-Reply-To: <405485.44210.qm@web110813.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.58.0904281140170.7837@shell2.speakeasy.net>
References: <405485.44210.qm@web110813.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Apr 2009, Uri Shkolnik wrote:
> --- On Tue, 4/21/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > > If the system includes SDIO and OMAP SPI/SPP, the
> > module build will discard the USB interface driver, but the
> > SDIO and the OMAP SPI will be built.
> >
> > The patch you've provided just merge everything. If you're
> > proposing a newer
> > model, you should send a patchset with the complete Kbuild
> > refactor. For now,
> > it is better to postpone this patch until we merge
> > non-kbuild changes.
> >
> > > Can you name another driver that works this way? 
> > It is considered better
> > > to build a new module for a different interface. 
> > That way one can decide
> > > at run time if the interface is needed or not and only
> > load the module if
> > > needed.  If everything is built into one module
> > then one must decide at
> > > compile time what interfaces to support.  But it
> > is often the case that
> > > kernels are compiled on different systems than run
> > them.
> >
> > This model also sounds different to me from what I've seen
> > so far.
> >
>
> 1) PLUTO Kconfig
>
> config DVB_PLUTO2
> 	tristate "Pluto2 cards"
> 	depends on DVB_CORE && PCI && I2C
> As we can see, it depends on PCI and I2C (and DVB_CORE, but that is outside the current discussion), which means, that if the target system lacks either PCI or I2C (and many Linux target do not have those) the entire Pluto module will not be built, even if selected.

I do not think you understand.  This driver is for a device that is access
via a PCI bus.  It creates an i2c adapter that is used to control the tuner
chip on the device.  The device is not accessed via i2c.  What's more, and
this is a key point you are missing, it can not be accessed by PCI *or*
I2C.  This is the same with all the other drivers you may have found that
use both PCI and I2C.  It's a totally different situation.

Look at the how the B2C2 flexcop driver works.  This hardware is availble
in both PCI and USB versions.


> config DVB_TTUSB_BUDGET
> 	tristate "Technotrend/Hauppauge Nova-USB devices"
> 	depends on DVB_CORE && USB && I2C && PCI
> 	  Support for external USB adapters designed by Technotrend and
>
> This module while not be build (even if chosen) on target system that lacks USB stack (additional to PCI and I2C).

This looks like a mistake.  The driver is for a USB device and should not
depend on PCI, but the driver uses the pci dma api.

> First, SMS (Siano based device) requires at least one available bus (either USB, SDIO, SPI/SPP, HIF/Parallel, TS_I2C, ....), not a combination like the TTUSB. (Note, if multiple buses available, the module can use them simultaneously, for example - two different instances (SDIO and USB) dongles may co-exist on the same system).
>
> There is no reason to prevent some systems which have only SDIO interface to work if there is no USB and vice versa.
>
> Only if there are no supported (by SMS) buses at all, the drive will not be built.
>
> Second, in order to reduce module size, there is no need to compile and link to the binary module a bus interface component that will never be used, more than that, if there are no suitable (external) headers, the build process will fail.
> So, the Kconfig and Makefile need to ensure that the module will be built and function OK on target systems which have full set AND subset of the total supported buses (by SMS).

The point you are missing is that by compiling all support into one module
you are forcing the supported busses to be chosen at compile time.  If
they were separate modules then the supported busses could be loaded
at run time.
