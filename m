Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:40127 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZCPO2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 10:28:21 -0400
Date: Mon, 16 Mar 2009 15:28:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090316152802.7492dd20@hyperion.delvare>
In-Reply-To: <20090316095237.21775418@gaivota.chehab.org>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
	<20090315185313.4c15702c@hyperion.delvare>
	<20090316063402.1b0da1f3@gaivota.chehab.org>
	<20090316121801.1c03d747@hyperion.delvare>
	<20090316095237.21775418@gaivota.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 16 Mar 2009 09:52:37 -0300, Mauro Carvalho Chehab wrote:
> On Mon, 16 Mar 2009 12:18:01 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> > I really don't see any problem there. There are many drivers (i2c or
> > not) in the kernel which do exactly this and this works just fine. We
> > even have a directory for (some of) them: drivers/mfd. For other
> > drivers, we either have broader categories in Linux, or we put the
> > driver in the category which is the more meaningful. For example, many
> > hwmon drivers include several functions: voltage monitoring,
> > temperature monitoring, fan speed monitoring, fan speed control (either
> > manual or automatic), chassis intrusion detection, etc. Some even
> > include a watchdog. We have decided to put all these drivers under
> > drivers/hwmon, and this didn't cause any problem so far. Some other
> > chips have hardware monitoring has a secondary feature and as a result
> > they live in other directories but still register has a hwmon (class)
> > device. Again, nothing wrong with that.
> 
> In the case of hwmon, it is all about hardware monitoring, so, it is fine to
> have all of them grouped.

Absolutely not. These are totally separate functions. There's really
nothing in common between ensuring that the PSU is in good health and
controlling the speed of the fans.

> This is not the case of an input device, and an audio DSP control for some TV
> standard.

I don't make any difference. It's all multimedia stuff to me.

See how subjective drawing this kind of lines can be? ;)

> The input device is a handler for EVDEV events, that has their own dependencies
> and needs, while the audio DSP control is part of a group of functions to setup
> a certain video/audio standard. You don't need to be streaming a video to use
> your IR. 
> 
> For IR to work, a driver generally just needs to setup a few GPIO pins at the
> driver, and do a glue with I2C bus (or GPIO bus). 
> 
> Several designed manufacturer drivers for other O. S. use separate drivers for
> IR and for video, since those are completely independent functions just sharing
> a very limited set of the chipset resources (the worse case is generally
> needing to share up to 4 GPIO registers, the I2C bus and a IRQ line).
> 
> It is about the same we had in the past where some audio boards that also had a CD
> controller inside (those legacy Sound Blaster devices, for example). The proper 
> design were to map, the audio driver to be independent of the ISA driver.
> 
> We should really isolate things. On an ideal design, I'd say that we should
> have a completely independent bttv-ir driver splitted from the bttv-video,
> since someone can use the board just for IR interface, or just video.

I agree, but then again this is nothing you can't already do today.
It's not the most frequent driver design, but it can be done. There is
nothing preventing you from passing i2c_client references to other
modules, which can then do whatever they want with them.

> The I2C layer need to be capable of supporting such hardware abstraction level,
> instead of forcing to use the same driver for both things. In fact, it does
> support the needed abstraction, if the I2C addresses of the two hardwares are
> different, but it fails if the difference is at the subaddress level.

No, the I2C layer doesn't need to be capable of supporting such
hardware abstraction level. I claim it isn't the I2C layer's job to deal
with how each device maps its registers nor how many functions an I2C
device implements. This is a driver-specific issue.

The I2C layer must make it _possible_ to write drivers for such
devices, yes. And I think it already does. If there are problems,
please point me to them, and we'll address them. But this won't take a
redesign of the i2c subsystem.

