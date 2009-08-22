Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50442 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbZHVV0r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 17:26:47 -0400
Subject: Re: [RFC] v4l2_subdev_ir_ops
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <20090822130410.0438cbc8@pedra.chehab.org>
References: <1250906940.3159.20.camel@palomino.walls.org>
	 <20090822130410.0438cbc8@pedra.chehab.org>
Content-Type: text/plain
Date: Sat, 22 Aug 2009 17:27:50 -0400
Message-Id: <1250976470.4238.42.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-08-22 at 13:04 -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 21 Aug 2009 22:09:00 -0400
> Andy Walls <awalls@radix.net> escreveu:
> 
> > In the course of implementing code to run the Consumer IR circuitry in
> > the CX2584[0123] chip and similar cores, I need to add
> > v4l2_subdev_ir_ops for manipulating the device and fetch and send data.
> > 
> > In line below is a proposal at what I think those subdev ops might be.
> > Feel free to take shots at it.
> > 
> > The insipration for these comes from two sources, the LIRC v0.8.5 source
> > code and what the CX2584x chip is capable of doing:
> > 
> > http://prdownloads.sourceforge.net/lirc/lirc-0.8.5.tar.bz2
> > http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf
> > 
> > Note the Consumer IR in the CX2584x can theoretically measure
> > unmodulated marks and spaces with a resolution of 37.037... ns (1/27
> > MHz), hence the references to nanoseconds in the proposal below.  Most
> > IR devices use pulses on the order of microseconds in real life.

Mauro,

Thank you for your comments.


> LIRC uses a very low level way to communicate with IR since it were originally
> designed to work with just an IR receiver plugged at some serial port.
> 
> While on some very low cost devices you can still see this kind of approach,
> modern devices has some IR decoding chip that can handle one or more IR
> protocol directly, returning back scan codes directly. There are even some
> video chips with such capability inside, like em2860 and upper designs.
> 
> In a matter of fact, it is very common to have the same bridge driver used with
> both dedicated IR decoding chips and with low cost IR's. For example, if you
> take a look on saa7134 driver, you'll see devices where:
> 	1) the IR is directly connected to a GPIO pin;
> 	2) IR is at a GPIO pin that generates interrupts;
> 	3) chips like ks007 (a low-cost micro controller with a IR decoding
> firmware inside) connected in parallel at several GPIO pins;
> 	4) i2c IR chips.

Right, so we have several type of IR devices, and the v4l2_subdev_ir_ops
interface needs to accomadte all of them eventually - in a way that
makes sense.

Just to reiterate what you said (to make sure I understand), the IR
receiver devices are:

1) A simple bit (GPIO pin) that must be polled and manually timed to
extract pulse widths

2) A bit (GPIO pin) that can generate an interrupt but timing
measurement is still manual 

3) A microcontroller with a parallel (GPIO pins) output of the codes.

4) An i2c connected microcontroller or IR chip that outputs codes.


I have two devices that don't quite fit in that set:

a. The CX23885 has an IR device, which is part of a larger I2C-connected
integrated subdevice, that provides pulse timings via i2c register
reads.

b. The CX23888 has an integrated IR device that provides pulse timings
via local register reads.  

I think these fall somewhere between 2) and 3) in the above list.  None
of the code in saa7134 quite does what I need, but thank you for the
high level overview to help me figure it out.


> Also, for the low cost devices, ir-functions.c already has the code to
> transform several common protocols into scan codes.

Yes I was planning on leveraging those.  I was probably going to add
some.  I hadn't gotten there yet.

I figured if the in kernel ir-functions.c file didn't have a pulse width
to RC-5 protocol conversion routine, that I would have to add one.

Once I have that, I can use the already existing ir_decode_biphase()
function, remote keymaps, etc.

This was all something I thought should not be in the v4l2_subdev for
the CX2388x IR.



> >From the way you've designed the API, I think that you're wanting to write some
> interface to communicate to LIRC, right?  If this is the case, I think that there
> are several missing parts that needs to be addressed, in terms of architecture.

