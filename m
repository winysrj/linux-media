Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3537 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0DAVL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 17:11:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: V4L-DVB drivers and BKL
Date: Thu, 1 Apr 2010 23:11:40 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <201004011001.10500.hverkuil@xs4all.nl> <4BB4E91B.9030508@redhat.com> <v2y829197381004011156ld4b30171s169a296bb682e638@mail.gmail.com>
In-Reply-To: <v2y829197381004011156ld4b30171s169a296bb682e638@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012311.40264.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 20:56:19 Devin Heitmueller wrote:
> On Thu, Apr 1, 2010 at 2:42 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > If the i2c lock was toggled to digital mode, then it means that the i2c
> > code is being in use simultaneously by analog and digital mode. It also
> > means that an i2c IR device, or alsa will have troubles also. So, we
> > really need one i2c lock that will protect the access to the I2C bus as
> > a hole, including the i2c gate.
> 
> Most i2c locks typically are only held for the duration of a single
> i2c transaction.  What you are proposing would likely result in just
> about every function having to explicitly lock/unlock, which just
> seems bound to be error prone.
> 
> >> We would need to implement proper locking of analog versus digital mode,
> >> which unfortunately would either result in hald getting back -EBUSY on open
> >> of the V4L device or the DVB module loading being deferred while the
> >> v4l side of the board is in use (neither of which is a very good
> >> solution).
> >
> > Yes, this is also needed: we shouldn't let simultaneous stream access to the
> > analog and digital mode at the same time, but I don't see, by itself, any problem
> > on having both analog and digital nodes opened at the same time. So, the solution
> > seems to lock some resources between digital/analog access.
> 
> I think this is probably a bad idea.  The additional granularity
> provides you little benefit, and you could easily end up in situations
> where power is being continuously being toggled on the decoder and
> demodulator as ioctls come in from both analog and digital.  The
> solution would probably not be too bad if you're only talking about
> boards where everything is powered up all the time (like most of the
> PCI boards), but this approach would be horrific for any board where
> power management were a concern (e.g. USB devices).
> 
> A fairly simple locking scheme at open() would prevent essentially all
> of race conditions, the change would only be in one or two places per
> bridge (as opposed to littering the code with locking logic), and the
> only constraint is that applications would have to be diligent in
> closing the device when its not in use.

I agree. The biggest problem with v4l-dvb devices is driver complexity. It
has never been performance. Reducing that complexity by moving some of that
into the core is a good thing in my view.

> We've got enough power management problems as it is without adding
> lots additional complexity with little benefit and only increasing the
> likelihood of buggy code.

Right.

	Hans

> 
> Devin
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
