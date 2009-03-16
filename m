Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59003 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbZCPAvo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 20:51:44 -0400
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20090315232612.04346bdb@hyperion.delvare>
References: <200903151344.01730.hverkuil@xs4all.nl>
	 <20090315181207.36d951ac@hyperion.delvare>
	 <1237145673.3314.47.camel@palomino.walls.org>
	 <20090315232612.04346bdb@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 15 Mar 2009 20:52:33 -0400
Message-Id: <1237164753.13144.105.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-03-15 at 23:26 +0100, Jean Delvare wrote:
> Hi Andy,

Hi Jean,

Thanks for the reply.

> On Sun, 15 Mar 2009 15:34:33 -0400, Andy Walls wrote:
> > On Sun, 2009-03-15 at 18:12 +0100, Jean Delvare wrote:
> > > Hi Hans,

> > > This is the typical multifunction device problem. It isn't specifically
> > > related to I2C,
> > 
> > But the specific problem that Hans' brings up is precisely a Linux
> > kernel I2C subsystem *software* prohibition on two i2c_clients binding
> > to the same address on the same adapter.
> 
> No. Once again: Linux doesn't support binding more than one driver to a
> device. This has _nothing_ to do with any choice done in i2c-core.

So how does the linux identify a "device" when binding, by some n-tuple
in a coordinate space right?  The last few parts of that coordinate are
dictated by I2C subsystem design for I2C devices.  I believe they are
(adapter, address) commonly displayed something 0-004b.  

