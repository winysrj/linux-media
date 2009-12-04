Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZLDOMy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 09:12:54 -0500
Date: Fri, 4 Dec 2009 12:12:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
Message-ID: <20091204121234.5144836b@pedra>
In-Reply-To: <20091204100642.GD22570@core.coreip.homeip.net>
References: <BDodf9W1qgB@lirc>
	<4B14EDE3.5050201@redhat.com>
	<4B1524DD.3080708@redhat.com>
	<4B153617.8070608@redhat.com>
	<A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
	<4B17AA6A.9060702@redhat.com>
	<20091203175531.GB776@core.coreip.homeip.net>
	<20091203163328.613699e5@pedra>
	<20091204100642.GD22570@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 4 Dec 2009 02:06:42 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:

> On Thu, Dec 03, 2009 at 04:33:28PM -0200, Mauro Carvalho Chehab wrote:
> > Let me draw my view:
> > 
> > Em Thu, 3 Dec 2009 09:55:31 -0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:
> > 
> > > No, please, wait just a minute. I know it is tempting to just merge
> > > lirc_dev and start working, but can we first agree on the overall
> > > subsystem structure before doing so. It is still quite inclear to me.
> > > 
> > > The open questions (for me at least):
> > > 
> > > - do we create a new class infrastructure for all receivers or only for
> > >   ones plugged into lirc_dev? Remember that classifying objects affects
> > >   how udev and friemds see them and may either help or hurt writing PnP
> > >   rules.
> > 
> > IMO, I would create it as /sys/class/input/IR (just like the /mice). I
> 
> That will not work. Driver core does not support notion of subclasses,
> Greg and Kay insist on flat class namespace. Mice do not belong to a
> separate [sub]class, they all members of input class, with peculiar
> directory structure.
> 
> IRs however, I believe, deserve a full-fledged class (since they are in
> my view are parents to the input devices representing remotes). I would
> argus for the following sysfs hierarchy for the main device tree:
> 
> /sys/devices/pcipci0000:00/../pci.../../irrcv0/input14/event16
> /sys/devices/pcipci0000:00/../usb.../../irrcv1/input15/event17
> 					      /input16/event18
> 
> And corresponding class:
> 
> /sys/class/irrcv/irrcv0
>                  irrcv1
> 
> and so on.

Seems fine to me.
> 
> >
> > don't see why do we need to different lirc than no-lirc drivers in the
> > case of sysfs class.
> 
> I do agree that _all_ infrared receivers should belong to this class,
> and not only ones utilizing lirc_dev.
> 
> > As devices with raw input capabilities will have
> > another dev to communicate, this means that we'll need a /lirc node
> > there to point to lirc dev.
> > 
> > > 
> > > - do we intend to support in-kernel sotfware decoders?
> > 
> > Yes.
> > 
> 
> Good.
> 
> > > - What is the structure? Do we organize them as a module to be used by driver
> > >   directly or the driver "streams" the data to IR core and the core
> > >   applies decoders (in the same fashion input events from drivers flow
> > >   into input core and then distributed to all bound interfaces for
> > >   processing/conversion/transmission to userspace)?
> > 
> > My plan is to expand ir-common.ko module and rename it to ir-core, to be 
> > the IR core module for the evdev interface. I'm already working on it. 
> > My idea for an architecture is that the lirc-core module will use 
> > ir-common where the IR decoders will be, and the evdev interface.
> >
> 
> How related lirc-core to the current lirc code? If it is not the same
> maybe we should not call it lirc to avoid confusion.

Just for better illustrate what I'm seeing, I broke the IR generic
code into two components:

	lirc core - the module that receives raw pulse/space and creates
		    a device to receive raw API pulse/space events;

	IR core - the module that receives scancodes, convert them into
		  keycodes and send via evdev interface.

We may change latter the nomenclature, but I'm seeing the core as two different
modules, since there are cases where lirc core won't be used (those
devices were there's no way to get pulse/space events).

> > Not sure if I got your idea. Basically, what I see is:
> > 
> > 	For device drivers that work in raw mode:
> > [IR physical device] ==> [IR receiver driver]  ==> [lirc-core] ==> [decoder] ==> [ir-core] ==> [evdev]
> > 
> > (eventually, we can merge decoder and ir-core into one module at the beginning,
> > depending on the size of the decoders)
> > 
> > 	For device drivers that work only in evdev mode (those with hardware decoders):
> > 
> > [IR physical device] ==> [IR receiver driver]  ==> [ir-core] ==> [evdev]
> >
> 
> Maybe we are talking about the same things and it is just names that are
> confusing. I'd imagine something like this:
> 
> 
> In-kernel decoding:
> 
> [IR physical device] => [IR receiver driver] => [IR core] => [decoder] => [input core] => [evdev]
> 							  => [decoder] => [input core] => [evdev]  
> 
> Hardware decoder:
> [IR physical device] => [IR receiver driver] => [IR core]
> 					     => [input core] => [evdev]  
> 
> I.e we still register with IR core but driver communicates directly with input device.
> 
> Userspace decoging:
> [IR physical device] => [IR receiver driver] => [IR core] => [lirc_dev] => [lircd] => [uinput] => [input core] => [evdev]

