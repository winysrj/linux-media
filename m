Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42884 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1CMIN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2011 04:13:59 -0400
Received: by bwz15 with SMTP id 15so3708128bwz.19
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 00:13:58 -0800 (PST)
Message-ID: <4D7C7CC0.2050804@gmail.com>
Date: Sun, 13 Mar 2011 10:13:52 +0200
From: tosiara <tosiara@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: RE: Problems with analog sound on Pinnacle Dazzle TV hybrid USB stick
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm having similar issue with another em28xx based analog tv tuner: USB
KWorld PVR-TV 305U

I will start separate thread for my issue

Could you let me know what version of kernel and ALSA are you using?

Thanks,

tosiara





Cite:
-----------

Hi all,

I have read serveral newsgroups about this problem and did not find any 
solution.

The closest to a solution was a suggestion to install a em28xx-new module but 


it is no longer available.

I have loaded em28xx em28xx-alsa and em28xx-dvb with this output ( I have 
forced the card on 56 using options em28xx card=56)


[51556.500765] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, 


interface 0, class 0)
[51556.500949] em28xx #0: chip ID is em2882/em2883
[51556.687042] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 
20 6a 00
[51556.687056] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 


02 00 00
[51556.687068] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 
1e 00 00
[51556.687080] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 
00 00 00
[51556.687091] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 


00 00 00
[51556.687102] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[51556.687114] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 
00 53 00
[51556.687125] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 


00 56 00
[51556.687137] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 
00 00 00
[51556.687148] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[51556.687160] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 


00 00 00
[51556.687171] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[51556.687182] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[51556.687194] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 


00 00 00
[51556.687205] em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17 98 01 00 
00 00 00
[51556.687216] em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00 00 00 00 
00 00 00
[51556.687229] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb8846b20


[51556.687232] em28xx #0: EEPROM info:
[51556.687234] em28xx #0:       AC97 audio (5 sample rates)
[51556.687236] em28xx #0:       USB Remote wakeup capable
[51556.687238] em28xx #0:       500mA max power
[51556.687241] em28xx #0:       Table at 0x04, strings=0x206a, 0x006a, 0x0000


[51556.687915] em28xx #0: Identified as Pinnacle Hybrid Pro (card=53)
[51556.690103] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[51556.694727] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[51556.694862] xc2028 1-0061: creating new instance


[51556.694864] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[51556.694872] usb 2-6: firmware: requesting xc3028-v27.fw
[51556.696352] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, 
type: xc2028 firmware, ver 2.7


[51556.752531] xc2028 1-0061: Loading firmware for type=BASE (1), id 
0000000000000000.
[51557.679461] xc2028 1-0061: Loading firmware for type=(0), id 
000000000000b700.
[51557.693080] SCODE (20000000), id 000000000000b700:


[51557.693088] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 
(60008000), id 0000000000008000.
[51557.900062] em28xx #0: Config register raw data: 0x58
[51557.900812] em28xx #0: AC97 vendor ID = 0xffffffff


[51557.901178] em28xx #0: AC97 features = 0x6a90
[51557.901181] em28xx #0: Empia 202 AC97 audio processor detected
[51558.050427] tvp5150 1-005c: tvp5150am1 detected.
[51558.153287] em28xx #0: v4l2 driver version 0.1.2


[51558.237283] em28xx #0: V4L2 video device registered as /dev/video1
[51558.237287] em28xx #0: V4L2 VBI device registered as /dev/vbi1
[51558.250087] usbcore: registered new interface driver em28xx
[51558.250092] em28xx driver loaded


[51558.420877] xc2028 1-0061: attaching existing instance
[51558.420881] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[51558.420884] em28xx #0/2: xc3028 attached
[51558.420888] DVB: registering new adapter (em28xx #0)


[51558.420893] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[51558.421536] Successfully loaded em28xx-dvb
[51558.421540] Em28xx: Initialized (Em28xx dvb Extension) extension
[51558.421968] Em28xx: Initialized (Em28xx Audio Extension) extension


[51560.520457] tvp5150 1-005c: tvp5150am1 detected.
[51561.024168] tvp5150 1-005c: tvp5150am1 detected.
[51561.332517] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
[51562.259446] (0), id 00000000000000ff:


[51562.259452] xc2028 1-0061: Loading firmware for type=(0), id 
0000000100000007.
[51562.273059] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 
(60008000), id 0000000f0000000

I can get video. I see in alsa a third card (in fact I have a second internal 


TV capture card)
But I cannot get sound out of it.

I used mplayer to play TV.  I did get no errors about opening the card but 
again no sound.
I used this command :

mplayer -tv 
immediatemode=0:outfmt=yuy2:width=768:height=576:adevice=hw.2,0:forceaudio:alsa:amode=1:norm=PAL:normid=5:chanlist=europe-west:freq=203.25:device=/dev/video1:input=0


 tv://

(I also tried hw.1,0 or /dev/dsp(x)

help greatly appreciated

Thx
W

