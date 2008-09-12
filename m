Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8C301ow016389
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 23:00:02 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8C2xn0I022271
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 22:59:50 -0400
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
In-Reply-To: <48C9D060.6080808@edgehp.net>
References: <48C9D060.6080808@edgehp.net>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 22:59:32 -0400
Message-Id: <1221188372.2648.100.camel@morgan.walls.org>
Mime-Version: 1.0
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

On Thu, 2008-09-11 at 22:13 -0400, Dale Pontius wrote:
> I'm trying to get an Hauppauge HVR-1600 card running, based on 
> information from the Gentoo Wiki, the IVTV Wiki, google, and lists. 
> (This list, the mythtv list, and searching LIRC archives.)



> I'm running a 2.6.25 kernel and v4l-dvb sources pulled tonight.

Those should be fine for cx18.

>   As a 
> side note, the saa5249 driver with this drop does not compile for me.  I 
> don't remember from previous attempts if it's needed or not.

You shouldn't for an HVR-1600.


>   Google 
> hasn't helped me determine this.  I also tried Andy Walls' tree a few 
> weeks back, but for some reason it didn't integrate properly with my 
> source tree, and though it compiled, it didn't install any modules.

Make install problems should be related to my tree, but that's a moot
point.  The latest v4l-dvb has all of my latest changes.



> Incidentally, this system also has a bttv card installed, which I'm 
> currently using for video capture.  I hope to replace it with a pair of 
> HVR-1600s.

FYI cx18 doesn't support analog VBI right now.  If you need closed
captions and the bttv card provides it, you may wish to keep it in for
now.

> -------------------------------------------------------------------------------
> When I try "mplayer /dev/video1" it suggests I try a few options.  I did 
> some trial and error with that, and with modprobe ivtv before cx18. So 
> the latest when I try "mplayer -vf spp,scale /dev/video1":
> -------------------------------------------------------------------------------
> MPlayer dev-SVN-r26753-4.1.2 (C) 2000-2008 MPlayer Team
> CPU: AMD Athlon(tm) 64 Processor 3000+ (Family: 15, Model: 47, Stepping: 0)
> SSE2 supported but disabled
> 3DNowExt supported but disabled
> CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 0 SSE: 1 SSE2: 0
> Compiled for x86 CPU with extensions: MMX MMX2 3DNow SSE
> 
> Playing /dev/video1.
> MPEG-PS file format detected.
> VIDEO:  MPEG2  384x288  (aspect 2)  29.970 fps  8000.0 kbps (1000.0 kbyte/s)
                 ^^^^^^^
That resolution seems really odd to me ATM.


