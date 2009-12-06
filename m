Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53796 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZLFHJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 02:09:28 -0500
Date: Sat, 5 Dec 2009 23:09:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091206070929.GB14651@core.coreip.homeip.net>
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com> <20091203175531.GB776@core.coreip.homeip.net> <20091203163328.613699e5@pedra> <20091204100642.GD22570@core.coreip.homeip.net> <20091204121234.5144836b@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204121234.5144836b@pedra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 04, 2009 at 12:12:34PM -0200, Mauro Carvalho Chehab wrote:
> Em Fri, 4 Dec 2009 02:06:42 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:
> 
> > > 
> > 
> > evdev does not really care what you use as scancode. So nobody stops
> > your driver to report index as a scancode and accept index from the
> > ioctl. The true "scancode" will thus be competely hidden from userspace.
> > In fact a few drivers do just that.
> 
> Let me better express here. It is all about how we'll expand the limits of those
> ioctls to fulfill the needs.
> 
> The point is that we'll have, let's say something like to 50-500 scancode/keycode tuples
> sparsely spread into a 2^64 scancode universe (assuming 64 bits - Not sure if is there any
> IR protocol/code with a bigger scancode).
> 
> On such universe if we want to get all keycodes with the current ioctls for a scancode in
> the range of 32 bits, we need to do something like:
> 
> u32 code;
> int codes[2];
> for (code = 0; code <= (unsigned u32) - 1; code++) {
> 	codes[0] = (int)code;
> 	if (!ioctl(fd, EVIOCGKEYCODE, codes))
> 		printf("scancode 0x%08x = keycode 0x%08x\n", codes[0], codes[1]);
> }
> 
> So, on the 32 bits case, we'll do about 4 billions calls to EVIOGKEYCODE ioctl to
> read the complete scancode space, to get those 50-500 useful codes.
>

Right, currently there is no need to query all scancodes defined by
device. Quite often drivers don't even know what scancodes device
actually generates (ex AT keyboard).

Could you describe in more detail how you are using this data?

> 
> Due to the current API limit, we don't have any way to use the full 64bits space for scancodes.
> 

Can we probably reduce the "scancode" space? ARe all 64 bits in
protocols used to represent keypresses or some are used for some kind of
addressing?

> if we use code[0] as an index, this means that we'll need to share the 32 bits on code[1]
> for scancode/keycode. Even using an 32 bits integer for keycode, it is currently limited to:
> 
> #define KEY_MAX                 0x2ff
> #define KEY_CNT                 (KEY_MAX+1)
> 
> So, we have 10 bits already used for keycode. This gives only 22 bits for scancodes, if we share
> codes[1] for both keycode/scancode. By sharing the 32 bits, we'll need to be care to not extend
> KEY_MAX to be bigger than 0x3ff, otherwise the keytable won't be able to represent all keys of the
> key universe.
> 
> What is need for this case is that the arguments for get key/set key to be something like:
> 
> struct {
> 	u16	index;
> 	u64	scancode;
> 	u32	keycode;
> };
> 

Hmm, so what is this index? I am confused...

Thanks.

-- 
Dmitry
