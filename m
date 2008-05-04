Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m44IPBgG020229
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 14:25:11 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m44IP0HJ002096
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 14:25:00 -0400
Received: by rv-out-0506.google.com with SMTP id f6so731601rvb.51
	for <video4linux-list@redhat.com>; Sun, 04 May 2008 11:24:59 -0700 (PDT)
Message-ID: <a93d57c00805041124m387d55k61aed378c8031054@mail.gmail.com>
Date: Sun, 4 May 2008 13:24:57 -0500
From: "Ryan Churches" <ryan.churches@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: no signal on /dev/videoX
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

I have two generic DVR cards with 8 chips eash.  Lspci says they are
bt878, and the manufacturer, who supports linux, says they are card=98
or "ProVideo 150".

I believe I've set everything up correctly, having followed howtos
from the v4l, bttv, zoneminder, and gentoo communities, but I continue
to get no signal on the video feeds.  When I plug the cameras into the
windows based pc, which runs some proprietary software from a defunct
company, the video comes in.

That tells me the cameras are working, but they are a decade old, and
perhaps they are not playing nice with the standards of today.





I load the module like this:

modprobe bttv card=98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98





...and I know that works because when i check my log i see "using:
ProVideo PV150 [card=98,insmod option]":

bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:06:04.0, irq: 16, latency: 64, mmio: 0xfaefe000
bttv0: subsystem: 1830:1540 (UNKNOWN)
bttv0: using: ProVideo PV150 [card=98,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: tuner absent
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok

I have 16 'ports' (two 8-chip cards), so as you would expect i see
sixteen of those and get 16 nodes in /dev/v4l/vbil* with simlinks at
/dev/video*





I tried to build as much of the v4l stuff as nodules, and this is was
lsmod says:

Module                  Size  Used by
bttv                  133620  16
ipv6                  162916  20
nvidia               7352096  24
ir_common              23940  1 bttv
compat_ioctl32          1536  1 bttv
videobuf_dma_sg         6916  1 bttv
videobuf_core           9604  2 bttv,videobuf_dma_sg
btcx_risc               3080  1 bttv
tveeprom               11664  1 bttv
videodev               21632  17 bttv
v4l2_common            11520  2 bttv,videodev
v4l1_compat            11396  2 bttv,videodev
sky2                   29700  0
sg                     18832  0




But as I mentioned before, I seem to be getting no signal on my
/dev/v4l nodes.  If I cat them to a file, and try to play it in VLC, I
get 'nothing to play' on the std_out.

I guess the good news is that using some of the apps that come with
the ZoneMinder project, I can see that there appears to be some
communication between camera and DVR.

zmu -d /dev/video0 -q -v
Video Capabilities
  Name: BT878 video (ProVideo PV150)
  Type: 171
    Can capture
    Can tune
    Overlay onto frame buffer
    Can clip
    Scalable
  Video Channels: 2
  Audio Channels: 0
  Maximum Width: 640
  Maximum Height: 576
  Minimum Width: 48
  Minimum Height: 32
Window Attributes
  X Offset: 0
  Y Offset: 0
  Width: 320
  Height: 240
Picture Attributes
  Palette: 4 - 24bit RGB
  Colour Depth: 24
  Brightness: 32768
  Hue: 32768
  Colour :32768
  Contrast: 32768
  Whiteness: 0
Channel 0 Attributes
  Name: Composite0
  Channel: 0
  Flags: 2
    Channel has audio
  Type: 2 - Camera
  Format: 3 - AUTO
Channel 1 Attributes
  Name: Composite1
  Channel: 1
  Flags: 2
    Channel has audio
  Type: 2 - Camera
  Format: 3 - AUTO




...some of them have different 'Maximum Width' and 'Maximum Height'
values, and when I view them i see that some report to come in at
40fps, where others come in at 20fps.

One thing that is jumping out at me for the first time now is that the
capabilities say 'can tune', but neither channel 0 nor 1 have the flag
"Channel Has Tuner".   In any case if tried checking on all channels
with and without the card=98 directive, and I even tried some other
card types I've heard people have used with bt878 chipset cards.
(Like 133,132,77, and probably some others).  The number of channels
per chip available to me changes, and some of the "channel flags"
change, but the end result is exactly the same.

I contacted the manufacturer on friday, and they haven't responded
yet, but their own documentation says to use card=98, and it doesn't
qualify that with a revision or anything.

I also noticed this error in my logs:

~ $ sudo cat /var/log/messages |grep v4l
May  1 23:18:12 isabel v4l1_compat: exports duplicate symbol
v4l_compat_translate_ioctl (owned by kernel)
May  1 23:18:12 isabel v4l2_common: exports duplicate symbol
v4l2_norm_to_name (owned by kernel)
May  1 23:18:12 isabel compat_ioctl32: exports duplicate symbol
v4l_compat_ioctl32 (owned by kernel)
May  1 23:19:19 isabel v4l1_compat: exports duplicate symbol
v4l_compat_translate_ioctl (owned by kernel)
May  1 23:19:19 isabel v4l2_common: exports duplicate symbol
v4l2_norm_to_name (owned by kernel


Obviously I have both the v4l2_common and v4l1_compat APIs installed
in my kernel, as installing the latter autoselects the former, but I
hard linked them into the kernel image.  nonetheless modprobing bttv
pulls in these two other external modules which seem like they are
already loaded into the kernel.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