If the I2C subsystem allowed a coordinate for a device to have the last
few parts be (adapter, address, client/function #), like:

0-004b-0
0-004b-1

then one could have multiple drivers bind to a single piece of hardware
and still have the locking on the i2c_adapter provided by the
i2c_subsystem.  Wouldn't this be possible once the automatic probing is
gone?

 
> > It seems like an artificial restriction: intended for safety, but
> > getting in the way when something like that is a valid need.
> 
> I think we could remove the check. But then the driver core would fail
> for us, so it wouldn't change anything in practice.



> You claim that the need is valid, but I disagree.

I suppose validity is subjective, in that I have implicit cost measures
and assessments of the costs that are different from yours.

For example you have a need for some threshold number of devices to
behave like the I2C device in question before the need would be valid.
One such device is not enough.

Fair enough.



>  Once a design is in
> place, you have to follow it,


I disagree.  Why does the world now have digital TV broadcast systems
instead of just being stuck with analog TV broadcast systems?  A change
in the design of the broadcast television system was needed due to
pressures to recover spectrum, etc.


> even if you come up with a case which
> doesn't fit in said design perfectly. Otherwise there is no point in
> having a design in the first place.

No there is always a point to an intial design.  You always start with a
design to address your current needs and perhaps try to accomodate
future needs in design considerations.  No one can know everything ahead
of time.


>  Sure, a design can evolve, but not
> for just one case.

I agree, there are costs to be weighed.  If it doesn't make sense for a
single case, due to the costs involved, then it doesn't make sense.


> And, in Linux' case, not for just one subsystem. The
> strength of the Linux driver model is that it is shared by all
> subsystems. That's not something which is going to change.

I was not thinking of trying to "move the world", just accomodate
multifunction I2C devices to allow multiple driver modules to access a
device at a single (adapter, address) coordinate.  Perhaps by using an
(adapter, address, function #) coordinate.


 
> > > I know that there was some work in progress to allow multiple drivers
> > > to bind to the same device. However it seems to be very slow because it
> > > is fundamentally incompatible with the device driver model as it was
> > > originally designed.
> > 
> > The driver model outside of the I2C subsystem?
> 
> Again this was in no way specific to the I2C subsystem. This was meant
> as an extension to the core device driver model.

Thanks, I didn't understand the scope of that effort you had
mentioned.  




> > Looking at the rest of i2c_attach_client() (that I didn't paste in
> > above), I dont' see how the call to device_register(&client->dev) would
> > care, as each i2c_client has it's own dev.  Although I guess you might
> > get duplicately named sysfs directory entries like 
> > 
> > /sys/devices/.../i2c-adapter/i2c-3/3-0096
> >
> > Which could be a problem for accessing via the sysfs filesystem.  But
> > that could be fixed in i2c_attach_client?
> 
> That's not just duplicated sysfs directories. That's duplicated device
> names. The "3-0096" above is how the driver core uniquely identifies
> the device in question withing the i2c subsystem name space. By
> definition you can't have two devices with the same identifier.

And I guess I was thinking, but didn't write down, that the I2C
subsystem could expand it's namespace by one coordinate axis.

3-004b-0
3-004b-1


> (I am curious if this is a real device, BTW, as 0x96 isn't a valid
> 7-bit I2C address.)

No, I made it up from the device in the discussion. I forgot to shift it
down to a 7 bit address of 0x4b.


> > Then there's a matter of accessing the I2C device only by the address
> > which means the wrong client might be used.  But since they both point
> > to the same address on the same device, does that really matter?
> 
> Of course it does matter. The whole point of having only one driver
> that can bind to a device is that said driver can control who accesses
> the device, and how, and take care of any needed locking or delays.
> Having multiple "clients" (software devices) accessing the same
> (physical) device is equivalent to not having any client at all. This
> would be a significant step backwards.

I was under the impression that access to a bus adapter was locked by
the I2C subsystem using adapter->bus_lock.  At that point, if multiple
drivers are accessing a multifunction device at a single address, they
would just need to "play nice" and stay in different register regions of
the multifunction I2C chip.

I hadn't thought about intertransfer delays.  The I2C spec does have a
minimum turn around specification between STOP and START, 4.7 us, but I
have no idea where it is enforced currently in Linux.



> > > In the meantime, one workaround is to list the multifunction device as
> > > supported by several drivers, and make the probe functions for this
> > > device fail, while still keeping a reference to the device. The
> > > reference lets you access the device, and is freed when you remove the
> > > drivers. See for example the via686a, vt8231 and i2c-viapro drivers.
> > > This approach may or may not be suitable for the ir-kbd-i2c and tvaudio
> > > drivers. One drawback is that you can't do power management on the
> > > device.
> > 
> > To me it would be more forward looking to add support in the I2C
> > subsystem for allowing multiple client drivers to use the same address
> > on the same adapter,
> 
> No, that's not going to happen in i2c-core, sorry. If anything like
> this happens, it will be implemented as part of the core driver model.

OK.  So it sounds like it's not going to happen at all.


> > instead of adding non-intuitive behavior to module
> > probe routines as a workaround.  Integration of discrete I2C chip cores
> > into multifunction devices is likely to be a continuing trend.
> 
> I sure hope not.


> > The PCI subsystem handles single devices with multiple functions.
> 
> In the good cases, yes. In some cases (which I have quoted already) it
> doesn't. But anyway PCI functions are an implementation detail
> irrelevant to this discussion: as far as Linux is concerned, each PCI
> function is a separate device, exactly as separate PCI devices.

Ah. You're right.  My analogy corresponds to an I2C chip that responds
on two addresses on the same bus.  My analogy was bad.


> > For an single I2C chip with multiple functions,  I've seen two types of
> > functional block separation provided: a separate I2C address per
> > functional block, and functions are separated by register address
> > ranges.  The CX25843 leaps to mind as being of the second type.  There
> > are register blocks for the basic device, the analog front end, the
> > consumer IR device, the video decoding, the broadcast audio decoding,
> > and AC97 interface functions.
> 
> And there's nothing preventing you from handling these separate
> functions as you wish in your driver. Having a single function per
> i2c_client is not a requirement in general.

That's the current state.  So it looks like the problem is there is no
"PIC16C54" driver since it's an 8-bit general purpose microcontroller.  

It's a one off case for writing a driver to handle a PIC16C54 with the
microcode the manufacturer has programmed into the device.  So I
understand the desire to leverage existing modules.


> > > As far as the PIC16C54 is concerned, another possibility would be to
> > > move support to a dedicated driver. Depending on how much code is common
> > > between the PIC16C54 and the other supported devices, the new driver
> > > may either be standalone, or rely on functions exported by the
> > > ir-kbd-i2c and tvaudio modules.
> > 
> > I'll guess that solution is probably the path of least resistance for
> > the problem at hand.  It seems like a workaround for design decision
> > made in the I2C subsystem long ago though.
> 
> Third (and last) time: this is how the Linux device driver model was
> designed (and quite rightly so.) Not my decision and not i2c subsystem
> specific. The only i2c-specific thing here (and not my choice either)
> are the bus identifiers (e.g. 3-0096) but I believe it was a pretty
> natural choice given that a given I2C address can indeed only be used
> by one (physical) I2C slave on a given I2C segment.

And the problem here is that one physical slave ends up as two logical
slaves, that are very similar to individual physical slave handled by
other drivers, and people want to levereage existing code.

But you've convinced me that one corner case is not worth going through
all the expense to cover.



> Instead of blaming me or the i2c subsystem,

My intent was not to blame or offend, but to discuss the issue.  I'm
sorry if my tone didn't convey properly.  I'm not the most eloquent
writer.


>  please look carefully at
> what the problem is in the first place: the ir-kbd-i2c and tvaudio
> drivers are horrible design errors (for which there are certainly
> historical errors, but still.) They support many devices each, on the
> basis that these devices have the same functionality. Can you imagine a
> single driver for all SATA controllers out there? Or a single driver
> for all RTC chips out there? This is the design mistake you are looking
> for.

I understand now.  The desire to leverage existing crappy code is not
worth the cost and risk of perturbing things for the sake of one device.

Regards,
Andy


> Good night,

