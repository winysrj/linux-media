Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:55594 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0JTTXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 15:23:44 -0400
Date: Wed, 20 Oct 2010 13:23:42 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: ext_lock (was viafb camera controller driver)
Message-ID: <20101020132342.35a2c401@bike.lwn.net>
In-Reply-To: <201010190854.40419.hverkuil@xs4all.nl>
References: <20101010162313.5caa137f@bike.lwn.net>
	<4CB9AC58.5020301@infradead.org>
	<20101018212017.7c53789e@bike.lwn.net>
	<201010190854.40419.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 19 Oct 2010 08:54:40 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> We are working on removing the BKL. As part of that effort it is now possible
> for drivers to pass a serialization mutex to the v4l core (a mutex pointer was
> added to struct video_device). If the core sees that mutex then the core will
> serialize all open/ioctl/read/write/etc. file ops. So all file ops will in that
> case be called with that mutex held. Which is fine, but if the driver has to do
> a blocking wait, then you need to unlock the mutex first and lock it again
> afterwards. And since videobuf does a blocking wait it needs to know about that
> mutex.

So videobuf is expecting that you're passing this special device mutex
in particular?  In that case, why not just use it directly?  Having a
separate pointer to (what looks like) a distinct lock seems like a way
to cause fatal confusion.  Given the tightness of the rules here (you
*must* know that this "ext_lock" has been grabbed by the v4l core in the
current call chain or you cannot possibly unlock it safely), I don't
get why you wouldn't use the lock directly.

I would be inclined to go even further and emit a warning if the mutex
is *not* locked.  It seems that the rules would require it, no?  If
mutex debugging is turned on, you could even check if the current task
is the locker, would would be even better.

In general, put me in the "leery of central locking" camp.  If you
don't understand locking, you're going to mess things up somewhere
along the way.  And, as soon as you get into hardware with interrupts,
it seems like you have to deal with your own locking for access to the
hardware regardless...

Thanks,

jon

