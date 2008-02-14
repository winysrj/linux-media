Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1ENdXDi025793
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 18:39:33 -0500
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.182])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1ENdC9V023731
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 18:39:12 -0500
Received: by el-out-1112.google.com with SMTP id r23so578899elf.7
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 15:39:06 -0800 (PST)
Date: Thu, 14 Feb 2008 15:08:50 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080214230850.GA5990@plankton.ifup.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
	<20080214174602.4ed91987@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214174602.4ed91987@gaivota>
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Brandon Philips <bphilips@suse.de>
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

On 17:46 Thu 14 Feb 2008, Mauro Carvalho Chehab wrote:
> On Wed, 13 Feb 2008 12:20:55 -0800
> Brandon Philips <bphilips@suse.de> wrote:
> 
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
> About linux-next, this is really a good idea. I've already implemented a
> linux-next -git tree for v4l-dvb. This tree is generated at the same time I
> generate the master -git. Since I update this often, I think this will work
> properly.

Great.  It should be interesting to see what happens with linux-next.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
