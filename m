Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6NKIhX9028331
	for <video4linux-list@redhat.com>; Thu, 23 Jul 2009 16:18:43 -0400
Received: from keetweej.vanheusden.com (keetweej.vanheusden.com
	[80.126.110.251])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6NKIPNR004549
	for <video4linux-list@redhat.com>; Thu, 23 Jul 2009 16:18:26 -0400
Date: Thu, 23 Jul 2009 22:18:24 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20090723201823.GS11865@vanheusden.com>
References: <20090717174101.GB15611@vanheusden.com>
	<20090723165929.64cf3933@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723165929.64cf3933@pedra.chehab.org>
Cc: video4linux-list@redhat.com
Subject: Re: video4linux loopback device
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

> > Any chance that the video4linux loopback device will be integrated in
> > the main video4linux distribution and included in the kernel?
> > http://www.lavrsen.dk/foswiki/bin/view/Motion/VideoFourLinuxLoopbackDevice
> > or
> > http://sourceforge.net/projects/v4l2vd/
> > or
> > http://code.google.com/p/v4l2loopback/
> > This enables userspace postprocessors to feed the altered stream to
> > applications like amsn and skype for videochats.
> If the postprocessor application is LGPL, the better is to add it at libv4l.

I don't agree as the postprocessor implements fun-effects: warhol,
puzzle, circles, wobble, etc.


Folkert van Heusden

-- 
Looking for a cheap but fast webhoster with an excellent helpdesk?
http://keetweej.vanheusden.com/redir.php?id=1001
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
