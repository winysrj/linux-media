Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:18501 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757757Ab0LMNal (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:30:41 -0500
Subject: Re: [RFC/PATCH 03/19] cx18: Use the control framework.
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201012130832.10265.hverkuil@xs4all.nl>
References: <dpputt4i632ox8ldodidq3jk.1292179593754@email.android.com>
	 <201012130832.10265.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 08:31:18 -0500
Message-ID: <1292247078.2054.38.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, 2010-12-13 at 08:32 +0100, Hans Verkuil wrote:
> On Sunday, December 12, 2010 19:46:33 Andy Walls wrote:

Hi Hans,
 
> > 1. Why set the vol step to 655, when the volume will actaully step at increments of 512?
> 
> The goal of the exercise is to convert to the control framework. I don't like to
> mix changes like that with lots of other unrelated changes, so I kept this the
> same as it was.

Sounds fine to me.


> > 2. Why should failure to initialize a data structure for user
> controls mean failure to init otherwise working hardware?  We never
> let user control init cause subdev driver probe failure before, so why
> now?  I'd prefer a working device without user controls in case of
> user control init failure.
> 
> Huh? If you fail to allocate the memory for such data structures then I'm
> pretty sure you will encounter other problems as well.

ENOMEM is not why I bring this up.  The new control framework can also
return ERANGE and EINVAL.

Granted, both look like they can only result due to subdev driver bugs.
However, when one is mass converting subdev and bridge drivers, bugs are
going to get introduced.  In my specific case, the ERANGE error,
aborting the the init of the CX23888 A/V core in the cx25840 driver,
meant the CX23888 IR unit doesn't get a good clock.  IR didn't work
because of a *volume control*!?  That is the only reason I noticed the
bug.

I perceive a dearth of non-developers testing the changes in the GIT
trees.  I don't have confidence that the majority of subdev driver bugs
introduced by the conversion to the new framework will get caught until
after a kernel release.  As I am discovering, the process for getting
regressions fixed and into stable kernels is much longer than the time
to introduce bugs.

I would prefer deployed hardware still be as operational as possible
under newly released kernels.  That's why I'll still suggest user
control init failure, for something other than ENOMEM, be a non-fatal
error.  The move to the new control framework has no immediate,
user-visible changes, except for symptoms of any introduced bugs.  The
bugs found so far (msp3400 and cx25840) had pretty severe symptoms, and
were noticed way too late.

My $0.02.

Regards,
Andy

