Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m95BGUSb009524
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:16:30 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m95BG2D3019396
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:16:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sun, 5 Oct 2008 13:15:53 +0200
References: <200810031313.36607.hverkuil@xs4all.nl>
	<200810031652.00222.hverkuil@xs4all.nl>
	<20081005075228.202bdfc7@pedra.chehab.org>
In-Reply-To: <20081005075228.202bdfc7@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810051315.53755.hverkuil@xs4all.nl>
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

On Sunday 05 October 2008 12:52:28 Mauro Carvalho Chehab wrote:
> On Fri, 3 Oct 2008 16:52:00 +0200
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > >  What about clients? Since these are all
> > > > (i2c) clients on a (usually i2c) bus.
> > >
> > > "Clients" comes from a software command/control vs hardware
> > > support perspective.  That's certainly valid, but I think the
> > > term "client" is overloaded semantically.
> >
> > Actually, no. You made me realize that i2c was probably not the
> > best name to use for that directory. The media_client struct I have
> > in mind is actually bus-agnostic. Since 99% of all ancillary
> > drivers are i2c and i2c has an i2c_client struct, the usage of
> > 'client' make sense (sort of).
>
> media_client for i2c ancilary drivers? This sounds wrong to me. The
> model of client/server assumes that the client is the piece of
> software that requests services from the other piece of software (the
> server).
>
> In this case, the bridge devices are requesting services for the i2c
> drivers. So, the bridges are the clients, and the ancilary drivers
> are the servers.

The name is derived from the i2c naming convention where you have an 
adapter and i2c client chips on that adapter. So it is really 
adapter/client rather than server/client. Since 99% (if not 100%) of 
all ancilary drivers are i2c clients I thought it made sense to keep 
that name. I'm not attached to the name, I just haven't found anything 
better yet. Hmm, what about media_service? media_slave? media_helper? 
media_ancilary? media_anc? media_support? media_chip? I don't know, I 
just keep coming back to media_client as the one that, while not 
perfect, at least closely matches the current i2c naming scheme.

>
> > > > 1) Moving zoran sources into a zoran directory reflects current
> > > > practice.
> > >
> > > Yup.  Good idea.
>
> Seems ok to me.
>
> > > > 2) We could prefix all core files with a common prefix (v4l2_)
> > > > as an alternative. But I think it is cleaner to have a core
> > > > directory instead.
> > >
> > > Agree, don't do the prefix.  A core directory is better.
>
> On almost all other subsystems (dvb is one of the exceptions), the
> core is at drivers/<subsystem>. I don't see why we shouldn't keep all
> the core stuff there.

You are right about this. As long as we are careful to use the v4l2_ 
prefix. It's important to quickly see which files are core framework 
and which are drivers.

> > > > 3) Ditto for all i2c drivers, but there are so many that I
> > > > think these really should be moved to their own directory.
> > >
> > > Agree.  The name is not all that important either (although easy
> > > to argue about).
> > >
> > > One cost I'd like to avoid is in terms of recursive descent
> > > searches and diff's.  Don't move the files up out of media/video
> > > without good reason, to keep the file count for lazy searches
> > > (grep -R 'foo' video ) the same.  But you said that was your plan
> > > anyway.
> >
> > Yes.
>
> If you want to do grep, then have a copy of my -git tree. Then, you
> can simply use "git grep" that it is a way faster than doing a
> recursive grep.
>
> Every time we move things from one directory to another, this breaks
> things and cause some mess. This is expecially valid for drivers that
> are under development.
>
> We already did one such big rearrangements for the last kernel
> version, with the common tuners. In the case of tuners, this had a
> good reason, since the Kconfig rules were being very confusing due to
> dvb drivers needing to access tuners. Yet, it required me extra care
> when merging drivers, since several ones broke or caused merge
> conflicts, since they were developed with the old model in mind.
>
> We should really avoid this, unless we have a really good reason. And
> we shouldn't do it on every next kernel cycle.
>
> If you really want to to this, I think that the better would be to
> start discussing this for the 2.6.29 merge window.

OK, I do think we need to do it, but there is no hurry. I wasn't aware 
that it was that difficult to move things around. 2.6.29 would work 
just as well for me.

> IMO, the better is to have a TODO file with the planned core changes.
> I had to postpone some important driver fixes to 2.6.28 simply
> because the patches didn't apply on my "fixes" branch (I remember
> that I had to re-tag several cx18 changes, and an important s2255drv
> change), due to the changes at the KABI on V4L core introduced early
> at 2.6.28 development cycle.

I don't quite understand how a TODO file would help. And you meant 
2.6.27 rather than 2.6.28, right?

So the conclusion is: I can create a patch that moves zoran drivers into 
a new zoran directory for inclusion with 2.6.28, core sources stay 
untouched, and i2c client drivers can be moved into a new directory 
when 2.6.29 starts. Right?

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
