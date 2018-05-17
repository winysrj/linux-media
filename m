Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751907AbeEQSFL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 14:05:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <20180517125033.18050-4-rui.silva@linaro.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        linux-clk@vger.kernel.org
References: <20180517125033.18050-1-rui.silva@linaro.org>
 <20180517125033.18050-4-rui.silva@linaro.org>
Message-ID: <152658031035.210890.12212209931570500982@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH v4 03/12] clk: imx7d: fix mipi dphy div parent
Date: Thu, 17 May 2018 11:05:10 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Rui Miguel Silva (2018-05-17 05:50:24)
> Fix the mipi dphy root divider to mipi_dphy_pre_div, this would remove a =
orphan
> clock and set the correct parent.
> =

> before:
> cat clk_orphan_summary
>                                  enable  prepare  protect
>    clock                          count    count    count        rate   a=
ccuracy   phase
> -------------------------------------------------------------------------=
---------------
>  mipi_dphy_post_div                   1        1        0           0    =
      0 0
>     mipi_dphy_root_clk                1        1        0           0    =
      0 0
> =

> cat clk_dump | grep mipi_dphy
> mipi_dphy_post_div                    1        1        0           0    =
      0 0
>     mipi_dphy_root_clk                1        1        0           0    =
      0 0
> =

> after:
> cat clk_dump | grep mipi_dphy
>    mipi_dphy_src                     1        1        0    24000000     =
     0 0
>        mipi_dphy_cg                  1        1        0    24000000     =
     0 0
>           mipi_dphy_pre_div          1        1        0    24000000     =
     0 0
>              mipi_dphy_post_div      1        1        0    24000000     =
     0 0
>                 mipi_dphy_root_clk   1        1        0    24000000     =
     0 0
> =

> Fixes: 8f6d8094b215 ("ARM: imx: add imx7d clk tree support")
> =

> Cc: linux-clk@vger.kernel.org
> Acked-by: Dong Aisheng <Aisheng.dong@nxp.com>
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---

I only get two patches out of the 12 and I don't get a cover letter.
Did you want me to pick up these clk patches into clk-next? Where are
the other patches? Can you cc lkml on all your kernel emails so I can
easily find them?
