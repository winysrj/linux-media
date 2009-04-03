Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail47.e.nsc.no ([193.213.115.47]:47121 "EHLO mail47.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZDCGiu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 02:38:50 -0400
Subject: Re: gpsca kernel BUG when disconnecting camera while streaming
 with mmap (2.6.29-rc8)
From: Stian Skjelstad <stian@nixia.no>
To: Adam Baker <linux@baker-net.org.uk>
Cc: "'Jean-Francois Moine'" <moinejf@free.fr>,
	linux-media@vger.kernel.org
In-Reply-To: <200904022354.24951.linux@baker-net.org.uk>
References: <1238347504.5232.17.camel@laptop>
	 <20090402091112.5411b711@free.fr> <000301c9b363$d0533ce0$70f9b6a0$@no>
	 <200904022354.24951.linux@baker-net.org.uk>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 08:33:33 +0200
Message-Id: <1238740413.5794.4.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > >You did not tell which version of gspca you use. If it is the one of a
> > >kernel older than 2.6.30, you should update. Also, may this problem
> > >be reproduced?
> >
> > I'm using the built in one. I'm going to upgrade to 2.6.29 very soon. And
> > if problem still persists, I can build gspca outside the kernel instead.
> >
> 
> 2.6.29 isn't good enough, you need the patch at
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d08e2ce0ebb38f2b66d875a09ebab3ed548354ee
> which only hit Linus' tree 3 days ago.
> 
> I'm not sure whether it is appropriate for that patch to go to -stable. There 
> are other patches that affect the relevant code but that one looks like it is 
> a fix for a real bug that should apply cleanly to 2.6.29.
> 
> I guess if you are able to confirm if it fixes 2.6.29 for you that would be a 
> good indication it is appropriate for -stable.

That patch does not help. It still panics inside gspca_set_alt0 when
calling STREAM_OFF, so something else causes gspca_dev->present not to
be cleared.

Another detail I noticed is that VIDIOC_DQBUF returns EAGAIN after I
have disconnected the camera.... Will try another version when I find
the time for it.

Stian Skjelstad

