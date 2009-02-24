Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1145 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZBXH1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 02:27:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
Date: Tue, 24 Feb 2009 08:25:57 +0100
Cc: David Ellingsworth <david@identd.dyndns.org>,
	linux-media@vger.kernel.org
References: <200902221115.01464.hverkuil@xs4all.nl> <30353c3d0902230653w419e10c4u73b7f70f135d6663@mail.gmail.com> <Pine.LNX.4.58.0902231842300.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902231842300.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240825.57694.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 24 February 2009 06:04:48 Trent Piepho wrote:
> On Mon, 23 Feb 2009, David Ellingsworth wrote:
> > On Sun, Feb 22, 2009 at 5:15 AM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > > Optional question:
> >
> > Why can't we drop support for all but the latest kernel?
> >
> > > Why:
> >
> > As others have already pointed out, it is a waste of time for
> > developers who volunteer their time to work on supporting prior kernel
> > revisions for use by enterprise distributions. The task of
> > back-porting driver modifications to earlier kernels lessens the
> > amount of time developers can focus on improving the quality and
> > stability of new and existing drivers. Furthermore, it deters driver
> > development since  there an expectation that they will back-port their
> > driver to earlier kernel versions. Finally, as a developer, I have
>
> We don't backport the drivers to older kernels.  That's what drivers kept
> in a full kernel tree end up doing.
>
> Generally there is just the code for the newest kernel to think about.
> Most of the driver code doesn't have backward compatibility ifdefs.  Most
> of the compat issues are handled transparently by compat.h and only those
> developers who patch compat.h ever need to know they exist.
>
> When a developer does need to deal with some compat ifdef in a driver,
> almost all the time it's something trivial and obvious.  Change the
> variable name in both branches.  Copy in a couple lines of boilerplate.
>
> Sometimes a bigger issue comes up.  IIRC, around 2.6.16 there was a major
> class_device change in the kernel and backward compat code for it ended
> up being a nightmare.  So we didn't do it.  We stopped supporting back to
> ~2.6.11 and moved up the target past the problem change.

Actually that was in 2.6.19. The class_device #ifs are still in e.g. 
v4l2-dev.c. It would be a nice bonus when we can drop that as well. It 
could be that there were additional changes as well in pre-2.6.16 kernels. 
If so, then we definitely implemented the backwards compat for it at the 
time.

> Maybe this has happened again with the changes to i2c?  I don't think
> it's that hard, but I've yet to do it myself, so maybe it is.

I've been working on this since around 2.6.24 (and been involved with i2c in 
one way or another for quite a bit longer) and I say it's hard. Jean 
Delvare made the i2c core changes in 2.6.22 and he says it's hard. So 
perhaps if the two people who know most about the topic say it's hard and 
not solvable with a compat.h change, or the occasional #if, or a regexp as 
Mauro seems to be attempting now, then it really IS hard.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
