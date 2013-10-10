Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39123 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab3JJVAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 17:00:10 -0400
Received: by mail-lb0-f169.google.com with SMTP id z5so2623387lbh.14
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 14:00:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381371651.1889.21.camel@palomino.walls.org>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
	<1381371651.1889.21.camel@palomino.walls.org>
Date: Thu, 10 Oct 2013 22:00:07 +0100
Message-ID: <CAFoaQoBiLUK=XeuW31RcSeaGaX3VB6LmAYdT9BoLsz9wxReYHQ@mail.gmail.com>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Rajil Saraswat <rajil.s@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 October 2013 03:20, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2013-09-18 at 02:19 +0530, Rajil Saraswat wrote:
>> Hi,
>>
>>  I have a couple of PVR-500's which have additional tuners connected
>> to them (using daughter cards).
>
> The PVR-500's don't have daughter cards with additional tuners AFAIK.
>
> There is this however:
> http://www.hauppauge.com/site/webstore2/webstore_avcable-pci.asp
>
> Make sure you have any jumpers set properly and the cable connectors
> seated properly.
>
> Also make sure the cable is routed aways from any electrically noisy
> cards and high speed data busses: disk controller cards, graphics cards,
> etc.
>
>>  The audio is not usable on either
>> 1.4.2 or 1.4.3 ivtv drivers. The issue is described at
>> http://ivtvdriver.org/pipermail/ivtv-users/2013-September/010462.html
>
> With your previous working kernel and with the non-working kernel, what
> is the output of
>
> $ v4l2-ctl -d /dev/videoX --log-status
>
> after you have set up the inputs properly and have a known good signal
> going into the input in question?
>
> I'm speculating this is a problem with the cx25840 driver or the wm8775
> driver, since they change more often than the ivtv driver.

Yes, thats right it is a set of extra inputs and not a separate tuner
card. I played a video stream fro both kernels. Here are the logs

Working kernel 2.6.35
 v4l2-ctl -d /dev/video1 --log-status

Status Log:

   [50885.487963] ivtv1: =================  START STATUS CARD #1
=================
   [50885.487967] ivtv1: Version: 1.4.1 Card: WinTV PVR 500 (unit #2)
   [50885.541679] tveeprom 2-0050: Hauppauge model 23559, rev D591,
serial# 8228753
   [50885.541681] tveeprom 2-0050: tuner model is Philips FQ1216AME
MK4 (idx 91, type 56)
   [50885.541684] tveeprom 2-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D1/K) (eeprom 0x74)
   [50885.541686] tveeprom 2-0050: second tuner model is Philips
TEA5768HL FM Radio (idx 101, type 62)
   [50885.541688] tveeprom 2-0050: audio processor is CX25843 (idx 37)
   [50885.541690] tveeprom 2-0050: decoder processor is CX25843 (idx 30)
   [50885.541692] tveeprom 2-0050: has radio
   [50885.541698] ivtv1: GPIO status: DIR=0xdf01 OUT=0x26f3 IN=0x17e7
   [50885.545429] cx25840 2-0044: Video signal:              present
   [50885.545431] cx25840 2-0044: Detected format:           PAL-BDGHI
   [50885.545433] cx25840 2-0044: Specified standard:        PAL-BDGHI
   [50885.545435] cx25840 2-0044: Specified video input:     Composite 4
   [50885.545437] cx25840 2-0044: Specified audioclock freq: 48000 Hz
   [50885.553051] cx25840 2-0044: Detected audio mode:       forced mode
   [50885.553053] cx25840 2-0044: Detected audio standard:   no
detected audio standard
   [50885.553055] cx25840 2-0044: Audio muted:               no
   [50885.553057] cx25840 2-0044: Audio microcontroller:     stopped
   [50885.553059] cx25840 2-0044: Configured audio standard: automatic detection
   [50885.553061] cx25840 2-0044: Configured audio system:   automatic
