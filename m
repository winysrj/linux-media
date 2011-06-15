Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35377 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1FOUtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 16:49:41 -0400
Received: by eyx24 with SMTP id 24so314359eyx.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 13:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106152237.02427.hverkuil@xs4all.nl>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
	<201106152155.57978.hverkuil@xs4all.nl>
	<BANLkTinx9Pa_Oe3qOfNgKZS3e82US6r8wg@mail.gmail.com>
	<201106152237.02427.hverkuil@xs4all.nl>
Date: Wed, 15 Jun 2011 16:49:39 -0400
Message-ID: <BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 15, 2011 at 4:37 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> But the driver has that information, so it should act accordingly.
>
> So on first open you can check whether the current input has a tuner and
> power on the tuner in that case. On S_INPUT you can also poweron/off accordingly
> (bit iffy against the spec, though). So in that case the first use case would
> actually work. It does require that tuner-core.c supports s_power(1), of course.

This will get messy, and is almost certain to get screwed up and cause
regressions at least on some devices.

> BTW, I noticed in tuner-core.c that the g_tuner op doesn't wake-up the tuner
> when called. I think it should be added, even though most (all?) tuners will
> need time before they can return anything sensible.

Bear in mind that some tuners can take several seconds to load
firmware when powered up.  You don't want a situation where the tuner
is reloading firmware continuously, the net result being that calls to
v4l2-ctl that used to take milliseconds now take multiple seconds.

> BTW2: it's not a good idea to just broadcast s_power to all subdevs. That should
> be done to the tuner(s) only since other subdevs might also implement s_power.
> For now it's pretty much just tuners and some sensors, though.
>
> You know, this really needs to be a standardized module option and/or sysfs
> entry: 'always on', 'wake up on first open', 'wake up on first use'.

That would definitely be useful, but it shouldn't be a module option
since you can have multiple devices using the same module.  It really
should be an addition to the V4L API.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
