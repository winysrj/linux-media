Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51089 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbaKTQ3C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 11:29:02 -0500
Date: Thu, 20 Nov 2014 14:28:56 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/9] rc: sunxi-cir: Add support for the larger fifo
 found on sun5i and sun6i
Message-ID: <20141120142856.16b6562d@recife.lan>
In-Reply-To: <1416498928-1300-6-git-send-email-hdegoede@redhat.com>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
	<1416498928-1300-6-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Nov 2014 16:55:24 +0100
Hans de Goede <hdegoede@redhat.com> escreveu:

> Add support for the larger fifo found on sun5i and sun6i, having a separate
> compatible for the ir found on sun5i & sun6i also is useful if we ever want
> to add ir transmit support, because the sun5i & sun6i version do not have
> transmit support.
> 
> Note this commits also adds checking for the end-of-packet interrupt flag
> (which was already enabled), as the fifo-data-available interrupt flag only
> gets set when the trigger-level is exceeded. So far we've been getting away
> with not doing this because of the low trigger-level, but this is something
> which we should have done since day one.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

As this is meant to be merged via some other tree:

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>


> ---
>  .../devicetree/bindings/media/sunxi-ir.txt          |  2 +-
>  drivers/media/rc/sunxi-cir.c                        | 21 ++++++++++++---------
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> index 23dd5ad..5767128 100644
> --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> @@ -1,7 +1,7 @@
>  Device-Tree bindings for SUNXI IR controller found in sunXi SoC family
>  
>  Required properties:
> -- compatible	    : should be "allwinner,sun4i-a10-ir";
> +- compatible	    : "allwinner,sun4i-a10-ir" or "allwinner,sun5i-a13-ir"
>  - clocks	    : list of clock specifiers, corresponding to
>  		      entries in clock-names property;
>  - clock-names	    : should contain "apb" and "ir" entries;
> diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
> index 895fb65..559b0e3 100644
> --- a/drivers/media/rc/sunxi-cir.c
> +++ b/drivers/media/rc/sunxi-cir.c
> @@ -56,12 +56,12 @@
>  #define REG_RXINT_RAI_EN		BIT(4)
>  
>  /* Rx FIFO available byte level */
> -#define REG_RXINT_RAL(val)    (((val) << 8) & (GENMASK(11, 8)))
> +#define REG_RXINT_RAL(val)    ((val) << 8)
>  
>  /* Rx Interrupt Status */
>  #define SUNXI_IR_RXSTA_REG    0x30
>  /* RX FIFO Get Available Counter */
> -#define REG_RXSTA_GET_AC(val) (((val) >> 8) & (GENMASK(5, 0)))
> +#define REG_RXSTA_GET_AC(val) (((val) >> 8) & (ir->fifo_size * 2 - 1))
>  /* Clear all interrupt status value */
>  #define REG_RXSTA_CLEARALL    0xff
>  
> @@ -72,10 +72,6 @@
>  /* CIR_REG register idle threshold */
>  #define REG_CIR_ITHR(val)    (((val) << 8) & (GENMASK(15, 8)))
>  
> -/* Hardware supported fifo size */
> -#define SUNXI_IR_FIFO_SIZE    16
> -/* How many messages in FIFO trigger IRQ */
> -#define TRIGGER_LEVEL         8
>  /* Required frequency for IR0 or IR1 clock in CIR mode */
>  #define SUNXI_IR_BASE_CLK     8000000
>  /* Frequency after IR internal divider  */
> @@ -94,6 +90,7 @@ struct sunxi_ir {
>  	struct rc_dev   *rc;
>  	void __iomem    *base;
>  	int             irq;
> +	int		fifo_size;
>  	struct clk      *clk;
>  	struct clk      *apb_clk;
>  	struct reset_control *rst;
> @@ -115,11 +112,11 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
>  	/* clean all pending statuses */
>  	writel(status | REG_RXSTA_CLEARALL, ir->base + SUNXI_IR_RXSTA_REG);
>  
> -	if (status & REG_RXINT_RAI_EN) {
> +	if (status & (REG_RXINT_RAI_EN | REG_RXINT_RPEI_EN)) {
>  		/* How many messages in fifo */
>  		rc  = REG_RXSTA_GET_AC(status);
>  		/* Sanity check */
> -		rc = rc > SUNXI_IR_FIFO_SIZE ? SUNXI_IR_FIFO_SIZE : rc;
> +		rc = rc > ir->fifo_size ? ir->fifo_size : rc;
>  		/* If we have data */
>  		for (cnt = 0; cnt < rc; cnt++) {
>  			/* for each bit in fifo */
> @@ -156,6 +153,11 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	if (!ir)
>  		return -ENOMEM;
>  
> +	if (of_device_is_compatible(dn, "allwinner,sun5i-a13-ir"))
> +		ir->fifo_size = 64;
> +	else
> +		ir->fifo_size = 16;
> +
>  	/* Clock */
>  	ir->apb_clk = devm_clk_get(dev, "apb");
>  	if (IS_ERR(ir->apb_clk)) {
> @@ -271,7 +273,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>  	 * level
>  	 */
>  	writel(REG_RXINT_ROI_EN | REG_RXINT_RPEI_EN |
> -	       REG_RXINT_RAI_EN | REG_RXINT_RAL(TRIGGER_LEVEL - 1),
> +	       REG_RXINT_RAI_EN | REG_RXINT_RAL(ir->fifo_size / 2 - 1),
>  	       ir->base + SUNXI_IR_RXINT_REG);
>  
>  	/* Enable IR Module */
> @@ -319,6 +321,7 @@ static int sunxi_ir_remove(struct platform_device *pdev)
>  
>  static const struct of_device_id sunxi_ir_match[] = {
>  	{ .compatible = "allwinner,sun4i-a10-ir", },
> +	{ .compatible = "allwinner,sun5i-a13-ir", },
>  	{},
>  };
>  
