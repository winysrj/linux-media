Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36866 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbZHWSAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 14:00:04 -0400
Date: Sun, 23 Aug 2009 15:00:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
Subject: Re: [RFC] v4l2_subdev_ir_ops
Message-ID: <20090823150000.31de77da@pedra.chehab.org>
In-Reply-To: <1250976470.4238.42.camel@palomino.walls.org>
References: <1250906940.3159.20.camel@palomino.walls.org>
 <20090822130410.0438cbc8@pedra.chehab.org>
 <1250976470.4238.42.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Aug 2009 17:27:50 -0400
Andy Walls <awalls@radix.net> escreveu:

> Right, so we have several type of IR devices, and the v4l2_subdev_ir_ops
> interface needs to accomadte all of them eventually - in a way that
> makes sense.
> 
> Just to reiterate what you said (to make sure I understand), the IR
> receiver devices are:
> 
> 1) A simple bit (GPIO pin) that must be polled and manually timed to
> extract pulse widths
> 
> 2) A bit (GPIO pin) that can generate an interrupt but timing
> measurement is still manual 
> 
> 3) A microcontroller with a parallel (GPIO pins) output of the codes.
> 
> 4) An i2c connected microcontroller or IR chip that outputs codes.
> 
> 
> I have two devices that don't quite fit in that set:
> 
> a. The CX23885 has an IR device, which is part of a larger I2C-connected
> integrated subdevice, that provides pulse timings via i2c register
> reads.
> 
> b. The CX23888 has an integrated IR device that provides pulse timings
> via local register reads.  
> 
> I think these fall somewhere between 2) and 3) in the above list.  None
> of the code in saa7134 quite does what I need, but thank you for the
> high level overview to help me figure it out.

Ok, so, there are currently 5 known different sets of IR. I think I've seen at
the datasheets or at the driver code for something like (b).

> > Also, for the low cost devices, ir-functions.c already has the code to
> > transform several common protocols into scan codes.
> 
> Yes I was planning on leveraging those.  I was probably going to add
> some.  I hadn't gotten there yet.
> 
> I figured if the in kernel ir-functions.c file didn't have a pulse width
> to RC-5 protocol conversion routine, that I would have to add one.
> 
> Once I have that, I can use the already existing ir_decode_biphase()
> function, remote keymaps, etc.

You'll see rc5 conversion code at bttv-input (bttv_rc5_irq), and a nec
conversion code at saa7134-input (saa7134_nec_timer, nec_task and
saa7134_nec_irq). It shouldn't be hard to move they to ir-common.c, to be used on
other places where they're needed.

> > The more important one is what kind of IR interfaces a V4L2 device will open to
> > lirc.
> 
> I was thinking a lirc-v4l2-subdev plugin for lirc-dev.  If the
> v4l2_subdev_ir_ops interface aligned or can easily translate to
> supporting things LIRC needed, then follow on support for all video
> related IR devices would fall out from implementing the
> v4l2_subdev_ir_ops interface.  (In my optimistic version of the
> future ;] ).

This won't work, due to two reasons:

1) a subdev interface works for the devices with i2c interfaces (e. g. the subdev's),
but it won't work on other cases;

2) even when you'll have this at i2c, you may still need to properly lock the IR code
to avoid that the IR operation to happen in the middle of another i2c transfer.

So, IMO, we need to create a lirc type of ops handled by the device itself.
Those ops will take care of interfacing with subdevs in the case that this
applies.

> What I wouldn't want to happen iss a lirc-conexant plugin for lirc-dev,
> and a lirc-foo plugin for lirc-dev, and etc.
> 
> It was my desire to try to keep the bridge drivers mostly out of the
> loop aside from device setup and hook-up to another layer: be that the
> input layer or LIRC somehow.

This seems to be the proper approach to me.

> >  For now (upstream), the only "official" interface defined is events
> > interface, used by lirc-events daemon.
> 
> Yup.  The input/events interface will be the first interface I
> implement.  I suspect, it satsifies the >90% use case.

Yes, I think so. We need to discuss with the events people a way to allow
selecting, from userspace, what IR protocols are supported by a given device
and allow to get/set the kind of IR protocol that will be used. 

