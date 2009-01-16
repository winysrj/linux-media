Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43875 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935387AbZAPCDi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 21:03:38 -0500
Date: Fri, 16 Jan 2009 00:02:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, CityK <cityk@rogers.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>,
	linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090116000252.2cd9e5b6@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0901151009070.11165@shell2.speakeasy.net>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496F488B.3010302@linuxtv.org>
	<20090115152955.38f40e4e@pedra.chehab.org>
	<Pine.LNX.4.58.0901151009070.11165@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Jan 2009 10:33:15 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Thu, 15 Jan 2009, Mauro Carvalho Chehab wrote:
> > It has nothing to do with the load order. It is related to i2c binding. With
> > the current approach (before Hans patch), the i2c core will try to bind the
> > tuner after having 2 conditions satisfied:
> > 	1) I2C bus were registered;
> > 	2) tuner code is available.
> >
> > So, if you load tuner before saa7134 (or have it compiled in-kernel), the code
> > will try to probe tuners at the moment you register i2c bus. Otherwise, it will
> > try to bind only when request_module is handled.
> >
> > Some devices with DVB has an internal i2c gate. For a subset of these, the i2c
> > gate is inside the tuner. So, you need to bind the tuner device before probing
> > for the frontends. On the other set of devices, the gate is inside the demod.
> > So, you need to turn the i2c gate before running the i2c address seek for tuner.
> 
> I wonder if a better way to fix these problems is to use virtual I2C busses
> for the gate?

For now, we should finish the Hans approach, since it also helps to stop using
the legacy i2c methods. After having all drivers using it, we can do some
cleanup at the drivers.

However, I like the idea of providing a better support for those buses that
have an i2c switch inside (I don't like to call it "virtual" - it is a real i2c
bus, where part of the bus is controlled by a switch).

>  When a device has some kind of i2c gate, it creates a new
> I2C adapter for the devices behind the gate.  The code for this virtual i2c
> adapter can just open the gate, pass of the request to the main i2c
> adapter, then close the gate.  Creating a new i2c adapter should trigger
> the i2c drivers that scan to do so and find new devices behind the gate.
> 
> It seems like this would solve the scan order problem, since the bus the
> tuner/demod/whatever is on won't exist until the gate it is behind can be
> properly controlled.
> 
> There are a number of additional benefits too.  There are many devices that
> can be behind many different kinds of gates.  So we have all these gate
> control functions that must be called manually from all over the place.
> This adds bloat and developers are always forgetting to call them, which
> doesn't cause any problem they notice because their card doesn't have a
> gate.
> 
> With manual gate control, we must remember to close the gate when done with
> the device.  But this isn't always done and the gate is left open.  These
> gates are there for a reason, to shield RF devices from noise created by
> the I2C bus, and so leaving them opens impairs RF performance.
> 
> And when the gate is only controlled by the driver in the kernel, it is
> hard to manually debug/test i2c devices from userspace with i2c-dev.

I'm not sure if we should implement it inside v4l core, or at i2c-core. 

Maybe the latter could be more appropriate, since maybe some other devices could have
similar issues, like the embedded processor/controllers, where you have an i2c
bus there connected to several different devices, like those used on cellular
phones. 

I bet that some embedded devices uses the same i2c bus for more than
one subsystem (like having a radio and/or a webcam and some temperature/battery
sensors). In this case, a virtual i2c support could be interesting.

Maybe Jean could give us some suggestions about the better approach for such cases.

Cheers,
Mauro
