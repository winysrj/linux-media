Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44402 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbcFETYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2016 15:24:24 -0400
Date: Sun, 5 Jun 2016 21:24:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com,
	Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH v2 1/6] ir-rx51: Fix build after multiarch changes broke
 it
Message-ID: <20160605192419.GA20086@amd>
References: <1463427254-7728-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1463427254-7728-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463427254-7728-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 2016-05-16 22:34:09, Ivaylo Dimitrov wrote:
> From: Tony Lindgren <tony@atomide.com>
> 
> The ir-rx51 driver for n900 has been disabled since the multiarch
> changes as plat include directory no longer is SoC specific.
> 
> Let's fix it with minimal changes to pass the dmtimer calls in
> pdata. Then the following changes can be done while things can
> be tested to be working for each change:
> 
> 1. Change the non-pwm dmtimer to use just hrtimer if possible
> 
> 2. Change the pwm dmtimer to use Linux PWM API with the new
>    drivers/pwm/pwm-omap-dmtimer.c and remove the direct calls
>    to dmtimer functions
> 
> 3. Parse configuration from device tree and drop the pdata
> 
> Note compilation of this depends on the previous patch
> "ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51".
> 
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
