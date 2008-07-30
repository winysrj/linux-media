Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UMqLxT029258
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 18:52:21 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6UMpYqL004378
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 18:51:34 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Ian.Davidson@bigfoot.com
In-Reply-To: <4890BBE8.8000901@blueyonder.co.uk>
References: <488C9266.7010108@blueyonder.co.uk>
	<1217364178.2699.17.camel@pc10.localdom.local>
	<4890BBE8.8000901@blueyonder.co.uk>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 00:44:55 +0200
Message-Id: <1217457895.4433.52.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: xawtv - no picture
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

Hi,

Am Mittwoch, den 30.07.2008, 20:07 +0100 schrieb Ian Davidson:
> The card has 4 sockets on the back
> - FM Antenna
> - UHF/VHF antenna
> - S-Video
> - Remote sensor.
> 
> This time, I tried plugging the camera into the S-Video (rather than
> the FM antenna - oops!) but it didn't help - still a black screen.
> 
> I ran xawtv with the -v 1 option and got this
> 
> [Ian@localhost ~]$ xawtv -remote -nodga -c /dev/video on card=114 -v 1
> This is xawtv-3.95, running on Linux/i686 (2.6.25.11-97.fc9.i686)
> visual: id=0x21 class=4 (TrueColor), depth=24
> visual: id=0x22 class=5 (DirectColor), depth=24
> visual: id=0x5b class=4 (TrueColor), depth=32
> x11: color depth: 24 bits, 3 bytes - pixmap: 4 bytes
> x11: color masks: red=0x00ff0000 green=0x0000ff00 blue=0x000000ff
> x11: server byte order: little endian
> x11: client byte order: little endian
> main: dga extention...
> main: xinerama extention...
> xinerama 0: 1440x900+0+0
> main: xvideo extention [video]...
> main: xvideo extention [image]...
> main: init main window...
> main: install signal handlers...
> main thread [pid=2619]
> main: open grabber device...
> x11: remote display (overlay disabled)
> vid-open: trying: v4l2-old... 
> vid-open: failed: v4l2-old
> vid-open: trying: v4l2... 
> v4l2: open
> v4l2: device info:
>   saa7134 0.2.14 / UNKNOWN/GENERIC @ PCI:0000:04:02.0
> vid-open: ok: v4l2
> main: checking wm...
> wmhooks: netwm state above
> wmhooks: netwm state fullscreen
> main: creating windows ...
> main: init frequency tables ...
> freq: reading /usr/share/xawtv/Index.map
> main: read config file ...
> xt: checking for randr extention ...
> xrandr: 1440x900 1400x1050 1280x1024 1280x960 1152x864 1024x768
> 832x624 800x600 640x480 720x400
> xt: checking for vidmode extention ...
> xt: checking for lirc ...
> lirc: not enabled at compile time
> xt: checking for joystick ...
> xt: checking for midi ...
> xt: adding kbd hooks ...
> main: mapping main window ...
> main: initialize hardware ...
> main: parse channels from config file ...
> xt: handle_pending:  start ...
> gd: init
> blit: init
> blit: gl: init
> blit: gl: DRI=Yes
> blit: gl: texture max size: 2048
> blit: resize 384x288
> gd: config 384x288 win=3c00060
> blit: gl: extention GL_EXT_bgra is available
> blit: gl: extention GL_EXT_bgra is available
> v4l2: new capture params (384x288, BGR3, 331776 byte)
> setformat: 24 bit TrueColor (LE: bgr) (384x288): ok
> grabdisplay: using "24 bit TrueColor (LE: bgr)"
> xt: handle_pending:  ... done
> cmd: "setfreqtab" "europe-west"
> freq: newtab 5
> freq: reading /usr/share/xawtv/europe-west.list
> freq: reading /usr/share/xawtv/ccir-i-iii.list
> freq: reading /usr/share/xawtv/ccir-sl-sh.list
> freq: reading /usr/share/xawtv/ccir-h.list
> freq: reading /usr/share/xawtv/uhf.list
> cmd: "capture" "overlay"
> gd: start [7]
> v4l2: new capture params (384x288, BGR3, 331776 byte)
> setformat: 24 bit TrueColor (LE: bgr) (384x288): ok
> ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success
> v4l2: buf 0: video-cap 0x0+331776, used 0
> v4l2: buf 1: video-cap 0x51000+331776, used 0
> main: setting defaults
> xt: enter main event loop... 
> v4l2: start ts=1217446410590289000
> blit: gl: extention GL_EXT_bgra is available
> blit: gl: frame=384x288, texture=512x512
> blit: 384x288/[24 bit TrueColor (LE: bgr)] => OpenGL
> expose count=4
> expose count=3
> expose count=2
> expose count=1
> expose count=0
> keypad: timeout
> cmd: "capture" "off"
> gd: stop
> v4l2: buf 0: video-cap 0x0+331776, used 331776
> v4l2: buf 1: video-cap 0x51000+331776, used 331776
> v4l2: new capture params (384x288, BGR4, 442368 byte)
> setformat: 32 bit TrueColor (LE: bgr-) (384x288): ok
> v4l2: new capture params (384x288, BGR4, 442368 byte)
> v4l2: close
> [Ian@localhost ~]$ 
> 
> -
> I have been writing programs for almost 44 years - but I blunder round
> linux like a newbie.  I appreciate all the help you can give me.
> Please let me know what else I can do to get this working.
> 
> Ian


