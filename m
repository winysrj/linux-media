Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:10544 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762883AbZARKI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 05:08:57 -0500
Date: Sun, 18 Jan 2009 11:08:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, CityK <cityk@rogers.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090118110805.691c7273@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0901171058480.11165@shell2.speakeasy.net>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496F488B.3010302@linuxtv.org>
	<20090115152955.38f40e4e@pedra.chehab.org>
	<Pine.LNX.4.58.0901151009070.11165@shell2.speakeasy.net>
	<20090116000252.2cd9e5b6@pedra.chehab.org>
	<20090116110700.584ec052@hyperion.delvare>
	<Pine.LNX.4.58.0901160424350.11165@shell2.speakeasy.net>
	<20090116153257.0bd1c90f@hyperion.delvare>
	<Pine.LNX.4.58.0901171058480.11165@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent,

On Sat, 17 Jan 2009 11:45:57 -0800 (PST), Trent Piepho wrote:
> On Fri, 16 Jan 2009, Jean Delvare wrote:
> > On Fri, 16 Jan 2009 05:34:59 -0800 (PST), Trent Piepho wrote:
> > > How will this work for drivers like bttv, where the i2c address of the
> > > tuner chips isn't know for every supported card?
> >
> > Is this a problem in practice? My understanding was that I2C gates were
> > relatively recent in the history of V4L devices, so I assumed that for
> > devices with an I2C gate we would know where the devices are.
> 
> Changing hardware without notice is something manufactures still do, which
> makes probing even for modern hardware still useful in some cases.

But I would expect limited probing then (using
i2c_new_probed_device()), not wide probing using the .detect() method.

> But the old hardware that was always probed uses the same i2c clients as
> the new hardware that has gates and muxes.

This isn't necessarily an issue: your I2C chip driver can implement
a .detect() method for old hardware, where class is set to
I2C_CLASS_TV_ANALOG, while more recent hardware set no class and
instantiate the I2C devices explicitly. The new i2c model allows both
approaches to cohabit nicely.

> > This is indeed a possible implementation. One could argue though that
> > it's a bit overkill to instantiate a separate i2c_adapter just for a
> > gate. There are also caveats you must pay attention to. Two things in
> > particular that come to my mind:
> 
> The I2C layer doesn't have a concept for an i2c bus segment, so an
> i2c_adapter is the next closest thing.  One could create an entirely new
> struct i2c_bus for that, but how would it be different than the currenct
> i2c_adapter?  It seems like just another layer of complexity.

I agree with you, using i2c_adapter for bus segments is the plan, as
far as multiplexers are concerned. My point was whether it was worth
considering a chip behind a gate as a bus segment or not.

> > * Your proposal above, in its simple form, is incompatible with I2C
> > device detection, because devices which are before the gate would be
> > double-detected (once on each segment.)
> >
> > The first point is very easy to handle, the second is a little more
> > complicated. Basically you should add an address check at the beginning
> > of cx88_gate_i2c_xfer() to reject all transfers except to the device
> > you know is behind the gate.
> 
> I can think of a few more ways to do.  The main adapter could get
> registered with no I2C_CLASS_* (or with something like I2C_CLASS_MUX) so
> clients that scan won't scan it.  Then create virtual adapters for gate
> closed and gate open.  Scan gate closed first and then excluded any
> addresses found from the gate open adapter.

Yeah, that could work in some cases... At the cost of 3 i2c_adapter
instances. And it seems specifically tailored for hardware that need
scanning. I mean, if you do _not_ scan when gate is closed, then you
don't know what addresses must be removed from the gate-opened adapter,
so you can't allow for probing on that adapter.

But this doesn't seem to work in the general case: you may not be able
to actually scan for chips when gate is closed.  Some chips may not
respond to probing (either because they never do, or because they are
themselves behind another gate or multiplexer.) For complex topologies,
I am skeptical that your approach will be practical. It might even be
pretty confusing due to the fact that the apparent topology will be
quite different from the physical one.

(If we go that route then it does make sense to start speaking of
virtual adapters.)

Anyway, there's nothing missing from i2c-core right now to implement
this, is there?

> > At which point it is no longer clear why you want to have 2
> > i2c_adapters. You can have just one which opens (and closes) the gate
> > automatically for the right I2C address and not for the other addresses.
> 
> The scanning order problem.  The adapter is scanned before the gate can be
> controlled.  Works better with i2c-dev too.  Suppose I have a new card or a
> new revision and want to scan for devices behind the gate and see if I can
> figure out what they are?

Well, if you have a new card, you presumably don't know that it has a
gate to start with. If you have enough information about the gate, then
I expect you to also have enough information about what is behind it.

One possible requirement this discussion is bringing up, is the ability
to instantiate an i2c_adapter without any probing class set, then do
some initialization (e.g. accessing the gate chip, and close the gate)
and only then add probing classes (or have a separate function to ask
for re-probing of a given adapter.) This would fulfill your needs,
wouldn't it? Then we can stick to the physical topology.

> > Sorry for not being clear, I was only trying to address the gate issue
> > here, not the (more complex) multiplexing issue. I am not aware of V4L
> > devices having real I2C muxes?
> 
> I think some multi-tuner cards have real muxes.  But if the system created
> for muxes can be applied to gates as well, why not use it instead of
> creating something else for gates?

If we had support for muxes already, they I'd say yes, let's handle
gates the same. But the problem is that full muxes support is a
non-trivial thing, and we don't have it now, and I have no idea when we
will have it. I _hope_ before the end of the year, but I didn't even
start working on it, and I don't have any hardware to test either.

My main reason for suggesting a simple handling of gates is so that you
can have it quickly. But if you prefer to help me (and others)
implement full support for muxes instead, you're very welcome :)

> (..)
> First adapter created with the class set to 0 or I2C_CLASS_MUX, so nothing
> scans it (except a mux driver that scans).  Mux is added with
> i2c_new_device() and creats new busses/adapters for each segment.  These
> have the "real" class for the device and so get scanned.

Mux drivers should not scan. I mean, I've never see a mux chip that can
be detected. You should _know_ what mux you have on your bus.

> > But this has the disadvantage to leave the gate opened for longer than
> > it really has to, which could have adverse consequences on video
> > quality. Anyway, I'm leaving this up to you video/media people, as I
> > don't know enough myself about this to make a sane decision.
> 
> I think the gates are primarily meant to shield the device from noise
> relating to i2c bus traffic for other devices.  So it shouldn't be a
> problem to leave the gate open as long as it's closed when a message that
> doesn't need to go behind the gate is sent.

Ah, OK, I get the idea now.

-- 
Jean Delvare
