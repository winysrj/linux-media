Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f204.google.com ([209.85.210.204]:50773 "EHLO
	mail-yx0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZFZT3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 15:29:19 -0400
Received: by yxe42 with SMTP id 42so71787yxe.33
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 12:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246042980.3159.68.camel@palomino.walls.org>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
	 <1246041288.3159.51.camel@palomino.walls.org>
	 <829197380906261147g311d9a0ap7c9d5efc1473bf85@mail.gmail.com>
	 <1246042980.3159.68.camel@palomino.walls.org>
Date: Fri, 26 Jun 2009 15:29:21 -0400
Message-ID: <829197380906261229g6e9f38q4be149597930ef0@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 3:02 PM, Andy Walls<awalls@radix.net> wrote:
> All I'm saying is that it is obviously the expected behavior, it the
> specified behavior, and all the userland apps and scripts are written
> with that behavior in mind.
>
> The applications' expectation of that behavior is, of course, why we are
> having this discussion.
>
> Assuming arguendo, maintaing state in the face of power management is a
> hard requirement on the driver; I'll still contend it's harder to change
> the existing base of applications and user scripts.  Until the spec and
> all the existing apps change, not adhering to the spec leads to user
> confusion.

I guess that means that every product that has a tuner which
implements the sleep callback is broken.  And yet this is the first
case I've heard a user complain, which makes me wonder how big a
population is out there that is using scripts to control the tuner.  I
suspect most people are just using applications like MythTV, xawtv or
tvtime, which won't have these issues.

I don't intend to come across as argumentative, but if we haven't
heard a massive outcry about this by now, maybe nobody actually cares
and thus we shouldn't spend the time to build a whole infrastructure
to preserve the driver state across the low power mode.  Those people
who really do care can just disable the power management with a
modprobe option.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
