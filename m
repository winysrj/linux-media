Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <v4l@therussellhome.us>) id 1Ko7W2-0008Ng-AA
	for linux-dvb@linuxtv.org; Fri, 10 Oct 2008 04:14:09 +0200
Date: Thu, 9 Oct 2008 22:13:30 -0400
From: Chris Russell <v4l@therussellhome.us>
To: linux-dvb@linuxtv.org
Message-ID: <20081009221330.3e355773@arwen.therussellhome.us>
Mime-Version: 1.0
Subject: [linux-dvb] em28xx - analog tv audio on kworld 305U
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

	I have a KWorld DVB-T 305U on Gentoo using the v4l-dvb-hg
package (live development version of v4l&dvb-driver for Kernel 2.6)
that I updated today (03Oct08).

	The analog TV looks great but I cannot get the sound to work.
I have tried just about everything I could find searching including:
$ arecord -D hw:1 -f dat | aplay -f dat
	and
$ mplayer tv:// -tv driver=v4l2:device=/dev/video0:chanlist=us-cable:alsa:adevice=hw.1,0:amode=1:audiorate=32000:forceaudio:volume=100:immediatemode=0:norm=NTSC
	and
$ v4lctl volume mute off; v4lctl volume 31
	and
even attempting a manual cat from /dev/audio1 to /dev/audio

So what am I missing or is audio for the 305U not working yet?

Soli Deo Gloria,
Chris

-- lsusb output --
Bus 002 Device 002: ID eb1a:e305 eMPIA Technology, Inc. 

-- lsmod output --
Module                  Size  Used by
tuner_xc2028           17712  1 
tuner                  21444  0 
tvp5150                15376  0 
em28xx                 44584  2 
videodev               28160  2 tuner,em28xx
v4l1_compat            11396  1 videodev
compat_ioctl32           768  1 em28xx
videobuf_vmalloc        3844  1 em28xx
videobuf_core           9988  2 em28xx,videobuf_vmalloc
ir_common              29444  1 em28xx
snd_usb_audio          47200  0 
snd_usb_lib             9472  1 snd_usb_audio
v4l2_common             7040  3 tuner,tvp5150,em28xx
snd_rawmidi            11168  1 snd_usb_lib
tveeprom               10884  1 em28xx
snd_hwdep               3588  1 snd_usb_audio

-- dmesg output --
usb 2-5: new high speed USB device using ehci_hcd and address 4
usb 2-5: configuration #1 chosen from 1 choice
usbcore: registered new interface driver snd-usb-audio
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (eb1a:e305): interface 0, class 255
em28xx Has usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: chip ID is em2860
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 05 e3 50 00 5c 00 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 4e 03 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 06 00 01 00 f0 10 01 00 00 00 00 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 31 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
EEPROM ID= 0x9567eb1a, hash = 0xa8a51142
Vendor/Product ID= eb1a:e305
AC97 audio (5 sample rates)
500mA max power
Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0: 
em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)
tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
firmware: requesting xc3028-v27.fw
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
