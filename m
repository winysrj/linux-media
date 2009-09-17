Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZIQMAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 08:00:14 -0400
Date: Thu, 17 Sep 2009 08:59:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090917085935.34e02c99@pedra.chehab.org>
In-Reply-To: <200909170835.57106.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<200909162334.08807.hverkuil@xs4all.nl>
	<1253139323.3158.28.camel@palomino.walls.org>
	<200909170835.57106.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Sep 2009 08:35:57 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Thursday 17 September 2009 00:15:23 Andy Walls wrote:
> > On Wed, 2009-09-16 at 23:34 +0200, Hans Verkuil wrote:
> > > On Wednesday 16 September 2009 22:50:43 Mauro Carvalho Chehab wrote:
> > > > Em Wed, 16 Sep 2009 21:21:16 +0200
> > 
> > > C) in all other cases you only get it if a kernel config option is on. And since
> > > any advanced controls are still exposed in sysfs you can still change those even
> > > if the config option was off.
> > 
> > That is a user interface and support annoyance.  Either decide to have a
> > node for a subdevice or don't.  If a distribution wants to supress them,
> > udev rules could suffice - right?  Changing udev rules is
> > (theoretically) easier than rebuilding the kernel for most end users.
> 
> Good point.

I suspect that, in practice, the drivers will talk for themselves: e. g.
drivers that are used with embedded and that requires extra parameters for
tweaking will add some callback methods to indicate V4L2 core that they need
a /dev. Others will not implement those methods and won't have any /dev
associated.

Cheers,
Mauro
