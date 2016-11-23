Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35568 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935603AbcKWMjO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 07:39:14 -0500
Received: by mail-pf0-f180.google.com with SMTP id i88so3571055pfk.2
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2016 04:39:13 -0800 (PST)
Date: Wed, 23 Nov 2016 23:39:06 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161123123851.GB14257@shambles.local>
References: <20161116105256.GA9998@shambles.local>
 <20161117134526.GA8485@gofer.mess.org>
 <20161118121422.GA1986@shambles.local>
 <20161118174034.GA6167@gofer.mess.org>
 <20161118220107.GA3510@shambles.local>
 <20161120132948.GA23247@gofer.mess.org>
 <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
 <20161122092043.GA8630@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161122092043.GA8630@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2016 at 09:20:44AM +0000, Sean Young wrote:
> > Thanks for this. I have got it to build within the media_build setup
> > but will need to find some windows in the schedule for testing. More
> > in a couple of days. Are there specific things you would like me to
> > test?
> 
> You should have an rc device for the IR receiver in the dvb device; does
> it continue to work and can you clear/load a new keymap with ir-keytable,
> and does it work after that.
> 
> A "Tested-by" would be great if it all works of course.

Time for some initial results. Good start, not quite there yet.

Nov 23 23:04:56 kernel: Registered IR keymap rc-dvico-mce
Nov 23 23:04:56 kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00
Nov 23 23:04:56 kernel: rc rc1: IR-receiver inside an USB DVB receiver as /devices/pci0000:0
Nov 23 23:04:56 kernel: dvb-usb: schedule remote query interval to 100 msecs.
Nov 23 23:04:56 kernel: dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initiali
Nov 23 23:04:56 kernel: dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm sta
Nov 23 23:04:56 kernel: dvb-usb: will pass the complete MPEG2 transport stream to the softwa
Nov 23 23:04:56 kernel: dvbdev: DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Di
Nov 23 23:04:56 kernel: usb 3-2: media controller created
Nov 23 23:04:56 kernel: dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered
Nov 23 23:04:56 kernel: cxusb: No IR receiver detected on this device.
Nov 23 23:04:56 kernel: usb 3-2: DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 DVB-
Nov 23 23:04:56 kernel: dvbdev: dvb_create_media_entity: media entity 'Zarlink ZL10353 DVB-T
Nov 23 23:04:56 kernel: xc2028 5-0061: creating new instance
Nov 23 23:04:56 kernel: xc2028 5-0061: type set to XCeive xc2028/xc3028 tuner
Nov 23 23:04:56 kernel: xc2028 5-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
Nov 23 23:04:56 kernel: dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initiali
Nov 23 23:04:56 kernel: usbcore: registered new interface driver dvb_usb_cxusb

# lsmod |grep rc
rc_dvico_mce           16384  0
rc_imon_mce            16384  0
rc_core                32768  11 imon,dvb_usb,winbond_cir,dvb_usb_cxusb,rc_imon_mce,rc_dvico_mce,dvb_usb_v2,dvb_usb_af9035
libcrc32c              16384  1 raid456
crc_itu_t              16384  1 firewire_core

# lsmod |grep cxu
dvb_usb_cxusb          77824  2
dib0070                20480  1 dvb_usb_cxusb
dvb_usb                32768  1 dvb_usb_cxusb
rc_core                32768  11 imon,dvb_usb,winbond_cir,dvb_usb_cxusb,rc_imon_mce,rc_dvico_mce,dvb_usb_v2,dvb_usb_af9035


# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
    Driver imon, table rc-imon-mce
    Supported protocols: rc-6 
    Enabled protocols: rc-6 
    Name: iMON Remote (15c2:ffdc)
    bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
    Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc1/ (/dev/input/event15) with:
    Driver (null), table rc-dvico-mce
    Supported protocols: unknown 
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

Not sure why Driver is (null), dvb_usb_cxusb is loaded.

# ir-keytable -s rc1 -r -v
Found device /sys/class/rc/rc0/
Found device /sys/class/rc/rc1/
Found device /sys/class/rc/rc2/
Input sysfs node is /sys/class/rc/rc1/input18/
Event sysfs node is /sys/class/rc/rc1/input18/event15/
Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
/sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
/sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
/sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
Parsing uevent /sys/class/rc/rc1/uevent
/sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
input device is /dev/input/event15
/sys/class/rc/rc1/protocols protocol unknown (disabled)
Opening /dev/input/event15
Input Protocol version: 0x00010001
scancode 0xfe01 = KEY_RECORD (0xa7)
scancode 0xfe02 = KEY_TV (0x179)
scancode 0xfe03 = KEY_0 (0x0b)
scancode 0xfe05 = KEY_VOLUMEDOWN (0x72)
scancode 0xfe07 = KEY_4 (0x05)
scancode 0xfe09 = KEY_CHANNELDOWN (0x193)
scancode 0xfe0a = KEY_EPG (0x16d)
scancode 0xfe0b = KEY_1 (0x02)
scancode 0xfe0d = KEY_STOP (0x80)
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
scancode 0xfe47 = KEY_PLAYPAUSE (0xa4)
scancode 0xfe48 = KEY_7 (0x08)
scancode 0xfe49 = KEY_BACK (0x9e)
scancode 0xfe4c = KEY_8 (0x09)
scancode 0xfe4d = KEY_MENU (0x8b)
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
scancode 0xfe5e = KEY_OK (0x160)
scancode 0xfe5f = KEY_RIGHT (0x6a)
Enabled protocols: 
#

