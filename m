Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DNOPIe004222
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:24:25 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DNO1To012833
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:24:01 -0500
Received: by nf-out-0910.google.com with SMTP id g13so121259nfb.21
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 15:24:00 -0800 (PST)
Message-ID: <37219a840802131524i33e34930uc95b7a12d484526a@mail.gmail.com>
Date: Wed, 13 Feb 2008 18:24:00 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Brandon Philips" <bphilips@suse.de>
In-Reply-To: <20080213202055.GA26352@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
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

On Feb 13, 2008 3:20 PM, Brandon Philips <bphilips@suse.de> wrote:
> On 10:24 Tue 05 Feb 2008, Mauro Carvalho Chehab wrote:
> > Maybe we've took the wrong direction when we've decided to select
> > mercurial. It were better and easier to use, on that time, but the -git
> > improvements happened too fast.
>
> We should consider a move to a full-tree git.  Particularly, it would be
> nice to be have v4l-dvb merging/building against other subsystems in the
> linux-next tree:
>
>   http://lkml.org/lkml/2008/2/11/512
>
> Also, it would save the silly pain of things like this meye.h thing and
> pulling in fixes from the rest of the community that patches against git
> trees.


When we moved from CVS to HG, we lost many developers.

Of the developers that remain, most of us are finally comfortable
working in mercurial.

I understand the benefits of moving to git, but that option was on the
table when we moved to mercurial from cvs, and it was shot down.

I would prefer that we stick with what we have for now -- for the sake
of our users / testers, and for the sake of our developers.

Lets not drive away more contributors.

Additionally, the moment we move development from hg to git, we are
bound to the development kernel -- we will no longer be able to work
against any stable kernel series, and we will lose all of our testers.

v4l/dvb is a bit different from kernel development of other
subsystems, in that we work on drivers for new devices.  Users will
not want to upgrade an entire kernel, let alone build that entire
kernel themselves, just so they can get new device support.  We will
quickly notice that users will be less daring to buy new hardware, and
will start buying older hardware known to have stable linux support.

As much as I wanted us all to use git back when we were discussing the
SCM move a few years ago, I am entirely against it right now.

Regards,

Mike Krufky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
