Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760042Ab0I1Agq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 20:36:46 -0400
Message-ID: <4CA13893.8050409@redhat.com>
Date: Mon, 27 Sep 2010 21:36:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.36] V4L/DVB fixes
References: <4CA10545.4010204@redhat.com> <AANLkTikYyEPAHq5rYzzckExTSFFCAj_DUqAZEvoeU0WD@mail.gmail.com>
In-Reply-To: <AANLkTikYyEPAHq5rYzzckExTSFFCAj_DUqAZEvoeU0WD@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-09-2010 21:02, Linus Torvalds escreveu:
> On Mon, Sep 27, 2010 at 1:57 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> The following changes since commit 32163f4b2cef28a5aab8b226ffecfc6379a53786:
>>
>>  alpha: fix usp value in multithreaded coredumps (2010-09-25 14:38:13 -0700)
>>
>> are available in the git repository at:
>>  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
> 
> I get
> 
>   scripts/kconfig/conf --oldconfig arch/x86/Kconfig
>   drivers/media/Kconfig:146: 'endif' in different file than 'if'
>   drivers/media/IR/Kconfig:15: location of the 'if'
>   drivers/Kconfig:114: unexpected 'endmenu' within if block
>   drivers/Kconfig:1: missing end statement for this entry
>   make[1]: *** [oldconfig] Error 1
>   make: *** [oldconfig] Error 2
> 
> with this. And it seems to be due to a totally broken commit at the
> very beginning of the series by a commit called "Kconfig fixes"
> (Hah!), that clearly has not been tested at all.

Argh! something got completely wrong here. Sorry for the mess.
This patch is already upstream (changeset ade321c5b8a0e4).

I had some troubles on my local tree (some objects missed after a gc on
a shared repository). I had to recover my local tree, to avoid loosing 
some patches applied there for linux-next. It seems that I did a bad work 
on recovering them. I always compile everything a few times before sending, 
but this time, I just didn't notice.

> The commit sequence was also done today, apparently immediately before
> sending me the pull request. Which sure as hell explains the "clearly
> not tested at all" situation.
> 
> Don't do this. You are now officially on my shit-list for sending me
> total crap.
> 
> How effing hard can it be to understand: you don't send me stuff that
> hasn't been tested. It needs to be in -next for SEVERAL DAYS, and you
> don't rebase it or take it from some random quilt series just before
> sending it to me.
> 
> That's true _especially_ during the -rc series. But it's damn well
> true at any other time too.
> 
> I'm angry. I expect at least some _minimal_ amount of competence from
> people I pull from. This was not it. Get your ^&#! act together!
> 
>                                    Linus

I'll clean up the mess and prepare a new pull request in the next days.

Sorry,
Mauro.
