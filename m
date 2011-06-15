Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2761 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1FOUhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 16:37:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
Date: Wed, 15 Jun 2011 22:37:02 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl> <201106152155.57978.hverkuil@xs4all.nl> <BANLkTinx9Pa_Oe3qOfNgKZS3e82US6r8wg@mail.gmail.com>
In-Reply-To: <BANLkTinx9Pa_Oe3qOfNgKZS3e82US6r8wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106152237.02427.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 15, 2011 22:09:45 Devin Heitmueller wrote:
> On Wed, Jun 15, 2011 at 3:55 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Why would that violate the spec? If the last filehandle is closed, then
> > you can safely poweroff the tuner. The only exception is when you have a radio
> > tuner whose audio output is hooked up to some line-in: there you can't power off
> > the tuner.
> 
> The use case that some expect to work is:
> 
> v4l2-ctl <set standard>
> v4l2-ctl <set frequency>
> cat /dev/video0 > out.mpg
> 
> By powering off the tuner after v4l2-ctl closes the device node, the
> cat won't work as expected because the tuner will be powered down.
> 
> >> We've been forced to choose between the purist perspective, which is
> >> properly preserving state, never powering down the tuner and sucking
> >> up 500ma on the USB port when not using the tuner, versus powering
> >> down the tuner when the last party closes the filehandle, which
> >> preserves power but breaks v4l2 conformance and in some cases is
> >> highly noticeable with tuners that require firmware to be reloaded
> >> when being powered back up.
> >
> > Seems fine to me. What isn't fine is that a driver like e.g. em28xx powers off
> > the tuner but doesn't power it on again on the next open. It won't do that
> > until the first S_FREQUENCY/S_TUNER/S_STD call.
> 
> You don't want to power up the tuner unless you know the user intends
> to use it.  For example, you don't want to power up the tuner if the
> user intends to capture on composite/s-video input (as this consumes
> considerably more power).

But the driver has that information, so it should act accordingly.

So on first open you can check whether the current input has a tuner and
power on the tuner in that case. On S_INPUT you can also poweron/off accordingly
(bit iffy against the spec, though). So in that case the first use case would
actually work. It does require that tuner-core.c supports s_power(1), of course.

BTW, I noticed in tuner-core.c that the g_tuner op doesn't wake-up the tuner
when called. I think it should be added, even though most (all?) tuners will
need time before they can return anything sensible.

BTW2: it's not a good idea to just broadcast s_power to all subdevs. That should
be done to the tuner(s) only since other subdevs might also implement s_power.
For now it's pretty much just tuners and some sensors, though.

You know, this really needs to be a standardized module option and/or sysfs
entry: 'always on', 'wake up on first open', 'wake up on first use'.

Regards,

	Hans
