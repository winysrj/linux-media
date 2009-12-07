Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbZLGPeg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 10:34:36 -0500
Message-ID: <4B1D2072.4020003@redhat.com>
Date: Mon, 07 Dec 2009 13:34:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com> <20091203175531.GB776@core.coreip.homeip.net> <20091203163328.613699e5@pedra> <20091204100642.GD22570@core.coreip.homeip.net> <20091204121234.5144836b@pedra> <20091206070929.GB14651@core.coreip.homeip.net> <4B1B8F83.5080009@redhat.com> <20091207074818.GA24958@core.coreip.homeip.net>
In-Reply-To: <20091207074818.GA24958@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Sun, Dec 06, 2009 at 09:03:31AM -0200, Mauro Carvalho Chehab wrote:
>> Dmitry Torokhov wrote:
>>> On Fri, Dec 04, 2009 at 12:12:34PM -0200, Mauro Carvalho Chehab wrote:
>>>> Em Fri, 4 Dec 2009 02:06:42 -0800
>>>> Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:
>>>>
>>>>> evdev does not really care what you use as scancode. So nobody stops
>>>>> your driver to report index as a scancode and accept index from the
>>>>> ioctl. The true "scancode" will thus be competely hidden from userspace.
>>>>> In fact a few drivers do just that.
>>>> Let me better express here. It is all about how we'll expand the limits of those
>>>> ioctls to fulfill the needs.
>>>>
>>>> The point is that we'll have, let's say something like to 50-500 scancode/keycode tuples
>>>> sparsely spread into a 2^64 scancode universe (assuming 64 bits - Not sure if is there any
>>>> IR protocol/code with a bigger scancode).
>>>>
>>>> On such universe if we want to get all keycodes with the current ioctls for a scancode in
>>>> the range of 32 bits, we need to do something like:
>>>>
>>>> u32 code;
>>>> int codes[2];
>>>> for (code = 0; code <= (unsigned u32) - 1; code++) {
>>>> 	codes[0] = (int)code;
>>>> 	if (!ioctl(fd, EVIOCGKEYCODE, codes))
>>>> 		printf("scancode 0x%08x = keycode 0x%08x\n", codes[0], codes[1]);
>>>> }
>>>>
>>>> So, on the 32 bits case, we'll do about 4 billions calls to EVIOGKEYCODE ioctl to
>>>> read the complete scancode space, to get those 50-500 useful codes.
>>>>
>>> Right, currently there is no need to query all scancodes defined by
>>> device. Quite often drivers don't even know what scancodes device
>>> actually generates (ex AT keyboard).
>>>
>>> Could you describe in more detail how you are using this data?
>> It is useful if you want to dump the keycode maps into file with the current
>> scancode attribution, in order to modify some keystrokes.
>>
>> Right now, programs like dumpkeys (from kbd package) allow you to dump for example
>> the attribution keys from your keyboard.
>>
>> In the case of IR's this functionality is very important.
>>
>> For example, you may need to replace the scancode/KEY_CHANNELUP tuple by scancode/KEY_UP,
>> in order to make your IR to work with some applications that don't recognize the IR
>> specific keycodes.
>>
>> In practice, with such applications, you'll need to replace several different scancodes.
>>
>> So, you may end by having different scancodes producing the same keycode, as such applications
>> aren't capable of differentiating an UP key from a CHANNELUP key. This is the case, for example
>> of the popular tvtime application.
>>
>> The better way is to just generate a dump file, modify the needed entries and reload the
>> table by calling EVIOSKEYCODE, in order to use the new table.
>>
>> I wrote a small application that just do the above, and I use to load some special tables
>> to work with some applications like tvtime and mplayer. (with mplayer, you need to map 
>> <channel down> as KEY_H and <channel up> as KEY_K).
>>
>> I hope that, after we finish addressing IR's, we'll finally have media applications handling
>> directly the proper keycodes, but people may still need to write different keycodes to do
>> other things. I used to have a keymap file in order to use an IR to control the slide show
>> with openoffice.
>>
>>>> Due to the current API limit, we don't have any way to use the full 64bits space for scancodes.
>>>>
>>> Can we probably reduce the "scancode" space? ARe all 64 bits in
>>> protocols used to represent keypresses or some are used for some kind of
>>> addressing?
>> All the IR's I found with V4L/DVB use up to 16 bits code (or 24 bits, for NEC extended protocol).
>> However, currently, the drivers were getting only 7 bits, due to the old way to implement
>> EVIO[S|G]KEYCODE. 
>>
>> I know, however, one i2c chip that returns a 5 byte scancode when you press a key. 
>> We're currently just discarding the remaining bits, so I'm not really sure what's there.
>>
>>
>> The usage of 7 bits, in practice, were meaning that it weren't possible to use
>> a different remote than the one provided by the device manufacturer, as the scancodes produced
>> by other remotes differ on more than 7 bits. Also, this means that, if your TV and your PC
>> are using the same protocol, like RC5, if you press a button on your TV remote, the PC will
>> also get it.
>>
>> I know, however, one IR driver that produces 6 bytes when you press a key. 
>> We're currently just discarding the remaining bits, so I'm not really sure
>> what else is there. Some badly optimized protocol? a bigger scancode? a protocol indication?
>>
>> In general, the scancode contains 8 or 16 bits for address, and 8 bits for command.
>>
>> However, the scancode table needs to handle the address as well, since we don't want that a
>> scancode meant to go to your TV to be handled by the PC, but we may want to get codes from
>> different addresses there, as we may need to use the address to differentiate the commands
>> meant to control the TV volume, for example, than the same command meant to control the PC
>> master volume.
> 
> Right, but this data is not interesting to userspace. For userpsace
> scancode is just a cookie that is uniquely identifies a button for which
> a keycode can be assigned.
> 
>>>> if we use code[0] as an index, this means that we'll need to share the 32 bits on code[1]
>>>> for scancode/keycode. Even using an 32 bits integer for keycode, it is currently limited to:
>>>>
>>>> #define KEY_MAX                 0x2ff
>>>> #define KEY_CNT                 (KEY_MAX+1)
>>>>
>>>> So, we have 10 bits already used for keycode. This gives only 22 bits for scancodes, if we share
>>>> codes[1] for both keycode/scancode. By sharing the 32 bits, we'll need to be care to not extend
>>>> KEY_MAX to be bigger than 0x3ff, otherwise the keytable won't be able to represent all keys of the
>>>> key universe.
>>>>
>>>> What is need for this case is that the arguments for get key/set key to be something like:
>>>>
>>>> struct {
>>>> 	u16	index;
>>>> 	u64	scancode;
>>>> 	u32	keycode;
>>>> };
>>>>
>>> Hmm, so what is this index? I am confused...
>> It is the sequence number of a scancode/keycode tuple stored at the keycode table.
>>
>> Better than saying it in words, let me put a code snippet:
>>
>> at include/linux/input.h, we'll add a code like:
>>
>> struct input_keytable_entry {
>>  	u16	index;
>>  	u64	scancode;
>>  	u32	keycode;
>> } __attribute__ ((packed));
>>
>> (the attribute packed avoids needing a compat for 64 bits)
>>
>> #define EVIOGKEYCODEENTRY _IOR('E', 0x85, struct input_keytable_entry)
>>
>> (and a similar ioctl for setkeycode)
>>
>> This struct will be used by the new 
>>
>> at include/media/ir-common.h, we already have:
>>
>> struct ir_scancode {
>>         u16     scancode;
>>         u32     keycode;
>> };
>>
>> struct ir_scancode_table {
>>         struct ir_scancode *scan;
>>         int size;
>> 	...
>> };
>>
>> The code at ir core that will handle the ioctl will be like:
>>
>> static int ir_getkeycode_entry(struct input_dev *dev, struct input_keytable_entry *ike)
>> {
>> 	struct ir_scancode_table *rc_tab = input_get_drvdata(dev);
>>
>> 	if (rc_tab->size >= ike->index)
>> 		return -EINVAL;
>>
>> 	irk->scancode = rctab->scan->scancode;
>> 	irk->keycode = rctab->scan->keycode;
>> 	
>> 	return 0;
>> }
>>
> 
> OK, but why do you even want to expose scancode to userpsace using
> evdev here? Lircd-type applications might be interested, but they are
> going to use lircd. For the rest of userpsace index can be used as a
> "scancode" just as easily.

