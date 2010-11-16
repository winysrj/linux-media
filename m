Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab0KPQdC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 11:33:02 -0500
Message-ID: <4CE2B238.7000707@redhat.com>
Date: Tue, 16 Nov 2010 14:32:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
References: <cover.1289740431.git.hverkuil@xs4all.nl> <ccc5d34bc1daa662da4af75127256505.squirrel@webmail.xs4all.nl> <ebc68dfa756290569c3905a79175f65a.squirrel@webmail.xs4all.nl> <201011161701.36982.arnd@arndb.de>
In-Reply-To: <201011161701.36982.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-11-2010 14:01, Arnd Bergmann escreveu:
> On Tuesday 16 November 2010, Hans Verkuil wrote:
>>> I think there is a misunderstanding. One V4L device (e.g. a TV capture
>>> card, a webcam, etc.) has one v4l2_device struct. But it can have multiple
>>> V4L device nodes (/dev/video0, /dev/radio0, etc.), each represented by a
>>> struct video_device (and I really hope I can rename that to v4l2_devnode
>>> soon since that's a very confusing name).
>>>
>>> You typically need to serialize between all the device nodes belonging to
>>> the same video hardware. A mutex in struct video_device doesn't do that,
>>> that just serializes access to that single device node. But a mutex in
>>> v4l2_device is at the right level.
> 
> Ok, got it now.
> 
>> A quick follow-up as I saw I didn't fully answer your question: to my
>> knowledge there are no per-driver data structures that need a BKL for
>> protection. It's definitely not something I am worried about.
> 
> Good. Are you preparing a patch for a per-v4l2_device then? This sounds
> like the right place with your explanation. I would not put in the
> CONFIG_BKL switch, because I tried that for two other subsystems and got
> called back, but I'm not going to stop you.
> 
> As for the fallback to a global mutex, I guess you can set the
> videodev->lock pointer and use unlocked_ioctl for those drivers
> that do not use a v4l2_device yet, if there are only a handful of them.

Hans,

FYI, Linus already pull Arnd patch that removed BKL on -rc2 (commit 
0edf2e5e2bd0ae7689ce8a57ae3c87cc1f0c6548). I've pulled back from -rc2 into
linux-media.git tree. So, the patch is now visible on our main tree.

Cheers,
Mauro