standard and mode detection
   [50885.553063] cx25840 2-0044: Specified audio input:     External
   [50885.553064] cx25840 2-0044: Preferred audio mode:      stereo
   [50885.553066] cx25840 2-0044: Selected 65 MHz format:    system DK
   [50885.553068] cx25840 2-0044: Selected 45 MHz format:    chroma
   [50885.553070] tda9887 2-0043: Data bytes: b=0x94 c=0x6e e=0x49
   [50885.553073] tuner 2-0061: Tuner mode:      analog TV
   [50885.553075] tuner 2-0061: Frequency:       400.00 MHz
   [50885.553077] tuner 2-0061: Standard:        0x00000007
   [50885.553079] wm8775 2-001b: Input: 4
   [50885.553081] ivtv1: Video Input:  Composite 2
   [50885.553082] ivtv1: Audio Input:  Line In 2
   [50885.553084] ivtv1: Tuner:  TV
   [50885.553086] ivtv1: Stream: MPEG-2 Program Stream
   [50885.553088] ivtv1: VBI Format: No VBI
   [50885.553089] ivtv1: Video:  720x576, 25 fps
   [50885.553092] ivtv1: Video:  MPEG-2, 4x3, Variable Bitrate,
6000000, Peak 8000000
   [50885.553094] ivtv1: Video:  GOP Size 12, 2 B-Frames, GOP Closure
   [50885.553097] ivtv1: Audio:  48 kHz, MPEG-1/2 Layer II, 224 kbps,
Stereo, No Emphasis, No CRC
   [50885.553100] ivtv1: Spatial Filter:  Manual, Luma 1D Horizontal,
Chroma 1D Horizontal, 0
   [50885.553103] ivtv1: Temporal Filter: Manual, 8
   [50885.553105] ivtv1: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
   [50885.553106] ivtv1: Status flags:    0x00200000
   [50885.553109] ivtv1: Stream encoder MPG: status 0x0118, 15% of
16384 KiB (512 buffers) in use
   [50885.553112] ivtv1: Stream encoder YUV: status 0x0000, 0% of
20480 KiB (640 buffers) in use
   [50885.553114] ivtv1: Stream encoder VBI: status 0x0000, 0% of 1049
KiB (41 buffers) in use
   [50885.553117] ivtv1: Stream encoder PCM: status 0x0000, 0% of 643
KiB (143 buffers) in use
   [50885.553119] ivtv1: Read MPG/VBI: 56262656/0 bytes
   [50885.553121] ivtv1: ==================  END STATUS CARD #1
==================

For the non-working kernel 2.6.37

   [  212.730996] ivtv1: =================  START STATUS  =================
   [  212.731001] ivtv1: Version: 1.4.3 Card: WinTV PVR 500 (unit #2)
   [  212.784536] tveeprom 2-0050: Hauppauge model 23559, rev D591,
serial# 8228753
   [  212.784539] tveeprom 2-0050: tuner model is Philips FQ1216AME
MK4 (idx 91, type 56)
   [  212.784541] tveeprom 2-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D1/K) (eeprom 0x74)
   [  212.784542] tveeprom 2-0050: second tuner model is Philips
TEA5768HL FM Radio (idx 101, type 62)
   [  212.784544] tveeprom 2-0050: audio processor is CX25843 (idx 37)
   [  212.784545] tveeprom 2-0050: decoder processor is CX25843 (idx 30)
   [  212.784546] tveeprom 2-0050: has radio
   [  212.784551] ivtv1: GPIO status: DIR=0xdf01 OUT=0x26f3 IN=0x17e7
   [  212.784588] ivtv1-gpio: Mute: false
   [  212.787820] cx25840 2-0044: Video signal:              present
   [  212.787822] cx25840 2-0044: Detected format:           PAL-BDGHI
   [  212.787823] cx25840 2-0044: Specified standard:        PAL-BDGHI
   [  212.787824] cx25840 2-0044: Specified video input:     Composite 4
   [  212.787825] cx25840 2-0044: Specified audioclock freq: 48000 Hz
   [  212.795328] cx25840 2-0044: Detected audio mode:       forced mode
   [  212.795329] cx25840 2-0044: Detected audio standard:   no
