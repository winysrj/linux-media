Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:41541 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbaAHU0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 15:26:14 -0500
Received: by mail-we0-f172.google.com with SMTP id p61so1976152wes.31
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 12:26:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEEHgGXjTfP4FPjSe6YxEODjWSCovZ4Z+ggS2ZCqxm5qfWd+EQ@mail.gmail.com>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
	<1389068966-14594-3-git-send-email-tmester@ieee.org>
	<CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
	<CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
	<CAEEHgGXjTfP4FPjSe6YxEODjWSCovZ4Z+ggS2ZCqxm5qfWd+EQ@mail.gmail.com>
Date: Wed, 8 Jan 2014 15:26:13 -0500
Message-ID: <CAGoCfiyQgs3So3bVg_VG9ii0SeR1Dit3SrV_6-3ox8MmqfVqDQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Mester <tmester@ieee.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Wed, Jan 8, 2014 at 12:12 AM, Tim Mester <tmester@ieee.org> wrote:
>   Commit 2e68a75990011ccd looks interesting.  It makes sense to me
> that if we are gating the clock, and it is possible that we are
> glitching the clock line, it could put the internal synchronous logic
> into a bad state.  If that happens, it would generally require a reset
> under a stable clock to get out of that condition.  I will give that
> patch a try an see if it addresses issue 1), mentioned above.

Yeah, the whole thing about the clocks not being enabled/disabled in
the correct order relative to enabling the sub-blocks did result in
some strange cases where sub-block wouldn't reactivate properly,
requiring a reset to return it to a working state.  It was
specifically this issue I was concerned about might be the "right fix"
for the problem you are hitting.

Note:  you need more than just 2e68a75990011ccd.  That is actually an
add-on to the real commit that restructures the clock managment:
39c39b0e612b5d35feb00329b527b266df8f7fd2

> However, I'm not sure if that will do anything about issue 2). Do you
> have any insight into that one?

Well, I've never been a fan of how the code just does a blind "return
0" if the target modulation and frequency are the same as it's in
theory already tuned to.  Have you tried commenting out just that
block and see if it makes a difference?  IIRC, the dvb-frontend kernel
thread should automatically re-issue a set_frontend() call if the
signal lock drops out.

As for the underlying problem, I'm not sure.  Generally once the
signal is locked it continues to work.  If you set the xc5000 debug=1
modprobe option, do you see lines in the log that say "xc5000: PLL not
locked"?

How reproducible is the issue, and how often does it happen?  I've got
some newer firmware that might be worth trying which isn't upstream
yet (assuming for a moment that it's an xc5000 issue).  If you believe
you can repro the issue pretty regularly, you and I can work offline
to try that out.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
