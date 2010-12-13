Return-path: <mchehab@gaivota>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4628 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab0LMSjn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 13:39:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC/PATCH 03/19] cx18: Use the control framework.
Date: Mon, 13 Dec 2010 19:39:45 +0100
Cc: linux-media@vger.kernel.org
References: <dpputt4i632ox8ldodidq3jk.1292179593754@email.android.com> <201012130832.10265.hverkuil@xs4all.nl> <1292247078.2054.38.camel@morgan.silverblock.net>
In-Reply-To: <1292247078.2054.38.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012131939.45550.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, December 13, 2010 14:31:18 Andy Walls wrote:
> On Mon, 2010-12-13 at 08:32 +0100, Hans Verkuil wrote:
> > On Sunday, December 12, 2010 19:46:33 Andy Walls wrote:
> 
> Hi Hans,
>  
> > > 1. Why set the vol step to 655, when the volume will actaully step at increments of 512?
> > 
> > The goal of the exercise is to convert to the control framework. I don't like to
> > mix changes like that with lots of other unrelated changes, so I kept this the
> > same as it was.
> 
> Sounds fine to me.
> 
> 
> > > 2. Why should failure to initialize a data structure for user
> > controls mean failure to init otherwise working hardware?  We never
> > let user control init cause subdev driver probe failure before, so why
> > now?  I'd prefer a working device without user controls in case of
> > user control init failure.
> > 
> > Huh? If you fail to allocate the memory for such data structures then I'm
> > pretty sure you will encounter other problems as well.
> 
> ENOMEM is not why I bring this up.  The new control framework can also
> return ERANGE and EINVAL.
> 
> Granted, both look like they can only result due to subdev driver bugs.
> However, when one is mass converting subdev and bridge drivers, bugs are
> going to get introduced.  In my specific case, the ERANGE error,
> aborting the the init of the CX23888 A/V core in the cx25840 driver,
> meant the CX23888 IR unit doesn't get a good clock.  IR didn't work
> because of a *volume control*!?  That is the only reason I noticed the
> bug.

But would you have noticed it if it would just skip the control due to a
driver bug? I much rather like to see a clear failure then that a control
silently disappears.

> I perceive a dearth of non-developers testing the changes in the GIT
> trees.  I don't have confidence that the majority of subdev driver bugs
> introduced by the conversion to the new framework will get caught until
> after a kernel release.  As I am discovering, the process for getting
> regressions fixed and into stable kernels is much longer than the time
> to introduce bugs.
> 
> I would prefer deployed hardware still be as operational as possible
> under newly released kernels.  That's why I'll still suggest user
> control init failure, for something other than ENOMEM, be a non-fatal
> error.  The move to the new control framework has no immediate,
> user-visible changes, except for symptoms of any introduced bugs.  The
> bugs found so far (msp3400 and cx25840) had pretty severe symptoms, and
> were noticed way too late.

I think this was more bad luck than anything else. From what I can remember,
these were pretty much the only regressions that we had. Based on other large
conversions I did in the past (e.g. the conversion to the subdevice API) the
number of regressions that they caused was surprisingly small.

The motivation of the move to the control framework is to make drivers
more predictable for userspace applications. Right now control handling is
wildly different between drivers. By moving everything over we should have
better and more consistent drivers in the end.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
