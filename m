Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:48663 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZLCCsS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 21:48:18 -0500
Date: Wed, 2 Dec 2009 18:48:24 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jon Smirl <jonsmirl@gmail.com>
cc: Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
In-Reply-To: <9e4733910912021620s7a2b09a8v88dd45eef38835a@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0912021827120.4729@shell2.speakeasy.net>
References: <4B155288.1060509@redhat.com>  <20091201201158.GA20335@core.coreip.homeip.net>
  <4B15852D.4050505@redhat.com>  <20091202093803.GA8656@core.coreip.homeip.net>
  <4B16614A.3000208@redhat.com>  <20091202171059.GC17839@core.coreip.homeip.net>
  <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
 <4B16BE6A.7000601@redhat.com>  <20091202195634.GB22689@core.coreip.homeip.net>
  <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
 <9e4733910912021620s7a2b09a8v88dd45eef38835a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Dec 2009, Jon Smirl wrote:
> > A bluetooth remote has a specific device ID that the receiver has to pair with. Your usb mouse and keyboard each have specific device IDs. A usb IR *receiver* has a specific device ID, the remotes do not. So there's the major difference from your examples.
>
> Actually remotes do have an ID. They all transmit vendor/device pairs
> which is exactly how USB works.

*All* remotes?  That's a bold statement.  I'm sure there are some that
only transmit 8 bits of so of scancode.  I think remotes are more like
hosts on a network than usb or bluetooth devices.  Remotes do not join or
leave a receiver, while things like usb devices do explictly join and leave
the hub.

> >> Now I understand that if 2 remotes send completely identical signals we
> >> won't be able to separate them, but in cases when we can I think we
> >> should.
> >
> > I don't have a problem with that, if its a truly desired feature.  But
> > for the most part, I don't see the point.  Generally, you go from
> > having multiple remotes, one per device (where "device" is your TV,
> > amplifier, set top box, htpc, etc), to having a single universal remote
> > that controls all of those devices.  But for each device (IR receiver),
> > *one* IR command set.  The desire to use multiple distinct remotes with
> > a single IR receiver doesn't make sense to me.  Perhaps I'm just not
> > creative enough in my use of IR.  :)

Most universal remotes I'm familiar with emulate multiple remotes.  I.e.
my tv remote generates one set of scancodes for the numeric keys.  The DVD
remote generates a different set.  The amplifier remote in "tv mode"
generates the same codes as the tv remote, and in "dvd mode" the same codes
as the dvd remote.  From the perspective of the IR receiver there is no
difference between having both the DVD and TV remotes, or using the
aplifier remote to control both devices.

Now, my aplifier remote has a number of modes.  Some control devices I
have, like "vcr mode", and there is nothing I can do about that.  Some,
like "md mode" don't control devices I have.  That means they are free to
do things on the computer.  Someone else with the same remote (or any
number of remotes that use the same protocol and scancodes) might have
different devices.

So I want my computer to do stuff when I push "JVC MD #xx" keys, but ignore
"JVC VCR #yyy" yets.  Someone with an MD player and not a VCR would want to
opposite.  Rather than force everyone to create custom keymaps, it's much
easier if we can use the standard keymaps from a database of common remotes
and simply tell mythtv to only use remote #xxx or not to use remote #yyy.

It sounds like you're thinking of a receiver that came bundled with a
remote and that's it.  Not someone with a number of remotes that came with
different pieces of AV gear that they want to use with their computer.
