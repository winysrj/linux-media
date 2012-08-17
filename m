Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1388 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab2HQMg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 08:36:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: pdickeybeta@gmail.com
Subject: Re: Preferred setup for development?
Date: Fri, 17 Aug 2012 14:35:56 +0200
Cc: linux-media@vger.kernel.org
References: <1345204225.1800.73.camel@dcky-ubuntu64>
In-Reply-To: <1345204225.1800.73.camel@dcky-ubuntu64>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171435.56349.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri August 17 2012 13:50:25 Patrick Dickey wrote:
> I'm looking for information about what distributions people are using,
> and how they go about testing their code.  The reason is, I'm running
> Ubuntu for my main distribution, and it seems like I'll have to go
> through a lot of hoops in order to compile and test changes to the
> kernel.  I realize that I could probably just use the media_build tree,
> and add the changes there.  But, I'd prefer to go the same route that
> the majority of the developers here do.
> 
> So, my questions are these:
> 
> 1.  Do you use a specific distribution for development, or a roll your
> own (like Linux from Scratch)?

I used LFS a long time ago. It's great to learn how a linux system is put
together, but it takes way too much time to upgrade.

I've used several distros in the past but I'm now running aptosid, which is
a rolling Debian sid distro. But I do build my own kernel.

> 2.  If you use a distribution, which one?
> 3.  Do you do your development on physical computers or on virtual
> machines (or both)?

Physical for the most part.

> 4.  Do you have a machine that's dedicated to development, or is it one
> that you use for other things?

Both. I use my main PC for development, but I also have more specialized
PCs to test certain things.

> 5.  Do you use a newer computer, or older computer for development? (or
> both)

I tend to upgrade to something faster every so often :-)

> For anyone using the media_build tree (instead of the media_git tree):
> 
> Are you able to seamlessly implement changes that are in the media_git
> tree files to the media_build tree, or do you have to make changes in
> order to get them to compile? 
> Are your files able to be implemented into the media_git tree
> seamlessly, or do you have to make changes to get them to compile?

If you have to make changes, let me know. It should be seamless. Occasionally
things break with media_build if new code is merged in media-git, but I try
to be on top of it.

> If you're able to use the media_build tree, and the changes you make can
> be implemented in the media_git tree without hassle, I may go that route
> instead.
> 
> I downloaded a Slackware DVD, as it appears to be one that you can "roll
> your own kernel" without too much of a hassle. But, I want to get
> people's opinions before I start.

Generally, building your own kernel isn't that hard. Figuring it out tends
to be a one-time job.

But if you just touch media drivers and do not intend to do any work
elsewhere in the kernel, then media_build should work well.

Regards,

	Hans