I think, we're thinking the same thing, but I've broke the IR core into two parts:
the lirc core, where the LIRC API will be handled, and the IR core, where the input API will be handled.

I've assumed that we'll use lirc API only for raw IR decode. So, in the hardware decoder case,
we will expose only the evdev. 

So a drawing showing those two components will be:

In-kernel decoding:

[IR physical device] => [IR receiver driver] => [LIRC core] => [decoder] => [IR core] => [input core] => [evdev]
						   ||
						    => [Lirc API device]

Hardware decoder:
[IR physical device] => [IR receiver driver] => [IR core]
					     => [input core] => [evdev]

Userspace decoding:
[IR physical device] => [IR receiver driver] => [LIRC core] => [Lirc API device] => [lircd] => [uinput] => [input core] => [evdev]

Of course, for userspace, there is trivial case where it will 
just directly read from evdev without using any userspace program:

Userspace direct usage of IR:
[IR physical device] => [IR receiver driver] => [IR core] => [input core] => [evdev]

> Essentially lirc_dev becomes a special case of decoder that, instead of
> connecting inptu core and creating input devices passes the data to
> userspace.

Yes.

> I did not show the block that you call ir-core since I expect it to be more
> like a library rather than an object in overall structure.
> 
>  
> > > 
> > > Now as far as input core goes I see very limited number of changes that
> > > may be needed:
> > > 
> > > - Allow to extend size of "scancode" in EVIOC{S,G}KEYCODE if we are
> > >   unable to limit ourselves to 32 bits (keeping compatibility of course)
> > 
> > Yes, but the way EVIOC{S,G}KEYCODE currently works, it performs poorly when you have a
> > table with 2^64 size. The table is very sparsed, but, as the key to get/set a code is
> > the scancode, it is very hard to enumberate what are the actual entries there. The
> > better is to use an index parameter for they, instead of using the scancode as such.
> > 
> 
> evdev does not really care what you use as scancode. So nobody stops
> your driver to report index as a scancode and accept index from the
> ioctl. The true "scancode" will thus be competely hidden from userspace.
> In fact a few drivers do just that.

Let me better express here. It is all about how we'll expand the limits of those
ioctls to fulfill the needs.

The point is that we'll have, let's say something like to 50-500 scancode/keycode tuples
sparsely spread into a 2^64 scancode universe (assuming 64 bits - Not sure if is there any
IR protocol/code with a bigger scancode).

On such universe if we want to get all keycodes with the current ioctls for a scancode in
the range of 32 bits, we need to do something like:

u32 code;
int codes[2];
for (code = 0; code <= (unsigned u32) - 1; code++) {
	codes[0] = (int)code;
	if (!ioctl(fd, EVIOCGKEYCODE, codes))
		printf("scancode 0x%08x = keycode 0x%08x\n", codes[0], codes[1]);
}

So, on the 32 bits case, we'll do about 4 billions calls to EVIOGKEYCODE ioctl to
read the complete scancode space, to get those 50-500 useful codes.

Due to the current API limit, we don't have any way to use the full 64bits space for scancodes.

if we use code[0] as an index, this means that we'll need to share the 32 bits on code[1]
for scancode/keycode. Even using an 32 bits integer for keycode, it is currently limited to:

#define KEY_MAX                 0x2ff
#define KEY_CNT                 (KEY_MAX+1)

So, we have 10 bits already used for keycode. This gives only 22 bits for scancodes, if we share
codes[1] for both keycode/scancode. By sharing the 32 bits, we'll need to be care to not extend
KEY_MAX to be bigger than 0x3ff, otherwise the keytable won't be able to represent all keys of the
key universe.

What is need for this case is that the arguments for get key/set key to be something like:

struct {
	u16	index;
	u64	scancode;
	u32	keycode;
};

Eventually, if we want to be more careful about the number of bits for scancode, the better is to
think on some ways to allow extending the scancode universe, like using u64 scancode[2],
adding some reserved fields, or using a pair of size/pointer for the the scancode. 
In the latter case, we'll need to write some compat32 code for handling the pointer. Comments?

It should be noticed that just changing the number of bits at EVIO[G|S]KEYCODE will break
the kernel API. One alternative would be to just define a new pair of ioctls that allows
using more bits there.

Cheers,
Mauro
