Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f216.google.com ([209.85.218.216])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lkustan@gmail.com>) id 1MIUqC-0007Jp-2x
	for linux-dvb@linuxtv.org; Sun, 21 Jun 2009 23:44:45 +0200
Received: by bwz12 with SMTP id 12so2855697bwz.17
	for <linux-dvb@linuxtv.org>; Sun, 21 Jun 2009 14:44:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Jun 2009 00:44:10 +0300
Message-ID: <88b49f150906211444u39a8eae1v77a15f32e4062775@mail.gmail.com>
From: Laszlo Kustan <lkustan@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Kworld DVB-T 323UR problems
Reply-To: linux-media@vger.kernel.org
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

Hi everyone,
I have a Kword DVB-T 323UR connected to a Linux Mint 7 Gloria (based
on Ubuntu Jaunty), kernel 2.6.28.
I successfully compiled em28xx, the firmware was obtained based on these steps:
1) Download the windows driver with something like:
wget http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
2) Extract the file hcw85bda.sys from the zip into the current dir:
unzip -j HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
3) run the script:
./extract_xc3028.pl
4) copy the generated file:
cp xc3028-v27.fw /lib/firmware

My windows driver is called embda.sys, so I'm not sure whether the
firmware is 100% good for my tuner or not.
I have a couple of problems:
1. no analog audio, but I found out this works with workarounds

I tried several tricks:
a. sox -c 2 -r 32000 -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp
this works, but with a 4-5 second delay between audio and video

b. arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | play -q -c 2 -r 32000 -t wav - &
I get an error:
laco@laco-desktop ~ $ arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | play
-q -c 2 -r 32000 -t wav - &
[1] 9084
laco@laco-desktop ~ $ Recording WAVE 'stdin' : Signed 16 bit Little
Endian, Rate 32000 Hz, Stereo
Warning: rate is not accurate (requested = 32000Hz, got = 48000Hz)
         please, try the plug plugin
arecord: pcm_read:1529: read error: Input/output error
play wav: Premature EOF on .wav input file

c. install modified tvtime from mcentral.de
I get an error in this case too:
Reading configuration from /usr/etc/tvtime/tvtime.xml
Reading configuration from /home/laco/.tvtime/tvtime.xml
HDA NVidia : AD198x Analog hw:0,0
Em28xx Audio : Empia 28xx Capture hw:1,0
opening: hw:1,0
Access type not available

My arecord -l output is:
laco@laco-desktop ~ $ arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: NVidia [HDA NVidia], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: Em28xx Audio [Em28xx Audio], device 0: Em28xx Audio [Empia 28xx Capture]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

2. my remote is not recognized. Here is the em28xx part from dmesg:
laco@laco-desktop ~ $ dmesg | grep em28xx
[11231.562817] em28xx v4l2 driver version 0.0.1 loaded
[11231.564913] em28xx: new video device (eb1a:e323): interface 0, class 255
[11231.564920] em28xx: setting up device on a USB 1.1 bus
[11231.564924] em28xx: your device won't work properly when
[11231.564927] em28xx: not attached to a USB 2.0 highspeed bus
[11231.564931] em28xx: more information:
[11231.564933] em28xx: http://mcentral.de/wiki/index.php5/Talk:Em2880
[11231.564942] em28xx #0: Alternate settings: 8
[11231.564946] em28xx #0: Alternate setting 0, max size= 0
[11231.564950] em28xx #0: Alternate setting 1, max size= 512
[11231.564954] em28xx #0: Alternate setting 2, max size= 640
[11231.564958] em28xx #0: Alternate setting 3, max size= 768
[11231.564962] em28xx #0: Alternate setting 4, max size= 832
[11231.564966] em28xx #0: Alternate setting 5, max size= 896
[11231.564969] em28xx #0: Alternate setting 6, max size= 960
[11231.564973] em28xx #0: Alternate setting 7, max size= 1020
[11240.939178] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[11240.998075] em28xx #0: V4L2 device registered as /dev/video0
[11240.998087] em28xx #0: Found KWorld E323
[11240.998153] usbcore: registered new interface driver em28xx
[11241.064491] em28xx-audio.c: probing for em28x1 non standard usbaudio
[11241.064497] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[11241.922736] em28xx-audio: device is currently in analog TV mode

Nothing about input devices here and neither in /proc/bus/input/devices.

3. heat problems
I noticed that when it is connected, it gets quite hot, even if no dvb
software is running. In Windows it does not get so hot, even when
watching tv.

Sorry for this long mail.
The first point would be the most important to solve, if you need more
details to help me, no problem.
Thanks, Laszlo

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
