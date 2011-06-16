Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3112 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1FPGVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 02:21:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
Date: Thu, 16 Jun 2011 08:21:15 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl> <201106152237.02427.hverkuil@xs4all.nl> <BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>
In-Reply-To: <BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106160821.15352.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 15, 2011 22:49:39 Devin Heitmueller wrote:
> On Wed, Jun 15, 2011 at 4:37 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > But the driver has that information, so it should act accordingly.
> >
> > So on first open you can check whether the current input has a tuner and
> > power on the tuner in that case. On S_INPUT you can also poweron/off accordingly
> > (bit iffy against the spec, though). So in that case the first use case would
> > actually work. It does require that tuner-core.c supports s_power(1), of course.
> 
> This will get messy, and is almost certain to get screwed up and cause
> regressions at least on some devices.

I don't see why this should be messy. Anyway, this is all theoretical as long
as tuner-core doesn't support s_power(1). Let's get that in first.

> > BTW, I noticed in tuner-core.c that the g_tuner op doesn't wake-up the tuner
> > when called. I think it should be added, even though most (all?) tuners will
> > need time before they can return anything sensible.
> 
> Bear in mind that some tuners can take several seconds to load
> firmware when powered up.  You don't want a situation where the tuner
> is reloading firmware continuously, the net result being that calls to
> v4l2-ctl that used to take milliseconds now take multiple seconds.

Yes, but calling VIDIOC_G_TUNER is a good time to wake up the tuner :-)

> > BTW2: it's not a good idea to just broadcast s_power to all subdevs. That should
> > be done to the tuner(s) only since other subdevs might also implement s_power.
> > For now it's pretty much just tuners and some sensors, though.
> >
> > You know, this really needs to be a standardized module option and/or sysfs
> > entry: 'always on', 'wake up on first open', 'wake up on first use'.
> 
> That would definitely be useful, but it shouldn't be a module option
> since you can have multiple devices using the same module.

Of course, I forgot about that.

> It really
> should be an addition to the V4L API.

This would actually for once be a good use of sysfs.

Regards,

	Hans