This is needed in order to load a keytable by udev, even for devices that
won't provide a lirc_dev interface.
 
> Scancodes in input system never been real scancodes. Even if you look
> into atkbd it uses some synthetic data composed out of real scancodes
> sent to the keyboard, and noone cares. If you are unsatisfied with
> mapping you fire up evtest, press the key, take whatever the driver
> [mis]represents as a scancode and use it to load the new definition. And
> you don't care at all whether the thing that driver calls cancode makes
> any sense to the hardware device.

We used a mis-represented scancode, but this proofed to be a broken design
along the time.

For users, whatever the scancode "cookie" means, the same IR device should
provide the same "cookie" no matter what IR receiver is used, since the same
IR may be found on different devices, or the user can simply buy a new card
and opt to use their old IR (there are very good reasons for that, since
several new devices are now coming with small IR's that has half of the
keys of the ones available at the older models).

To allow that, the userspace should allow a completely override of the scancode
table by a new table, the driver should support not only replacing the keycodes,
but also replacing the scancodes. 

Also, the same IR physical device may be provided by a wide range of different 
boards, so the scancode should be portable between all drivers.

The solution of using a mis-represented scancode is currently used by V4L drivers,
and we're getting rid of that, since this won't allow replacing the IR keytable
by the keytable from another IR.

