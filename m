Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:37557 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAHFMU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 00:12:20 -0500
Received: by mail-qe0-f52.google.com with SMTP id ne12so1331508qeb.11
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 21:12:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
	<1389068966-14594-3-git-send-email-tmester@ieee.org>
	<CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
	<CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
Date: Tue, 7 Jan 2014 22:12:19 -0700
Message-ID: <CAEEHgGXjTfP4FPjSe6YxEODjWSCovZ4Z+ggS2ZCqxm5qfWd+EQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
From: Tim Mester <tmester@ieee.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 6, 2014 at 9:53 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
>> I suspect this is actually a different problem which out of dumb luck
>> gets "fixed" by resetting the chip.  Without more details on the
>> specific behavior you are seeing though I cannot really advise on what
>> the correct change is.
>
> Tim,
>
> It might be worth trying out the following patch series and see if it
> addresses the problem you're seeing.  There was a host of problems
> with the clock management on the device which could result in the
> various sub-blocks getting wedged.  The TS output block was just one
> of those cases.
>
> http://git.kernellabs.com/?p=dheitmueller/linuxtv.git;a=shortlog;h=refs/heads/950q_improv
>
> I'm not against the hack you've proposed if it's really warranted, but
> a reset is really a last resort and I'm very concerned it's masking
> over the real problem.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

Devin,

  Commit 2e68a75990011ccd looks interesting.  It makes sense to me
that if we are gating the clock, and it is possible that we are
glitching the clock line, it could put the internal synchronous logic
into a bad state.  If that happens, it would generally require a reset
under a stable clock to get out of that condition.  I will give that
patch a try an see if it addresses issue 1), mentioned above.

However, I'm not sure if that will do anything about issue 2). Do you
have any insight into that one?

 Thanks,

 Tim
