Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750863AbeEAWLe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 18:11:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <20180423134750.30403-4-rui.silva@linaro.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        linux-clk@vger.kernel.org
References: <20180423134750.30403-1-rui.silva@linaro.org>
 <20180423134750.30403-4-rui.silva@linaro.org>
Message-ID: <152521269309.138124.2596659349470455371@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH v2 03/15] clk: imx7d: fix mipi dphy div parent
Date: Tue, 01 May 2018 15:11:33 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Rui Miguel Silva (2018-04-23 06:47:38)
> Fix the mipi dphy root divider to mipi_dphy_pre_div, this would remove a orphan
> clock and set the correct parent.
> 
> before:
> cat clk_orphan_summary
>                                  enable  prepare  protect
>    clock                          count    count    count        rate   accuracy   phase
> ----------------------------------------------------------------------------------------
>  mipi_dphy_post_div                   1        1        0           0          0 0
>     mipi_dphy_root_clk                1        1        0           0          0 0
> 
> cat clk_dump | grep mipi_dphy
> mipi_dphy_post_div                    1        1        0           0          0 0
>     mipi_dphy_root_clk                1        1        0           0          0 0
> 
> after:
> cat clk_dump | grep mipi_dphy
>    mipi_dphy_src                     1        1        0    24000000          0 0
>        mipi_dphy_cg                  1        1        0    24000000          0 0
>           mipi_dphy_pre_div          1        1        0    24000000          0 0
>              mipi_dphy_post_div      1        1        0    24000000          0 0
>                 mipi_dphy_root_clk   1        1        0    24000000          0 0
> 
> Cc: linux-clk@vger.kernel.org
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>

You have double signed-off-by here. Please resend.

Also, add a "Fixes:" tag so we know where to backport this to.
