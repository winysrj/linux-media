Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0A2T7c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 14:59:32 -0500
Message-ID: <4B633E1D.2050609@redhat.com>
Date: Fri, 29 Jan 2010 17:59:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Walls <awalls@radix.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: cx18 fix patches
References: <4B60F901.20301@redhat.com>	 <1264731845.3095.16.camel@palomino.walls.org>	 <829197381001290922p69a68ce5k3f5192f427f4658a@mail.gmail.com>	 <4B632BB8.3000904@redhat.com> <829197381001291057o5b94d1d7k4d5f7f6d7251101f@mail.gmail.com>
In-Reply-To: <829197381001291057o5b94d1d7k4d5f7f6d7251101f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Jan 29, 2010 at 1:40 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> I doubt it would solve. IMO, having it modular is good, since you may not
>> need cx18 alsa on all devices.
> 
> Modularity is good, but we really need to rethink about the way we are
> loading these modules (this applies to dvb as well).  For example, on
> em28xx, the dvb module is often getting loaded while at the same that
> hald is connecting to the v4l2 device (resulting in i2c errors while
> attempting to talk to tvp5150).  A simple initialization lock would
> seem like a good idea, except that doesn't really work because the
> em28xx submodules get loaded asynchronously.  And the problem isn't
> specific to em28xx by any means.  I've hit comparable bugs in cx88.
> 
> If we didn't load the modules asynchronously, then at least we would
> be able to hold the lock throughout the entire device initialization
> (ensuring that nobody can connect to the v4l2 device while the dvb and
> alsa drivers are initializing).  Sure, it in theory adds a second or
> two to the module load (depending on the device), but we would have a
> much simpler model that would be less prone to race conditions.

The asynchronous load were added not to improve the boot load time, but to
avoid some troubles that happens when the load is synchronous. 
I don't remember what were the exact trouble, but I suspect that it was
something related to i2c. The result was that, sometimes, the driver
used to enter into a deadlock state (something like driver A waits for driver B
to load, but, as driver B needs functions provided by driver A, both are put
into sleep).

Also, reducing the driver load time is a good thing. The asynchronous load 
is very interesting for devices where the firmware load takes a very long time.

I love the fact that new kernels with new distros boot the machine on a few
seconds. This is thanks to some asynchronous loads that happen on several 
drivers. The removal of KBL from open/close/ioct2 is one of the reasons for 
those improvements. Of course, if the driver is not properly locked, it will 
cause race conditions.

Maybe one alternative would be to register the interfaces asynchronously
also, as a deferred task that is started only after the driver enters into
a sane state. 

For example, a kref may be used to indicate that there are init
tasks pending. Only after having kref zeroed, the driver registers.
As kref_put() automatically calls a routine when the usage count reaches
zero, it shouldn't be hard to implement such locking schema.



As the problem is common, the better is to provide a global way to avoid
device open while the initialization is not complete, at the v4l core.

Cheers,
Mauro
