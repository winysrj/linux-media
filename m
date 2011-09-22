Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:33595 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1IVP3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 11:29:37 -0400
Date: Thu, 22 Sep 2011 17:29:29 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
Message-ID: <20110922172929.16df967f@skate>
In-Reply-To: <CAGoCfiy_RVbgq+3WTsC=ZrJsOfDYEWUov6meOU8=ShACBM7J2g@mail.gmail.com>
References: <20110921135604.64363a2e@skate>
	<CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
	<20110922164508.395c2900@skate>
	<CAGoCfiy_RVbgq+3WTsC=ZrJsOfDYEWUov6meOU8=ShACBM7J2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Thu, 22 Sep 2011 11:09:22 -0400,
Devin Heitmueller <dheitmueller@kernellabs.com> a écrit :

> Ok, that is a good start.  I would definitely submit that as a patch
> (including your Signed-off-by line).

Sure, we will definitely do this.

> Regarding the outstanding issue, I believe I did see that and fixed
> it.  Please look the history for the various cx231xx files surrounding
> the time of the ".dont_use_port_3 = 1" fix.  If I recall, that patch
> was actually part of a series of two or three patches which were
> required for that device to work properly.  I believe the other patch
> needed included an extra 10ms msleep call to ensure the hardware is
> powered up fully before issuing certain i2c commands (which are what
> are causing the -71 errors).

I guess you're talking about 44ecf1df9493e6684cd1bb34abb107a0ffe1078a,
which ensures a 10ms msleep call. We don't have this patch, but as with
CONFIG_HZ=100, msleep() calls are anyway rounded up to 10ms, so I'm not
sure this patch will have a huge impact. But we will try.

Then, there is also de99d5328c6d54694471da28711a05adec708c3b, but it
doesn't seem to be related to our problem. But we will also try with
that one.

> If you cannot find it, let me know and I will dig around my archives
> and find it for you (I'm actually at work right now so it would be
> inopportune for me to do it right this minute).

 :-)

Thanks for your very quick feedback!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
