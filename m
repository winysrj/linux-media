Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2IGA7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 20:59:11 -0400
Received: by pbbrr13 with SMTP id rr13so3276938pbb.19
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2012 17:59:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201209061355.00726.hverkuil@xs4all.nl>
References: <20120713173708.GB17109@thunk.org>
	<201209060836.42059.hverkuil@xs4all.nl>
	<CAGA24MKWiDnbyLquTZx6KyOsBHo=xo3HmmqgmJw2YNxj6ha_Vg@mail.gmail.com>
	<201209061355.00726.hverkuil@xs4all.nl>
Date: Fri, 7 Sep 2012 08:59:10 +0800
Message-ID: <CAGA24MJ_z+CWSMOdWub8uGTn6tOuSd-__UfaKG4X0_mFoNruhg@mail.gmail.com>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
From: Jun Nie <niej0001@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: workshop-2011@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/9/6 Hans Verkuil <hverkuil@xs4all.nl>:
> On Thu 6 September 2012 12:29:17 Jun Nie wrote:
>> 2012/9/6 Hans Verkuil <hverkuil@xs4all.nl>:
>> > On Thu September 6 2012 06:09:44 Jun Nie wrote:
>> >> 2012/9/5 Hans Verkuil <hverkuil@xs4all.nl>:
>> >> > On Wed 5 September 2012 10:04:41 Jun Nie wrote:
>> >> >> Is there any summary for this summit or presentation material? I am
>> >> >> looking forward for some idea on CEC. It is really complex in
>> >> >> functionality.
>> >> >> Maybe other guys is expecting simiar fruite from summit too.
>> >> >
>> >> > Yes, there will be a summit report. It's not quite finished yet, I think.
>> >> >
>> >> > With respect to CEC we had some useful discussions. It will have to be a
>> >> > new class of device (/dev/cecX), so the userspace API will be separate from
>> >> > drm or v4l.
>> >> >
>> >> > And the kernel will have to take care of the core CEC protocol w.r.t. control
>> >> > and discovery due to the HDMI 1.4a requirements.
>> >> >
>> >> > I plan on starting work on this within 1-2 weeks.
>> >> >
>> >> > My CEC presentation can be found here:
>> >> >
>> >> > http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-cec.odp
>> >> >
>> >> > Regards,
>> >> >
>> >> >         Hans
>> >>
>> >> Thanks for quick response! It's good to know that CEC is independent
>> >> with DRM/V4L for my HDMI implementation is FB/lcd-device based. CEC is
>> >> also deserved to have independent management in both hardware signal
>> >> and functionality. Someone also expressed similar thoughts before.
>> >> Will remote control protocal parsing are done in userspace reference
>> >> library? Or not decided yet?
>> >
>> > Are you referring to the remote control pass-through functionality?
>> > I don't know yet whether that will go through a userspace library or
>> > through the RC kernel subsystem, or possibly both.
>
>> I mean all the feature that can involved in handhold remote control,
>> one touch play, standby, on screen display, etc, such as
>> play/pause/poweroff. I want to mention all non CDC features that can
>> be implemented in user space. They are hard to be covered by any
>> sub-system and user space library is more proper. Just like your
>> metaphor, kitchen sink for CEC. I like your words.
>
> Yes, that will all be userspace.
>
> My plan is to have the CEC adapter driver handle the core CEC protocol,
> allow other drivers to intercept messages that are relevant for them and
> send messages themselves, and anything that remains will be available to
> userspace for which a new library will be created.
>
> Now, don't ask me about any of the details, since I don't have them yet :-)
> My plan is to start working on this next week or the week after.
>
> Are you willing to test early versions of this work? Can you test HDMI 1.4a
> features as well? Testing this might well be one of the harder things to do.
>
I am willing to test or contribute to the library. But my hardware
does not include HEAC. So my test scope limites to the features that
can be implemented in user space.

> Regards,
>
>         Hans
