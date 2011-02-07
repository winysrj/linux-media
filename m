Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:18610 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1BGKwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 05:52:31 -0500
Subject: Re: WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 12:52:02 +0200
Message-ID: <1297075922.15320.31.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Mark Brown wrote:
> On Wed, Feb 02, 2011 at 01:35:01PM -0200, Mauro 
> Carvalho Chehab wrote:
>
> [Reflowed into 80 columns.]
>> My concerns is that the V4L2-specific part of the code should be at
>> drivers/media.  I prefer that the specific MFD I/O part to be at
>> drivers/mfd, just like the other drivers.
>
> Currently that's not the case - the I/O functionality is not in any
> meaningful sense included in the MFD, it's provided by the V4L portion.

I've been away for two and a half weeks so I haven't been able to
comment...

But before I start to make changes, I'd still like to ask for a comment
on my original plan, which was to have the I/O functions in the MFD
driver and also have there things like interrupt handling etc.

My vision was that the MFD part would have the application logic and the
child drivers would be just true interfaces to the core functionality,
because I kind of saw the children to be of equal importance and because
the codec and the v4l2 driver share some controls like for example the
volume control. 

If you'd care to take a look an earlier version of the MFD driver here:

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/23602/match=aaltonen

So the question is if I put only the I/O stuff into the MFD driver or
can I have the other application logic there as well?

Thanks,
Matti





