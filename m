Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbZCPMxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 08:53:11 -0400
Date: Mon, 16 Mar 2009 09:52:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090316095237.21775418@gaivota.chehab.org>
In-Reply-To: <20090316121801.1c03d747@hyperion.delvare>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
	<20090315185313.4c15702c@hyperion.delvare>
	<20090316063402.1b0da1f3@gaivota.chehab.org>
	<20090316121801.1c03d747@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009 12:18:01 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> > With the current approach, we need to bind two completely different things
> > inside the same i2c module, which may result in a very poor design.
> 
> I really don't see any problem there. There are many drivers (i2c or
> not) in the kernel which do exactly this and this works just fine. We
> even have a directory for (some of) them: drivers/mfd. For other
> drivers, we either have broader categories in Linux, or we put the
> driver in the category which is the more meaningful. For example, many
> hwmon drivers include several functions: voltage monitoring,
> temperature monitoring, fan speed monitoring, fan speed control (either
> manual or automatic), chassis intrusion detection, etc. Some even
> include a watchdog. We have decided to put all these drivers under
> drivers/hwmon, and this didn't cause any problem so far. Some other
> chips have hardware monitoring has a secondary feature and as a result
> they live in other directories but still register has a hwmon (class)
> device. Again, nothing wrong with that.

In the case of hwmon, it is all about hardware monitoring, so, it is fine to
have all of them grouped.

This is not the case of an input device, and an audio DSP control for some TV
standard.

The input device is a handler for EVDEV events, that has their own dependencies
and needs, while the audio DSP control is part of a group of functions to setup
a certain video/audio standard. You don't need to be streaming a video to use
your IR. 

For IR to work, a driver generally just needs to setup a few GPIO pins at the
driver, and do a glue with I2C bus (or GPIO bus). 

Several designed manufacturer drivers for other O. S. use separate drivers for
IR and for video, since those are completely independent functions just sharing
a very limited set of the chipset resources (the worse case is generally
needing to share up to 4 GPIO registers, the I2C bus and a IRQ line).

It is about the same we had in the past where some audio boards that also had a CD
controller inside (those legacy Sound Blaster devices, for example). The proper 
design were to map, the audio driver to be independent of the ISA driver.

We should really isolate things. On an ideal design, I'd say that we should
have a completely independent bttv-ir driver splitted from the bttv-video,
since someone can use the board just for IR interface, or just video. 

The I2C layer need to be capable of supporting such hardware abstraction level,
instead of forcing to use the same driver for both things. In fact, it does
support the needed abstraction, if the I2C addresses of the two hardwares are
different, but it fails if the difference is at the subaddress level.

> While I agree that in an ideal world each device would serve just one
> function so we can put each driver in the right directory and have many
> small and easy to maintain drivers, in the case where we have a
> multi-function device, the solutions to handle it already exist.
> 
> > Getting back to the problem Hans discovered with PV951, This board was
> > introduced by the initial CVS commit that populates the tree, dated as Sun Feb
> > 22 01:59:34 2004 +0000, on changeset#784.
> > 
> > So, this is more ancient than 2.6.11. This driver were probably added during
> > 2.5 development cycle or even before, together with i2c introduction in kernel.
> > So, I really don't doubt that on that time it were possible to have two boards
> > sharing the same address. To be sure, when this were added, we would need to
> > followup the Kernel past history before -git.
> 
> You can just look at Thomas Gleixner's excellent history tree:
> http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=summary

I know. 

> > By looking at tvaudio, it really seems that they used the same I2C address, but
> > 2 different I2C subaddress for two completely independent things:
> > 
> > +/* the registers of 16C54, I2C sub address. */
> > +#define PIC16C54_REG_KEY_CODE     0x01        /* Not use. */
> > +#define PIC16C54_REG_MISC         0x02
> > 
> > It seems clear by the code that address 0x48 subaddress 0x01 is for IR and address
> > 0x48 subaddress 0x02 is for audio.
> > 
> > Since the Input subsystem is something completely independent from the audio
> > one, and even agreeding that generic modules like tvaudio and i2c-ir-kbd are
> > not the proper way, we shouldn't mix the input susbystem stuff with audio at
> > the same driver. Those are completely unrelated things. The proper design would
> > be to have one different driver for each address/subaddress pair.
> 
> This is one possible design, yes. Having both functions handled by the
> same driver (and I really wrote driver, as in struct i2c_driver, and
> not module) is another possible design, and honestly I don't see any
> problem with it. You are totally free to put the separate functions
> into separate source files or even separate modules to keep the code
> clean. Then all you need is some glue and exported functions to make
> all pieces work together.

So, it seems that this is the more direct alternative for that pic processor.

> > So, in this case, I2C should not expose this driver as:
> > 
> > /sys/devices/.../i2c-adapter/i2c-3/3-0096
> > 
> > But, instead, create a subbus, just like PCI, exposing it as:
> 
> PCI doesn't do this, no. The way each device organizes its register map
> (which is really what we are talking about here) has _nothing_ to do
> with bus topology.

This is the way PCI maps the devices on a machine I have here with one saa7131
board and one 4x bt878 board:

lspci output:

01:02.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
02:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
02:0e.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0e.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
02:0f.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0f.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)

v4l2-apps/util/v4l2_sysfs_path output:

device     = /dev/video4
bus info   = PCI:0000:01:02.0
sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:02.0

device     = /dev/video3
bus info   = PCI:0000:02:0f.0
sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0f.0

device     = /dev/video2
bus info   = PCI:0000:02:0e.0
sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0e.0

device     = /dev/video1
bus info   = PCI:0000:02:0d.0
sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0d.0

device     = /dev/video0
bus info   = PCI:0000:02:0c.0
sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0c.0


You should notice that, even physically having all 4 bttv devices at the same
slot (physically at pci0000:00/0000:00:1e.0/0000:01:01.0), PCI has created unique
representation and sysfs names for each bttv device. The same occurs with
devices like cx88, that has 4 pci logical devices inside the plastic.

This is what I'm meaning.

> 
> > /sys/devices/.../i2c-adapter/i2c-3/3-0096-1
> > /sys/devices/.../i2c-adapter/i2c-3/3-0096-2
> > 
> > And letting to bind one module at address 0096-1 (for IR) and another at 0096-2 (for audio).
> 
> I fear this is never going to happen. We have a model which works
> today, you propose to change it for another one which would work too.
> Without an excellent reason to justify this change, I can't see why we
> would change anything here at the cost of a compatibility breakage.

Well, I could use the same argument for all those conversions done at the V4L
drivers. 

I never saw any excellent reason to migrate the existing board support to the
model you're proposing: the current model works properly for the almost all
the supported devices. 

A large amount of changes that are needed to be done, on a very short interval
will almost certainly cause compatibility breakages. I can't see any gain to
the end user of a board that it is properly supported that such change would do.

The reasons I see are in order to provide a more consistent internal model
to represent the devices, and to support devices with more complex approaches
like devices that have some I2C muxes and switches on their buses, to solve the
address problems we're currently facing with such devices.

> Also, please let's not lose focus here. The important thing here is to
> finish the conversion to the new i2c device driver binding model, and
> quickly.

For finishing the conversion, I agree that we just need some kind of workaround
to allow both IR and Audio to work, but we shouldn't loose how it would be done
in the final version.

Cheers,
Mauro
