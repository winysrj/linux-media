Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53027 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756468AbdGKSgB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 14:36:01 -0400
Date: Tue, 11 Jul 2017 19:35:58 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Subject: Re: Trying to use IR driver for my SoC
Message-ID: <20170711183557.ir4h7nqx2rrr3mbf@gofer.mess.org>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
 <20170629155557.GA12980@gofer.mess.org>
 <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
 <20170629175037.GA14390@gofer.mess.org>
 <204a429c-b886-63a7-4d59-522864f05030@free.fr>
 <20170629194405.GA15901@gofer.mess.org>
 <0e2089ae-23cf-33fc-7c3d-68b7ab43ef57@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e2089ae-23cf-33fc-7c3d-68b7ab43ef57@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 10, 2017 at 10:40:04AM +0200, Mason wrote:
> On 29/06/2017 21:44, Sean Young wrote:
> 
> > On Thu, Jun 29, 2017 at 09:12:48PM +0200, Mason wrote:
> >
> >> On 29/06/2017 19:50, Sean Young wrote:
> >>
> >>> On Thu, Jun 29, 2017 at 06:25:55PM +0200, Mason wrote:
> >>>
> >>>> $ ir-keytable -v -t
> >>>> Found device /sys/class/rc/rc0/
> >>>> Input sysfs node is /sys/class/rc/rc0/input0/
> >>>> Event sysfs node is /sys/class/rc/rc0/input0/event0/
> >>>> Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
> >>>> /sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
> >>>> /sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
> >>>> /sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
> >>>> Parsing uevent /sys/class/rc/rc0/uevent
> >>>> /sys/class/rc/rc0/uevent uevent NAME=rc-empty
> >>>> input device is /dev/input/event0
> >>>> /sys/class/rc/rc0/protocols protocol rc-5 (disabled)
> >>>> /sys/class/rc/rc0/protocols protocol nec (disabled)
> >>>> /sys/class/rc/rc0/protocols protocol rc-6 (disabled)
> >>
> >> I had overlooked this. Is it expected for these protocols
> >> to be marked as "disabled"?
> > 
> > Ah, good point, I forgot about that. :/
> > 
> > "ir-keytable -p all -t -v" should enable all protocols and test.
> 
> After hours of thrashing around, I finally figured out that
> the IRQ was misconfigured... Doh!
> 
> Here's the output from pressing '1' for one second on the RC:
> 
> # cat /dev/input/event0 | hexdump -vC
> 00000000  04 04 00 00 7a 08 07 00  04 00 04 00 41 cb 04 00  |....z.......A...|
-snip-

It might be easier to use "ir-keytable -t" for this, or evtest. 

> I'm not sure what these mean. There seems to be some kind of
> timestamp? And something else?

You're reading "struct input_event" here, see the input api.

> How do I tell which protocol
> this RC is using?

That's an awkward question to answer. This is not passed to user space
at the moment, that's one of addition I want to make to the lirc user
space api in the near future.

For the moment I would suggest just putting printk() in your code when
you call rc_keydown().

> Repeating the test (pressing '1' for one second) with ir-keytable:
> 
> # ir-keytable -p all -t -v
> Found device /sys/class/rc/rc0/
> Input sysfs node is /sys/class/rc/rc0/input0/
> Event sysfs node is /sys/class/rc/rc0/input0/event0/
> Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
> /sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
> /sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
> /sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
> Parsing uevent /sys/class/rc/rc0/uevent
> /sys/class/rc/rc0/uevent uevent NAME=rc-empty
> input device is /dev/input/event0
> /sys/class/rc/rc0/protocols protocol rc-5 (disabled)
> /sys/class/rc/rc0/protocols protocol nec (disabled)
> /sys/class/rc/rc0/protocols protocol rc-6 (disabled)
> Opening /dev/input/event0
> Input Protocol version: 0x00010001
> /sys/class/rc/rc0//protocols: Invalid argument
> Couldn't change the IR protocols
> Testing events. Please, press CTRL-C to abort.
> 1296.124872: event type EV_MSC(0x04): scancode = 0x4cb41
> 1296.124872: event type EV_SYN(0x00).
> 1296.178753: event type EV_MSC(0x04): scancode = 0x00
> 1296.178753: event type EV_SYN(0x00).
> 1296.286526: event type EV_MSC(0x04): scancode = 0x00
> 1296.286526: event type EV_SYN(0x00).
> 1296.394303: event type EV_MSC(0x04): scancode = 0x00
> 1296.394303: event type EV_SYN(0x00).
> 1296.502081: event type EV_MSC(0x04): scancode = 0x00
> 1296.502081: event type EV_SYN(0x00).
> 1296.609857: event type EV_MSC(0x04): scancode = 0x00
> 1296.609857: event type EV_SYN(0x00).
> 1296.717635: event type EV_MSC(0x04): scancode = 0x00
> 1296.717635: event type EV_SYN(0x00).
> 1296.825412: event type EV_MSC(0x04): scancode = 0x00
> 1296.825412: event type EV_SYN(0x00).
> 1296.933189: event type EV_MSC(0x04): scancode = 0x00
> 1296.933189: event type EV_SYN(0x00).
> 1297.040967: event type EV_MSC(0x04): scancode = 0x00
> 1297.040967: event type EV_SYN(0x00).
> 1297.148745: event type EV_MSC(0x04): scancode = 0x00
> 1297.148745: event type EV_SYN(0x00).
> 1297.256522: event type EV_MSC(0x04): scancode = 0x00
> 1297.256522: event type EV_SYN(0x00).
> 
> It looks like scancode 0x00 means "REPEAT" ?

This looks like nec repeat to me; nec repeats are sent every 110ms;
however when a repeat occurs, the driver should call rc_repeat(),
sending a scancode of 0 won't work.

> And 0x4cb41 would be '1' then?
> 
> If I compile the legacy driver (which is much more cryptic)
> it outputs 04 cb 41 be

~0xbe = 0x41. The code in tangox_ir_handle_nec() has decoded this
into extended nec (so the driver should send RC_TYPE_NECX), see
https://github.com/mansr/linux-tangox/blob/master/drivers/media/rc/tangox-ir.c#L68

> So 0x4cb41 in common - plus a trailing 0xbe (what is that?
> Some kind of checksum perhaps?)

That's part of the nec protocol.

> (For '2', I get 04 cb 03 fc)

See http://www.sbprojects.com/knowledge/ir/nec.php

> I'm a bit confused between "protocols", "decoders", "scancodes",
> "keys", "keymaps". Is there some high-level doc somewhere?

I don't think there is. The infrared led is either on or off[1], so an 
IR message is a series of pulses and spaces (pulse for IR on, space for
IR absent). There are different protocols for encoding these IR messages,
e.g. nec, rc5. When they are decoded, you end up with a scancode 
(32 bit number). The keymap maps scancodes to keys, so in your case we
would want a keymap with:
scancode 0x4cb41 = KEY_1
scancode 0x4cb03 = KEY_2
etc.
Then KEY_1 will be reported to the input layer and you can use the
remote as you would expect.

The decoder can either be done in hardware (firmware?) and in software; 
in your case it is done in hardware.

[1] Ignoring the carrier for simplicity, that rarely matters.

> I found this, but it seems to dive straight into API details:
> https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/rc/remote_controllers.html
> 
> I'll start a separate thread to discuss the available IR hardware
> on the board I'm using.


Sean
