Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61011 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1LQGdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 01:33:42 -0500
Received: by ggdk6 with SMTP id k6so3272833ggd.19
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 22:33:40 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Dec 2011 17:33:40 +1100
Message-ID: <CAA0ZO6BFmX6pb4+8jgnBQsGGZCV+ZkZ_BPSQFxLrOA43Ny1s1w@mail.gmail.com>
Subject: budget_ci / rc-hauppauge / inputlirc /Linux 3.0+ broken
From: Brian May <brian@microcomaustralia.com.au>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Have noticed this combination is broken.

Upgrading to a 3.1.2 kernel doesn't help, but downgrading to 2.6.28
and it works fine.

RAW DATA:

root@oncilla:~# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
	Driver budget_ci, table rc-hauppauge
	Supported protocols:
	Enabled protocols:
	Repeat delay = 500 ms, repeat period = 125 ms
root@oncilla:~# ir-keytable -r
scancode 0x0000 = KEY_0 (0x0b)
scancode 0x0001 = KEY_1 (0x02)
scancode 0x0002 = KEY_2 (0x03)
scancode 0x0003 = KEY_3 (0x04)
scancode 0x0004 = KEY_4 (0x05)
scancode 0x0005 = KEY_5 (0x06)
scancode 0x0006 = KEY_6 (0x07)
scancode 0x0007 = KEY_7 (0x08)
scancode 0x0008 = KEY_8 (0x09)
scancode 0x0009 = KEY_9 (0x0a)
scancode 0x000a = KEY_TEXT (0x184)
scancode 0x000b = KEY_RED (0x18e)
scancode 0x000c = KEY_RADIO (0x181)
scancode 0x000d = KEY_MUTE (0x71)
scancode 0x000e = KEY_SUBTITLE (0x172)
scancode 0x000f = KEY_MUTE (0x71)
scancode 0x0010 = KEY_VOLUMEUP (0x73)
scancode 0x0011 = KEY_VOLUMEDOWN (0x72)
scancode 0x0012 = KEY_PREVIOUS (0x19c)
scancode 0x0014 = KEY_UP (0x67)
scancode 0x0015 = KEY_DOWN (0x6c)
scancode 0x0016 = KEY_LEFT (0x69)
scancode 0x0017 = KEY_RIGHT (0x6a)
scancode 0x0018 = KEY_VIDEO (0x189)
scancode 0x0019 = KEY_AUDIO (0x188)
scancode 0x001a = KEY_CAMERA (0xd4)
scancode 0x001b = KEY_EPG (0x16d)
scancode 0x001c = KEY_TV (0x179)
scancode 0x001e = KEY_RED (0x18e)
scancode 0x001f = KEY_TV (0x179)
scancode 0x0020 = KEY_CHANNELUP (0x192)
scancode 0x0021 = KEY_CHANNELDOWN (0x193)
scancode 0x0022 = KEY_VIDEO (0x189)
scancode 0x0024 = KEY_LAST (0x195)
scancode 0x0025 = KEY_OK (0x160)
scancode 0x0026 = KEY_SLEEP (0x8e)
scancode 0x0029 = KEY_BLUE (0x191)
scancode 0x002e = KEY_ZOOM (0x174)
scancode 0x0030 = KEY_PAUSE (0x77)
scancode 0x0032 = KEY_REWIND (0xa8)
scancode 0x0034 = KEY_FASTFORWARD (0xd0)
scancode 0x0035 = KEY_PLAY (0xcf)
scancode 0x0036 = KEY_STOP (0x80)
scancode 0x0037 = KEY_RECORD (0xa7)
scancode 0x0038 = KEY_YELLOW (0x190)
scancode 0x003b = KEY_GOTO (0x162)
scancode 0x003c = KEY_ZOOM (0x174)
scancode 0x003d = KEY_POWER (0x74)
scancode 0x003f = KEY_HOME (0x66)
Enabled protocols:
root@oncilla:~# ir-keytable   -t
Testing events. Please, press CTRL-C to abort.
1324089674.313994: event MSC: scancode = 1f21
1324089674.313995: event sync
1324089674.689301: event MSC: scancode = 1f21
1324089674.689303: event sync
1324089674.948084: event MSC: scancode = 1f21
1324089674.948085: event sync
1324089675.230977: event MSC: scancode = 1f21
1324089675.230978: event sync
1324089675.489673: event MSC: scancode = 1f21
1324089675.489674: event sync
1324089675.806055: event MSC: scancode = 1f21
1324089675.806057: event sync


SUMMARY OF WHAT I THINK I HAPPENING:

budget_ci sets dev->scanmask to 0xff, this means the scancodes in the
tables have the upper 8 bits of the 16 bit code set to 0.

However for my card, it sets full_rc5 to True and rc_device to 0x1f.
This means the following new code gets executed:

    if (budget_ci->ir.full_rc5) {
        rc_keydown(dev,
               budget_ci->ir.rc5_device <<8 | budget_ci->ir.ir_key,
               (command & 0x20) ? 1 : 0);
        return;
    }


Where as before this code would get executed:

rc_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);

The result is that it tries to lookup (in this case) 0x1f21 in the
scancode table, which is a copy of rc-hauppauge but with the upper 8
bits of the scan code set to 0; the result is it can't find a match.

Does this sound right?

Maybe scanmask shouldn't be set to 0xff if full_rc5 is set to true?


LATER:

I deleted the line that sets dev->scanmask to 0xff in budget_ci,
recompiled, and now everything works.

Now all the table entries in rc-hauppauge.c appear in the output of
"ir-keytable -r" with the scan codes intact, and the kernel gives the
button presses correctly to inputlirc.



Please CC responses to me, thanks.
-- 
Brian May <brian@microcomaustralia.com.au>
