Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:50797 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbdB1WPR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 17:15:17 -0500
Date: Tue, 28 Feb 2017 22:15:05 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20170228221505.GA13809@gofer.mess.org>
References: <20170202233533.GA14357@gofer.mess.org>
 <CAEsFdVMhbxb3d=_ugYjfYSCRZsQMhtt=kmsqX81x-6UjTYc-bg@mail.gmail.com>
 <20170204191050.GA31779@gofer.mess.org>
 <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
 <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
 <CAEsFdVOfGFJ9HYav2h0gNkpdhYzbnVxnPbOaZW+HpO3KE1S9-w@mail.gmail.com>
 <20170220171309.GA26632@gofer.mess.org>
 <CAEsFdVNbmNZpYcst6wuDAVw4XS2eNBqwMwgx9LwfLZtY_jHhVA@mail.gmail.com>
 <20170221183223.GA3646@gofer.mess.org>
 <CAEsFdVP1pGPJFiUn8ERyXDhE2Zm2uwuD7gbr5mdRD=OmbQ9dwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsFdVP1pGPJFiUn8ERyXDhE2Zm2uwuD7gbr5mdRD=OmbQ9dwg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 25, 2017 at 02:08:39AM +1100, Vincent McIntyre wrote:
> On 2/22/17, Sean Young <sean@mess.org> wrote:
> 
> > So it's still using the old keymap. I've attached a new one.
> 
> That works, thanks.
> 
> >>   # vol down
> >> 1487676637.746348: event type EV_MSC(0x04): scancode = 0xffff0105
> >> 1487676637.746348: event type EV_SYN(0x00).
> >>   # vol up
> >> 1487676642.746321: event type EV_MSC(0x04): scancode = 0xffff0115
> >> 1487676642.746321: event type EV_SYN(0x00).
> >
> > Oops, that's a bug. 0xffff should be 0x0000. I've attached a new version of
> > the patch which should fix that.
> >
> 
> I am still getting the high bits set. I checked the code and the patch
> was correctly applied,
> I see where you are applying a 0xff mask to the ircode values.
> 
> 
> Test run:
> # Found /sys/class/rc/rc0/ (/dev/input/event5) with:
>         Driver imon, table rc-imon-mce
>         Supported protocols: rc-6
>         Enabled protocols: rc-6
>         Name: iMON Remote (15c2:ffdc)
>         bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
>         Repeat delay = 500 ms, repeat period = 125 ms
> Found /sys/class/rc/rc1/ (/dev/input/event15) with:
>         Driver dvb_usb_cxusb, table rc-dvico-mce
>         Supported protocols: nec
>         Enabled protocols:
>         Name: IR-receiver inside an USB DVB re
>         bus: 3, vendor/product: 0fe9:db78, version: 0x827b
>         Repeat delay = 500 ms, repeat period = 125 ms
> Found /sys/class/rc/rc2/ (/dev/input/event16) with:
>         Driver dvb_usb_af9035, table rc-empty
>         Supported protocols: nec
>         Enabled protocols:
>         Name: Leadtek WinFast DTV Dongle Dual
>         bus: 3, vendor/product: 0413:6a05, version: 0x0200
>         Repeat delay = 500 ms, repeat period = 125 ms
> 
> #  ir-keytable -r -t -d /dev/input/event15
> scancode 0x0101 = KEY_RECORD (0xa7)
> scancode 0x0102 = KEY_TV (0x179)
> scancode 0x0103 = KEY_0 (0x0b)
> scancode 0x0105 = KEY_VOLUMEDOWN (0x72)
> scancode 0x0107 = KEY_4 (0x05)
> scancode 0x0109 = KEY_CHANNELDOWN (0x193)
> scancode 0x010a = KEY_EPG (0x16d)
> scancode 0x010b = KEY_1 (0x02)
> scancode 0x010d = KEY_STOP (0x80)
> scancode 0x010e = KEY_MP3 (0x187)
> scancode 0x010f = KEY_PREVIOUSSONG (0xa5)
> scancode 0x0111 = KEY_CHANNELUP (0x192)
> scancode 0x0112 = KEY_NEXTSONG (0xa3)
> scancode 0x0113 = KEY_ANGLE (0x173)
> scancode 0x0115 = KEY_VOLUMEUP (0x73)
> scancode 0x0116 = KEY_SETUP (0x8d)
> scancode 0x0117 = KEY_2 (0x03)
> scancode 0x0119 = KEY_OPEN (0x86)
> scancode 0x011a = KEY_DVD (0x185)
> scancode 0x011b = KEY_3 (0x04)
> scancode 0x011e = KEY_FAVORITES (0x16c)
> scancode 0x011f = KEY_ZOOM (0x174)
> scancode 0x0142 = KEY_ENTER (0x1c)
> scancode 0x0143 = KEY_REWIND (0xa8)
> scancode 0x0146 = KEY_POWER2 (0x164)
> scancode 0x0147 = KEY_PLAYPAUSE (0xa4)
> scancode 0x0148 = KEY_7 (0x08)
> scancode 0x0149 = KEY_BACK (0x9e)
> scancode 0x014c = KEY_8 (0x09)
> scancode 0x014d = KEY_MENU (0x8b)
> scancode 0x014e = KEY_POWER (0x74)
> scancode 0x014f = KEY_FASTFORWARD (0xd0)
> scancode 0x0150 = KEY_5 (0x06)
> scancode 0x0151 = KEY_UP (0x67)
> scancode 0x0152 = KEY_CAMERA (0xd4)
> scancode 0x0153 = KEY_DOWN (0x6c)
> scancode 0x0154 = KEY_6 (0x07)
> scancode 0x0155 = KEY_TAB (0x0f)
> scancode 0x0157 = KEY_MUTE (0x71)
> scancode 0x0158 = KEY_9 (0x0a)
> scancode 0x0159 = KEY_INFO (0x166)
> scancode 0x015a = KEY_TUNER (0x182)
> scancode 0x015b = KEY_LEFT (0x69)
> scancode 0x015e = KEY_OK (0x160)
> scancode 0x015f = KEY_RIGHT (0x6a)
> Enabled protocols: other jvc sony nec sanyo mce-kbd rc-6 sharp xmp
> Testing events. Please, press CTRL-C to abort.
>  # '1'
> 1487948112.709532: event type EV_MSC(0x04): scancode = 0xffff010b
> 1487948112.709532: event type EV_SYN(0x00).
>  # '2'
> 1487948137.229455: event type EV_MSC(0x04): scancode = 0xffff0117
> 1487948137.229455: event type EV_SYN(0x00).
>  # '8'
> 1487948233.341489: event type EV_MSC(0x04): scancode = 0xffff014c
> 1487948233.341489: event type EV_SYN(0x00).
>  # '9'
> 1487948248.417547: event type EV_MSC(0x04): scancode = 0xffff0158
> 1487948248.417547: event type EV_SYN(0x00).
>  # volume_down
> 1487948270.537497: event type EV_MSC(0x04): scancode = 0xffff0105
> 1487948270.537497: event type EV_SYN(0x00).
>  # volume_up
> 1487948464.425435: event type EV_MSC(0x04): scancode = 0xffff0115
> 1487948464.425435: event type EV_SYN(0x00).

Sorry Vincent, but are you sure you're running the patch with the
& 0xff mask? That should have solved it.


Sean
