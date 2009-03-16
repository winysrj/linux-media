Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:37415 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZCPLSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 07:18:20 -0400
Date: Mon, 16 Mar 2009 12:18:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090316121801.1c03d747@hyperion.delvare>
In-Reply-To: <20090316063402.1b0da1f3@gaivota.chehab.org>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
	<20090315185313.4c15702c@hyperion.delvare>
	<20090316063402.1b0da1f3@gaivota.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 16 Mar 2009 06:34:02 -0300, Mauro Carvalho Chehab wrote:
> On Sun, 15 Mar 2009 18:53:13 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> > On Sun, 15 Mar 2009 10:42:41 -0700 (PDT), Trent Piepho wrote:
> > > You can also split the "device" into multiple devices.  Most SoCs have one
> > > register block where all kinds of devices, from i2c controllers to network
> > > adapters, exist.  This is shown to linux as many devices, rather than one
> > > massive multifunction device.
> > 
> > It really depends on the device type. You can't split an I2C or PCI
> > device that way.
> 
> In the case of PCI, you can. There are several devices where you have a PCI
> bridge inside the chip. The PCI bus identifies such cases and create a PCI
> sub-bus to handle this. This is what happens by default with cx88 drivers
> (where we have up to 4 different PCI devices at the same chip) and with devices
> with multiple bt848 chips, inside the same board.

Sorry for not being clear. I really meant "PCI device" as in "what
Linux considers a PCI device", which is a PCI function at the PCI bus
level. I didn't mean "PCI device" as in "TV card which plugs into a PCI
slot". I am fully aware that TV cards can show up as several entries in
the output of lspci.

Yeah, the term "device" can mean many different things and it can get
very confusing at times :(

> Of course, a subdev information is attached inside the BUS address on this case.
> 
> I suspect that we may need to have something like this, in order to support
> some complex devices that use I2C. It seems to be very common those days to
> have a device using a subaddress to address different functions. 
> 
> With the current approach, we need to bind two completely different things
> inside the same i2c module, which may result in a very poor design.

I really don't see any problem there. There are many drivers (i2c or
not) in the kernel which do exactly this and this works just fine. We
even have a directory for (some of) them: drivers/mfd. For other
drivers, we either have broader categories in Linux, or we put the
driver in the category which is the more meaningful. For example, many
hwmon drivers include several functions: voltage monitoring,
temperature monitoring, fan speed monitoring, fan speed control (either
manual or automatic), chassis intrusion detection, etc. Some even
include a watchdog. We have decided to put all these drivers under
drivers/hwmon, and this didn't cause any problem so far. Some other
chips have hardware monitoring has a secondary feature and as a result
they live in other directories but still register has a hwmon (class)
device. Again, nothing wrong with that.

While I agree that in an ideal world each device would serve just one
function so we can put each driver in the right directory and have many
small and easy to maintain drivers, in the case where we have a
multi-function device, the solutions to handle it already exist.

> Getting back to the problem Hans discovered with PV951, This board was
> introduced by the initial CVS commit that populates the tree, dated as Sun Feb
> 22 01:59:34 2004 +0000, on changeset#784.
> 
> So, this is more ancient than 2.6.11. This driver were probably added during
> 2.5 development cycle or even before, together with i2c introduction in kernel.
> So, I really don't doubt that on that time it were possible to have two boards
> sharing the same address. To be sure, when this were added, we would need to
> followup the Kernel past history before -git.

You can just look at Thomas Gleixner's excellent history tree:
http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=summary

> By looking at tvaudio, it really seems that they used the same I2C address, but
> 2 different I2C subaddress for two completely independent things:
> 
> +/* the registers of 16C54, I2C sub address. */
> +#define PIC16C54_REG_KEY_CODE     0x01        /* Not use. */
> +#define PIC16C54_REG_MISC         0x02
> 
> It seems clear by the code that address 0x48 subaddress 0x01 is for IR and address
> 0x48 subaddress 0x02 is for audio.
> 
> Since the Input subsystem is something completely independent from the audio
> one, and even agreeding that generic modules like tvaudio and i2c-ir-kbd are
> not the proper way, we shouldn't mix the input susbystem stuff with audio at
> the same driver. Those are completely unrelated things. The proper design would
> be to have one different driver for each address/subaddress pair.

This is one possible design, yes. Having both functions handled by the
same driver (and I really wrote driver, as in struct i2c_driver, and
not module) is another possible design, and honestly I don't see any
problem with it. You are totally free to put the separate functions
into separate source files or even separate modules to keep the code
clean. Then all you need is some glue and exported functions to make
all pieces work together.

> So, in this case, I2C should not expose this driver as:
> 
> /sys/devices/.../i2c-adapter/i2c-3/3-0096
> 
> But, instead, create a subbus, just like PCI, exposing it as:

PCI doesn't do this, no. The way each device organizes its register map
(which is really what we are talking about here) has _nothing_ to do
with bus topology.

> /sys/devices/.../i2c-adapter/i2c-3/3-0096-1
> /sys/devices/.../i2c-adapter/i2c-3/3-0096-2
> 
> And letting to bind one module at address 0096-1 (for IR) and another at 0096-2 (for audio).

I fear this is never going to happen. We have a model which works
today, you propose to change it for another one which would work too.
Without an excellent reason to justify this change, I can't see why we
would change anything here at the cost of a compatibility breakage.

Also, please let's not lose focus here. The important thing here is to
finish the conversion to the new i2c device driver binding model, and
quickly.

Thanks,
-- 
Jean Delvare
