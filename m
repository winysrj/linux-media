Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36207 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbdBUNHK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 08:07:10 -0500
Received: by mail-wr0-f169.google.com with SMTP id 89so77133061wrr.3
        for <linux-media@vger.kernel.org>; Tue, 21 Feb 2017 05:07:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170220171309.GA26632@gofer.mess.org>
References: <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
 <20161127193510.GA20548@gofer.mess.org> <20161130090229.GB639@shambles.local>
 <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
 <20170202233533.GA14357@gofer.mess.org> <CAEsFdVMhbxb3d=_ugYjfYSCRZsQMhtt=kmsqX81x-6UjTYc-bg@mail.gmail.com>
 <20170204191050.GA31779@gofer.mess.org> <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
 <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
 <CAEsFdVOfGFJ9HYav2h0gNkpdhYzbnVxnPbOaZW+HpO3KE1S9-w@mail.gmail.com> <20170220171309.GA26632@gofer.mess.org>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Wed, 22 Feb 2017 00:07:07 +1100
Message-ID: <CAEsFdVNbmNZpYcst6wuDAVw4XS2eNBqwMwgx9LwfLZtY_jHhVA@mail.gmail.com>
Subject: Re: ir-keytable: infinite loops, segfaults
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/21/17, Sean Young <sean@mess.org> wrote:
> Hi Vincent,
>
...
>
> On the cxusb the protocol is now nec, and that is the only protocol it
> supports, you can't change it.
>

doh! ok well that's all good then.

>> $ sudo cat /sys/class/rc/rc1/protocols
>> nec
>> $ sudo sh
>> # echo "+rc-5 +nec +rc-6 +jvc +sony +rc-5-sz +sanyo +sharp +xmp" >
>> /sys/class/rc/rc1/protocols
>> bash: echo: write error: Invalid argument
>> # cat  /sys/class/rc/rc1/protocols
>> nec
>> In kern.log I got:
>> kernel: [ 2293.491534] rc_core: Normal protocol change requested
>> kernel: [ 2293.491538] rc_core: Protocol switching not supported
>>
>> # echo "+nec" > /sys/class/rc/rc1/protocols
>> bash: echo: write error: Invalid argument
>> kernel: [ 2390.832476] rc_core: Normal protocol change requested
>> kernel: [ 2390.832481] rc_core: Protocol switching not supported
>
> That is expected. Does the the keymap actually work?
>
> ir-keytable -r -t

Kind of important information, yes. Answer: not sure. I can see it
receiving something but none of the keys I pressed caused any reaction
on the application (mythtv)

# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
        Driver imon, table rc-imon-mce
        Supported protocols: rc-6
        Enabled protocols: rc-6
        Name: iMON Remote (15c2:ffdc)
        bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
        Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc1/ (/dev/input/event11) with:
        Driver dvb_usb_cxusb, table rc-dvico-mce
        Supported protocols: nec
        Enabled protocols:
        Name: IR-receiver inside an USB DVB re
        bus: 3, vendor/product: 0fe9:db78, version: 0x827b
        Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc2/ (/dev/input/event16) with:
        Driver dvb_usb_af9035, table rc-empty
        Supported protocols: nec
        Enabled protocols:
        Name: Leadtek WinFast DTV Dongle Dual
        bus: 3, vendor/product: 0413:6a05, version: 0x0200
        Repeat delay = 500 ms, repeat period = 125 ms

