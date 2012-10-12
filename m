Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41306 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759971Ab2JLRuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 13:50:44 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3098927obb.19
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2012 10:50:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507853C5.9040605@gmail.com>
References: <507853C5.9040605@gmail.com>
Date: Fri, 12 Oct 2012 23:20:43 +0530
Message-ID: <CAGJz9e_N+1cq3OpfP0s3RP0jHCHm7Qib=E7+pS8DVQ+vnBp7pQ@mail.gmail.com>
Subject: Analog tv/composite and capture does not work on Hauppauge WinTV
 HVR-900 (r2) [USB ID 2040:6502], using kernel 3.2.0-32-generic ubuntu 12.04 lts
From: Supratim Bandyopadhyaya <mail.supratim@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have this DVB+Analog usb tv tuner Hauppauge WinTV HVR-900 (r2) [USB ID
2040:6502]. This used to work under ubuntu 10.04 LTS. But in 12.04 there
seems to be a problem. I am using stock updated kernel 3.2.0-32-generic

I have linux-firmware-nonfree and ivtv-utils installed.

I am running Ubuntu 12.04.1 LTS 64 bit with all updates installed and
the default unity environment.

When I run

|mplayer tv:// -tv driver=v4l2:device=/dev/video1:input=1:norm=PAL
|

I get a solid green screen and no picture. Here input 1 is the composite
input of the card.

MPlayer svn r34540 (Ubuntu), built with gcc-4.6 (C) 2000-2012 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
  name: Video 4 Linux 2 input
  author: Martin Olschewski
  comment: first try, more to come ;-)
Selected device: Hauppauge WinTV HVR 900 (R2)
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
  Current input: 1
  Current format: YUYV
v4l2: current audio mode is : MONO
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
Failed to open VDPAU backend libvdpau_nvidia.so: cannot open shared
object file: No such file or directory
[vdpau] Error when calling vdp_device_create_x11: 1
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 640x480 => 640x480 Packed YUY2
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
v4l2: select timeout
V:   0.0   2/  2 ??% ??% ??,?% 0 0
v4l2: select timeout
V:   0.0   4/  4 ??% ??% ??,?% 0 0
v4l2: select timeout
V:   0.0   6/  6 ??% ??% ??,?% 0 0
v4l2: select timeout
v4l2: 0 frames successfully processed, 1 frames dropped.

Exiting... (Quit)



Here is the dmesg of the card when plugged in..

