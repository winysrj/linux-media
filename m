Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:40232 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbZCOW0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 18:26:30 -0400
Date: Sun, 15 Mar 2009 23:26:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090315232612.04346bdb@hyperion.delvare>
In-Reply-To: <1237145673.3314.47.camel@palomino.walls.org>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<1237145673.3314.47.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sun, 15 Mar 2009 15:34:33 -0400, Andy Walls wrote:
> On Sun, 2009-03-15 at 18:12 +0100, Jean Delvare wrote:
> > Hi Hans,
> > 
> > On Sun, 15 Mar 2009 13:44:01 +0100, Hans Verkuil wrote:
> > > Hi Mauro, Jean,
> > > 
> > > When converting the bttv driver to v4l2_subdev I found one probing conflict 
> > > between tvaudio and ir-kbd-i2c: address 0x96 (or 0x4b in 7-bit notation).
> > > 
> > > It turns out that this is one and the same PIC16C54 device used on the 
> > > ProVideo PV951 board. This chip is used for both audio input selection and 
> > > for IR handling.
> > > 
> > > But the tvaudio module does the audio part and the ir-kbd-i2c module does 
> > > the IR part. I have truly no idea how this should be handled in the new 
> > > situation. For that matter, I wonder whether it ever worked at all since my 
> > > understanding is that once you called i2c_attach_client for a particular 
> > > address, you cannot do that a second time. So depending on which module 
> > > happens to register itself first, you either have working audio or working 
> > > IR, but not both.
> > 
> > You are right.
> > 
> 
> > This is the typical multifunction device problem. It isn't specifically
> > related to I2C,
> 
> But the specific problem that Hans' brings up is precisely a Linux
> kernel I2C subsystem *software* prohibition on two i2c_clients binding
> to the same address on the same adapter.

No. Once again: Linux doesn't support binding more than one driver to a
device. This has _nothing_ to do with any choice done in i2c-core.