detected audio standard
   [  212.795330] cx25840 2-0044: Audio microcontroller:     stopped
   [  212.795332] cx25840 2-0044: Configured audio standard: automatic detection
   [  212.795333] cx25840 2-0044: Configured audio system:   automatic
standard and mode detection
   [  212.795334] cx25840 2-0044: Specified audio input:     External
   [  212.795335] cx25840 2-0044: Preferred audio mode:      stereo
   [  212.795336] cx25840 2-0044: Selected 65 MHz format:    system DK
   [  212.795337] cx25840 2-0044: Selected 45 MHz format:    chroma
   [  212.807207] cx25840 2-0044: IR Receiver:
   [  212.807208] cx25840 2-0044:       Enabled:                           no
   [  212.807209] cx25840 2-0044:       Demodulation from a carrier:
    disabled
   [  212.807210] cx25840 2-0044:       FIFO:
    disabled
   [  212.807211] cx25840 2-0044:       Pulse timers' start/stop
trigger:  disabled
   [  212.807212] cx25840 2-0044:       FIFO data on pulse timer
overflow: overflow marker
   [  212.807212] cx25840 2-0044:       FIFO data on pulse timer
overflow: overflow marker
   [  212.807213] cx25840 2-0044:       FIFO interrupt watermark:
    half full or greater
   [  212.807214] cx25840 2-0044:       Loopback mode:
    normal receive
   [  212.807215] cx25840 2-0044:       Max measurable pulse width:
    318144512 us, 318144512000 ns
   [  212.807216] cx25840 2-0044:       Low pass filter:
    disabled
   [  212.807217] cx25840 2-0044:       Pulse width timer timed-out:       no
   [  212.807218] cx25840 2-0044:       Pulse width timer time-out
intr:   enabled
   [  212.807219] cx25840 2-0044:       FIFO overrun:                      no
   [  212.807220] cx25840 2-0044:       FIFO overrun interrupt:
    enabled
   [  212.807221] cx25840 2-0044:       Busy:                              no
   [  212.807222] cx25840 2-0044:       FIFO service requested:            no
   [  212.807223] cx25840 2-0044:       FIFO service request
interrupt:    enabled
   [  212.807223] cx25840 2-0044: IR Transmitter:
   [  212.807224] cx25840 2-0044:       Enabled:                           no
   [  212.807225] cx25840 2-0044:       Modulation onto a carrier:
    disabled
   [  212.807226] cx25840 2-0044:       FIFO:
    disabled
   [  212.807227] cx25840 2-0044:       FIFO interrupt watermark:
    half full or less
   [  212.807228] cx25840 2-0044:       Carrier polarity:
    space:noburst mark:burst
   [  212.807229] cx25840 2-0044:       Max pulse width:
    318144512 us, 318144512000 ns
   [  212.807230] cx25840 2-0044:       Busy:                              no
   [  212.807231] cx25840 2-0044:       FIFO service requested:            yes
   [  212.807232] cx25840 2-0044:       FIFO service request
