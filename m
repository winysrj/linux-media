Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34820 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbeABUnu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 15:43:50 -0500
Received: by mail-wm0-f68.google.com with SMTP id a79so7512wma.0
        for <linux-media@vger.kernel.org>; Tue, 02 Jan 2018 12:43:49 -0800 (PST)
Subject: Re: [PATCH 01/33] clk_ops: change round_rate() to return unsigned
 long
To: Stephen Boyd <sboyd@codeaurora.org>
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
References: <1514596392-22270-1-git-send-email-pure.logic@nexus-software.ie>
 <1514596392-22270-2-git-send-email-pure.logic@nexus-software.ie>
 <9f4bef5a-8a71-6f30-5cfb-5e8fe133e3d3@kapsi.fi>
 <6d83a5c3-6589-24bc-4ca5-4d1bbca47432@nexus-software.ie>
 <20180102190159.GH7997@codeaurora.org>
From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Message-ID: <c2212d56-a8b5-cba5-46a7-c2c7f66e752b@nexus-software.ie>
Date: Tue, 2 Jan 2018 20:43:44 +0000
MIME-Version: 1.0
In-Reply-To: <20180102190159.GH7997@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/18 19:01, Stephen Boyd wrote:
> On 12/31, Bryan O'Donoghue wrote:
>> On 30/12/17 16:36, Mikko Perttunen wrote:
>>> FWIW, we had this problem some years ago with the Tegra CPU clock
>>> - then it was determined that a simpler solution was to have the
>>> determine_rate callback support unsigned long rates - so clock
>>> drivers that need to return rates higher than 2^31 can instead
>>> implement the determine_rate callback. That is what's currently
>>> implemented.
>>>
>>> Mikko
>>
>> Granted we could work around it but, having both zero and less than
>> zero indicate error means you can't support larger than LONG_MAX
>> which is I think worth fixing.
>>
> 
> Ok. But can you implement the determine_rate op instead of the
> round_rate op for your clk?

Don't know .

> It's not a work-around, it's the
> preferred solution. That would allow rates larger than 2^31 for
> the clk without pushing through a change to all the drivers to
> express zero as "error" and non-zero as the rounded rate.
> 
> I'm not entirely opposed to this approach, because we probably
> don't care to pass the particular error value from a clk provider
> to a clk consumer about what the error is.

Which was my thought. The return value of clk_ops->round_rate() appears 
not to get pushed up the stack, which is what the last patch in this 
series deals with.

[PATCH 33/33] clk: change handling of round_rate() such that only zero 
is an error

> It's actually what we
> proposed as the solution for clk_round_rate() to return values
> larger than LONG_MAX to consumers. But doing that consumer API
> change or this provider side change is going to require us to
> evaluate all the consumers of these clks to make sure they don't
> check for some error value that's less than zero. This series
> does half the work,

Do you mean users of clk_rounda_rate() ? I have a set of patches for 
that but wanted to separate that from clk_ops->round_rate() so as not to 
send ~70 patches out to LKML at once - even if they are in two blocks.

If so, I can publish that set too for reference.

AFAICT on clk_ops->round_rate the last patch #33 ought to cover the 
usage of the return value of clk_ops->round_rate().

Have I missed something ?

> by changing the provider side, while ignoring
> the consumer side and any potential fallout of the less than zero
> to zero return value change.
> 

Can you look at #33 ? I'm not sure if you saw that one.


---
bod
