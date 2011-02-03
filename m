Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3797 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1BCHJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Feb 2011 02:09:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PATCHES FOR 2.6.39] fix cx18 regression
Date: Thu, 3 Feb 2011 08:09:31 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201101260823.43809.hverkuil@xs4all.nl> <4D46C36A.1040407@redhat.com> <1296690612.2402.4.camel@localhost>
In-Reply-To: <1296690612.2402.4.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102030809.31469.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, February 03, 2011 00:50:12 Andy Walls wrote:
> On Mon, 2011-01-31 at 12:12 -0200, Mauro Carvalho Chehab wrote:
> > Em 26-01-2011 05:23, Hans Verkuil escreveu:
> > > Mauro, please get this upstream asap since this fix needs to go into 2.6.38
> > > as well.
> > > 
> > > Regards,
> > > 
> > > 	Hans
> > > 
> > > The following changes since commit e5fb95675639f064ca40df7ad319f1c380443999:
> > >   Hans Verkuil (1):
> > >         [media] vivi: fix compiler warning
> > > 
> > > are available in the git repository at:
> > > 
> > >   ssh://linuxtv.org/git/hverkuil/media_tree.git cx18-fix
> > > 
> > > Hans Verkuil (1):
> > >       cx18: fix kernel oops when setting MPEG control before capturing.
> > > 
> > >  drivers/media/video/cx18/cx18-driver.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > 
> > I tried to apply it against 2.6.38-rc2, but it failed:
> > 
> >        	mutex_init(&cx->serialize_lock);
> >         mutex_init(&cx->gpio_lock);
> >         mutex_init(&cx->epu2apu_mb_lock);
> >        	mutex_init(&cx->epu2cpu_mb_lock);
> > 
> >         ret = cx18_create_in_workq(cx);
> > <<<<<<<
> > =======
> >        	cx->cxhdl.capabilities = CX2341X_CAP_HAS_TS | CX2341X_CAP_HAS_SLICED_VBI;
> >         cx->cxhdl.ops = &cx18_cxhdl_ops;
> >         cx->cxhdl.func = cx18_api_func;
> >         cx->cxhdl.priv = &cx->streams[CX18_ENC_STREAM_TYPE_MPG];
> >         ret = cx2341x_handler_init(&cx->cxhdl, 50);
> > >>>>>>>
> >         if (ret)
> >                 return ret;
> > 
> > Perhaps this change requires some patch delayed for .39?
> 
> The bug was authored on 31 Dec 2010, but not comitted until 23 Jan 2011:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git?a=commit;h=82f205b2f2a1deb1ab700a601ef48a4db4ca4f4e
> 
> Kernel 2.6.38-rc2 appears to have a date one day prior: 22 Jan 2011:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git?a=commit;h=1bae4ce27c9c90344f23c65ea6966c50ffeae2f5
> 
> So the bug will be in whatever version comes out after 2.6.38-rc2

I'll look at this tomorrow. It's been very busy for the past week and I haven't
had time to look into this.

It definitely doesn't require any other patches, but probably some new patch
changed the order of some lines causing the patch to fail.

Regards,

	Hans

> 
> Regards,
> Andy
> 
> > Cheers,
> > Mauro
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
