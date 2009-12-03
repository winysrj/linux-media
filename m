Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36213 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZLCMEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 07:04:33 -0500
Subject: Re: [RFC v2] Another approach to IR
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, j@jannau.net,
	jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <4B178C4D.1020007@redhat.com>
References: <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>
	 <4B154C54.5090906@redhat.com>
	 <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>
	 <4B155288.1060509@redhat.com>
	 <20091201175400.GA19259@core.coreip.homeip.net>
	 <4B1567D8.7080007@redhat.com>
	 <20091201201158.GA20335@core.coreip.homeip.net>
	 <4B15852D.4050505@redhat.com>
	 <20091202093803.GA8656@core.coreip.homeip.net>
	 <4B16614A.3000208@redhat.com>
	 <20091202171059.GC17839@core.coreip.homeip.net>
	 <4B16C10E.6040907@redhat.com>
	 <1CA77278-9B8E-4169-8F10-78764A35F64E@wilsonet.com>
	 <1259802169.3085.10.camel@palomino.walls.org> <4B178C4D.1020007@redhat.com>
Content-Type: text/plain
Date: Thu, 03 Dec 2009 07:02:49 -0500
Message-Id: <1259841769.3100.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-03 at 08:00 -0200, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
> > On Wed, 2009-12-02 at 14:55 -0500, Jarod Wilson wrote:
> >> On Dec 2, 2009, at 2:33 PM, Mauro Carvalho Chehab wrote:

 
> > Both of those IR devices are/will be encapsulated in a v4l2_subdevice
> > object internally.  I was going to write lirc_v4l glue between the
> > v4l2_device/v4l2_subdev_ir_ops and lirc_dev.
> > 
> > As for the the I2C chips, I was going to go back and encapsulate those
> > in the v4l2_subdevice object as well, so then my notional lirc_v4l could
> > pick those up too.  The I2C subsystem only allows one binding to an I2C
> > client address/name on a bus.  So without some new glue like a notional
> > lirc_v4l, it *may* be hard to share between ir-kbd-i2c and lirc_i2c and
> > lirc_zilog.
> 
> Maybe you're having a bad time because you may be trying to integrate lirc
> at the wrong place.

These were just ideas.  I haven't done *anything* yet. ;)


> All devices at V4L tree including ir-kbd-i2c use ir-common.ko 
> (at /drivers/media/common tree) module to communicate to IR's. 
> I'm preparing some patches to extend this also to dvb-usb devices 
> (that uses a close enough infrastructure). 
> 
> Also, most of the decoding code are there, in a form of helper routines.
> 
> As the idea is to provide lirc interface to all devices that can work with
> raw pulse/space, the proper place is to write a subroutine there that, once
> called, will make those pulse/space raw codes available to lirc and will
> call the needed decoders to export them also to evdev.
> 
> The code at ir-common module was originally built to be used by V4L, but I'm
> porting the code there to be generic enough to be a library that can be used
> by other drivers. So, lirc_zilog and other lirc devices that will need to open
> evdev interfaces after running a decoder can use them.

I think I see what you are saying (I wish could see look at a whiteboard
somewhere...).  Wherever we come through internally to split to 2
different userspace interfaces is fine, if you've got a big picture plan
you think is feasible.

That seems like a bit of perturbation to lirc_zilog and lirc_i2c.  My
thought was that lirc_v4l using the standardized v4l2_subdev_ir_ops
interface, and maybe some new calls associted with v4l2_device, could
subsume/unify all the functionality of lirc_i2c, lirc_zilog, ...
lirc_whatever.

Maybe that's just a poorly thought out dream though...


> Due to that, we shouldn't add v4l2_subdevice there. Nothing prevents to create
> a v4l2-ir-subdev glue if you want to see the IR's as subdevices, but this should
> be implemented as a separate module.

The v4l_subdevice just abstracted the IR hardware into a nice (mental)
box for me -- easier to keep hardware separate from software decoders
and userspace interface logic.

Also, since v4l2_subdevices may have per subdevice /dev nodes and
the /dev/../mcN nodes providing a discovery mechanism due to the Meda
Controller framework, wrapping things in v4l2_subdevice may be handy for
development and debug.  Or ... as an additional operational interface to
userspace. :D  *ducks and runs for cover*

Regards,
Andy

> Cheers,
> Mauro.