I was trying to develop an interface that supported both the in kernnel
ir-functions.c functions and LIRC.   Yes, you are correct.  Both will
need more glue than what the v4l2_subdev_ir_ops interface will provide.

My intent was to provide an interface that made that "glue" as simple as
possible (for LIRC for sure) and hopefully for an in kernel
implementation using the ir-functions.c functions.

> The more important one is what kind of IR interfaces a V4L2 device will open to
> lirc.

I was thinking a lirc-v4l2-subdev plugin for lirc-dev.  If the
v4l2_subdev_ir_ops interface aligned or can easily translate to
supporting things LIRC needed, then follow on support for all video
related IR devices would fall out from implementing the
v4l2_subdev_ir_ops interface.  (In my optimistic version of the
future ;] ).

What I wouldn't want to happen iss a lirc-conexant plugin for lirc-dev,
and a lirc-foo plugin for lirc-dev, and etc.

It was my desire to try to keep the bridge drivers mostly out of the
loop aside from device setup and hook-up to another layer: be that the
input layer or LIRC somehow.


>  For now (upstream), the only "official" interface defined is events
> interface, used by lirc-events daemon.

Yup.  The input/events interface will be the first interface I
implement.  I suspect, it satsifies the >90% use case.


>  Still, it misses one feature: there's no
> way to ask a V4L2 device to use a different IR protocol. So, we need a set of
> GET_CAP, GET, SET at events interface especially designed to be used by IR.
> 
> Currently, there's no uniform way for doing it. For example, if you take a look
> at lirc_gpio.c, you'll see that it depends on a patch, to be applied on
> bttv-if.c[1], that exposes the board name and a wait_queue that is waked when an
> IRQ with a IR remote key is generated.



>  Btw, lirc_gpio.c only knows how to handle
> with the bttv driver. IMHO, it should be named instead as lirc_bttv.

I didn't know that.

All the more reason to get a uniform v4l2_subdev_ir_ops interface and
start encapsulating things.

I'd much rather see a migration to a lirc_v4l2_subdev plugin for
lirc-dev.  That would get rid of the "stray cats & dogs" and could even
unify the I2C vs. non-I2c IR devices into one interface.  (The whole
point of Hans' v4l2_subdev class).

Of course LIRC is out of kernel right now, so it is not a priority I
assume.


> If you take a look at lirc_i2.c, it directly sends ir commands to the i2c device:
> 
>         i2c_master_send(&ir->c, keybuf, 1);
>         /* poll IR chip */
>         if (i2c_master_recv(&ir->c, keybuf, sizeof(keybuf)) != sizeof(keybuf)) {
>                 dprintk("read error\n");
>                 return -EIO;
>         }
> 
> Btw, as there's no lock between send and receive ops, there's a risk of the driver to
> try to use the I2C bus for something else in the middle of the send/recv, causing
> data corruption - eventually, this might explain some cases of eeprom corruption
> reported at ML.

Oooh.  Thanks for reminding me.  That's not an issue for the CX23888 but
will be for the CX23885.


> In brief, IMO, we should first write a v4l2 device interface for it, capable of
> working with all types of IR devices, using input event interface where
> applied, and then address v4l2 subdev interfaces where needed.
> 
> In order to better discuss it, it would be nice to have some patches for a
> driver showing some use cases.

I'm in the process of writing something for the CX23888.  What I first
implement will be closer to the minimal set needed as Hans suggested.  I
will keep in mind all the types of IR implementations that you
mentioned.

The input event interface will be a separate set of routines in the
cx23885 driver that uses what code I can from ir-functions.c.

Hopefully I'll have the initial CX23888 driver working before the LPC.
I can then talk face to face with Hans at least. IIRC you stated you
were not going to the LPC because of the Kernel Summit.


Again, thanks for information and comments.

Regards,
Andy

> [1] http://www.lirc.org/software/snapshots/lirc-bttv-linux-2.6.24.patch
> 
> Cheers,
> Mauro.
> 

