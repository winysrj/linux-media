Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:35990 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753570AbdGJIkR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 04:40:17 -0400
Subject: Re: Trying to use IR driver for my SoC
To: Sean Young <sean@mess.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
 <20170629155557.GA12980@gofer.mess.org>
 <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
 <20170629175037.GA14390@gofer.mess.org>
 <204a429c-b886-63a7-4d59-522864f05030@free.fr>
 <20170629194405.GA15901@gofer.mess.org>
From: Mason <slash.tmp@free.fr>
Message-ID: <0e2089ae-23cf-33fc-7c3d-68b7ab43ef57@free.fr>
Date: Mon, 10 Jul 2017 10:40:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170629194405.GA15901@gofer.mess.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/06/2017 21:44, Sean Young wrote:

> On Thu, Jun 29, 2017 at 09:12:48PM +0200, Mason wrote:
>
>> On 29/06/2017 19:50, Sean Young wrote:
>>
>>> On Thu, Jun 29, 2017 at 06:25:55PM +0200, Mason wrote:
>>>
>>>> $ ir-keytable -v -t
>>>> Found device /sys/class/rc/rc0/
>>>> Input sysfs node is /sys/class/rc/rc0/input0/
>>>> Event sysfs node is /sys/class/rc/rc0/input0/event0/
>>>> Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
>>>> /sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
>>>> /sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
>>>> /sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
>>>> Parsing uevent /sys/class/rc/rc0/uevent
>>>> /sys/class/rc/rc0/uevent uevent NAME=rc-empty
>>>> input device is /dev/input/event0
>>>> /sys/class/rc/rc0/protocols protocol rc-5 (disabled)
>>>> /sys/class/rc/rc0/protocols protocol nec (disabled)
>>>> /sys/class/rc/rc0/protocols protocol rc-6 (disabled)
>>
>> I had overlooked this. Is it expected for these protocols
>> to be marked as "disabled"?
> 
> Ah, good point, I forgot about that. :/
> 
> "ir-keytable -p all -t -v" should enable all protocols and test.

After hours of thrashing around, I finally figured out that
the IRQ was misconfigured... Doh!

Here's the output from pressing '1' for one second on the RC:

# cat /dev/input/event0 | hexdump -vC
00000000  04 04 00 00 7a 08 07 00  04 00 04 00 41 cb 04 00  |....z.......A...|
00000010  04 04 00 00 7a 08 07 00  00 00 00 00 00 00 00 00  |....z...........|
00000020  04 04 00 00 f4 da 07 00  04 00 04 00 00 00 00 00  |................|
00000030  04 04 00 00 f4 da 07 00  00 00 00 00 00 00 00 00  |................|
00000040  04 04 00 00 f1 7f 09 00  04 00 04 00 00 00 00 00  |................|
00000050  04 04 00 00 f1 7f 09 00  00 00 00 00 00 00 00 00  |................|
00000060  04 04 00 00 f2 24 0b 00  04 00 04 00 00 00 00 00  |.....$..........|
00000070  04 04 00 00 f2 24 0b 00  00 00 00 00 00 00 00 00  |.....$..........|
00000080  04 04 00 00 f3 c9 0c 00  04 00 04 00 00 00 00 00  |................|
00000090  04 04 00 00 f3 c9 0c 00  00 00 00 00 00 00 00 00  |................|
000000a0  04 04 00 00 f6 6e 0e 00  04 00 04 00 00 00 00 00  |.....n..........|
000000b0  04 04 00 00 f6 6e 0e 00  00 00 00 00 00 00 00 00  |.....n..........|
000000c0  05 04 00 00 ba d1 00 00  04 00 04 00 00 00 00 00  |................|
000000d0  05 04 00 00 ba d1 00 00  00 00 00 00 00 00 00 00  |................|
000000e0  05 04 00 00 bb 76 02 00  04 00 04 00 00 00 00 00  |.....v..........|
000000f0  05 04 00 00 bb 76 02 00  00 00 00 00 00 00 00 00  |.....v..........|
00000100  05 04 00 00 bd 1b 04 00  04 00 04 00 00 00 00 00  |................|
00000110  05 04 00 00 bd 1b 04 00  00 00 00 00 00 00 00 00  |................|
00000120  05 04 00 00 be c0 05 00  04 00 04 00 00 00 00 00  |................|
00000130  05 04 00 00 be c0 05 00  00 00 00 00 00 00 00 00  |................|
00000140  05 04 00 00 c2 65 07 00  04 00 04 00 00 00 00 00  |.....e..........|
00000150  05 04 00 00 c2 65 07 00  00 00 00 00 00 00 00 00  |.....e..........|

I'm not sure what these mean. There seems to be some kind of
timestamp? And something else? How do I tell which protocol
this RC is using?

Repeating the test (pressing '1' for one second) with ir-keytable:

# ir-keytable -p all -t -v
Found device /sys/class/rc/rc0/
Input sysfs node is /sys/class/rc/rc0/input0/
Event sysfs node is /sys/class/rc/rc0/input0/event0/
Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
/sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
/sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
/sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-empty
input device is /dev/input/event0
/sys/class/rc/rc0/protocols protocol rc-5 (disabled)
/sys/class/rc/rc0/protocols protocol nec (disabled)
/sys/class/rc/rc0/protocols protocol rc-6 (disabled)
Opening /dev/input/event0
Input Protocol version: 0x00010001
/sys/class/rc/rc0//protocols: Invalid argument
Couldn't change the IR protocols
Testing events. Please, press CTRL-C to abort.
1296.124872: event type EV_MSC(0x04): scancode = 0x4cb41
1296.124872: event type EV_SYN(0x00).
1296.178753: event type EV_MSC(0x04): scancode = 0x00
1296.178753: event type EV_SYN(0x00).
1296.286526: event type EV_MSC(0x04): scancode = 0x00
1296.286526: event type EV_SYN(0x00).
1296.394303: event type EV_MSC(0x04): scancode = 0x00
1296.394303: event type EV_SYN(0x00).
1296.502081: event type EV_MSC(0x04): scancode = 0x00
1296.502081: event type EV_SYN(0x00).
1296.609857: event type EV_MSC(0x04): scancode = 0x00
1296.609857: event type EV_SYN(0x00).
1296.717635: event type EV_MSC(0x04): scancode = 0x00
1296.717635: event type EV_SYN(0x00).
1296.825412: event type EV_MSC(0x04): scancode = 0x00
1296.825412: event type EV_SYN(0x00).
1296.933189: event type EV_MSC(0x04): scancode = 0x00
1296.933189: event type EV_SYN(0x00).
1297.040967: event type EV_MSC(0x04): scancode = 0x00
1297.040967: event type EV_SYN(0x00).
1297.148745: event type EV_MSC(0x04): scancode = 0x00
1297.148745: event type EV_SYN(0x00).
1297.256522: event type EV_MSC(0x04): scancode = 0x00
1297.256522: event type EV_SYN(0x00).

It looks like scancode 0x00 means "REPEAT" ?
And 0x4cb41 would be '1' then?

If I compile the legacy driver (which is much more cryptic)
it outputs 04 cb 41 be

So 0x4cb41 in common - plus a trailing 0xbe (what is that?
Some kind of checksum perhaps?)

(For '2', I get 04 cb 03 fc)

I'm a bit confused between "protocols", "decoders", "scancodes",
"keys", "keymaps". Is there some high-level doc somewhere?

I found this, but it seems to dive straight into API details:
https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/rc/remote_controllers.html

I'll start a separate thread to discuss the available IR hardware
on the board I'm using.

Regards.
