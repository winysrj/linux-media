Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:56734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab0KPQAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 11:00:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Tue, 16 Nov 2010 17:01:36 +0100
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <cover.1289740431.git.hverkuil@xs4all.nl> <ccc5d34bc1daa662da4af75127256505.squirrel@webmail.xs4all.nl> <ebc68dfa756290569c3905a79175f65a.squirrel@webmail.xs4all.nl>
In-Reply-To: <ebc68dfa756290569c3905a79175f65a.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161701.36982.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 16 November 2010, Hans Verkuil wrote:
> > I think there is a misunderstanding. One V4L device (e.g. a TV capture
> > card, a webcam, etc.) has one v4l2_device struct. But it can have multiple
> > V4L device nodes (/dev/video0, /dev/radio0, etc.), each represented by a
> > struct video_device (and I really hope I can rename that to v4l2_devnode
> > soon since that's a very confusing name).
> >
> > You typically need to serialize between all the device nodes belonging to
> > the same video hardware. A mutex in struct video_device doesn't do that,
> > that just serializes access to that single device node. But a mutex in
> > v4l2_device is at the right level.

Ok, got it now.

> A quick follow-up as I saw I didn't fully answer your question: to my
> knowledge there are no per-driver data structures that need a BKL for
> protection. It's definitely not something I am worried about.

Good. Are you preparing a patch for a per-v4l2_device then? This sounds
like the right place with your explanation. I would not put in the
CONFIG_BKL switch, because I tried that for two other subsystems and got
called back, but I'm not going to stop you.

As for the fallback to a global mutex, I guess you can set the
videodev->lock pointer and use unlocked_ioctl for those drivers
that do not use a v4l2_device yet, if there are only a handful of them.

	Arnd
