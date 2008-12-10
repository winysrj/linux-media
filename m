Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBB00UV4003250
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 19:00:30 -0500
Received: from mail.cs.helsinki.fi (courier.cs.helsinki.fi [128.214.9.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBANwNDe031481
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 18:58:50 -0500
From: Mikko Rauhala <mjrauhal@cc.helsinki.fi>
To: video4linux-list@redhat.com
Date: Thu, 11 Dec 2008 01:58:21 +0200
Message-Id: <1228953501.6908.21.camel@phantom.hip>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Subject: Getting "Unknown em28xx video grabber" to work?
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

Hello

I just noticed that my external LG DVD drive, which happens to have
video input, is actually recognized by Ubuntu 8.10's kernel as a v4l
device:

[   58.236269] em28xx #0: V4L2 device registered as /dev/video0
and /dev/vbi0
[   58.236272] em28xx #0: Found Unknown EM2750/28xx video grabber
[   58.236350] em28xx audio device (eb1a:2861): interface 1, class 1
[...]
[   11.640274] scsi 6:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-E20N
1.03 PQ: 0 ANSI: 0

Now, it could be handy sometimes to get some video input in through
there, so I tried it with my pocket cam's video output (which hopefully
works itself...). Nothing worked, in the end, getting blackness or
sometimes blackness with the bottom of the screen including green lines
(that with streamer -n pal -s 720x576 -o foo.ppm). cat /dev/video0, like
other ways to try to access the device, do light up an access led on the
drive.

Is there some idiot-proof way to see if it can be set up properly to
receive video or is there just no support for this particular thing?
I've not much experience with v4l, but see below for some stuff I tried.

mjr@phantom:~$ xawtv
This is xawtv-3.95.dfsg.1, running on Linux/x86_64 (2.6.27-9-generic)
xinerama 0: 1920x1200+1920+0
xinerama 1: 1920x1200+0+0
WARNING: No DGA direct video mode for this display.
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string
"-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
ioctl: VIDIOC_S_INPUT(int=0): Invalid argument

mjr@phantom:~$ v4lctl -c /dev/video0 setinput Composite
invalid value for input: Composite
valid choices for "input": 

(Yes, there's nothing there for valid choices.)

mjr@phantom:~$ dov4l -q
dov4l v0.9, (C) 2003-2006 by folkert@vanheusden.com

Canonical name for this interface: Unknown EM2750/28xx video grabb
Type of interface:
 Can capture to memory

Number of radio/tv channels if appropriate: 0
Number of audio devices if appropriate: 0
Maximum capture width in pixels: 720
Maximum capture height in pixels: 576
Minimum capture width in pixels: 48
Minimum capture height in pixels: 32

Image size (x,y): 720, 576

Brightness: 32896
Hue: 32896
Colour: 32896
Contrast: 32896
Whiteness: 0
Depth: 16
Palette: Describe me

mjr@phantom:~$ mplayer tv://
MPlayer 1.0rc2-4.3.2 (C) 2000-2007 MPlayer Team
CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ (Family: 15, Model:
35, Stepping: 2)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Unknown EM2750/28xx video grabb
 Capabilites:  video capture  audio  read/write  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4
= NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 =
PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B;
16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 = SECAM-Lc;
 inputs:
 Current input: 0
 Current format: YUYV
v4l2: ioctl enum input failed: Invalid argument
Selected input hasn't got a tuner!
xscreensaver_disable: Could not find XScreenSaver window.
GNOME screensaver disabled
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
VDec: using Packed YUY2 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 640x480 => 640x480 Packed YUY2 
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
^C

mjr@phantom:~$ cat /dev/video0 | od -x
0000000 8010 8010 8010 8010 8010 8010 8010 8010
*
^C
mjr@phantom:~$ cat /dev/video0 | od -x
[...]
3075400 0000 0000 0000 0000 0000 0000 0000 0000
*
3100240 8010 8010 8010 8010 8010 8010 8010 8010
*
3103100 0000 0000 0000 0000 0000 0000 0000 0000
*
3105740 8010 8010 8010 8010 8010 8010 8010 8010
[...]

And so forth; any suggestions?

-- 
Mikko Rauhala <mjr@iki.fi>       - http://www.iki.fi/mjr/blog/  
The Finnish Pirate Party         - http://piraattipuolue.fi/  
World Transhumanist Association  - http://transhumanism.org/  
Singularity Institute            - http://singinst.org/  


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
