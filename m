Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49239 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0DAS4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 14:56:21 -0400
Received: by bwz1 with SMTP id 1so1081315bwz.21
        for <linux-media@vger.kernel.org>; Thu, 01 Apr 2010 11:56:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB4E91B.9030508@redhat.com>
References: <201004011001.10500.hverkuil@xs4all.nl>
	 <201004011411.02344.laurent.pinchart@ideasonboard.com>
	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>
	 <4BB4B569.3080608@redhat.com>
	 <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>
	 <4BB4D9AB.6070907@redhat.com>
	 <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
	 <4BB4E91B.9030508@redhat.com>
Date: Thu, 1 Apr 2010 14:56:19 -0400
Message-ID: <v2y829197381004011156ld4b30171s169a296bb682e638@mail.gmail.com>
Subject: Re: V4L-DVB drivers and BKL
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 1, 2010 at 2:42 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> If the i2c lock was toggled to digital mode, then it means that the i2c
> code is being in use simultaneously by analog and digital mode. It also
> means that an i2c IR device, or alsa will have troubles also. So, we
> really need one i2c lock that will protect the access to the I2C bus as
> a hole, including the i2c gate.

Most i2c locks typically are only held for the duration of a single
i2c transaction.  What you are proposing would likely result in just
about every function having to explicitly lock/unlock, which just
seems bound to be error prone.

>> We would need to implement proper locking of analog versus digital mode,
>> which unfortunately would either result in hald getting back -EBUSY on open
>> of the V4L device or the DVB module loading being deferred while the
>> v4l side of the board is in use (neither of which is a very good
>> solution).
>
> Yes, this is also needed: we shouldn't let simultaneous stream access to the
> analog and digital mode at the same time, but I don't see, by itself, any problem
> on having both analog and digital nodes opened at the same time. So, the solution
> seems to lock some resources between digital/analog access.

I think this is probably a bad idea.  The additional granularity
provides you little benefit, and you could easily end up in situations
where power is being continuously being toggled on the decoder and
demodulator as ioctls come in from both analog and digital.  The
solution would probably not be too bad if you're only talking about
boards where everything is powered up all the time (like most of the
PCI boards), but this approach would be horrific for any board where
power management were a concern (e.g. USB devices).

A fairly simple locking scheme at open() would prevent essentially all
of race conditions, the change would only be in one or two places per
bridge (as opposed to littering the code with locking logic), and the
only constraint is that applications would have to be diligent in
closing the device when its not in use.

We've got enough power management problems as it is without adding
lots additional complexity with little benefit and only increasing the
likelihood of buggy code.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
