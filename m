Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53664 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1AXG1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 01:27:40 -0500
Received: by qwa26 with SMTP id 26so3642094qwa.19
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 22:27:40 -0800 (PST)
Subject: TM6010 no audio
From: =?UTF-8?Q?=E5=BC=B5=E7=A6=8F=E6=B5=B7?= <hendry002@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 14:27:31 +0800
Message-ID: <1295850451.2017.14.camel@levono3000>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi,

I have a Trident TM6010 based tv tuner: hauppauge WINTV-HVR-900H, and I
am able to get both audio and video under windows 7 by using the drivers
and utilities from the vender. The analogue tv standard is PAL-D.

I tried to make it work under my linux box by using the lasted kernel
and v4l2 modules, and use the firmware xc3028L-v36.fw,then:
modprobe tm6000 tm6000-alsa and tm6000-dvb:
[zhangfh@levono3000 ~]$ lsmod|grep tm6000
tm6000_dvb              5434  0 
dvb_core               72998  1 tm6000_dvb
tm6000_alsa             4545  1 
tm6000                 36587  2 tm6000_dvb,tm6000_alsa
v4l2_common             6822  2 tuner,tm6000
videobuf_vmalloc        3838  1 tm6000
videobuf_core          13383  2 tm6000,videobuf_vmalloc
rc_core                14522  7
ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,tm6000,ir_nec_decoder
snd_pcm                62434  4 tm6000_alsa,snd_hda_intel,snd_hda_codec
videodev               53893  4 tuner,tm6000,v4l2_common,uvcvideo
snd                    47301  17
tm6000_alsa,snd_hda_codec_conexant,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
i2c_core               20624  11
zl10353,tuner_xc2028,tuner,tm6000,v4l2_common,videodev,i2c_i801,nouveau,drm_kms_helper,drm,i2c_algo_bit


