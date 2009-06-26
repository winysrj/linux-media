Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52468 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZFZSdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:33:08 -0400
Subject: Re: Bah! How do I change channels?
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 14:34:48 -0400
Message-Id: <1246041288.3159.51.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-06-26 at 13:23 -0400, Devin Heitmueller wrote:
> On Fri, Jun 26, 2009 at 1:19 PM, Robert
> Krakora<rob.krakora@messagenetsystems.com> wrote:
> > I had ran into this before with the KWorld a few months back.
> > However, whatever problem existed that forced me to add
> > "no_poweroff=1" to modprobe.conf for the em28xx module has went away.
> > I have been able to use v4l-ctl or ivtv-tune without any problems to
> > tune analog channels over cable.
> 
> Well, bear in mind that if you run v4l-ctl *after* the program is
> streaming it should work.  However, if you run v4l-ctl and then try to
> stream I suspect it will fail.
> 
> If it's working, then perhaps I should take a look at the power
> management code in em28xx/xc2028 since I don't know why it would work


Hmm, that sure sounds like a V4L2 spec violation.  From the V4L2 close()
description:

"Closes the device. Any I/O in progress is terminated and resources
associated with the file descriptor are freed. However data format
parameters, current input or output, control values or other properties
remain unchanged."


Regards,
Andy

> (and perhaps the tuner is *not* being powered down like it should be).
> 
> Devin
> 

