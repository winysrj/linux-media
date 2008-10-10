Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <v4l@therussellhome.us>) id 1KoQwo-0005xY-Dr
	for linux-dvb@linuxtv.org; Sat, 11 Oct 2008 00:59:05 +0200
Date: Fri, 10 Oct 2008 18:58:25 -0400
From: Chris Russell <v4l@therussellhome.us>
To: "Markus Rechberger" <mrechberger@gmail.com>
Message-ID: <20081010185825.37790e23@arwen.therussellhome.us>
In-Reply-To: <d9def9db0810091919x2aa763bey15e39e74508763e9@mail.gmail.com>
References: <20081009221330.3e355773@arwen.therussellhome.us>
	<d9def9db0810091919x2aa763bey15e39e74508763e9@mail.gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] em28xx - analog tv audio on kworld 305U
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

On Fri, 10 Oct 2008 04:19:31 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

> On Fri, Oct 10, 2008 at 4:13 AM, Chris Russell <v4l@therussellhome.us> wrote:
> >        I have a KWorld DVB-T 305U on Gentoo using the v4l-dvb-hg
> > package (live development version of v4l&dvb-driver for Kernel 2.6)
> > that I updated today (03Oct08).
> >
> >        The analog TV looks great but I cannot get the sound to work.
> > I have tried just about everything I could find searching including:
> > $ arecord -D hw:1 -f dat | aplay -f dat
> >        and
> > $ mplayer tv:// -tv driver=v4l2:device=/dev/video0:chanlist=us-cable:alsa:adevice=hw.1,0:amode=1:audiorate=32000:forceaudio:volume=100:immediatemode=0:norm=NTSC
> >        and
> > $ v4lctl volume mute off; v4lctl volume 31
> >        and
> > even attempting a manual cat from /dev/audio1 to /dev/audio
> >
> > So what am I missing or is audio for the 305U not working yet?
> >
> 
> Hi,
> 
> you need the em28xx-new code from mcentral.de in order to get audio
> work with it, audio for it is still in progress but it should work
> fine as long as you have attached one device only.
> 
> Markus

Thanks for the reply.  Unfortunately, I still end up with the same
result.  I un-installed v4l-dvb-hg, added back v4l support in my kernel
(2.6.26) and pulled down the latest em28xx-new driver (based on the
sunshine overlay which pulls from
http://mcentral.de/hg/~mrec/em28xx-new/).  Again, tv works but audio
does not.  Did I miss something?

Soli Deo Gloria,
Chris

-- dmesg output --
usb 2-5: new high speed USB device using ehci_hcd and address 5
usb 2-5: configuration #1 chosen from 1 choice
em28xx v4l2 driver version 0.0.1 loaded
em28xx: new video device (eb1a:e305): interface 0, class 255
em28xx: device is attached to a USB 2.0 bus
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
attach_inform: tvp5150 detected.
tvp5150 1-005c: tvp5150am1 detected.
successfully attached tuner
em28xx #0: V4L2 VBI device registered as /dev/vbi0
em28xx #0: V4L2 device registered as /dev/video0
em28xx #0: Found KWorld DVB-T 305U
usbcore: registered new interface driver em28xx
em2880-dvb.c: DVB Init
em2880-dvb.c: unsupported device
Em28xx: Initialized (Em2880 DVB Extension) extension
tvp5150 1-005c: tvp5150am1 detected.
Em28xx: Removed (Em2880 DVB Extension) extension
usbcore: deregistering interface driver em28xx
em28xx #0: disconnecting em28xx#0 video
em28xx #0: V4L2 VIDEO devices /dev/video0 deregistered
em28xx #0: V4L2 VBI devices /dev/vbi0 deregistered

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
