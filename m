Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:37080 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab1FHLGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 07:06:22 -0400
Date: Wed, 8 Jun 2011 14:06:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [GIT PATCHES FOR 2.6.41] Add bitmask controls
Message-ID: <20110608110617.GG7830@valkosipuli.localdomain>
References: <201105231315.29328.hverkuil@xs4all.nl>
 <4DE636C5.7040604@redhat.com>
 <ef656b6325ca0b3c65337f7480f834f0.squirrel@webmail.xs4all.nl>
 <4DE64181.6050007@redhat.com>
 <20110605132802.GH6073@valkosipuli.localdomain>
 <20110608105432.GE7830@valkosipuli.localdomain>
 <bd38b77550d2297147f86defb0caa4f4.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd38b77550d2297147f86defb0caa4f4.squirrel@webmail.xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 08, 2011 at 01:04:05PM +0200, Hans Verkuil wrote:
> > On Sun, Jun 05, 2011 at 04:28:03PM +0300, Sakari Ailus wrote:
> >> On Wed, Jun 01, 2011 at 10:41:21AM -0300, Mauro Carvalho Chehab wrote:
> >> > > There are currently two use cases: Sakari's flash controller needs
> >> to
> >> > > report errors which are a bitmask of possible error conditions. It
> >> is way
> >> > > overkill to split that up in separate boolean controls, especially
> >> since
> >> > > apps will also want to get an event whenever such an error is
> >> raised.
> >> >
> >> > Hmm... returning errors via V4L2 controls don't seem to be a good
> >> implementation.
> >> > I need to review his RFC to better understand his idea.
> >>
> >> The "errors" are not errors in the traditional meaning --- they also are
> >> called faults. They signal that there's either a temporary or a
> >> permanent
> >> hardware problem with the flash controller. The user will be able to
> >> mitigate with many of these. Also the faults do arrive asynchronously,
> >> making traditional error handling unsuitable for them. For example, the
> >> LED
> >> controller may overheat in some situations which cause immediate LED
> >> shutdown, leading to only partially flash exposed frame. When this
> >> happens
> >> the user has to be notified of the condition, and to avoid reading a
> >> large
> >> set of controls, a single bitmask control telling directly the reason
> >> for
> >> the trouble is ideal.
> >>
> >> The full RFC may be found here:
> >>
> >> <USR:http://www.spinics.net/lists/linux-media/msg32030.html>
> >
> > That was supposed to be
> >
> > <URL:http://www.spinics.net/lists/linux-media/msg32030.html>
> >
> > The adp1653 flash controller driver using the flash API. The patches have
> > been acked by Laurent already.
> 
> Sakari, I think it is best if you combine that driver with my bitmask
> patch series and have it pulled as a whole.

Right; I'll do that.

Thanks.

-- 
Sakari Ailus
sakari.ailus@iki.fi