# ir-keytable -r -t -d /dev/input/event11
scancode 0xfe01 = KEY_R (0x13)
scancode 0xfe02 = KEY_TV (0x179)
scancode 0xfe03 = KEY_0 (0x0b)
scancode 0xfe05 = KEY_VOLUMEDOWN (0x72)
scancode 0xfe07 = KEY_4 (0x05)
scancode 0xfe09 = KEY_CHANNELDOWN (0x193)
scancode 0xfe0a = KEY_EPG (0x16d)
scancode 0xfe0b = KEY_1 (0x02)
scancode 0xfe0d = KEY_ESC (0x01)
scancode 0xfe0e = KEY_MP3 (0x187)
scancode 0xfe0f = KEY_PREVIOUSSONG (0xa5)
scancode 0xfe11 = KEY_CHANNELUP (0x192)
scancode 0xfe12 = KEY_NEXTSONG (0xa3)
scancode 0xfe13 = KEY_ANGLE (0x173)
scancode 0xfe15 = KEY_VOLUMEUP (0x73)
scancode 0xfe16 = KEY_SETUP (0x8d)
scancode 0xfe17 = KEY_2 (0x03)
scancode 0xfe19 = KEY_OPEN (0x86)
scancode 0xfe1a = KEY_DVD (0x185)
scancode 0xfe1b = KEY_3 (0x04)
scancode 0xfe1e = KEY_FAVORITES (0x16c)
scancode 0xfe1f = KEY_ZOOM (0x174)
scancode 0xfe42 = KEY_ENTER (0x1c)
scancode 0xfe43 = KEY_REWIND (0xa8)
scancode 0xfe46 = KEY_POWER2 (0x164)
scancode 0xfe47 = KEY_P (0x19)
scancode 0xfe48 = KEY_7 (0x08)
scancode 0xfe49 = KEY_ESC (0x01)
scancode 0xfe4c = KEY_8 (0x09)
scancode 0xfe4d = KEY_M (0x32)
scancode 0xfe4e = KEY_POWER (0x74)
scancode 0xfe4f = KEY_FASTFORWARD (0xd0)
scancode 0xfe50 = KEY_5 (0x06)
scancode 0xfe51 = KEY_UP (0x67)
scancode 0xfe52 = KEY_CAMERA (0xd4)
scancode 0xfe53 = KEY_DOWN (0x6c)
scancode 0xfe54 = KEY_6 (0x07)
scancode 0xfe55 = KEY_TAB (0x0f)
scancode 0xfe57 = KEY_MUTE (0x71)
scancode 0xfe58 = KEY_9 (0x0a)
scancode 0xfe59 = KEY_INFO (0x166)
scancode 0xfe5a = KEY_TUNER (0x182)
scancode 0xfe5b = KEY_LEFT (0x69)
scancode 0xfe5e = KEY_ENTER (0x1c)
scancode 0xfe5f = KEY_RIGHT (0x6a)
Enabled protocols: other sony nec sanyo mce-kbd rc-6 sharp xmp
Testing events. Please, press CTRL-C to abort.
  # pressed '1' key
1487676458.742329: event type EV_MSC(0x04): scancode = 0xffff010b
1487676458.742329: event type EV_SYN(0x00).
  # '2'
1487676481.742284: event type EV_MSC(0x04): scancode = 0xffff0117
1487676481.742284: event type EV_SYN(0x00).
  # '8'
1487676504.842250: event type EV_MSC(0x04): scancode = 0xffff014c
1487676504.842250: event type EV_SYN(0x00).
  # '9'
1487676506.542243: event type EV_MSC(0x04): scancode = 0xffff0158
1487676506.542243: event type EV_SYN(0x00).
  # right-arrow
1487676551.942312: event type EV_MSC(0x04): scancode = 0xffff015f
1487676551.942312: event type EV_SYN(0x00).
  # vol down
1487676637.746348: event type EV_MSC(0x04): scancode = 0xffff0105
1487676637.746348: event type EV_SYN(0x00).
  # vol up
1487676642.746321: event type EV_MSC(0x04): scancode = 0xffff0115
1487676642.746321: event type EV_SYN(0x00).

# cat /sys/class/rc/rc1/protocols
nec

All the above was done with the system booted with this in /etc/rc.local
/usr/bin/ir-keytable -s rc1 -c
/usr/bin/ir-keytable -s rc1 -w /etc/rc_keymaps/dvico-remote

After I disabled the rc.local script and rebooted:
# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event10) with:
        Driver imon, table rc-imon-mce
        Supported protocols: rc-6
        Enabled protocols: rc-6
        Name: iMON Remote (15c2:ffdc)
        bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
        Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc1/ (/dev/input/event15) with:
        Driver dvb_usb_cxusb, table rc-dvico-mce
        Supported protocols: nec
        Enabled protocols:
        Name: IR-receiver inside an USB DVB re
        bus: 3, vendor/product: 0fe9:db78, version: 0x827b
        Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc2/ (/dev/input/event16) with:
        Driver dvb_usb_af9035, table rc-empty
        Supported protocols: nec
        Enabled protocols:
        Name: Leadtek WinFast DTV Dongle Dual
        bus: 3, vendor/product: 0413:6a05, version: 0x0200
        Repeat delay = 500 ms, repeat period = 125 ms

