Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35129 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbeIABm4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 21:42:56 -0400
MIME-Version: 1.0
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com> <1535576973-8067-3-git-send-email-eajames@linux.vnet.ibm.com>
In-Reply-To: <1535576973-8067-3-git-send-email-eajames@linux.vnet.ibm.com>
From: Joel Stanley <joel@jms.id.au>
Date: Fri, 31 Aug 2018 14:33:22 -0700
Message-ID: <CACPK8Xe+aSgFvysXFJaGdSMjG4CsEL6-iy5d79ou1+VFTV_aQw@mail.gmail.com>
Subject: Re: [PATCH 2/4] clock: aspeed: Setup video engine clocking
To: eajames <eajames@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Andrew Jeffery <andrew@aj.id.au>, mchehab@kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-clk@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 29 Aug 2018 at 14:09, Eddie James <eajames@linux.vnet.ibm.com> wrote:
>
> Add the video engine reset bit. Add eclk mux and clock divider table.
>
> Signed-off-by: Eddie James <eajames@linux.vnet.ibm.com>

I'm travelling this week, so I'll be able to take a closer look next week.

At a glance it looks okay.

Cheers,

Joel

> ---
>  drivers/clk/clk-aspeed.c | 41 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clk/clk-aspeed.c b/drivers/clk/clk-aspeed.c
> index 5961367..f16ce7d 100644
> --- a/drivers/clk/clk-aspeed.c
> +++ b/drivers/clk/clk-aspeed.c
> @@ -87,7 +87,7 @@ struct aspeed_clk_gate {
>  /* TODO: ask Aspeed about the actual parent data */
>  static const struct aspeed_gate_data aspeed_gates[] = {
>         /*                               clk rst   name                 parent  flags */
> -       [ASPEED_CLK_GATE_ECLK] =        {  0, -1, "eclk-gate",          "eclk", 0 }, /* Video Engine */
> +       [ASPEED_CLK_GATE_ECLK] =        {  0,  6, "eclk-gate",          "eclk", 0 }, /* Video Engine */
>         [ASPEED_CLK_GATE_GCLK] =        {  1,  7, "gclk-gate",          NULL,   0 }, /* 2D engine */
>         [ASPEED_CLK_GATE_MCLK] =        {  2, -1, "mclk-gate",          "mpll", CLK_IS_CRITICAL }, /* SDRAM */
>         [ASPEED_CLK_GATE_VCLK] =        {  3,  6, "vclk-gate",          NULL,   0 }, /* Video Capture */
> @@ -113,6 +113,24 @@ struct aspeed_clk_gate {
>         [ASPEED_CLK_GATE_LHCCLK] =      { 28, -1, "lhclk-gate",         "lhclk", 0 }, /* LPC master/LPC+ */
>  };
>
> +static const char * const eclk_parent_names[] = {
> +       "mpll",
> +       "hpll",
> +       "dpll",
> +};
> +
> +static const struct clk_div_table ast2500_eclk_div_table[] = {
> +       { 0x0, 2 },
> +       { 0x1, 2 },
> +       { 0x2, 3 },
> +       { 0x3, 4 },
> +       { 0x4, 5 },
> +       { 0x5, 6 },
> +       { 0x6, 7 },
> +       { 0x7, 8 },
> +       { 0 }
> +};
> +
>  static const struct clk_div_table ast2500_mac_div_table[] = {
>         { 0x0, 4 }, /* Yep, really. Aspeed confirmed this is correct */
>         { 0x1, 4 },
> @@ -192,18 +210,21 @@ static struct clk_hw *aspeed_ast2500_calc_pll(const char *name, u32 val)
>
>  struct aspeed_clk_soc_data {
>         const struct clk_div_table *div_table;
> +       const struct clk_div_table *eclk_div_table;
>         const struct clk_div_table *mac_div_table;
>         struct clk_hw *(*calc_pll)(const char *name, u32 val);
>  };
>
>  static const struct aspeed_clk_soc_data ast2500_data = {
>         .div_table = ast2500_div_table,
> +       .eclk_div_table = ast2500_eclk_div_table,
>         .mac_div_table = ast2500_mac_div_table,
>         .calc_pll = aspeed_ast2500_calc_pll,
>  };
>
>  static const struct aspeed_clk_soc_data ast2400_data = {
>         .div_table = ast2400_div_table,
> +       .eclk_div_table = ast2400_div_table,
>         .mac_div_table = ast2400_div_table,
>         .calc_pll = aspeed_ast2400_calc_pll,
>  };
> @@ -317,6 +338,7 @@ struct aspeed_reset {
>         [ASPEED_RESET_PECI]     = 10,
>         [ASPEED_RESET_I2C]      =  2,
>         [ASPEED_RESET_AHB]      =  1,
> +       [ASPEED_RESET_VIDEO]    =  6,
>
>         /*
>          * SCUD4 resets start at an offset to separate them from
> @@ -522,6 +544,22 @@ static int aspeed_clk_probe(struct platform_device *pdev)
>                 return PTR_ERR(hw);
>         aspeed_clk_data->hws[ASPEED_CLK_24M] = hw;
>
> +       hw = clk_hw_register_mux(dev, "eclk-mux", eclk_parent_names,
> +                                ARRAY_SIZE(eclk_parent_names), 0,
> +                                scu_base + ASPEED_CLK_SELECTION, 2, 0x3, 0,
> +                                &aspeed_clk_lock);
> +       if (IS_ERR(hw))
> +               return PTR_ERR(hw);
> +       aspeed_clk_data->hws[ASPEED_CLK_ECLK_MUX] = hw;
> +
> +       hw = clk_hw_register_divider_table(dev, "eclk", "eclk-mux", 0,
> +                                          scu_base + ASPEED_CLK_SELECTION, 28,
> +                                          3, 0, soc_data->eclk_div_table,
> +                                          &aspeed_clk_lock);
> +       if (IS_ERR(hw))
> +               return PTR_ERR(hw);
> +       aspeed_clk_data->hws[ASPEED_CLK_ECLK] = hw;
> +
>         /*
>          * TODO: There are a number of clocks that not included in this driver
>          * as more information is required:
> @@ -531,7 +569,6 @@ static int aspeed_clk_probe(struct platform_device *pdev)
>          *   RGMII
>          *   RMII
>          *   UART[1..5] clock source mux
> -        *   Video Engine (ECLK) mux and clock divider
>          */
>
>         for (i = 0; i < ARRAY_SIZE(aspeed_gates); i++) {
> --
> 1.8.3.1
>
