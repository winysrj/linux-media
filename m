Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc4-s18.col0.hotmail.com ([65.55.34.220]:36880 "EHLO
	col0-omc4-s18.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZFVVqN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 17:46:13 -0400
Message-ID: <COL103-W6456EADD7DFD74DAC94D8488390@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <dheitmueller@kernellabs.com>
CC: <linux-media@vger.kernel.org>, <video4linux-list@redhat.com>
Subject: RE: (more info) Can't use my Pinnacle PCTV HD Pro stick - what am I
 doing wrong?
Date: Mon, 22 Jun 2009 17:46:16 -0400
In-Reply-To: <COL103-W308B321250A646D788B25188390@phx.gbl>
References: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
	 <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
  <829197380906211429k7176a93fm49d49851e6d2df1e@mail.gmail.com>
 <COL103-W308B321250A646D788B25188390@phx.gbl>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Oh, and in case it's useful, here are my video modules before plugging in the Pinnacle device...

> lsmod | grep vid
video                  19856  0
output                  4736  1 video
hwmon_vid               4352  1 it87
nvidia               9555940  0
agpgart                34760  1 nvidia
i2c_core               24832  1 nvidia

... and after plugging it in

> lsmod | grep vid
videodev               40864  4 tuner,tvp5150,em28xx,v4l2_common
v4l1_compat            14852  1 videodev
videobuf_vmalloc        8324  1 em28xx
videobuf_core          19716  2 em28xx,videobuf_vmalloc
video                  19856  0
output                  4736  1 video
hwmon_vid               4352  1 it87
nvidia               9555940  0
agpgart                34760  1 nvidia
i2c_core               24832  8 tuner_xc2028,lgdt330x,tuner,tvp5150,em28xx,v4l2_common,tveeprom,nvidia


dmesg is still about the same:

> dmesg

[  115.185132] usb 7-1: new high speed USB device using ehci_hcd and address 2
[  115.339403] usb 7-1: configuration #1 chosen from 1 choice
[  115.433546] Linux video capture interface: v2.00
[  115.514652] em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
[  115.514658] em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
[  115.514729] em28xx #0: chip ID is em2882/em2883
[  115.733205] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
[  115.733215] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
[  115.733236] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[  115.733243] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[  115.733249] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  115.733255] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  115.733262] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
[  115.733268] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
[  115.733274] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
[  115.733280] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
[  115.733287] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
[  115.733294] em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
[  115.733382] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  115.733388] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  115.733394] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  115.733400] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  115.733407] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
[  115.733409] em28xx #0: EEPROM info:
[  115.733410] em28xx #0:       AC97 audio (5 sample rates)
[  115.733411] em28xx #0:       500mA max power
[  115.733413] em28xx #0:       Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[  115.746503] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb7/7-1/input/input6
[  115.864417] em28xx #0: Config register raw data: 0xd0
[  115.865164] em28xx #0: AC97 vendor ID = 0xffffffff
[  115.865540] em28xx #0: AC97 features = 0x6a90
[  115.865544] em28xx #0: Empia 202 AC97 audio processor detected
[  115.955428] em28xx #0: v4l2 driver version 0.1.2
[  116.037113] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[  116.037129] usbcore: registered new interface driver em28xx
[  116.037133] em28xx driver loaded
[  116.374776] xc2028 0-0061: creating new instance
[  116.374780] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[  116.374782] em28xx #0/2: xc3028 attached
[  116.374784] DVB: registering new adapter (em28xx #0)
[  116.374786] DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[  116.374943] Successfully loaded em28xx-dvb
[  116.374945] Em28xx: Initialized (Em28xx dvb Extension) extension


----------------------------------------
> From: g_adams27@hotmail.com
> To: dheitmueller@kernellabs.com
> CC: linux-media@vger.kernel.org; video4linux-list@redhat.com
> Subject: RE: Can't use my Pinnacle PCTV HD Pro stick - what am I doing wrong?
> Date: Mon, 22 Jun 2009 17:39:45 -0400
>
>
> Hello again. I have some updates now that I've been able to make some further tests.
>
> 1) My Pinnacle PCTV HD Pro (800e) stick does, in fact, work correctly under Windows. The scanning detects the one channel we're running over our closed circuit cable (channel 3) and displays it on-screen just fine. (audio over channel 3 works as well)
>
>
> 2) Devin, my installation process is "hg clone http://linuxtv.org/hg/v4l-dvb; cd v4l-dvb; make rminstall; make distclean; make; make install" This appears to install everything v4l-related as modules in the appropriate directories. For instance:
>
>> uname -r
> 2.6.24-24-server
>
>> find /lib/modules/`uname -r` -type f -name em28xx\* -o -name tvp\*
> /lib/modules/2.6.24-24-server/kernel/drivers/media/video/tvp5150.ko
> /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx.ko
> /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
>
>
> 3) tvtime still hangs when launched.
>
>
> 4) Running zapping gives the error "VBI Initialization failed. /dev/vbi0 (Pinnacle PCTV HD Pro) is not a raw vbi device)". Continuing on and trying to choose the "Preferences" menu option segfaults the program (and this is the Ubuntu-distributed "zapping" package)
>
>
> 5) Running Paul's suggested "mplayer" command gives the following:
>
>> mplayer -vo xv tv:// -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3
>
> MPlayer 1.0rc2-4.2.4 (C) 2000-2007 MPlayer Team
> CPU: Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz (Family: 6, Model: 23, Stepping: 10)
> CPUflags: MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
> Compiled with runtime CPU detection.
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote control.
>
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
> name: Video 4 Linux 2 input
> author: Martin Olschewski
> comment: first try, more to come ;-)
> Selected device: Pinnacle PCTV HD Pro Stick
> Tuner cap:
> Tuner rxs:
> Capabilites: video capture tuner audio read/write streaming
> supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM;
> inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
> Current input: 0
> Current format: YUYV
> v4l2: current audio mode is : MONO
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> Selected channel: 3 (freq: 61.250)
> Video buffer shorter than 3 times audio frame duration.
> You will probably experience heavy framedrops.
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> xscreensaver_disable: Could not find XScreenSaver window.
> GNOME screensaver disabled
> ==========================================================================
> Opening video decoder: [raw] RAW Uncompressed Video
> VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
> VDec: using Packed YUY2 as output csp (no 0)
> Movie-Aspect is undefined - no prescaling applied.
> VO: [xv] 640x480 => 640x480 Packed YUY2
> Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
> ==========================================================================
> ==========================================================================
> Forced audio codec: mad
> Opening audio decoder: [pcm] Uncompressed PCM audio decoder
> AUDIO: 44100 Hz, 1 ch, s16le, 705.6 kbit/100.00% (ratio: 88200->88200)
> Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
> ==========================================================================
> AO: [pulse] 44100Hz 1ch s16le (2 bytes per sample)
> Starting playback...
> v4l2: select timeout
> A: 0.5 V: 0.0 A-V: 0.472 ct: 0.000 1/ 1 ??% ??% ??,?% 1 0 [[JMA: 0.9 V: 0.0 A-V: 0.940 ct: 0.003 2/ 2 ??% ??% ??,?% 2 0 [[JMv4l2: select timeout
> A: 1.5 V: 0.0 A-V: 1.479 ct: 0.007 3/ 3 ??% ??% ??,?% 3 0 [[JMA: 2.0 V: 0.0 A-V: 1.981 ct: 0.010 4/ 4 ??% ??% ??,?% 4 0 [[JMv4l2: select timeout
> A: 2.5 V: 0.0 A-V: 2.485 ct: 0.013 5/ 5 ??% ??% ??,?% 5 0 [[JMA: 3.0 V: 0.0 A-V: 2.957 ct: 0.017 6/ 6 ??% ??% ??,?% 6 0 [[JMv4l2: select timeout
> A: 3.5 V: 0.0 A-V: 3.460 ct: 0.020 7/ 7 ??% ??% ??,?% 7 0 [[JMA: 4.0 V: 0.0 A-V: 3.956 ct: 0.022 8/ 8 ??% ??% ??,?% 8 0 [[JMv4l2: select timeout
> A: 4.5 V: 0.0 A-V: 4.460 ct: 0.025 9/ 9 ??% ??% ??,?% 9 0 [[JMA: 5.0 V: 0.0 A-V: 4.956 ct: 0.027 10/ 10 ??% ??% ??,?% 10 0 [[JMv4l2: select timeout
>
>
> The Mplayer screen itself remains green the whole time.
>
>
> So the surprise to me is that the Pinnacle device is not actually broken. By this point, I had been sure it was a hardware problem. Now I realize that it's something else. And so I would again appreciate any suggestions you might have. Thank you once again!
>
> (My installation process, just for reference, distilled down:)
>> cd /usr/local/src
>> hg clone http://linuxtv.org/hg/v4l-dvb
>> cd v4l-dvb
>> make rminstall; make distclean; make; make install
>> cd /tmp
>> wget http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
>> unzip -j HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
>> perl /usr/local/src/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
>> mv xc3028-v27.fw /lib/firmware/xc3028-v27.fw
>
>
>
>
> _________________________________________________________________
> Hotmail® has ever-growing storage! Don’t worry about storage limits.
> http://windowslive.com/Tutorial/Hotmail/Storage?ocid=TXT_TAGLM_WL_HM_Tutorial_Storage_062009--
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Bing™  brings you maps, menus, and reviews organized in one place.   Try it now.
http://www.bing.com/search?q=restaurants&form=MLOGEN&publ=WLHMTAG&crea=TEXT_MLOGEN_Core_tagline_local_1x1