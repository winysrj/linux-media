Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56537 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1AHEIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 23:08:24 -0500
Received: by iwn9 with SMTP id 9so17776419iwn.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 20:08:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101072206.30323.hverkuil@xs4all.nl>
References: <201101072053.37211@orion.escape-edv.de>
	<AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
	<201101072206.30323.hverkuil@xs4all.nl>
Date: Fri, 7 Jan 2011 20:08:23 -0800
Message-ID: <AANLkTi=zsQmO5Ss_ewwPXAgC3o1RTJAQ+eMLspMdr7Ac@mail.gmail.com>
Subject: Re: Debug code in HG repositories
From: VDR User <user.vdr@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 7, 2011 at 1:06 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Have you tried Mauro's media_build tree? I had to use it today to test a
> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we should
> promote this more. I could add backwards compatibility builds to my daily
> build script that uses this in order to check for which kernel versions
> this compiles if there is sufficient interest.

I'd just like to note that I have been using the media_build daily
snapshots with much success.  IMO, it's about as close as you're going
to get to the old hg system.  As a (mostly) end-user, I am one of the
people unwilling to hassle with the entire git tree (kernel included),
but since the introduction of media_build, we're once again able to
test new code much like we did before.  I strongly urge any end-user
who hasn't given it a try, to do so.

Regards,
Derek
