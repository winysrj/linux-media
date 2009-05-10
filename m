Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4AJ6drp013557
	for <video4linux-list@redhat.com>; Sun, 10 May 2009 15:06:39 -0400
Received: from smtp102.rog.mail.re2.yahoo.com (smtp102.rog.mail.re2.yahoo.com
	[206.190.36.80])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n4AJ6Ml1001111
	for <video4linux-list@redhat.com>; Sun, 10 May 2009 15:06:23 -0400
From: William Case <billlinux@rogers.com>
To: video4linux-list <video4linux-list@redhat.com>
Content-Type: text/plain
Date: Sun, 10 May 2009 15:05:35 -0400
Message-Id: <1241982336.31677.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Hauppauge WinTV-hvr-1800 PCIe won't work with tvtime or mplayer.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi;

I have been trying to get my tuner card working for over a week now.

I have tried all the advice I can find on various sites as well as the
Fedora users list.  But no joy.  It was suggested on that list that I
try here.

I have installed the 'cx88_alsa' and 'tuner modules' with modprobe in
rc.local and, 

alias snd-card-1 cx88-alsa
options cx88-alsa index=1,  in /etc/modprobe.d/tvtuner

Here is what I am getting:

~]$ cat /proc/asound/cards
0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xe5300000 irq 16

==> no second sound device

~]$ lsmod | grep cx88
cx88_alsa              20488  0 
cx88xx                 75048  1 cx88_alsa
ir_common              45060  1 cx88xx
i2c_algo_bit           13956  1 cx88xx
snd_pcm                85640  3 cx88_alsa,snd_hda_intel,snd_pcm_oss
videodev               40704  4 cx88xx,tuner,cx23885,compat_ioctl32
videobuf_dma_sg        19972  3 cx88_alsa,cx88xx,cx23885
btcx_risc              12296  3 cx88_alsa,cx88xx,cx23885
tveeprom               21508  2 cx88xx,cx23885
snd                    68984  17
cx88_alsa,snd_hda_intel,snd_seq_dummy,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer,snd_hwdep
videobuf_core          24836  4
cx88xx,cx23885,videobuf_dma_sg,videobuf_dvb
i2c_core               29216  13
cx88xx,i2c_algo_bit,tda18271,tda8290,tuner,mt2131,s5h1409,cx25840,i2c_i801,cx23885,v4l2_common,tveeprom,nvidia

]$ tvtime -v
Running tvtime 1.0.2.
Reading configuration from /etc/tvtime/tvtime.xml
Reading configuration from /home/bill/.tvtime/tvtime.xml
cpuinfo: CPU Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz, family 6,
model 7, stepping 10.
cpuinfo: CPU measured at 2800.022MHz.
tvtime: Cannot set priority to -10: Permission denied.
xcommon: Display :0.0, vendor The X.Org Foundation, vendor release
10503000
xfullscreen: Using XINERAMA for dual-head information.
xfullscreen: Pixels are square.
xfullscreen: Number of displays is 1.
xfullscreen: Head 0 at 0,0 with size 1680x1050.
xcommon: Have XTest, will use it to ping the screensaver.
xcommon: Pixel aspect ratio 1:1.
xcommon: Pixel aspect ratio 1:1.
xcommon: Window manager is Metacity and is EWMH compliant.
xcommon: You are using metacity.  Disabling aspect ratio hints
xcommon: since most deployed versions of metacity are still broken.
xcommon: Using EWMH state fullscreen property.
xcommon: Using EWMH state above property.
xcommon: Using EWMH state below property.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 1024x576 window inside 1024x576 space.
xvoutput: Using XVIDEO adaptor 280: NV17 Video Texture.
speedycode: Using MMXEXT optimized functions.
station: Reading stationlist from /home/bill/.tvtime/stationlist.xml
videoinput: Using video4linux2 driver 'cx23885', card 'Hauppauge
WinTV-HVR1800' (bus PCIe:0000:02:00.0).
videoinput: Version is 1, capabilities 5010011.
videoinput: Maximum input width: 720 pixels.
tvtime: Sampling input at 720 pixels per scanline.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 1024x576 window inside 1024x576 space.
xcommon: Received a map, marking window as visible (57).
tvtime: Cleaning up.
Thank you for using tvtime.

==> Video works but no sound!

]$ mpl ==> runs the following script

"#!/bin/bash
# Run mplayer for TV
# file name: mplayer4tv
# ~/.bashrc alias: alias mpl = 'mplayer4tv' 

