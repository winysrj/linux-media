Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbeABTCC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 14:02:02 -0500
Date: Tue, 2 Jan 2018 11:01:59 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Mikko Perttunen <cyndis@kapsi.fi>, mturquette@baylibre.com,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linux-rpi-kernel@lists.infradead.org,
        patches@opensource.cirrus.com,
        uclinux-h8-devel@lists.sourceforge.jp,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org,
        freedreno@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org
Subject: Re: [PATCH 01/33] clk_ops: change round_rate() to return unsigned
 long
Message-ID: <20180102190159.GH7997@codeaurora.org>
References: <1514596392-22270-1-git-send-email-pure.logic@nexus-software.ie>
 <1514596392-22270-2-git-send-email-pure.logic@nexus-software.ie>
 <9f4bef5a-8a71-6f30-5cfb-5e8fe133e3d3@kapsi.fi>
 <6d83a5c3-6589-24bc-4ca5-4d1bbca47432@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d83a5c3-6589-24bc-4ca5-4d1bbca47432@nexus-software.ie>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/31, Bryan O'Donoghue wrote:
> On 30/12/17 16:36, Mikko Perttunen wrote:
> >FWIW, we had this problem some years ago with the Tegra CPU clock
> >- then it was determined that a simpler solution was to have the
> >determine_rate callback support unsigned long rates - so clock
> >drivers that need to return rates higher than 2^31 can instead
> >implement the determine_rate callback. That is what's currently
> >implemented.
> >
> >Mikko
> 
> Granted we could work around it but, having both zero and less than
> zero indicate error means you can't support larger than LONG_MAX
> which is I think worth fixing.
> 

Ok. But can you implement the determine_rate op instead of the
round_rate op for your clk? It's not a work-around, it's the
preferred solution. That would allow rates larger than 2^31 for
the clk without pushing through a change to all the drivers to
express zero as "error" and non-zero as the rounded rate.

I'm not entirely opposed to this approach, because we probably
don't care to pass the particular error value from a clk provider
to a clk consumer about what the error is. It's actually what we
proposed as the solution for clk_round_rate() to return values
larger than LONG_MAX to consumers. But doing that consumer API
change or this provider side change is going to require us to
evaluate all the consumers of these clks to make sure they don't
check for some error value that's less than zero. This series
does half the work, by changing the provider side, while ignoring
the consumer side and any potential fallout of the less than zero
to zero return value change.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
