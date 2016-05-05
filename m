Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:53402 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbcEERLX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2016 13:11:23 -0400
Date: Thu, 5 May 2016 10:11:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machel <pavel@ucw.cz>,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH 0/2] Fix ir-rx51 by using PWM pdata
Message-ID: <20160505171119.GZ5995@atomide.com>
References: <1461714709-10455-1-git-send-email-tony@atomide.com>
 <57227E63.4040907@gmail.com>
 <20160428212748.GI5995@atomide.com>
 <5724F0CB.6060807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5724F0CB.6060807@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160430 10:53]:
> Hi,
> 
> On 29.04.2016 00:27, Tony Lindgren wrote:
> >* Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160428 14:21]:
> >>
> >>I didn't test legacy boot, as I don't really see any value of doing it now
> >>the end of the legacy boot is near, the driver does not function correctly,
> >>however the patchset at least allows for the driver to be build and we have
> >>something to improve on. And I am going to send a patch that fixes the
> >>problem with omap_dm_timer_request_specific(). So, for both patches, you may
> >>add:
> >>
> >>Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> >
> >OK thanks.
> >
> >Mauro, do the driver changes look OK to you?
> >
> >If so, I could queue the driver too for v4.7 because of the
> >dependency with your ack. Or I can provide you an immutable
> >branch with just the pdata changes against v4.6-rc1 if you
> >prefer that.
> >

Mauro, I've applied the pdata patch only into my omap-for-v4.7/legacy branch.
Feel free to merge immutable commit against v4.6-rc1 which is 8453c5cafd32
("ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51") to your tree
also for v4.7 if you decide to apply the ir-rx51 driver changes. Else we need
to wait for v4.7-rc1 :)

> In the meanwhile I was able to make the driver functional (on top of the
> $subject series) - for that purpose I had to fix dmtimer.c - it turns out
> that PM runtime get()/put() is called in almost every function exported by
> dmtimer, which in turn slows down IR transmission to 4-5s instead of 0.5s. I
> also replaced GPT9 dmtimer with PWM framework API (pwm-omap-dmtimer needs a
> patch) and implemented some DT support.
> 
> Now, how shall I proceed with those - wait for the $subject series to be
> accepted or post the patches now?

Best to do incremental patches on what was posted to avoid confusion.

> Tony, I was unable to find the tree on kernel.org your patches are in. Which
> tree to use to base my patches on?

The pdata changes are in Linux next with omap-for-v4.7/legacy, the driver
changes I have not committed into any upstream going tree. Seems like
Mauro can take it after merging in commit 8453c5cafd32.

Regards,

Tony
