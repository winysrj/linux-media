Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:47007 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129AbZAQTp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 14:45:59 -0500
Date: Sat, 17 Jan 2009 11:45:57 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, CityK <cityk@rogers.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
In-Reply-To: <20090116153257.0bd1c90f@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0901171058480.11165@shell2.speakeasy.net>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
 <496F488B.3010302@linuxtv.org> <20090115152955.38f40e4e@pedra.chehab.org>
 <Pine.LNX.4.58.0901151009070.11165@shell2.speakeasy.net>
 <20090116000252.2cd9e5b6@pedra.chehab.org> <20090116110700.584ec052@hyperion.delvare>
 <Pine.LNX.4.58.0901160424350.11165@shell2.speakeasy.net>
 <20090116153257.0bd1c90f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 16 Jan 2009, Jean Delvare wrote:
> On Fri, 16 Jan 2009 05:34:59 -0800 (PST), Trent Piepho wrote:
> > On Fri, 16 Jan 2009, Jean Delvare wrote:
> > > Hi Mauro, Trent,
> > > On Fri, 16 Jan 2009 00:02:52 -0200, Mauro Carvalho Chehab wrote:
> > > > For now, we should finish the Hans approach, since it also helps to stop using
> > > > the legacy i2c methods. After having all drivers using it, we can do some
> > > > cleanup at the drivers.
> >
> > How will this work for drivers like bttv, where the i2c address of the
> > tuner chips isn't know for every supported card?
>
> Is this a problem in practice? My understanding was that I2C gates were
> relatively recent in the history of V4L devices, so I assumed that for
> devices with an I2C gate we would know where the devices are.

Changing hardware without notice is something manufactures still do, which
makes probing even for modern hardware still useful in some cases.

But the old hardware that was always probed uses the same i2c clients as
the new hardware that has gates and muxes.

> This is indeed a possible implementation. One could argue though that
> it's a bit overkill to instantiate a separate i2c_adapter just for a
> gate. There are also caveats you must pay attention to. Two things in
> particular that come to my mind:

The I2C layer doesn't have a concept for an i2c bus segment, so an
i2c_adapter is the next closest thing.  One could create an entirely new
struct i2c_bus for that, but how would it be different than the currenct
i2c_adapter?  It seems like just another layer of complexity.

> * Your proposal above, in its simple form, is incompatible with I2C
> device detection, because devices which are before the gate would be
> double-detected (once on each segment.)
>
> The first point is very easy to handle, the second is a little more
> complicated. Basically you should add an address check at the beginning
> of cx88_gate_i2c_xfer() to reject all transfers except to the device
> you know is behind the gate.

I can think of a few more ways to do.  The main adapter could get
registered with no I2C_CLASS_* (or with something like I2C_CLASS_MUX) so
clients that scan won't scan it.  Then create virtual adapters for gate
closed and gate open.  Scan gate closed first and then excluded any
addresses found from the gate open adapter.

> At which point it is no longer clear why you want to have 2
> i2c_adapters. You can have just one which opens (and closes) the gate
> automatically for the right I2C address and not for the other addresses.

The scanning order problem.  The adapter is scanned before the gate can be
controlled.  Works better with i2c-dev too.  Suppose I have a new card or a
new revision and want to scan for devices behind the gate and see if I can
figure out what they are?

> > > * At I2C bus driver level. We can have a pre-transfer handler and a
> > > post-transfer handler, which does what needs to be done (like opening
> > > and closing a gate) based on the address of the device that is being
> > > accessed. I had discussed this approach with Michael Krufky long ago.
> >
> > This won't work when muxes are used to put multiple i2c devices with the
> > same address behind a single master.
>
> Sorry for not being clear, I was only trying to address the gate issue
> here, not the (more complex) multiplexing issue. I am not aware of V4L
> devices having real I2C muxes?

I think some multi-tuner cards have real muxes.  But if the system created
for muxes can be applied to gates as well, why not use it instead of
creating something else for gates?

> > It still has the problem of probe order when one wants to scan for chips.
> > The i2c core does scanning when a new adapter is created.  But, suppose the
> > mux is an i2c device on the adapter?  In order for the scanner to find
> > anything behind the mux, it needs to be detected and working before the bus
> > is scanned.  But this may not happen.  Say one calls:
> > i2c_add_adapter(adap); i2c_new_device(adap, &the_mux);
> >
> > If the client driver for the device behind the mux uses probing, and is
> > already loaded when i2c_add_adapter() is called, then it will be probed for
> > before the i2c_new_device() call and won't be found because the mux isn't
> > working.
>
> You are right, this is a problem.
>
> > If instead the mux driver created a new i2c adapter for the segment(s)
> > behind it, which would happen when i2c_new_device() is called, then those
> > segments would be probed at the correct time.
>
> This doesn't fully solve the problem, because you have no idea in which
> state the mux is initially. If one of its segments is already selected,
> then the detection will happen when it shouldn't (the chip drivers
> thinks it has found a device on the trunk) and things will break as
> soon as the mux driver is in action (the device behind the mux will
> "move" to its actual branch.)

First adapter created with the class set to 0 or I2C_CLASS_MUX, so nothing
scans it (except a mux driver that scans).  Mux is added with
i2c_new_device() and creats new busses/adapters for each segment.  These
have the "real" class for the device and so get scanned.

> > But this isn't insolvable.  For a real mux, the driver could only switch
> > the mux when the selected segment is different from the last one.  For a
> > gate, one could reset a timer on each transfer that will close the gate
> > when it gets triggered.  That way when multiple commands arrive close
> > enough together the gate can be left open for all of them.  This has an
> > advantage over manually batching commands in that in many cases the code
> > that sends one command does not know that another command will be sent
> > immediately afterwards and so they are not batched.
>
> But this has the disadvantage to leave the gate opened for longer than
> it really has to, which could have adverse consequences on video
> quality. Anyway, I'm leaving this up to you video/media people, as I
> don't know enough myself about this to make a sane decision.

I think the gates are primarily meant to shield the device from noise
relating to i2c bus traffic for other devices.  So it shouldn't be a
problem to leave the gate open as long as it's closed when a message that
doesn't need to go behind the gate is sent.
