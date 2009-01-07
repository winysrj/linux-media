Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.sissa.it ([147.122.11.135])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nsoranzo@tiscali.it>) id 1LKe7p-0007A5-UY
	for linux-dvb@linuxtv.org; Wed, 07 Jan 2009 20:31:37 +0100
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Date: Wed, 7 Jan 2009 20:31:27 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PMQZJND90vDgN/n"
Message-Id: <200901072031.27852.nsoranzo@tiscali.it>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] No audio with Hauppauge WinTV-HVR-900 (R2)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi everybody,
I have a Hauppauge WinTV-HVR-900 (R2) USB stick, model 65018, which has 
Empiatech Em2880 chip, Xceive XC3028 tuner and Micronas drx397x DVB-T 
demodulator.
On the same laptop I have an Intel High Definition Audio soundcard and a Syntek 
DC-1125 webcam.

Both analog and DVB-T work under Windows.
I'm using v4l-dvb from hg repo over Fedora 10 kernel 2.6.27.9 and I have 
correctly installed xc3028-v27.fw firmware.
I know that DVB-T chip is not yet supported, so I tried with analog TV.
I can see analog video, but no audio with any program I used (tvtime, xawtv, 
MythTV).
I'm attaching the part of /var/log/messages after the stick attach and the 
output of the following commands:
aplay -l
arecord -l
cat /proc/asound/cards
cat /proc/asound/devices
cat /proc/asound/modules
cat /proc/asound/pcm

If any other information may be useful, just ask.
Thanks in advance for your help,
Nicola


--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8";
  name="var.log.messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="var.log.messages"

