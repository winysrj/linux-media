Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57476 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbcF3Eup (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 00:50:45 -0400
Date: Wed, 29 Jun 2016 21:49:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
	robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pavel@ucw.cz,
	Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [RESEND PATCH v2 1/5] ir-rx51: Fix build after multiarch changes
 broke it
Message-ID: <20160630044959.GL28140@atomide.com>
References: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1466623341-30130-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <201606231948.51640@pali>
 <57716E27.2040702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57716E27.2040702@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160627 11:22]:
> On 23.06.2016 20:48, Pali Rohár wrote:
> > On Wednesday 22 June 2016 21:22:17 Ivaylo Dimitrov wrote:
> > > The ir-rx51 driver for n900 has been disabled since the multiarch
> > > changes as plat include directory no longer is SoC specific.
> > > 
> > > Let's fix it with minimal changes to pass the dmtimer calls in
> > > pdata. Then the following changes can be done while things can
> > > be tested to be working for each change:
> > > 
> > > 1. Change the non-pwm dmtimer to use just hrtimer if possible
> > > 
> > > 2. Change the pwm dmtimer to use Linux PWM API with the new
> > >     drivers/pwm/pwm-omap-dmtimer.c and remove the direct calls
> > >     to dmtimer functions
> > > 
> > > 3. Parse configuration from device tree and drop the pdata
> > > 
> > > Note compilation of this depends on the previous patch
> > > "ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51".
> > 
> > I think that this extensive description is not needed for commit
> > message. Just for email discussion.
> > 
> 
> I guess Tony can strip the description a bit before applying.

OK I'll leave out the last paragraph as that already got merged
earlier.

Tony
