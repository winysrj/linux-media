Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61730 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZLAQHG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 11:07:06 -0500
Received: by fxm5 with SMTP id 5so5061309fxm.28
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 08:07:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
Date: Tue, 1 Dec 2009 11:07:11 -0500
Message-ID: <a728f9f90912010807g42705243u5509a66d8be74145@mail.gmail.com>
Subject: Re: Replace Mercurial with GIT as SCM
From: Alex Deucher <alexdeucher@gmail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 1, 2009 at 9:59 AM, Patrick Boettcher
<pboettcher@kernellabs.com> wrote:
> Hi all,
>
> I would like to start a discussion which ideally results in either changing
> the SCM of v4l-dvb to git _or_ leaving everything as it is today with
> mercurial.
>
> To start right away: I'm in favour of using GIT because of difficulties I
> have with my "daily" work with v4l-dvb. It is in my nature do to mistakes,
> so I need a tool which assists me in fixing those, I have not found a simple
> way to do my stuff with HG.
>
> I'm helping out myself using a citation from which basically describes why
> GIT fits the/my needs better than HG (*):
>
> "The culture of mercurial is one of immutability. This is quite a good
> thing, and it's one of my favorite aspects of gnu arch. If I commit
> something, I like to know that it's going to be there. Because of this,
> there are no tools to manipulate history by default.
>
> git is all about manipulating history. There's rebase, commit amend,
> reset, filter-branch, and probably other commands I'm not thinking of,
> many of which make it into day-to-day workflows. Then again, there's
> reflog, which adds a big safety net around this mutability."
>
> The first paragraph here describes exactly my problem and the second
> descibes how to solve it.
>
> My suggestion is not to have the full Linux Kernel source as a new base for
> v4l-dvb development, but "only" to replace the current v4l-dvb hg with a GIT
> one. Importing all the history and everything.
>
> Unfortunately it will change nothing for Mauro's job.
>
> I also understand that it does not give a lot to people who haven't used GIT
> until now other than a new SCM to learn. But believe me, once you've done a
> rebase when Mauro has asked you to rebuild your tree before he can merge it,
> you will see what I mean.
>
> I'm waiting for comments.

I prefer git myself, but I'm not really actively working on v4l at the
moment, so, I leave it up to the active devs.  One nice thing about
git is the ability to maintain patch authorship.

Alex
