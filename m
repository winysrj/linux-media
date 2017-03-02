Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37159 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdCBNsg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 08:48:36 -0500
Received: by mail-wm0-f47.google.com with SMTP id n11so25359831wma.0
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 05:48:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170228221505.GA13809@gofer.mess.org>
References: <20170202233533.GA14357@gofer.mess.org> <CAEsFdVMhbxb3d=_ugYjfYSCRZsQMhtt=kmsqX81x-6UjTYc-bg@mail.gmail.com>
 <20170204191050.GA31779@gofer.mess.org> <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
 <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
 <CAEsFdVOfGFJ9HYav2h0gNkpdhYzbnVxnPbOaZW+HpO3KE1S9-w@mail.gmail.com>
 <20170220171309.GA26632@gofer.mess.org> <CAEsFdVNbmNZpYcst6wuDAVw4XS2eNBqwMwgx9LwfLZtY_jHhVA@mail.gmail.com>
 <20170221183223.GA3646@gofer.mess.org> <CAEsFdVP1pGPJFiUn8ERyXDhE2Zm2uwuD7gbr5mdRD=OmbQ9dwg@mail.gmail.com>
 <20170228221505.GA13809@gofer.mess.org>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Fri, 3 Mar 2017 00:48:27 +1100
Message-ID: <CAEsFdVPPcmmazfxSYiNdG4WctTDPD9-78dki+Qsafq7CyCs8yw@mail.gmail.com>
Subject: Re: ir-keytable: infinite loops, segfaults
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/1/17, Sean Young <sean@mess.org> wrote:
>
> Sorry Vincent, but are you sure you're running the patch with the
> & 0xff mask? That should have solved it.
>

er, no. Some kind of build issue. Once I applied your media_build
patch and then the latest kernel patch you sent, this is what the test
run looks like.

# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
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
Enabled protocols: unknown other rc-5 sanyo mce-kbd rc-6 sharp xmp
Testing events. Please, press CTRL-C to abort.
 # 1
1488461383.614660: event type EV_MSC(0x04): scancode = 0x10b
1488461383.614660: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
1488461383.614660: event type EV_SYN(0x00).
1488461383.865435: event type EV_KEY(0x01) key_up: KEY_1(0x0002)
1488461383.865435: event type EV_SYN(0x00).
 # 2
1488461394.150608: event type EV_MSC(0x04): scancode = 0x117
1488461394.150608: event type EV_KEY(0x01) key_down: KEY_2(0x0003)
1488461394.150608: event type EV_SYN(0x00).
1488461394.401431: event type EV_KEY(0x01) key_up: KEY_2(0x0003)
1488461394.401431: event type EV_SYN(0x00).
 # 8
1488461400.870636: event type EV_MSC(0x04): scancode = 0x14c
1488461400.870636: event type EV_KEY(0x01) key_down: KEY_8(0x0009)
1488461400.870636: event type EV_SYN(0x00).
1488461401.121430: event type EV_KEY(0x01) key_up: KEY_8(0x0009)
1488461401.121430: event type EV_SYN(0x00).
 # 9
1488461409.598593: event type EV_MSC(0x04): scancode = 0x158
1488461409.598593: event type EV_KEY(0x01) key_down: KEY_9(0x000a)
1488461409.598593: event type EV_SYN(0x00).
1488461409.849430: event type EV_KEY(0x01) key_up: KEY_9(0x000a)
1488461409.849430: event type EV_SYN(0x00).
 # vol_dn
1488461418.530615: event type EV_MSC(0x04): scancode = 0x105
1488461418.530615: event type EV_KEY(0x01) key_down: KEY_VOLUMEDOWN(0x0072)
1488461418.530615: event type EV_SYN(0x00).
1488461418.781443: event type EV_KEY(0x01) key_up: KEY_VOLUMEDOWN(0x0072)
1488461418.781443: event type EV_SYN(0x00).
 # vol_up
1488461428.490659: event type EV_MSC(0x04): scancode = 0x115
1488461428.490659: event type EV_KEY(0x01) key_down: KEY_VOLUMEUP(0x0073)
1488461428.490659: event type EV_SYN(0x00).
1488461428.741432: event type EV_KEY(0x01) key_up: KEY_VOLUMEUP(0x0073)
1488461428.741432: event type EV_SYN(0x00).
 # down arrow
1488461441.650689: event type EV_MSC(0x04): scancode = 0x153
1488461441.650689: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
1488461441.650689: event type EV_SYN(0x00).
1488461441.901433: event type EV_KEY(0x01) key_up: KEY_DOWN(0x006c)
1488461441.901433: event type EV_SYN(0x00).

So it's working, although ir-keytable seems a little confused about
the protocol being used.

I explored other keys and found that higher keycodes are still being
ignored by mythtv, e.g.

  KEY_BACK(0x009e) scancode 0x149
  KEY_MENU(0x008b) scancode 0x14d
  KEY_STOP(0x0080) scancode 0x10d

The boundary seems to be 0x0080, all the keycodes below that seem to work.
I have not explored messing about with keytable remapping.

But for this patch at least: Tested-By: vincent.mcintyre@gmail.com
And thanks!
Vince
