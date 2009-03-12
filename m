Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4801 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZCLLOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 07:14:43 -0400
Message-ID: <60934.62.70.2.252.1236856462.squirrel@webmail.xs4all.nl>
Date: Thu, 12 Mar 2009 12:14:22 +0100 (CET)
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Add cx231xx USB driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	"Sri Deevi via Mercurial" <srinivasa.deevi@conexant.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
> On Thu, 12 Mar 2009 08:38:59 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Mauro,
>>
>> What the hell??!
>>
>> Since when does a big addition like this get merged without undergoing a
>> public review?
>>
>> I've been working my ass off converting drivers to the new i2c API and
>> v4l2_subdev structures and here you merge a big driver that uses
>> old-style
>> (which will lead to 'deprecated' warnings when compiling with 2.6.29,
>> BTW),
>> where the driver writes directly to i2c modules instead of adding a
>> proper
>> i2c module for them. And what are 'colibri', 'flatrion' and 'hammerhead'
>> anyway? Are they integrated devices of the cx231xx? Can they be used
>> separately in other products as well?
>>
>> So yes, I have objections. At the minimum it should be converted first
>> to
>> use v4l2_device/v4l2_subdev and I need more information on the new i2c
>> devices so I can tell whether the code for those should be split off
>> into
>> separate i2c modules. Not to mention that I want to have the time to
>> review
>> this code more closely.
>>
>> Sorry Sri, this isn't your fault.
>
> Hans,
>
> I know that you're rushing to convert all drivers to the new model, but
> you
> should give time to time. Even with Kernel's fast development cycle, we
> should
> take care to not depreciate things faster than developers can track (btw,
> lwn.net already complained that V4L subsystem changes their APIs faster
> than
> usual).

Mauro, you did not answer the question why this driver was just merged
without going through a public review? If I'd seen it beforehand I'd have
worked together with Sri to get it fixed first. I don't expect him to know
about this, but I didn't even get a chance to discuss it and help with it.
Everyone else has to go through the normal review channels, but apparently
this was just fast-tracked and merged. That's not the way to do it.

Please back out this driver, put it in a separate tree and let me 1)
review this driver first, and 2) help Sri implementing the
v4l2_device/v4l2_subdev stuff.

> First of all, except for ivtv drivers, the first conversion to the new
> model
> occurred just few weeks ago. The new model will bring some gains, but this
> shouldn't stop the merge of the drivers whose development started before
> we
> port the drivers used as example by the developer.
>
> This is a new model, and we should give people some time to adapt to it.
> This
> is the way we worked in the past and it is the way we should keep working.

It's not a new model. The I2C core changes went in in 2.6.22. Jean is no
longer accepting new i2c drivers that use the old module, and neither
should we. And definitely NOT without discussing it first. The old i2c API
has been marked deprecated in 2.6.29, and that's for a reason. There are
good alternatives for this and I'm available to help with the conversion.
Not to mention that this will make Jean quite unhappy.

And please note that the use of the old API isn't the only question I
have, there are more oddities with the i2c handling that I'd like to have
more information about. Writing i2c registers directly from the adapter
driver doesn't look good to me at first sight.

> For
> example, video_ioctl2 were added several Kernel releases before merging
> uvc
> driver. Yet, we've accepted uvc driver without using the new model,
> because its
> development that occurred before video_ioctl2.
>
> The second point is that there's nothing at
> Documentation/feature-removal-schedule.txt informing that those stuff is
> deprecated.

Yes it is, see this from the 2.6.29 kernel:

What:   i2c_attach_client(), i2c_detach_client(), i2c_driver->detach_client()
When:   2.6.29 (ideally) or 2.6.30 (more likely)
Why:    Deprecated by the new (standard) device driver binding model. Use
        i2c_driver->probe() and ->remove() instead.
Who:    Jean Delvare <khali@linux-fr.org>

> So, we should still accept new drivers without the conversion at least
> until
> the end of 2.6.30 window, and add some notice at
> feature-removal-schedule.txt
> on 2.6.30 clearly stating what's deprecated and when, before generating
> penalty
> over the developers that are using the current drivers as their model of
> development.
>
> In the specific case of cx231xx driver, I've explained to Sri, there are
> still
> some issues to be fixed at the driver. Although the driver works, It is
> not
> ready for 2.6.30 yet.
>
> However, keeping this on a separate tree will just create more mess
> (according
> with Sri, he already had to rebase this driver 4 times during 2.6.29-rc
> cycle,
> due to the high speed of internal API changes).
>
> Since his driver seems to be based on em28xx, he had no sample on how to
> convert it to
> v4l2_device/v4l2_subdev/new_i2c model.

Again, if I'd known about it I'd be happy to help with it. Why didn't you
put me in contact with him? You know I'm spending a lot of time on this.

> After committing Devin's Austek patches (also seemed to be based on
> em28xx), it will
> probably be easier for Uri to convert his driver to the new approach.

That depends. As I said, there are other i2c issues that need to be
clarified, but I *never* got the chance to ask him since you just merged
this driver without the customary public review.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

