Return-path: <linux-media-owner@vger.kernel.org>
Received: from seanyoung1.plus.com ([80.229.237.210]:49633 "EHLO
        gofer.mess.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964889AbcKXNfC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 08:35:02 -0500
Date: Thu, 24 Nov 2016 13:34:59 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161124133459.GA32385@gofer.mess.org>
References: <20161117134526.GA8485@gofer.mess.org>
 <20161118121422.GA1986@shambles.local>
 <20161118174034.GA6167@gofer.mess.org>
 <20161118220107.GA3510@shambles.local>
 <20161120132948.GA23247@gofer.mess.org>
 <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
 <20161122092043.GA8630@gofer.mess.org>
 <20161123123851.GB14257@shambles.local>
 <20161123223419.GA25515@gofer.mess.org>
 <20161124121253.GA17639@shambles.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161124121253.GA17639@shambles.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 24, 2016 at 11:12:57PM +1100, Vincent McIntyre wrote:
> On Wed, Nov 23, 2016 at 10:34:19PM +0000, Sean Young wrote:
> > > Not sure why Driver is (null), dvb_usb_cxusb is loaded.
> > 
> > That's a mistake, I've fixed that now.
> 
> Ah. I see the added module_name struct members.
> 
> > > I tried -t and it generated events constantly, before I could press
> > > any keys.
> > > # ir-keytable -s rc1 -t
> > > Testing events. Please, press CTRL-C to abort.
> > > 1479903007.535509: event type EV_MSC(0x04): scancode = 0x00
> > > 1479903007.535509: event type EV_SYN(0x00).
> > > 1479903007.635521: event type EV_MSC(0x04): scancode = 0x00
> > 
> > That's also been fixed.
> > 
> 
> yep, works nicely.
> 
> Things are looking much better!
> As shown below I am able to clear a keytable and put in a fresh one.
> Having a bit of trouble with key remapping.
> I guess we still have to work out the protocol in use.
> 
> Test details:
> # ir-keytable -v
> Found device /sys/class/rc/rc0/
> Found device /sys/class/rc/rc1/
> Found device /sys/class/rc/rc2/
> Input sysfs node is /sys/class/rc/rc0/input8/
> Event sysfs node is /sys/class/rc/rc0/input8/event5/
> Parsing uevent /sys/class/rc/rc0/input8/event5/uevent
> /sys/class/rc/rc0/input8/event5/uevent uevent MAJOR=13
> /sys/class/rc/rc0/input8/event5/uevent uevent MINOR=69
> /sys/class/rc/rc0/input8/event5/uevent uevent DEVNAME=input/event5
> Parsing uevent /sys/class/rc/rc0/uevent
> /sys/class/rc/rc0/uevent uevent NAME=rc-imon-mce
> /sys/class/rc/rc0/uevent uevent DRV_NAME=imon
> input device is /dev/input/event5
> /sys/class/rc/rc0/protocols protocol rc-6 (enabled)
> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
> 	Driver imon, table rc-imon-mce
> 	Supported protocols: rc-6 
> 	Enabled protocols: rc-6 
> 	Name: iMON Remote (15c2:ffdc)
> 	bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
> Input sysfs node is /sys/class/rc/rc1/input18/
> Event sysfs node is /sys/class/rc/rc1/input18/event15/
> Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
> /sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
> /sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
> /sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
> Parsing uevent /sys/class/rc/rc1/uevent
> /sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
> /sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
> input device is /dev/input/event15
> /sys/class/rc/rc1/protocols protocol unknown (disabled)
> Found /sys/class/rc/rc1/ (/dev/input/event15) with:
> 	Driver dvb_usb_cxusb, table rc-dvico-mce
> 	Supported protocols: unknown 
> 	Enabled protocols: 
> 	Name: IR-receiver inside an USB DVB re
> 	bus: 3, vendor/product: 0fe9:db78, version: 0x827b
> Input sysfs node is /sys/class/rc/rc2/input19/
> Event sysfs node is /sys/class/rc/rc2/input19/event16/
> Parsing uevent /sys/class/rc/rc2/input19/event16/uevent
> /sys/class/rc/rc2/input19/event16/uevent uevent MAJOR=13
> /sys/class/rc/rc2/input19/event16/uevent uevent MINOR=80
> /sys/class/rc/rc2/input19/event16/uevent uevent DEVNAME=input/event16
> Parsing uevent /sys/class/rc/rc2/uevent
> /sys/class/rc/rc2/uevent uevent NAME=rc-empty
> /sys/class/rc/rc2/uevent uevent DRV_NAME=dvb_usb_af9035
> input device is /dev/input/event16
> /sys/class/rc/rc2/protocols protocol nec (disabled)
> Found /sys/class/rc/rc2/ (/dev/input/event16) with:
> 	Driver dvb_usb_af9035, table rc-empty
> 	Supported protocols: nec 
> 	Enabled protocols: 
> 	Name: Leadtek WinFast DTV Dongle Dual
> 	bus: 3, vendor/product: 0413:6a05, version: 0x0200
> 	Repeat delay = 500 ms, repeat period = 125 ms
> 	Repeat delay = 500 ms, repeat period = 125 ms
> 	Repeat delay = 500 ms, repeat period = 125 ms
> 
> # ir-keytable -r -v -s rc1
> Found device /sys/class/rc/rc0/
> Found device /sys/class/rc/rc1/
> Found device /sys/class/rc/rc2/
> Input sysfs node is /sys/class/rc/rc1/input18/
> Event sysfs node is /sys/class/rc/rc1/input18/event15/
> Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
> /sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
> /sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
> /sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
> Parsing uevent /sys/class/rc/rc1/uevent
> /sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
> /sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
> input device is /dev/input/event15
> /sys/class/rc/rc1/protocols protocol unknown (disabled)
> Opening /dev/input/event15
> Input Protocol version: 0x00010001
> Enabled protocols: 
> scancode 0xfe01 = KEY_RECORD (0xa7)
> scancode 0xfe02 = KEY_TV (0x179)
> scancode 0xfe03 = KEY_0 (0x0b)
> scancode 0xfe05 = KEY_VOLUMEDOWN (0x72)
> scancode 0xfe07 = KEY_4 (0x05)
> scancode 0xfe09 = KEY_CHANNELDOWN (0x193)
> scancode 0xfe0a = KEY_EPG (0x16d)
> scancode 0xfe0b = KEY_1 (0x02)
> scancode 0xfe0d = KEY_STOP (0x80)
> scancode 0xfe0e = KEY_MP3 (0x187)
> scancode 0xfe0f = KEY_PREVIOUSSONG (0xa5)
> scancode 0xfe11 = KEY_CHANNELUP (0x192)
> scancode 0xfe12 = KEY_NEXTSONG (0xa3)
> scancode 0xfe13 = KEY_ANGLE (0x173)
> scancode 0xfe15 = KEY_VOLUMEUP (0x73)
> scancode 0xfe16 = KEY_SETUP (0x8d)
> scancode 0xfe17 = KEY_2 (0x03)
> scancode 0xfe19 = KEY_OPEN (0x86)
> scancode 0xfe1a = KEY_DVD (0x185)
> scancode 0xfe1b = KEY_3 (0x04)
> scancode 0xfe1e = KEY_FAVORITES (0x16c)
> scancode 0xfe1f = KEY_ZOOM (0x174)
> scancode 0xfe42 = KEY_ENTER (0x1c)
> scancode 0xfe43 = KEY_REWIND (0xa8)
> scancode 0xfe46 = KEY_POWER2 (0x164)
> scancode 0xfe47 = KEY_PLAYPAUSE (0xa4)
> scancode 0xfe48 = KEY_7 (0x08)
> scancode 0xfe49 = KEY_BACK (0x9e)
> scancode 0xfe4c = KEY_8 (0x09)
> scancode 0xfe4d = KEY_MENU (0x8b)
> scancode 0xfe4e = KEY_POWER (0x74)
> scancode 0xfe4f = KEY_FASTFORWARD (0xd0)
> scancode 0xfe50 = KEY_5 (0x06)
> scancode 0xfe51 = KEY_UP (0x67)
> scancode 0xfe52 = KEY_CAMERA (0xd4)
> scancode 0xfe53 = KEY_DOWN (0x6c)
> scancode 0xfe54 = KEY_6 (0x07)
> scancode 0xfe55 = KEY_TAB (0x0f)
> scancode 0xfe57 = KEY_MUTE (0x71)
> scancode 0xfe58 = KEY_9 (0x0a)
> scancode 0xfe59 = KEY_INFO (0x166)
> scancode 0xfe5a = KEY_TUNER (0x182)
> scancode 0xfe5b = KEY_LEFT (0x69)
> scancode 0xfe5e = KEY_OK (0x160)
> scancode 0xfe5f = KEY_RIGHT (0x6a)
> 
> # ir-keytable -s rc1 -t
> Testing events. Please, press CTRL-C to abort.
> 1479985656.760267: event type EV_MSC(0x04): scancode = 0xfe47
> 1479985656.760267: event type EV_KEY(0x01) key_down: KEY_PLAYPAUSE(0x00a4)
> 1479985656.760267: event type EV_SYN(0x00).
> 1479985657.011045: event type EV_KEY(0x01) key_up: KEY_PLAYPAUSE(0x00a4)
> 1479985657.011045: event type EV_SYN(0x00).
> 1479985671.812267: event type EV_MSC(0x04): scancode = 0xfe53
> 1479985671.812267: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
> 1479985671.812267: event type EV_SYN(0x00).
> 1479985672.063048: event type EV_KEY(0x01) key_up: KEY_DOWN(0x006c)
> 1479985672.063048: event type EV_SYN(0x00).
> 1479985674.520279: event type EV_MSC(0x04): scancode = 0xfe52
> 1479985674.520279: event type EV_KEY(0x01) key_down: KEY_CAMERA(0x00d4)
> 1479985674.520279: event type EV_SYN(0x00).
> 1479985674.771044: event type EV_KEY(0x01) key_up: KEY_CAMERA(0x00d4)
> 1479985674.771044: event type EV_SYN(0x00).
> 1479985675.628312: event type EV_MSC(0x04): scancode = 0xfe4d
> 1479985675.628312: event type EV_KEY(0x01) key_down: KEY_MENU(0x008b)
> 1479985675.628312: event type EV_SYN(0x00).
> 1479985675.879045: event type EV_KEY(0x01) key_up: KEY_MENU(0x008b)
> 1479985675.879045: event type EV_SYN(0x00).
> 1479985677.732236: event type EV_MSC(0x04): scancode = 0xfe49
> 1479985677.732236: event type EV_KEY(0x01) key_down: KEY_BACK(0x009e)
> 1479985677.732236: event type EV_SYN(0x00).
> 1479985677.983043: event type EV_KEY(0x01) key_up: KEY_BACK(0x009e)
> 1479985677.983043: event type EV_SYN(0x00).
> 1479985687.464239: event type EV_MSC(0x04): scancode = 0xfe5e
> 1479985687.464239: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
> 1479985687.464239: event type EV_SYN(0x00).
> 1479985687.715043: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
> 1479985687.715043: event type EV_SYN(0x00).
> 1479985696.396382: event type EV_MSC(0x04): scancode = 0xfe42
> 1479985696.396382: event type EV_KEY(0x01) key_down: KEY_ENTER(0x001c)
> 1479985696.396382: event type EV_SYN(0x00).
> 1479985696.647049: event type EV_KEY(0x01) key_up: KEY_ENTER(0x001c)
> 1479985696.647049: event type EV_SYN(0x00).
> 1479985701.220194: event type EV_MSC(0x04): scancode = 0xfe0d
> 1479985701.220194: event type EV_KEY(0x01) key_down: KEY_STOP(0x0080)
> 1479985701.220194: event type EV_SYN(0x00).
> 1479985701.471047: event type EV_KEY(0x01) key_up: KEY_STOP(0x0080)
> 1479985701.471047: event type EV_SYN(0x00).
> ^C
> 
> # diff  dvice_mce dvico_mce_new
> --- dvico_mce   2016-11-24 22:18:48.000000000 +1100
> +++ dvico_mce_new   2016-11-24 22:11:02.000000000 +1100
> @@ -12,7 +12,7 @@
>  0xfe5b KEY_LEFT
>  0xfe5f KEY_RIGHT
>  0xfe53 KEY_DOWN
> -0xfe5e KEY_OK
> +0xfe5e KEY_ENTER
>  0xfe59 KEY_INFO
>  0xfe55 KEY_TAB
>  0xfe0f KEY_PREVIOUSSONG
> 
> # ir-keyable -v -s rc1 -c
> Found device /sys/class/rc/rc0/
> Found device /sys/class/rc/rc1/
> Found device /sys/class/rc/rc2/
> Input sysfs node is /sys/class/rc/rc1/input18/
> Event sysfs node is /sys/class/rc/rc1/input18/event15/
> Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
> /sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
> /sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
> /sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
> Parsing uevent /sys/class/rc/rc1/uevent
> /sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
> /sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
> input device is /dev/input/event15
> /sys/class/rc/rc1/protocols protocol unknown (disabled)
> Opening /dev/input/event15
> Input Protocol version: 0x00010001
> Deleting entry 1
> Deleting entry 2
> Deleting entry 3
> Deleting entry 4
> Deleting entry 5
> Deleting entry 6
> Deleting entry 7
> Deleting entry 8
> Deleting entry 9
> Deleting entry 10
> Deleting entry 11
> Deleting entry 12
> Deleting entry 13
> Deleting entry 14
> Deleting entry 15
> Deleting entry 16
> Deleting entry 17
> Deleting entry 18
> Deleting entry 19
> Deleting entry 20
> Deleting entry 21
> Deleting entry 22
> Deleting entry 23
> Deleting entry 24
> Deleting entry 25
> Deleting entry 26
> Deleting entry 27
> Deleting entry 28
> Deleting entry 29
> Deleting entry 30
> Deleting entry 31
> Deleting entry 32
> Deleting entry 33
> Deleting entry 34
> Deleting entry 35
> Deleting entry 36
> Deleting entry 37
> Deleting entry 38
> Deleting entry 39
> Deleting entry 40
> Deleting entry 41
> Deleting entry 42
> Deleting entry 43
> Deleting entry 44
> Deleting entry 45
> Deleting entry 46
> Old keytable cleared
> 
> # ir-keyable -v -s rc1 -w dvico-mce-new
> Parsing ./dvico_mce_new keycode file
> parsing 0xfe02=KEY_TV:	value=377
> parsing 0xfe0e=KEY_MP3:	value=391
> parsing 0xfe1a=KEY_DVD:	value=389
> parsing 0xfe1e=KEY_FAVORITES:	value=364
> parsing 0xfe16=KEY_SETUP:	value=141
> parsing 0xfe46=KEY_POWER2:	value=356
> parsing 0xfe0a=KEY_EPG:	value=365
> parsing 0xfe49=KEY_BACK:	value=158
> parsing 0xfe4d=KEY_MENU:	value=139
> parsing 0xfe51=KEY_UP:	value=103
> parsing 0xfe5b=KEY_LEFT:	value=105
> parsing 0xfe5f=KEY_RIGHT:	value=106
> parsing 0xfe53=KEY_DOWN:	value=108
> parsing 0xfe5e=KEY_ENTER:	value=28
> parsing 0xfe59=KEY_INFO:	value=358
> parsing 0xfe55=KEY_TAB:	value=15
> parsing 0xfe0f=KEY_PREVIOUSSONG:	value=165
> parsing 0xfe12=KEY_NEXTSONG:	value=163
> parsing 0xfe42=KEY_ENTER:	value=28
> parsing 0xfe15=KEY_VOLUMEUP:	value=115
> parsing 0xfe05=KEY_VOLUMEDOWN:	value=114
> parsing 0xfe11=KEY_CHANNELUP:	value=402
> parsing 0xfe09=KEY_CHANNELDOWN:	value=403
> parsing 0xfe52=KEY_CAMERA:	value=212
> parsing 0xfe5a=KEY_TUNER:	value=386
> parsing 0xfe19=KEY_OPEN:	value=134
> parsing 0xfe0b=KEY_1:	value=2
> parsing 0xfe17=KEY_2:	value=3
> parsing 0xfe1b=KEY_3:	value=4
> parsing 0xfe07=KEY_4:	value=5
> parsing 0xfe50=KEY_5:	value=6
> parsing 0xfe54=KEY_6:	value=7
> parsing 0xfe48=KEY_7:	value=8
> parsing 0xfe4c=KEY_8:	value=9
> parsing 0xfe58=KEY_9:	value=10
> parsing 0xfe13=KEY_ANGLE:	value=371
> parsing 0xfe03=KEY_0:	value=11
> parsing 0xfe1f=KEY_ZOOM:	value=372
> parsing 0xfe43=KEY_REWIND:	value=168
> parsing 0xfe47=KEY_PLAYPAUSE:	value=164
> parsing 0xfe4f=KEY_FASTFORWARD:	value=208
> parsing 0xfe57=KEY_MUTE:	value=113
> parsing 0xfe0d=KEY_STOP:	value=128
> parsing 0xfe01=KEY_RECORD:	value=167
> parsing 0xfe4e=KEY_POWER:	value=116
> Read dvico_mce table
> Found device /sys/class/rc/rc0/
> Found device /sys/class/rc/rc1/
> Found device /sys/class/rc/rc2/
> Input sysfs node is /sys/class/rc/rc1/input18/
> Event sysfs node is /sys/class/rc/rc1/input18/event15/
> Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
> /sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
> /sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
> /sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
> Parsing uevent /sys/class/rc/rc1/uevent
> /sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
> /sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
> input device is /dev/input/event15
> /sys/class/rc/rc1/protocols protocol unknown (disabled)
> Opening /dev/input/event15
> Input Protocol version: 0x00010001
> 	fe4e=0074
> 	fe01=00a7
> 	fe0d=0080
> 	fe57=0071
> 	fe4f=00d0
> 	fe47=00a4
> 	fe43=00a8
> 	fe1f=0174
> 	fe03=000b
> 	fe13=0173
> 	fe58=000a
> 	fe4c=0009
> 	fe48=0008
> 	fe54=0007
> 	fe50=0006
> 	fe07=0005
> 	fe1b=0004
> 	fe17=0003
> 	fe0b=0002
> 	fe19=0086
> 	fe5a=0182
> 	fe52=00d4
> 	fe09=0193
> 	fe11=0192
> 	fe05=0072
> 	fe15=0073
> 	fe42=001c
> 	fe12=00a3
> 	fe0f=00a5
> 	fe55=000f
> 	fe59=0166
> 	fe5e=001c
> 	fe53=006c
> 	fe5f=006a
> 	fe5b=0069
> 	fe51=0067
> 	fe4d=008b
> 	fe49=009e
> 	fe0a=016d
> 	fe46=0164
> 	fe16=008d
> 	fe1e=016c
> 	fe1a=0185
> 	fe0e=0187
> 	fe02=0179
> Wrote 45 keycode(s) to driver
> /sys/class/rc/rc1//protocols: Invalid argument
> Couldn't change the IR protocols
> 
> # ir-keyable -v -s rc1 -r
> Found device /sys/class/rc/rc0/
> Found device /sys/class/rc/rc1/
> Found device /sys/class/rc/rc2/
> Input sysfs node is /sys/class/rc/rc1/input18/
> Event sysfs node is /sys/class/rc/rc1/input18/event15/
> Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
> /sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
> /sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
> /sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
> Parsing uevent /sys/class/rc/rc1/uevent
> /sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
> /sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
> input device is /dev/input/event15
> /sys/class/rc/rc1/protocols protocol unknown (disabled)
> Opening /dev/input/event15
> Input Protocol version: 0x00010001
> Enabled protocols: 
> scancode 0xfe01 = KEY_RECORD (0xa7)
> scancode 0xfe02 = KEY_TV (0x179)
> scancode 0xfe03 = KEY_0 (0x0b)
> scancode 0xfe05 = KEY_VOLUMEDOWN (0x72)
> scancode 0xfe07 = KEY_4 (0x05)
> scancode 0xfe09 = KEY_CHANNELDOWN (0x193)
> scancode 0xfe0a = KEY_EPG (0x16d)
> scancode 0xfe0b = KEY_1 (0x02)
> scancode 0xfe0d = KEY_STOP (0x80)
> scancode 0xfe0e = KEY_MP3 (0x187)
> scancode 0xfe0f = KEY_PREVIOUSSONG (0xa5)
> scancode 0xfe11 = KEY_CHANNELUP (0x192)
> scancode 0xfe12 = KEY_NEXTSONG (0xa3)
> scancode 0xfe13 = KEY_ANGLE (0x173)
> scancode 0xfe15 = KEY_VOLUMEUP (0x73)
> scancode 0xfe16 = KEY_SETUP (0x8d)
> scancode 0xfe17 = KEY_2 (0x03)
> scancode 0xfe19 = KEY_OPEN (0x86)
> scancode 0xfe1a = KEY_DVD (0x185)
> scancode 0xfe1b = KEY_3 (0x04)
> scancode 0xfe1e = KEY_FAVORITES (0x16c)
> scancode 0xfe1f = KEY_ZOOM (0x174)
> scancode 0xfe42 = KEY_ENTER (0x1c)
> scancode 0xfe43 = KEY_REWIND (0xa8)
> scancode 0xfe46 = KEY_POWER2 (0x164)
> scancode 0xfe47 = KEY_PLAYPAUSE (0xa4)
> scancode 0xfe48 = KEY_7 (0x08)
> scancode 0xfe49 = KEY_BACK (0x9e)
> scancode 0xfe4c = KEY_8 (0x09)
> scancode 0xfe4d = KEY_MENU (0x8b)
> scancode 0xfe4e = KEY_POWER (0x74)
> scancode 0xfe4f = KEY_FASTFORWARD (0xd0)
> scancode 0xfe50 = KEY_5 (0x06)
> scancode 0xfe51 = KEY_UP (0x67)
> scancode 0xfe52 = KEY_CAMERA (0xd4)
> scancode 0xfe53 = KEY_DOWN (0x6c)
> scancode 0xfe54 = KEY_6 (0x07)
> scancode 0xfe55 = KEY_TAB (0x0f)
> scancode 0xfe57 = KEY_MUTE (0x71)
> scancode 0xfe58 = KEY_9 (0x0a)
> scancode 0xfe59 = KEY_INFO (0x166)
> scancode 0xfe5a = KEY_TUNER (0x182)
> scancode 0xfe5b = KEY_LEFT (0x69)
> scancode 0xfe5e = KEY_ENTER (0x1c)    ##NB
> scancode 0xfe5f = KEY_RIGHT (0x6a)
> 
> # cat /sys/class/rc/rc1/protocols
> unknown

That all looks fine.

> Mapping KEY_OK to KEY_ENTER worked (ie the behaviour when the
> OK key was pressed changed), but others did not. For example
> I mapped KEY_BACK (0x9e, decimal 158) to KEY_ESC (001)
> and KEY_PLAYPAUSE (0xa4, 164) to KEY_PAUSE (119).
> But I did not observe any change in behaviour for these two.
> ir-keytable -t did show the correct KEY_foo and descimal code, eg.
> # ir-keytable -s rc1 -t
> Testing events. Please, press CTRL-C to abort.
> 1479989250.528206: event type EV_MSC(0x04): scancode = 0xfe47
> 1479989250.528206: event type EV_KEY(0x01) key_down: KEY_PAUSE(0x0077)
> 1479989250.528206: event type EV_SYN(0x00).
> 1479989250.779044: event type EV_KEY(0x01) key_up: KEY_PAUSE(0x0077)
> 1479989250.779044: event type EV_SYN(0x00).
> ^C

So if I understand you correctly, if you change the keymap, like you
changed 0xfe47 to KEY_PAUSE, then "ir-keytable -s rc1 -t" show you the
correct (new) key? So as far as ir-keytable is concerned, everything
works?

However when you try to use the new mapping in some application then
it does not work?

> I notice that KEY_ENTER existed in the original keymap but _PAUSE
> and _ESC don't, but I don't understand the significance of that.

I don't know how that should matter.

Thanks
Sean
