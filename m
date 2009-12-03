Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753164AbZLCVmc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 16:42:32 -0500
Date: Thu, 3 Dec 2009 22:42:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Andy Walls <awalls@radix.net>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Replace Mercurial with GIT as SCM
In-Reply-To: <200912031012.41889.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0912032239550.4328@axis700.grange>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
 <1259709900.3102.3.camel@palomino.walls.org> <200912031012.41889.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 3 Dec 2009, Hans Verkuil wrote:

> On Wednesday 02 December 2009 04:55:00 Andy Walls wrote:
> > On Tue, 2009-12-01 at 15:59 +0100, Patrick Boettcher wrote:
> > > Hi all,
> > >
> > > I would like to start a discussion which ideally results in either
> > > changing the SCM of v4l-dvb to git _or_ leaving everything as it is today
> > > with mercurial.
> > >
> > >
> > > I'm waiting for comments.
> >
> > I only have one requirement: reduce bandwidth usage between the server
> > and my home.
> >
> > The less I have to clone out 65 M of history to start a new series of
> > patches the better.  I suppose that would include a rebase...
> 
> Unfortunately, one reason for moving to git would be to finally be able to 
> make changes to the arch directory tree. The fact that that part is 
> unavailable in v4l-dvb is a big problem when working with SoCs. And these will 
> become much more important in the near future.

FWIW, tomorrow (or a day or two later) I'll have to spend time again 
back-porting arch changes from git to hg, to be able to push my current 
patches...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
