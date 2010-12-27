Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:40287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0L0Qvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:51:52 -0500
Message-ID: <4D18C413.3020300@infradead.org>
Date: Mon, 27 Dec 2010 14:51:31 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: David Henningsson <david.henningsson@canonical.com>
CC: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] DVB: TechnoTrend CT-3650 IR support
References: <4D170785.1070306@canonical.com> <4D1729DB.80406@infradead.org> <4D17999E.4000500@canonical.com> <4D18623C.8080006@infradead.org> <4D18B6AC.2040506@canonical.com>
In-Reply-To: <4D18B6AC.2040506@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 27-12-2010 13:54, David Henningsson escreveu:
> On 2010-12-27 10:54, Mauro Carvalho Chehab wrote:
>> Em 26-12-2010 17:38, David Henningsson escreveu:
>>> On 2010-12-26 12:41, Mauro Carvalho Chehab wrote:

>>> +/* command to poll IR receiver (copied from pctv452e.c) */
>>> +#define CMD_GET_IR_CODE     0x1b
>>> +
>>> +/* IR */
>>> +static int tt3650_rc_query(struct dvb_usb_device *d)
>>> +{
>>> +    int ret;
>>> +    u8 rx[9]; /* A CMD_GET_IR_CODE reply is 9 bytes long */
>>> +    ret = ttusb2_msg(d, CMD_GET_IR_CODE, NULL, 0, rx, sizeof(rx));
>>> +    if (ret != 0)
>>> +        return ret;
>>> +
>>> +    if (rx[8]&  0x01) {
>>
>> Maybe (rx[8]&  0x01) == 0 indicates a keyup event. If so, if you map both keydown
>> and keyup events, the in-kernel repeat logic will work.
> 
> Hmm. If I should fix keyup events, the most reliable version would probably be something like:
> 
> if (rx[8] & 0x01) {
>   int currentkey = rx[2]; // or (rx[3]<<  8) | rx[2];
>   if (currentkey == lastkey)
>     rc_repeat(lastkey);
>   else {
>     if (lastkey)
>       rc_keyup(lastkey);
>     lastkey = currentkey;
>     rc_keydown(currentkey);
>   }

rc_keydown() already handles repeat events (see ir_do_keydown and rc_keydown, at
rc-main.c), so, you don't need it.

> }
> else if (lastkey) {
>   rc_keyup(lastkey);
>   lastkey = 0;
> }

Yeah, this makes sense, if bit 1 of rx[8] indicates keyup/keydown or repeat.

You need to double check if you are not receiving any packet with this bit unset,
when you press and hold a key, as some devices use a bit to just indicate that
the info there is valid or not (a "done" bit).

> 
> Does this sound reasonable to you?
> 
>>
>>> +        /* got a "press" event */
>>> +        deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
>>> +        rc_keydown(d->rc_dev, rx[2], 0);
>>> +    }
>>
>> As you're receiving both command+address, please use the complete code:
>>     rc_keydown(d->rc_dev, (rx[3]<<  8) | rx[2], 0);
> 
> I've tried this, but it stops working. evtest shows only scancode events, so my guess is that this makes it incompatible with RC_MAP_TT_1500, which lists only the lower byte.

yeah, you'll need either to create another table or to fix it. The better is to fix
the table and to use .scanmask = 0xff at the old drivers. This way, the same table
will work for both the legacy/incomplete get_scancode function and for the new one.

>> Also as it is receiving 8 bytes from the device, maybe the IR decoding logic is
>> capable of decoding more than just one protocol. Such feature is nice, as it
>> allows replacing the original keycode table by a more complete one.
> 
> I've tried dumping all nine bytes but I can't make much out of it as I'm unfamiliar with RC protocols and decoders.
> 
> Typical reply is (no key pressed):
> 
> cc 35 0b 15 00 03 00 00 00
> 
> Does this tell you anything?

This means nothing to me, but the only way to double check is to test the device
with other remote controllers. On several hardware, it is possible to use
RC5 remote controllers as well. As there are some empty (zero) fields, maybe
this device also supports RC6 protocols (that have more than 16 bits) and
NEC extended (24 bits or 32 bits, on a few variants).

>> One of the most interesting features of the new RC code is that it offers
>> a sysfs class and some additional logic to allow dynamically change/replace
>> the keymaps and keycodes via userspace. The idea is to remove all in-kernel
>> keymaps in the future, using, instead, the userspace way, via ir-keytable
>> tool, available at:
>>     http://git.linuxtv.org/v4l-utils.git
>>
>> The tool already supports auto-loading the keymap via udev.
>>
>> For IR's where we don't know the protocol or that we don't have the full scancode,
>> loading the keymap via userspace will not bring any new feature. But, for those
>> devices where we can be sure about the protocol and for those that also allow
>> using other protocols, users can just replace the device-provided IR with a more
>> powerful remote controller with more keys.
> 
> Yeah, that sounds like a really nice feature.
> 
>> So, it would be wonderful if you could identify what's the supported protocol(s)
>> instead of using RC_TYPE_UNKNOWN. You can double check the protocol if you have
>> with you another RC device that supports raw decoding. The rc-core internal decoders
>> will tell you what protocol was used to decode a keycode, if you enable debug.
> 
> I don't have any such RC receiver device. I do have a Logitech Harmony 525, so I tried pointing that one towards the CT 3650, but CMD_GET_IR_CODE didn't change for any of the devices I've currently told my Harmony to emulate.
> 
> So I don't really see how I can help further in this case?
> 

I don't have a Logitech Harmony, so I'm not sure about it. Maybe Jarod may have some
info about it.

Cheers,
Mauro
