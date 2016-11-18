Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:36858 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752176AbcKRWtO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 17:49:14 -0500
Received: by mail-pg0-f42.google.com with SMTP id f188so106968697pgc.3
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2016 14:49:14 -0800 (PST)
Date: Sat, 19 Nov 2016 09:49:03 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161118224843.GA4107@shambles.local>
References: <20161116105256.GA9998@shambles.local>
 <20161117134526.GA8485@gofer.mess.org>
 <20161118121422.GA1986@shambles.local>
 <20161118174034.GA6167@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118174034.GA6167@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 18, 2016 at 05:40:34PM +0000, Sean Young wrote:
> > 
> > # ir-keytable
> > Found /sys/class/rc/rce0/ (/dev/input/event5) with:
> >     Driver imon, table rc-imon-mce
> >     Supported protocols: rc-6 
> >     Enabled protocols: rc-6 
> >     Name: iMON Remote (15c2:ffdc)
> >     bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
> >     Repeat delay = 500 ms, repeat period = 125 ms
> > Found /sys/class/rc/rc1/ (/dev/input/event16) with:
> >     Driver dvb_usb_af9035, table rc-empty
> >     Supported protocols: nec 
> >     Enabled protocols: 
> >     Name: Leadtek WinFamst DTV Dongle Dual
> >     bus: 3, vendor/product: 0413:6a05, version: 0x0200
> >     Repeat delay = 500 mss, repeat period = 125 ms

So I checked on the ir receivers and found the rc1 device ir receiver
was indeed blocked (haven't checked rc0 properly, time is short)

I tested it with evtest and the remote that comes with the device

# evtest /dev/input/event16
Input driver version is 1.0.1
Input device ID: bus 0x3 vendor 0x413 product 0x6a05 version 0x200
Input device name: "Leadtek WinFast DTV Dongle Dual"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 28 (KEY_ENTER)
    Event code 103 (KEY_UP)
    Event code 105 (KEY_LEFT)
    Event code 106 (KEY_RIGHT)
    Event code 108 (KEY_DOWN)
    Event code 111 (KEY_DELETE)
    Event code 113 (KEY_MUTE)
    Event code 114 (KEY_VOLUMEDOWN)
    Event code 115 (KEY_VOLUMEUP)
    Event code 119 (KEY_PAUSE)
    Event code 128 (KEY_STOP)
    Event code 142 (KEY_SLEEP)
    Event code 152 (KEY_SCREENLOCK)
    Event code 161 (KEY_EJECTCD)
    Event code 164 (KEY_PLAYPAUSE)
    Event code 167 (KEY_RECORD)
    Event code 168 (KEY_REWIND)
    Event code 174 (KEY_EXIT)
    Event code 207 (KEY_PLAY)
    Event code 208 (KEY_FASTFORWARD)
    Event code 210 (KEY_PRINT)
    Event code 212 (KEY_CAMERA)
    Event code 224 (KEY_BRIGHTNESSDOWN)
    Event code 225 (KEY_BRIGHTNESSUP)
    Event code 226 (KEY_MEDIA)
    Event code 352 (KEY_OK)
    Event code 356 (KEY_POWER2)
    Event code 358 (KEY_INFO)
    Event code 365 (KEY_EPG)
    Event code 366 (KEY_PVR)
    Event code 368 (KEY_LANGUAGE)
    Event code 369 (KEY_TITLE)
    Event code 370 (KEY_SUBTITLE)
    Event code 372 (KEY_ZOOM)
    Event code 373 (KEY_MODE)
    Event code 377 (KEY_TV)
    Event code 385 (KEY_RADIO)
    Event code 386 (KEY_TUNER)
    Event code 387 (KEY_PLAYER)
    Event code 389 (KEY_DVD)
    Event code 392 (KEY_AUDIO)
    Event code 393 (KEY_VIDEO)
    Event code 398 (KEY_RED)
    Event code 399 (KEY_GREEN)
    Event code 400 (KEY_YELLOW)
    Event code 401 (KEY_BLUE)
    Event code 402 (KEY_CHANNELUP)
    Event code 403 (KEY_CHANNELDOWN)
    Event code 407 (KEY_NEXT)
    Event code 412 (KEY_PREVIOUS)
    Event code 425 (KEY_PRESENTATION)
    Event code 512 (KEY_NUMERIC_0)
    Event code 513 (KEY_NUMERIC_1)
    Event code 514 (KEY_NUMERIC_2)
    Event code 515 (KEY_NUMERIC_3)
    Event code 516 (KEY_NUMERIC_4)
    Event code 517 (KEY_NUMERIC_5)
    Event code 518 (KEY_NUMERIC_6)
    Event code 519 (KEY_NUMERIC_7)
    Event code 520 (KEY_NUMERIC_8)
    Event code 521 (KEY_NUMERIC_9)
    Event code 522 (KEY_NUMERIC_STAR)
    Event code 523 (KEY_NUMERIC_POUND)
  Event type 4 (EV_MSC)
    Event code 4 (MSC_SCAN)
Key repeat handling:
  Repeat type 20 (EV_REP)
    Repeat code 0 (REP_DELAY)
      Value    500
    Repeat code 1 (REP_PERIOD)
      Value    125
Properties:
Testing ... (interrupt to exit)
<volumedown pressed>
Event: time 1479509081.158426, type 4 (EV_MSC), code 4 (MSC_SCAN), value 35a
Event: time 1479509081.158426, -------------- SYN_REPORT ------------
<volumeup pressed>
Event: time 1479509084.658351, type 4 (EV_MSC), code 4 (MSC_SCAN), value 35e
Event: time 1479509084.658351, -------------- SYN_REPORT ------------
^C

I tried to load a keymap but got another segfault

# ir-keytable -p nec -d /dev/input/event16 -w /lib/udev/rc_keymaps/rc6_mce 
Read rc6_mce table
Wrote 63 keycode(s) to driver
Segmentation fault (core dumped)

Can't find a -dbg package so can't give you a useful backtrace
at the moment.

Anyway: trying the same evtest with the dvico remote
evtest /dev/input/event16
<volumedown>
Event: time 1479509251.174361, type 4 (EV_MSC), code 4 (MSC_SCAN), value 105
Event: time 1479509251.174361, -------------- SYN_REPORT ------------
<volumeup>
Event: time 1479509254.174403, type 4 (EV_MSC), code 4 (MSC_SCAN), value 115
Event: time 1479509254.174403, -------------- SYN_REPORT ------------

So something is connecting via IR.
Out of time now, more later
Vince
