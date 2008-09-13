Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8D0J2K2028739
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 20:19:02 -0400
Received: from mho-02-bos.mailhop.org (mho-02-bos.mailhop.org [63.208.196.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8D0IqIC015314
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 20:18:52 -0400
Message-ID: <48CB06EF.9020803@edgehp.net>
Date: Fri, 12 Sep 2008 20:18:55 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <48C9D060.6080808@edgehp.net>
	<1221188372.2648.100.camel@morgan.walls.org>
In-Reply-To: <1221188372.2648.100.camel@morgan.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge HVR-1600 (cx18) newbie - stuff loads, can't get output
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

Andy Walls wrote:
> On Thu, 2008-09-11 at 22:13 -0400, Dale Pontius wrote:
>   
Thanks for all of the info.  Cutting to save space, more specifics below.
>> -------------------------------------------------------------------------------
>> When I try "mplayer /dev/video1" it suggests I try a few options.  I did 
>> some trial and error with that, and with modprobe ivtv before cx18. So 
>> the latest when I try "mplayer -vf spp,scale /dev/video1":
>> -------------------------------------------------------------------------------
>> MPlayer dev-SVN-r26753-4.1.2 (C) 2000-2008 MPlayer Team
>> CPU: AMD Athlon(tm) 64 Processor 3000+ (Family: 15, Model: 47, Stepping: 0)
>> SSE2 supported but disabled
>> 3DNowExt supported but disabled
>> CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 0 SSE: 1 SSE2: 0
>> Compiled for x86 CPU with extensions: MMX MMX2 3DNow SSE
>>
>> Playing /dev/video1.
>> MPEG-PS file format detected.
>> VIDEO:  MPEG2  384x288  (aspect 2)  29.970 fps  8000.0 kbps (1000.0 kbyte/s)
>>     
>                  ^^^^^^^
> That resolution seems really odd to me ATM.
>   
It's worth noting that MythTV has tried to use the card.  It's default 
resolution for the bttv card is 480x480, so I'm not sure what's 
happening here.  On other attempts I've seen it start up at 720x480.


<snip>
>
> OK. Some questions and things to try:
>
> 1. Do you set the mmio_ndelay module option to anything specific when
> you load the cx18 module?  (The very latest v4l-dvb defaults it to 0).
>   
I have not tried that.  This is an nForce4 board, with PCIe, so I 
believe that pretty much guarantees that it's PCI 2.3.  In addition I 
verified that I have a subtractive pci bridge, if I remember your 
earlier posts.  I did as you suggested there, and read the whole i2c/pci 
thread, and I think I'm good.
> 2. What does dmesg or /var/log/messages output look like when the module
> is loaded?
>   
cx18-0: unregister DVB
ACPI: PCI interrupt for device 0000:05:08.0 disabled
cx18-0: Removed Hauppauge HVR-1600, card #0
cx18:  Start initialization, version 1.0.0
cx18-0: Initializing card #0
cx18-0: Autodetected Hauppauge card
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, 
low) -> IRQ 18
cx18-0: cx23418 revision 01010000 (B)
tveeprom 6-0050: Hauppauge model 74041, rev C6B2, serial# 3334244
tveeprom 6-0050: MAC address is 00-0D-FE-32-E0-64
tveeprom 6-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 6-0050: audio processor is CX23418 (idx 38)
tveeprom 6-0050: decoder processor is CX23418 (idx 31)
tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
cx18-0: Autodetected Hauppauge HVR-1600
cx18-0: VBI is not yet supported
cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
cx18-0: Disabled encoder IDX device
cx18-0: Registered device video1 for encoder MPEG (2 MB)
DVB: registering new adapter (cx18)
MXL5005S: Attached at address 0x63
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: DVB Frontend registered
cx18-0: Registered device video32 for encoder YUV (2 MB)
cx18-0: Registered device video24 for encoder PCM audio (1 MB)
cx18-0: Initialized card #0: Hauppauge HVR-1600
cx18:  End initialization

Incidentally, I unloaded cx18, then reloaded it.  That looks like the 
first 3 lines.  In addition, note that there is no firmware load.  It 
only appears that firmware is loaded when the first client attaches.  
This appears a bit later in /var/log/messages:

Sep 12 15:41:12 localhost cx18-0: loaded v4l-cx23418-apu.fw firmware 
V00120000 (141200 bytes)
Sep 12 15:41:12 localhost cx18-0: loaded v4l-cx23418-cpu.fw firmware 
(158332 bytes)
Sep 12 15:41:12 localhost cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
Sep 12 15:41:13 localhost cx18-0: loaded v4l-cx23418-dig.fw firmware 
(16382 bytes)

> 3. What is the output of
>
>    $ v4l2-ctl -d /dev/video1 --log-status
>   
Status Log:

   cx18-0: =================  START STATUS CARD #0  =================
   tveeprom 6-0050: Hauppauge model 74041, rev C6B2, serial# 3334244
   tveeprom 6-0050: MAC address is 00-0D-FE-32-E0-64
   tveeprom 6-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
   tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
   tveeprom 6-0050: audio processor is CX23418 (idx 38)
   tveeprom 6-0050: decoder processor is CX23418 (idx 31)
   tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
   cx18-0: Video signal:              not present
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
   cs5345 6-004c: Input:  1
   cs5345 6-004c: Volume: 0 dB
   cx18-0: Video Input: Tuner 1
   cx18-0: Audio Input: Tuner 1
   cx18-0: GPIO:  direction 0x00003001, value 0x00003001
   cx18-0: Tuner: TV
   cx18-0: Stream: MPEG-2 Program Stream
   cx18-0: VBI Format: No VBI
   cx18-0: Video:  720x480, 30 fps
   cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
   cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
   cx18-0: Audio:  48 kHz, MPEG-1/2 Layer II, 224 kbps, Stereo, No 
Emphasis, No CRC
   cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D 
Horizontal, 0
   cx18-0: Temporal Filter: Manual, 8
   cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
   cx18-0: Status flags: 0x00200001
   cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2016 KiB (63 
buffers) in use
   cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 
buffers) in use
   cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1008 KiB (63 
buffers) in use
   cx18-0: Read MPEG/VBI: 0/0 bytes
   cx18-0: ==================  END STATUS CARD #0  ==================

