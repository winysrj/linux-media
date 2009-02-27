Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2972 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZB0MMd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 07:12:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Conversion of vino driver for SGI to not use the legacy decoder API
Date: Fri, 27 Feb 2009 13:12:10 +0100
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>,
	Douglas Landgraf <dougsland@gmail.com>
References: <20090226214742.6576f30b@pedra.chehab.org> <20090227082216.574b42cf@pedra.chehab.org> <200902271253.28283.hverkuil@xs4all.nl>
In-Reply-To: <200902271253.28283.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271312.10467.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 February 2009 12:53:28 Hans Verkuil wrote:
> On Friday 27 February 2009 12:22:16 Mauro Carvalho Chehab wrote:
> > Well, let's merge the code. Maybe someone at the ML could have an Indy
> > and can test it.
> >
> > I think that the risk of breaking vino is not big, since this
> > conversion is more like a variable renaming. Also, after applying those
> > changes at linux-next, more people can test its code. Maybe we can add
> > some printk's asking for testers to contact us at LMML.
> >
> > I would love to finally remove another V4L1 header (video_decoder.h).
>
> OK, I'll send the pull request.

This will be delayed until early next week. I think I may have forgotten to 
push some final changes to my vino tree but I won't have access to that PC 
until Sunday.

> > > > Jean, I remember you mentioning that you wouldn't mind if the
> > > > i2c-algo-sgi code could be dropped which is only used by vino. How
> > > > important is that to you? Perhaps we are flogging a dead horse here
> > > > and we should just let this driver die.
> > >
> > > My rant was based on the fact that i2c-algo-sgi is totally
> > > SGI-specific while i2c-algo-* modules are supposed to be generic
> > > abstractions that can be reused by a variety of hardware. So
> > > i2c-algo-sgi should really be merged into drivers/media/video/vino.c.
> > > But as it takes a SGI system to build-test such a change, and I don't
> > > have one, I am reluctant to do it. If we can find a tester for your
> > > V4L2 conversion then maybe the same tester will be able to test my
> > > own changes.
> > >
> > > But i2c-algo-sgi isn't a big problem per se, it doesn't block further
> > > evolutions or anything like that, so if we can't find a tester and it
> > > has to stay for a few more years, this really isn't a problem for me.
> >
> > If the merger of i2c-algo-sgi is as not something complex, then we can
> > try to merge and apply at vino. Otherwise, we can just keep as-is.

Jean, if you are interested in doing this, then use my v4l-dvb-vino2 tree as 
the starting point. It would be nice to get it all done in one go.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
