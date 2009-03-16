Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:14343 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZCPM6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 08:58:44 -0400
Date: Mon, 16 Mar 2009 13:58:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090316135829.48abd6f0@hyperion.delvare>
In-Reply-To: <1237164753.13144.105.camel@palomino.walls.org>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<1237145673.3314.47.camel@palomino.walls.org>
	<20090315232612.04346bdb@hyperion.delvare>
	<1237164753.13144.105.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sun, 15 Mar 2009 20:52:33 -0400, Andy Walls wrote:
> On Sun, 2009-03-15 at 23:26 +0100, Jean Delvare wrote:
> > No. Once again: Linux doesn't support binding more than one driver to a
> > device. This has _nothing_ to do with any choice done in i2c-core.
> 
> So how does the linux identify a "device" when binding, by some n-tuple
> in a coordinate space right?  The last few parts of that coordinate are
> dictated by I2C subsystem design for I2C devices.  I believe they are
> (adapter, address) commonly displayed something 0-004b.  

Yes, this is correct.

> If the I2C subsystem allowed a coordinate for a device to have the last
> few parts be (adapter, address, client/function #), like:
> 
> 0-004b-0
> 0-004b-1
> 
> then one could have multiple drivers bind to a single piece of hardware
> and still have the locking on the i2c_adapter provided by the
> i2c_subsystem.  Wouldn't this be possible once the automatic probing is
> gone?

No. Locking on the i2c_adapter level is only the tip of the iceberg. As
discussed with Trent somewhere else in this thread, there are many
other cases which require additional locking at the device (not bus)
level. Executive summary: non-atomic transactions, banked registers,
read-modify-write cycles.

Of course there may be cases where neither problem exists for a given
chip (all drivers use only atomic transactions, the register space is
flat and the registers accessed by both drivers don't overlap.) But this
is the lucky case. We can hardly build a new design on top of these
assumptions.

What this means is that, in general, you will require some form of
coordination between the drivers for the separate functions. At which
point it is really not different from having a single driver with a
core part taking care of the coordination and other parts taking care
of each functions.

> > (...)
> > That's not just duplicated sysfs directories. That's duplicated device
> > names. The "3-0096" above is how the driver core uniquely identifies
> > the device in question withing the i2c subsystem name space. By
> > definition you can't have two devices with the same identifier.
> 
> And I guess I was thinking, but didn't write down, that the I2C
> subsystem could expand it's namespace by one coordinate axis.
> 
> 3-004b-0
> 3-004b-1

It could, yes. This raises questions though. For example, while the bus
number and especially device address are dictated by hardware
realities, the last coordinate you propose to had would not. These
numbers would be attributed arbitrarily by Linux driver authors. How?

Oh, and of course this change would break compatibility. There are a
number of user-space tools which expect the i2c device "names" to look
like 3-004b and not 3-004b-0. We'd have to fix them all. So this kind
of change is not to be taken lightly.

But more importantly, my feeling is that the additional coordinate in
the device names doesn't solve any problem. It's moving to the bus
level something which was handled at the chip level so far, and I fail
to see any significant benefit in doing so.

> > (I am curious if this is a real device, BTW, as 0x96 isn't a valid
> > 7-bit I2C address.)
> 
> No, I made it up from the device in the discussion. I forgot to shift it
> down to a 7 bit address of 0x4b.

Ah, OK. Pffew :)

> I hadn't thought about intertransfer delays.  The I2C spec does have a
> minimum turn around specification between STOP and START, 4.7 us, but I
> have no idea where it is enforced currently in Linux.

I fear it is not enforced. I suspect this is taken care of by hardware
implementations (e.g. SMBus controller on the mainboard) but probably
i2c-algo-bit and possibly other software implementations should be
taught about it. If this really bothers someone, I accept patches ;)

But this is not what I had in mind. What I had in mind was per-chip
restrictions. For example, some chips require a delay between
consecutive writes, and will misbehave if the delay isn't respected.
This needs to be handled at the driver level. More specifically, for a
multifunction device, this likely has to be handled by the common part
of the driver.

> > (...)
> > No, that's not going to happen in i2c-core, sorry. If anything like
> > this happens, it will be implemented as part of the core driver model.
> 
> OK.  So it sounds like it's not going to happen at all.

Well, I still hope that someday the core driver model will have proper
support for multiple bindings. But given how slow the progress has been
over the past few years, yeah, I'm not holding my breath :(

> Ah. You're right.  My analogy corresponds to an I2C chip that responds
> on two addresses on the same bus.  My analogy was bad.

A single I2C chip which responds to 2 I2C addresses can be handled by
one or two drivers, as you like. This is an easy case. This however
isn't the case of the PIC16C54.

> > (...)
> > And there's nothing preventing you from handling these separate
> > functions as you wish in your driver. Having a single function per
> > i2c_client is not a requirement in general.
> 
> That's the current state.  So it looks like the problem is there is no
> "PIC16C54" driver since it's an 8-bit general purpose microcontroller.

General purpose devices are indeed a special case. In general I don't
see much point in having a general driver for them. I think it's better
to consider each usage a separate chip and write per-usage driver. All
we have to come up with is an i2c device name for them (e.g.
pic16c54_pv951) so that the right driver will bind.

> > (...)
> > Instead of blaming me or the i2c subsystem,
> 
> My intent was not to blame or offend, but to discuss the issue.  I'm
> sorry if my tone didn't convey properly.  I'm not the most eloquent
> writer.

I didn't take it personally, don't worry. I'm probably not the best
writer out there either, and it was late, and my baby is ill so I can't
really concentrate on what I'm writing, which doesn't help.

> I understand now.  The desire to leverage existing crappy code is not
> worth the cost and risk of perturbing things for the sake of one device.

+1 :)

-- 
Jean Delvare
