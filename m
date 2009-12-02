Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43991 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZLBUxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 15:53:22 -0500
Date: Wed, 2 Dec 2009 12:53:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, Jarod Wilson <jarod@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
Message-ID: <20091202205323.GF22689@core.coreip.homeip.net>
References: <4B15852D.4050505@redhat.com> <20091202093803.GA8656@core.coreip.homeip.net> <4B16614A.3000208@redhat.com> <20091202171059.GC17839@core.coreip.homeip.net> <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com> <4B16BE6A.7000601@redhat.com> <20091202195634.GB22689@core.coreip.homeip.net> <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com> <20091202201404.GD22689@core.coreip.homeip.net> <4B16CCD7.20601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B16CCD7.20601@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 02, 2009 at 06:23:51PM -0200, Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
> > On Wed, Dec 02, 2009 at 03:04:30PM -0500, Jarod Wilson wrote:
> >> On Dec 2, 2009, at 2:56 PM, Dmitry Torokhov wrote:
> >>> Now I understand that if 2 remotes send completely identical signals we
> >>> won't be able to separete them, but in cases when we can I think we
> >>> should.
> >> I don't have a problem with that, if its a truly desired feature. But
> >> for the most part, I don't see the point. Generally, you go from
> >> having multiple remotes, one per device (where "device" is your TV,
> >> amplifier, set top box, htpc, etc), to having a single universal
> >> remote that controls all of those devices. But for each device (IR
> >> receiver), *one* IR command set. The desire to use multiple distinct
> >> remotes with a single IR receiver doesn't make sense to me. Perhaps
> >> I'm just not creative enough in my use of IR. :)
> > 
> > Didn't Jon posted his example whith programmable remote pretending to be
> > several separate remotes (depending on the mode of operation) so that
> > several devices/applications can be controlled without interfering with
> > each other?
> > 
> From what I understood, he is using the same physical remote, but creating different
> IR groups of keys on it, each group meant to be used by a different application.
> 
> For such usage, some software will need to filter the scancode group and send
> them only for a certain application. This can be done easily by using lirc,
> purely in userspace.
> 
> Another alternative (that will also work for multimedia keys on a keyboard) is
> to add a filtering subsystem at evdev that will send certain events for just certain
> PID's.

They are the same key events (Lets's say KEY_PLAY) but one is supposed
to affect CD player while another DVD player application. Evdev will not
be able to distinguish them but if we had 2 separate devices then
applications could read from the one thet user assigned to them.

However even subscription is something that is desirable to have ouside
of IRC handling topic (so that supporting applications need not be woken
up by events they are not interested in - example mixer application is
interested in KEY_VOLUMEUP, KEY_VOLUMEDOWN and KEY_MUTE but not any
other key that may be emitted by a keyboard).

-- 
Dmitry
