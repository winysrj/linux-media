Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44829 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZK2XhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 18:37:19 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
In-Reply-To: <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259469121.3125.28.camel@palomino.walls.org>
	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	 <1259515703.3284.11.camel@maxim-laptop>
	 <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 29 Nov 2009 18:35:32 -0500
Message-Id: <1259537732.5231.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-29 at 09:49 -0800, Ray Lee wrote:
> On Sun, Nov 29, 2009 at 9:28 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > This has zero advantages besides good developer feeling that "My system
> > has one less daemon..."
> 
> Surely it's clear that having an unnecessary daemon is introducing
> another point of failure?

A failure in a userspace IR daemon is worst case loss of IR
functionality.

A failure in kernel space can oops or panic the machine.

> Reducing complexity is not just its own
> reward in a 'Developer Feel Good' way.

No complexity is being reduced here.  It's being shoved from one side of
a fence to another.  A bad part about the proposed move is that in user
space, user address space is fairly isolated from other applications and
separate from kernel space.  Partitioning reduces complexity and the
impact of failures.  Moving things into kernel space just adds more to
the pile of code; it should have a good reason for being there.


> If decoding can *only* be sanely handled in user-space, that's one
> thing. If it can be handled in kernel, then that would be better.

Why does the address space in which decoding is performed make the
decoding process better or worse?  The in kernel infrastructre and
restrictions add constraints to a decoding implementation.  Userspace is
much more flexible.

Regards,
Andy