> Opening video filter: [scale]
> Opening video filter: [spp]
> ==========================================================================
> Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
> VDec: vo config request - 384 x 288 (preferred colorspace: Mpeg PES)
> [PP] Using external postprocessing filter, max q = 6.
> Could not find matching colorspace - retrying with -vf scale...
> Opening video filter: [scale]
> The selected video_out device is incompatible with this codec.
> Try appending the scale filter to your filter list,
> e.g. -vf spp,scale instead of -vf spp.
> VDecoder init failed :(
> Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
> Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
> ==========================================================================
> ==========================================================================
> Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
> AUDIO: 48000 Hz, 2 ch, s16le, 224.0 kbit/14.58% (ratio: 28000->192000)
> Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
> ==========================================================================
> AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
> Starting playback...
> VDec: vo config request - 384 x 288 (preferred colorspace: Planar YV12)
> [PP] Using external postprocessing filter, max q = 6.
> VDec: using Planar YV12 as output csp (no 0)
> Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
> [swscaler @ 0x87804b8]using unscaled yuv420p -> yuv420p special converter
> VO: [xv] 384x288 => 384x288 Planar YV12
> A:   0.5 V:   0.0 A-V:  0.504 ct:  0.000   1/  1 ??% ??% ??,?% 0 0 [J 
> A:   0.5 V:   0.8 A-V: -0.296 ct: -0.003   2/  2 ??% ??% ??,?% 0 0 [J 
> A:   0.6 V:   0.9 A-V: -0.244 ct: -0.007   3/  3 ??% ??% ??,?% 1 0
> [J A:   1.2 V:   1.3 A-V: -0.086 ct: -0.047  15/ 15 ??% ??% ??,?% 6 0
> ...
> [J A:   1.2 V:   1.3 A-V: -0.093 ct: -0.050  16/ 16 13% 61% 97.5% 7 0 
> [J A:   1.2 V:   1.3 A-V: -0.103 ct: -0.053  17/ 17 12% 61% 91.5% 8 0 
> [J A:   1.3 V:   1.4 A-V: -0.051 ct: -0.057  18/ 18 11% 62% 108.8% 9 0
> ...
> [J A:   3.8 V:   2.8 A-V:  1.058 ct: -0.197  60/ 60  5% 66% 236.5% 49 
> 0 [J A:   3.9 V:   2.8 A-V:  1.110 ct: -0.200  61/ 61  5% 66% 240.2% 
> 50 0 [J
> 
>             ************************************************
>             **** Your system is too SLOW to play this!  ****
>             ************************************************
> 
> Possible reasons, problems, workarounds:
> - Most common: broken/buggy _audio_ driver
>    - Try -ao sdl or use the OSS emulation of ALSA.
>    - Experiment with different values for -autosync, 30 is a good start.
> - Slow video output
>    - Try a different -vo driver (-vo help for a list) or try -framedrop!
> - Slow CPU
>    - Don't try to play a big DVD/DivX on a slow CPU! Try some of the 
> lavdopts,
>      e.g. -vfm ffmpeg -lavdopts lowres=1:fast:skiploopfilter=all.
> - Broken file
>    - Try various combinations of -nobps -ni -forceidx -mc 0.
> - Slow media (NFS/SMB mounts, DVD, VCD etc)
>    - Try -cache 8192.
> - Are you using -cache to play a non-interleaved AVI file?
>    - Try -nocache.
> Read DOCS/HTML/en/video.html for tuning/speedup tips.
> If none of this helps you, read DOCS/HTML/en/bugreports.html.
> 
> A:   4.0 V:   2.8 A-V:  1.161 ct: -0.204  62/ 62  5% 66% 243.9% 51 0 [J 
> A:   4.1 V:   2.9 A-V:  1.213 ct: -0.207  63/ 63  5% 65% 248.3% 52 0 [J 
> A:   4.1 V:   2.9 A-V:  1.204 ct: -0.210  64/ 64  5% 65% 244.4% 53 0
> ...
> [J A:   4.6 V:   3.2 A-V:  1.424 ct: -0.240  73/ 73  5% 65% 248.8% 61 0
> [J A:   4.7 V:   3.2 A-V:  1.476 ct: -0.244  74/ 74  5% 65% 250.7% 62 0 [J
> Exiting... (Quit)
> ---------------------------------------------------------------------------------
> I would truly appreciate any suggestions or instructions for getting 
> this beast working.

OK. Some questions and things to try:

1. Do you set the mmio_ndelay module option to anything specific when
you load the cx18 module?  (The very latest v4l-dvb defaults it to 0).

2. What does dmesg or /var/log/messages output look like when the module
is loaded?


3. What is the output of

   $ v4l2-ctl -d /dev/video1 --log-status


4. Do this sequence of commands

   $ cat /dev/video1 > foo0.mpg
   ^C
   $ cat /dev/video1 > foo1.mpg    
   ^C
   $ mplayer foo1.mpg -vo x11

(You can drop the '-vo x11' if you now your card supports Xv with X.)

Do you see a good capture being played back?  The first analog capture
in file foo0.mpg will playback in a jumpy manner: it's a known cx18 bug.


5. Run a capture using caching but not scaling

   $ mplayer /dev/video1 -cache 16384 -vo x11

(Again drop the '-vo x11' if you know Xv works for you.)

That should be a buffered live capture.  The last numer on the mplayer
status line is the percent cache fill.  If it drops to 0 the playback
may get a little jumps every so often.

(I'm looking into how to remove the need to buffer output from the cx18
driver before playback - it's a driver problem.)


> When it's fully in service I plan to put it on 
> svideo behind a Comcast set-top box, using the IR blaster.
>   But I know 
> that's another ongoing story,

Yeah, fixing up the lirc_pvr150 driver to support the hvr1600 is on my
list of things to do, but it's way way down there.  It involves
capturing commands as they are issued to the Zilog chip on a windows
box; and I don't currently have a setup to do that.



>  just like cx18.  I see today on LKML that 
> they merged bidi LIRC for practically everything but the HVR-1600.

There's nothing to merge for the HVR-1600 really.  The lirc_pvr150
module itself really only needs minor modifications.  It's capturing the
library of octet strings to command the IR chip for the HVR-1600 that's
the hangup.

Regards,
Andy

> Thanks,
> Dale Pontius
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