Just as an example, I've committed one patch yesterday that replaces the old
mis-represented scancode table for the Hauppauge Grey IR by the correct one, for
one device I have here (WinTV USB2):

	http://linuxtv.org/hg/v4l-dvb/rev/6ec717e42b4a

After this patch, both WinTV USB2 and HVR-950 devices will use the same scancode
representation, also used by a completely different driver (dib0700).

After the patch, both devices can now support other IR's that generates keycodes
using RC-5 protocol, and the bits are represented on both following the RC-5 specs.

So, for both devices, the same IR keycode table for Hauppauge Grey IR will work
perfectly with both devices.

Also, I can now replace the IR table to accept for example, a PC-39 [1] IR I have here.
	[1] http://www.cwtek.com.tw/product-en.php?layer1=6&layer2=37&lang=en

(this site is interesting: it shows several different types of IR manufactured by a 
Chinese company that are commonly found bundled with cheap media devices - I've got
several cases of devices that used to be shipped with one type to be replaced by
another type on a newer device, with the same PCI/USB ID's).

The PC-39 IR generates a completely different set of scancodes. For example, on this IR,
the scancode 0x083a for <Picture> key. With the original IR, the scancode for <Pictures>
is the scancode 0x1e1a.

After the patch, the same PC-39 IR table works with both WinTV USB2 and HVR-950.

Before it, we're using the Hauppauge new scancode table masked by a 0xff mask. So,
instead of getting 0x1e00 + command, the table has just command).

By not using the complete scancode, this means that the driver will need to
accept only codes that matches (scancode & 0x1e00) == 0x1e00, or that it
will accept any scancode & 0xff.

With the first case, you can't replace the IR by another manufacturer. With
the latter case, if you use your TV RC5 remote, your PC will miss-recognize the
scancode.

So, on both cases, evdev interface will be taking undesired actions.

The V4L drivers had this broken behavior for a long time, causing lots of
complaints, and, in practice, limiting the driver to use just the provided IR's,
or preventing the usage of a PC close to a TV.

So, we're migrating the drivers to get a full scancode table there. This is
needed for users that use evdev.

So, while I agree that, in thesis, we might just use any arbitrary representation
for scancode, by just discarding information, the practice already proofed that 
such design won't work.

In summary,

While the current EVIO[G|S]KEYCODE works sub-optimally for scancodes up to 16 bytes
(since a read loop for 2^16 is not that expensive), the current approach
won't scale with bigger scancode spaces. So, it is needed expand it
to work with bigger scancode spaces, used by more recent IR protocols.

I'm afraid that any tricks we may try to go around the current limits to still
keep using the same ioctl definition will sooner or later cause big headaches.
The better is to redesign it to allow using different scancode spaces.

Cheers,
Mauro.
