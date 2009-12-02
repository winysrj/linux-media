Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:51367 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZLBVMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 16:12:13 -0500
Date: Wed, 2 Dec 2009 13:12:18 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jarod Wilson <jarod@wilsonet.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
In-Reply-To: <B8514BFF-DB1B-4475-9E6D-E2A567A998FA@wilsonet.com>
Message-ID: <Pine.LNX.4.58.0912021300270.4729@shell2.speakeasy.net>
References: <4B15852D.4050505@redhat.com> <20091202093803.GA8656@core.coreip.homeip.net>
 <4B16614A.3000208@redhat.com> <20091202171059.GC17839@core.coreip.homeip.net>
 <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
 <4B16BE6A.7000601@redhat.com> <20091202195634.GB22689@core.coreip.homeip.net>
 <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
 <20091202201404.GD22689@core.coreip.homeip.net> <434927DD-0E66-4D0E-B705-022B7FCCCDB0@wilsonet.com>
 <20091202204811.GE22689@core.coreip.homeip.net> <B8514BFF-DB1B-4475-9E6D-E2A567A998FA@wilsonet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Dec 2009, Jarod Wilson wrote:
> >>
> >> My main point is that each of these devices has device ID that can be determined without having to first do some protocol analysis and table lookups to figure out which "device" some random IR input is actually coming from.
> >>
> >
> > Heh, right back at ya ;) The fact that you need to do some more work
> > to separate 2 physical devices does not mean it should not be done.
>
> No, but it means added complexity inside the kernel. I'm questioning whether the added complexity is worth it, when I doubt the vast majority of users would take advantage of it, and it can already be done in userspace. Although... Damn. The userspace approach would only work if the device were passing raw IR to userspace, so in the in-kernel decoding case, yeah, I guess you'd need separate input devices for each remote to use them independently. Meh. Doubt I'd ever use it, but I guess I'll concede that it makes some sense to do the extra work.

You just need to send a tuple that contrains the keycode plus some kind of
id for the remote it came from.  That's what I did for lirc, it decodes the
sparc/mark into a remote id and key code tuple.  It's certainly a common
thing to want.  Anyone who has existing remotes and components that use
them would want it.  You don't want your computer turning off when you push
the power button on the DVD player's remote, do you?

Each host connected to a network interface doesn't get its own device.
