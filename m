Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3628 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623AbZHWTRI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 15:17:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] v4l2_subdev_ir_ops
Date: Sun, 23 Aug 2009 21:16:36 +0200
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jwilson@redhat.com>
References: <1250906940.3159.20.camel@palomino.walls.org> <1250976470.4238.42.camel@palomino.walls.org> <20090823150000.31de77da@pedra.chehab.org>
In-Reply-To: <20090823150000.31de77da@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908232116.36519.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 23 August 2009 20:00:00 Mauro Carvalho Chehab wrote:
> Em Sat, 22 Aug 2009 17:27:50 -0400
>
> Andy Walls <awalls@radix.net> escreveu:
> > > The more important one is what kind of IR interfaces a V4L2 device
> > > will open to lirc.
> >
> > I was thinking a lirc-v4l2-subdev plugin for lirc-dev.  If the
> > v4l2_subdev_ir_ops interface aligned or can easily translate to
> > supporting things LIRC needed, then follow on support for all video
> > related IR devices would fall out from implementing the
> > v4l2_subdev_ir_ops interface.  (In my optimistic version of the
> > future ;] ).
>
> This won't work, due to two reasons:
>
> 1) a subdev interface works for the devices with i2c interfaces (e. g.
> the subdev's), but it won't work on other cases;

Subdev is actually independent of i2c, that was the one of the reasons for 
making v4l2_subdev in the first place. Both the cx18 and ivtv drivers use a 
non-i2c subdev in fact. It does rely on there being a parent v4l2_device 
struct with which it will be registered. In other words: while there may be 
good reasons for not using v4l2_subdev, this reason isn't one of them.

> 2) even when you'll have this at i2c, you may still need to properly lock
> the IR code to avoid that the IR operation to happen in the middle of
> another i2c transfer.

I could well be wrong, but isn't the i2c_adapter already locking at the bus 
level?

> So, IMO, we need to create a lirc type of ops handled by the device
> itself. Those ops will take care of interfacing with subdevs in the case
> that this applies.
>
> > What I wouldn't want to happen iss a lirc-conexant plugin for lirc-dev,
> > and a lirc-foo plugin for lirc-dev, and etc.
> >
> > It was my desire to try to keep the bridge drivers mostly out of the
> > loop aside from device setup and hook-up to another layer: be that the
> > input layer or LIRC somehow.
>
> This seems to be the proper approach to me.
>
> > >  For now (upstream), the only "official" interface defined is events
> > > interface, used by lirc-events daemon.
> >
> > Yup.  The input/events interface will be the first interface I
> > implement.  I suspect, it satsifies the >90% use case.
>
> Yes, I think so. We need to discuss with the events people a way to allow
> selecting, from userspace, what IR protocols are supported by a given
> device and allow to get/set the kind of IR protocol that will be used.
>
> > >  Btw, lirc_gpio.c only knows how to handle
> > > with the bttv driver. IMHO, it should be named instead as lirc_bttv.
> >
> > I didn't know that.
> >
> > All the more reason to get a uniform v4l2_subdev_ir_ops interface and
> > start encapsulating things.

BTW, Andy: I liked your latest proposal for these ops much better. Seems to 
me to be an excellent starting point.