I tried -t and it generated events constantly, before I could press
any keys.
# ir-keytable -s rc1 -t
Testing events. Please, press CTRL-C to abort.
1479903007.535509: event type EV_MSC(0x04): scancode = 0x00
1479903007.535509: event type EV_SYN(0x00).
1479903007.635521: event type EV_MSC(0x04): scancode = 0x00
1479903007.635521: event type EV_SYN(0x00).
1479903007.735535: event type EV_MSC(0x04): scancode = 0x00
1479903007.735535: event type EV_SYN(0x00).
1479903007.839552: event type EV_MSC(0x04): scancode = 0x00
1479903007.839552: event type EV_SYN(0x00).
1479903007.939565: event type EV_MSC(0x04): scancode = 0x00
1479903007.939565: event type EV_SYN(0x00).
1479903008.039579: event type EV_MSC(0x04): scancode = 0x00
1479903008.039579: event type EV_SYN(0x00).
1479903008.143594: event type EV_MSC(0x04): scancode = 0x00
1479903008.143594: event type EV_SYN(0x00).
1479903008.243608: event type EV_MSC(0x04): scancode = 0x00
1479903008.243608: event type EV_SYN(0x00).
1479903008.343622: event type EV_MSC(0x04): scancode = 0x00
1479903008.343622: event type EV_SYN(0x00).
1479903008.443512: event type EV_MSC(0x04): scancode = 0x00
1479903008.443512: event type EV_SYN(0x00).
1479903008.543525: event type EV_MSC(0x04): scancode = 0x00
1479903008.543525: event type EV_SYN(0x00).
1479903008.647541: event type EV_MSC(0x04): scancode = 0x00
1479903008.647541: event type EV_SYN(0x00).
^C

Same behaviour with -d /dev/input/event15.

I tried pressing the PLAYPAUSE key:
1479903175.199520: event type EV_MSC(0x04): scancode = 0x00
1479903175.199520: event type EV_SYN(0x00).
1479903175.299538: event type EV_MSC(0x04): scancode = 0xfe47
1479903175.299538: event type EV_KEY(0x01) key_down: KEY_PLAYPAUSE(0x00a4)
1479903175.299538: event type EV_SYN(0x00).
1479903175.399554: event type EV_KEY(0x01) key_up: KEY_PLAYPAUSE(0x00a4)
1479903175.399554: event type EV_MSC(0x04): scancode = 0x00
1479903175.399554: event type EV_SYN(0x00).
1479903175.499563: event type EV_MSC(0x04): scancode = 0x00
1479903175.499563: event type EV_SYN(0x00).
1479903175.599579: event type EV_MSC(0x04): scancode = 0x00
1479903175.599579: event type EV_SYN(0x00).
1479903175.699593: event type EV_MSC(0x04): scancode = 0x00
1479903175.699593: event type EV_SYN(0x00).
1479903175.799481: event type EV_MSC(0x04): scancode = 0x00
1479903175.799481: event type EV_SYN(0x00).
1479903175.899496: event type EV_MSC(0x04): scancode = 0x00
1479903175.899496: event type EV_SYN(0x00).
1479903175.999510: event type EV_MSC(0x04): scancode = 0x00
1479903175.999510: event type EV_SYN(0x00).
1479903176.099653: event type EV_MSC(0x04): scancode = 0xfe47
1479903176.099653: event type EV_KEY(0x01) key_down: KEY_PLAYPAUSE(0x00a4)
1479903176.099653: event type EV_SYN(0x00).
1479903176.199540: event type EV_KEY(0x01) key_up: KEY_PLAYPAUSE(0x00a4)
1479903176.199540: event type EV_MSC(0x04): scancode = 0x00
1479903176.199540: event type EV_SYN(0x00).

Same behaviour wth 'evtest'

I explored telling it what protocol to use etc.

# cat /sys/class/rc/rc1/protocols 
unknown
# echo 3 > /sys/module/rc_core/parameters/debug
# journalctl -f -k
(Pressing PLAYPAUSE, once)
Nov 23 23:21:52 kernel: rc_core: IR-receiver inside an USB DVB receiver: scancode 0xfe47 keycode 0xa4
Nov 23 23:21:52 kernel: rc_core: IR-receiver inside an USB DVB receiver: key down event, key 0x00a4, protocol 0x0000, scancode 0x0000fe47
Nov 23 23:21:52 kernel: rc_core: keyup key 0x00a4

(MENU)
Nov 23 23:24:34 kernel: rc_core: IR-receiver inside an USB DVB receiver: scancode 0xfe4d keycode 0x8b
Nov 23 23:24:34 kernel: rc_core: IR-receiver inside an USB DVB receiver: key down event, key 0x008b, protocol 0x0000, scancode 0x0000fe4d
Nov 23 23:24:34 kernel: rc_core: keyup key 0x008b

