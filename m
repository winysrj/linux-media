Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:46562 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087AbbDSPaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2015 11:30:14 -0400
Date: Sun, 19 Apr 2015 17:30:06 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
	Mikko Perttunen <mikko.perttunen@kapsi.fi>,
	Jonathan Corbet <corbet@lwn.net>,
	Shawn Guo <shawn.guo@linaro.org>,
	ascha Hauer <kernel@pengutronix.de>,
	David Brown <davidb@codeaurora.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Bryan Huntsman <bryanh@codeaurora.org>,
	Tony Lindgren <tony@atomide.com>,
	Paul Walmsley <paul@pwsan.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Viresh Kumar <viresh.linux@gmail.com>,
	Emilio =?UTF-8?B?TMOzcGV6?= <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Peter De Schrijver <pdeschrijver@nvidia.com>,
	Prashant Gaikwad <pgaikwad@nvidia.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Alexandre Courbot <gnurou@gmail.com>,
	Tero Kristo <t-kristo@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Michal Simek <michal.simek@xilinx.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-mips@linux-mips.org, patches@opensource.wolfsonmicro.com,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, spear-devel@list.st.com,
	linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/2] clk: change clk_ops' ->round_rate() prototype
Message-ID: <20150419173006.0ce6cfe0@bbrezillon>
In-Reply-To: <7408975.lBcgZIN9hf@diego>
References: <1429255769-13639-1-git-send-email-boris.brezillon@free-electrons.com>
	<1429255769-13639-2-git-send-email-boris.brezillon@free-electrons.com>
	<7408975.lBcgZIN9hf@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Heiko,

On Sun, 19 Apr 2015 14:13:04 +0200
Heiko Stübner <heiko@sntech.de> wrote:

> Hi Boris,
> 
> Am Freitag, 17. April 2015, 09:29:28 schrieb Boris Brezillon:
> > Clock rates are stored in an unsigned long field, but ->round_rate()
> > (which returns a rounded rate from a requested one) returns a long
> > value (errors are reported using negative error codes), which can lead
> > to long overflow if the clock rate exceed 2Ghz.
> > 
> > Change ->round_rate() prototype to return 0 or an error code, and pass the
> > requested rate as a pointer so that it can be adjusted depending on
> > hardware capabilities.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> 
> On a rk3288-veyron-pinky with the fix described below:
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> 
> 
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index fa5a00e..1462ddc 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -1640,8 +1643,10 @@ static struct clk_core *clk_calc_new_rates(struct
> > clk_core *clk, &parent_hw);
> >  		parent = parent_hw ? parent_hw->core : NULL;
> >  	} else if (clk->ops->round_rate) {
> > -		new_rate = clk->ops->round_rate(clk->hw, rate,
> > -						&best_parent_rate);
> > +		if (clk->ops->round_rate(clk->hw, &new_rate,
> > +					 &best_parent_rate))
> > +			return NULL;
> > +
> >  		if (new_rate < min_rate || new_rate > max_rate)
> >  			return NULL;
> >  	} else if (!parent || !(clk->flags & CLK_SET_RATE_PARENT)) {
> 
> This is using new_rate uninitialized when calling into the round_rate
> callback. Which in turn pushed my PLLs up to 2.2GHz :-)

Indeed, thanks for the fix.

[...]

> 
> 
> And as I've stumbled onto this recently too, the clock-maintainership has
> expanded to Stephen Boyd and linux-clk@vger.kernel.org .

Noted. I'll add Stephen and the new linux-clk ML in the recipient list
next time.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