> >  Btw, lirc_gpio.c only knows how to handle
> > with the bttv driver. IMHO, it should be named instead as lirc_bttv.
> 
> I didn't know that.
> 
> All the more reason to get a uniform v4l2_subdev_ir_ops interface and
> start encapsulating things.

Agreed. IMHO, in the specific case of lirc_gpio, I suspect that most (or maybe all) of the
code should be merged inside bttv-input, to be easier for new board additions to receive
their appropriate setup to retrieve IR keys also since their addition at the kernel.

> I'd much rather see a migration to a lirc_v4l2_subdev plugin for
> lirc-dev.  That would get rid of the "stray cats & dogs" and could even
> unify the I2C vs. non-I2c IR devices into one interface.  (The whole
> point of Hans' v4l2_subdev class).

See above. This should be unified outside subdev, since, on most cases, the IR
is handled directly by the bridge code. Another alternative would be to create
a fake subdev for the IR handling code, but, IMHO, such change will be large and
I don't see much gain on doing it. Also, since on several cases it shares the bridge
IRQ code, the IR handling code will be broken on just a layer interface at the
subdev, but the real work will be handled at the bridge driver.
> 
> Of course LIRC is out of kernel right now, so it is not a priority I
> assume.

In the case of the event interface, this is independent of lirc, since there's no
need of having an extra kernel driver for it.

Yet, at lirc side, at least with the version I have on RHEL5 (0.8.4a), it
didn't work well with usb devices, since those devices are hot-pluggable.
In order to work, lirc needs the name of the event interface at the command
line:

$ lircd -H devinput -d /dev/input/event6

However, the event interface is only known after plugging the device. So, you
cannot have lircd initialized during boot time, if your device is not already
plugged. Also, if you unplug the device while there are some client listening
to it, the daemon dies.

IMHO, it should be providing a driver that checks for the creation of e
at /dev/video? and, if a node is found, it should do the a procedure similar to
what is done by v4l2-apps/util/v4l2-sysfs-path (the latest version at
http://linuxtv.org/hg/v4l-dvb tree), to determine the associated event device.
For example, with my HVR-950, it returns:

device     = /dev/video0
bus info   = usb-0000:00:1d.7-8
sysfs path = /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8
Associated devices:
        i2c-adapter:i2c-4
        input:input12:event6 (dev 13,70)
        sound:pcmC1D0c (dev 116,9)
        sound:dsp1 (dev 14,19)
        sound:audio1 (dev 14,20)
        sound:controlC1 (dev 116,10)
        sound:mixer1 (dev 14,16)
        dvb:dvb0.frontend0 (dev 212,0)
        dvb:dvb0.demux0 (dev 212,1)
        dvb:dvb0.dvr0 (dev 212,2)
        dvb:dvb0.net0 (dev 212,3)
        usb_endpoint:usbdev1.11_ep00 (dev 252,20)

So, the event interface associated with /dev/video0 is /dev/input/event6 (minor
13, major 70), as reported above.

> > In order to better discuss it, it would be nice to have some patches for a
> > driver showing some use cases.
> 
> I'm in the process of writing something for the CX23888.  What I first
> implement will be closer to the minimal set needed as Hans suggested.  I
> will keep in mind all the types of IR implementations that you
> mentioned.
> 
> The input event interface will be a separate set of routines in the
> cx23885 driver that uses what code I can from ir-functions.c.

I suggest you to have them at *-input.c file, to keep the same convention as
the other IR drivers. This makes easier for people to know where the IR
specific code is.

> Hopefully I'll have the initial CX23888 driver working before the LPC.
> I can then talk face to face with Hans at least. IIRC you stated you
> were not going to the LPC because of the Kernel Summit.

I would love to go to LPC, but it is hard to attend to both events, since they'll be
close and both are very long trips. Also, IMO, being in Japan for KS and JLC
will be an interesting opportunity to meet with people in Asia and spread our
work there. I'll try to be at LPC for the next year.

> Again, thanks for information and comments.

Anytime.



Cheers,
Mauro