# echo rc-6 > /sys/class/rc/rc1/protocols 
Nov 23 23:26:01 kernel: rc_core: Normal protocol change requested
Nov 23 23:26:01 kernel: rc_core: Protocol switching not supported
# cat /sys/class/rc/rc1/protocols
unknown

Try to load a keytable:
# ir-keytable -v -s rc1 -w /lib/udev/rc_keymaps/dvico_mce 
Parsing /lib/udev/rc_keymaps/dvico_mce keycode file
parsing 0xfe02=KEY_TV:  value=377
parsing 0xfe0e=KEY_MP3: value=391
parsing 0xfe1a=KEY_DVD: value=389
parsing 0xfe1e=KEY_FAVORITES:   value=364
parsing 0xfe16=KEY_SETUP:   value=141
parsing 0xfe46=KEY_POWER2:  value=356
parsing 0xfe0a=KEY_EPG: value=365
parsing 0xfe49=KEY_BACK:    value=158
parsing 0xfe4d=KEY_MENU:    value=139
parsing 0xfe51=KEY_UP:  value=103
parsing 0xfe5b=KEY_LEFT:    value=105
parsing 0xfe5f=KEY_RIGHT:   value=106
parsing 0xfe53=KEY_DOWN:    value=108
parsing 0xfe5e=KEY_OK:  value=352
parsing 0xfe59=KEY_INFO:    value=358
parsing 0xfe55=KEY_TAB: value=15
parsing 0xfe0f=KEY_PREVIOUSSONG:    value=165
parsing 0xfe12=KEY_NEXTSONG:    value=163
parsing 0xfe42=KEY_ENTER:   value=28
parsing 0xfe15=KEY_VOLUMEUP:    value=115
parsing 0xfe05=KEY_VOLUMEDOWN:  value=114
parsing 0xfe11=KEY_CHANNELUP:   value=402
parsing 0xfe09=KEY_CHANNELDOWN: value=403
parsing 0xfe52=KEY_CAMERA:  value=212
parsing 0xfe5a=KEY_TUNER:   value=386
parsing 0xfe19=KEY_OPEN:    value=134
parsing 0xfe0b=KEY_1:   value=2
parsing 0xfe17=KEY_2:   value=3
parsing 0xfe1b=KEY_3:   value=4
parsing 0xfe07=KEY_4:   value=5
parsing 0xfe50=KEY_5:   value=6
parsing 0xfe54=KEY_6:   value=7
parsing 0xfe48=KEY_7:   value=8
parsing 0xfe4c=KEY_8:   value=9
parsing 0xfe58=KEY_9:   value=10
parsing 0xfe13=KEY_ANGLE:   value=371
parsing 0xfe03=KEY_0:   value=11
parsing 0xfe1f=KEY_ZOOM:    value=372
parsing 0xfe43=KEY_REWIND:  value=168
parsing 0xfe47=KEY_PLAYPAUSE:   value=164
parsing 0xfe4f=KEY_FASTFORWARD: value=208
parsing 0xfe57=KEY_MUTE:    value=113
parsing 0xfe0d=KEY_STOP:    value=128
parsing 0xfe01=KEY_RECORD:  value=167
parsing 0xfe4e=KEY_POWER:   value=116
Read dvico_mce table
Found device /sys/class/rc/rc0/
Found device /sys/class/rc/rc1/
Found device /sys/class/rc/rc2/
Input sysfs node is /sys/class/rc/rc1/input18/
Event sysfs node is /sys/class/rc/rc1/input18/event15/
Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
/sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
/sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
/sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
Parsing uevent /sys/class/rc/rc1/uevent
/sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
input device is /dev/input/event15
/sys/class/rc/rc1/protocols protocol unknown (disabled)
Opening /dev/input/event15
Input Protocol version: 0x00010001
    fe4e=0074
    fe01=00a7
    fe0d=0080
    fe57=0071
    fe4f=00d0
    fe47=00a4
    fe43=00a8
    fe1f=0174
    fe03=000b
    fe13=0173
    fe58=000a
    fe4c=0009
    fe48=0008
    fe54=0007
    fe50=0006
    fe07=0005
    fe1b=0004
    fe17=0003
    fe0b=0002
    fe19=0086
    fe5a=0182
    fe52=00d4
    fe09=0193
    fe11=0192
    fe05=0072
    fe15=0073
    fe42=001c
    fe12=00a3
    fe0f=00a5
    fe55=000f
    fe59=0166
    fe5e=0160
    fe53=006c
    fe5f=006a
    fe5b=0069
    fe51=0067
    fe4d=008b
    fe49=009e
    fe0a=016d
    fe46=0164
    fe16=008d
    fe1e=016c
    fe1a=0185
    fe0e=0187
    fe02=0179
Wrote 45 keycode(s) to driver
/sys/class/rc/rc1//protocols: Invalid argument
Couldn't change the IR protocols
#

Same result if I add -p RC-6 to the argument list.

Cheers
Vince
