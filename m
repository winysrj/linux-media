Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3DLivHJ003079
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 17:44:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3DLigPR018098
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 17:44:43 -0400
Date: Sun, 13 Apr 2008 18:42:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@empiatech.com>
Message-ID: <20080413184247.0e413896@areia>
In-Reply-To: <674190.766.qm@web906.biz.mail.mud.yahoo.com>
References: <20080413181018.7ac689cd@areia>
	<674190.766.qm@web906.biz.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Video <video4linux-list@redhat.com>
Subject: Re: [ANNOUNCE] Videobuf improvements to allow its usage with USB
 drivers
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

On Sun, 13 Apr 2008 23:38:24 +0200 (CEST)
Markus Rechberger <mrechberger@empiatech.com> wrote:

> 
> --- Mauro Carvalho Chehab <mchehab@infradead.org>
> schrieb:
> 
> > > my eeePC shows up 0-5% CPU usage with mplayer
> > > fullscreen without videobuf, seems more like
> > > something's broken in your testapplication or
> > > somewhere else?
> > 
> > The test application (capture_example) is the one
> > documented at the V4L2 spec.
> > The only difference is that I've incremented count
> > to 1000, to get more frames.
> > I don't see what's wrong on it.
> > 
> 
> I just tested capture_example on the eeePC (again non
> videobuf).
> 
> $ time ./capture_example
> .................. (printed this around 100 times?)
> real   0m4.312s
> user   0m0.010s
> sys    0m0.000s
> 
> strace clearly shows up VIDIOC_QBUF, VIDIOC_DQBUF.
> 
> So the question is rather what makes the results so
> bad on your system. 
> How can the userspace application go up to 100%, while
> the system isn't that busy?

Are you running your tests against the in-kernel version? Also, you're running
with count = 100 (the 100 dots). You need to edit the example code, and move to
1000 to have the same basement as I used here.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