[ 7637.756089] usb 1-4: new high-speed USB device number 5 using ehci_hcd
[ 7637.895229] em28xx: New device WinTV HVR-900 @ 480 Mbps (2040:6502,
interface 0, class 0)
[ 7637.895232] em28xx: Audio Vendor Class interface 0 found
[ 7637.895509] em28xx #0: chip ID is em2882/em2883
[ 7638.076517] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12
5c 03 82 1e 6a 18
[ 7638.076528] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00
00 00 00 00 00 00
[ 7638.076537] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00
00 00 5b e0 00 00
[ 7638.076547] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01
01 01 00 00 00 00
[ 7638.076556] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 7638.076565] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 7638.076575] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
18 03 34 00 30 00
[ 7638.076584] em28xx #0: i2c eeprom 70: 32 00 37 00 38 00 32 00 33 00
39 00 30 00 31 00
[ 7638.076593] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00
54 00 56 00 20 00
[ 7638.076602] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00
30 00 30 00 00 00
[ 7638.076612] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78
23 fa fd d0 28 89
[ 7638.076621] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01
20 77 00 40 1d b7
[ 7638.076630] em28xx #0: i2c eeprom c0: 13 f0 74 02 01 00 01 79 63 00
00 00 00 00 00 00
[ 7638.076639] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78
23 fa fd d0 28 89
[ 7638.076648] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01
20 77 00 40 1d b7
[ 7638.076657] em28xx #0: i2c eeprom f0: 13 f0 74 02 01 00 01 79 63 00
00 00 00 00 00 00
[ 7638.076668] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2bbf3bdd
[ 7638.076670] em28xx #0: EEPROM info:
[ 7638.076671] em28xx #0:       AC97 audio (5 sample rates)
[ 7638.076673] em28xx #0:       500mA max power
[ 7638.076675] em28xx #0:       Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[ 7638.078635] em28xx #0: Identified as Hauppauge WinTV HVR 900 (R2) (card=18)
[ 7638.080169] tveeprom 15-0050: Hauppauge model 65018, rev B2C0,
serial# 1292061
[ 7638.080173] tveeprom 15-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[ 7638.080176] tveeprom 15-0050: TV standards PAL(B/G) PAL(I)
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
[ 7638.080179] tveeprom 15-0050: audio processor is None (idx 0)
[ 7638.080182] tveeprom 15-0050: has radio
[ 7638.090569] tuner 15-0061: Tuner -1 found with type(s) Radio TV.
[ 7638.090589] xc2028 15-0061: creating new instance
[ 7638.090591] xc2028 15-0061: type set to XCeive xc2028/xc3028 tuner
[ 7638.092953] xc2028 15-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 7638.140044] xc2028 15-0061: Loading firmware for type=BASE MTS (5),
id 0000000000000000.
[ 7639.532644] xc2028 15-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[ 7639.557012] xc2028 15-0061: Loading SCODE for type=MTS LCD NOGD
MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 7639.684892] Registered IR keymap rc-hauppauge
[ 7639.685023] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/rc/rc4/input13
[ 7639.685162] rc4: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/rc/rc4
[ 7639.686260] em28xx #0: Config register raw data: 0xd0
[ 7639.687758] em28xx #0: AC97 vendor ID = 0xffffffff
[ 7639.688632] em28xx #0: AC97 features = 0x6a90
[ 7639.688635] em28xx #0: Empia 202 AC97 audio processor detected
[ 7639.759629] em28xx #0: v4l2 driver version 0.1.3
[ 7639.804046] xc2028 15-0061: Loading firmware for type=BASE F8MHZ
MTS (7), id 0000000000000000.
[ 7641.205142] MTS (4), id 00000000000000ff:
[ 7641.205148] xc2028 15-0061: Loading firmware for type=MTS (4), id
0000000100000007.
[ 7641.434910] em28xx #0: V4L2 video device registered as video1
[ 7641.434914] em28xx #0: V4L2 VBI device registered as vbi0
[ 7641.435896] em28xx-audio.c: probing for em28xx Audio Vendor Class
[ 7641.435899] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 7641.435901] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
[ 7641.492777] xc2028 15-0061: attaching existing instance
[ 7641.492781] xc2028 15-0061: type set to XCeive xc2028/xc3028 tuner
[ 7641.492783] em28xx #0: em28xx #0/2: xc3028 attached
[ 7641.492786] DVB: registering new adapter (em28xx #0)
[ 7641.492789] DVB: registering adapter 0 frontend 0 (Micronas DRXD DVB-T)...
[ 7641.493326] em28xx #0: Successfully loaded em28xx-dvb

And here goes the lsmod output

lsmod|grep em28xx


em28xx_dvb             18579  0
dvb_core              110619  1 em28xx_dvb
em28xx_alsa            18305  1
em28xx                109365  2 em28xx_dvb,em28xx_alsa
v4l2_common            16454  3 tuner,tvp5150,em28xx
videobuf_vmalloc       13589  1 em28xx
videobuf_core          26390  2 em28xx,videobuf_vmalloc
rc_core                26412  10
rc_hauppauge,ir_lirc_codec,ir_mce_kbd_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,em28xx,ir_nec_decoder
tveeprom               21249  1 em28xx
videodev               98259  5 tuner,tvp5150,em28xx,v4l2_common,uvcvideo
snd_pcm                97188  3 em28xx_alsa,snd_hda_intel,snd_hda_codec
snd                    78855  16
em28xx_alsa,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device

Isn't this driver mainline now? Or this card is not supported? Or the
analog functionality is not working?

I need the analog capture working for this card.

Please help!
