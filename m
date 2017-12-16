Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52138 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdLPJTN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 04:19:13 -0500
Date: Sat, 16 Dec 2017 07:18:55 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Philipp Rossak <embed3d@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [RFC 1/5] [media] rc: update sunxi-ir driver to get base
 frequency from devicetree
Message-ID: <20171216071855.0ef43f7b@recife.lan>
In-Reply-To: <20171216024914.7550-2-embed3d@gmail.com>
References: <20171216024914.7550-1-embed3d@gmail.com>
        <20171216024914.7550-2-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 16 Dec 2017 03:49:10 +0100
Philipp Rossak <embed3d@gmail.com> escreveu:

Hi Phillip,

This is not a full review of this patchset. I just want to point you
that you should keep supporting existing DT files.

> This patch updates the sunxi-ir driver to set the ir base clock from
> devicetree.
> 
> This is neccessary since there are different ir recievers on the
> market, that operate with different frequencys. So this value needs to
> be set depending on the attached receiver.

Please don't break backward compatibility with old DT files. In this
specific case, it seems simple enough to be backward-compatible.

> 
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  drivers/media/rc/sunxi-cir.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
> index 97f367b446c4..55b53d6463e9 100644
> --- a/drivers/media/rc/sunxi-cir.c
> +++ b/drivers/media/rc/sunxi-cir.c
> @@ -72,12 +72,6 @@
>  /* CIR_REG register idle threshold */
>  #define REG_CIR_ITHR(val)    (((val) << 8) & (GENMASK(15, 8)))
>  
> -/* Required frequency for IR0 or IR1 clock in CIR mode */
> -#define SUNXI_IR_BASE_CLK     8000000
> -/* Frequency after IR internal divider  */
> -#define SUNXI_IR_CLK          (SUNXI_IR_BASE_CLK / 64)

Keep those to definitions...

> -/* Sample period in ns */
> -#define SUNXI_IR_SAMPLE       (1000000000ul / SUNXI_IR_CLK)
>  /* Noise threshold in samples  */
>  #define SUNXI_IR_RXNOISE      1
>  /* Idle Threshold in samples */
> @@ -122,7 +116,7 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
>  			/* for each bit in fifo */
>  			dt = readb(ir->base + SUNXI_IR_RXFIFO_REG);
>  			rawir.pulse = (dt & 0x80) != 0;
> -			rawir.duration = ((dt & 0x7f) + 1) * SUNXI_IR_SAMPLE;
> +			rawir.duration = ((dt & 0x7f) + 1) * ir->rc->rx_resolution;
>  			ir_raw_event_store_with_filter(ir->rc, &rawir);
>  		}
>  	}
> @@ -148,6 +142,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	struct device_node *dn = dev->of_node;
>  	struct resource *res;
>  	struct sunxi_ir *ir;
> +	u32 b_clk_freq;
>  
>  	ir = devm_kzalloc(dev, sizeof(struct sunxi_ir), GFP_KERNEL);
>  	if (!ir)
> @@ -172,6 +167,12 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  		return PTR_ERR(ir->clk);
>  	}
>  
> +	/* Required frequency for IR0 or IR1 clock in CIR mode */
> +	if (of_property_read_u32(dn, "base-clk-frequency", &b_clk_freq)) {
> +		dev_err(dev, "failed to get ir base clock frequency.\n");
> +		return -ENODATA;
> +	}
> +

And here, instead of returning an error, if the property can't be read, 
it means it is an older DT file. Just default to SUNXI_IR_BASE_CLK. 
This will make it backward-compatible with old DT files that don't have
such property.

Regards,
Mauro


>  	/* Reset (optional) */
>  	ir->rst = devm_reset_control_get_optional_exclusive(dev, NULL);
>  	if (IS_ERR(ir->rst))
> @@ -180,7 +181,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -	ret = clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
> +	ret = clk_set_rate(ir->clk, b_clk_freq);
>  	if (ret) {
>  		dev_err(dev, "set ir base clock failed!\n");
>  		goto exit_reset_assert;
> @@ -225,7 +226,8 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
>  	ir->rc->dev.parent = dev;
>  	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
> -	ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
> +	/* Frequency after IR internal divider with sample period in ns */
> +	ir->rc->rx_resolution = (1000000000ul / (b_clk_freq / 64));
>  	ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
>  	ir->rc->driver_name = SUNXI_IR_DEV;
>  

Thanks,
Mauro
