Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steele.brian@gmail.com>) id 1KO1Wm-0000VS-Hy
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 04:35:03 +0200
Received: by qw-out-2122.google.com with SMTP id 9so116725qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 29 Jul 2008 19:34:55 -0700 (PDT)
Message-ID: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
Date: Tue, 29 Jul 2008 19:34:55 -0700
From: "Brian Steele" <steele.brian@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] HVR-1600 - No audio
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

Hi,

I'm attempting to capture from the HVR-1600 MPEG encoder and I can't
seem to get any audio.  I'm using the following procedure:

ivtv-tune -c 4
cat /dev/video0 > /tmp/test.mpg
mplayer /tmp/test.mpg

This displays a nice picture but no audio.  Output from mplayer
indicates that there is an audio stream present, but I hear nothing.

I ran v4l2-ctl --log-status and I got this:

   cx18-0: =================  START STATUS CARD #0  =================
   tveeprom 1-0050: Hauppauge model 74021, rev C1B2, serial# 1441469
   tveeprom 1-0050: MAC address is 00-0D-FE-15-FE-BD
   tveeprom 1-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
   tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
   tveeprom 1-0050: audio processor is CX23418 (idx 38)
   tveeprom 1-0050: decoder processor is CX23418 (idx 31)
   tveeprom 1-0050: has no radio, has IR receiver, has IR transmitter
   cx18-0: Video signal:              present
   cx18-0: Detected format:           NTSC-M
   cx18-0: Specified standard:        NTSC-M
   cx18-0: Specified video input:     Composite 7
   cx18-0: Specified audioclock freq: 48000 Hz
   cx18-0: Detected audio mode:       mono
   cx18-0: Detected audio standard:   no detected audio standard
   cx18-0: Audio muted:               yes
   cx18-0: Audio microcontroller:     running
   cx18-0: Configured audio standard: automatic detection
   cx18-0: Configured audio system:   BTSC
   cx18-0: Specified audio input:     Tuner (In8)
   cx18-0: Preferred audio mode:      stereo
   cs5345 1-004c: Input:  1
   cs5345 1-004c: Volume: 0 dB
   tuner 2-0061: Tuner mode:      analog TV
   tuner 2-0061: Frequency:       67.25 MHz
   tuner 2-0061: Standard:        0x00001000
   cx18-0: Video Input: Tuner 1
   cx18-0: Audio Input: Tuner 1
   cx18-0: GPIO:  direction 0x00003001, value 0x00003001
   cx18-0: Tuner: TV
   cx18-0: Stream: MPEG-2 Program Stream
   cx18-0: VBI Format: No VBI
   cx18-0: Video:  720x480, 30 fps
   cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
   cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
   cx18-0: Audio:  48 kHz, Layer II, 224 kbps, Stereo, No Emphasis, No CRC
   cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
   cx18-0: Temporal Filter: Manual, 8
   cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
   cx18-0: Status flags: 0x00200001
   cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2016 KiB (63
buffers) in use
   cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
   cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1008 KiB (63
buffers) in use
   cx18-0: Read MPEG/VBI: 5240832/0 bytes
   cx18-0: ==================  END STATUS CARD #0  ==================

I notice it says audio muted, so I checked the status of the mute controls:
v4l2-ctl -C mute gives me
mute: 1

v4l2-ctl -c mute=0 returns no errors, but if I run v4l2-ctl -C mute
again it still shows the value is 1.

v4l2-ctl -C audio_mute shows me audio_mute: 0, which seems correct

I turned on debugging in the cx18 driver and re-ran v4l2-ctl -c
mute=0.  The interesting parts of the output were:
cx18-0: VIDIOC_QUERYCTRL id=0x980909, type=2, name=Mute, min/max=0/1,
step=1, default=0, flags=0x00000000
cx18-0: VIDIOC_QUERYCTRL id=0x98090a, type=2, name=Mute, min/max=0/1,
step=1, default=0, flags=0x00000001
cx18-0: VIDIOC_QUERYCTRL id=0x99096d, type=2, name=Audio Mute,
min/max=0/1, step=1, default=0, flags=0x00000000
cx18-0: VIDIOC_QUERYCTRL id=0x990964, type=3, name=Audio Sampling
Frequency, min/max=0/2, step=1, default=1, flags=0x00000000
cx18-0: VIDIOC_QUERYCTRL id=0x990965, type=3, name=Audio Encoding
Layer, min/max=1/1, step=1, default=1, flags=0x00000008
cx18-0: VIDIOC_QUERYCTRL id=0x990967, type=3, name=Audio Layer II
Bitrate, min/max=9/13, step=1, default=10, flags=0x00000000
cx18-0: VIDIOC_QUERYCTRL id=0x990969, type=3, name=Audio Stereo Mode,
min/max=0/3, step=1, default=0, flags=0x00000008
cx18-0: VIDIOC_QUERYCTRL id=0x99096a, type=3, name=Audio Stereo Mode
Extension, min/max=0/3, step=1, default=0, flags=0x00000010
cx18-0: VIDIOC_QUERYCTRL id=0x99096b, type=3, name=Audio Emphasis,
min/max=0/2, step=1, default=0, flags=0x00000000
cx18-0: VIDIOC_QUERYCTRL id=0x99096c, type=3, name=Audio CRC,
min/max=0/1, step=1, default=0, flags=0x00000000
cx18-0: VIDIOC_QUERYCTRL id=0x99096d, type=2, name=Audio Mute,
min/max=0/1, step=1, default=0, flags=0x00000000
cx18-0: VIDIOC_QUERYCTRL id=0x0
cx18-0: VIDIOC_QUERYCTRL error -22
cx18-0: VIDIOC_S_CTRL id=0x980909, value=0

I see there are two different mute controls there, one that is on and
one that is off.  I have no idea why this is.

I'm using v4l-dvb pulled from hg about 2 hours ago.  Does anybody have
any ideas what else I can do to debug this or how to fix it?

Thanks,
Brian

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
