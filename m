Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0DASmn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 14:42:43 -0400
Message-ID: <4BB4E91B.9030508@redhat.com>
Date: Thu, 01 Apr 2010 15:42:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>	 <201004011411.02344.laurent.pinchart@ideasonboard.com>	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>	 <4BB4B569.3080608@redhat.com>	 <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>	 <4BB4D9AB.6070907@redhat.com> <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
In-Reply-To: <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Thu, Apr 1, 2010 at 1:36 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> If you take a look at em28xx-dvb, it is not lock-protected. If the bug is due
>> to the async load, we'll need to add the same locking at *alsa and *dvb
>> parts of em28xx.
> 
> Yes, that is correct.  The problem effects both dvb and alsa, although
> empirically it is more visible with the dvb case.

In the case of the initialization, the lock is needed, even if we fing a
way to load the module synchronously.

> 
>> Yet, in this specific case, as the errors are due to the reception of
>> wrong data from tvp5150, maybe the problem is due to the lack of a
>> proper lock at the i2c access.
> 
> The problem is because hald sees the new device and is making v4l2
> calls against the tvp5150 even though the gpio has been toggled over
> to digital mode.  Hence an i2c lock won't help. 

If the i2c lock was toggled to digital mode, then it means that the i2c
code is being in use simultaneously by analog and digital mode. It also
means that an i2c IR device, or alsa will have troubles also. So, we
really need one i2c lock that will protect the access to the I2C bus as
a hole, including the i2c gate.

> We would need to implement proper locking of analog versus digital mode, 
> which unfortunately would either result in hald getting back -EBUSY on open
> of the V4L device or the DVB module loading being deferred while the
> v4l side of the board is in use (neither of which is a very good
> solution).

Yes, this is also needed: we shouldn't let simultaneous stream access to the
analog and digital mode at the same time, but I don't see, by itself, any problem
on having both analog and digital nodes opened at the same time. So, the solution
seems to lock some resources between digital/analog access.
 
> This is what got me thinking a few weeks ago that perhaps the
> submodules should not be loaded asynchronously.  In that case, at
> least the main em28xx module could continue to hold the lock while the
> submodules are still being loaded.
> 
> Devin
> 


-- 

Cheers,
Mauro
