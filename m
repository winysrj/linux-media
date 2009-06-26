Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f192.google.com ([209.85.210.192]:41784 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZFZUdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 16:33:09 -0400
Received: by yxe30 with SMTP id 30so106382yxe.4
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 13:33:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A4527D0.5040703@messagenetsystems.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
	 <1246041288.3159.51.camel@palomino.walls.org>
	 <829197380906261147g311d9a0ap7c9d5efc1473bf85@mail.gmail.com>
	 <1246042980.3159.68.camel@palomino.walls.org>
	 <829197380906261229g6e9f38q4be149597930ef0@mail.gmail.com>
	 <4A4527D0.5040703@messagenetsystems.com>
Date: Fri, 26 Jun 2009 16:33:08 -0400
Message-ID: <829197380906261333g2e850e4ax7abe7a03780a0f28@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
Cc: Andy Walls <awalls@radix.net>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 3:56 PM, Robert Vincent
> I care and I love the infrastructure that has been created.  However, it
> seems as though there are devices that do not conform to the paradigm or
> maybe they are not truly in "low power" mode.  My guess is the latter
> otherwise there would be a flurry of complaints.

Unfortunately, it's a little more complicated.  In the beginning, none
of the drivers did power management, and nobody cared because they
were all PCI cards and nobody would notice a 1 watt difference in
consumption on a 300 watt power supply.  These devices would maintain
persistent state across v4l closes because the chips were never
powered down.

Other devices, such as some USB devices, do have the power management
hooks implemented.  I don't know what the percentages are here (I
would have to look at the driver code to figure that out).  These
devices power down the chips when asked to by the bridge, and it is
typically triggered when no userland apps still have the v4l device
open.  In cases such as this, the power management works but it would
break cases where people used scripts to control the device.

There's probably a third class of devices worth mentioning: those that
really should be doing power management but aren't.  This includes all
the USB devices which burn your fingers and drain your laptop battery
from the time you plug it in until the time you unplug it, regardless
of whether you are using it.

It's not about "caring" or how much we do or do not love the
infrastructure.  It's about deciding what are the most important goals
given limited developer resources.  In this case, it's a question of
which is more important: incurring the cost of overhauling all the
drivers that do power management to have state persist after a power
down versus telling those users who use scripts to manually disable
power management.

Since we have no idea how many users use scripts to control their
tuners, and right now we don't know how many devices are effected, we
cannot really make any decisions one way or the other.

My hope is to see power management properly implemented in more
drivers since I'm concerned about the environment.  However, if I have
to do a huge overhaul of the state management in every driver just to
accommodate an unknown quantity of users, then I would have to think
twice about that.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
