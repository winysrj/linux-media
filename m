Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37414 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136Ab3JJCTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Oct 2013 22:19:09 -0400
Message-ID: <1381371651.1889.21.camel@palomino.walls.org>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Andy Walls <awalls@md.metrocast.net>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 09 Oct 2013 22:20:51 -0400
In-Reply-To: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-09-18 at 02:19 +0530, Rajil Saraswat wrote:
> Hi,
> 
>  I have a couple of PVR-500's which have additional tuners connected
> to them (using daughter cards).

The PVR-500's don't have daughter cards with additional tuners AFAIK. 

There is this however:
http://www.hauppauge.com/site/webstore2/webstore_avcable-pci.asp

Make sure you have any jumpers set properly and the cable connectors
seated properly.

Also make sure the cable is routed aways from any electrically noisy
cards and high speed data busses: disk controller cards, graphics cards,
etc.  

>  The audio is not usable on either
> 1.4.2 or 1.4.3 ivtv drivers. The issue is described at
> http://ivtvdriver.org/pipermail/ivtv-users/2013-September/010462.html

With your previous working kernel and with the non-working kernel, what
is the output of

$ v4l2-ctl -d /dev/videoX --log-status

after you have set up the inputs properly and have a known good signal
going into the input in question?

I'm speculating this is a problem with the cx25840 driver or the wm8775
driver, since they change more often than the ivtv driver.

BTW, I have very little time to fix things nowadays.

Also my development machine with PCI slots is tied up running simulation
experiments for 4 more weeks.  I can't test any fixes until those
simulations are done.

> Is there anything i can do to make kernel 3.10.7 (ivtv 1.4.3) play
> nice with my card?

1. Differential analysis of the v4l2-ctl --log-status output

2. Differential analysis of the kernel source code for the ivtv, cx2580,
and wm8775 drivers.

3. git bisection of the kernel starting from known good and bad kernel
versions, compile kernel, test, repeat.
http://git-scm.com/book/en/Git-Tools-Debugging-with-Git#Binary-Search
http://lwn.net/Articles/317154/

That's what I'd have to do, but it takes time and a setup that is able
to reporduce the problem reliably.

The git bisect is guaranteed to terminate on the problem change, if it
is a software change that caused the problem.

Although it doesn't sound like a hardware problem so far:

If it is a hardware problem induced by a change in hardware, or the way
the hardware is being driven, then verify your cables and any jumpers
and take steps to reduce EMI on the audio lines (move the cables away
from potential noise sources).  Also, if you suspect hardware, remove
*all* the PCI cards, blow the dust out of the PCI slots and reseat them.

Regards,
Andy

