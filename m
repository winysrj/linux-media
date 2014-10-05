Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37487 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaJERIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 13:08:32 -0400
Received: by mail-pd0-f176.google.com with SMTP id fp1so2058886pdb.7
        for <linux-media@vger.kernel.org>; Sun, 05 Oct 2014 10:08:31 -0700 (PDT)
Message-ID: <54317B0A.5070008@gmail.com>
Date: Mon, 06 Oct 2014 02:08:26 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: "AreMa Inc." <info@are.ma>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media <linux-media@vger.kernel.org>, knightrider@are.ma
Subject: Re: [PATCH 02/11] tc90522 is a client
References: <cover.1412497399.git.knightrider@are.ma>	<5bff3e029fe189f44222961dc04790d4f58a4659.1412497399.git.knightrider@are.ma>	<20141005083358.072f5909.m.chehab@samsung.com> <CAKnK8-REGVgdgQM+2KP0ibrf_gHMm_UO3oLr0MRoiu=-7vXUPw@mail.gmail.com>
In-Reply-To: <CAKnK8-REGVgdgQM+2KP0ibrf_gHMm_UO3oLr0MRoiu=-7vXUPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(some Cc:'s removed, to exclude those who are not directly involved)

It seems that I should make some counterarguments.

On 2014年10月05日 21:39, AreMa Inc. wrote:
....
> We started developing and publishing PT3 drivers (chardev and DVB versions)
> on 2013 and have been submitting the patches to this community since then.
> We were waiting for reviews.

you haven't annouced any intent to merge this github project
to the linux kernel until this April.
It also has not acquired so many users that a bug in parallel streaming
had been left unnoticed until just recently.
So I disagree that your project is
> a de facto standard,
> well tested without any major/minor issues
> reported
, but it's a small thing anyway, comparted to the other claims by you.

I read your first post this April in the ML,
and exchanged some private emails after sending my reply to the ML,
about the reviews on the original post.
I waited 3 months, expecting you revise and re-post the patch,
but you didn't.

As I knew that your code did not well conform to the current DVB
driver model/style nor kernel patch submission rules,
I sent a private email that I was afraid that the patch you sent
to the ML would not be accepted if left as it is,
and asked if you would continue revising it, and if not,
I would take over the submitting of PT3 driver.
But you replied that you were reluctant to change the original code
and clealy rejected some of the reviews incl. separating of the patch.

I still waited one more week expecting you to revise the patch or
at least express some counterarguments on the ML, but no responses.
Thus I figured that you don't have a will to revise the patch anymore
and gave up merging it, so I post my code with reference to your patch.
But you didn't repsoned anything, again.

> However this July, a man named Tsukada, who has been annoying us since
> the beginning of development (we invited him to merge/join the project,
> in other words, opted him to be co-author), interrupted our submission
> and started
> speaking ill of us that we didn't want to split the driver and stopped
> the development, etc.
plz don't lie. you just said that you would accept patches to your origianl
code base at github if I would sent those.
Never mentioned joining the project or co-writing.
and I never spoke ill of you.
I just pointed out the reason why I took over the driver,
which is just same as you mentioned in the above paragraph.

If you had an objection to my patch,
Why you didn't express objections for well more than one month after my first post?
Why you didn't respond to the first review to your patch for more than 3 months?
Did you remember that you even "DECLINED" separting your patch later in September?
(see 1409966878-22627-1-git-send-email-knightrider@are.ma in the ML)

As I said in the private email to you, all those things made me believe that
you would not update your patch to conform to the DVB driver model
and thus it would not be accepted in the future,
and that you had admitted my patch since you did not express any objections.
--
akihiro
