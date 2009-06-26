Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:53370 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZFZTB0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 15:01:26 -0400
Subject: Re: Bah! How do I change channels?
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <829197380906261147g311d9a0ap7c9d5efc1473bf85@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
	 <1246041288.3159.51.camel@palomino.walls.org>
	 <829197380906261147g311d9a0ap7c9d5efc1473bf85@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 15:02:59 -0400
Message-Id: <1246042980.3159.68.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-06-26 at 14:47 -0400, Devin Heitmueller wrote:
> On Fri, Jun 26, 2009 at 2:34 PM, Andy Walls<awalls@radix.net> wrote:
> > Hmm, that sure sounds like a V4L2 spec violation.  From the V4L2 close()
> > description:
> >
> > "Closes the device. Any I/O in progress is terminated and resources
> > associated with the file descriptor are freed. However data format
> > parameters, current input or output, control values or other properties
> > remain unchanged."
> >
> >
> > Regards,
> > Andy
> 
> I have no idea how that would work with power management.  It would
> mean that all the tuners and demod drivers which don't maintain state
> across powerdown would have to maintain some sort of cache of all of
> the programmed registers, and we would need to add some sort of
> "wakeup" callback which reprograms the device accordingly (currently
> we have a sleep callback but not a corresponding callback to wake the
> device back up).

That sounds about right.


> As a requirement, it might have been suitable for PCI cards where you
> don't care about power management (and therefore never power anything
> down), but I don't know how practical that is for USB or minicard
> devices where power management is critical because you're on a
> battery.

All I'm saying is that it is obviously the expected behavior, it the
specified behavior, and all the userland apps and scripts are written
with that behavior in mind.

The applications' expectation of that behavior is, of course, why we are
having this discussion.

Assuming arguendo, maintaing state in the face of power management is a
hard requirement on the driver; I'll still contend it's harder to change
the existing base of applications and user scripts.  Until the spec and
all the existing apps change, not adhering to the spec leads to user
confusion.

My $0.02

Regards,
Andy

> Devin


