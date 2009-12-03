Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1714 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZLCEoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 23:44:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Replace Mercurial with GIT as SCM
Date: Thu, 3 Dec 2009 10:12:41 +0530
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de> <1259709900.3102.3.camel@palomino.walls.org>
In-Reply-To: <1259709900.3102.3.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912031012.41889.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 02 December 2009 04:55:00 Andy Walls wrote:
> On Tue, 2009-12-01 at 15:59 +0100, Patrick Boettcher wrote:
> > Hi all,
> >
> > I would like to start a discussion which ideally results in either
> > changing the SCM of v4l-dvb to git _or_ leaving everything as it is today
> > with mercurial.
> >
> >
> > I'm waiting for comments.
>
> I only have one requirement: reduce bandwidth usage between the server
> and my home.
>
> The less I have to clone out 65 M of history to start a new series of
> patches the better.  I suppose that would include a rebase...

Unfortunately, one reason for moving to git would be to finally be able to 
make changes to the arch directory tree. The fact that that part is 
unavailable in v4l-dvb is a big problem when working with SoCs. And these will 
become much more important in the near future.

Regards,

	Hans

>
> Regards,
> Andy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

