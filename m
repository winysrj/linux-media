Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34156 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759452AbdLRMno (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:43:44 -0500
Subject: Re: [PATCH 1/5] media: rc: update sunxi-ir driver to get base clock
 frequency from devicetree
To: Andi Shyti <andi.shyti@samsung.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
References: <20171217224547.21481-1-embed3d@gmail.com>
 <CGME20171217224555epcas5p3eb77a28e9f3ba4b189c5f275e2d2a679@epcas5p3.samsung.com>
 <20171217224547.21481-2-embed3d@gmail.com>
 <20171218024444.GA9140@gangnam.samsung>
From: Philipp Rossak <embed3d@gmail.com>
Message-ID: <887632f1-6e43-c9d0-c298-0d02b99d2781@gmail.com>
Date: Mon, 18 Dec 2017 13:43:40 +0100
MIME-Version: 1.0
In-Reply-To: <20171218024444.GA9140@gangnam.samsung>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Andi,

thanks for the feedback. I will fix that in the next version of this 
patch series!

On 18.12.2017 03:44, Andi Shyti wrote:
> Hi Philipp,
> 
> just a couple of small nitpicks.
> 
>> +	u32 b_clk_freq;
> 
> [...]
> 
>> +	/* Base clock frequency (optional) */
>> +	if (of_property_read_u32(dn, "clock-frequency", &b_clk_freq)) {
>> +		b_clk_freq = SUNXI_IR_BASE_CLK;
>> +	}
>> +
> 
> how about you intialize 'b_clk_freq' to 'SUNXI_IR_BASE_CLK' and
> just call 'of_property_read_u32' without if statement.
> 'b_clk_freq' value should not be changed if "clock-frequency"
> is not present in the DTS.
> 
> This might avoid misinterpretation from static analyzers that
> might think that 'b_clk_freq' is used uninitialized.
> 
>> +	dev_info(dev, "set base clock frequency to %d Hz.\n", b_clk_freq);
> 
> Please use dev_dbg().
> 
> Andi
> 
--
Philipp
