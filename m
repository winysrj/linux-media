Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0ANCED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 21:04:03 -0500
Date: Wed, 13 Jan 2010 21:03:57 -0500
From: Ralph Siemsen <ralphs@netwinder.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: cx23885 oops during loading, WinTV-HVR-1850 card -- SOLVED
Message-ID: <20100114020357.GA18559@harvey.netwinder.org>
References: <20100108191459.GJ2257@harvey.netwinder.org>
 <20100109015521.GK2257@harvey.netwinder.org>
 <829197381001081806i29b3898fn28de19a9d1beb61d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829197381001081806i29b3898fn28de19a9d1beb61d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 08, 2010 at 09:06:01PM -0500, Devin Heitmueller wrote:
> 
> The cx23885 driver doesn't work with tvtime, due to bugs in the v4l
> controls in the driver.  Michael Krufky has some patches but they need
> some more work before they can go in the mainline.  Even if they were
> committed though, there is currently no support for raw audio, so
> tvtime would not be a good application to use for this device.

Thanks for the tip.  I've tried all the other clients I could get my
hands on, including xawtv, mplayer, and xine.  Unfortunately, I have
not managed to get a picture (or even an empty window) out of them.
Is there a way to get it working?

Mplayer plays local media files and DVDs happily, but when I
try to input from /dev/video, or use the tv:// args, it complains:
    v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
over and over again.  The other clients just hang or exit.

I'm not sure what to try next.  Here is a typical log, I have tried
many variations, but the end result is always the same.

$ mplayer tv://4 -tv norm=NTSC-M:chanlist=us-bcast
MPlayer SVN-r29800-4.4.2 (C) 2000-2009 MPlayer Team
[...]
Playing tv://4.
STREAM: [tv] tv://4
STREAM: Description: TV Input
STREAM: Author: Benjamin Zores, Albeu
STREAM: Comment: 
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Hauppauge WinTV-HVR1850
 Tuner cap: STEREO LANG1 LANG2
 Tuner rxs: MONO LANG2
 Capabilites:  video capture  tuner  read/write  streaming
 supported norms: 0 = NTSC-M; 1 = NTSC-M-JP; 2 = NTSC-443; 3 = PAL-BG; 4 = PAL-I; 5 = PAL-DK; 6 = PAL-M; 7 = PAL-N; 8 = PAL-Nc; 9 = PAL-60; 10 = SECAM-DK; 11 = SECAM-L;
 inputs:
 Current input: 0
 Format unknown (0x4745504d) ( 0 bits, MPEG): Unknown 0x4745504d
 Current format: unknown (0x4745504d)
v4l2: current audio mode is : LANG1
v4l2: set format: YVU420
v4l2: set input: 0
v4l2: ioctl enum input failed: Invalid argument
Selected norm : NTSC-M
v4l2: set norm: NTSC-M
Selected channel list: us-bcast (including 82 channels)
Requested channel: 4
Selected channel: 4 (freq: 67.250)
Current frequency: 1076 (67.250)
Current frequency: 1076 (67.250)
==> Found video stream: 0
v4l2: get format: unknown (0x4745504d)
v4l2: get fps: 29.970030
v4l2: get width: 720
v4l2: get height: 480
Using a ring buffer for maximum 2 frames, 0 MB total size.
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
[V] filefmt:9  fourcc:0x4745504D  size:720x480  fps:29.970  ftime:=0.0334
[vdpau] Could not open dynamic library libvdpau.so.1
X11 opening display: :0.0
vo: X11 color mask:  FFFFFF  (R:FF0000 G:FF00 B:FF)
vo: X11 running at 848x480 with depth 24 and 32 bpp (":0.0" => local display)
[x11] Detected wm supports NetWM.
[x11] Detected wm supports FULLSCREEN state.
[x11] Detected wm supports ABOVE state.
[x11] Detected wm supports BELOW state.
[x11] Current fstype setting honours FULLSCREEN ABOVE BELOW X atoms
[VO_XV] Using Xv Adapter #0 (Intel(R) Textured Video)
[xv common] Drawing no colorkey.
[xv common] Maximum source image dimensions: 2048x2048
==========================================================================
Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
VDec: vo config request - 720 x 480 (preferred colorspace: Mpeg PES)
Trying filter chain: vo
Could not find matching colorspace - retrying with -vf scale...
Opening video filter: [scale]
SwScale params: -1 x -1 (-1=no scaling)
Trying filter chain: scale vo
The selected video_out device is incompatible with this codec.
Try appending the scale filter to your filter list,
e.g. -vf spp,scale instead of -vf spp.
VDecoder init failed :(
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Unsupported PixelFormat -1
INFO: libavcodec init OK!
Selected video codec: [ffmpeg1] vfm: ffmpeg (FFmpeg MPEG-1)
==========================================================================
Audio: no sound
Freeing 0 unused audio chunks.
Starting playback...
v4l2: going to capture
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
v4l2: ioctl dequeue buffer failed: Input/output error, idx = 0
...etc...

