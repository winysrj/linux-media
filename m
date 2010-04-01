Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab0DAXKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 19:10:25 -0400
Message-ID: <4BB527D3.6030201@redhat.com>
Date: Thu, 01 Apr 2010 20:10:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>	 <4BB4B569.3080608@redhat.com>	 <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>	 <4BB4D9AB.6070907@redhat.com>	 <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>	 <4BB4E91B.9030508@redhat.com>	 <v2y829197381004011156ld4b30171s169a296bb682e638@mail.gmail.com>	 <4BB50B2F.9050207@redhat.com> <n2q829197381004011440kf2c12143i24fb570544551118@mail.gmail.com>
In-Reply-To: <n2q829197381004011440kf2c12143i24fb570544551118@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Thu, Apr 1, 2010 at 5:07 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>> Most i2c locks typically are only held for the duration of a single
>>> i2c transaction.  What you are proposing would likely result in just
>>> about every function having to explicitly lock/unlock, which just
>>> seems bound to be error prone.
>> The i2c open/close should be part of the transaction. Of course, there's no
>> need to send a command to open an already opened gate (yet, from some sniff
>> dumps, it seems that some drivers for other OS's do it for every single i2c
>> access).
> 
> I'm not even talking about i2c gate control, which is a whole separate
> case where it is applied inconsistently across drivers.  Even under
> Linux, we have lots of cases where there are double opens and double
> closes of the i2c gate, depending on whether the developer is
> controlling the gate from the tuner driver or the demodulator.
> 
> What I'm getting at though is that the lock granularity today is
> typically at the i2c transaction level, so something like an demod
> driver attempting to set two disparate registers is likely to be two
> i2c transactions.  Without moving the locking into the caller, the
> other half of the driver can take control between those two
> transactions.  And moving the logic into the caller means we will have
> to litter the code all over the place with lock/unlock calls.

I agree with a caller logic.

Yet, even moving to the caller, an i2c lock is still needed. For example, i2c IR
events are polling at interrupt time, so, they can happen anytime, including
in the middle of one i2c transaction (by transaction, I mean gate control+i2c
read/write ops go get/set a single register).

>>> We've got enough power management problems as it is without adding
>>> lots additional complexity with little benefit and only increasing the
>>> likelihood of buggy code.
>> For sure a lock at the open() is simple, but I suspect that this may
>> cause some troubles with applications that may just open everything
>> on startup (even letting the device unused). Just as one example of
>> such apps, kmix, pulseaudio and other alsa mixers love to keep the
>> mixer node opened, even if nobody is using it.
> 
> I'm frankly far less worried about the ALSA devices than I am about
> DVB versus V4L Vdeo/VBI, based on all the feedback I see from real
> users.

Ok, but alsa driver may also try to access things like i2c. For example,
msp34xx audio controls are reached via I2C.

> The cases where we are getting continuously burned are MythTV
> users who don't have their "input groups" properly defined and as a
> result MythTV attempts to use both digital and analog at the same time
> (input groups themselves are really a hack to deal with the fact that
> the Linux kernel doesn't have any way to inform userland of the
> relationships).
> 
> And the more I think about it, we can probably even implement the
> locking itself in the V4L and DVB core (further reducing the risk of
> some bridge maintainer screwing it up).  All the bridge driver would
> have to do is declare the relationship between the DVB and V4L devices
> (both video and vbi), and the enforcement of the locking could be
> abstracted out.

I agree on having some sort of resource locking in core, but this type
of lock between radio/audio/analog/analog mpeg-encoded/digital/vbi/...
is different than a mere mutex-type of locking from what we've discussed
so far. It has nothing to do with BKL.

-- 

Cheers,
Mauro
