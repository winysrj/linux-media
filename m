Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:33551 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757547AbZLFUTD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 15:19:03 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>
	<4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>
	<A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
	<4B17AA6A.9060702@redhat.com>
	<20091203175531.GB776@core.coreip.homeip.net>
	<20091203163328.613699e5@pedra>
	<20091204100642.GD22570@core.coreip.homeip.net>
	<20091204121234.5144836b@pedra>
	<20091206070929.GB14651@core.coreip.homeip.net>
	<4B1B8F83.5080009@redhat.com>
Date: Sun, 06 Dec 2009 21:19:06 +0100
In-Reply-To: <4B1B8F83.5080009@redhat.com> (Mauro Carvalho Chehab's message of
	"Sun, 06 Dec 2009 09:03:31 -0200")
Message-ID: <m31vj77t51.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> All the IR's I found with V4L/DVB use up to 16 bits code (or 24 bits, for NEC extended protocol).
> However, currently, the drivers were getting only 7 bits, due to the old way to implement
> EVIO[S|G]KEYCODE. 
>
> I know, however, one i2c chip that returns a 5 byte scancode when you press a key. 
> We're currently just discarding the remaining bits, so I'm not really sure what's there.

Right. This will have to be investigated by owners of the exact hardware
in question. What we can do is to try to make it easy for them.
There is no hurry, though - it can and will continue to work the current
way.

> In general, the scancode contains 8 or 16 bits for address, and 8 bits for command.

Right. I think the kernel shouldn't differentiate between address and
command too much.

> at include/linux/input.h, we'll add a code like:
>
> struct input_keytable_entry {
>  	u16	index;
>  	u64	scancode;
>  	u32	keycode;
> } __attribute__ ((packed));
>
> (the attribute packed avoids needing a compat for 64 bits)

Maybe { u64 scancode; u32 keycode; u16 index; u16 reserved } would be a
bit better, no alignment problems and we could eventually change
"reserved" into something useful.

But I think, if we are going to redesign it, we better use scancodes of
arbitrary length (e.g. protocol-dependent length). It should be opaque
except for the protocol handler.
-- 
Krzysztof Halasa
