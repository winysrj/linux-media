Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:48538 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaKISM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Nov 2014 13:12:29 -0500
Received: by mail-vc0-f170.google.com with SMTP id hq12so756517vcb.1
        for <linux-media@vger.kernel.org>; Sun, 09 Nov 2014 10:12:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEk3jHj1qJ4HdVheXesEpinA4d+5HxbzY1UE5hY3uj-y_vcF6A@mail.gmail.com>
References: <CAEk3jHj1qJ4HdVheXesEpinA4d+5HxbzY1UE5hY3uj-y_vcF6A@mail.gmail.com>
Date: Sun, 9 Nov 2014 19:12:27 +0100
Message-ID: <CAEk3jHhH7Z_Ve3yRW+m6tP6omckEdn7F2BqKUCs162nmLRHkgg@mail.gmail.com>
Subject: Fwd: em28xx: Hauppauge HVR 900 on 3.18.0-rc3
From: Michal B <developer.m3@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

plaese somebody could explain me why i can't use correctly Hauppauge
HVR 900 [2040:6500] like before 5 years for example ?
could somebody have a look on it to fix it ?
i bought new hardware with Intel Haswell and i'm unable to use tv
analog tuner on old kernels as i used on my old hardware , my old
hardware is out of order :-(



Kind regards,
Michal


---------- Forwarded message ----------
From: Michal B <developer.m3@gmail.com>
Date: 2014-11-06 7:51 GMT+01:00
Subject: em28xx: Hauppauge HVR 900 on 3.18.0-rc3
To: linux-media@vger.kernel.org


Hi,

analog TV on Hauppauge HVR 900 [2040:6500] - audio works correctly but
video stops after few samples, audio continues after video stop,

tested:

mplayer tv:// -tv
norm=PAL-BG:freq=687.5:input=0:device=/dev/video0:alsa:amode=1:adevice=hw.2,0:audiorate=48000:forceaudio:immediatemode=0
-hardframedrop -ao alsa -vo x11

mplayer output:
MPlayer svn r34540 (Debian), built with gcc-4.7 (C) 2000-2012 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Hauppauge WinTV HVR 900
 Tuner cap:
 Tuner rxs:
 Capabilities:  video capture  VBI capture device  tuner  audio
read/write  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR;
4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK;
10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 =
SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 =
SECAM-Lc;
 inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
 Current input: 0
 Current format: YUYV
v4l2: current audio mode is : STEREO
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
Could not find matching colorspace - retrying with -vf scale...
Opening video filter: [scale]
Movie-Aspect is undefined - no prescaling applied.
[swscaler @ 0x13c7d40] BICUBIC scaler, from yuyv422 to bgra using MMX2
VO: [x11] 720x576 => 720x576 BGRA
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
==========================================================================
Opening audio decoder: [pcm] Uncompressed PCM audio decoder
AUDIO: 48000 Hz, 2 ch, s16le, 1536.0 kbit/100.00% (ratio: 192000->192000)
Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
==========================================================================
AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
A:   3.1 V:   1.6 A-V:  1.447 ct:  0.165  92/ 92  0%  8% 28.8% 50 0


           ************************************************
           **** Your system is too SLOW to play this!  ****
           ************************************************

Possible reasons, problems, workarounds:
- Most common: broken/buggy _audio_ driver
  - Try -ao sdl or use the OSS emulation of ALSA.
  - Experiment with different values for -autosync, 30 is a good start.
- Slow video output
  - Try a different -vo driver (-vo help for a list) or try -framedrop!
- Slow CPU
  - Don't try to play a big DVD/DivX on a slow CPU! Try some of the lavdopts,
    e.g. -vfm ffmpeg -lavdopts lowres=1:fast:skiploopfilter=all.
- Broken file
  - Try various combinations of -nobps -ni -forceidx -mc 0.
- Slow media (NFS/SMB mounts, DVD, VCD etc)
  - Try -cache 8192.
- Are you using -cache to play a non-interleaved AVI file?
  - Try -nocache.
Read DOCS/HTML/en/video.html for tuning/speedup tips.
If none of this helps you, read DOCS/HTML/en/bugreports.html.

A:  11.7 V:   5.1 A-V:  6.636 ct:  0.250 308/308  0%  2% 12.9% 266 0
v4l2: 310 frames successfully processed, 0 frames dropped.


kernel output:
[  427.441405] usb 3-13.5.5: new high-speed USB device number 9 using xhci_hcd
[  427.534116] usb 3-13.5.5: New USB device found, idVendor=2040, idProduct=6500
[  427.534126] usb 3-13.5.5: New USB device strings: Mfr=0, Product=1,
SerialNumber=2
[  427.534131] usb 3-13.5.5: Product: WinTV HVR-900
[  427.534136] usb 3-13.5.5: SerialNumber: 4026875858
[  427.586621] media: Linux media interface: v0.10
[  427.625926] Linux video capture interface: v2.00
[  427.669943] em28xx: New device  WinTV HVR-900 @ 480 Mbps
(2040:6500, interface 0, class 0)
[  427.669945] em28xx: Video interface 0 found: isoc
[  427.669946] em28xx: DVB interface 0 found: isoc
[  427.669973] em28xx: chip ID is em2882/3
[  427.838493] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x43a734dd
[  427.838499] em2882/3 #0: EEPROM info:
[  427.838503] em2882/3 #0:     AC97 audio (5 sample rates)
[  427.838506] em2882/3 #0:     500mA max power
[  427.838510] em2882/3 #0:     Table at offset 0x24, strings=0x1e82,
0x186a, 0x0000
[  427.838515] em2882/3 #0: Identified as Hauppauge WinTV HVR 900 (card=10)
[  427.840708] tveeprom 7-0050: Hauppauge model 65008, rev A1C0, serial# 344018
[  427.840714] tveeprom 7-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[  427.840719] tveeprom 7-0050: TV standards PAL(B/G) PAL(I)
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
[  427.840722] tveeprom 7-0050: audio processor is None (idx 0)
[  427.840725] tveeprom 7-0050: has radio
[  427.840727] em2882/3 #0: analog set to isoc mode.
[  427.840729] em2882/3 #0: dvb set to isoc mode.
[  427.840760] em28xx audio device (2040:6500): interface 1, class 1
[  427.840775] em28xx audio device (2040:6500): interface 2, class 1
[  427.840832] usbcore: registered new interface driver em28xx
[  427.872945] em2882/3 #0: Registering V4L2 extension
[  427.910653] tvp5150 7-005c: chip found @ 0xb8 (em2882/3 #0)
[  427.910655] tvp5150 7-005c: tvp5150am1 detected.
[  427.912474] tvp5150 7-005c: i2c i/o error: rc == -6
[  427.931506] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[  427.970505] xc2028 7-0061: creating new instance
[  427.970507] xc2028 7-0061: type set to XCeive xc2028/xc3028 tuner
[  427.970545] em2882/3 #0: Config register raw data: 0x50
[  427.970773] em2882/3 #0: AC97 vendor ID = 0xffffffff
[  427.970893] em2882/3 #0: AC97 features = 0x6a90
[  427.970894] em2882/3 #0: Empia 202 AC97 audio processor detected
[  428.007655] usbcore: registered new interface driver snd-usb-audio
[  428.030650] tvp5150 7-005c: i2c i/o error: rc == -6
[  428.033304] tvp5150 7-005c: i2c i/o error: rc == -6
[  428.036606] tvp5150 7-005c: i2c i/o error: rc == -6
[  428.037127] xc2028 7-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  428.082802] tvp5150 7-005c: i2c i/o error: rc == -6
[  428.132097] xc2028 7-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[  429.044910] MTS (4), id 00000000000000ff:
[  429.044919] xc2028 7-0061: Loading firmware for type=MTS (4), id
0000000100000007.
[  429.372336] em2882/3 #0: V4L2 video device registered as video0
[  429.372343] em2882/3 #0: V4L2 VBI device registered as vbi0
[  429.372840] em2882/3 #0: V4L2 extension successfully initialized
[  429.372845] em28xx: Registered (Em28xx v4l2 Extension) extension
[  429.421235] em2882/3 #0: Binding DVB extension
[  429.432300] tvp5150 7-005c: i2c i/o error: rc == -6
[  429.433737] tvp5150 7-005c: i2c i/o error: rc == -6
[  429.434274] tvp5150 7-005c: i2c i/o error: rc == -6
[  429.555251] xc2028 7-0061: attaching existing instance
[  429.555259] xc2028 7-0061: type set to XCeive xc2028/xc3028 tuner
[  429.555265] em2882/3 #0: em2882/3 #0/2: xc3028 attached
[  429.555268] DVB: registering new adapter (em2882/3 #0)
[  429.555277] usb 3-13.5.5: DVB: registering adapter 0 frontend 0
(Zarlink ZL10353 DVB-T)...
[  429.556086] em2882/3 #0: DVB extension successfully initialized
[  429.556096] em28xx: Registered (Em28xx dvb Extension) extension
[  429.574991] em2882/3 #0: Registering input extension
[  429.610030] Registered IR keymap rc-hauppauge
[  429.610306] input: em28xx IR (em2882/3 #0) as
/devices/pci0000:00/0000:00:14.0/usb3/3-13/3-13.5/3-13.5.5/rc/rc0/input22
[  429.611069] rc0: em28xx IR (em2882/3 #0) as
/devices/pci0000:00/0000:00:14.0/usb3/3-13/3-13.5/3-13.5.5/rc/rc0
[  429.611189] em2882/3 #0: Input extension successfully initalized
[  429.611193] em28xx: Registered (Em28xx Input Extension) extension
[  434.992078] tvp5150 7-005c: i2c i/o error: rc == -6
[  434.993487] tvp5150 7-005c: i2c i/o error: rc == -6
[  434.995820] tvp5150 7-005c: i2c i/o error: rc == -6
[  434.996902] tvp5150 7-005c: i2c i/o error: rc == -6
[  434.998295] tvp5150 7-005c: i2c i/o error: rc == -6
[  435.110378] xc2028 7-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[  436.055085] MTS (4), id 00000000000000ff:
[  436.055097] xc2028 7-0061: Loading firmware for type=MTS (4), id
0000000100000007.
[  436.190777] tvp5150 7-005c: i2c i/o error: rc == -6
[  436.190784] tvp5150 7-005c: tvp5150_selmux: failed with error = -6
[  436.263263] xc2028 7-0061: Loading firmware for type=MTS (4), id
0000000100000007.
[  436.633107] tvp5150 7-005c: i2c i/o error: rc == -6

Kind regards,

Michal
