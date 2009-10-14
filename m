Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:55275 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbZJNOHl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 10:07:41 -0400
Received: by yxe26 with SMTP id 26so5359418yxe.4
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 07:07:05 -0700 (PDT)
Date: Wed, 14 Oct 2009 16:06:26 +0200
From: Giuseppe Borzi <gborzi@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
Message-ID: <20091014160626.70db928b@ieee.org>
In-Reply-To: <829197380910140612t726251d6y7cff3873587101b4@mail.gmail.com>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
	<20091014122550.7c84bba5@ieee.org>
	<829197380910140612t726251d6y7cff3873587101b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/wovrb+yx1Xde66BsF98i2Co"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/wovrb+yx1Xde66BsF98i2Co
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


> Did you run "make unload" before you plugged in the device?
> 
> Do me a favor - unplug the device, reboot the PC, plug it back in and
> see if it still happens.  I just want to be sure this isn't some sort
> of issue with conflict between the new and old modules before I debug
> this any further.
> 
> Thanks,
> 
> Devin
> 

Hello Devin,
I did as you suggested. Unplugged the stick reboot and plug it again.
And just to be sure I did it two times. Now the device works, but it is
unable to change channel. That is to say, when I use the command "vlc
channels.conf" it tunes to the first station in the channel file and
can't change it. Other apps (xine, kaffeine) that seems to change to
the latest channel don't work at all. The dmesg output after plugging
the driver is in attach. In dmesg I noticed lines like this 

[drm] TV-14: set mode NTSC 480i 0

I suppose this hasn't anything to do with the analog audio problem, but
just to be sure I ask you. Also, using arecord/aplay for analog audio I
get an "underrun" error message

arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -
Recording WAVE 'stdin' : Signed 16 bit Little Endian, Rate 32000 Hz,
Stereo Playing WAVE 'stdin' : Signed 16 bit Little Endian, Rate 32000
Hz, Stereo underrun!!! (at least -1255527098942.108 ms long)

Cheers.

-- 
***********************************************************
  Giuseppe Borzi, Assistant Professor at the
  University of Messina - Department of Civil Engineering
  Address: Contrada di Dio, Messina, I-98166, Italy
  Tel:     +390903977323
  Fax:     +390903977480
  email:   gborzi@ieee.org
  url:     http://ww2.unime.it/dic/gborzi/index.php
***********************************************************

--MP_/wovrb+yx1Xde66BsF98i2Co
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.txt

usb 1-3.1: new high speed USB device using ehci_hcd and address 7
usb 1-3.1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class 0)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17 98 01 00 00 00 00
em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb8846b20
em28xx #0: EEPROM info:
em28xx #0:	AC97 audio (5 sample rates)
em28xx #0:	USB Remote wakeup capable
em28xx #0:	500mA max power
em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on eeprom hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
em28xx #0: Board detected as Pinnacle Hybrid Pro
tvp5150 2-005c: chip found @ 0xb8 (em28xx #0)
tuner 2-0061: chip found @ 0xc2 (em28xx #0)
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
usb 1-3.1: firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
em28xx #0: Config register raw data: 0x58
em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 2-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as /dev/video0
em28xx #0: V4L2 VBI device registered as /dev/vbi0
em28xx audio device (eb1a:2881): interface 1, class 1
em28xx audio device (eb1a:2881): interface 2, class 1
usbcore: registered new interface driver em28xx
em28xx driver loaded
usbcore: registered new interface driver snd-usb-audio
tvp5150 2-005c: tvp5150am1 detected.
xc2028 2-0061: attaching existing instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
em28xx #0/2: xc3028 attached
DVB: registering new adapter (em28xx #0)
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Successfully loaded em28xx-dvb
Em28xx: Initialized (Em28xx dvb Extension) extension

--MP_/wovrb+yx1Xde66BsF98i2Co--
