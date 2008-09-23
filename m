Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8N8lUHr005016
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 04:47:30 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8N8lGKH019218
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 04:47:16 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2115083wfc.6
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 01:47:15 -0700 (PDT)
Message-ID: <5495d16c0809230147u4049cc06maf404683465d0840@mail.gmail.com>
Date: Tue, 23 Sep 2008 03:47:15 -0500
From: "Sergey Zelenev" <zelenev@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: WinTV-PVR-USB2 / MFNM05-4 / wm8775/ cx25843 audio distortion
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

I'm new to the list, so I am sorry if that has been discussed before. I
cannot find a working solution on the Web.

I'm having terrible sound distortion problems with WinTV-PVR-USB2.

I'm hearing significant sound distortion and clipping when recording/playing
channels from the Tuner of pvrusb2. I have tried playing recorded files on
another box (in fact a professional sound studio) and I'm hearing the same
sound artifacts in recording. Tried using the capture device with another PC
- same problem. It is especially noticeable on certain TV channels that seem
to have a strong sound level (such as HBO/HBO2). This digital
distortion/clipping sounds terrible and on certain scenes in the movies that
have a lot of bass sounds makes dialogs barely distinguishable. I'm playing
the sound through large 12" 3-way speakers, so I hear things that may be
obscured on smaller PC or TV speakers.
I have no problems with sound on any channel when the channels are
demodulated by my TV and fed to the same speakers. I have no problems with
sound on existing sound and video files played through my box, so it is not
a sound card issue. I have tried playing with ctl_volume/cur_val value, but
it looks like distortion happens before the attenuation by this parameter as
I can hear distortion even at lower settings (sometimes it is even more
noticeable).

I am running Mythbuntu 8.04.1 x86 with 2.6.24-19-generic kernel. I have
installed the new firmware from ivtv page and kernel modules from
linuxtv.org Mercurial repo with no improvements.

Is there any external user or application-accessible interface or API to
change the 0x8XX registers of cx25843 from userland? It looks like the chip
has a lot of sound features that are not controlled by the driver and I
would hate to have to recompile each time I want to do something with
cx25840_write4().

