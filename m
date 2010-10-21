Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:34660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab0JUC5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 22:57:39 -0400
Message-ID: <4CBFAC1A.90306@infradead.org>
Date: Thu, 21 Oct 2010 00:57:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: ext_lock (was viafb camera controller driver)
References: <20101010162313.5caa137f@bike.lwn.net>	<4CB9AC58.5020301@infradead.org>	<20101018212017.7c53789e@bike.lwn.net>	<201010190854.40419.hverkuil@xs4all.nl> <20101020132342.35a2c401@bike.lwn.net>
In-Reply-To: <20101020132342.35a2c401@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-10-2010 17:23, Jonathan Corbet escreveu:
> On Tue, 19 Oct 2010 08:54:40 +0200
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> We are working on removing the BKL. As part of that effort it is now possible
>> for drivers to pass a serialization mutex to the v4l core (a mutex pointer was
>> added to struct video_device). If the core sees that mutex then the core will
>> serialize all open/ioctl/read/write/etc. file ops. So all file ops will in that
>> case be called with that mutex held. Which is fine, but if the driver has to do
>> a blocking wait, then you need to unlock the mutex first and lock it again
>> afterwards. And since videobuf does a blocking wait it needs to know about that
>> mutex.
> 
> So videobuf is expecting that you're passing this special device mutex
> in particular?  In that case, why not just use it directly?  Having a
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

Yeah, a definitive solution would be to directly use the lock at videobuf. However,
people are re-writing videobuf (the new version is called videobuf2), in order
to fix some know issues on it.

Probably, it is better to wait for the new vb2, test it, and better integrate
its locking schema.

> In general, put me in the "leery of central locking" camp.  If you
> don't understand locking, you're going to mess things up somewhere
> along the way.  And, as soon as you get into hardware with interrupts,
> it seems like you have to deal with your own locking for access to the
> hardware regardless...

Yeah, if developers don't understand lock, a mess will happen, but this
doesn't matter if the developer is using a central or a driver-priv lock.

With a core-assisted lock, driver code is cleaner, and, hopefully, will be
easier to analyze the lock "exceptions", as the common case (hardware access
via file operations) will already be covered.

Cheers,
Mauro.
