Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from linux17.grserver.gr ([64.34.176.211])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <opensource@andmarios.com>) id 1MsIV2-0004oY-HT
	for linux-dvb@linuxtv.org; Mon, 28 Sep 2009 17:50:53 +0200
From: Marios Andreopoulos <opensource@andmarios.com>
To: linux-dvb@linuxtv.org
Date: Mon, 28 Sep 2009 18:50:25 +0300
MIME-Version: 1.0
Message-Id: <200909281850.25492.opensource@andmarios.com>
Subject: [linux-dvb] KWORLD 323U,
	kernel panic when trying to access ALSA interface
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,
I own a KWORLD 323U USB hybrid tv tuner.

My problem is about the analog sound. When I am trying to access the alsa audio interface of this device I get kernel panics.
I use commands like these in order to transfer audio from the tuner to my sound card:
$ sox -r 48000 -c 2 -v 1 -t alsa hw:1 -t alsa hw:0
$ arecord -D hw:1 | aplay -D hw:0 -

When I use OSS I generally do not get kernel panics, although I have them on some occasions:
$ sox -r 48000 -c 2 -v 1 -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp

A couple of times, after playing with OSS (changing sample rate or number of channels) I managed to use ALSA without a kernel panic but I didn't manage to find a workflow that will allow me to use ALSA every time.

I have tried both the in kernel drivers (kernel version 2.6.31) and the latest drivers from the Hg tree as described in http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

I would appreciate any help as OSS gives me a terrible audio lag and ALSA -both times I managed it to work- seemed to not have any significant audio lag.

In case there is anyone interested in this tuner I will add that I haven't managed to get DVB-T or the remote to work.

My dmesg output in case it helps:

usb 2-1.2: new high speed USB device using ehci_hcd and address 9                            
usb 2-1.2: configuration #1 chosen from 1 choice                                             
em28xx: New device USB 2883 Device @ 480 Mbps (eb1a:e323, interface 0, class 0)              
em28xx #0: chip ID is em2882/em2883                                                          
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 23 e3 d0 12 5c 00 6a 22 00 00                    
em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00                    
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00                    
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00                    
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 33 00 20 00 44 00                    
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x0d913542                                   
em28xx #0: EEPROM info:                                                                      
em28xx #0:      AC97 audio (5 sample rates)                                                  
em28xx #0:      500mA max power
em28xx #0:      Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0: Identified as Kworld VS-DVB-T 323UR (card=54)
em28xx #0:

em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)

tvp5150 2-005c: chip found @ 0xb8 (em28xx #0)
tuner 2-0061: chip found @ 0xc2 (em28xx #0)
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
usb 2-1.2: firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
em28xx #0: Config register raw data: 0xd0
em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 2-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as /dev/video0
em28xx #0: V4L2 VBI device registered as /dev/vbi0
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
tvp5150 2-005c: tvp5150am1 detected.


Thanks in advance for any help,
Marios Andreopoulos.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