Debugs disabled:
~$ dmesg | grep
'bttv\|ivtv\|cx88/0\|cx25840\|tuner\|pvrusb2\|wm8775\|tda9887\|tveeprom\|lirc'
[   49.077277] usbcore: registered new interface driver pvrusb2
[   49.077287] /home/tv/v4l-dvb/v4l/pvrusb2-main.c: Hauppauge WinTV-PVR-USB2
MPEG2 Encoder/Tuner : V4L in-tree version
[   49.077293] /home/tv/v4l-dvb/v4l/pvrusb2-main.c: Debug mask is 31 (0x1f)
[   49.693356] pvrusb2_a: IR disabled
[   49.715345] cx25840' 1-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
[   49.882115] tuner' 1-0043: chip found @ 0x86 (pvrusb2_a)
[   49.992866] tda9887 1-0043: creating new instance
[   49.992874] tda9887 1-0043: tda988[5/6/7] found
[   50.023865] tuner' 1-0061: chip found @ 0xc2 (pvrusb2_a)
[   50.029095] wm8775' 1-001b: chip found @ 0x36 (pvrusb2_a)
[   50.057355] tveeprom 1-00a2: Hauppauge model 24022, rev E1A3, serial#
9006229
[   50.057364] tveeprom 1-00a2: tuner model is TCL MFNM05-4 (idx 103, type
43)
[   50.057370] tveeprom 1-00a2: TV standards NTSC(M) (eeprom 0x08)
[   50.057374] tveeprom 1-00a2: audio processor is CX25843 (idx 37)
[   50.057378] tveeprom 1-00a2: decoder processor is CX25843 (idx 30)
[   50.057382] tveeprom 1-00a2: has radio, has IR receiver, has IR
transmitter
[   50.057394] pvrusb2: Supported video standard(s) reported available in
hardware: PAL-M/N/Nc;NTSC-M/Mj/Mk
[   50.057402] pvrusb2: Mapping standards mask=0xb700
(PAL-M/N/Nc;NTSC-M/Mj/Mk)
[   50.057407] pvrusb2: Setting up 6 unique standard(s)
[   50.057414] pvrusb2: Set up standard idx=0 name=PAL-M
[   50.057418] pvrusb2: Set up standard idx=1 name=PAL-N
[   50.057422] pvrusb2: Set up standard idx=2 name=PAL-Nc
[   50.057426] pvrusb2: Set up standard idx=3 name=NTSC-M
[   50.057430] pvrusb2: Set up standard idx=4 name=NTSC-Mj
[   50.057440] pvrusb2: Set up standard idx=5 name=NTSC-Mk
[   50.057445] pvrusb2: Initial video standard guessed as NTSC-M
[   50.057463] pvrusb2: Device initialization completed successfully.
[   50.057542] pvrusb2: registered device video0 [mpeg]
[   50.057571] pvrusb2: registered device radio0 [mpeg]
[   53.943925] cx25840' 1-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[   54.190959] tuner-simple 1-0061: creating new instance
[   54.190969] tuner-simple 1-0061: type set to 43 (Philips NTSC MK3
(FM1236MK3 or FM1236/F))
[   54.281159] cx25840' 1-0044: Video signal:              not present
[   54.281166] cx25840' 1-0044: Detected format:           NTSC-M
[   54.281171] cx25840' 1-0044: Specified standard:        NTSC-M
[   54.281175] cx25840' 1-0044: Specified video input:     Composite 7
[   54.281179] cx25840' 1-0044: Specified audioclock freq: 48000 Hz
[   54.291026] cx25840' 1-0044: Detected audio mode:       forced mode
[   54.291034] cx25840' 1-0044: Detected audio standard:   no detected audio
standard
[   54.291038] cx25840' 1-0044: Audio muted:               no
[   54.291042] cx25840' 1-0044: Audio microcontroller:     detecting
[   54.291047] cx25840' 1-0044: Configured audio standard: automatic
detection
[   54.291051] cx25840' 1-0044: Configured audio system:   BTSC
[   54.291055] cx25840' 1-0044: Specified audio input:     Tuner (In8)
[   54.291059] cx25840' 1-0044: Preferred audio mode:      stereo
[   54.291067] tda9887 1-0043: Data bytes: b=0x14 c=0x30 e=0x44
[   54.291072] tuner' 1-0061: Tuner mode:      analog TV
[   54.291076] tuner' 1-0061: Frequency:       175.25 MHz
[   54.291080] tuner' 1-0061: Standard:        0x00001000
[   54.291085] wm8775' 1-001b: Input: 2
[   78.210347] lirc_dev: IR Remote Control driver registered, at major 61
[   78.339322] bttv: driver version 0.9.17 loaded
[   78.339332] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   78.515655] ivtv:  Start initialization, version 1.4.0
[   78.516065] ivtv:  End initialization
[   78.578712] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   78.596864] lirc_i2c: chip 0x10005 found @ 0x71 (Hauppauge PVR150)
[   78.596923] lirc_dev: lirc_register_plugin: sample_rate: 10