mplayer -v \
-tv driver=v4l2:norm=ntsc-m:outfmt=uyvy:chanlist=us-cable\
:immediatemode=0:amode=1:forceaudio:volume=100:adevice=hw.0\
:alsa=1:audiorate=44100\
-vo xv\
-aspect 16:9\
-menu\
tv://33"

which returns
]$ mpl
MPlayer SVN-r28461-4.3.2 (C) 2000-2009 MPlayer Team
CPU: Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz (Family: 6, Model:
23, Stepping: 10)
get_path('codecs.conf') -> '/home/bill/.mplayer/codecs.conf'
Reading /home/bill/.mplayer/codecs.conf: Can't open
'/home/bill/.mplayer/codecs.conf': No such file or directory
Reading /etc/mplayer/codecs.conf: Can't open '/etc/mplayer/codecs.conf':
No such file or directory
Using built-in default codecs.conf.
Configuration: --prefix=/usr --bindir=/usr/bin
--datadir=/usr/share/mplayer --mandir=/usr/share/man
--confdir=/etc/mplayer --libdir=/usr/lib64 --codecsdir=/usr/lib64/codecs
--target=x86_64-linux --language=all --enable-joystick
--enable-largefiles --enable-lirc --enable-menu
--enable-runtime-cpudetection --enable-unrarexec
--disable-dvdread-internal --disable-libdvdcss-internal --disable-nemesi
--disable-smb --disable-faac-lavc --disable-mp3lame-lavc
--disable-x264-lavc --disable-libamr_nb --disable-libamr_wb
--disable-faad-internal --disable-mad --disable-tremor-internal
--disable-bitmap-font --disable-directfb
--with-fribidi-config=pkg-config fribidi --disable-svga
--disable-termcap --enable-xvmc --with-xvmclib=XvMCW --disable-arts
--disable-esd --disable-jack --disable-openal
CommandLine: '-v' '-tv'
'driver=v4l2:norm=ntsc-m:outfmt=uyvy:chanlist=us-cable:immediatemode=0:amode=1:forceaudio:volume=100:adevice=hw.0:alsa=1:audiorate=44100' '-vo' 'xv' '-aspect' '16:9' '-menu' 'tv://33'
init_freetype
Using MMX (with tiny bit MMX2) Optimized OnScreenDisplay
get_path('fonts') -> '/home/bill/.mplayer/fonts'
Using nanosleep() timing
get_path('input.conf') -> '/home/bill/.mplayer/input.conf'
Parsing input config file /home/bill/.mplayer/input.conf
Input config file /home/bill/.mplayer/input.conf parsed: 89 binds
Setting up LIRC support...
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.
get_path('menu.conf') -> '/home/bill/.mplayer/menu.conf'
[libmenu] got keybinding element 275 UP=>[menu up].
[libmenu] got keybinding element 274 DOWN=>[menu down].
[libmenu] got keybinding element 273 LEFT=>[menu left].
[libmenu] got keybinding element 272 RIGHT=>[menu right].
[libmenu] got keybinding element 13 ENTER=>[menu ok].
[libmenu] got keybinding element 263 ESC=>[menu cancel].
[libmenu] got keybinding element 259 HOME=>[menu home].
[libmenu] got keybinding element 260 END=>[menu end].
[libmenu] got keybinding element 261 PGUP=>[menu pageup].
[libmenu] got keybinding element 262 PGDWN=>[menu pagedown].
[libmenu] got keybinding element 387 JOY_UP=>[menu up].
[libmenu] got keybinding element 386 JOY_DOWN=>[menu down].
[libmenu] got keybinding element 385 JOY_LEFT=>[menu left].
[libmenu] got keybinding element 384 JOY_RIGHT=>[menu right].
[libmenu] got keybinding element 404 JOY_BTN0=>[menu ok].
[libmenu] got keybinding element 405 JOY_BTN1=>[menu cancel].
[libmenu] got keybinding element 1288 AR_VUP=>[menu up].
[libmenu] got keybinding element 1289 AR_VDOWN=>[menu down].
[libmenu] got keybinding element 1284 AR_PREV=>[menu left].
[libmenu] got keybinding element 1282 AR_NEXT=>[menu right].
[libmenu] got keybinding element 1280 AR_PLAY=>[menu ok].
[libmenu] got keybinding element 1286 AR_MENU=>[menu cancel].
[libmenu] got keybinding element 1285 AR_PREV_HOLD=>[menu home].
[libmenu] got keybinding element 1283 AR_NEXT_HOLD=>[menu end].
[libmenu] got keybinding element 512 MOUSE_BTN0=>[menu click].
[libmenu] got keybinding element 514 MOUSE_BTN2=>[menu cancel].
[libmenu] got keybinding element 1284 AR_PREV=>[menu pageup].
[libmenu] got keybinding element 1282 AR_NEXT=>[menu pagedown].
[libmenu] got keybinding element 256 BS=>[menu left].
[libmenu] got keybinding element 1284 AR_PREV=>[menu left].
[libmenu] got keybinding element 1282 AR_NEXT=>[menu right].
[libmenu] got keybinding element 1284 AR_PREV=>[menu left].
[libmenu] got keybinding element 1282 AR_NEXT=>[menu right].
[libmenu] got keybinding element 1285 AR_PREV_HOLD=>[menu left].
[libmenu] got keybinding element 1283 AR_NEXT_HOLD=>[menu right].
Menu initialized: /home/bill/.mplayer/menu.conf
get_path('33.conf') -> '/home/bill/.mplayer/33.conf'

