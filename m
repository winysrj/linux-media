Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751889AbeECC1b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:27:31 -0400
Date: Thu, 3 May 2018 10:27:16 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Subject: Re: [PATCH v2 04/15] clk: imx7d: reset parent for mipi csi root
Message-ID: <20180503022714.GO3443@dragon>
References: <20180423134750.30403-1-rui.silva@linaro.org>
 <20180423134750.30403-5-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423134750.30403-5-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 02:47:39PM +0100, Rui Miguel Silva wrote:
> To guarantee that we do not get Overflow in image FIFO the outer bandwidth has
> to be faster than inputer bandwidth. For that it must be possible to set a
> faster frequency clock. So set new parent to sys_pfd3 clock for the mipi csi
> block.
> 
> Cc: linux-clk@vger.kernel.org
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/clk/imx/clk-imx7d.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/clk/imx/clk-imx7d.c b/drivers/clk/imx/clk-imx7d.c
> index f7f4db2e6fa6..9a1a18ceb132 100644
> --- a/drivers/clk/imx/clk-imx7d.c
> +++ b/drivers/clk/imx/clk-imx7d.c
> @@ -891,6 +891,9 @@ static void __init imx7d_clocks_init(struct device_node *ccm_node)
>  	clk_set_parent(clks[IMX7D_PLL_AUDIO_MAIN_BYPASS], clks[IMX7D_PLL_AUDIO_MAIN]);
>  	clk_set_parent(clks[IMX7D_PLL_VIDEO_MAIN_BYPASS], clks[IMX7D_PLL_VIDEO_MAIN]);
>  
> +	clk_set_parent(clks[IMX7D_MIPI_CSI_ROOT_SRC],
> +		       clks[IMX7D_PLL_SYS_PFD3_CLK]);
> +

For i.MX clock driver, we intentionally ignore line over 80 columns
warning to make the file easier for read.  So I would suggest you keep
it on a single line to stay consistent with other clk_set_parent() calls.

Other than that,

Acked-by: Shawn Guo <shawnguo@kernel.org>

>  	/* use old gpt clk setting, gpt1 root clk must be twice as gpt counter freq */
>  	clk_set_parent(clks[IMX7D_GPT1_ROOT_SRC], clks[IMX7D_OSC_24M_CLK]);
>  
> -- 
> 2.17.0
> 
