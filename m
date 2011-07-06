Return-path: <mchehab@localhost>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:49706 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab1GFRxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 13:53:52 -0400
Message-ID: <4E14A127.8040805@kolumbus.fi>
Date: Wed, 06 Jul 2011 20:53:43 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>	<201106152237.02427.hverkuil@xs4all.nl>	<BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>	<201106160821.15352.hverkuil@xs4all.nl>	<4DF9E5AB.1050707@redhat.com> <BANLkTi=Wq=swMMBfK+X9gVQ0XhL4OSxXFA@mail.gmail.com>
In-Reply-To: <BANLkTi=Wq=swMMBfK+X9gVQ0XhL4OSxXFA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


Hi.

I think that you could reuse lots of code with smart suspend / resume.

What do you think about this DVB power saving case (about the concept, don't look at details, please):

- One device has responsibility to do the power off when it can be done (mantis_core.ko)
- In my case there is only one frontend tda10021.ko to take care of.

- dvb_frontend.c would call fe->sleep(fe). The callback goes into mantis_core.ko.
- mantis_core.ko will traverse all devices on it's responsibility, all (tda10021.ko) are idle.
=> suspend tda10021.ko by calling tda10021->sleep() and do additional power off things.

- When dvb_frontend.c wants tuner to be woken up,
  mantis_core.ko does hardware resets and power on first and then resumes tda10021->init(fe).

I implemented something that worked a few years ago with suspend / resume.
In mantis_dvb.c's driver probe function I modified tuner_ops to enable these runtime powersaving features:
+                       mantis->fe->ops.tuner_ops.sleep = mantis_dvb_tuner_sleep;
+                       mantis->fe->ops.tuner_ops.init = mantis_dvb_tuner_init;

That way mantis_core.ko had all needed details to do any advanced power savings I wanted.

Suspend / resume worked well: During resume there was only a glitch at the picture and sound
and the TV channel watching continued. tda10021 (was cu1216 at that time)
restored the original TV channel. It took DVB FE_LOCK during resume.
Suspended DMA transfer was recovered before returning into userspace.

So I think that you need a single device (mantis_core.ko) that can see the whole picture,
in what states the subdevices are: can you touch the power button?.
With DVB this is easy because dvb_frontend.c tells when a frontend is idle and when it is not.

The similar idea of some kind of watchdog that is able to track when a single 
device (frontend) is used and when it is not used, would be sufficient.

The topmost driver (mantis_core.ko in my case) would then be responsible to track multiple frontends
(subdevices), if they all are idle or not, with suitable mutex protection.
Then this driver could easilly suspend/resume these subdevices and press power switch when necessary.


So the clash between DVB and V4L devices would be solved:
Both DVB and V4L calls a (different) sleep() function on mantis_core.ko
mantis_core.ko will turn power off when both "frontends" are sleeping.
If only one sleeps, the one can be put to sleep or suspended, but power
button can't be touched.

What do you think?

I did this easy case mantis_core.ko solution in about Summer 2007.
It needs a rewrite and testing, if I take it from the dust.

Regards,
Marko Ristola

16.06.2011 15:51, Devin Heitmueller wrote:
> On Thu, Jun 16, 2011 at 7:14 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> One possible logic that would solve the scripting would be to use a watchdog
>> to monitor ioctl activities. If not used for a while, it could send a s_power
>> to put the device to sleep, but this may not solve all our problems.
>>
>> So, I agree with Devin: we need to add an option to explicitly control the
>> power management logic of the device, having 3 modes of operation:
>>        POWER_AUTO - use the watchdogs to poweroff
>>        POWER_ON - explicitly powers on whatever subdevices are needed in
>>                   order to make the V4L ready to stream;
>>        POWER_OFF - Put all subdevices to power-off if they support it.
>>
>> After implementing such logic, and keeping the default as POWER_ON, we may
>> announce that the default will change to POWER_AUTO, and give some time for
>> userspace apps/scripts that need to use a different mode to change their
>> behaviour. That means that, for example, "radio -qf" will need to change to
>> POWER_ON mode, and "radio -m" should call POWER_OFF.
> 
> I've considered this idea before, and it's not bad in theory.  The one
> thing you will definitely have to watch out for is causing a race
> between DVB and V4L for hybrid tuners.  In other words, you can have a
> user switching from analog to digital and you don't want the tuner to
> get powered down a few seconds after they started streaming video from
> DVB.
> 
> Any such solution would have to take the above into account.  We've
> got a history of race conditions like this and I definitely don't want
> to see a new one introduced.
> 
> Devin
> 

