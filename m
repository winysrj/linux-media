Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m95Aqvne002993
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 06:52:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m95AqaEu010498
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 06:52:45 -0400
Date: Sun, 5 Oct 2008 07:52:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20081005075228.202bdfc7@pedra.chehab.org>
In-Reply-To: <200810031652.00222.hverkuil@xs4all.nl>
References: <200810031313.36607.hverkuil@xs4all.nl>
	<200810031431.23882.hverkuil@xs4all.nl>
	<1223043826.9691.54.camel@palomino.walls.org>
	<200810031652.00222.hverkuil@xs4all.nl>
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

On Fri, 3 Oct 2008 16:52:00 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > >  What about clients? Since these are all
> > > (i2c) clients on a (usually i2c) bus.
> >
> > "Clients" comes from a software command/control vs hardware support
> > perspective.  That's certainly valid, but I think the term "client"
> > is overloaded semantically. 

> Actually, no. You made me realize that i2c was probably not the best 
> name to use for that directory. The media_client struct I have in mind 
> is actually bus-agnostic. Since 99% of all ancillary drivers are i2c 
> and i2c has an i2c_client struct, the usage of 'client' make sense 
> (sort of).

media_client for i2c ancilary drivers? This sounds wrong to me. The model of
client/server assumes that the client is the piece of software that requests
services from the other piece of software (the server).

In this case, the bridge devices are requesting services for the i2c drivers.
So, the bridges are the clients, and the ancilary drivers are the servers.

> > > 1) Moving zoran sources into a zoran directory reflects current
> > > practice.
> >
> > Yup.  Good idea.

Seems ok to me.

> >
> > > 2) We could prefix all core files with a common prefix (v4l2_) as
> > > an alternative. But I think it is cleaner to have a core directory
> > > instead.
> >
> > Agree, don't do the prefix.  A core directory is better.

On almost all other subsystems (dvb is one of the exceptions), the core is at
drivers/<subsystem>. I don't see why we shouldn't keep all the core stuff there.

> > > 3) Ditto for all i2c drivers, but there are so many that I think
> > > these really should be moved to their own directory.
> >
> > Agree.  The name is not all that important either (although easy to
> > argue about).
> >
> > One cost I'd like to avoid is in terms of recursive descent searches
> > and diff's.  Don't move the files up out of media/video without good
> > reason, to keep the file count for lazy searches (grep -R 'foo' video
> > ) the same.  But you said that was your plan anyway.
> 
> Yes.

If you want to do grep, then have a copy of my -git tree. Then, you can simply
use "git grep" that it is a way faster than doing a recursive grep.

Every time we move things from one directory to another, this breaks things and
cause some mess. This is expecially valid for drivers that are under
development.

We already did one such big rearrangements for the last kernel version, with
the common tuners. In the case of tuners, this had a good reason, since the
Kconfig rules were being very confusing due to dvb drivers needing to access
tuners. Yet, it required me extra care when merging drivers, since several ones
broke or caused merge conflicts, since they were developed with the old model
in mind.

We should really avoid this, unless we have a really good reason. And we
shouldn't do it on every next kernel cycle.

If you really want to to this, I think that the better would be to start
discussing this for the 2.6.29 merge window.

IMO, the better is to have a TODO file with the planned core changes. I had to
postpone some important driver fixes to 2.6.28 simply because the patches
didn't apply on my "fixes" branch (I remember that I had to re-tag several cx18
changes, and an important s2255drv change), due to the changes at the KABI on
V4L core introduced early at 2.6.28 development cycle.

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
