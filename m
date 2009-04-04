Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail46.e.nsc.no ([193.213.115.46]:61758 "EHLO mail46.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZDDKOw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 06:14:52 -0400
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
Date: Sat, 04 Apr 2009 12:09:34 +0200
Message-Id: <1238839774.7062.4.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > >You did not tell which version of gspca you use. If it is the one of a
> > >kernel older than 2.6.30, you should update. Also, may this problem
> > >be reproduced?

> 2.6.29 isn't good enough, you need the patch at
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d08e2ce0ebb38f2b66d875a09ebab3ed548354ee
> which only hit Linus' tree 3 days ago.

I just tested 2.6.29 with http://linuxtv.org/hg/~jfrancois/gspca/ bz2
tarball named gspca-d8d701594f71.tar.bz2 installed over it, and it works
(with higher framerate):
 * VIDIOC_QBUF and VIDIOC_DQBUF no longer gives EAGAIN when device goes
missing
 * VIDIOC_STREAMOFF does no longer make the kernel oops on if device is
missing.

Stian Skjelstad

