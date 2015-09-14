Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35944 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbbINKCH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 06:02:07 -0400
Date: Mon, 14 Sep 2015 07:02:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Time for a v4l-utils 1.8.0 release
Message-ID: <20150914070201.39302d8c@recife.lan>
In-Reply-To: <55F67483.4030709@googlemail.com>
References: <55491541.1040709@googlemail.com>
	<20150505172235.4bef50eb@recife.lan>
	<55F67483.4030709@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Mon, 14 Sep 2015 09:17:23 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> On 05/05/15 22:22, Mauro Carvalho Chehab wrote:
> > Em Tue, 05 May 2015 21:08:49 +0200
> > Gregor Jasny <gjasny@googlemail.com> escreveu:
> >
> >> Hello,
> >>
> >> It's already more than half a year since the last v4l-utils release. Do
> >> you have any pending commits or objections? If no one vetos I'd like to
> >> release this weekend.
> >
> > There is are a additions I'd like to add to v4l-utils:
> >
> > 1) on DVB, ioctls may fail with -EAGAIN. Some parts of the libdvbv5 don't
> > handle it well. I made one quick hack for it, but didn't have time to
> > add a timeout to avoid an endless loop. The patch is simple. I just need
> > some time to do that;
> >
> > 2) The Media Controller control util (media-ctl) doesn't support DVB.
> >
> > The patchset adding DVB support on media-ctl is ready, and I'm merging
> > right now, and matches what's there at Kernel version 4.1-rc1 and upper.
> >
> > Yet, Laurent and Sakari want to do some changes at the Kernel API, before
> > setting it into a stone at Kernel v 4.1 release.
> >
> > This has to happen on the next 4 weeks.
> >
> > So, I suggest to postpone the release of 1.8.0 until the end of this month.
> 
> I'd like to release v4l-utils 1.8.0 during the upcoming weekend. Please 
> postpone any disruptive fixes until the release has been tagged.

OK.

There was one patch there adding support for DVB at the Media Controller
part based on the old approach. As we decided to use a different
approach ("MC next generation"), I reverted the change, as we won't
want that change to go to the distros. It is not actually a big deal,
as there's no released Kernel using the old approach, and the code in
question is only triggered by certain types of defines that will never
be found. Yet, I prefer not having an API support on a non-development
branch for something that will never be mainstream.

Besides of such change, I think the remaining stuff there are OK for
a new release.

After the release of 1.8.x, I'll likely be merging a test application
to allow checking the new API on the next development branch, at
contrib/test.

Regards,
Mauro
