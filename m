Return-path: <mchehab@localhost>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:40748 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1GGSg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 14:36:26 -0400
Message-ID: <4E15FCA0.6000404@kolumbus.fi>
Date: Thu, 07 Jul 2011 21:36:16 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>	<201106152237.02427.hverkuil@xs4all.nl>	<BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>	<201106160821.15352.hverkuil@xs4all.nl>	<4DF9E5AB.1050707@redhat.com>	<BANLkTi=Wq=swMMBfK+X9gVQ0XhL4OSxXFA@mail.gmail.com>	<4E14A127.8040805@kolumbus.fi> <CAGoCfiwjXYBR8FBYMS8BsBM20mCQLvWQbyhLh-psA_HX73SGjw@mail.gmail.com> <4E14BE93.2030205@kolumbus.fi> <4E15CD4E.1040507@redhat.com>
In-Reply-To: <4E15CD4E.1040507@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


Hi.

IMO, your thoughts about core resource locking mechanism sound good.
I say here some thoughts and examples how the resource locking mechanism might work.

IMHO, It's good enough now if we are heading to a solution.
At least I would not alone find a proper concept.

07.07.2011 18:14, Mauro Carvalho Chehab kirjoitti:
> Em 06-07-2011 16:59, Marko Ristola escreveu:
>> 06.07.2011 21:17, Devin Heitmueller kirjoitti:
>>> On Wed, Jul 6, 2011 at 1:53 PM, Marko Ristola <marko.ristola@kolumbus.fi> wrote:
>>>>
> 
> IMO, the proper solution is to provide a core resource locking mechanism, that will keep
> track about what device resources are in usage (tuner, analog audio/video demods, digital
> demods, sec, radio reception, i2c buses, etc), and some mechanisms like the above that will
> power the subdevice off when it is not being used for a given amount of time (a Kconfig option
> can be added so set the time to X minutes or to disable such mechanism, in order to preserve
> back compatibility).
> 

> One special case for the locking mechanisms that may or may not be covered by such core
> resource locking is the access to the I2C buses. Currently, the DVB, V4L and remote controller
> stacks may try to use resources behind I2C at the same time. The I2C core has a locking schema,
> but it works only if a transaction is atomically commanded. So, if it requires multiple I2C 
> transfers, all of them need to be grouped into one i2c xfer call. Complex operations like firmware
> transfers are protected by the I2C locking, so one driver might be generating RC polling events
> while a firmware is being transferring, causing it to fail.

A generic locking schema could have shared/exclusive locks by name (device name, pointer ?).
A generic resource "set of named locks" could contain these locks.

Firmware load would take an exclusive lock on "I2C master" for the whole transfer.
RC polling would take a shared lock on "I2C master" and an exclusive lock on "RC UART" device.
Or if there is no need to share I2C device, RC polling would just take exclusive lock on "I2C Master".

If I2C bus must be quiesced for 10ms after frontend's tuning action, "I2C master" exclusive lock
could be held 10ms after last I2C transfer. "i2c/bridge1" state should be protected if the frontend
is behind an I2C bridge.

The existing I2C xfer mutex would be as it is now: it is a lower level lock, no regressions to come.

Taking a shared lock of "tuner_power_switch" would mark that the device must not be turned off.
While holding the shared lock, no "deferred watch" would be needed.
While releasing "tuner_power_switch" lock, usage timestamp on that name should be updated.
If there are no more "tuner_power_switch" holders, "delayed task" could be activated and
run after 3 minutes to power the device off if needed.

Bridge drivers that don't have full runtime power saving support, would
not introduce a callback which a "delayed task" would run to turn power off / on.

> 
> Regards,
> Mauro

IMO, suspend / resume code must be a separate thing.

We might want to suspend the laptop while watching a DVB channel.
We don't want to have runtime power management active while watching a DVB channel.

Suspend quiesces the device possibly in one phase. It needs to have the device
in a good state before suspending: take an exclusive "I2C Master"
lock before going to suspend. While resuming, release "I2C Master" lock.

So even though these details are incomplete, suspend/resume could perhaps
be integrated with the generic advanced locking scheme.

Regards,
Marko
