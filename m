Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0DAVIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 17:08:07 -0400
Message-ID: <4BB50B2F.9050207@redhat.com>
Date: Thu, 01 Apr 2010 18:07:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>	 <201004011411.02344.laurent.pinchart@ideasonboard.com>	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>	 <4BB4B569.3080608@redhat.com>	 <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>	 <4BB4D9AB.6070907@redhat.com>	 <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>	 <4BB4E91B.9030508@redhat.com> <v2y829197381004011156ld4b30171s169a296bb682e638@mail.gmail.com>
In-Reply-To: <v2y829197381004011156ld4b30171s169a296bb682e638@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Thu, Apr 1, 2010 at 2:42 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> If the i2c lock was toggled to digital mode, then it means that the i2c
>> code is being in use simultaneously by analog and digital mode. It also
>> means that an i2c IR device, or alsa will have troubles also. So, we
>> really need one i2c lock that will protect the access to the I2C bus as
>> a hole, including the i2c gate.
> 
> Most i2c locks typically are only held for the duration of a single
> i2c transaction.  What you are proposing would likely result in just
> about every function having to explicitly lock/unlock, which just
> seems bound to be error prone.

The i2c open/close should be part of the transaction. Of course, there's no
need to send a command to open an already opened gate (yet, from some sniff
dumps, it seems that some drivers for other OS's do it for every single i2c
access).

>>> We would need to implement proper locking of analog versus digital mode,
>>> which unfortunately would either result in hald getting back -EBUSY on open
>>> of the V4L device or the DVB module loading being deferred while the
>>> v4l side of the board is in use (neither of which is a very good
>>> solution).
>> Yes, this is also needed: we shouldn't let simultaneous stream access to the
>> analog and digital mode at the same time, but I don't see, by itself, any problem
>> on having both analog and digital nodes opened at the same time. So, the solution
>> seems to lock some resources between digital/analog access.
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
> 
> We've got enough power management problems as it is without adding
> lots additional complexity with little benefit and only increasing the
> likelihood of buggy code.

For sure a lock at the open() is simple, but I suspect that this may
cause some troubles with applications that may just open everything
on startup (even letting the device unused). Just as one example of
such apps, kmix, pulseaudio and other alsa mixers love to keep the
mixer node opened, even if nobody is using it.

-- 

Cheers,
Mauro