PVRUSB2 debug:
[ 3179.506500] pvrusb2: =================  START STATUS CARD #0
=================
[ 3179.509453] cx25840' 1-0044: Video signal:              present
[ 3179.509461] cx25840' 1-0044: Detected format:           NTSC-M
[ 3179.509466] cx25840' 1-0044: Specified standard:        NTSC-M
[ 3179.509470] cx25840' 1-0044: Specified video input:     Composite 7
[ 3179.509474] cx25840' 1-0044: Specified audioclock freq: 48000 Hz
[ 3179.517691] cx25840' 1-0044: Detected audio mode:       mono
[ 3179.517698] cx25840' 1-0044: Detected audio standard:   BTSC
[ 3179.517702] cx25840' 1-0044: Audio muted:               no
[ 3179.517705] cx25840' 1-0044: Audio microcontroller:     running
[ 3179.517710] cx25840' 1-0044: Configured audio standard: automatic
detection
[ 3179.517715] cx25840' 1-0044: Configured audio system:   BTSC
[ 3179.517719] cx25840' 1-0044: Specified audio input:     Tuner (In8)
[ 3179.517723] cx25840' 1-0044: Preferred audio mode:      stereo
[ 3179.517731] tda9887 1-0043: Data bytes: b=0x14 c=0x30 e=0x44
[ 3179.517736] tuner' 1-0061: Tuner mode:      analog TV
[ 3179.517740] tuner' 1-0061: Frequency:       409.25 MHz
[ 3179.517744] tuner' 1-0061: Standard:        0x0000b000
[ 3179.517749] wm8775' 1-001b: Input: 2
[ 3179.517754] pvrusb2: cx2341x config:
[ 3179.517758] pvrusb2: Stream: MPEG-2 Program Stream
[ 3179.517762] pvrusb2: VBI Format: No VBI
[ 3179.517766] pvrusb2: Video:  720x480, 30 fps
[ 3179.517771] pvrusb2: Video:  MPEG-2, 4x3, Variable Bitrate, 4500000, Peak
6000000
[ 3179.517777] pvrusb2: Video:  GOP Size 15, 2 B-Frames, GOP Closure
[ 3179.517782] pvrusb2: Audio:  48 kHz, MPEG-1/2 Layer II, 384 kbps, Stereo,
No Emphasis, No CRC
[ 3179.517789] pvrusb2: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma
1D Horizontal, 0
[ 3179.517794] pvrusb2: Temporal Filter: Manual, 8
[ 3179.517798] pvrusb2: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
[ 3179.517809] pvrusb2_a driver: <ok> <init> <connected> <mode=analog>
[ 3179.517814] pvrusb2_a pipeline: <idle> <configok>
[ 3179.517819] pvrusb2_a worker: <decode:quiescent> <encode:stop>
<encode:waitok> <usb:stop> <pathway:ok>
[ 3179.517824] pvrusb2_a state: ready
[ 3179.517829] pvrusb2_a Hardware supported inputs: television, composite,
s-video, radio
[ 3179.517836] pvrusb2_a Bytes streamed=93137920 URBs: queued=0 idle=0
ready=0 processed=5741 failed=0
[ 3179.517841] pvrusb2: ==================  END STATUS CARD #0
==================


NOW DEBUGS ENABLED:


