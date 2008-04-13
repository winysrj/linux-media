Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3DLck36001234
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 17:38:46 -0400
Received: from web906.biz.mail.mud.yahoo.com (web906.biz.mail.mud.yahoo.com
	[216.252.100.52])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3DLcUT5015762
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 17:38:30 -0400
Date: Sun, 13 Apr 2008 23:38:24 +0200 (CEST)
From: Markus Rechberger <mrechberger@empiatech.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080413181018.7ac689cd@areia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <674190.766.qm@web906.biz.mail.mud.yahoo.com>
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


--- Mauro Carvalho Chehab <mchehab@infradead.org>
schrieb:

> > my eeePC shows up 0-5% CPU usage with mplayer
> > fullscreen without videobuf, seems more like
> > something's broken in your testapplication or
> > somewhere else?
> 
> The test application (capture_example) is the one
> documented at the V4L2 spec.
> The only difference is that I've incremented count
> to 1000, to get more frames.
> I don't see what's wrong on it.
> 

I just tested capture_example on the eeePC (again non
videobuf).

$ time ./capture_example
.................. (printed this around 100 times?)
real   0m4.312s
user   0m0.010s
sys    0m0.000s

strace clearly shows up VIDIOC_QBUF, VIDIOC_DQBUF.

So the question is rather what makes the results so
bad on your system. 
How can the userspace application go up to 100%, while
the system isn't that busy?

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
