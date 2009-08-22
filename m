Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43535 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbZHVQER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 12:04:17 -0400
Date: Sat, 22 Aug 2009 13:04:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
Subject: Re: [RFC] v4l2_subdev_ir_ops
Message-ID: <20090822130410.0438cbc8@pedra.chehab.org>
In-Reply-To: <1250906940.3159.20.camel@palomino.walls.org>
References: <1250906940.3159.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2009 22:09:00 -0400
Andy Walls <awalls@radix.net> escreveu:

> In the course of implementing code to run the Consumer IR circuitry in
> the CX2584[0123] chip and similar cores, I need to add
> v4l2_subdev_ir_ops for manipulating the device and fetch and send data.
> 
> In line below is a proposal at what I think those subdev ops might be.
> Feel free to take shots at it.
> 
> The insipration for these comes from two sources, the LIRC v0.8.5 source
> code and what the CX2584x chip is capable of doing:
> 
> http://prdownloads.sourceforge.net/lirc/lirc-0.8.5.tar.bz2
> http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf
> 
> Note the Consumer IR in the CX2584x can theoretically measure
> unmodulated marks and spaces with a resolution of 37.037... ns (1/27
> MHz), hence the references to nanoseconds in the proposal below.  Most
> IR devices use pulses on the order of microseconds in real life.

LIRC uses a very low level way to communicate with IR since it were originally
designed to work with just an IR receiver plugged at some serial port.

While on some very low cost devices you can still see this kind of approach,
modern devices has some IR decoding chip that can handle one or more IR
protocol directly, returning back scan codes directly. There are even some
video chips with such capability inside, like em2860 and upper designs.

In a matter of fact, it is very common to have the same bridge driver used with
both dedicated IR decoding chips and with low cost IR's. For example, if you
take a look on saa7134 driver, you'll see devices where:
	1) the IR is directly connected to a GPIO pin;
	2) IR is at a GPIO pin that generates interrupts;
	3) chips like ks007 (a low-cost micro controller with a IR decoding
firmware inside) connected in parallel at several GPIO pins;
	4) i2c IR chips.

Also, for the low cost devices, ir-functions.c already has the code to
transform several common protocols into scan codes.

>From the way you've designed the API, I think that you're wanting to write some
interface to communicate to LIRC, right? If this is the case, I think that there
are several missing parts that needs to be addressed, in terms of architecture.

The more important one is what kind of IR interfaces a V4L2 device will open to
lirc. For now (upstream), the only "official" interface defined is events
interface, used by lirc-events daemon. Still, it misses one feature: there's no
way to ask a V4L2 device to use a different IR protocol. So, we need a set of
GET_CAP, GET, SET at events interface especially designed to be used by IR.

Currently, there's no uniform way for doing it. For example, if you take a look
at lirc_gpio.c, you'll see that it depends on a patch, to be applied on
bttv-if.c[1], that exposes the board name and a wait_queue that is waked when an
IRQ with a IR remote key is generated. Btw, lirc_gpio.c only knows how to handle
with the bttv driver. IMHO, it should be named instead as lirc_bttv.

If you take a look at lirc_i2.c, it directly sends ir commands to the i2c device:

        i2c_master_send(&ir->c, keybuf, 1);
        /* poll IR chip */
        if (i2c_master_recv(&ir->c, keybuf, sizeof(keybuf)) != sizeof(keybuf)) {
                dprintk("read error\n");
                return -EIO;
        }

Btw, as there's no lock between send and receive ops, there's a risk of the driver to
try to use the I2C bus for something else in the middle of the send/recv, causing
data corruption - eventually, this might explain some cases of eeprom corruption
reported at ML.

In brief, IMO, we should first write a v4l2 device interface for it, capable of
working with all types of IR devices, using input event interface where
applied, and then address v4l2 subdev interfaces where needed.

In order to better discuss it, it would be nice to have some patches for a
driver showing some use cases.

[1] http://www.lirc.org/software/snapshots/lirc-bttv-linux-2.6.24.patch

Cheers,
Mauro.