That "cx18-0: Video signal:              not present" has me worried.  I 
just reconnected the coax to the output of the splitter, and that feeds 
the bttv card just fine.  Then the "cx18-0: Specified video input:     
Composite 7" would make me think that I'm not looking at the tuner 
input, but "v4l2-ctl -d /dev/video1 --show" gives:

Driver Info:
    Driver name   : cx18
    Card type     : Hauppauge HVR-1600
    Bus info      : 0000:05:08.0
    Driver version: 65536
    Capabilities  : 0x01030001
        Video Capture
        Tuner
        Audio
        Read/Write
Format Video Capture:
    Width/Height  : 720/480
    Pixel Format  : MPEG
    Field         : Interlaced
    Bytes per Line: 0
    Size Image    : 131072
    Colorspace    : Broadcast NTSC/PAL (SMPTE170M/ITU601)
Format VBI Capture:
    Sampling Rate   : 27000000 Hz
    Offset          : 248 samples (9.18519e-06 secs after leading edge)
    Samples per Line: 1452
    Sample Format   : GREY
    Start 1st Field : 10
    Count 1st Field : 12
    Start 2nd Field : 273
    Count 2nd Field : 12
Crop Capability Video Capture:
    Bounds      : Left 0, Top 0, Width 720, Height 480
    Default     : Left 0, Top 0, Width 720, Height 480
    Pixel Aspect: 10/11
Video input : 0 (Tuner 1)
Audio input : 0 (Tuner 1)
Frequency: 0 (0.000000 MHz)
Video Standard = 0x00001000
    NTSC-M
Tuner:
    Capabilities         : 62.5 kHz stereo lang1 lang2
    Frequency range      : 0.0 MHz - 0.0 MHz
    Signal strength      : 0%
    Current audio mode   : lang1
    Available subchannels: mono

Which would indicate that the tuner is the live input.
> 4. Do this sequence of commands
>
>    $ cat /dev/video1 > foo0.mpg
>    ^C
>    $ cat /dev/video1 > foo1.mpg    
>    ^C
>    $ mplayer foo1.mpg -vo x11
>
> (You can drop the '-vo x11' if you now your card supports Xv with X.)
>
> Do you see a good capture being played back?  The first analog capture
> in file foo0.mpg will playback in a jumpy manner: it's a known cx18 bug.
>   
I get a red screen, which I guess is consistent with no signal.
>
> 5. Run a capture using caching but not scaling
>
>    $ mplayer /dev/video1 -cache 16384 -vo x11
>
> (Again drop the '-vo x11' if you know Xv works for you.)
>
> That should be a buffered live capture.  The last numer on the mplayer
> status line is the percent cache fill.  If it drops to 0 the playback
> may get a little jumps every so often.
>
> (I'm looking into how to remove the need to buffer output from the cx18
> driver before playback - it's a driver problem.)
>   
Also nothing.  Incidentally, it's now running at a more reasonable 
resolution:

Starting playback...
VDec: vo config request - 720 x 480 (preferred colorspace: Planar YV12)
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
VO: [x11] 720x480 => 720x540 Planar YV12


By the way, should I be doing a "modprobe ivtv" prior to "modprobe 
cx18"?  When I was fooling around with it the other night, I noticed 
that loading ivtv first did change the symptoms, and may have increased 
the apparent functionality, though I may also be interpreting that 
wrong.  I notice that there doesn't appear to be any direct dependence 
between ivtv and cx18, though both do use several other modules.  I also 
thought I saw that cx18 used pieces (as in source code) of ivtv, but 
didn't depend directly on it.  Is it also possible that ivtv is 
hurting?  A quick "rmmod ivtv cx18 && modprobe cx18", and the v4l2-ctl 
command above gives the same results.

I think the crux of my problem is the lack of video signal, but don't 
understand it.
Thanks for assistance, so far,
Dale

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
