Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57375 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753008AbdLQXNF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 18:13:05 -0500
Date: Sun, 17 Dec 2017 23:13:02 +0000
From: Sean Young <sean@mess.org>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, p.zabel@pengutronix.de,
        andi.shyti@samsung.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/5] media: rc: update sunxi-ir driver to get base clock
 frequency from devicetree
Message-ID: <20171217231301.tany44vgzeyud2ca@gofer.mess.org>
References: <20171217224547.21481-1-embed3d@gmail.com>
 <20171217224547.21481-2-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171217224547.21481-2-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 17, 2017 at 11:45:43PM +0100, Philipp Rossak wrote:
> This patch updates the sunxi-ir driver to set the base clock frequency from
> devicetree.
> 
> This is neccessary since there are different ir recievers on the
> market, that operate with different frequencys. So this value could be

s/neccessary/necessary/
s/recievers/receivers/
s/frequencys/frequencies/

> set if the attached ir receiver needs an other base clock frequency,
> than the default 8 MHz.

s/other/different/

> 
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  drivers/media/rc/sunxi-cir.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
> index 97f367b446c4..9bbe55a76860 100644
> --- a/drivers/media/rc/sunxi-cir.c
> +++ b/drivers/media/rc/sunxi-cir.c
> @@ -72,12 +72,8 @@
>  /* CIR_REG register idle threshold */
>  #define REG_CIR_ITHR(val)    (((val) << 8) & (GENMASK(15, 8)))
>  
> -/* Required frequency for IR0 or IR1 clock in CIR mode */
> +/* Required frequency for IR0 or IR1 clock in CIR mode (default) */
>  #define SUNXI_IR_BASE_CLK     8000000
> -/* Frequency after IR internal divider  */
> -#define SUNXI_IR_CLK          (SUNXI_IR_BASE_CLK / 64)
> -/* Sample period in ns */
> -#define SUNXI_IR_SAMPLE       (1000000000ul / SUNXI_IR_CLK)
>  /* Noise threshold in samples  */
>  #define SUNXI_IR_RXNOISE      1
>  /* Idle Threshold in samples */
> @@ -122,7 +118,7 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
>  			/* for each bit in fifo */
>  			dt = readb(ir->base + SUNXI_IR_RXFIFO_REG);
>  			rawir.pulse = (dt & 0x80) != 0;
> -			rawir.duration = ((dt & 0x7f) + 1) * SUNXI_IR_SAMPLE;
> +			rawir.duration = ((dt & 0x7f) + 1) * ir->rc->rx_resolution;

Line over 80 characters.

>  			ir_raw_event_store_with_filter(ir->rc, &rawir);
>  		}
>  	}
> @@ -148,6 +144,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	struct device_node *dn = dev->of_node;
>  	struct resource *res;
>  	struct sunxi_ir *ir;
> +	u32 b_clk_freq;
>  
>  	ir = devm_kzalloc(dev, sizeof(struct sunxi_ir), GFP_KERNEL);
>  	if (!ir)
> @@ -172,6 +169,11 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  		return PTR_ERR(ir->clk);
>  	}
>  
> +	/* Base clock frequency (optional) */
> +	if (of_property_read_u32(dn, "clock-frequency", &b_clk_freq)) {
> +		b_clk_freq = SUNXI_IR_BASE_CLK;
> +	}

No braces here please; please use ./scripts/checkpatch.pl to find issues
like this.

> +
>  	/* Reset (optional) */
>  	ir->rst = devm_reset_control_get_optional_exclusive(dev, NULL);
>  	if (IS_ERR(ir->rst))
> @@ -180,11 +182,12 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -	ret = clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
> +	ret = clk_set_rate(ir->clk, b_clk_freq);
>  	if (ret) {
>  		dev_err(dev, "set ir base clock failed!\n");
>  		goto exit_reset_assert;
>  	}
> +	dev_info(dev, "set base clock frequency to %d Hz.\n", b_clk_freq);
>  
>  	if (clk_prepare_enable(ir->apb_clk)) {
>  		dev_err(dev, "try to enable apb_ir_clk failed\n");
> @@ -225,7 +228,8 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
>  	ir->rc->dev.parent = dev;
>  	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
> -	ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
> +	/* Frequency after IR internal divider with sample period in ns */
> +	ir->rc->rx_resolution = (1000000000ul / (b_clk_freq / 64));
>  	ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
>  	ir->rc->driver_name = SUNXI_IR_DEV;
>  
> -- 
> 2.11.0
