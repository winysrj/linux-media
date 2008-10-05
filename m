Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m95BVsRn013559
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:31:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m95BVhbV025562
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:31:43 -0400
Date: Sun, 5 Oct 2008 08:31:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20081005083136.05714021@pedra.chehab.org>
In-Reply-To: <200810051315.53755.hverkuil@xs4all.nl>
References: <200810031313.36607.hverkuil@xs4all.nl>
	<200810031652.00222.hverkuil@xs4all.nl>
	<20081005075228.202bdfc7@pedra.chehab.org>
	<200810051315.53755.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: RFC: move zoran/core/i2c drivers to separate directories
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

On Sun, 5 Oct 2008 13:15:53 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > In this case, the bridge devices are requesting services for the i2c
> > drivers. So, the bridges are the clients, and the ancilary drivers
> > are the servers.
> 
> The name is derived from the i2c naming convention where you have an 
> adapter and i2c client chips on that adapter. So it is really 
> adapter/client rather than server/client. Since 99% (if not 100%) of 
> all ancilary drivers are i2c clients I thought it made sense to keep 
> that name.

In the case of I2C, the core I2C is a sort of "server" (on some cases, the
adapter also provides some services to the "client", like doing the low-level
i2c adapter connection for the "clients" to access the device i2c bus).

So, while "client" is not the most fortunate naming on I2C, it is not wrong. 

> I'm not attached to the name, I just haven't found anything 
> better yet. Hmm, what about media_service? media_slave? media_helper? 
> media_ancilary? media_anc? media_support? media_chip? I don't know, I 
> just keep coming back to media_client as the one that, while not 
> perfect, at least closely matches the current i2c naming scheme.

I agree that it is not easy to name it ;)

ancilary is the most appropriate term, IMO, but it is really ugly... maybe
media_slave? Just my 2 cents.

> > On almost all other subsystems (dvb is one of the exceptions), the
> > core is at drivers/<subsystem>. I don't see why we shouldn't keep all
> > the core stuff there.
> 
> You are right about this. As long as we are careful to use the v4l2_ 
> prefix. It's important to quickly see which files are core framework 
> and which are drivers.

I like the idea of prefixing core with v4l2_.

> > IMO, the better is to have a TODO file with the planned core changes.
> > I had to postpone some important driver fixes to 2.6.28 simply
> > because the patches didn't apply on my "fixes" branch (I remember
> > that I had to re-tag several cx18 changes, and an important s2255drv
> > change), due to the changes at the KABI on V4L core introduced early
> > at 2.6.28 development cycle.
> 
> I don't quite understand how a TODO file would help.

It would provide the others some info on what's being changing at the subsystem
internals and when. It is a (weak) way to aware the others that things can broke.

> And you meant 2.6.27 rather than 2.6.28, right?

I mean: some important fixes meant to happen on 2.6.27 had to be postponed to
2.6.28 simply due to the KABI breakages.

I can't see an easy solution for this. The better would be to have developer
trees based on my -git tree, where all fixes come to the -fixes branch, and all
new stuff at the "working" branch [1].

[1] This is the current naming on my -git tree. I think the better would simply
to break it into two separate trees, since this costs almost nothing on
filesystems, if you clone the other local trees with -l flag.

> So the conclusion is: I can create a patch that moves zoran drivers into 
> a new zoran directory for inclusion with 2.6.28, core sources stay 
> untouched, and i2c client drivers can be moved into a new directory 
> when 2.6.29 starts. Right?

Yes.

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
