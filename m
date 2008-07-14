Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6E5Q95G004308
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 01:26:09 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6E5PkOH006221
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 01:25:46 -0400
Received: by ug-out-1314.google.com with SMTP id s2so196037uge.6
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 22:25:45 -0700 (PDT)
Date: Mon, 14 Jul 2008 07:25:56 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: David Brownell <david-b@pacbell.net>
Message-ID: <20080714052556.GA3470@ska.dandreoli.com>
References: <200807101914.10174.mb@bu3sch.de> <200807131215.12082.mb@bu3sch.de>
	<20080713154333.GA32133@ska.dandreoli.com>
	<200807131300.35126.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807131300.35126.david-b@pacbell.net>
Cc: video4linux-list@redhat.com, Michael Buesch <mb@bu3sch.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
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

On Sun, Jul 13, 2008 at 01:00:34PM -0700, David Brownell wrote:
> On Sunday 13 July 2008, Domenico Andreoli wrote:
> > Something respecting these conditions clearly conflicts with bttv
> > and looks like your bt8xxgpio driver. Indeed I do not see the need of
> > dropping it.
> > 
> > Currently my patch requires the bttv functionality, since it is done
> > to work toghether with bttv. Surely one must be able to use bttv only,
> > without gpiolib.
> 
> Just an idea ... I tend to agree that Michael's GPIO-only scenario
> is atypical for these chips.

I am facing another atipical scenario (I am writing the initialization
of bttv gpiolib sub-driver).

Say that a given card has 4 relays attached to its GPIOs. Only the
card's driver may know about these relays and only the driver should
be able to set those GPIO directions. Moreover, driver should prevent
direction change for them, which are intended for output only.

While I figure out how to prevent user direction tampering, how about
making gpiolib know which are the initial directions?

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
