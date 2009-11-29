Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35039 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbZK2S7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 13:59:25 -0500
Date: Sun, 29 Nov 2009 19:00:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Andy Walls <awalls@radix.net>, Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
Message-ID: <20091129190059.02c2a0ff@lxorguk.ukuu.org.uk>
In-Reply-To: <9e4733910911291019l27e5fea2x3db268311842b17@mail.gmail.com>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	<BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<m3aay6y2m1.fsf@intrepid.localdomain>
	<9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org>
	<20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	<9e4733910911291019l27e5fea2x3db268311842b17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Half of the drivers are in user space and there are two different
> classes of kernel driver - LIRC and V4L.


> A lot of the hardware doesn't identify itself.
> There are two types of IR data in use - pulse timing and decoded protocol.
> 
> IR is an input device. We have a nice evdev input subsystem and it has
> been demonstrated that IR can work with it.

Evdev allows userspace to feed events into the kernel.

> Everybody keeps complaining that they want IR to "just work".
> Consolidating all of this (under 50K of code)  driver support in the
> kernel is the way to make it "just work".

We have things called "Libraries" that unlike kernel code run out of a
secure context, can be paged and shared by applications dynamically.

Also the data rate of IR controllers puts it into the realm where the
kernel doesn't need to be involved, in fact you could turn them into
evdev events via user space quite acceptably, or even into meaningful
actions and onto dbus.

> For example. Some IR devices only record pulse timing data. There are
> various protocols - RC5, RC6, etc for turning these pulse timing into
> a decode IR command. This is about 20K of code. Does it really make
> sense to create a device, push this data out into user space, decode
> it there, then inject the results back into the kernel (uinput) for
> further processing by the input subsystem?

Does it really make sense to put big chunks of protocol decoding crap for
an interface which runs at about 1 character per second on a good day
into the kernel ? Does it really make sense ot move 50K of code from user
context to kernel context where it must meet strict security
requirements, be extensively audited and cannot be paged. For embedded
users will also have to be highly modular so no unused bits are loaded.

> This decoding is getting done in user space because half of the IR
> drivers are in user space. But the other half of them aren't in user
> space and that set can't work in user space.  Most of the user space
> drivers can be pushed into the kernel where they'll automatically load
> when the device is detected.

So you proposed to write another ton of new drivers in kernel space for
these only devices supported by user space, portably and to test and
submit them all. If you can't persuade the maintainera of all those
drivers to do so you don't appear to have a credible proposal.

> attaching an IR diode to the mic input of your sound card really a
> device or is it a hack that should be dealt with in user space?

It's a device. There is no divide between "hack" and "device", as anyone
who ever worked on the Mac68K can assure you ;)

> Another type is IR hardware that toggles the DTR output of a serial
> port at 40Khz to make a signal. Same thing is done with parallel
> ports. Those force the system into a bit-banging timing loop for
> 1/10th second.

We have people who run wireless like that, people who ran SCSI and IDE
like that. In the embedded world its the norm. If you sell 100,000
devices then saving that part, wiring and board space is often the right
choice. That kind of stuff needs doing in user space not kernel.

You stated the real problem at the start - devices don't identify
themselves well. That doesn't seem to be a kernel problem other than for
kernel drivers perhaps exposing more information on themselves via sysfs.