Playing tv://33.
get_path('sub/') -> '/home/bill/.mplayer/sub/'
STREAM: [tv] tv://33
STREAM: Description: TV Input
STREAM: Author: Benjamin Zores, Albeu
STREAM: Comment: 
TV file format detected.
Selected driver: v4l2
name: Video 4 Linux 2 input
author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
comment: first try, more to come ;-)
Selected device: Hauppauge WinTV-HVR1800
Tuner cap:
Tuner rxs:
Capabilites:  video capture  VBI capture device  tuner  read/write
streaming
supported norms: 0 = NTSC-M; 1 = NTSC-M-JP; 2 = NTSC-443; 3 = PAL-BG; 4
= PAL-I; 5 = PAL-DK; 6 = PAL-M; 7 = PAL-N; 8 = PAL-Nc; 9 = PAL-60; 10 =
SECAM-DK; 11 = SECAM-L;
inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
Current input: 0
Format GREY   ( 8 bits, 8 bpp, gray): Planar Y800
Format RGB555 (16 bits, 15 bpp RGB, le): BGR 15-bit
Format RGB555X (16 bits, 15 bpp RGB, be): Unknown 0x51424752
Format RGB565 (16 bits, 16 bpp RGB, le): BGR 16-bit
Format RGB565X (16 bits, 16 bpp RGB, be): Unknown 0x52424752
Format BGR24  (24 bits, 24 bpp RGB, le): BGR 24-bit
Format BGR32  (32 bits, 32 bpp RGB, le): BGRA
Format RGB32  (32 bits, 32 bpp RGB, be): RGBA
Format YUYV   (16 bits, 4:2:2, packed, YUYV): Packed YUY2
Format UYVY   (16 bits, 4:2:2, packed, UYVY): Packed UYVY
Current format: BGR24
v4l2: setting audio mode
v4l2: current audio mode is : STEREO
v4l2: set Volume: 63 [0, 63]
v4l2: set format: UYVY
v4l2: set input: 0
Selected norm : ntsc-m
v4l2: set norm: NTSC-M
Selected channel list: us-cable (including 133 channels)
Requested channel: 33
Selected channel: 33 (freq: 277.250)
Current frequency: 4436 (277.250)
Current frequency: 38654710100 (2415919360.000)
==> Found video stream: 0
v4l2: get format: UYVY
v4l2: get fps: 29.970030
v4l2: get width: 640
v4l2: get height: 480
Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 44100
  exact rate   : 44100 (44100/1)
  msbits       : 16
  buffer_size  : 16384
  period_size  : 4096
  period_time  : 92879
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 4096
  period_event : 0
  start_threshold  : 0
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 4611686018427387904
  appl_ptr     : 0
  hw_ptr       : 0
v4l2: set audio samplerate: 44100
Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 44100
  exact rate   : 44100 (44100/1)
  msbits       : 16
  buffer_size  : 16384
  period_size  : 4096
  period_time  : 92879
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 4096
  period_event : 0
  start_threshold  : 0
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 4611686018427387904
  appl_ptr     : 0
  hw_ptr       : 0
v4l2: get audio format: 9
==> Found audio stream: 0
v4l2: get audio samplerate: 44100
v4l2: get audio samplesize: 2
v4l2: get audio channels: 2
  TV audio: 2 channels, 16 bits, 44100 Hz
