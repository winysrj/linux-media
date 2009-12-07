Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63492 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbZLGHsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 02:48:24 -0500
Date: Sun, 6 Dec 2009 23:48:18 -0800
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
Message-ID: <20091207074818.GA24958@core.coreip.homeip.net>
References: <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com> <20091203175531.GB776@core.coreip.homeip.net> <20091203163328.613699e5@pedra> <20091204100642.GD22570@core.coreip.homeip.net> <20091204121234.5144836b@pedra> <20091206070929.GB14651@core.coreip.homeip.net> <4B1B8F83.5080009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1B8F83.5080009@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 06, 2009 at 09:03:31AM -0200, Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
> > On Fri, Dec 04, 2009 at 12:12:34PM -0200, Mauro Carvalho Chehab wrote:
> >> Em Fri, 4 Dec 2009 02:06:42 -0800
> >> Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:
> >>
> >>> evdev does not really care what you use as scancode. So nobody stops
> >>> your driver to report index as a scancode and accept index from the
> >>> ioctl. The true "scancode" will thus be competely hidden from userspace.
> >>> In fact a few drivers do just that.
> >> Let me better express here. It is all about how we'll expand the limits of those
> >> ioctls to fulfill the needs.
> >>
> >> The point is that we'll have, let's say something like to 50-500 scancode/keycode tuples
> >> sparsely spread into a 2^64 scancode universe (assuming 64 bits - Not sure if is there any
> >> IR protocol/code with a bigger scancode).
> >>
> >> On such universe if we want to get all keycodes with the current ioctls for a scancode in
> >> the range of 32 bits, we need to do something like:
> >>
> >> u32 code;
> >> int codes[2];
> >> for (code = 0; code <= (unsigned u32) - 1; code++) {
> >> 	codes[0] = (int)code;
> >> 	if (!ioctl(fd, EVIOCGKEYCODE, codes))
> >> 		printf("scancode 0x%08x = keycode 0x%08x\n", codes[0], codes[1]);
> >> }
> >>
> >> So, on the 32 bits case, we'll do about 4 billions calls to EVIOGKEYCODE ioctl to
> >> read the complete scancode space, to get those 50-500 useful codes.
> >>
> > 
> > Right, currently there is no need to query all scancodes defined by
> > device. Quite often drivers don't even know what scancodes device
> > actually generates (ex AT keyboard).
> > 
> > Could you describe in more detail how you are using this data?
> 
> It is useful if you want to dump the keycode maps into file with the current
> scancode attribution, in order to modify some keystrokes.
> 
> Right now, programs like dumpkeys (from kbd package) allow you to dump for example
> the attribution keys from your keyboard.
> 
> In the case of IR's this functionality is very important.
> 
> For example, you may need to replace the scancode/KEY_CHANNELUP tuple by scancode/KEY_UP,
> in order to make your IR to work with some applications that don't recognize the IR
> specific keycodes.
> 
> In practice, with such applications, you'll need to replace several different scancodes.
> 
> So, you may end by having different scancodes producing the same keycode, as such applications
> aren't capable of differentiating an UP key from a CHANNELUP key. This is the case, for example
> of the popular tvtime application.
> 
> The better way is to just generate a dump file, modify the needed entries and reload the
> table by calling EVIOSKEYCODE, in order to use the new table.
> 
> I wrote a small application that just do the above, and I use to load some special tables
> to work with some applications like tvtime and mplayer. (with mplayer, you need to map 
> <channel down> as KEY_H and <channel up> as KEY_K).
> 
> I hope that, after we finish addressing IR's, we'll finally have media applications handling
> directly the proper keycodes, but people may still need to write different keycodes to do
> other things. I used to have a keymap file in order to use an IR to control the slide show
> with openoffice.
> 
> >> Due to the current API limit, we don't have any way to use the full 64bits space for scancodes.
> >>
> > 
> > Can we probably reduce the "scancode" space? ARe all 64 bits in
> > protocols used to represent keypresses or some are used for some kind of
> > addressing?
> 
> All the IR's I found with V4L/DVB use up to 16 bits code (or 24 bits, for NEC extended protocol).
> However, currently, the drivers were getting only 7 bits, due to the old way to implement
> EVIO[S|G]KEYCODE. 
> 
> I know, however, one i2c chip that returns a 5 byte scancode when you press a key. 
> We're currently just discarding the remaining bits, so I'm not really sure what's there.
> 
> 
> The usage of 7 bits, in practice, were meaning that it weren't possible to use
> a different remote than the one provided by the device manufacturer, as the scancodes produced
> by other remotes differ on more than 7 bits. Also, this means that, if your TV and your PC
> are using the same protocol, like RC5, if you press a button on your TV remote, the PC will
> also get it.
> 
> I know, however, one IR driver that produces 6 bytes when you press a key. 
> We're currently just discarding the remaining bits, so I'm not really sure
> what else is there. Some badly optimized protocol? a bigger scancode? a protocol indication?
> 
> In general, the scancode contains 8 or 16 bits for address, and 8 bits for command.
> 
> However, the scancode table needs to handle the address as well, since we don't want that a
> scancode meant to go to your TV to be handled by the PC, but we may want to get codes from
> different addresses there, as we may need to use the address to differentiate the commands
> meant to control the TV volume, for example, than the same command meant to control the PC
> master volume.

