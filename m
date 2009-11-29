Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:55475 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZK2STF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 13:19:05 -0500
MIME-Version: 1.0
In-Reply-To: <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259469121.3125.28.camel@palomino.walls.org>
	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
Date: Sun, 29 Nov 2009 13:19:10 -0500
Message-ID: <9e4733910911291019l27e5fea2x3db268311842b17@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andy Walls <awalls@radix.net>, Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 7:40 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> BTW, circa 1995 my serial mouse "Just Worked" in Linux.  Sometime around
>
> Correct X11 just talked to the serial ports. In fact that is still the
> way to configure it if you want any sanity in life.
>
>> and serial connected IRs.  It's also too convenient to access USB IR
>> hardware from existing userspace drivers to bother porting into the
>> kernel.
>
> Userspace needs a way to identify IR hardware and to interface with it
> using the right protocol. It's not clear the kernel needs to provide
> anything more than minimal hardware interfaces in most case - be that
> serial, libusb, ...

That's a description of the current system and it is driver chaos.

Half of the drivers are in user space and there are two different
classes of kernel driver - LIRC and V4L.
A lot of the hardware doesn't identify itself.
There are two types of IR data in use - pulse timing and decoded protocol.

IR is an input device. We have a nice evdev input subsystem and it has
been demonstrated that IR can work with it.

Everybody keeps complaining that they want IR to "just work".
Consolidating all of this (under 50K of code)  driver support in the
kernel is the way to make it "just work".

For example. Some IR devices only record pulse timing data. There are
various protocols - RC5, RC6, etc for turning these pulse timing into
a decode IR command. This is about 20K of code. Does it really make
sense to create a device, push this data out into user space, decode
it there, then inject the results back into the kernel (uinput) for
further processing by the input subsystem?

This decoding is getting done in user space because half of the IR
drivers are in user space. But the other half of them aren't in user
space and that set can't work in user space.  Most of the user space
drivers can be pushed into the kernel where they'll automatically load
when the device is detected.

Some of the drivers can't be moved like the IR over ALSA. But is
attaching an IR diode to the mic input of your sound card really a
device or is it a hack that should be dealt with in user space?
Another type is IR hardware that toggles the DTR output of a serial
port at 40Khz to make a signal. Same thing is done with parallel
ports. Those force the system into a bit-banging timing loop for
1/10th second.


-- 
Jon Smirl
jonsmirl@gmail.com