Audio capture - buffer 614 blocks of 16384 bytes, skew average from 16
meas.
Using a ring buffer for maximum 1716 frames, 1005 MB total size.
v4l2: set Brightness: 127 [0, 255]
v4l2: set Hue: 127 [0, 255]
v4l2: set Saturation: 127 [0, 255]
v4l2: set Contrast: 63 [0, 255]
[V] filefmt:9  fourcc:0x59565955  size:640x480  fps:29.970
ftime:=0.0334
get_path('sub/') -> '/home/bill/.mplayer/sub/'
X11 opening display: :0.0
vo: X11 color mask:  FFFFFF  (R:FF0000 G:FF00 B:FF)
vo: X11 running at 1680x1050 with depth 24 and 32 bpp (":0.0" => local
display)
[x11] Detected wm supports NetWM.
[x11] Detected wm supports FULLSCREEN state.
[x11] Detected wm supports ABOVE state.
[x11] Detected wm supports BELOW state.
[x11] Current fstype setting honours FULLSCREEN ABOVE BELOW X atoms
[VO_XV] Using Xv Adapter #0 (NV17 Video Texture)
[xv common] Drawing no colorkey.
[xv common] Maximum source image dimensions: 2046x2046
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 640 x 480 (preferred colorspace: Packed UYVY)
Trying filter chain: menu vo
VDec: using Packed UYVY as output csp (no 0)
Movie-Aspect is 1.78:1 - prescaling to correct movie aspect.
VO Config (640x480->854x480,flags=0,'MPlayer',0x59565955)
Unicode font: 4959 glyphs.
REQ: flags=0x437  req=0x0  
VO: [xv] 640x480 => 854x480 Packed UYVY 
VO: Description: X11/Xv
VO: Author: Gerd Knorr <kraxel@goldbach.in-berlin.de> and others
Xvideo image format: 0x32595559 (YUY2) packed
Xvideo image format: 0x32315659 (YV12) planar
Xvideo image format: 0x59565955 (UYVY) packed
Xvideo image format: 0x30323449 (I420) planar
using Xvideo port 280 for hw scaling
[xv] dx: 0 dy: 0 dw: 854 dh: 534
Selected video codec: [rawuyvy] vfm: raw (RAW UYVY)
==========================================================================
==========================================================================
Opening audio decoder: [pcm] Uncompressed PCM audio decoder
dec_audio: Allocating 2048 + 65536 = 67584 bytes for output buffer.
AUDIO: 44100 Hz, 2 ch, s16le, 1411.2 kbit/100.00% (ratio:
176400->176400)
Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
==========================================================================
Building audio filter chain for 44100Hz/2ch/s16le -> 0Hz/0ch/??...
[libaf] Adding filter dummy 
[dummy] Was reinitialized: 44100Hz/2ch/s16le
[dummy] Was reinitialized: 44100Hz/2ch/s16le
Trying preferred audio driver 'pulse', options '[none]'
AO: [pulse] 44100Hz 2ch s16le (2 bytes per sample)
AO: Description: PulseAudio audio output
AO: Author: Lennart Poettering
Building audio filter chain for 44100Hz/2ch/s16le ->
44100Hz/2ch/s16le...
[dummy] Was reinitialized: 44100Hz/2ch/s16le
[dummy] Was reinitialized: 44100Hz/2ch/s16le
Starting playback...
Increasing filtered audio buffer size from 0 to 46144
v4l2: going to capture
*** [menu] Exporting mp_image_t, 640x480x16bpp YUV packed, 614400 bytes
*** [vo] Exporting mp_image_t, 640x480x16bpp YUV packed, 614400 bytes
Unicode font: 4959 glyphs.
Unicode font: 4959 glyphs.
Uninit audio filters... 0.000 ct:  0.093 319/319  0%  2%  0.0% 0
0              
[libaf] Removing filter dummy 
Uninit audio: pcm
Uninit video: raw
v4l2: 337 frames successfully processed, -336 frames dropped.
v4l2: up to 28 video frames buffered.
vo: uninit ...

Exiting... (Quit)

==> mplayer gives me a terrible picture and no sound.

(terrible = inverted picture with green background; just black and
magenta for colours; and vertical lines running through it.)

I have tried the sound with PulseAudio installed and removed.  No
difference.


-- 
Regards Bill
Fedora 10, Gnome 2.24.3
Evo.2.24.5, Emacs 22.3.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
