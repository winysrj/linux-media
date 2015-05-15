Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:35040 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934332AbbEOPk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 11:40:56 -0400
Date: Fri, 15 May 2015 17:40:48 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>,
	Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
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
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-mips@linux-mips.org, patches@opensource.wolfsonmicro.com,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, spear-devel@list.st.com,
	linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH v2 1/2] clk: change clk_ops' ->round_rate() prototype
Message-ID: <20150515174048.4a31af49@bbrezillon>
In-Reply-To: <20150507093702.0b58753d@bbrezillon>
References: <1430407809-31147-1-git-send-email-boris.brezillon@free-electrons.com>
	<1430407809-31147-2-git-send-email-boris.brezillon@free-electrons.com>
	<20150507063953.GC32399@codeaurora.org>
	<20150507093702.0b58753d@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephen,

Adding Mikko in the loop (after all, he was the one complaining about
this signed long limitation in the first place, and I forgot to add
him in the Cc list :-/).

Mikko, are you okay with the approach proposed by Stephen (adding a
new method) ?

On Thu, 7 May 2015 09:37:02 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Hi Stephen,
> 
> On Wed, 6 May 2015 23:39:53 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> > On 04/30, Boris Brezillon wrote:
> > > Clock rates are stored in an unsigned long field, but ->round_rate()
> > > (which returns a rounded rate from a requested one) returns a long
> > > value (errors are reported using negative error codes), which can lead
> > > to long overflow if the clock rate exceed 2Ghz.
> > > 
> > > Change ->round_rate() prototype to return 0 or an error code, and pass the
> > > requested rate as a pointer so that it can be adjusted depending on
> > > hardware capabilities.
> > > 
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > Tested-by: Heiko Stuebner <heiko@sntech.de>
> > > Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > 
> > This patch is fairly invasive, and it probably doesn't even
> > matter for most of these clock providers to be able to round a
> > rate above 2GHz.
> 
> Fair enough.
> 
> > I've been trying to remove the .round_rate op
> > from the framework by encouraging new features via the
> > .determine_rate op.
> 
> Oh, I wasn't aware of that (BTW, that's a good thing).
> Maybe this should be clearly stated (both in the struct clk_ops
> kerneldoc header and in Documentation/clk.txt).
> 
> > Sadly, we still have to do a flag day and
> > change all the .determine_rate ops when we want to add things.
> 
> Yes, but the number of clk drivers implementing ->determine_rate() is
> still quite limited compared to those implementing ->round_rate().
> 
> > 
> > What if we changed determine_rate ops to take a struct
> > clk_determine_info (or some better named structure) instead of
> > the current list of arguments that it currently takes? Then when
> > we want to make these sorts of framework wide changes we can just
> > throw a new member into that structure and be done.
> 
> I really like this idea, especially since I was wondering if we could
> pass other 'clk rate requirements' like the rounding policy (down,
> closest, up), or the maximum clk inaccuracy.
> 
> > 
> > It doesn't solve the unsigned long to int return value problem
> > though. We can solve that by gradually introducing a new op and
> > handling another case in the rounding path. If we can come up
> > with some good name for that new op like .decide_rate or
> > something then it makes things nicer in the long run. I like the
> > name .determine_rate though :/

Okay, if you want a new method, how about this one:

struct clk_adjust_rate_req {
	/* fields filled by the caller */
	unsigned long rate; /* rate is updated by the clk driver */
	unsigned long min;
	unsigned long max;

	/* fields filled by the clk driver */
	struct clk_hw *best_parent;
	unsigned long best_parent_rate;

	/*
	 * new fields I'd like to add at some point:
	 * unsigned long max_inaccuracy;
	 * something about the power consumption constraints :-)
	 */
};

int (*adjust_rate)(struct clk_hw *hw, struct clk_adjust_rate_req *req);

> 
> Why not changing the ->determine_rate() prototype. As said above, the
> number of clk drivers implementing this function is still quite
> limited, and I guess we can have an ack for all of them.
> 
> > 
> > The benefit of all this is that we don't have to worry about
> > finding the random clk providers that get added into other
> > subsystems and fixing them up. If drivers actually care about
> > this problem then they'll be fixed to use the proper op. FYI,
> > last time we updated the function signature of .determine_rate we
> > broke a couple drivers along the way.
> > 
> 
> Hm, IMHO, adding a new op is not a good thing. I agree that it eases
> the transition, but ITOH you'll have to live with old/deprecated ops in
> your clk_ops structure with people introducing new drivers still using
> the old ops (see the number of clk drivers implementing ->round_rate()
> instead of ->determine_rate()).
> 
> Best Regards,
> 
> Boris
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
