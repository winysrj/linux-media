Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01Kmi4k002239
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 15:48:44 -0500
Received: from mk-outboundfilter-2.mail.uk.tiscali.com
	(mk-outboundfilter-2.mail.uk.tiscali.com [212.74.114.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01KmTGi005836
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 15:48:29 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: kilgota@banach.math.auburn.edu
Date: Thu, 1 Jan 2009 20:48:26 +0000
References: <200901010033.58093.linux@baker-net.org.uk>
	<1230831498.1702.40.camel@localhost>
	<Pine.LNX.4.64.0901011220230.18838@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0901011220230.18838@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901012048.26355.linux@baker-net.org.uk>
Cc: video4linux-list <video4linux-list@redhat.com>,
	sqcam-devel@lists.sourceforge.net
Subject: Re: [REVIEW] Driver for SQ-905 based cameras
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

On Thursday 01 January 2009, kilgota@banach.math.auburn.edu wrote:
> On Thu, 1 Jan 2009, Jean-Francois Moine wrote:

> > You did not look carefully at the finepix subdriver.
>
> Actually, I think that both of us did. There are certain diferences which
> are rather crucial and which led to the choice of doing things
> differently. If there are problems with our approach, then I am certainly
> open to suggestions, and I would think that Adam is, too. But perhaps it
> is good to recognize those differences, first.
>

Theodore and I did discuss for a while whether we needed to implement a 
finepix like state machine but thought the workqueue based design was 
simpler. It is certainly possible and I'd got a reasonable way through doing 
it before thinking that just looping in the workqueue would be easier.

> Its webcams work
>
> > quite the same as yours,
>
> No, they do not. That is the underlying problem.
>
> i.e. they ask for a control message to start
>
> > the bulk image transfer and an other control message to ack the
> > reception of the image.
>
> The problem is, this is not exactly the case. What really happens is the
> following, which you could perhaps help us to reconcile with the finepix.c
> way of doing things:
>
> To start, it seems the sensor is turned on. Then, to get each frame the
> sequence is the following:
>
> 1. By means of a control command, request data, up to max size of 0x8000,
> or whatever remains of te data for the given frame, whichever is less.
>
> 2. read the requested data (exact size of which has previously been
> specified).
>
> Repeat steps 1 and 2 until the frame is completely downloaded. In
> particular, in step (1) it is necessary to calculate and to request
> precisely the amount of data which can be obtained, and in step (2) the
> quantity of data which gets read is precisely that amount which has been
> requested in step (1). The Finepix cameras AFAICT permit one just to go
> ahead and request the max amount of data each time, and permit a short
> read. The SQ905 cameras will not let you do that. They will not.
>
> Then, finally, when the frame is completely downloaded one sends an ACK
> command which presumably lets the camera to refresh its memory with a new
> image.
>
> > For that, the finepix implements a state machine
> > running at interrupt level or in the system work queue. All USB
> > exchanges are asynchronous, so that the system thread is not blocked.
> > Instead, you do a loop in this thread: then, this one cannot be used for
> > any other purpose!
> >
> > I see only one alternative to do the image transfer:
> > - either implement a state machine as it is done in finepix,
>
> That would be much more complicated here than it is in the finepix driver,
> because of the need to keep at all times a running tally of the size
> remaining. Also because of the fact that here each individual read must be
> preceded by a command specifying the exact size of the coming read.
>

It isn't actually that much more complicated to keep track of the length - I 
had some code that had almost done it but the way data is requested does lead 
to more states hence a more complex driver.

> > - or have a specific work queue to handle the USB exchanges.
>
> Perhaps that is a better idea. Essentially, that is what was being
> attempted and you say it has not been correctly carried out. Suggestions
> as to how to rearrange things so as to do this are welcome.
>

I can't see what could be using this workqueue other than the USB exchanges - 
it is private to the sub driver and there is a per device instance of it in 
struct sd. What other than the call to schedule_delayed_work at the end of 
sd_start could try to use it?

Adam Baker


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
