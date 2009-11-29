Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:51579 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZK2HOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 02:14:52 -0500
Date: Sat, 28 Nov 2009 23:14:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Lampard <mike@mtgambier.net>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, j@jannau.net,
	jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR system?
Message-ID: <20091129071454.GV6936@core.coreip.homeip.net>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com> <200911291317.03612.mike@mtgambier.net> <20091129045549.GQ6936@core.coreip.homeip.net> <200911291601.53368.mike@mtgambier.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911291601.53368.mike@mtgambier.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 04:01:53PM +1030, Mike Lampard wrote:
> On Sun, 29 Nov 2009 03:25:49 pm Dmitry Torokhov wrote:
> > On Sun, Nov 29, 2009 at 01:17:03PM +1030, Mike Lampard wrote:
> > > On Sat, 28 Nov 2009 02:27:59 am Jon Smirl wrote:
> > > > On Fri, Nov 27, 2009 at 2:45 AM, Christoph Bartelmus
> > > >
> > > > <christoph@bartelmus.de> wrote:
> > > > > Hi Mauro,
> > > > >
> > > > > on 26 Nov 09 at 14:25, Mauro Carvalho Chehab wrote:
> > > > >> Christoph Bartelmus wrote:
> > > > >
> > > > > [...]
> > > > >
> > > > >>> But I'm still a bit hesitant about the in-kernel decoding. Maybe
> > > > >>> it's just because I'm not familiar at all with input layer toolset.
> > > > >
> > > > > [...]
> > > > >
> > > > >> I hope it helps for you to better understand how this works.
> > > > >
> > > > > So the plan is to have two ways of using IR in the future which are
> > > > > incompatible to each other, the feature-set of one being a subset of
> > > > > the other?
> > > >
> > > > Take advantage of the fact that we don't have a twenty year old legacy
> > > > API already in the kernel. Design an IR API that uses current kernel
> > > > systems. Christoph, ignore the code I wrote and make a design proposal
> > > > that addresses these goals...
> > > >
> > > > 1) Unified input in Linux using evdev. IR is on equal footing with
> > > > mouse and keyboard.
> > >
> > > I think this a case where automating setup can be over-emphasised (in the
> > > remote-as-keyboard case).
> > >
> > > Apologies in advance if I've misunderstood the idea of utilising the
> > > 'input subsystem' for IR.  If the plan is to offer dedicated IR events
> > > via a yet-to- be-announced input event subsystem and to optionally
> > > disallow acting as a keyboard via a module option or similar then please
> > > ignore the following.
> > >
> > > Whilst having remotes come through the input subsystem might be 'the
> > > correct thing' from a purely technical standpoint, as an end-user I find
> > > the use-case for remotes completely different in one key aspect: 
> > > Keyboards and mice are generally foreground-app input devices, whereas
> > > remotes are often controlling daemons sitting in the background piping
> > > media through dedicated devices.  As an example I have a VDR instance
> > > running in the background on my desktop machine outputting to a TV in
> > > another room via a pci mpeg decoder - I certainly don't want the VDR
> > > remote control interacting with my X11 desktop in any way unless I go out
> > > of my way to set it up to do so, nor do I want it interacting with other
> > > applications (such as MPD piping music around the house) that are
> > > controlled via other remotes in other rooms unless specified.
> > >
> > > Setting this up with Lircd was easy, how would a kernel-based proposal
> > > handle this?
> > 
> > Why would that be different really? On my keyboard there is a key for
> > e-mail application (and many others) - what HID calls Application Launch
> > keys IIRC. There also application control keys and system control keys,
> > KEY_COFFEE aka KEY_SCREENLOCK. Those are not to be consumed by
> > foreground application but by daemons/session-wide application.
> > 
> In my real-world examples above, both VDR and MPD are started at system start 
> and are not associated with any user-initiated sessions (X login etc) - they 
> are not X11 clients.  Their only input is via Lircd.  Conversely todays 
> Xserver (if I read my logfiles correctly) consumes all input event devices by 
> default, turning them into keypresses for its client apps.  This is exactly 
> the wrong behaviour for my use-case.  In order to ensure that my daemons 
> receive their input I must first ensure that X doesn't receive those events - 
> assuming this is possible it still complicates matters further than they are 
> today (I'd need a simple way of automatically differentiating between remote 
> devices and keyboard devices) .

But the setup you described only works for you because lirc is the only
consumer using the device _for now_. As soon as there are more users you
will have to solve the same isssue as with evdev being consumed but
different applications. As soon as somebody says "gosh, I really don't
want my KDE application to depend on lircm why does not X provide RC
data the same way it provides key presses?" your setup goes south.

As to how to solve such specific needs - there could be different
solutions. EVIOCGRAB can be used to gain exclusive access (but that
again breaks when there appears another application wanting exclusive
access). Applications can limit themselves to opening only specific
event devices (and igonre others).

-- 
Dmitry
