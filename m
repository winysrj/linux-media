Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57721 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaGVOow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 10:44:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"andrzej.p@samsung.com" <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] Documentation: devicetree: Document sclk-jpeg clock for exynos3250 SoC
Date: Tue, 22 Jul 2014 16:44:38 +0200
Message-ID: <7786783.sB22HqBgx3@wuerfel>
In-Reply-To: <53CE72B1.4080706@samsung.com>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com> <14970063.d648TVkJj8@wuerfel> <53CE72B1.4080706@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 22 July 2014 16:18:25 Sylwester Nawrocki wrote:
> 
> All right, then I would rephrase it to:
> 
> - clock-names   : should contain:
>                    - "jpeg" for the common gate clock,
>                    - "sclk" for the special clock (only for Exynos3250).
> - clocks        : should contain the clock specifier and clock ID list
>                   matching entries in the clock-names property, according
>                   to the common clock bindings.
> 
> I went through documentation of these clocks in various SoCs' datasheets:
> exynos4210, exynos4212/4412, exynos3250, exynos5250 and I think for all
> SoCs the "jpeg" clock can be referred as "gating all clocks for the IP".
> That means there is a single bit in a CMU register masking all the clocks
> for the IP, I suppose this includes the control bus (APB) clock and the
> IP functional ("special") clock.
> 
> It looks like e.g. exynos4412 also has the SCLK clock, after muxes and
> a divider, so rate can be configured for this clock.  However there is
> no separate gate for SCLK as in case of exynos3250. Thus there is no
> need to to enable/disable the second clock on anything except exynos3250
> currently.
> 
> I think ideally sclk should also be defined for SoCs like exynos4x12,
> exynos5250, even if now drivers are not touching sclk. All in all the
> IP functional clock frequency should be normally set to some known value,
> now we rely on the default divider value which results in divider
> ratio = 1.
> It would break backward compatibility though if we now made sclk
> mandatory. I'm inclined to also specify sclk for exynos4x12, just
> not sure if it should be optional or mandatory.

I'd vote for listing it as an optional clock independent of the compatible
string and changing the driver to just use it when it's provided.

	Arnd
