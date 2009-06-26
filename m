Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56791 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZFZUdU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 16:33:20 -0400
Subject: Re: Bah! How do I change channels?
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <829197380906261229g6e9f38q4be149597930ef0@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
	 <1246041288.3159.51.camel@palomino.walls.org>
	 <829197380906261147g311d9a0ap7c9d5efc1473bf85@mail.gmail.com>
	 <1246042980.3159.68.camel@palomino.walls.org>
	 <829197380906261229g6e9f38q4be149597930ef0@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 16:34:50 -0400
Message-Id: <1246048490.12406.56.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-06-26 at 15:29 -0400, Devin Heitmueller wrote: 
> On Fri, Jun 26, 2009 at 3:02 PM, Andy Walls<awalls@radix.net> wrote:
> > All I'm saying is that it is obviously the expected behavior, it the
> > specified behavior, and all the userland apps and scripts are written
> > with that behavior in mind.
> >
> > The applications' expectation of that behavior is, of course, why we are
> > having this discussion.
> >
> > Assuming arguendo, maintaing state in the face of power management is a
> > hard requirement on the driver; I'll still contend it's harder to change
> > the existing base of applications and user scripts.  Until the spec and
> > all the existing apps change, not adhering to the spec leads to user
> > confusion.
> 
> I guess that means that every product that has a tuner which
> implements the sleep callback is broken.  And yet this is the first
> case I've heard a user complain, which makes me wonder how big a
> population is out there that is using scripts to control the tuner.  I
> suspect most people are just using applications like MythTV, xawtv or
> tvtime, which won't have these issues.


> I don't intend to come across as argumentative, but if we haven't
> heard a massive outcry about this by now, maybe nobody actually cares
> and thus we shouldn't spend the time to build a whole infrastructure
> to preserve the driver state across the low power mode.

Devin,

I'm not saying we need to fix every broken tuner driver.  I would
suggest, however, that if you fix the one at hand, you will provide a
template which others could follow as the problem crops up with other
devices.


>   Those people
> who really do care can just disable the power management with a
> modprobe option.

I doubt you'll here a massive outcry, as most users use a large
monlithic application (e.g. MyhtTV) that keep at least two device nodes
open, so even if they momentarily close one, it doesn't matter.

Where it hurts not to preserve state is for:

1. development and troubleshooting - small tools that do one thing and
can do them in whatever order you want simply are really nice to have
work.

In this thread I've seen a user trying to troubleshoot being affected by
not preserving state.



2. user work arounds or conveniences - a small tool used in a script to
twiddle a device setting.

Preserving state is often *not* used for saving the last tuned
frequency, but for other things like the last used input, volume level,
VBI settings, etc.




As I wave the V4L2 spec around like a blind follower of some sacred law,
I'm begin to feel like Piggy clinging to the conch shell in
_The_Lord_of_the_Flies_ , so....

If you think the V4L2 spec is bad, then propose a modification in
writing (an RFC) that you think makes sense.  Propose exceptions for
tuners and/or power management.

I'm not trying to be argumentative either.  I guess I'm just not a big
fan of "kicking the can down the road".  We all bear the burden of the
spec non-compliance in the power managment design and/or implementation,
in the form of additional user support and less flexible troubleshooting
steps, until it is resolved.  

I do, however, appreciate that there is only so much time to do useful
work and that one has to prioritize.  And I do also appreciate the large
amount of enegry you put into v4l-dvb.

Regards,
Andy

> Devin


