Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:51393 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0BHQPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 11:15:21 -0500
Received: by bwz23 with SMTP id 23so1287963bwz.1
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 08:15:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265636585.5399.47.camel@brian.bconsult.de>
References: <1265546998.9356.4.camel@localhost> <4B6F72E5.3040905@redhat.com>
	 <4B700287.5080900@linuxtv.org>
	 <1265636585.5399.47.camel@brian.bconsult.de>
Date: Mon, 8 Feb 2010 11:15:19 -0500
Message-ID: <829197381002080815h61edc8a3t4a9b7db20089acf6@mail.gmail.com>
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux
	filter (Was: Videotext application crashes the kernel due to DVB-demux patch)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Francesco Lavra <francescolavra@interfree.it>,
	linux-media@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, rms@gnu.org, hermann-pitton@arcor.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mr. Shack,

On Mon, Feb 8, 2010 at 8:43 AM, Chicken Shack <chicken.shack@gmx.de> wrote:
> I vote for Andy Walls, Devin Heitmueller. There are a couple of capable
> candidates here who can really do that job with a better output for the
> whole Linux community.
> There is ABSOLUTELY NO necessity to continue with Mauro Carvalho Chehab.

I want to take this opportunity to thank you for your nomination and
vote.  It means so much to me to see this nomination coming from such
a dedicated contributor to the project, given your years of service
and hundreds of patches to the LinuxTV project.

<sarcasm mode off>

I've quietly sat back and watched this thread over the last few days.
I've watched your abusive and condescending attitude toward the
volunteers who have spent their limited time trying to help resolve
the issue you reported.  You seem to have forgotten that you are
dealing with a group of volunteers, and that they have absolutely *no*
obligation whatsoever to help you in making your application work.

As a user, I can appreciate your frustration:  your application used
to work and now it doesn't.  But *demanding* that developers stop what
they are doing to fix your problem is not particularly productive.
Unless you are cutting them a check, they have no obligation to do
what you want.

Was there a regression?  Yup.  Shit happens.  Let's focus on what
needs to be done to fix it.  While you interpreted the extended thread
of discussion of various options as counter-productive, this is
actually how development works.  Somebody reports a problem.
Developers discuss the various potential approaches available to deal
with the problem.  Other developers point out why those approaches
aren't appropriate or could cause other issues.

"When you are dumb, you surround yourself with smart people.  When you
are smart, you surround yourself with smart people who disagree with
you."

In this case, while not doubting the reported problem was valid, the
notion of rolling back functionality that made it into a stable kernel
in order to address the problem is something that isn't desirable.
The best case is when a fix can be made while preserving compatibility
with both usage patterns.  When that isn't possible, then hard
decisions need to be made.

And as someone who has both fixed bugs in the DVB core as well as
having introduced them, I can appreciate how hard it can be to
understand that piece of code.  It's an inherently complicated
problem, involving multiple threads of execution and concurrency, as
well as a large number of applications that use the API in different
ways.

With regards to your concerns about Mauro being the maintainer, what
can I say?  Does he make mistakes?  Sure.  Does he sometimes do things
I disagree with?  Yup.  Would I want his job?  Absolutely not.  It's a
thankless job and people only notice what you do when you make a
mistake.  He has to evaluate patches not just in terms of how they
effect whatever tuner the developer submitted them for, but also for
all the other products that use the same code.  When people submit
patches that effect application behavior, he has put forth his best
effort to ensure that it doesn't break other applications.  This is a
nontrivial exercise, and we should be thankful that Mauro has been
willing to do it for as long as he has (most maintainers of large
codebases experience "burn out" after a relatively short period of
time).

One of the things that is so empowering about open source is the
ability to fix your own problems if it matters enough to you.  You
have the full source code to all the components, and if some issue is
critical to you then you have everything you need to fix your own
problems.  You are only limited by your own commitment to learn how to
program.

Now I'm going to go back to working on my driver code.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