> Agreed. IMHO, in the specific case of lirc_gpio, I suspect that most (or
> maybe all) of the code should be merged inside bttv-input, to be easier
> for new board additions to receive their appropriate setup to retrieve IR
> keys also since their addition at the kernel.
>
> > I'd much rather see a migration to a lirc_v4l2_subdev plugin for
> > lirc-dev.  That would get rid of the "stray cats & dogs" and could even
> > unify the I2C vs. non-I2c IR devices into one interface.  (The whole
> > point of Hans' v4l2_subdev class).
>
> See above. This should be unified outside subdev, since, on most cases,
> the IR is handled directly by the bridge code. Another alternative would
> be to create a fake subdev for the IR handling code, but, IMHO, such
> change will be large and I don't see much gain on doing it. Also, since
> on several cases it shares the bridge IRQ code, the IR handling code will
> be broken on just a layer interface at the subdev, but the real work will
> be handled at the bridge driver.

It is a perfectly legitimate approach to use a subdev for IR handling. 
Usually it is some separate set of registers or IC block anyway, whether it 
is a bridge driver or a complex chip like cx2584x. The v4l2_subdev approach 
allows one to model such things in a relatively high-level manner. Andy has 
experience doing exactly that in the cx18 driver, so he is very well placed 
to investigate which approach is best.

It is very important that everyone realizes that the sub-device construct 
basically is an abstract model of the hardware, independent of any busses 
or where that hardware actually is (i.e. as a part of a larger IC or a 
self-contained i2c device). In 95% of the cases it does indeed model an i2c 
device, but that is just because these are so common.

In fact, it could be especially useful in cases where the i2c support is 
sometimes in a bridge, sometimes in an i2c device (or more than one). If 
the actual API is through a v4l2_subdev, then that will make everything 
nicely consistent.

Of course, the proof of the pudding is in the eating, so try it in a few 
drivers. You generally discover very quickly whether something is a good 
API or not.

> > Of course LIRC is out of kernel right now, so it is not a priority I
> > assume.
>
> In the case of the event interface, this is independent of lirc, since
> there's no need of having an extra kernel driver for it.
>
> Yet, at lirc side, at least with the version I have on RHEL5 (0.8.4a), it
> didn't work well with usb devices, since those devices are hot-pluggable.
> In order to work, lirc needs the name of the event interface at the
> command line:
>
> $ lircd -H devinput -d /dev/input/event6
>
> However, the event interface is only known after plugging the device. So,
> you cannot have lircd initialized during boot time, if your device is not
> already plugged. Also, if you unplug the device while there are some
> client listening to it, the daemon dies.

Yeah, that really sucks. I had the same problems, and it's very annoying.

> IMHO, it should be providing a driver that checks for the creation of e
> at /dev/video? and, if a node is found, it should do the a procedure
> similar to what is done by v4l2-apps/util/v4l2-sysfs-path (the latest
> version at http://linuxtv.org/hg/v4l-dvb tree), to determine the
> associated event device. For example, with my HVR-950, it returns:
>
> device     = /dev/video0
> bus info   = usb-0000:00:1d.7-8
> sysfs path = /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8
> Associated devices:
>         i2c-adapter:i2c-4
>         input:input12:event6 (dev 13,70)
>         sound:pcmC1D0c (dev 116,9)
>         sound:dsp1 (dev 14,19)
>         sound:audio1 (dev 14,20)
>         sound:controlC1 (dev 116,10)
>         sound:mixer1 (dev 14,16)
>         dvb:dvb0.frontend0 (dev 212,0)
>         dvb:dvb0.demux0 (dev 212,1)
>         dvb:dvb0.dvr0 (dev 212,2)
>         dvb:dvb0.net0 (dev 212,3)
>         usb_endpoint:usbdev1.11_ep00 (dev 252,20)
>
> So, the event interface associated with /dev/video0 is /dev/input/event6
> (minor 13, major 70), as reported above.

Mauro, you should consider using libudev to map major/minor device numbers 
to the actual device nodes. Right now no udev rules are taken into account. 
So if someone renames a device node you will never find it.

> > > In order to better discuss it, it would be nice to have some patches
> > > for a driver showing some use cases.
> >
> > I'm in the process of writing something for the CX23888.  What I first
> > implement will be closer to the minimal set needed as Hans suggested. 
> > I will keep in mind all the types of IR implementations that you
> > mentioned.
> >
> > The input event interface will be a separate set of routines in the
> > cx23885 driver that uses what code I can from ir-functions.c.
>
> I suggest you to have them at *-input.c file, to keep the same convention
> as the other IR drivers. This makes easier for people to know where the
> IR specific code is.
>
> > Hopefully I'll have the initial CX23888 driver working before the LPC.
> > I can then talk face to face with Hans at least. IIRC you stated you
> > were not going to the LPC because of the Kernel Summit.
>
> I would love to go to LPC, but it is hard to attend to both events, since
> they'll be close and both are very long trips. Also, IMO, being in Japan
> for KS and JLC will be an interesting opportunity to meet with people in
> Asia and spread our work there. I'll try to be at LPC for the next year.
>
> > Again, thanks for information and comments.
>
> Anytime.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
