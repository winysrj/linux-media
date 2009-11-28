Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59994 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbZK1X2h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 18:28:37 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
In-Reply-To: <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 28 Nov 2009 18:26:55 -0500
Message-Id: <1259450815.3137.19.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon,

On Sat, 2009-11-28 at 12:37 -0500, Jon Smirl wrote:
> On Sat, Nov 28, 2009 at 12:35 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > Jon Smirl <jonsmirl@gmail.com> writes:
> >
> >> There are two very basic things that we need to reach consensus on first.
> >>
> >> 1) Unification with mouse/keyboard in evdev - put IR on equal footing.

The only thing this buys for the user is remote/products bundles that
work out of the box.  That can only be a solution for the 80% case.

I don't hear users crying out "Please integrate IR with the input
system".  I do hear users say "I want my remote to work", and "How can I
make my remote work?".  Users are not specifically asking for this
integration of IR and the input system - a technical nuance.  If such a
tecnical desire-ment drives excessive rework, I doubt anyone will care
enough about IR to follow through to make a complete system.

What does "equal footing" mean as an incentive anyway?  The opportunity
to reimplement *everything* that exists for IR already over again in
kernel-space for the sake of developer technical desires?  That's just a
lot of work for "not invented here" syndrome.  IR transceivers are
arguably superior to keyboards and mice anyway because they can transmit
data too.


> >> 2) Specific tools (xmodmap, setkeycodes, etc or the LIRC ones) or
> >> generic tools (ls, mkdir, echo) for configuration
> >
> > I think we can do this gradually:
> > 1. Merging the lirc drivers. The only stable thing needed is lirc
> >   interface.
> 
> Doing that locks in a user space API that needs to be supported
> forever. We need to think this API through before locking it in.

No one get things right the first time - No one.

Most designs are iterated with prototypes in the commercial world.
Prototypes keep costs low so you can throw it away easily and try a new
approach, if the current approach is not panning out

Only governements try to get everything right on the first go.  It takes
them too long and the end product is usually still hosed.

Whatever gets developed won't be locked in for 20 years, that's absurd.
Technology moves on 6 month to two year cycles.  Linux changes ABIs too.
V4L transitioned from V4L1 to V4L2 and that's happened in less than 20
years for a much more complex set of devices with a more varied set of
userspace apps.

Regards,
Andy

> > 2. Changing IR input layer interface ("media" drivers and adding to lirc
> >   drivers).
> > --
> > Krzysztof Halasa


