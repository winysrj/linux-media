Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46930 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123AbZLHELo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 23:11:44 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
In-Reply-To: <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
References: <20091204220708.GD25669@core.coreip.homeip.net>
	 <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	 <1260070593.3236.6.camel@pc07.localdom.local>
	 <20091206065512.GA14651@core.coreip.homeip.net>
	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <m3skbn6dv1.fsf@intrepid.localdomain>
	 <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Dec 2009 23:10:56 -0500
Message-Id: <1260245456.3086.91.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-12-06 at 16:23 -0500, Jon Smirl wrote:
> On Sun, Dec 6, 2009 at 3:34 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > Jon Smirl <jonsmirl@gmail.com> writes:
> >
> >>> Once again: how about agreement about the LIRC interface
> >>> (kernel-userspace) and merging the actual LIRC code first? In-kernel
> >>> decoding can wait a bit, it doesn't change any kernel-user interface.
> >>
> >> I'd like to see a semi-complete design for an in-kernel IR system
> >> before anything is merged from any source.
> >
> > This is a way to nowhere, there is no logical dependency between LIRC
> > and input layer IR.
> >
> > There is only one thing which needs attention before/when merging LIRC:
> > the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
> > actually, making a correct IR core design without the LIRC merged can be
> > only harder.
> 
> Here's a few design review questions on the LIRC drivers that were posted....

I will answer based on my understanding of LIRC as it exists today, but
I'm tired and am not going to dig into too many details I can't find
easily.

(Christoph can correct me if I get anything wrong.)


An architecture drawing can be found here:

http://www.lirc.org/html/technical.html

> How is the pulse data going to be communicated to user space?

Currently that is via lirc_dev which shows up as /dev/lircN (IIRC) in
userspace.

"The lirc_dev module is a helper and abstraction layer for other
modules. It registers /dev/lirc device in a system (including support
for devfs) and waits for plugin registration. After that it serves
device requests (open, read, poll, ioctl, close) and if needed calls
callback functions from plugin(s) to communicate with the physical
device."

The function call for hardware drivers to register with lirc_dev from
within kernel space is lirc_register_driver() which requires a structure
with points to hardware specifi operations, IIRC.


> Can the pulse data be reported via an existing interface without
> creating a new one?

Yes.


> Where is the documentation for the protocol?

http://www.lirc.org/html/technical.html


> Is it a device interface or something else?

Device for a kernelspace driver/plugin registering with lirc_dev.


> Does it work with poll, epoll, etc?

lirc_dev has an function irctl_poll() that will call a hardware specifi
poll operation if it exists, otherwise it has default poll logic.


> What is the time standard for the data, where does it come from?

I think it is usec, IIRC.

I know that the hardware I work with has sub 100 ns resolution, so
that's what is used as the basis for v4l2_subdev_ir_ops time values in
kernel.  The conversion to usec is rather trivial.

The hardware I work with is very configurable, but I always use the
BT.656 video pixel clock of of 13.5 MHz * 8 = 108 MHz as the master
frequency reference for all the pulse width measurement circuitry.


> How do you define the start and stop of sequences?

For the end of Rx signalling:

Well with the Conexant hardware I can set a maximum pulse (mark or
space) width, and the hardware will generate an Rx Timeout interrupt to
signal the end of Rx when a space ends up longer than that max pulse
width.  The hardware also puts a special marker in the hardware pulse
widht measurement FIFO (in band signalling essentially).

I'm not sure anything like that gets communicated to userspace via
lirc_dev, and I'm too tired to doublecheck right now.

If you have determined the protocol you are after, it's easy to know
what the pulse count should be and what the max pulse width should be (+
slop for crappy hardware) so finding the end of an Rx isn't hard.  The
button repeats intervals are *very* large.  I've never seen a remote
rapid fire codes back to back.


For the start of a sequence:

Easy, the first mark after a *very* long (10's of msec) space.
You could also look for very long mark header which many protocols (NEC,
RC-6, ...) have to help the IR hardware's AGC get set.


> What about capabilities of the receiver, what frequencies?

LIRC's API has a LIRC_GET_FEATURES ioctl().


> If a receiver has multiple frequencies, how do you report what
> frequency the data came in on?

I'm not sure most hardware can pick up a pulse on an arbitrary freq.
Usually you set a desired carrier and a window.  The windows can be very
generous on some hardware: Fc * 16/20 to Fc * 16/12 (e.g. for 38 kHz
that's 30.4 kHz to 50.667 kHz). 

Hardware can have a special "learn mode" to really make fine
measurements about the waveform without a specified carrier, but usually
requires some special setup and the user being prompted to take action
to get a good measurement.


> What about multiple apps simultaneously using the pulse data?

LIRC multiplexes a single device node with a daemon in userspace.


> Is receiving synchronous or queued?

kfifo's in lirc_dev IIRC.


> How big is the receive queue?

Device HW FIFO's can have a depth of 1 to 16.

My software queues for CX2388[58] devices are 512 pulse measurments deep
--  overkill except for maybe a protocol with a 256 bit manchester
encoded payload.

IIRC the lirc_dev per device buffers (on top of things that I just
mentioned) are at a size requested of lirc_dev by the underlying
hardware driver/plugin.



> How does access work, root only or any user?

Depends on udev rules.  *NIX systems by default should be doing mknod()
such that root only has access unless otherwise specified.

Connecting to the LIRC daemon is via socket interface.


> What about transmit, how do you get pulse data into the device?

With the LIRC daemon which uses, in this example, the /dev/lircN device
node.


> Transmitter frequencies?

Config file.

Also with the LIRC_SET_SEND_CARRIER and LIRC_SET_SEND_DUTY_CYCLE
ioctl()s.


> Multiple transmitters?

LIRC_SET_TRANSMITTER_MASK ioctl() for multiple Tx diodes on one IR
controller.

Multiple /dev/lircN nodes for multiple independent controllers.


> Is transmitting synchronous or queued?

kfifo's IIRC.


> How big is the transmit queue?

Likely variable again requested by the underling driver/plugin of
lirc_dev.



There are really 3 files I think you should look at for in kernel LIRC
drivers which may have answered many of those questions you had:

lirc-0.8.5/drivers/lirc.h
lirc-0.8.5/drivers/lirc_dev/lirc_dev.h
lirc-0.8.5/drivers/lirc_dev/lirc_dev.c

and IIRC you said you had an MCE USB device, so maybe

lirc-0.8.5/drivers/lirc_mceusb*/*[ch]

would interest you as well.


My particular gripes about the current LIRC interface:

1. The one thing that I wish were documented better were the distinction
between LIRC_MODE_PULSE, LIRC_MODE_RAW, and LIRC_MODE2 modes of
operation.  I think I've figured it out, but I had to look at a lot of
LIRC drivers to do so.

2. I have hardware where I can set max_pulse_width so I can optimize
pulse timer resolution and have the hardware time out rapidly on end of
RX.  I also have hardware where I can set a min_pulse_width to set a
hardware low-pass/glitch filter.  Currently LIRC doesn't have any way to
set these, but it would be nice to have.  In band signalling of a
hardware detected "end of Rx" may also make sense then too.

3. As I mentioned before, it would be nice if LIRC could set a batch of
parameters atomically somehow, instead of with a series of ioctl()s.  I
can work around this in kernel though.


> How are capabilities exposed, sysfs, etc?
> What is the interface for attaching an in-kernel decoder?
> If there is an in-kernel decoder should the pulse data stop being
> reported, partially stopped, something else?
> What is the mechanism to make sure both system don't process the same pulses?

Mauro and Dmitiri probably have better answers.

Regards,
Andy


