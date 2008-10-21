Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LLAYvi014924
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:10:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LLAMGw008483
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:10:22 -0400
Date: Tue, 21 Oct 2008 19:09:40 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20081021190940.3d8700bb@pedra.chehab.org>
In-Reply-To: <200810212149.58105.laurent.pinchart@skynet.be>
References: <200810211916.47434.hverkuil@xs4all.nl>
	<200810212149.58105.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Proposal to rename compat_ioctl32.c to v4l2-compat-ioctl32.c
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

On Tue, 21 Oct 2008 21:49:57 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> On Tuesday 21 October 2008, Hans Verkuil wrote:
> > Hi Mauro,
> >
> > The compat_ioctl32.c is the only v4l2 core source whose name does not
> > begin with v4l2-. Because of that it is often overlooked (I certainly
> > did in the past!) when adding new ioctls.
> >
> > I propose to rename it to v4l2-compat-ioctl32.c. What I'm not sure of is
> > whether it is OK to rename the module as well to
> > v4l2_compat_ioctl32.ko? Or should that remain compat_ioctl32.ko?
> >
> > Personally I think it would be nice if this rename could go into 2.6.28.
> > This file is rarely touched so the chances of merge conflicts seem
> > remote to me.
> >
> > Note that I'm abroad from tomorrow until Sunday, so if you agree then
> > it's probably quicker if you make the change rather than waiting for me
> > to return. It's trivial anyway.
> 
> I'm in favour of the change. Renaming the module should not be an issue as it 
> should be pulled in by modprobe as a dependency anyway.

I agree. This seems to be a good idea.

I'll try to find some time for doing it this week. We should not forget to
update obsolete.txt to be sure that "make rmmod" and "make rminstall" will
properly remove the previous name.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
