Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1E00CbO023560
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 19:00:12 -0500
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DNxoah001179
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:59:50 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <37219a840802131524i33e34930uc95b7a12d484526a@mail.gmail.com>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
	<37219a840802131524i33e34930uc95b7a12d484526a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 00:55:06 +0100
Message-Id: <1202946906.3653.107.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [v4l-dvb-maintainer] Moving to git for v4l-dvb
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

Am Mittwoch, den 13.02.2008, 18:24 -0500 schrieb Michael Krufky:
> On Feb 13, 2008 3:20 PM, Brandon Philips <bphilips@suse.de> wrote:
> > On 10:24 Tue 05 Feb 2008, Mauro Carvalho Chehab wrote:
> > > Maybe we've took the wrong direction when we've decided to select
> > > mercurial. It were better and easier to use, on that time, but the -git
> > > improvements happened too fast.
> >
> > We should consider a move to a full-tree git.  Particularly, it would be
> > nice to be have v4l-dvb merging/building against other subsystems in the
> > linux-next tree:
> >
> >   http://lkml.org/lkml/2008/2/11/512
> >
> > Also, it would save the silly pain of things like this meye.h thing and
> > pulling in fixes from the rest of the community that patches against git
> > trees.
> 
> 
> When we moved from CVS to HG, we lost many developers.
> 
> Of the developers that remain, most of us are finally comfortable
> working in mercurial.
> 
> I understand the benefits of moving to git, but that option was on the
> table when we moved to mercurial from cvs, and it was shot down.
> 
> I would prefer that we stick with what we have for now -- for the sake
> of our users / testers, and for the sake of our developers.
> 
> Lets not drive away more contributors.
> 
> Additionally, the moment we move development from hg to git, we are
> bound to the development kernel -- we will no longer be able to work
> against any stable kernel series, and we will lose all of our testers.
> 
> v4l/dvb is a bit different from kernel development of other
> subsystems, in that we work on drivers for new devices.  Users will
> not want to upgrade an entire kernel, let alone build that entire
> kernel themselves, just so they can get new device support.  We will
> quickly notice that users will be less daring to buy new hardware, and
> will start buying older hardware known to have stable linux support.
> 
> As much as I wanted us all to use git back when we were discussing the
> SCM move a few years ago, I am entirely against it right now.
> 
> Regards,
> 
> Mike Krufky
> 

Mike,

I totally agree with you.

All the work invested in the build system to attract more testers did
not help us to keep some basic community for testing.

For that, we are not better off as when Gerd and some inclined enough
fought for every tester. I stated already, that it looks like we have to
buy all new cards soon on our own budget, despite of what we have done.

The current checkpatch.pl hysteria on decades old code does the rest..

Cheers,
Hermann





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