> >From linux/drivers/i2c/i2c-core.c:
> 
> static int __i2c_check_addr(struct device *dev, void *addrp)
> {
>         struct i2c_client       *client = i2c_verify_client(dev);
>         int                     addr = *(int *)addrp;
> 
>         if (client && client->addr == addr)
>                 return -EBUSY;
>         return 0;
> }
> [...]
> int i2c_attach_client(struct i2c_client *client)
> {
>         struct i2c_adapter *adapter = client->adapter;
>         int res;
> 
>         /* Check for address business */
>         res = i2c_check_addr(adapter, client->addr);
>         if (res)
>                 return res;
> [...]
> 
> 
> It seems like an artificial restriction: intended for safety, but
> getting in the way when something like that is a valid need.

I think we could remove the check. But then the driver core would fail
for us, so it wouldn't change anything in practice.

You claim that the need is valid, but I disagree. Once a design is in
place, you have to follow it, even if you come up with a case which
doesn't fit in said design perfectly. Otherwise there is no point in
having a design in the first place. Sure, a design can evolve, but not
for just one case. And, in Linux' case, not for just one subsystem. The
strength of the Linux driver model is that it is shared by all
subsystems. That's not something which is going to change.

> >  the exact same problem happens for other devices, for
> > example a PCI south bridge including hardware monitoring and SMBus, or
> > a Super-I/O chip including hardware monitoring, parallel port,
> > infrared, watchdog, etc. Linux currently only allows one driver to bind
> > to a given device, so it becomes very difficult to make per-function
> > drivers for such devices.
> 
> 
> > I know that there was some work in progress to allow multiple drivers
> > to bind to the same device. However it seems to be very slow because it
> > is fundamentally incompatible with the device driver model as it was
> > originally designed.
> 
> The driver model outside of the I2C subsystem?

Again this was in no way specific to the I2C subsystem. This was meant
as an extension to the core device driver model.

> Looking at the rest of i2c_attach_client() (that I didn't paste in
> above), I dont' see how the call to device_register(&client->dev) would
> care, as each i2c_client has it's own dev.  Although I guess you might
> get duplicately named sysfs directory entries like 
> 
> /sys/devices/.../i2c-adapter/i2c-3/3-0096
>
> Which could be a problem for accessing via the sysfs filesystem.  But
> that could be fixed in i2c_attach_client?

That's not just duplicated sysfs directories. That's duplicated device
names. The "3-0096" above is how the driver core uniquely identifies
the device in question withing the i2c subsystem name space. By
definition you can't have two devices with the same identifier.

(I am curious if this is a real device, BTW, as 0x96 isn't a valid
7-bit I2C address.)

> Then there's a matter of accessing the I2C device only by the address
> which means the wrong client might be used.  But since they both point
> to the same address on the same device, does that really matter?

Of course it does matter. The whole point of having only one driver
that can bind to a device is that said driver can control who accesses
the device, and how, and take care of any needed locking or delays.
Having multiple "clients" (software devices) accessing the same
(physical) device is equivalent to not having any client at all. This
would be a significant step backwards.

> > In the meantime, one workaround is to list the multifunction device as
> > supported by several drivers, and make the probe functions for this
> > device fail, while still keeping a reference to the device. The
> > reference lets you access the device, and is freed when you remove the
> > drivers. See for example the via686a, vt8231 and i2c-viapro drivers.
> > This approach may or may not be suitable for the ir-kbd-i2c and tvaudio
> > drivers. One drawback is that you can't do power management on the
> > device.
> 
> To me it would be more forward looking to add support in the I2C
> subsystem for allowing multiple client drivers to use the same address
> on the same adapter,

No, that's not going to happen in i2c-core, sorry. If anything like
this happens, it will be implemented as part of the core driver model.

> instead of adding non-intuitive behavior to module
> probe routines as a workaround.  Integration of discrete I2C chip cores
> into multifunction devices is likely to be a continuing trend.

I sure hope not.

> The PCI subsystem handles single devices with multiple functions.

In the good cases, yes. In some cases (which I have quoted already) it
doesn't. But anyway PCI functions are an implementation detail
irrelevant to this discussion: as far as Linux is concerned, each PCI
function is a separate device, exactly as separate PCI devices.

> There, of course, the function number is in the logical device address.

Not sure what you mean here. As said above, Linux doesn't give a damn
to PCI functions. They are an implementation detail.

> For an single I2C chip with multiple functions,  I've seen two types of
> functional block separation provided: a separate I2C address per
> functional block, and functions are separated by register address
> ranges.  The CX25843 leaps to mind as being of the second type.  There
> are register blocks for the basic device, the analog front end, the
> consumer IR device, the video decoding, the broadcast audio decoding,
> and AC97 interface functions.

And there's nothing preventing you from handling these separate
functions as you wish in your driver. Having a single function per
i2c_client is not a requirement in general.

> > As far as the PIC16C54 is concerned, another possibility would be to
> > move support to a dedicated driver. Depending on how much code is common
> > between the PIC16C54 and the other supported devices, the new driver
> > may either be standalone, or rely on functions exported by the
> > ir-kbd-i2c and tvaudio modules.
> 
> I'll guess that solution is probably the path of least resistance for
> the problem at hand.  It seems like a workaround for design decision
> made in the I2C subsystem long ago though.

Third (and last) time: this is how the Linux device driver model was
designed (and quite rightly so.) Not my decision and not i2c subsystem
specific. The only i2c-specific thing here (and not my choice either)
are the bus identifiers (e.g. 3-0096) but I believe it was a pretty
natural choice given that a given I2C address can indeed only be used
by one (physical) I2C slave on a given I2C segment.

Instead of blaming me or the i2c subsystem, please look carefully at
what the problem is in the first place: the ir-kbd-i2c and tvaudio
drivers are horrible design errors (for which there are certainly
historical errors, but still.) They support many devices each, on the
basis that these devices have the same functionality. Can you imagine a
single driver for all SATA controllers out there? Or a single driver
for all RTC chips out there? This is the design mistake you are looking
for.

Good night,
-- 
Jean Delvare