[   49.079382] usbcore: registered new interface driver pvrusb2
[   49.079392] /home/tv/v4l-dvb/v4l/pvrusb2-main.c: Hauppauge WinTV-PVR-USB2
MPEG2 Encoder/Tuner : V4L in-tree version
[   49.079398] /home/tv/v4l-dvb/v4l/pvrusb2-main.c: Debug mask is 31 (0x1f)
[   49.697029] wm8775: Unknown parameter `debug'
[   49.697959] pvrusb2_a: IR disabled
[   49.698039] cx25840' 1-0044: detecting cx25840 client on address 0x88
[   49.719948] cx25840' 1-0044: device_id = 0x8434
[   49.719956] cx25840' 1-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
[   49.965303] tuner' 1-0043: chip found @ 0x86 (pvrusb2_a)
[   50.045043] tda9887 1-0043: creating new instance
[   50.045051] tda9887 1-0043: tda988[5/6/7] found
[   50.045056] tuner' 1-0043: type set to tda9887
[   50.045061] tuner' 1-0043: tv freq set to 0.00
[   50.045066] tuner' 1-0043: TV freq (0.00) out of range (44-958)
[   50.045822] tuner' 1-0043: pvrusb2_a tuner' I2C addr 0x86 with type 74
used for 0x0e
[   50.076068] tuner' 1-0061: Setting mode_mask to 0x0e
[   50.076076] tuner' 1-0061: chip found @ 0xc2 (pvrusb2_a)
[   50.076080] tuner' 1-0061: tuner 0x61: Tuner type absent
[   50.101431] tveeprom 1-00a2: Tag [04] + 8 bytes: 20 77 00 40 95 6c 89 00
[   50.101445] tveeprom 1-00a2: Tag [05] + 2 bytes: 25 00
[   50.101451] tveeprom 1-00a2: Tag [06] + 7 bytes: d6 5d 00 00 53 18 95
[   50.101459] tveeprom 1-00a2: Tag [07] + 1 bytes: 70
[   50.101463] tveeprom 1-00a2: Tag [09] + 2 bytes: 1e 5f
[   50.101468] tveeprom 1-00a2: Tag [0a] + 2 bytes: 08 67
[   50.101473] tveeprom 1-00a2: Tag [0b] + 1 bytes: 2d
[   50.101478] tveeprom 1-00a2: Tag [0e] + 1 bytes: 01
[   50.101482] tveeprom 1-00a2: Tag [0f] + 1 bytes: 03
[   50.101487] tveeprom 1-00a2: Tag [10] + 1 bytes: 01
[   50.101491] tveeprom 1-00a2: Not sure what to do with tag [10]
[   50.101495] tveeprom 1-00a2: Tag [11] + 1 bytes: 00
[   50.101499] tveeprom 1-00a2: Not sure what to do with tag [11]
[   50.101505] tveeprom 1-00a2: Hauppauge model 24022, rev E1A3, serial#
9006229
[   50.101510] tveeprom 1-00a2: tuner model is TCL MFNM05-4 (idx 103, type
43)
[   50.101515] tveeprom 1-00a2: TV standards NTSC(M) (eeprom 0x08)
[   50.101524] tveeprom 1-00a2: audio processor is CX25843 (idx 37)
[   50.101528] tveeprom 1-00a2: decoder processor is CX25843 (idx 30)
[   50.101532] tveeprom 1-00a2: has radio, has IR receiver, has IR
transmitter
[   50.101543] pvrusb2: Supported video standard(s) reported available in
hardware: PAL-M/N/Nc;NTSC-M/Mj/Mk
[   50.101552] pvrusb2: Mapping standards mask=0xb700
(PAL-M/N/Nc;NTSC-M/Mj/Mk)
[   50.101557] pvrusb2: Setting up 6 unique standard(s)
[   50.101563] pvrusb2: Set up standard idx=0 name=PAL-M
[   50.101567] pvrusb2: Set up standard idx=1 name=PAL-N
[   50.101571] pvrusb2: Set up standard idx=2 name=PAL-Nc
[   50.101575] pvrusb2: Set up standard idx=3 name=NTSC-M
[   50.101580] pvrusb2: Set up standard idx=4 name=NTSC-Mj
[   50.101584] pvrusb2: Set up standard idx=5 name=NTSC-Mk
[   50.101589] pvrusb2: Initial video standard guessed as NTSC-M
[   50.101605] pvrusb2: Device initialization completed successfully.
[   50.101679] pvrusb2: registered device video0 [mpeg]
[   50.101710] pvrusb2: registered device radio0 [mpeg]
[   50.102391] cx25840' 1-0044: cmd c0445624 triggered fw load
[   54.023733] cx25840' 1-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[   54.037724] cx25840' 1-0044: PLL regs = int: 15, frac: 2876158, post: 4
[   54.037730] cx25840' 1-0044: PLL = 108.000011 MHz
[   54.037734] cx25840' 1-0044: PLL/8 = 13.500001 MHz
[   54.037738] cx25840' 1-0044: ADC Sampling freq = 14.317384 MHz
[   54.037742] cx25840' 1-0044: Chroma sub-carrier freq = 3.579545 MHz
[   54.037749] cx25840' 1-0044: hblank 122, hactive 720, vblank 26, vactive
487, vblank656 26, src_dec 543, burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66,
sc 0x087c1f
[   54.052841] cx25840' 1-0044: decoder set video input 7, audio input 8
[   54.093457] cx25840' 1-0044: PLL regs = int: 15, frac: 2876158, post: 4
[   54.093465] cx25840' 1-0044: PLL = 108.000011 MHz
[   54.093469] cx25840' 1-0044: PLL/8 = 13.500001 MHz
[   54.093473] cx25840' 1-0044: ADC Sampling freq = 14.317384 MHz
[   54.093477] cx25840' 1-0044: Chroma sub-carrier freq = 3.579545 MHz
[   54.093484] cx25840' 1-0044: hblank 122, hactive 720, vblank 26, vactive
487, vblank656 26, src_dec 543, burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66,
sc 0x087c1f
[   54.110061] cx25840' 1-0044: decoder set video input 7, audio input 8
[   54.143685] cx25840' 1-0044: decoder set video input 7, audio input 8
[   54.193680] tuner' 1-0043: TUNER_SET_TYPE_ADDR
[   54.193691] tuner' 1-0043: Calling set_type_addr for type=43, addr=0xff,
mode=0x06, config=0xdf904600
[   54.193697] tuner' 1-0043: set addr discarded for type 74, mask e. Asked
to change tuner at addr 0xff, with mask 6
[   54.193703] tuner' 1-0061: TUNER_SET_TYPE_ADDR
[   54.193709] tuner' 1-0061: Calling set_type_addr for type=43, addr=0xff,
mode=0x06, config=0xdf904600
[   54.193714] tuner' 1-0061: defining GPIO callback
[   54.270895] tuner-simple 1-0061: creating new instance
[   54.270905] tuner-simple 1-0061: type set to 43 (Philips NTSC MK3
(FM1236MK3 or FM1236/F))
[   54.270912] tuner' 1-0061: type set to Philips NTSC MK3 (FM1236MK3 or
FM1236/F)
[   54.270918] tuner' 1-0061: tv freq set to 400.00
[   54.270928] tuner' 1-0043: TUNER_SET_CONFIG
[   54.272437] tuner' 1-0061: TUNER_SET_CONFIG
[   54.273278] tuner' 1-0061: pvrusb2_a tuner' I2C addr 0xc2 with type 43
used for 0x0e
[   54.273289] cx25840' 1-0044: changing video std to fmt 1
[   54.282374] cx25840' 1-0044: PLL regs = int: 15, frac: 2876158, post: 4
[   54.282381] cx25840' 1-0044: PLL = 108.000011 MHz
[   54.282385] cx25840' 1-0044: PLL/8 = 13.500001 MHz
[   54.282389] cx25840' 1-0044: ADC Sampling freq = 14.317384 MHz
[   54.282393] cx25840' 1-0044: Chroma sub-carrier freq = 3.579545 MHz
[   54.282400] cx25840' 1-0044: hblank 122, hactive 720, vblank 26, vactive
487, vblank656 26, src_dec 543, burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66,
sc 0x087c1f
[   54.306602] tuner' 1-0043: VIDIOC_S_STD
[   54.306611] tuner' 1-0043: switching to v4l2
[   54.306615] tuner' 1-0061: VIDIOC_S_STD
[   54.306619] tuner' 1-0061: switching to v4l2
[   54.306624] tuner' 1-0061: tv freq set to 400.00
[   54.306632] tuner' 1-0043: TUNER_SET_CONFIG
[   54.307486] tuner' 1-0061: TUNER_SET_CONFIG
[   54.310740] tuner' 1-0043: VIDIOC_S_TUNER
[   54.310747] tuner' 1-0043: Cmd VIDIOC_S_TUNER accepted for analog TV
[   54.310751] tuner' 1-0061: VIDIOC_S_TUNER
[   54.310755] tuner' 1-0061: Cmd VIDIOC_S_TUNER accepted for analog TV
[   54.311485] tuner' 1-0043: VIDIOC_S_CTRL
[   54.311489] tuner' 1-0061: VIDIOC_S_CTRL
...
[   54.323607] tuner' 1-0043: VIDIOC_S_CTRL
[   54.323613] tuner' 1-0061: VIDIOC_S_CTRL
[   54.325856] tuner' 1-0043: VIDIOC_CROPCAP
[   54.325861] tuner' 1-0043: VIDIOC_G_TUNER
[   54.325866] tuner' 1-0043: Cmd VIDIOC_G_TUNER accepted for analog TV
[   54.326353] tuner' 1-0061: VIDIOC_G_TUNER
[   54.326357] tuner' 1-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
[   54.342102] tuner' 1-0043: VIDIOC_S_FREQUENCY
[   54.342112] tuner' 1-0043: tv freq set to 175.25
[   54.342971] tuner' 1-0061: VIDIOC_S_FREQUENCY
[   54.342976] tuner' 1-0061: tv freq set to 175.25
[   54.342983] tuner' 1-0043: TUNER_SET_CONFIG
[   54.343910] tuner' 1-0061: TUNER_SET_CONFIG
[   54.344802] tuner' 1-0043: VIDIOC_S_CROP
[   54.344807] tuner' 1-0061: VIDIOC_S_CROP
[   54.349348] cx25840' 1-0044: decoder set size 720x480 -> scale  0x0
[   54.354287] tuner' 1-0043: VIDIOC_S_FMT
[   54.354295] tuner' 1-0061: VIDIOC_S_FMT
[   54.358219] cx25840' 1-0044: Video signal:              not present
[   54.358225] cx25840' 1-0044: Detected format:           NTSC-M
[   54.358229] cx25840' 1-0044: Specified standard:        NTSC-M
[   54.358233] cx25840' 1-0044: Specified video input:     Composite 7
[   54.358237] cx25840' 1-0044: Specified audioclock freq: 48000 Hz
[   54.366218] cx25840' 1-0044: Detected audio mode:       forced mode
[   54.366225] cx25840' 1-0044: Detected audio standard:   no detected audio
standard
[   54.366230] cx25840' 1-0044: Audio muted:               no
[   54.366234] cx25840' 1-0044: Audio microcontroller:     detecting
[   54.366239] cx25840' 1-0044: Configured audio standard: automatic
detection
[   54.366243] cx25840' 1-0044: Configured audio system:   BTSC
[   54.366247] cx25840' 1-0044: Specified audio input:     Tuner (In8)
[   54.366252] cx25840' 1-0044: Preferred audio mode:      stereo
[   54.366258] tuner' 1-0043: VIDIOC_LOG_STATUS
[   54.366264] tda9887 1-0043: Data bytes: b=0x14 c=0x30 e=0x44
[   54.366268] tuner' 1-0061: VIDIOC_LOG_STATUS
[   54.366273] tuner' 1-0061: Tuner mode:      analog TV
[   54.366277] tuner' 1-0061: Frequency:       175.25 MHz
[   54.366281] tuner' 1-0061: Standard:        0x00001000
[   54.748445] tuner' 1-0043: VIDIOC_S_STD
[   54.748456] tuner' 1-0043: tv freq set to 175.25
[   54.749719] tuner' 1-0061: VIDIOC_S_STD
[   54.749726] tuner' 1-0061: tv freq set to 175.25
[   54.749735] tuner' 1-0043: TUNER_SET_CONFIG
[   54.750557] tuner' 1-0061: TUNER_SET_CONFIG
[   54.753559] tuner' 1-0043: VIDIOC_S_TUNER
[   54.753566] tuner' 1-0043: Cmd VIDIOC_S_TUNER accepted for analog TV
[   54.753570] tuner' 1-0061: VIDIOC_S_TUNER
[   54.753574] tuner' 1-0061: Cmd VIDIOC_S_TUNER accepted for analog TV
[   54.754854] tuner' 1-0043: VIDIOC_S_CTRL
[   54.754860] tuner' 1-0061: VIDIOC_S_CTRL
...
[   54.767047] tuner' 1-0043: VIDIOC_S_CTRL
[   54.767051] tuner' 1-0061: VIDIOC_S_CTRL
[   54.769422] tuner' 1-0043: VIDIOC_CROPCAP
[   54.769427] tuner' 1-0043: VIDIOC_G_TUNER
[   54.769432] tuner' 1-0043: Cmd VIDIOC_G_TUNER accepted for analog TV
[   54.769921] tuner' 1-0061: VIDIOC_G_TUNER
[   54.769926] tuner' 1-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
[   54.780177] tuner' 1-0043: VIDIOC_S_FREQUENCY
[   54.780184] tuner' 1-0043: tv freq set to 175.25
[   54.781041] tuner' 1-0061: VIDIOC_S_FREQUENCY
[   54.781046] tuner' 1-0061: tv freq set to 175.25
[   54.781053] tuner' 1-0043: TUNER_SET_CONFIG
[   54.781914] tuner' 1-0061: TUNER_SET_CONFIG
[   54.783084] tuner' 1-0043: VIDIOC_S_CROP
[   54.783089] tuner' 1-0061: VIDIOC_S_CROP
[   54.788168] cx25840' 1-0044: decoder set size 720x480 -> scale  0x0
[   54.792668] tuner' 1-0043: VIDIOC_S_FMT
[   54.792675] tuner' 1-0061: VIDIOC_S_FMT
[   91.335927] lirc_dev: IR Remote Control driver registered, at major 61
[   91.459481] bttv: driver version 0.9.17 loaded
[   91.459491] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   91.612055] ivtv:  Start initialization, version 1.4.0
[   91.612452] ivtv:  End initialization
[   91.672711] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   91.674263] lirc_i2c: chip 0x10005 found @ 0x71 (Hauppauge PVR150)
[   91.674316] lirc_dev: lirc_register_plugin: sample_rate: 10
[   91.677013] tuner' 1-0043: VIDIOC_CROPCAP
[   91.677024] tuner' 1-0043: VIDIOC_G_TUNER
[   91.677030] tuner' 1-0043: Cmd VIDIOC_G_TUNER accepted for analog TV
[   91.677853] tuner' 1-0061: VIDIOC_G_TUNER
[   91.677860] tuner' 1-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
[   92.030982] tuner' 1-0043: VIDIOC_S_FREQUENCY
[   92.030995] tuner' 1-0043: tv freq set to 175.25
[   92.031977] tuner' 1-0061: VIDIOC_S_FREQUENCY
[   92.031984] tuner' 1-0061: tv freq set to 175.25
[   92.031992] tuner' 1-0043: TUNER_SET_CONFIG
[   92.032977] tuner' 1-0061: TUNER_SET_CONFIG
[   92.034029] cx25840' 1-0044: changing video std to fmt 1
[   92.046473] cx25840' 1-0044: PLL regs = int: 15, frac: 2876158, post: 4
[   92.046482] cx25840' 1-0044: PLL = 108.000011 MHz
[   92.046487] cx25840' 1-0044: PLL/8 = 13.500001 MHz
[   92.046491] cx25840' 1-0044: ADC Sampling freq = 14.317384 MHz
[   92.046495] cx25840' 1-0044: Chroma sub-carrier freq = 3.579545 MHz
[   92.046502] cx25840' 1-0044: hblank 122, hactive 720, vblank 26, vactive
487, vblank656 26, src_dec 543, burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66,
sc 0x087c1f
[   92.069474] tuner' 1-0043: VIDIOC_S_STD
[   92.069489] tuner' 1-0043: tv freq set to 175.25
[   92.070347] tuner' 1-0061: VIDIOC_S_STD
[   92.070359] tuner' 1-0061: tv freq set to 175.25
[   92.070369] tuner' 1-0043: TUNER_SET_CONFIG
[   92.071119] tuner' 1-0061: TUNER_SET_CONFIG
[   92.090205] tuner' 1-0043: VIDIOC_CROPCAP
[   92.090214] tuner' 1-0043: VIDIOC_G_TUNER
[   92.090220] tuner' 1-0043: Cmd VIDIOC_G_TUNER accepted for analog TV
[   92.090772] tuner' 1-0061: VIDIOC_G_TUNER
[   92.090778] tuner' 1-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
[   92.101202] tuner' 1-0043: VIDIOC_S_FREQUENCY
[   92.101214] tuner' 1-0043: tv freq set to 175.25
[   92.102074] tuner' 1-0061: VIDIOC_S_FREQUENCY
[   92.102082] tuner' 1-0061: tv freq set to 175.25
[   92.102090] tuner' 1-0043: TUNER_SET_CONFIG
[   92.102947] tuner' 1-0061: TUNER_SET_CONFIG
[   92.127316] tuner' 1-0043: VIDIOC_S_FREQUENCY
[   92.127328] tuner' 1-0043: tv freq set to 409.25
[   92.128187] tuner' 1-0061: VIDIOC_S_FREQUENCY
[   92.128194] tuner' 1-0061: tv freq set to 409.25
[   92.128203] tuner' 1-0043: TUNER_SET_CONFIG
[   92.129061] tuner' 1-0061: TUNER_SET_CONFIG
[   92.132940] tuner' 1-0043: VIDIOC_S_CTRL
[   92.132951] tuner' 1-0061: VIDIOC_S_CTRL
...
[   92.155674] tuner' 1-0043: VIDIOC_S_CTRL
[   92.155679] tuner' 1-0061: VIDIOC_S_CTRL


STARTING CAPTURE WHILE DEBUGGING:

[  214.984760] tuner' 1-0043: VIDIOC_S_FREQUENCY
[  214.984773] tuner' 1-0043: tv freq set to 409.25
[  214.985755] tuner' 1-0061: VIDIOC_S_FREQUENCY
[  214.985762] tuner' 1-0061: tv freq set to 409.25
[  214.985772] tuner' 1-0043: TUNER_SET_CONFIG
[  214.986762] tuner' 1-0061: TUNER_SET_CONFIG
[  214.997260] tuner' 1-0043: VIDIOC_S_CTRL
...
[  216.467809] tuner' 1-0043: VIDIOC_S_CTRL
[  216.467815] tuner' 1-0061: VIDIOC_S_CTRL
[  216.506375] cx25840' 1-0044: decoder set size 720x480 -> scale  0x0
[  216.511998] tuner' 1-0043: VIDIOC_S_FMT
[  216.512009] tuner' 1-0061: VIDIOC_S_FMT
[  216.514493] tuner' 1-0043: VIDIOC_G_TUNER
[  216.514505] tuner' 1-0043: Cmd VIDIOC_G_TUNER accepted for analog TV
[  216.515291] tuner' 1-0061: VIDIOC_G_TUNER
[  216.515301] tuner' 1-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
[  216.517244] tuner' 1-0043: VIDIOC_S_TUNER
[  216.517256] tuner' 1-0043: Cmd VIDIOC_S_TUNER accepted for analog TV
[  216.517261] tuner' 1-0061: VIDIOC_S_TUNER
[  216.517265] tuner' 1-0061: Cmd VIDIOC_S_TUNER accepted for analog TV
[  216.518293] tuner' 1-0043: VIDIOC_S_CTRL
[  216.518301] tuner' 1-0061: VIDIOC_S_CTRL
...
[  216.527551] tuner' 1-0043: VIDIOC_S_CTRL
[  216.527562] tuner' 1-0061: VIDIOC_S_CTRL
[  216.672678] cx25840' 1-0044: enable output



I can upload a sample of a captured MPEG with distortion.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
