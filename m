Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZLCH5A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 02:57:00 -0500
Message-ID: <4B177120.6090900@redhat.com>
Date: Thu, 03 Dec 2009 09:04:48 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Replace Mercurial with GIT as SCM
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
In-Reply-To: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+1 for git, I really really really miss being able to do
a simple "git rebase", and no rebase is not evil not as long
as you don't use it for anything but local patches.

Regards,

Hans




On 12/01/2009 03:59 PM, Patrick Boettcher wrote:
> Hi all,
>
> I would like to start a discussion which ideally results in either
> changing the SCM of v4l-dvb to git _or_ leaving everything as it is
> today with mercurial.
>
> To start right away: I'm in favour of using GIT because of difficulties
> I have with my "daily" work with v4l-dvb. It is in my nature do to
> mistakes, so I need a tool which assists me in fixing those, I have not
> found a simple way to do my stuff with HG.
>
> I'm helping out myself using a citation from which basically describes
> why GIT fits the/my needs better than HG (*):
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
> My suggestion is not to have the full Linux Kernel source as a new base
> for v4l-dvb development, but "only" to replace the current v4l-dvb hg
> with a GIT one. Importing all the history and everything.
>
> Unfortunately it will change nothing for Mauro's job.
>
> I also understand that it does not give a lot to people who haven't used
> GIT until now other than a new SCM to learn. But believe me, once you've
> done a rebase when Mauro has asked you to rebuild your tree before he
> can merge it, you will see what I mean.
>
> I'm waiting for comments.
>
> Thanks,
>
> (*)
> http://www.rockstarprogrammer.org/post/2008/apr/06/differences-between-mercurial-and-git/
>
>
> --
>
> Patrick
> http://www.kernellabs.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
