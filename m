Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:36672 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbZDEWvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 18:51:14 -0400
Message-ID: <49D921E8.3050105@seznam.cz>
Date: Sun, 05 Apr 2009 23:26:00 +0200
From: "Ing. David Rehor" <drracer@seznam.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR-1300 experience
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear linuxtv developers,
   this is an email about my experience with the HVR-1300. I've been 
"fighting" with the Hauppauge HVR-1300 for almost 3 years in Linux. I'm 
pretty sure the card's hardware is ok, since most of its components did 
their job during the last years in Linux (not alltogether at once though 
:) ).
   During the years I've been watching the linuxtv site occasionally and 
I was trying various patches.

for the rest of the text:
#define hibernation "system suspend to disk using uswsusp v. 0.8"

---------------------------------------------
My current configuration:

Disto: Kubuntu 8.10 Interpid Ibex

Kernel: right now custom compiled kernel linux-2.6.27-7 PREEMPT (that 
comes with kubuntu). I have seen all the following issues in older 
kernels too (stock and/or custom built)

Machine: Intel Pentium4 1600MHz

V4l sources status: hg clone from the beginning of 2009

Analog signal: PAL-DK

i2c_udelay: 16

I use mplayer to watch TV. The symptoms described further apply to 
tvtime, kdetv, kaffeine etc. too though.

Mplayer cmdlines:
VBI:
   mplayer tv:// -tv ....

MPEG2:
   v4l2-ctl -d /dev/video1 --set-freq=some_frequency
   mplayer /dev/video1 -cache 8192
or even
   cat /dev/video1 > file.mpeg2

DVB:
   mplayer dvb://... with proper channels.conf from dvb-scan, when it 
last worked...

---------------------------------------------
The current status of tv via HVR-1300 on my computer is as follows:
- VBI works ok with proper stereo-sound + tuning channels, even S-Video 
works ok
- MPEG2 works ok (analog) with proper stereo sound + tuning channels, 
however see below...
- IR worked, when the lirc drivers were in the kernel
- DVB-T is a kind of mystery to me (explanation follows).
- analog radio - never managed to get any sound from it

Details:
VBI:
  The card tunes analog channels ok in mplayer. When changing channels 
in mplayer, the newly selected channel displays only in the topleft 
quarter of the window, the rest contains the last tv-frame of the 
previous channel mixed with garbage. Maybe it's an mplayer bug or maybe 
mplayer gets some inconsistent tv-picture resolution information from 
the v4l2 subsystem. This is not a problem for me, I'm not using VBI too 
much.

MPEG2 - cx88_blackbird:
   Works well IFF the tuner gets the selected frequency. Then the mpeg 
PS stream also contains a valid audio stream. The frequency problem was 
an issue (i2c write errors) in the previous kubuntu 8.04, the problem is 
gone now in the kubuntu 8.10.
   The v4l implicitly initialized the blackbird into NTSC, which was 
very annoying. I'm not sure, if the problem persists in the current v4l 
sources, I hardcoded it to PAL in the v4l sources for my machine.
   Setting different mpeg2 controls in the hvr-1300 firmware via v4l 
interface works also well, e.g. setting mpeg2 stream bitrate, audio 
bitrate, temporal and spatial filters setup etc.

DVB-T (+digital radio stations):
   DVB-T worked in kubuntu 8.04 only AFTER hibernation using kaffeine or 
mplayer. I'd say this has to do something with the different tuners on 
the card not being setup properly (or differently) during normal boot 
and during resume from hibernation.
   However, in the current kubuntu 8.10 the dvb-t does not work at all, 
the tuner timeouts when doing dvb-scan. I also tried the Kaffeine 
player, that worked in the 8.04 ok too, but again - only after 
hibernation. I'd really like to have the DVB-T work again...

Analog Radio:
Don't know, never managed to tune any existing station so far.

--------------------------------------------
And now the most interesting issue:

Hibernation:

   It is absolutely necessary to rmmod the following modules before 
hibernation on my machine:
rmmod cx88_blackbird
rmmod wm8775
rmmod cx88_dvb
rmmod cx8802

   If I forget to do the unloads, NO process must EVER touch the 
cx88_blackbird module after resume from hibernation until a HW reset of 
the system.
   If any process touches the blackbird (even starting xsane which scans 
for "scanning device" at start), the computer hangs really bad, only 
Ctrl-Alt-SysRq-B is a solution besides a HW reset.

After resume the following rmmod-modprobe sequence must be run 4 times 
(four times, not once, not twice, not three times, but four times!):
rmmod cx88_blackbird
rmmod wm8775
rmmod cx88_dvb
rmmod cx8802

modprobe wm8775
modprobe cx8802
modprobe cx88_blackbird
modprobe cx88_dvb

Why four times? It has definitely something to do with initialization of 
the wm8775 chip:
1. Doing the rmmod-modprobe sequence only once results in mpeg2 stream 
not containing ANY audio track.
2. Doing it twice results in mpeg2 stream containing muted audio track, 
but no way to unmute it.
3. Doing it three times results in mpeg2 stream containing audio track 
with just noise.
4. Doing it for the fourth time results finally in mpeg2 stream 
containing the expected and correct audio track.

Since then:
VBI - no problem
Blackbird works, event its audio source is correct (due to reloaded 
wm8775 module, which reinitializes the analog audio input chip).

----------------------------------------------

If any of you linuxtv developers is interested in debugging the above 
mentioned hibernation or the DVB-T and radio issues, please let me know. 
I'm ready to try various patches :)

Best regards,
David Rehor
