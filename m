Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42785 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757738AbdLRCos (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 21:44:48 -0500
Date: Mon, 18 Dec 2017 11:44:44 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/5] media: rc: update sunxi-ir driver to get base clock
 frequency from devicetree
Message-id: <20171218024444.GA9140@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20171217224547.21481-2-embed3d@gmail.com>
References: <20171217224547.21481-1-embed3d@gmail.com>
        <CGME20171217224555epcas5p3eb77a28e9f3ba4b189c5f275e2d2a679@epcas5p3.samsung.com>
        <20171217224547.21481-2-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

just a couple of small nitpicks.

> +	u32 b_clk_freq;

[...]

> +	/* Base clock frequency (optional) */
> +	if (of_property_read_u32(dn, "clock-frequency", &b_clk_freq)) {
> +		b_clk_freq = SUNXI_IR_BASE_CLK;
> +	}
> +

how about you intialize 'b_clk_freq' to 'SUNXI_IR_BASE_CLK' and
just call 'of_property_read_u32' without if statement.
'b_clk_freq' value should not be changed if "clock-frequency"
is not present in the DTS.

This might avoid misinterpretation from static analyzers that
might think that 'b_clk_freq' is used uninitialized.

> +	dev_info(dev, "set base clock frequency to %d Hz.\n", b_clk_freq);

Please use dev_dbg().

Andi
