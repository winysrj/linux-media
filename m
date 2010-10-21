Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4277 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0JUGvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 02:51:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: ext_lock (was viafb camera controller driver)
Date: Thu, 21 Oct 2010 08:51:22 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
References: <20101010162313.5caa137f@bike.lwn.net> <201010190854.40419.hverkuil@xs4all.nl> <20101020132342.35a2c401@bike.lwn.net>
In-Reply-To: <20101020132342.35a2c401@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010210851.22252.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, October 20, 2010 21:23:42 Jonathan Corbet wrote:
> On Tue, 19 Oct 2010 08:54:40 +0200
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > We are working on removing the BKL. As part of that effort it is now possible
> > for drivers to pass a serialization mutex to the v4l core (a mutex pointer was
> > added to struct video_device). If the core sees that mutex then the core will
> > serialize all open/ioctl/read/write/etc. file ops. So all file ops will in that
> > case be called with that mutex held. Which is fine, but if the driver has to do
> > a blocking wait, then you need to unlock the mutex first and lock it again
> > afterwards. And since videobuf does a blocking wait it needs to know about that
> > mutex.
> 
> So videobuf is expecting that you're passing this special device mutex
> in particular?  In that case, why not just use it directly?

The problem is that videobuf has to cater for two possible scenarios regarding
external locks: either it is the core lock which can be obtained through struct
video_device, or it is a driver-owned lock. In both cases videobuf has to unlock
before the wait.

So I can't just give it a pointer to video_device.

For the next kernel cycle we should start the work to convert drivers to
unlocked_ioctl and the core lock or a private lock. Hopefully that will give us
a better idea of how this can be improved.

> Having a
> separate pointer to (what looks like) a distinct lock seems like a way
> to cause fatal confusion.  Given the tightness of the rules here (you
> *must* know that this "ext_lock" has been grabbed by the v4l core in the
> current call chain or you cannot possibly unlock it safely), I don't
> get why you wouldn't use the lock directly.
> 
> I would be inclined to go even further and emit a warning if the mutex
> is *not* locked.  It seems that the rules would require it, no?  If
> mutex debugging is turned on, you could even check if the current task
> is the locker, would would be even better.

I agree with this. Mauro, I propose this change:

BUG_ON(q->ext_lock && !mutex_is_locked(q->ext_lock));

if (q->ext_lock)
	mutex_unlock(q->ext_lock);
...
if (q->ext_lock)
	mutex_lock(q->ext_lock);

It makes no sense to provide an external lock and not having it locked here.

> In general, put me in the "leery of central locking" camp.  If you
> don't understand locking, you're going to mess things up somewhere
> along the way.  And, as soon as you get into hardware with interrupts,
> it seems like you have to deal with your own locking for access to the
> hardware regardless...

Do you want to tackle the task of fixing all the old BKL drivers? That is
still the primary motivation for doing this, you know. I really don't
fancy putting manual locking in those drivers and auditing them all.

BTW, I want to add another reason why core-assisted locking is a good idea
for many drivers: the chances of hitting a race condition if the locking
isn't quite right are exceedingly low for v4l drivers. In general there is
just a single application that opens the device, streams and closes it again.
It is very rare for, say two apps to open the device at almost the same time,
or one closing it and another opening it. Or for two apps calling an ioctl at
the same time.

So things may seem to work just dandy, even though a driver contains more
races than you can shake a stick at.

Given the fact that a considerable amount of work went into verifying that the
v4l2 core does locking right (and I'm talking not just about the new core locking
feature, but also about the locks protecting internal core data structures), and
that it usually took several tries to get it right, I am not at all confident
that the same wouldn't happen on a much larger scale in all the drivers. Particularly
if it is a hot-pluggable driver.

Anyway, driver developers are completely free to choose either core-assisted
locking or manual locking. But for the BKL conversion core-assisted locking is
the only way if we want to have any hope of finishing that conversion in a
reasonable amount of time and with a reasonable degree of confidence in the
correctness of the locking.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