Right, but this data is not interesting to userspace. For userpsace
scancode is just a cookie that is uniquely identifies a button for which
a keycode can be assigned.

> 
> >> if we use code[0] as an index, this means that we'll need to share the 32 bits on code[1]
> >> for scancode/keycode. Even using an 32 bits integer for keycode, it is currently limited to:
> >>
> >> #define KEY_MAX                 0x2ff
> >> #define KEY_CNT                 (KEY_MAX+1)
> >>
> >> So, we have 10 bits already used for keycode. This gives only 22 bits for scancodes, if we share
> >> codes[1] for both keycode/scancode. By sharing the 32 bits, we'll need to be care to not extend
> >> KEY_MAX to be bigger than 0x3ff, otherwise the keytable won't be able to represent all keys of the
> >> key universe.
> >>
> >> What is need for this case is that the arguments for get key/set key to be something like:
> >>
> >> struct {
> >> 	u16	index;
> >> 	u64	scancode;
> >> 	u32	keycode;
> >> };
> >>
> > 
> > Hmm, so what is this index? I am confused...
> 
> It is the sequence number of a scancode/keycode tuple stored at the keycode table.
> 
> Better than saying it in words, let me put a code snippet:
> 
> at include/linux/input.h, we'll add a code like:
> 
> struct input_keytable_entry {
>  	u16	index;
>  	u64	scancode;
>  	u32	keycode;
> } __attribute__ ((packed));
> 
> (the attribute packed avoids needing a compat for 64 bits)
> 
> #define EVIOGKEYCODEENTRY _IOR('E', 0x85, struct input_keytable_entry)
> 
> (and a similar ioctl for setkeycode)
> 
> This struct will be used by the new 
> 
> at include/media/ir-common.h, we already have:
> 
> struct ir_scancode {
>         u16     scancode;
>         u32     keycode;
> };
> 
> struct ir_scancode_table {
>         struct ir_scancode *scan;
>         int size;
> 	...
> };
> 
> The code at ir core that will handle the ioctl will be like:
> 
> static int ir_getkeycode_entry(struct input_dev *dev, struct input_keytable_entry *ike)
> {
> 	struct ir_scancode_table *rc_tab = input_get_drvdata(dev);
> 
> 	if (rc_tab->size >= ike->index)
> 		return -EINVAL;
> 
> 	irk->scancode = rctab->scan->scancode;
> 	irk->keycode = rctab->scan->keycode;
> 	
> 	return 0;
> }
>

OK, but why do you even want to expose scancode to userpsace using
evdev here? Lircd-type applications might be interested, but they are
going to use lircd. For the rest of userpsace index can be used as a
"scancode" just as easily.

Scancodes in input system never been real scancodes. Even if you look
into atkbd it uses some synthetic data composed out of real scancodes
sent to the keyboard, and noone cares. If you are unsatisfied with
mapping you fire up evtest, press the key, take whatever the driver
[mis]represents as a scancode and use it to load the new definition. And
you don't care at all whether the thing that driver calls cancode makes
any sense to the hardware device.

-- 
Dmitry
