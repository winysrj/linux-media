Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZCPJef (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 05:34:35 -0400
Date: Mon, 16 Mar 2009 06:34:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090316063402.1b0da1f3@gaivota.chehab.org>
In-Reply-To: <20090315185313.4c15702c@hyperion.delvare>
References: <200903151344.01730.hverkuil@xs4all.nl>
 <20090315181207.36d951ac@hyperion.delvare>
 <Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
 <20090315185313.4c15702c@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 18:53:13 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> On Sun, 15 Mar 2009 10:42:41 -0700 (PDT), Trent Piepho wrote:
> > On Sun, 15 Mar 2009, Jean Delvare wrote:
> > > On Sun, 15 Mar 2009 13:44:01 +0100, Hans Verkuil wrote:
> > > This is the typical multifunction device problem. It isn't specifically
> > > related to I2C, the exact same problem happens for other devices, for
> > > example a PCI south bridge including hardware monitoring and SMBus, or
> > > a Super-I/O chip including hardware monitoring, parallel port,
> > > infrared, watchdog, etc. Linux currently only allows one driver to bind
> > > to a given device, so it becomes very difficult to make per-function
> > > drivers for such devices.
> > >
> > > For very specific devices, it isn't necessarily a big problem. You can
> > > simply make an all-in-one driver for that specific device. The real
> > > problem is when the device in question is fully compatible with other
> > > devices which only implement functionality A _and_ fully compatible with
> > > other devices which only implement functionality B. You don't really
> > > want to support functions A and B in the same driver if most devices
> > > out there have either function but not both.
> > 
> > You can also split the "device" into multiple devices.  Most SoCs have one
> > register block where all kinds of devices, from i2c controllers to network
> > adapters, exist.  This is shown to linux as many devices, rather than one
> > massive multifunction device.
> 
> It really depends on the device type. You can't split an I2C or PCI
> device that way.

In the case of PCI, you can. There are several devices where you have a PCI
bridge inside the chip. The PCI bus identifies such cases and create a PCI
sub-bus to handle this. This is what happens by default with cx88 drivers
(where we have up to 4 different PCI devices at the same chip) and with devices
with multiple bt848 chips, inside the same board.

Of course, a subdev information is attached inside the BUS address on this case.

I suspect that we may need to have something like this, in order to support
some complex devices that use I2C. It seems to be very common those days to
have a device using a subaddress to address different functions. 

With the current approach, we need to bind two completely different things
inside the same i2c module, which may result in a very poor design.

-

Getting back to the problem Hans discovered with PV951, This board was
introduced by the initial CVS commit that populates the tree, dated as Sun Feb
22 01:59:34 2004 +0000, on changeset#784.

So, this is more ancient than 2.6.11. This driver were probably added during
2.5 development cycle or even before, together with i2c introduction in kernel.
So, I really don't doubt that on that time it were possible to have two boards
sharing the same address. To be sure, when this were added, we would need to
followup the Kernel past history before -git.

By looking at tvaudio, it really seems that they used the same I2C address, but
2 different I2C subaddress for two completely independent things:

+/* the registers of 16C54, I2C sub address. */
+#define PIC16C54_REG_KEY_CODE     0x01        /* Not use. */
+#define PIC16C54_REG_MISC         0x02

It seems clear by the code that address 0x48 subaddress 0x01 is for IR and address
0x48 subaddress 0x02 is for audio.

Since the Input subsystem is something completely independent from the audio
one, and even agreeding that generic modules like tvaudio and i2c-ir-kbd are
not the proper way, we shouldn't mix the input susbystem stuff with audio at
the same driver. Those are completely unrelated things. The proper design would
be to have one different driver for each address/subaddress pair.

So, in this case, I2C should not expose this driver as:

/sys/devices/.../i2c-adapter/i2c-3/3-0096

But, instead, create a subbus, just like PCI, exposing it as:

/sys/devices/.../i2c-adapter/i2c-3/3-0096-1
/sys/devices/.../i2c-adapter/i2c-3/3-0096-2

And letting to bind one module at address 0096-1 (for IR) and another at 0096-2 (for audio).

Cheers,
Mauro
