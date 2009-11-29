Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:54511 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZK2SxA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 13:53:00 -0500
MIME-Version: 1.0
In-Reply-To: <20091129181316.7850f33c@lxorguk.ukuu.org.uk>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org> <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	<1259515703.3284.11.camel@maxim-laptop> <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	<20091129181316.7850f33c@lxorguk.ukuu.org.uk>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sun, 29 Nov 2009 10:52:45 -0800
Message-ID: <2c0942db0911291052n6e9dd116x943ee636bcf548b9@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Andy Walls <awalls@radix.net>, Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 10:13 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> If decoding can *only* be sanely handled in user-space, that's one
>> thing. If it can be handled in kernel, then that would be better.
>
> Why ?
>
> I can compute fast fourier transforms in the kernel but that doesn't make
> it better than doing it in user space.

Of course not.

> I can write web servers in the kernel and the same applies.

I'm not so young as to not recall Tux. That was again a bad idea, for
the same reason. It introduced unnecessary complexity. Enabling
userspace to be able to service web requests faster improved all
user-space code. Yay.

The question is which solution is more complex, the current one that
requires userspace to be an active participant in the decoding, so
that we can handle bare diodes hooked up to a sound-card, or having
the kernel do decode for the sane devices and providing some fall-back
for broken hardware. The former has the advantage of being flexible at
the cost of increased fragility and surface area for security, and
latency in responding to events, the latter has the problem of
requiring two different decoding paths to be maintained, at least if
you want to support odd-ball hardware.

Jon is asking for an architecture discussion, y'know, with use cases.
Maxim seems to be saying it's obvious that what we have today works
fine. Except it doesn't appear that we have a consensus that
everything is fine, nor an obvious winner for how to reduce the
complexity here and keep the kernel in a happy, maintainable state for
the long haul.

Who knows, perhaps I misunderstood the dozens of messages up-thread --
wouldn't be the first time, in which case I'll shut up and let you get
back to work.
