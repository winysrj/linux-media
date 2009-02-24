Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:41395 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756030AbZBXXgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 18:36:52 -0500
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <37219a840902241302u5b9d79bex9eb3b0e55462e3a@mail.gmail.com>
References: <200902221115.01464.hverkuil@xs4all.nl>
	 <37219a840902241302u5b9d79bex9eb3b0e55462e3a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 00:37:58 +0100
Message-Id: <1235518678.2701.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 24.02.2009, 16:02 -0500 schrieb Michael Krufky:
> On Sun, Feb 22, 2009 at 5:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
> >
> > _: Yes
> > _: No
> 
> 
> NO.
> 

this is an unwanted reply to Hans' polling, but I also stated previously
that I would leave it in the end to those who contributed and might
further do so. So this polling, for me, only means that neither Hans nor
Jean have to take care for how difficult backward compat would be for <
2.6.22.

Any common sense here?

> > Optional question:
> >
> > Why:
> 
> 
> Dropping support for older kernels means dropping support for MOST testers.

I seriously doubt this, I think I can count every single one reporting
issues below 2.6.22 and 2.6.18 during the last year, but it does not
even matter.

> Sure, it's an inconvenience for the maintainers.  This does *not* have
> to cause a hindrance for new drivers.  At first, new drivers can be
> added to the repository, and set to require only the latest kernels,
> via versions.txt .  When somebody has time to fix backwards compat for
> that driver, simply update versions.txt with the new kernel version
> dependency for the driver in question.

All agreed.

> Additionally, we all know what upstream kernel development is like --
> new kernel does *not* mean new stability.  More likely, new kernels
> bring new bugs.  (this isnt always the case, but it's good to be
> skeptical when it comes to production systems)

That is all true. But we start lacking testers on the recent rcx kernels
and unfortunately this includes me after years ...

> If I build an embedded system to use as a dedicated TV streaming box,
> I will not want to update my kernel JUST so that I can use the new
> driver required for my new TV tuner device.

Yes.

> Being able to build the v4l-dvb development repository against a
> reasonable set of stable kernels, including kernels as old as 2.6.16,
> is a critical feature for users of the v4l-dvb driver repository.

It is at least fun for them and we are great in that :)

Question is only, if Hans or Jean do to have to care for any of that
below 2.6.22 and I say no. Or?

> Regards,
> 
> Mike Krufky

Cheers,
Hermann