[zhangfh@levono3000 ~]$ arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: CONEXANT Analog [CONEXANT Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: tm6000 [TM5600/60x0], device 0: TM6000 Audio [Trident
TM5600/60x0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0


and try watching tv with mplayer:


mplayer -v tv:// -tv
driver=v4l2:device=/dev/video1:norm=PAL-DK:alsa:adevice=hw.1,0:forceaudio:immediatemode=0
MPlayer SVN-r32628-snapshot-4.5.1 (C) 2000-2010 MPlayer Team
CPU vendor name: GenuineIntel  max cpuid level: 10
CPU: Intel(R) Core(TM)2 Duo CPU     P7350  @ 2.00GHz (Family: 6, Model:
23, Stepping: 6)
extended cpuid-level: 8
extended cache-info: 201351232
Detected cache-line size is 64 bytes
Testing OS support for SSE... yes.
Tests of OS support for SSE passed.
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNowExt: 0 SSE: 1 SSE2: 1 SSSE3: 1
Compiled for x86 CPU with extensions: MMX MMX2 SSE SSE2 SSSE3 CMOV
get_path('codecs.conf') -> '/home/zhangfh/.mplayer/codecs.conf'
Reading /home/zhangfh/.mplayer/codecs.conf: Can't open
'/home/zhangfh/.mplayer/codecs.conf': No such file or directory
Reading /usr/local/etc/mplayer/codecs.conf: Can't open
'/usr/local/etc/mplayer/codecs.conf': No such file or directory
Using built-in default codecs.conf.
init_freetype
Using MMX (with tiny bit MMX2) Optimized OnScreenDisplay
get_path('fonts') -> '/home/zhangfh/.mplayer/fonts'
Configuration: --enable-gui
CommandLine: '-v' 'tv://' '-tv'
'driver=v4l2:device=/dev/video1:norm=PAL-DK:alsa:adevice=hw.1,0:forceaudio:immediatemode=0'
Using nanosleep() timing
get_path('input.conf') -> '/home/zhangfh/.mplayer/input.conf'
Can't open input config file /home/zhangfh/.mplayer/input.conf: No such
file or directory
Can't open input config file /usr/local/etc/mplayer/input.conf: No such
file or directory
Falling back on default (hardcoded) input config
get_path('.conf') -> '/home/zhangfh/.mplayer/.conf'

Playing tv://.
get_path('sub/') -> '/home/zhangfh/.mplayer/sub/'
STREAM: [tv] tv://
STREAM: Description: TV Input
STREAM: Author: Benjamin Zores, Albeu
STREAM: Comment: 
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Trident TVMaster TM5600/6000/60
 Tuner cap:
 Tuner rxs: MONO
 Capabilities:  video capture  tuner  read/write  streaming
 supported norms: 0 = NTSC-M; 1 = NTSC-M-JP; 2 = PAL; 3 = PAL-BG; 4 =
PAL-H; 5 = PAL-I; 6 = PAL-DK; 7 = PAL-M; 8 = PAL-N; 9 = PAL-Nc; 10 =
PAL-60; 11 = SECAM; 12 = SECAM-B; 13 = SECAM-G; 14 = SECAM-H; 15 =
SECAM-DK; 16 = SECAM-L; 17 = SECAM-Lc;
 inputs: 0 = Television; 1 = Composite; 2 = S-Video;
 Current input: 0
 Format YUYV   (16 bits, 4:2:2, packed, YVY2): Packed YUY2
 Format UYVY   (16 bits, 4:2:2, packed, UYVY): Packed UYVY
 Format unknown (0x30364d54) ( 0 bits, A/V + VBI mux packet): Unknown
0x30364d54
 Current format: YUYV
v4l2: current audio mode is : MONO
v4l2: set format: YVU420
v4l2: ioctl set format failed: Invalid argument
v4l2: set format: YUV420
v4l2: ioctl set format failed: Invalid argument
v4l2: set format: UYVY
v4l2: set input: 0
Selected norm : PAL-DK
v4l2: set norm: PAL-DK
Selected channel list: europe-east (including 133 channels)
Current frequency: 4868 (304.250)
==> Found video stream: 0
v4l2: get format: UYVY
v4l2: get fps: 25.000000
v4l2: get width: 720
v4l2: get height: 576
Channel count not available - reverting to default: 2
Hardware PCM card 1 'TM5600/60x0' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 48000
  period_size  : 3000
  period_time  : 62500
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 3000
  period_event : 0
  start_threshold  : 0
  stop_threshold   : 48000
  silence_threshold: 0
  silence_size : 0
  boundary     : 1572864000
  appl_ptr     : 0
  hw_ptr       : 0
v4l2: set audio samplerate: 44100
Channel count not available - reverting to default: 2
Hardware PCM card 1 'TM5600/60x0' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 48000
  period_size  : 3000
  period_time  : 62500
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 3000
  period_event : 0
  start_threshold  : 0
  stop_threshold   : 48000
  silence_threshold: 0
  silence_size : 0
  boundary     : 1572864000
  appl_ptr     : 0
  hw_ptr       : 0
v4l2: get audio format: 9
==> Found audio stream: 0
v4l2: get audio samplerate: 48000
v4l2: get audio samplesize: 2
v4l2: get audio channels: 2
  TV audio: 2 channels, 16 bits, 48000 Hz
Audio capture - buffer 256 blocks of 12000 bytes, skew average from 17
meas.
Video buffer shorter than 3 times audio frame duration.
You will probably experience heavy framedrops.
Using a ring buffer for maximum 2 frames, 1 MB total size.
v4l2: ioctl set mute failed: Invalid argument
v4l2: set Brightness: 54 [0, 255]
v4l2: set Hue: 0 [-128, 127]
v4l2: set Saturation: 112 [0, 255]
v4l2: set Contrast: 119 [0, 255]
[V] filefmt:9  fourcc:0x59565955  size:720x576  fps:25.000
ftime:=0.0400
get_path('sub/') -> '/home/zhangfh/.mplayer/sub/'
v4l2: going to capture

video buffer full - dropping frame

video buffer full - dropping frame

video buffer full - dropping frame

video buffer full - dropping frame

video buffer full - dropping frame

video buffer full - dropping frame

video buffer full - dropping frame

video buffer full - dropping frame

video buffer full - dropping frame






here, immediatemode=0 and 
it seems video buffer is too small or something else is wrong?
but when using immediatemode=1, able to get video but without audio.
can anyone help to figure out?


dmesg:

[12826.677884] tuner 3-0061: chip found @ 0xc2 (tm6000 #0)
[12826.715848] xc2028 3-0061: creating new instance
[12826.715852] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[12826.715855] Setting firmware parameters for xc2028
[12826.727243] xc2028 3-0061: Loading 81 firmware images from
xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[12826.943059] xc2028 3-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[12867.164070] xc2028 3-0061: Loading firmware for type=(0), id
000000000000b700.
[12867.840035] SCODE (20000000), id 000000000000b700:
[12867.840043] xc2028 3-0061: Loading SCODE for type=MONO SCODE
HAS_IF_4320 (60008000), id 0000000000008000.
[12868.632143] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load
status: 0)
[12868.632182] usbcore: registered new interface driver tm6000
[12868.636893] tm6000: open called (dev=video1)
[12869.534544] tm6000: open called (dev=video1)
[12877.103313] tm6000_alsa: module is from the staging directory, the
quality is unknown, you have been warned.
[12877.114332] tm6000 #0: Initialized (TM6000 Audio Extension) extension
[12883.203838] tm6000_dvb: module is from the staging directory, the
quality is unknown, you have been warned.
[12883.315054] DVB: registering new adapter (Trident TVMaster 6000
DVB-T)
[12883.315060] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
DVB-T)...
[12883.315330] xc2028 3-0061: attaching existing instance
[12883.315333] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[12883.315336] tm6000: XC2028/3028 asked to be attached to frontend!
[12883.315503] tm6000 #0: Initialized (TM6000 dvb Extension) extension
[12957.162513] tm6000: open called (dev=video1)
[12959.176065] xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3),
id 0000000000000000.
[12999.420122] xc2028 3-0061: Loading firmware for type=(0), id
00000000000000e0.
[13000.097058] xc2028 3-0061: Loading SCODE for type=SCODE HAS_IF_6600
(60000000), id 00000000000000e0.
[13000.902400] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.908143] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.913896] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.919652] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.925402] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.931144] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.936911] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.942638] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.959403] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.965151] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.970894] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.976664] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.982390] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.988142] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.993902] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13000.999645] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13001.016400] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13001.022144] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13001.027900] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)
[13001.033653] tm6000 tm6000_irq_callback :urb resubmit failed
(error=-1)



best regards, hendry


