Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1FPLPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 07:15:00 -0400
Message-ID: <4DF9E5AB.1050707@redhat.com>
Date: Thu, 16 Jun 2011 08:14:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl> <201106152237.02427.hverkuil@xs4all.nl> <BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com> <201106160821.15352.hverkuil@xs4all.nl>
In-Reply-To: <201106160821.15352.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-06-2011 03:21, Hans Verkuil escreveu:
> On Wednesday, June 15, 2011 22:49:39 Devin Heitmueller wrote:
>> On Wed, Jun 15, 2011 at 4:37 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> But the driver has that information, so it should act accordingly.
>>>
>>> So on first open you can check whether the current input has a tuner and
>>> power on the tuner in that case. On S_INPUT you can also poweron/off accordingly
>>> (bit iffy against the spec, though). So in that case the first use case would
>>> actually work. It does require that tuner-core.c supports s_power(1), of course.
>>
>> This will get messy, and is almost certain to get screwed up and cause
>> regressions at least on some devices.
> 
> I don't see why this should be messy. Anyway, this is all theoretical as long
> as tuner-core doesn't support s_power(1). Let's get that in first.

Adding s_power to tuner-core is the easiest part. The hardest one is to decide
what would be the proper behaviour. See bellow.

>>> BTW, I noticed in tuner-core.c that the g_tuner op doesn't wake-up the tuner
>>> when called. I think it should be added, even though most (all?) tuners will
>>> need time before they can return anything sensible.
>>
>> Bear in mind that some tuners can take several seconds to load
>> firmware when powered up.  You don't want a situation where the tuner
>> is reloading firmware continuously, the net result being that calls to
>> v4l2-ctl that used to take milliseconds now take multiple seconds.

The question is not when to wake up the tuner, but when to put it to sleep.
Really, the big issue is on USB devices, where we don't want to spend lots
of power while the device is not active. Some devices even become hot when
the tuner is not sleeping. As Devin pointed, some devices like tm6000 take
about 30-45 seconds for loading a firmware (ok, it is a broken design. We should
not take it as a good example).

Currently, there's no way to know when a radio device is being used or not.
Even for video, scripts that call v4l-ctl or v4l2-ctl and then start some
userspace application are there for years. We have even an example for
that at the v4l-utils: contrib/v4l_rec.pl.

One possible logic that would solve the scripting would be to use a watchdog
to monitor ioctl activities. If not used for a while, it could send a s_power
to put the device to sleep, but this may not solve all our problems.

So, I agree with Devin: we need to add an option to explicitly control the
power management logic of the device, having 3 modes of operation:
	POWER_AUTO - use the watchdogs to poweroff
	POWER_ON - explicitly powers on whatever subdevices are needed in
		   order to make the V4L ready to stream;
	POWER_OFF - Put all subdevices to power-off if they support it.

After implementing such logic, and keeping the default as POWER_ON, we may
announce that the default will change to POWER_AUTO, and give some time for
userspace apps/scripts that need to use a different mode to change their
behaviour. That means that, for example, "radio -qf" will need to change to
POWER_ON mode, and "radio -m" should call POWER_OFF.

It would be good if the API would also provide a way to warn userspace that
a given device supports it or not (maybe at VIDIOC_QUERYCTL?).

I think that such API can be implemented as a new V4L control.

> Yes, but calling VIDIOC_G_TUNER is a good time to wake up the tuner :-)

Not really. Several popular devices load firmware based on the standard (the ones based
on xc2028/xc3028/xc4000). So, before sending any tuner command, a VIDIOC_S_STD is needed.

>>> BTW2: it's not a good idea to just broadcast s_power to all subdevs. That should
>>> be done to the tuner(s) only since other subdevs might also implement s_power.
>>> For now it's pretty much just tuners and some sensors, though.
>>>
>>> You know, this really needs to be a standardized module option and/or sysfs
>>> entry: 'always on', 'wake up on first open', 'wake up on first use'.
>>
>> That would definitely be useful, but it shouldn't be a module option
>> since you can have multiple devices using the same module.
> 
> Of course, I forgot about that.
> 
>> It really
>> should be an addition to the V4L API.
> 
> This would actually for once be a good use of sysfs.
> 
> Regards,
> 
> 	Hans