# ir-keytable -r -t -d /dev/input/event15
scancode 0x0101 = KEY_RECORD (0xa7)
scancode 0x0102 = KEY_TV (0x179)
scancode 0x0103 = KEY_0 (0x0b)
scancode 0x0105 = KEY_VOLUMEDOWN (0x72)
scancode 0x0107 = KEY_4 (0x05)
scancode 0x0109 = KEY_CHANNELDOWN (0x193)
scancode 0x010a = KEY_EPG (0x16d)
scancode 0x010b = KEY_1 (0x02)
scancode 0x010d = KEY_STOP (0x80)
scancode 0x010e = KEY_MP3 (0x187)
scancode 0x010f = KEY_PREVIOUSSONG (0xa5)
scancode 0x0111 = KEY_CHANNELUP (0x192)
scancode 0x0112 = KEY_NEXTSONG (0xa3)
scancode 0x0113 = KEY_ANGLE (0x173)
scancode 0x0115 = KEY_VOLUMEUP (0x73)
scancode 0x0116 = KEY_SETUP (0x8d)
scancode 0x0117 = KEY_2 (0x03)
scancode 0x0119 = KEY_OPEN (0x86)
scancode 0x011a = KEY_DVD (0x185)
scancode 0x011b = KEY_3 (0x04)
scancode 0x011e = KEY_FAVORITES (0x16c)
scancode 0x011f = KEY_ZOOM (0x174)
scancode 0x0142 = KEY_ENTER (0x1c)
scancode 0x0143 = KEY_REWIND (0xa8)
scancode 0x0146 = KEY_POWER2 (0x164)
scancode 0x0147 = KEY_PLAYPAUSE (0xa4)
scancode 0x0148 = KEY_7 (0x08)
scancode 0x0149 = KEY_BACK (0x9e)
scancode 0x014c = KEY_8 (0x09)
scancode 0x014d = KEY_MENU (0x8b)
scancode 0x014e = KEY_POWER (0x74)
scancode 0x014f = KEY_FASTFORWARD (0xd0)
scancode 0x0150 = KEY_5 (0x06)
scancode 0x0151 = KEY_UP (0x67)
scancode 0x0152 = KEY_CAMERA (0xd4)
scancode 0x0153 = KEY_DOWN (0x6c)
scancode 0x0154 = KEY_6 (0x07)
scancode 0x0155 = KEY_TAB (0x0f)
scancode 0x0157 = KEY_MUTE (0x71)
scancode 0x0158 = KEY_9 (0x0a)
scancode 0x0159 = KEY_INFO (0x166)
scancode 0x015a = KEY_TUNER (0x182)
scancode 0x015b = KEY_LEFT (0x69)
scancode 0x015e = KEY_OK (0x160)
scancode 0x015f = KEY_RIGHT (0x6a)
Enabled protocols: other jvc sanyo mce-kbd rc-6 sharp xmp
Testing events. Please, press CTRL-C to abort.

 # '1'
1487682068.360565: event type EV_MSC(0x04): scancode = 0xffff010b
1487682068.360565: event type EV_SYN(0x00).
 # '2'
1487682091.293030: event type EV_MSC(0x04): scancode = 0xffff0117
1487682091.293030: event type EV_SYN(0x00).
 # '8'
1487682105.276940: event type EV_MSC(0x04): scancode = 0xffff014c
1487682105.276940: event type EV_SYN(0x00).
 # '9'
1487682121.489049: event type EV_MSC(0x04): scancode = 0xffff0158
1487682121.489049: event type EV_SYN(0x00).
 # vol_down
1487682143.577013: event type EV_MSC(0x04): scancode = 0xffff0105
1487682143.577013: event type EV_SYN(0x00).
 # vol_up
1487682155.736905: event type EV_MSC(0x04): scancode = 0xffff0115
1487682155.736905: event type EV_SYN(0x00).
 # down arrow
1487682175.924965: event type EV_MSC(0x04): scancode = 0xffff0153
1487682175.924965: event type EV_SYN(0x00).

# cat /sys/class/rc/rc1/protocols
nec

When I try to enable the nec protocol I get this:
# ir-keytable  -d /dev/input/event15 -p nec -t -r
Invalid protocols selected
Couldn't change the IR protocols

Hopefully all this stumbling in the dark is somewhat informative...
Vince
