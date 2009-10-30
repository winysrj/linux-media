Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:54816 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZJ3DGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 23:06:02 -0400
From: Daniel Flesner <danimal@agriroots.com>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ivtv-users] Call for Testers: HVR-1600 Improvements
References: <829197380910290728y5d885db7v34433dac73728fd5@mail.gmail.com>
Date: Thu, 29 Oct 2009 23:06:02 -0400
In-Reply-To: <829197380910290728y5d885db7v34433dac73728fd5@mail.gmail.com>
	(Devin Heitmueller's message of "Thu, 29 Oct 2009 10:28:21 -0400")
Message-ID: <m3ocnp60o5.fsf@dakar.agriroots.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


wow, much better. my old snr was about 0x128, now it's 0x14c and i
haven't had any BER errors all night.

thanks,
daniel

Devin Heitmueller <dheitmueller@kernellabs.com> writes:

> Hello all,
>
> If you are an HVR-1600 user who has noticed the ClearQAM tuning
> performance under Linux was worse than under Windows, the following
> should make you happy.
>
> There is now a tree that contains various fixes for ClearQAM tuning.
> These have been measured to put the SNR performance on-par with the
> Windows driver.
>
> http://www.kernellabs.com/hg/~dheitmueller/hvr-1600-perf-2
>
> The goal is to submit this upstream, but before that we want to get
> some people to try it out first and submit feedback on their
> experience.
>
> Thanks go out to ONELAN Limited for sponsoring this work!
>
> Feedback (good or bad) on the KernelLabs blog or the linux-media
> mailing list would be appreciated.
>
> Thanks,
>
> Devin
