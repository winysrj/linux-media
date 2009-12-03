Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbZLCSeS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 13:34:18 -0500
Date: Thu, 3 Dec 2009 16:33:28 -0200
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
Message-ID: <20091203163328.613699e5@pedra>
In-Reply-To: <20091203175531.GB776@core.coreip.homeip.net>
References: <BDodf9W1qgB@lirc>
	<4B14EDE3.5050201@redhat.com>
	<4B1524DD.3080708@redhat.com>
	<4B153617.8070608@redhat.com>
	<A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
	<4B17AA6A.9060702@redhat.com>
	<20091203175531.GB776@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let me draw my view:

Em Thu, 3 Dec 2009 09:55:31 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:

> No, please, wait just a minute. I know it is tempting to just merge
> lirc_dev and start working, but can we first agree on the overall
> subsystem structure before doing so. It is still quite inclear to me.
> 
> The open questions (for me at least):
> 
> - do we create a new class infrastructure for all receivers or only for
>   ones plugged into lirc_dev? Remember that classifying objects affects
>   how udev and friemds see them and may either help or hurt writing PnP
>   rules.

IMO, I would create it as /sys/class/input/IR (just like the /mice). I
don't see why do we need to different lirc than no-lirc drivers in the
case of sysfs class. As devices with raw input capabilities will have
another dev to communicate, this means that we'll need a /lirc node
there to point to lirc dev.

> 
> - do we intend to support in-kernel sotfware decoders?

Yes.

> - What is the structure? Do we organize them as a module to be used by driver
>   directly or the driver "streams" the data to IR core and the core
>   applies decoders (in the same fashion input events from drivers flow
>   into input core and then distributed to all bound interfaces for
>   processing/conversion/transmission to userspace)?

My plan is to expand ir-common.ko module and rename it to ir-core, to be 
the IR core module for the evdev interface. I'm already working on it. 
My idea for an architecture is that the lirc-core module will use 
ir-common where the IR decoders will be, and the evdev interface.

IMO, we should move them from /drivers/media/common to /drivers/input/ir.
It makes sense to use kfifo to send the data to the in-kernel decoders.

> - how do we control which decoder should handle particular
>   receiver/remote? Is it driver's decision, decoder's decision, user's
>   or all of the above?

It should be all the above, since some hardware will only work with certain
decoders (hardware limitation) or they may have already a raw mode->scancode
legacy decoder. In the latter case, those decoders will be removed from
the existing drivers, but this action will take some time.

Some sysfs attributes are needed to specify a list of the supported protocols
and the currently used one. I'll prepare a proposed patch for it, after we
finish aligning the requirements.
 
> - do we allow to have several decorers active at once for a receiver?

Yes, as an optional requirement, since some hardware won't support it.

> - who decides that we want to utilize lirc_dev? Driver's themselves, IR
>   core (looking at the driver/device "capabilities"), something else?

Drivers that support raw mode, should interface via lirc-core, that will,
in turn use ir-core.

Drivers that have in-hardware decode will directly use ir-core.

> - do we recognize and create input devices "on-fly" or require user
>   intervention? Semantics for splitting into several input/event
>   devices?

I don't have a strong opinion here. 

I don't see any way for doing it, except with very few protocols that
sends vendor IDs. I don't care if this feature can be used by the
drivers/decoders that could support it.

> Could anyone please draw me a picture, starting with a "receiver"
> piece of hardware. I am not concerned much with how exactly receiver is
> plugged into a particular subsystem (DVB/V4L etc) since it would be
> _their_ implementation detail, but with the flow in/out of that
> "receiver" device.

Not sure if I got your idea. Basically, what I see is:

	For device drivers that work in raw mode:
[IR physical device] ==> [IR receiver driver]  ==> [lirc-core] ==> [decoder] ==> [ir-core] ==> [evdev]

(eventually, we can merge decoder and ir-core into one module at the beginning,
depending on the size of the decoders)

	For device drivers that work only in evdev mode (those with hardware decoders):

[IR physical device] ==> [IR receiver driver]  ==> [ir-core] ==> [evdev]

> 
> Now as far as input core goes I see very limited number of changes that
> may be needed:
> 
> - Allow to extend size of "scancode" in EVIOC{S,G}KEYCODE if we are
>   unable to limit ourselves to 32 bits (keeping compatibility of course)

Yes, but the way EVIOC{S,G}KEYCODE currently works, it performs poorly when you have a
table with 2^64 size. The table is very sparsed, but, as the key to get/set a code is
the scancode, it is very hard to enumberate what are the actual entries there. The
better is to use an index parameter for they, instead of using the scancode as such.

> - Maybe adding new ioctl to "zap" the keymap table

Yes, this is needed.

> - Adding more key EV_KEY/KEY_* definitons, if needed

Probably.

-- 

Cheers,
Mauro
