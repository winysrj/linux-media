Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DNsXga020384
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:54:33 -0500
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DNralL029973
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:54:12 -0500
Received: by wr-out-0506.google.com with SMTP id 70so337630wra.7
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 15:54:12 -0800 (PST)
Message-ID: <a728f9f90802131554y6f2c9ca1s7a8c264b46dc9a40@mail.gmail.com>
Date: Wed, 13 Feb 2008 18:54:11 -0500
From: "Alex Deucher" <alexdeucher@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840802131524i33e34930uc95b7a12d484526a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
	<37219a840802131524i33e34930uc95b7a12d484526a@mail.gmail.com>
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Brandon Philips <bphilips@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Feb 13, 2008 6:24 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
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

Why would git have any affect on what kernels you could test against?
It's just an scm like hg or cvs.

Alex

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
