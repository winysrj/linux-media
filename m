Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd18532.kasserver.com ([85.13.139.13]:43581 "EHLO
	dd18532.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBQMC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 07:02:58 -0500
Date: Tue, 17 Feb 2009 13:02:55 +0100
From: Carsten Meier <cm@trexity.de>
To: kilgota@banach.math.auburn.edu
Cc: Andreas Witte <andreaz@t-online.de>, linux-media@vger.kernel.org
Subject: Re: Sometimes no lock on digivox miniII (Ver3.0)
Message-ID: <20090217130255.64262ff0@tuvok>
In-Reply-To: <alpine.LNX.2.00.0902162139510.3194@banach.math.auburn.edu>
References: <016001c99099$11476f20$33d64d60$@de>
	<alpine.LNX.2.00.0902162139510.3194@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 16 Feb 2009 21:54:40 -0600 (CST)
schrieb kilgota@banach.math.auburn.edu:

> 
> 
> On Tue, 17 Feb 2009, Andreas Witte wrote:
> 
> > Hello List,
> >
> > after changing my system to newer hardware (and use the latest
> > driver for af9015), it
> > seems the device didnt get a lock sometimes (mostly in the case the
> > system is started up).
> > I use the stick together with mythtv. If i get the partial lock, i
> > restart mythbackend or
> > switch channel - then i get the lock. If i get it just the first
> > time the stick is working
> > fine for the whole day. Only the very first channelpick after
> > system start seems to be the
> > problem.
> >
> > I cant reproduce this at all. Sometimes it works, sometimes not.
> > Anybody else seeing this?
> > Im on gentoo with 2.6.28 kernel.
> >
> > Any Ideas?
> >
> > Regards,
> > Andreas
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> I don't know anything about the af9015, what kind of device it is,
> what it is supposed to do, or who wrote the code, except that I just
> grepped the code for af9015, found it, and it is a USB device. So I
> am an outside observer. Here is my suspicion of what is wrong:
> 
> There was a rather nasty USB bug in 2.6.28 (no suffixes). It hit a
> lot of USB device drivers. The problem showed itself, pretty much, as
> you describe. I experienced it, too, with a couple of Gphoto camera
> drivers that I wrote which had been working ust fine for years and
> worked again just fine when I patched the kernel. So by extrapolation
> there is quite likely nothing wrong here, either. Probably, the best
> thing to do would be either to upgrade to 2.6.28.x or to downgrade to
> 2.6.27.x. If the problem goes away, good.
> 
> Theodore Kilgore

The bug occurs seldomly here, too. I'm using Ubuntu 8.10 with the
Ubuntu flavour of 2.6.27, some weeks old v4l-dvb-tree, and MSI digivox
II v3. I have to switch channels a couple of times to get a channel
lock. Can't reproduce it, and it doesn't happend for some time.
Possibly because of a v4l-dvb- or kernel- update.

Cheers,
Carsten
