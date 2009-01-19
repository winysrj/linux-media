Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54992 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZASEVp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 23:21:45 -0500
Subject: Re: Regression since 2.6.25 kernel: Crash of userspace program
 leaves DVB device unusable
From: Andy Walls <awalls@radix.net>
To: Brendon Higgins <blhiggins@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200901191337.31272.blhiggins@gmail.com>
References: <200901031200.56314.blhiggins@gmail.com>
	 <200901191337.31272.blhiggins@gmail.com>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 23:21:38 -0500
Message-Id: <1232338898.3242.27.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-01-19 at 13:37 +1000, Brendon Higgins wrote:
> Hi,
> 
> I wrote to linux-dvb (2009-01-03 12:00 pm):
> > I've been coming up against a problem that seems to be with the DVB drivers
> > that occurs when a program using them, usually VDR in my case, terminates
> > uncleanly (segfault, general protection fault). Linux 2.6.25 doesn't have
> > this problem, but 2.6.26, 2.6.27, and 2.6.28 do, though 2.6.28 manifests
> > slightly differently to the others. I'll focus on what 2.6.28 does. I have
> > a DViCO FusionHDTV DVB-T Plus, running on an amd64 Debian Testing (mostly)
> > dual-core machine.
> >
> > After VDR crashes it attemps to restart itself. This was fine on 2.6.25,
> > but on later kernels the crash seems to leave the device in some unusable
> > state, where no program can subsequently use it - the device files
> > (/dev/dvb) no longer exist. (In 2.6.2[67], the files existed, but accessing
> > /dev/dvb/adapter0/dvr0 resulted in "No such device".) I had figured out
> > that in order to get the device working again it is necessary to "rmmod
> > cx88_dvb cx8802; modprobe cx88_dvb". This worked in 2.6.2[67] without
> > trouble, but in 2.6.28, it's as if the cx88_dvb module gets lost somehow.
> > It doesn't appear in lsmod, however:
> > phi:~# modprobe cx88_dvb
> > FATAL: Error inserting cx88_dvb
> > (/lib/modules/2.6.28/kernel/drivers/media/video/cx88/cx88-dvb.ko): No such
> > device
> > phi:~# rmmod cx88_dvb cx8802
> > ERROR: Module cx88_dvb does not exist in /proc/modules
> > phi:~# modprobe cx88_dvb
> >
> > Note that probing it works only *after* cx8802 was unloaded. As before, now
> > the device is accessible.
> >
> > So it seems something is wrong in the cx8802 module. Something is not being
> > cleaned up after a userspace program crashes while using it, leaving the
> > DVB system in a broken state.
> >
> > I'd very much like this to not be the case, since on my system a VDR crash
> > is somewhat inevitable, and the automatic restart *was* very handy, back in
> > 2.6.25.
> 
> Deafening silence. Does nobody have a clue?

Well, you have the clues actually; they're in your log files.

At the time of the crash, what shows up in dmesg, /var/log/messages, and
any log that VDR creates?  

Since modprobe after the crash failed with -ENODEV ["...cx88-dvb.ko): No
such device], a quick grep through cx88-dvb.c in the source shows that
that can only happen in a few places.  It should be easy to spot in the
logs.  Adding an

	options cx88_dvb debug=1

line to /etc/modprobe.conf would make things easier to see in the logs
as well.

Also what is the source of your cx88 driver: Debian Testing or the
v4l-dvb repo?


> Or care?

The issue is usually not one of caring, but one of having
time, the specific hardware, and ability to reporduce the problem.

Regards,
Andy


>  I just noticed I posted 
> to the linux-dvb list which has been deprecated, so I'm quoting it here in 
> its entirety in case relevent people missed it. Is there anything else I can 
> do?
> 
> Peace,
> Brendon

