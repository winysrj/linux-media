Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:45969 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZCJSjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 14:39:41 -0400
Date: Tue, 10 Mar 2009 11:39:38 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	wk <handygewinnspiel@gmx.de>, linux-media@vger.kernel.org
Subject: Re: V4L2 spec
In-Reply-To: <200903092047.16329.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903101135090.28292@shell2.speakeasy.net>
References: <200903061523.15766.hverkuil@xs4all.nl> <49B14D3C.3010001@gmx.de>
 <alpine.LRH.2.00.0903090803010.6607@caramujo.chehab.org>
 <200903092047.16329.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Mar 2009, Hans Verkuil wrote:
> On Monday 09 March 2009 12:08:39 Mauro Carvalho Chehab wrote:
> > On Fri, 6 Mar 2009, wk wrote:
> > > Hans Verkuil wrote:
> > >>  Hi Mauro,
> > >>
> > >>  I noticed that there is an ancient V4L2 spec in our tree in the
> > >> v4l/API directory. Is that spec used in any way? I don't think so, so
> > >> I suggest that it is removed.
> >
> > OK.
> >
> > >>  The V4L1 spec that is there should probably be moved to the v4l2-spec
> > >>  directory as that is where people would look for it. We can just keep
> > >> it there for reference.
> >
> > Nah. Let's just strip and point to some place where V4L1 doc is
> > available, adding some warning that the API is outdated and will be
> > removed from kernel soon.
>
> I don't think we should remove the doc from the repo until all drivers are
> converted to v4l2.

I think it would be useful to keep around.  Consider someone trying to
convert some old app or driver from v4l1 to v4l2.  It would be useful for
them to have the spec for v4l1 to know what the software was trying to do.

You could just point somewhere else, but things move, and that's another
link that will need to be kept up to date.  And there could be updates to
it, like common ways that v4l1 apps violate the spec that you need to deal
with when converting to v4l2.
