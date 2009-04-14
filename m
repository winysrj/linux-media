Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZDNMMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 08:12:44 -0400
Date: Tue, 14 Apr 2009 09:12:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: vasaka@gmail.com
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [REVIEW] v4l2 loopback
Message-ID: <20090414091233.3ea2f6e4@pedra.chehab.org>
In-Reply-To: <36c518800904131808m67482f2ex54307dfab91ccdf0@mail.gmail.com>
References: <200903262049.10425.vasily@scopicsoftware.com>
	<200904131317.01731.hverkuil@xs4all.nl>
	<36c518800904131808m67482f2ex54307dfab91ccdf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 14 Apr 2009 04:08:41 +0300
vasaka@gmail.com wrote:

> On Mon, Apr 13, 2009 at 2:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Thursday 26 March 2009 19:49:10 Vasily wrote:
> >> Hello, please review the new version of v4l2 loopback driver.
> >> I fixed up comments to the previous submission, waiting for the new ones
> >> :-), reposting for patchwork tool
> >>
> >> ---
> >> This patch introduces v4l2 loopback module
> >>
> >> From: Vasily Levin <vasaka@gmail.com>
> >>
> >> This is v4l2 loopback driver which can be used to make available any
> >> userspace video as v4l2 device. Initialy it was written to make
> >> videoeffects available to Skype, but in fact it have many more uses.
> >
> > Hi Vasily,
> >
> > It's still on my todo list, but I have had very little time. If you still
> > haven't seen a review in two weeks time, then please send me a reminder.
> >
> > Sorry about this, normally I review things like this much sooner but it has
> > been very hectic lately.
> >
> > Regards,
> >
> >        Hans
> 
> Hi Hans,
> 
> Thanks for updating, driver is still waiting for review, I am glad to
> here that it is on a todo list :-)

Vasily,

It is on my todo list. I've postponed it since it is valuable to have some
discussions about this driver.

The issue I see is that the V4L drivers are meant to support real devices. This
driver that is a loopback for some userspace driver. I don't discuss its value
for testing purposes or other random usage, but I can't see why this should be
at upstream kernel.

So, I'm considering to add it at v4l-dvb tree, but as an out-of-tree driver
only. For this to happen, probably, we'll need a few adjustments at v4l build.

Cheers,
Mauro
