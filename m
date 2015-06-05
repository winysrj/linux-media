Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52706 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751433AbbFELjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 07:39:36 -0400
Date: Fri, 5 Jun 2015 13:39:28 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Paul Walmsley <paul@pwsan.com>,
	Mike Turquette <mturquette@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>,
	<linux-clk@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shawn Guo <shawn.guo@linaro.org>,
	ascha Hauer <kernel@pengutronix.de>,
	David Brown <davidb@codeaurora.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Bryan Huntsman <bryanh@codeaurora.org>,
	Tony Lindgren <tony@atomide.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
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
	<linux-doc@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mips@linux-mips.org>, <patches@opensource.wolfsonmicro.com>,
	<linux-rockchip@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <spear-devel@list.st.com>,
	<linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-media@vger.kernel.org>, <rtc-linux@googlegroups.com>
Subject: Re: [PATCH v2 1/2] clk: change clk_ops' ->round_rate() prototype
Message-ID: <20150605133928.66909901@bbrezillon>
In-Reply-To: <557161D1.3040107@nvidia.com>
References: <1430407809-31147-1-git-send-email-boris.brezillon@free-electrons.com>
 <1430407809-31147-2-git-send-email-boris.brezillon@free-electrons.com>
 <alpine.DEB.2.02.1506042258530.12316@utopia.booyaka.com>
 <557161D1.3040107@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On Fri, 5 Jun 2015 09:46:09 +0100
Jon Hunter <jonathanh@nvidia.com> wrote:

> 
> On 05/06/15 00:02, Paul Walmsley wrote:
> > Hi folks
> > 
> > just a brief comment on this one:
> > 
> > On Thu, 30 Apr 2015, Boris Brezillon wrote:
> > 
> >> Clock rates are stored in an unsigned long field, but ->round_rate()
> >> (which returns a rounded rate from a requested one) returns a long
> >> value (errors are reported using negative error codes), which can lead
> >> to long overflow if the clock rate exceed 2Ghz.
> >>
> >> Change ->round_rate() prototype to return 0 or an error code, and pass the
> >> requested rate as a pointer so that it can be adjusted depending on
> >> hardware capabilities.
> > 
> > ...
> > 
> >> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> >> index 0e4f90a..fca8b7a 100644
> >> --- a/Documentation/clk.txt
> >> +++ b/Documentation/clk.txt
> >> @@ -68,8 +68,8 @@ the operations defined in clk.h:
> >>  		int		(*is_enabled)(struct clk_hw *hw);
> >>  		unsigned long	(*recalc_rate)(struct clk_hw *hw,
> >>  						unsigned long parent_rate);
> >> -		long		(*round_rate)(struct clk_hw *hw,
> >> -						unsigned long rate,
> >> +		int		(*round_rate)(struct clk_hw *hw,
> >> +						unsigned long *rate,
> >>  						unsigned long *parent_rate);
> >>  		long		(*determine_rate)(struct clk_hw *hw,
> >>  						unsigned long rate,
> > 
> > I'd suggest that we should probably go straight to 64-bit rates.  There 
> > are already plenty of clock sources that can generate rates higher than 
> > 4GiHz.
> 
> An alternative would be to introduce to a frequency "base" the default
> could be Hz (for backwards compatibility), but for CPUs we probably only
> care about MHz (or may be kHz) and so 32-bits would still suffice. Even
> if CPUs cared about Hz they could still use Hz, but in that case they
> probably don't care about GHz. Obviously, we don't want to break DT
> compatibility but may be the frequency base could be defined in DT and
> if it is missing then Hz is assumed. Just a thought ...

Yes, but is it really worth the additional complexity. You'll have to
add the unit information anyway, so using an unsigned long for the
value and another field for the unit (an enum ?) is just like using a
64 bit integer.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
