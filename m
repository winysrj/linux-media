Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:54265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1GGPOd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2011 11:14:33 -0400
Message-ID: <4E15CD4E.1040507@redhat.com>
Date: Thu, 07 Jul 2011 12:14:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>	<201106152237.02427.hverkuil@xs4all.nl>	<BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>	<201106160821.15352.hverkuil@xs4all.nl>	<4DF9E5AB.1050707@redhat.com>	<BANLkTi=Wq=swMMBfK+X9gVQ0XhL4OSxXFA@mail.gmail.com>	<4E14A127.8040805@kolumbus.fi> <CAGoCfiwjXYBR8FBYMS8BsBM20mCQLvWQbyhLh-psA_HX73SGjw@mail.gmail.com> <4E14BE93.2030205@kolumbus.fi>
In-Reply-To: <4E14BE93.2030205@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Em 06-07-2011 16:59, Marko Ristola escreveu:
> 06.07.2011 21:17, Devin Heitmueller kirjoitti:
>> On Wed, Jul 6, 2011 at 1:53 PM, Marko Ristola <marko.ristola@kolumbus.fi> wrote:
>>>
>>
>> All that said, I believe that you are correct in that the business
>> logic needs to ultimately be decided by the bridge driver, rather than
>> having the dvb/tuner core blindly calling the sleep routines against
>> the tuner and demod drivers without a full understanding of what
>> impact it has on the board as a whole.
> 
> You wrote it nicely and compactly.
> 
> What do you think about tracking coarse last busy time rather than figuring out accurate idle time?
> 
> dvb_frontend.c and V4L side would just poll the device:
> "bridge->wake()". wake() will just store current "busy" timestamp to the bridge device
> with coarse accuracy, if subdevices are already at active state.
> If subdevices are powered off, it will first power them on and resume them, and then store "busy" timestamp.
> 
> Bridge device would have a "delayed task": "Check after 3 minutes: If I haven't been busy
> for three minutes, I'll go to sleep. I'll suspend the subdevices and power them off."
> 
> The "delayed task" would refresh itself: check again after last awake time + 3 minutes.
> 
> "Delayed task" could be further developed to support multiple suspend states.

There is still an issue: Devices that support FM radio may stay closed, but with radio
powered on. This is supported since the beginning by radio application (part of xawtv package).

If the device is on radio mode, the only reliable way to power the device off is if the
device is muted.

IMO, the proper solution is to provide a core resource locking mechanism, that will keep
track about what device resources are in usage (tuner, analog audio/video demods, digital
demods, sec, radio reception, i2c buses, etc), and some mechanisms like the above that will
power the subdevice off when it is not being used for a given amount of time (a Kconfig option
can be added so set the time to X minutes or to disable such mechanism, in order to preserve
back compatibility).

Having a core mechanism helps to assure that it will be properly implemented on all places.

This locking mechanism will be controlled by the bridge driver.

It is easy to say, but it may be hard to implement, as it may require some changes at both the
V4L/DVB core and at the drivers. 


One special case for the locking mechanisms that may or may not be covered by such core
resource locking is the access to the I2C buses. Currently, the DVB, V4L and remote controller
stacks may try to use resources behind I2C at the same time. The I2C core has a locking schema,
but it works only if a transaction is atomically commanded. So, if it requires multiple I2C 
transfers, all of them need to be grouped into one i2c xfer call. Complex operations like firmware
transfers are protected by the I2C locking, so one driver might be generating RC polling events
while a firmware is being transferring, causing it to fail.

Regards,
Mauro