interrupt:    enabled
   [  212.807233] cx25840 2-0044: Brightness: 128
   [  212.807234] cx25840 2-0044: Contrast: 63
   [  212.807235] cx25840 2-0044: Saturation: 63
   [  212.807237] cx25840 2-0044: Hue: 0
   [  212.807238] cx25840 2-0044: Volume: 60928
   [  212.807239] cx25840 2-0044: Mute: false
   [  212.807240] cx25840 2-0044: Balance: 32768
   [  212.807241] cx25840 2-0044: Bass: 32768
   [  212.807242] cx25840 2-0044: Treble: 32768
   [  212.807244] tda9887 2-0043: Data bytes: b=0x94 c=0x6e e=0x49
   [  212.807246] tuner 2-0061: Tuner mode:      analog TV
   [  212.807247] tuner 2-0061: Frequency:       400.00 MHz
   [  212.807248] tuner 2-0061: Standard:        0x00000007
   [  212.807249] wm8775 2-001b: Input: 4
   [  212.807250] wm8775 2-001b: Mute: false
   [  212.807251] wm8775 2-001b: Volume: 52992
   [  212.807253] wm8775 2-001b: Balance: 32768
   [  212.807254] wm8775 2-001b: Loudness: true
   [  212.807256] ivtv1: Video Input:  Composite 2
   [  212.807256] ivtv1: Audio Input:  Line In 2
   [  212.807257] ivtv1: Tuner:  TV
   [  212.807258] ivtv1: Stream Type: MPEG-2 Program Stream grabbed
   [  212.807260] ivtv1: Stream VBI Format: No VBI grabbed
   [  212.807261] ivtv1: Audio Sampling Frequency: 48 kHz grabbed
   [  212.807263] ivtv1: Audio Encoding: MPEG-1/2 Layer II grabbed
   [  212.807264] ivtv1: Audio Layer II Bitrate: 224 kbps grabbed
   [  212.807265] ivtv1: Audio Stereo Mode: Stereo
   [  212.807266] ivtv1: Audio Stereo Mode Extension: Bound 4 inactive
   [  212.807268] ivtv1: Audio Emphasis: No Emphasis
   [  212.807269] ivtv1: Audio CRC: No CRC
   [  212.807270] ivtv1: Audio Mute: false
   [  212.807271] ivtv1: Video Encoding: MPEG-2
   [  212.807272] ivtv1: Video Aspect: 4x3
   [  212.807273] ivtv1: Video B Frames: 2
   [  212.807274] ivtv1: Video GOP Size: 15
   [  212.807276] ivtv1: Video GOP Closure: true
   [  212.807277] ivtv1: Video Bitrate Mode: Variable Bitrate grabbed
   [  212.807278] ivtv1: Video Bitrate: 6000000 grabbed
   [  212.807279] ivtv1: Video Peak Bitrate: 8000000 grabbed
   [  212.807281] ivtv1: Video Temporal Decimation: 0
   [  212.807282] ivtv1: Video Mute: false
   [  212.807283] ivtv1: Video Mute YUV: 32896
   [  212.807284] ivtv1: Spatial Filter Mode: Manual
   [  212.807285] ivtv1: Spatial Filter: 0
   [  212.807286] ivtv1: Spatial Luma Filter Type: 1D Horizontal
   [  212.807287] ivtv1: Spatial Chroma Filter Type: 1D Horizontal
   [  212.807288] ivtv1: Temporal Filter Mode: Manual
   [  212.807289] ivtv1: Temporal Filter: 8
   [  212.807290] ivtv1: Median Filter Type: Off
   [  212.807291] ivtv1: Median Luma Filter Minimum: 0 inactive
   [  212.807293] ivtv1: Median Luma Filter Maximum: 255 inactive
   [  212.807294] ivtv1: Median Chroma Filter Minimum: 0 inactive
   [  212.807295] ivtv1: Median Chroma Filter Maximum: 255 inactive
   [  212.807297] ivtv1: Insert Navigation Packets: false
   [  212.807298] ivtv1: Status flags:    0x00200000
   [  212.807300] ivtv1: Stream encoder MPG: status 0x0118, 18% of
16384 KiB (512 buffers) in use
   [  212.807301] ivtv1: Stream encoder YUV: status 0x0000, 0% of
20480 KiB (640 buffers) in use
   [  212.807303] ivtv1: Stream encoder VBI: status 0x0000, 0% of 1049
KiB (41 buffers) in use
   [  212.807304] ivtv1: Stream encoder PCM: status 0x0000, 0% of 643
KiB (143 buffers) in use
   [  212.807305] ivtv1: Read MPG/VBI: 65054720/0 bytes
   [  212.807306] ivtv1: ==================  END STATUS  ==================

The 3.10.7 kernel has extra wm8775 parameters and  cx25840 parameters
than 2.6.35.

Any clues from above?

Unfortunately, i cannot do a git bisect since it is a remote system
with a slow internet connection.
