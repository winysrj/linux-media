Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1387 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2IFGh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 02:37:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jun Nie <niej0001@gmail.com>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
Date: Thu, 6 Sep 2012 08:36:42 +0200
Cc: workshop-2011@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20120713173708.GB17109@thunk.org> <201209051028.30258.hverkuil@xs4all.nl> <CAGA24MKyr_N2Upns9FaZ9Q+Yegs0DDeHVfm_EWZQQN=Auky8Ow@mail.gmail.com>
In-Reply-To: <CAGA24MKyr_N2Upns9FaZ9Q+Yegs0DDeHVfm_EWZQQN=Auky8Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209060836.42059.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu September 6 2012 06:09:44 Jun Nie wrote:
> 2012/9/5 Hans Verkuil <hverkuil@xs4all.nl>:
> > On Wed 5 September 2012 10:04:41 Jun Nie wrote:
> >> Is there any summary for this summit or presentation material? I am
> >> looking forward for some idea on CEC. It is really complex in
> >> functionality.
> >> Maybe other guys is expecting simiar fruite from summit too.
> >
> > Yes, there will be a summit report. It's not quite finished yet, I think.
> >
> > With respect to CEC we had some useful discussions. It will have to be a
> > new class of device (/dev/cecX), so the userspace API will be separate from
> > drm or v4l.
> >
> > And the kernel will have to take care of the core CEC protocol w.r.t. control
> > and discovery due to the HDMI 1.4a requirements.
> >
> > I plan on starting work on this within 1-2 weeks.
> >
> > My CEC presentation can be found here:
> >
> > http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-cec.odp
> >
> > Regards,
> >
> >         Hans
> 
> Thanks for quick response! It's good to know that CEC is independent
> with DRM/V4L for my HDMI implementation is FB/lcd-device based. CEC is
> also deserved to have independent management in both hardware signal
> and functionality. Someone also expressed similar thoughts before.
> Will remote control protocal parsing are done in userspace reference
> library? Or not decided yet?

Are you referring to the remote control pass-through functionality?
I don't know yet whether that will go through a userspace library or
through the RC kernel subsystem, or possibly both.

Most of the other non-system messages will go to a userspace library.

But I haven't started coding yet, so it is very early days :-)

The main thing is that at least I now have a high-level design that
I can start to work with.

Regards,

	Hans
