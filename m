Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:35128 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3JOTDi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 15:03:38 -0400
Message-ID: <525D9185.4000305@gmail.com>
Date: Tue, 15 Oct 2013 21:03:33 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	milo kim <milo.kim@ti.com>, media-workshop@linuxtv.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Thierry Reding <thierry.reding@gmail.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-pwm@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] V2: Agenda for the Edinburgh mini-summit
References: <201309101134.32883.hansverk@cisco.com> <3335821.8epFKWiJXY@avalon> <CAK5ve-JHEaNrNiYwdMdEiEsD0LnqHG-MEAQv4D-962fYK0=g4A@mail.gmail.com> <2523390.YEHU3IBNqR@avalon> <CAK5ve-+N=GyNk-ryR0LbiUcT0TErFTwK60-vHNEf7112dNyh_A@mail.gmail.com>
In-Reply-To: <CAK5ve-+N=GyNk-ryR0LbiUcT0TErFTwK60-vHNEf7112dNyh_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/15/2013 08:37 PM, Bryan Wu wrote:
> On Fri, Oct 11, 2013 at 12:38 AM, Laurent Pinchart
>> > <laurent.pinchart@ideasonboard.com>  wrote:
[...]
>> >  The biggest reason why we're not fond of sysfs-based APIs for media devices is
>> >  that they can't provide atomicity. There's no way to set multiple parameters
>> >  in a single operation.

I wonder what are your concerns WRT atomicity about usage of flash 
devices in
camera subsystems ? Is atomicity really so important here ? I don't 
disagree with
this argument, but I'm curious if you had any specific use cases in mind ?

>> >  We can't get rid of the sysfs LEDs API, but maybe we could have a unified
>> >  kernel LED/flash subsystem that would provide both a sysfs-based API to ensure

One of my original concerns were that same chip (often a multi-function 
device)
can be used as a camera Flash or an ordinary LED indicator. It depends 
on physical
system a chip is deployed, LED current configured, etc. So it appears 
bad from
design POV to have different drivers for different purposes of same device.

I believe led API should be a lower level layer, so each LED can be used as
a simple indicator.

>> >  compatibility with current userspace software and an ioctl-based API (possibly
>> >  through V4L2 controls). That way LED/flash devices would be registered with a
>> >  single subsystem, and the corresponding drivers won't have to care about the
>> >  API exposed to userspace. That would require a major refactoring of the in-
>> >  kernel APIs though.
>> >
>
> I agree this. I'm thinking about expanding the ledtrig-camera.c
> created by Milo Kim. This trigger will provide flashing and strobing
> control of a LED device and for sure the LED device driver like
> drivers/leds/leds-lm355x.c.
>
> So we basically can do this:
> 1. add V4L2 Flash subdev into ledtrig-camera.c. So this trigger driver
> can provide trigger API to kernel drivers as well as V4L2 Flash API to
> userspace.

That sounds reasonable to me, I guess this could be a kernel config option,
so one can disable dependency on videodev module and the like at the LED
module if V4L2 flash API is not needed.

> 2. add the real flash torch functions into LED device driver like
> leds-lm355x.c, this driver will still provide sysfs interface and
> extended flash/torch control sysfs interface as well.

+1

> I'm not sure about whether we need some change in V4L2 internally. But
> actually Andrzej Hajda's patchset is quite straightforward, but we
> just need put those V4L2 Flash API into a LED trigger driver and the
> real flash/torch operation in a LED device driver.

I guess some changes will be needed at both subsystems, but these are
details. Such high level design sounds good to me.

Sorry for not replying earlier in this thread, have been busy and
travelling for last two weeks.

--
Thanks,
Sylwester
