Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38MbWKF014257
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 18:37:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38MbLq7029613
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 18:37:21 -0400
Date: Tue, 8 Apr 2008 19:36:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oliver Endriss <o.endriss@gmx.de>
Message-ID: <20080408193658.4fcb598b@gaivota>
In-Reply-To: <200804090027.19735@orion.escape-edv.de>
References: <47FBDD42.2030608@linuxtv.org>
	<200804090027.19735@orion.escape-edv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mkrufky@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

On Wed, 9 Apr 2008 00:27:18 +0200
Oliver Endriss <o.endriss@gmx.de> wrote:

> mkrufky@linuxtv.org wrote:
> > ...
> > ...all of this noise was made, and now not a single person is willing to 
> > test the proposed solution?
> > 
> > I don't think that there will be many more 2.6.24.y releases.  I have an 
> > ivtv patch queued for 2.6.24.5, and this tda10086 patch is sitting in my 
> > outbox, waiting for test results.
> > 
> > I suspect that 2.6.25 will be released in a few days, after which, 
> > 2.6.24.y -stable release turnaround gets slower and slower, and most 
> > likely will end by the time 2.6.26 is released.
> > 
> > If you want this fixed, then the fix needs testing .... NOW.
> 
> Always the same story. :-(
> 
> We need a test center, or preferably a community of testers who are
> willing to do regression tests with the drivers...

Agreed.

Michael,

About this specific patch, I don't see any reason why not forwarding it to
2.6.24. There were some reports already about this fixing some broken LNA.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
