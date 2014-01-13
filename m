Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41038 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaAMQcc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 11:32:32 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm2so2441305wib.16
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 08:32:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEEHgGW008UFbe722vLt0suSxix_4KrM=9G2g82J9rfEypeCyg@mail.gmail.com>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
	<1389068966-14594-3-git-send-email-tmester@ieee.org>
	<CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
	<CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
	<CAEEHgGXjTfP4FPjSe6YxEODjWSCovZ4Z+ggS2ZCqxm5qfWd+EQ@mail.gmail.com>
	<CAGoCfiyQgs3So3bVg_VG9ii0SeR1Dit3SrV_6-3ox8MmqfVqDQ@mail.gmail.com>
	<CAEEHgGW008UFbe722vLt0suSxix_4KrM=9G2g82J9rfEypeCyg@mail.gmail.com>
Date: Mon, 13 Jan 2014 11:32:31 -0500
Message-ID: <CAGoCfizcPzsnsaYmiLMCuMENLr1bccoO8OQbYTUwBGKNHbqTHQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Mester <tmester@ieee.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 11, 2014 at 5:12 PM, Tim Mester <tmester@ieee.org> wrote:
>   My device is the 950q, so it uses the AU8522_DEMODLOCKING method.

No devices do tuner locking for digital (it's always the demodulator).
 That code should really just be ripped out.

> It does not appear to be an xc5000 issue on the surface.   When I
> originally put the patch together, I removed the return if the
> frequency was the same, and added the reset_demodulator() call at the
> end of the set_frontend() function. It seemed to work the same as the
> patch that I submitted.

I'm pretty sure that we accomplish the same thing through the patch I
have which reworks the clock management. except for removing the part
where the set_frontend() call returns if the freq/modulation are
already set.

> I have not been able to tell that it keeps the au8522 from losing
> lock, but it allows it to come back.  I see this issue about once a
> every 2-3 weeks on average, which is less frequent than the other
> issues.
>
> If you believe that this issue could result in a xc5000 and au8522
> interaction, then I should be able to try out the updated firmware. It
> will just take some time to know the results.

My instinct would be to get you to try that patch series I have in
git.  I suspect that it will address your issue with no further
patches required (we might need the one additional patch to remove the
early return in set_frontend, but let's see).  The testing of the new
firmware can be done in a separate series (the issue it addresses is
completely unrelated to the behavior you are seeing).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
