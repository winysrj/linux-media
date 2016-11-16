Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:34286 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbcKPLAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 06:00:34 -0500
Received: by mail-pg0-f50.google.com with SMTP id x23so75387198pgx.1
        for <linux-media@vger.kernel.org>; Wed, 16 Nov 2016 03:00:34 -0800 (PST)
Received: from shambles.local (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id p125sm1926745pfg.33.2016.11.16.02.53.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Nov 2016 02:53:09 -0800 (PST)
Date: Wed, 16 Nov 2016 21:52:58 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: ir-keytable: infinite loops, segfaults
Message-ID: <20161116105256.GA9998@shambles.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a fairly old dvico dual digital 4 tuner and remote.
There seem to be some issues with support for it, can I help fix them?

I am using ir-keytable 1.10.0-1 on Ubuntu 16.04 LTS,
with kernel 4.4.0-47-generic (package version 4.4.0-47-generic)

The remote's keymapping is the one in /lib/udev/rc_keymaps/dvico_mce;
kernel support for the device is in media/usb/dvb-usb/cxusb.c.

Mostly it works, in that I get correct keycodes back from evtest
and ir-keytable -t. But I want to change some of the keycode mappings
and that is not working.

  # cat >testfile
  0xfe47 KEY_PAUSE
  ^D
  
  # ir-keytable -v -d /dev/input/event15 -w testfile
  Parsing testfile keycode file
  parsing 0xfe47=KEY_PAUSE:   value=119
  Opening /dev/input/event15
  Input Protocol version: 0x00010001
      fe47=0077
  Wrote 1 keycode(s) to driver

So far so good, yes? But evtest still reports the same keycode
for the key I tried to modify.

  # evtest
  <select device 15>
  <press PLAYPAUSE key on remote>
  Event: time 1479206112.262746, type 1 (EV_KEY), code 164 (KEY_PLAYPAUSE), value 1
  Event: time 1479206112.262746, -------------- SYN_REPORT ------------
  Event: time 1479206112.262760, type 1 (EV_KEY), code 164 (KEY_PLAYPAUSE), value 0
  Event: time 1479206112.262760, -------------- SYN_REPORT ------------
 
  # irkeytable -r -d /dev/input/event15 |grep PAUSE
  Enabled protocols: unknown rc-5 sony nec sanyo mce-kbd rc-6 sharp xmp 
  scancode 0xfe02 = KEY_PAUSE (0x77)
  scancode 0xfe47 = KEY_PLAYPAUSE (0xa4)

I thought that I might need to clear and replace the entire table
to get things working. This is where the problems really start.

First trying to clear the table causes an infinite loop.

  # ir-keytable -d /dev/input/event15 -c
  Opening /dev/input/event15
  Input Protocol version: 0x00010001
  Deleting entry 1
  Deleting entry 2
  Deleting entry 3
  Deleting entry 4
  ....
  Deleting entry 2114689
  Deleting entry 2114690
  ^C

Then I tried to load a modified version of dvico_mce
The whole file was there, with just this change:
--- dvico_mce   2016-11-13 22:50:11.442092350 +1100
+++ testfile    2016-11-16 20:46:29.361411631 +1100
@@ -38,7 +38,7 @@
 0xfe03 KEY_0
 0xfe1f KEY_ZOOM
 0xfe43 KEY_REWIND
-0xfe47 KEY_PLAYPAUSE
+0xfe47 KEY_PAUSE
 0xfe4f KEY_FASTFORWARD
 0xfe57 KEY_MUTE
 0xfe0d KEY_STOP

The program seems to parse the modified file ok but then
segaults while reading from the input device.

  # ir-keytable -v -d /dev/input/event15 -w testfile
  Parsing testfile keycode file
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
  parsing 0xfe47=KEY_PAUSE:   value=119
  parsing 0xfe4f=KEY_FASTFORWARD: value=208
  parsing 0xfe57=KEY_MUTE:    value=113
  parsing 0xfe0d=KEY_STOP:    value=128
  parsing 0xfe01=KEY_RECORD:  value=167
  parsing 0xfe4e=KEY_POWER:   value=116
  Read dvico_mce table
  Opening /dev/input/event15
  Input Protocol version: 0x00010001
      fe4e=0074
      fe01=00a7
      fe0d=0080
      fe57=0071
      fe4f=00d0
      fe47=0077
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
  Segmentation fault (core dumped)
 
Is this just operator error?
What further diagnostics would help?

Vince

PS evtest reports this about the device:
  # evtest /dev/input/event15
  Input driver version is 1.0.1
  Input device ID: bus 0x3 vendor 0xfe9 product 0xdb78 version 0x827b
  Input device name: "IR-receiver inside an USB DVB receiver"
  Supported events:
    Event type 0 (EV_SYN)
    Event type 1 (EV_KEY)
    ...<elided>...
    Event code 403 (KEY_CHANNELDOWN)
  Properties:
  Testing ... (interrupt to exit)
  ^C
