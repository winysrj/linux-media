Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50510 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752560AbeERIaQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 04:30:16 -0400
Received: by mail-wm0-f66.google.com with SMTP id t11-v6so12796885wmt.0
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 01:30:15 -0700 (PDT)
References: <20180517125033.18050-1-rui.silva@linaro.org> <20180517125033.18050-4-rui.silva@linaro.org> <152658031035.210890.12212209931570500982@swboyd.mtv.corp.google.com>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        linux-clk@vger.kernel.org
Subject: Re: [PATCH v4 03/12] clk: imx7d: fix mipi dphy div parent
In-reply-to: <152658031035.210890.12212209931570500982@swboyd.mtv.corp.google.com>
Date: Fri, 18 May 2018 09:30:12 +0100
Message-ID: <m3sh6pxt63.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephen,
On Thu 17 May 2018 at 18:05, Stephen Boyd wrote:
> Quoting Rui Miguel Silva (2018-05-17 05:50:24)
>> Fix the mipi dphy root divider to mipi_dphy_pre_div, this would 
>> remove a orphan
>> clock and set the correct parent.
>> 
>> before:
>> cat clk_orphan_summary
>>                                  enable  prepare  protect
>>    clock                          count    count    count 
>>    rate   accuracy   phase
>> ----------------------------------------------------------------------------------------
>>  mipi_dphy_post_div                   1        1        0 
>>  0          0 0
>>     mipi_dphy_root_clk                1        1        0 
>>     0          0 0
>> 
>> cat clk_dump | grep mipi_dphy
>> mipi_dphy_post_div                    1        1        0 
>> 0          0 0
>>     mipi_dphy_root_clk                1        1        0 
>>     0          0 0
>> 
>> after:
>> cat clk_dump | grep mipi_dphy
>>    mipi_dphy_src                     1        1        0 
>>    24000000          0 0
>>        mipi_dphy_cg                  1        1        0 
>>        24000000          0 0
>>           mipi_dphy_pre_div          1        1        0 
>>           24000000          0 0
>>              mipi_dphy_post_div      1        1        0 
>>              24000000          0 0
>>                 mipi_dphy_root_clk   1        1        0 
>>                 24000000          0 0
>> 
>> Fixes: 8f6d8094b215 ("ARM: imx: add imx7d clk tree support")
>> 
>> Cc: linux-clk@vger.kernel.org
>> Acked-by: Dong Aisheng <Aisheng.dong@nxp.com>
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>
> I only get two patches out of the 12 and I don't get a cover 
> letter.
> Did you want me to pick up these clk patches into clk-next? 
> Where are
> the other patches? Can you cc lkml on all your kernel emails so 
> I can
> easily find them?

Yea, sorry, You are right, I will cc all patches to the lists. v5 
is on
the way and I will do that.

---
Cheers,
	Rui