Jan  7 10:15:26 ozzy kernel: usb 1-1: new high speed USB device using ehci_hcd and address 3
Jan  7 10:15:26 ozzy kernel: usb 1-1: configuration #1 chosen from 1 choice
Jan  7 10:15:26 ozzy kernel: usb 1-1: New USB device found, idVendor=2040, idProduct=6502
Jan  7 10:15:26 ozzy kernel: usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
Jan  7 10:15:26 ozzy kernel: usb 1-1: Product: WinTV HVR-900
Jan  7 10:15:26 ozzy kernel: usb 1-1: SerialNumber: 4030546469
Jan  7 10:15:26 ozzy kernel: em28xx: New device WinTV HVR-900 @ 480 Mbps (2040:6502, interface 0, class 0)
Jan  7 10:15:26 ozzy kernel: em28xx #0: Identified as Hauppauge WinTV HVR 900 (R2) (card=18)
Jan  7 10:15:26 ozzy kernel: em28xx #0: chip ID is em2882/em2883
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a 18
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 70: 33 00 30 00 35 00 34 00 36 00 34 00 36 00 39 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 25 42
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom c0: 3d f0 74 02 01 00 01 79 96 00 00 00 00 00 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 25 42
Jan  7 10:15:26 ozzy kernel: em28xx #0: i2c eeprom f0: 3d f0 74 02 01 00 01 79 96 00 00 00 00 00 00 00
Jan  7 10:15:26 ozzy kernel: em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x353f3fdd
Jan  7 10:15:26 ozzy kernel: em28xx #0: EEPROM info:
Jan  7 10:15:26 ozzy kernel: em28xx #0:	AC97 audio (5 sample rates)
Jan  7 10:15:26 ozzy kernel: em28xx #0:	500mA max power
Jan  7 10:15:26 ozzy kernel: em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
Jan  7 10:15:26 ozzy kernel: tveeprom 1-0050: Hauppauge model 65018, rev B3C0, serial# 4014629
Jan  7 10:15:26 ozzy kernel: tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
Jan  7 10:15:26 ozzy kernel: tveeprom 1-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
Jan  7 10:15:26 ozzy kernel: tveeprom 1-0050: audio processor is None (idx 0)
Jan  7 10:15:26 ozzy kernel: tveeprom 1-0050: has radio
Jan  7 10:15:27 ozzy kernel: tvp5150' 1-005c: chip found @ 0xb8 (em28xx #0)
Jan  7 10:15:27 ozzy kernel: tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
Jan  7 10:15:27 ozzy kernel: xc2028 1-0061: creating new instance
Jan  7 10:15:27 ozzy kernel: xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
Jan  7 10:15:27 ozzy kernel: firmware: requesting xc3028-v27.fw
Jan  7 10:15:27 ozzy kernel: xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Jan  7 10:15:27 ozzy kernel: xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
Jan  7 10:15:28 ozzy kernel: xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
Jan  7 10:15:28 ozzy kernel: xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
Jan  7 10:15:28 ozzy kernel: em28xx #0: Config register raw data: 0xd0
Jan  7 10:15:28 ozzy kernel: em28xx #0: AC97 vendor ID = 0xffffffff
Jan  7 10:15:28 ozzy kernel: em28xx #0: AC97 features = 0x6a90
Jan  7 10:15:28 ozzy kernel: em28xx #0: Empia 202 AC97 audio processor detected
Jan  7 10:15:28 ozzy kernel: tvp5150' 1-005c: tvp5150am1 detected.
Jan  7 10:15:28 ozzy kernel: em28xx #0: v4l2 driver version 0.1.1
Jan  7 10:15:28 ozzy kernel: em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
Jan  7 10:15:28 ozzy kernel: usbcore: registered new interface driver em28xx
Jan  7 10:15:28 ozzy kernel: em28xx driver loaded
Jan  7 10:15:28 ozzy kernel: em28xx-audio.c: probing for em28x1 non standard usbaudio
Jan  7 10:15:28 ozzy kernel: em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Jan  7 10:15:28 ozzy kernel: Em28xx: Initialized (Em28xx Audio Extension) extension
Jan  7 10:15:28 ozzy kernel: tvp5150' 1-005c: tvp5150am1 detected.

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8";
  name="aplay-l"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aplay-l"

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC880 Analog [ALC880 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: ALC880 Digital [ALC880 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8";
  name="arecord-l"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="arecord-l"

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC880 Analog [ALC880 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 2: ALC880 Analog [ALC880 Analog]
  Subdevices: 2/2
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
card 1: default [USB2.0 Video       ], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8";
  name="proc.asound.cards"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc.asound.cards"

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xfebf8000 irq 16
 1 [default        ]: USB-Audio - USB2.0 Video       
                      Syntek Semicon.     USB2.0 Video        at usb-0000:00:1d.7-5, high speed
 2 [Em28xx Audio   ]: Empia Em28xx AudEm28xx Audio - Em28xx Audio
                      Empia Em28xx Audio

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8";
  name="proc.asound.devices"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc.asound.devices"

  2:        : timer
  3: [ 1- 0]: digital audio capture
  4: [ 1]   : control
  5:        : sequencer
  6: [ 0- 2]: digital audio capture
  7: [ 0- 1]: digital audio playback
  8: [ 0- 0]: digital audio playback
  9: [ 0- 0]: digital audio capture
 10: [ 0- 1]: hardware dependent
 11: [ 0- 0]: hardware dependent
 12: [ 0]   : control
 13: [ 2- 0]: digital audio capture
 14: [ 2]   : control

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8";
  name="proc.asound.modules"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc.asound.modules"

 0 snd_hda_intel
 1 snd_usb_audio
 2 em28xx_alsa

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain;
  charset="utf-8";
  name="proc.asound.pcm"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc.asound.pcm"

00-00: ALC880 Analog : ALC880 Analog : playback 1 : capture 1
00-01: ALC880 Digital : ALC880 Digital : playback 1
00-02: ALC880 Analog : ALC880 Analog : capture 2
01-00: USB Audio : USB Audio : capture 1
02-00: Em28xx Audio : Empia 28xx Capture : capture 1

--Boundary-00=_PMQZJND90vDgN/n
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_PMQZJND90vDgN/n--