for sure I know you are not around the first time.

Despite of the camera, please try card=114 and provide all dmesg stuff
you can gather for it and the tuner.

Kworld has nothing in the eeprom one could eventually start guessing on,
but I know for sure they are not mad and keep a line and you likely find
someone even responding on linux.

Likely we don't need to moleste anyone, if we have the logs.

Cheers,
Hermann


> hermann pitton wrote: 
> > Hi Ian,
> > 
> > Am Sonntag, den 27.07.2008, 16:21 +0100 schrieb Ian Davidson:
> >   
> > > I am trying to run xawtv (or actually streamer) to capture video - but 
> > > at the moment, it is not working.
> > > 
> > > For details of my system, please see 
> > > http://www.smolts.org/client/show_all/pub_86fd06ee-583b-40d2-b23b-92749309023b
> > > 
> > > I have a K-World DVB-T 210SE card which I hope will allow me to capture 
> > > the video (although that is not very evident in the above link)
> > > 
> > > Here is a section of the dmesg output
> > > Linux video capture interface: v2.00
> > > saa7130/34: v4l2 driver version 0.2.14 loaded
> > > ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 18 (level, low) -> IRQ 18
> > > saa7133[0]: found at 0000:04:02.0, rev: 209, irq: 18, latency: 64, mmio: 
> > > 0xfebff800
> > > saa7133[0]: subsystem: 17de:7253, board: UNKNOWN/GENERIC 
> > >     
> > 
> > that board seems to be not reported yet.
> > 
> >   
> > > [card=0,autodetected]
> > >     
> > 
> > That card=0 has only input on videomux 0 enabled.
> > This is on most boards composite over the s-video connector.
> > 
> > On KWORLD_DVBT_210 card=114, which is likely close to it or even fully
> > compatible, the composite over s-video connector is not enabled yet.
> > 
> > Only composite on vmux = 3 and s-video on vmux = 8. Depending on how
> > composite is connected through the breakout cable, we might need a
> > section with composite2 vmux = 0 in saa7134-cards.c.
> > 
> >   
> > > saa7133[0]: board init: gpio is 100
> > > parport_pc 00:07: reported by Plug and Play ACPI
> > > parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> > > saa7133[0]: i2c eeprom 00: de 17 53 72 ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7133[0]: registered device video0 [v4l2]
> > > saa7133[0]: registered device vbi0
> > > ppdev: user-space parallel port driver
> > > 
> > > When I try to run xawtv, this is what I get
> > > [Ian@localhost ~]$ xawtv
> > > This is xawtv-3.95, running on Linux/i686 (2.6.25.10-86.fc9.i686)
> > > xinerama 0: 1440x900+0+0
> > > WARNING: No DGA support available for this display.
> > >     
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> >   
> > > WARNING: couldn't find framebuffer base address, try manual
> > >          configuration ("v4l-conf -a <addr>")
> > > ioctl: 
> > > VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: 
> > > VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> > > ioctl: 
> > > VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: 
> > > VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> > > ioctl: 
> > > VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: 
> > > VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> > > ioctl: 
> > > VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: 
> > > VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> > > ioctl: 
> > > VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: 
> > > VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> > > ioctl: 
> > > VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: 
> > > VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> > > ioctl: 
> > > VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: 
> > > VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> > > Invalid argument
> > > ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> > > [Ian@localhost ~]$
> > > 
> > > Also, the screen is black, although the camera was turned on.
> > > 
> > > I feel that it is trying to tell me something - but I do not understand 
> > > what it is saying.  Is there any hope?
> > > 
> > > Ian
> > > 
> > >     
> > 
> > On most binary video-card drivers you can't set overlay preview mode
> > anymore.
> > 
> > You might try to force xawtv -remote -nodga -c /dev/video0 on card=114
> > to have it in mmap/grabdisplay mode.
> > 
> > Please test whatever you can that we might add the card to auto
> > detection.
> > 
> > Cheers,
> > Hermann
> > 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
