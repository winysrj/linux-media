Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36387 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZEAC1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 22:27:19 -0400
Subject: Re: [ivtv-users] Delay loading v4l-cx25840.fw
From: Andy Walls <awalls@radix.net>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
In-Reply-To: <1241054296.3374.44.camel@palomino.walls.org>
References: <1241054296.3374.44.camel@palomino.walls.org>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 22:21:36 -0400
Message-Id: <1241144496.22968.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-04-29 at 21:18 -0400, Andy Walls wrote:
> On Wed, 2009-04-29 at 13:33 +0200, Hans Verkuil wrote:
> > > On Wed, 2009-04-29 at 21:50 +1200, Michael Cree wrote:
> > >> On 29/04/2009, at 6:19 PM, Hans Verkuil wrote:
> 
> > >> > What does surprise me here is that the fw is loaded right after the
> > >> > driver
> > >> > was loaded, which does suggest that some process is opening one of the
> > >> > device nodes since the fw load is only done on the first open.
> > >>
> 
> > > On my systems (Fedora 9 & 10) IIRC it happens early too.  I've always
> > > assumed it was either udev or hal or some some other automatic process
> > > that mucks with device nodes.
> 
> > It would be nice if you could track down who is messing around with those
> > device nodes.
> 
> I'll work on it.  It looks like something that is aware of v4l device
> nodes (see below) - I'm wagering hald.

I've found it.  It's hald-probe-video4linux:

[11539.917539] cx18-0:  info: cx18_v4l2_open: called for stream encoder MPEG by pid 22870 (hald-probe-vide) ppid 1981 (hald-runner)
[11540.333557] cx18-0:  info: cx18_v4l2_open: called for stream encoder PCM audio by pid 22907 (hald-probe-vide) ppid 1981 (hald-runner)
[11540.337019] cx18-0:  info: cx18_v4l2_open: called for stream encoder VBI by pid 22923 (hald-probe-vide) ppid 1981 (hald-runner)
[11540.386051] cx18-0:  info: cx18_v4l2_open: called for stream encoder YUV by pid 22929 (hald-probe-vide) ppid 1981 (hald-runner)
[11540.401658] cx18-0:  info: cx18_v4l2_open: called for stream encoder radio by pid 22930 (hald-probe-vide) ppid 1981 (hald-runner)

# locate hald-probe-vide
/usr/libexec/hald-probe-video4linux


It's not restricted to boot.  It happens on modprobe, probably cued by
udev or some other hotplug mechanism.


> >  If you modprobe ivtv with file and ioctl debugging on, does
> > that give an indication of what is done with the device nodes?
> 
> For the cx18 driver on a Fedora 10 system something runs through
> the /dev/video* nodes and /dev/radio* doing VIDIOC_QUERYCAP.  I suspect
> the behavior will be the same for ivtv.  I'll test on my other system
> when I get a chance.


 
> > Depending on what process is doing what with the device nodes I may be
> > able to optimize the driver for that. It's really annoying to have this fw
> > loaded at boot time, esp. if you have one or more PVR-500 cards.

Well thinking about this, this is a system level issue:

1. People want to avoid unnecessary waits at boot (or module insertion
time)

2. Hardware detection mechanisms want to query what new hardware is as
soon as it appears.

3. Hardware queries from userspace should (or need to) avoid IO bound
operations that consume CPU.

4. Kernel drivers should be able to satsify hardware queries without
starting up an IO bound operation that consumes CPU.

Hans, it sounds like your media_controller device node idea is really
what we need to get implemented here for user space to do queires on
hardware.  This problem obviously affects more than the ivtv driver so
I'd recommend against an ivtv band-aid.

We'd also want to coordinate with the hald folks and other user space
app/plumbing developers, as this likely affects a few v4l2 drivers.  It
sounds like an LPC agenda item to me...

Regards,
Andy



