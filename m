Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3352 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1BEMNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 07:13:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.39] fix cx18 regression
Date: Sat, 5 Feb 2011 13:13:01 +0100
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
References: <201101260823.43809.hverkuil@xs4all.nl> <4D46C36A.1040407@redhat.com>
In-Reply-To: <4D46C36A.1040407@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102051313.01248.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, January 31, 2011 15:12:58 Mauro Carvalho Chehab wrote:
> Em 26-01-2011 05:23, Hans Verkuil escreveu:
> > Mauro, please get this upstream asap since this fix needs to go into 2.6.38
> > as well.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit e5fb95675639f064ca40df7ad319f1c380443999:
> >   Hans Verkuil (1):
> >         [media] vivi: fix compiler warning
> > 
> > are available in the git repository at:
> > 
> >   ssh://linuxtv.org/git/hverkuil/media_tree.git cx18-fix
> > 
> > Hans Verkuil (1):
> >       cx18: fix kernel oops when setting MPEG control before capturing.
> > 
> >  drivers/media/video/cx18/cx18-driver.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> 
> I tried to apply it against 2.6.38-rc2, but it failed:

I think there is a mixup here. The patch is for 2.6.39 and it should apply
cleanly. Please apply for 2.6.39!

It is only necessary to apply it to 2.6.38 if your pull request to Linus of
February 2nd ("V4L/DVB patches") is merged. It still hasn't been merged, so I
suspect that Linus refused them (or are they still pending?).

When I wrote the original mail I mistakenly assumed that the cx18 control
framework patches were already upstream.

So, if your pull request to Linus isn't merged for 2.6.38, then no action
regarding 2.6.38 needs to be taken. If it is merged, then this fix must
be included in 2.6.38 as well.

Regards,

	Hans

> 
>        	mutex_init(&cx->serialize_lock);
>         mutex_init(&cx->gpio_lock);
>         mutex_init(&cx->epu2apu_mb_lock);
>        	mutex_init(&cx->epu2cpu_mb_lock);
> 
>         ret = cx18_create_in_workq(cx);
> <<<<<<<
> =======
>        	cx->cxhdl.capabilities = CX2341X_CAP_HAS_TS | CX2341X_CAP_HAS_SLICED_VBI;
>         cx->cxhdl.ops = &cx18_cxhdl_ops;
>         cx->cxhdl.func = cx18_api_func;
>         cx->cxhdl.priv = &cx->streams[CX18_ENC_STREAM_TYPE_MPG];
>         ret = cx2341x_handler_init(&cx->cxhdl, 50);
> >>>>>>>
>         if (ret)
>                 return ret;
> 
> Perhaps this change requires some patch delayed for .39?
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
