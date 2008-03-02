Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m22NN1sh030948
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 18:23:01 -0500
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m22NMSIL028806
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 18:22:28 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Carl Karsten <carl@personnelware.com>
In-Reply-To: <47CB3212.1060509@personnelware.com>
References: <47CA4C4C.7010901@personnelware.com>
	<1204495846.7276.10.camel@pc08.localdom.local>
	<47CB3212.1060509@personnelware.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 00:15:31 +0100
Message-Id: <1204499731.7276.15.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] ioctl-test.c
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

Am Sonntag, den 02.03.2008, 17:02 -0600 schrieb Carl Karsten:
> hermann pitton wrote:
> > Hi Carl,
> > 
> > Am Sonntag, den 02.03.2008, 00:42 -0600 schrieb Carl Karsten:
> >> I copied the command line parameter support from test/pixfmt-test.c, and used 
> >> the prt_caps() func from lib/v4l2_driver.c.
> >>
> >> I am hoping to merge all of the test code into one big test, and put all the 
> >> generic code into one lib.
> >>
> >> Carl K
> >>
> > 
> > that looks interesting and should save time looking up the ioctls in the
> > code etc.
> 
> There is more to come :)
> 
> > 
> > But please don't post any patches inline with thunderbird, try as
> > attachment or use another mail client.
> 
> better?

at least functional ...

> > Concerning newly included headers, at what kernel environment you get
> > this to compile? My stuff still seems to be too old.
> 
> Oh, didn't include the Makefile, probably what is causing you problems.  I tried 
> to keep my vivi patch separate.
> 
> Carl K
> 

Ah, also without line breakage at vivi now.

Should be worth another try :)

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
