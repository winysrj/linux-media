Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steele.brian@gmail.com>) id 1KPl8L-0003Ti-GI
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 23:29:00 +0200
Received: by yw-out-2324.google.com with SMTP id 3so833055ywj.41
	for <linux-dvb@linuxtv.org>; Sun, 03 Aug 2008 14:28:53 -0700 (PDT)
Message-ID: <5f8558830808031428u3c9a8191tcd1705b27087f992@mail.gmail.com>
Date: Sun, 3 Aug 2008 14:28:53 -0700
From: "Brian Steele" <steele.brian@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1217791214.2690.31.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - No audio
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

On Sun, Aug 3, 2008 at 12:20 PM, Andy Walls <awalls@radix.net> wrote:

> OK.  I'm going to assume you're working with the latest version of the
> cx18-av microcontroller firmware
> ( http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz ).

Yes, I am.

> So we'll go with the tried and true axiom of "the bug was caused by the
> last thing I changed".
>
> On Jul 23 & 25 I made some changes to the cx18-av-audio.c file to fix
> the 32 kHz sample rate, lock the Video PLL and Audio PLL together, and
> fine tune the video sample rate PLL values.
>
> I've just put in a small change at
>
> http://linuxtv.org/hg/~awalls/v4l-dvb
>
> to back out the part of the change that locked the video PLL & the audio
> PLL together for both tuner and line in audio.
>
> See if that change makes things work for you.

Unfortunately it doesn't.  This is the output of v4l2-ctl --log-status
with your update after make, make install, make unload, modprobe cx18,
tuning a channel, and doing three test captures.

  cx18-0: =================  START STATUS CARD #0  =================
   tveeprom 0-0050: Hauppauge model 74021, rev C1B2, serial# 1441469
   tveeprom 0-0050: MAC address is 00-0D-FE-15-FE-BD
   tveeprom 0-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
   tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
   tveeprom 0-0050: audio processor is CX23418 (idx 38)
   tveeprom 0-0050: decoder processor is CX23418 (idx 31)
   tveeprom 0-0050: has no radio, has IR receiver, has IR transmitter
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
   cs5345 0-004c: Input:  1
   cs5345 0-004c: Volume: 0 dB
   tuner 1-0061: Tuner mode:      analog TV
   tuner 1-0061: Frequency:       163.25 MHz
   tuner 1-0061: Standard:        0x00001000
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
   cx18-0: Read MPEG/VBI: 7720960/0 bytes
   cx18-0: ==================  END STATUS CARD #0  ==================

>
> BTW, Did the cx18 driver ever work properly for tuner audio for you
> before?
>

I bought the card on July 27 from a friend who has had it sitting in
his closet for a year and a half.  This is the first time anybody has
ever installed it in a system and tried to get it working.  I'm
starting to wonder if maybe I have a defective card.  I suppose I
could try installing it in a windows system and see if I can get
audio.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
