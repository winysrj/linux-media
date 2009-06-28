Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60959 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbZF1ARM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 20:17:12 -0400
Subject: Re: Bah! How do I change channels?
From: Andy Walls <awalls@radix.net>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Cc: George Adams <g_adams27@hotmail.com>, dheitmueller@kernellabs.com,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <b24e53350906271457r594decccg397537db0d324754@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <COL103-W513258452EA45C7700193888320@phx.gbl>
	 <b24e53350906271457r594decccg397537db0d324754@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 20:17:18 -0400
Message-Id: <1246148238.3148.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-06-27 at 17:57 -0400, Robert Krakora wrote:

> Andy:
> 
> I too care about the environment.  I am trying to find some extra time
> to figure out if my KWorld 330U USB TV devices are actually going into
> low power mode or not.  I would say not as they get really hot, so I
> unplug them when I am not using them.  I told Devin I would work on
> this and I have an accurate analog amp meter, but I got very busy at
> work and at home with the kids.  However, I don't believe that the
> answer is to disable power management as some of these parts get so
> hot that leaving them in a powered state and tuned to a channel will
> probably damage the device.  Remember, these are silicon tuners, not
> the old discrete tuners that have way more surface area to dissipate
> heat.

Oh, I'm not against power management.  But state is lost - somethings
that's fixable with a lot of work apparently.  I was thinking maybe the
V4L2 spec could change.

I was also pondering maybe the final close() shouldn't be the trigger
for powering devices down.  How about the final close() + 30 seconds?
Or the final close() + some user set interval.  It seems like scheduling
delayed work to do something like that should be easy enough.  That
would require a spec change about state being only preserved until power
management powered the thing down and probably an additional ioctl()
added to set the powerdown delay.  The driver could probably default
delay to some interval that would be good for most users.

I don't know.  Just ideas...

Regards,
Andy