> > (...)
> > PCI doesn't do this, no. The way each device organizes its register map
> > (which is really what we are talking about here) has _nothing_ to do
> > with bus topology.
> 
> This is the way PCI maps the devices on a machine I have here with one saa7131
> board and one 4x bt878 board:
> 
> lspci output:
> 
> 01:02.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> 02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
> 02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
> 02:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
> 02:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
> 02:0e.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
> 02:0e.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
> 02:0f.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
> 02:0f.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
> 
> v4l2-apps/util/v4l2_sysfs_path output:
> 
> device     = /dev/video4
> bus info   = PCI:0000:01:02.0
> sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:02.0
> 
> device     = /dev/video3
> bus info   = PCI:0000:02:0f.0
> sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0f.0
> 
> device     = /dev/video2
> bus info   = PCI:0000:02:0e.0
> sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0e.0
> 
> device     = /dev/video1
> bus info   = PCI:0000:02:0d.0
> sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0d.0
> 
> device     = /dev/video0
> bus info   = PCI:0000:02:0c.0
> sysfs path = /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/0000:02:0c.0
> 
> 
> You should notice that, even physically having all 4 bttv devices at the same
> slot (physically at pci0000:00/0000:00:1e.0/0000:01:01.0), PCI has created unique
> representation and sysfs names for each bttv device. The same occurs with
> devices like cx88, that has 4 pci logical devices inside the plastic.
> 
> This is what I'm meaning.

If you like to keep the analogy between I2C and PCI, PCI bridges (which
is what you have above) are like I2C multiplexers. Again, nothing to do
with the internal register mapping of I2C devices.

> > (...)
> > I fear this is never going to happen. We have a model which works
> > today, you propose to change it for another one which would work too.
> > Without an excellent reason to justify this change, I can't see why we
> > would change anything here at the cost of a compatibility breakage.
> 
> Well, I could use the same argument for all those conversions done at the V4L
> drivers.

This was more or less my point, but apparently I didn't stress it
enough. I am impressed by the way you ask me to basically redesign the
i2c subsystem to take care of one specific I2C device which you think
doesn't fit exactly in the current model, while OTOH you are doing all
you can to slow down an on-going subsystem redesign that has been
requested by many for years, and that solves a dozen real-world
problems, and that is already 85% done.

> I never saw any excellent reason to migrate the existing board support to the
> model you're proposing: the current model works properly for the almost all
> the supported devices.

That's it, you made my day, really.

At this point I'm not sure if you really have a bad memory (worse than
mine), or if you are trying to make fun of me, or if you are just
wasting my time.

Come on, just look at ir-kbd-i2c and tvaudio again, see how great are
these drivers which have been "designed" on top of the legacy i2c
binding model. Look at the bttv mess. Look at the zoran driver
conversion done by Hans a few weeks ago, which killed what, 3000 lines
of code? The old binding model was so bad that DVB doesn't even use it.
They decided to go with raw bus transactions instead, despite the
potential problems theses have.

The new binding model solves so many issues that I don't even know
where to start. It makes drivers load much faster. It prevents device
misdetections. It prevents undue probes which have occasionally been
reported to break hardware. It kills a lot of glue code that had been
added to workaround the weakness of the old binding model. It makes it
much easier for developers to understand the i2c code because it now
follows the standard model.

I can't believe that you claim that I am pushing the new model on you
when you don't want it, when you (not necessarily you personally, but
you video4linux developers) are one of the two groups for which the
redesign happened in the first place. You asked for it, don't you
remember? With more spare time I'd go dig my mail archive.

> A large amount of changes that are needed to be done, on a very short interval

Kernel 2.6.22 was released in July 2007. This is 20 months ago. Is that
what you call a short interval? In the Linux development time frame,
this is a long interval.

Ah yeah, now I remember. You're the one who considers 2.6.18 a bleeding
edge kernel suitable for upstream development. This explains a lot.

> will almost certainly cause compatibility breakages. I can't see any gain to
> the end user of a board that it is properly supported that such change would do.

I'm literally speechless.

> The reasons I see are in order to provide a more consistent internal model
> to represent the devices, and to support devices with more complex approaches
> like devices that have some I2C muxes and switches on their buses, to solve the
> address problems we're currently facing with such devices.

Abstracting the numerous improvements brought by the new binding model
for older devices, which by themselves justify the move IMHO, the key
issue here is that the old model and the new model do not mix properly.
The different device lifetime cycles make it pretty much impossible to
come up with a sane locking model. This is the reason why I want the
legacy model to die now.

> > Also, please let's not lose focus here. The important thing here is to
> > finish the conversion to the new i2c device driver binding model, and
> > quickly.
> 
> For finishing the conversion, I agree that we just need some kind of workaround
> to allow both IR and Audio to work, but we shouldn't loose how it would be done
> in the final version.

For finishing the conversion, we don't need to do anything. The
PIC16C54 support is already broken today if I understood Hans
correctly. We certainly want to fix that someday, but this is unrelated
to the model conversion.

-- 
Jean Delvare
