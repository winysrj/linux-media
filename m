Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:57402 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaH1QWg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 12:22:36 -0400
Date: Thu, 28 Aug 2014 17:22:31 +0100
From: Sean Young <sean@mess.org>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, arnd@arndb.de,
	haifeng.yan@linaro.org, jchxue@gmail.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Guoxiong Yan <yanguoxiong@huawei.com>
Subject: Re: [PATCH v3 2/3] rc: Introduce hix5hd2 IR transmitter driver
Message-ID: <20140828162231.GA3429@gofer.mess.org>
References: <1409238977-19444-1-git-send-email-zhangfei.gao@linaro.org>
 <1409238977-19444-3-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409238977-19444-3-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 28, 2014 at 11:16:16PM +0800, Zhangfei Gao wrote:
> From: Guoxiong Yan <yanguoxiong@huawei.com>
> 
> IR transmitter driver for Hisilicon hix5hd2 soc
> 
> By default all protocols are disabled.
> For example nec decoder can be enabled by either
> 1. ir-keytable -p nec
> 2. echo nec > /sys/class/rc/rc0/protocols
> See see Documentation/ABI/testing/sysfs-class-rc

I'm not sure that's true any more. All protocols are enabled, right?

> 
> Signed-off-by: Guoxiong Yan <yanguoxiong@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  drivers/media/rc/Kconfig      |   11 ++
>  drivers/media/rc/Makefile     |    1 +
>  drivers/media/rc/ir-hix5hd2.c |  351 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 363 insertions(+)
>  create mode 100644 drivers/media/rc/ir-hix5hd2.c
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 5e626af..64dc8bb 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -164,6 +164,17 @@ config IR_ENE
>  	   To compile this driver as a module, choose M here: the
>  	   module will be called ene_ir.
>  
> +config IR_HIX5HD2
> +	tristate "Hisilicon hix5hd2 IR remote control"
> +	depends on RC_CORE
> +	help
> +	 Say Y here if you want to use hisilicon remote control.
> +	 The driver passes raw pulse and space information to the LIRC decoder.
> +	 To compile this driver as a module, choose M here: the module will be
> +	 called hisi_ir.

The module won't be called that.

> +
> +	 If you're not sure, select N here
> +
>  config IR_IMON
>  	tristate "SoundGraph iMON Receiver and Display"
>  	depends on USB_ARCH_HAS_HCD
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 9f9843a1..0989f94 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
>  
>  # stand-alone IR receivers/transmitters
>  obj-$(CONFIG_RC_ATI_REMOTE) += ati_remote.o
> +obj-$(CONFIG_IR_HIX5HD2) += ir-hix5hd2.o
>  obj-$(CONFIG_IR_IMON) += imon.o
>  obj-$(CONFIG_IR_ITE_CIR) += ite-cir.o
>  obj-$(CONFIG_IR_MCEUSB) += mceusb.o
> diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
> new file mode 100644
> index 0000000..1839709
> --- /dev/null
> +++ b/drivers/media/rc/ir-hix5hd2.c
> @@ -0,0 +1,351 @@
> +/*
> + * Copyright (c) 2014 Linaro Ltd.
> + * Copyright (c) 2014 Hisilicon Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/regmap.h>
> +#include <media/rc-core.h>
> +
> +#define IR_ENABLE		0x00
> +#define IR_CONFIG		0x04
> +#define CNT_LEADS		0x08
> +#define CNT_LEADE		0x0c
> +#define CNT_SLEADE		0x10
> +#define CNT0_B			0x14
> +#define CNT1_B			0x18
> +#define IR_BUSY			0x1c
> +#define IR_DATAH		0x20
> +#define IR_DATAL		0x24
> +#define IR_INTM			0x28
> +#define IR_INTS			0x2c
> +#define IR_INTC			0x30
> +#define IR_START		0x34
> +
> +/* interrupt mask */
> +#define INTMS_SYMBRCV		(BIT(24) | BIT(8))
> +#define INTMS_TIMEOUT		(BIT(25) | BIT(9))
> +#define INTMS_OVERFLOW		(BIT(26) | BIT(10))
> +#define INT_CLR_OVERFLOW	BIT(18)
> +#define INT_CLR_TIMEOUT		BIT(17)
> +#define INT_CLR_RCV		BIT(16)
> +#define INT_CLR_RCVTIMEOUT	(BIT(16) | BIT(17))
> +
> +#define IR_CLK			0x48
> +#define IR_CLK_ENABLE		BIT(4)
> +#define IR_CLK_RESET		BIT(5)
> +
> +#define IR_CFG_WIDTH_MASK	0xffff
> +#define IR_CFG_WIDTH_SHIFT	16
> +#define IR_CFG_FORMAT_MASK	0x3
> +#define IR_CFG_FORMAT_SHIFT	14
> +#define IR_CFG_INT_LEVEL_MASK	0x3f
> +#define IR_CFG_INT_LEVEL_SHIFT	8
> +/* only support raw mode */
> +#define IR_CFG_MODE_RAW		BIT(7)
> +#define IR_CFG_FREQ_MASK	0x7f
> +#define IR_CFG_FREQ_SHIFT	0
> +#define IR_CFG_INT_THRESHOLD	1
> +/* symbol start from low to high, symbol stream end at high*/
> +#define IR_CFG_SYMBOL_FMT	0
> +#define IR_CFG_SYMBOL_MAXWIDTH	0x3e80
> +
> +#define IR_HIX5HD2_NAME		"hix5hd2-ir"
> +
> +struct hix5hd2_ir_priv {
> +	int			irq;
> +	void			*base;
> +	struct device		*dev;
> +	struct rc_dev		*rdev;
> +	struct regmap		*regmap;
> +	struct clk		*clock;
> +	const char		*map_name;

map_name member is only assigned, it's unused.

> +	unsigned long		rate;
> +};
> +
> +static void hix5hd2_ir_send_lirc_timeout(struct rc_dev *rdev)
> +{
> +	DEFINE_IR_RAW_EVENT(ev);
> +
> +	ev.timeout = true;
> +	ir_raw_event_store(rdev, &ev);
> +}
> +
> +static irqreturn_t hix5hd2_ir_rx_interrupt(int irq, void *data)
> +{
> +	u32 symb_num, symb_val, symb_time;
> +	u32 data_l, data_h;
> +	u32 irq_sr, i;
> +	struct hix5hd2_ir_priv *priv = data;
> +
> +	irq_sr = readl_relaxed(priv->base + IR_INTS);
> +	if (irq_sr & INTMS_OVERFLOW) {
> +		/*
> +		 * we must read IR_DATAL first, then we can clean up
> +		 * IR_INTS availably since logic would not clear
> +		 * fifo when overflow, drv do the job
> +		 */
> +		ir_raw_event_reset(priv->rdev);
> +		symb_num = readl_relaxed(priv->base + IR_DATAH);
> +		for (i = 0; i < symb_num; i++)
> +			readl_relaxed(priv->base + IR_DATAL);
> +
> +		writel_relaxed(INT_CLR_OVERFLOW, priv->base + IR_INTC);
> +		dev_info(priv->dev, "overflow, level=%d\n",
> +			 IR_CFG_INT_THRESHOLD);
> +	}
> +
> +	if ((irq_sr & INTMS_SYMBRCV) || (irq_sr & INTMS_TIMEOUT)) {
> +		DEFINE_IR_RAW_EVENT(ev);
> +
> +		symb_num = readl_relaxed(priv->base + IR_DATAH);
> +		for (i = 0; i < symb_num; i++) {
> +			symb_val = readl_relaxed(priv->base + IR_DATAL);
> +			data_l = ((symb_val & 0xffff) * 10);
> +			data_h =  ((symb_val >> 16) & 0xffff) * 10;
> +			symb_time = (data_l + data_h) / 10;
> +
> +			ev.duration = US_TO_NS(data_l);
> +			ev.pulse = true;
> +			ir_raw_event_store(priv->rdev, &ev);
> +
> +			if (symb_time < IR_CFG_SYMBOL_MAXWIDTH) {
> +				ev.duration = US_TO_NS(data_h);
> +				ev.pulse = false;
> +				ir_raw_event_store(priv->rdev, &ev);
> +			} else {
> +				hix5hd2_ir_send_lirc_timeout(priv->rdev);

Surely this is when IR goes idle.

				ir_raw_event_set_idle(priv->rdev, true);

This will set up idle processing and send the timeout IR event.

> +			}
> +		}
> +
> +		if (irq_sr & INTMS_SYMBRCV)
> +			writel_relaxed(INT_CLR_RCV, priv->base + IR_INTC);
> +		if (irq_sr & INTMS_TIMEOUT)
> +			writel_relaxed(INT_CLR_TIMEOUT, priv->base + IR_INTC);
> +	}
> +
> +	/* Empty software fifo */
> +	ir_raw_event_handle(priv->rdev);
> +	return IRQ_HANDLED;
> +}
> +
> +static void hix5hd2_ir_enable(struct hix5hd2_ir_priv *dev, bool on)
> +{
> +	u32 val;
> +
> +	regmap_read(dev->regmap, IR_CLK, &val);
> +	if (on) {
> +		val &= ~IR_CLK_RESET;
> +		val |= IR_CLK_ENABLE;
> +	} else {
> +		val &= ~IR_CLK_ENABLE;
> +		val |= IR_CLK_RESET;
> +	}
> +	regmap_write(dev->regmap, IR_CLK, val);
> +}
> +
> +static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
> +{
> +	int timeout = 10000;
> +	u32 val, rate;
> +
> +	writel_relaxed(0x01, priv->base + IR_ENABLE);
> +	while (readl_relaxed(priv->base + IR_BUSY)) {
> +		if (timeout--) {
> +			udelay(1);
> +		} else {
> +			dev_err(priv->dev, "IR_BUSY timeout\n");
> +			return -ETIMEDOUT;
> +		}
> +	}
> +
> +	/* Now only support raw mode, with symbol start from low to high */
> +	rate = DIV_ROUND_CLOSEST(priv->rate, 1000000);
> +	val = IR_CFG_SYMBOL_MAXWIDTH & IR_CFG_WIDTH_MASK << IR_CFG_WIDTH_SHIFT;
> +	val |= IR_CFG_SYMBOL_FMT & IR_CFG_FORMAT_MASK << IR_CFG_FORMAT_SHIFT;
> +	val |= (IR_CFG_INT_THRESHOLD - 1) & IR_CFG_INT_LEVEL_MASK
> +	       << IR_CFG_INT_LEVEL_SHIFT;
> +	val |= IR_CFG_MODE_RAW;
> +	val |= (rate - 1) & IR_CFG_FREQ_MASK << IR_CFG_FREQ_SHIFT;
> +	writel_relaxed(val, priv->base + IR_CONFIG);
> +
> +	writel_relaxed(0x00, priv->base + IR_INTM);
> +	/* write arbitrary value to start  */
> +	writel_relaxed(0x01, priv->base + IR_START);
> +	return 0;
> +}
> +
> +static int hix5hd2_ir_open(struct rc_dev *rdev)
> +{
> +	struct hix5hd2_ir_priv *priv = rdev->priv;
> +
> +	hix5hd2_ir_enable(priv, true);
> +	hix5hd2_ir_config(priv);

hix5hd2_ir_config can fail, the error can be returned to userspace rather 
than silently failing.

> +	return 0;
> +}
> +
> +static void hix5hd2_ir_close(struct rc_dev *rdev)
> +{
> +	struct hix5hd2_ir_priv *priv = rdev->priv;
> +
> +	hix5hd2_ir_enable(priv, false);
> +}
> +
> +static struct of_device_id hix5hd2_ir_table[] = {
> +	{ .compatible = "hisilicon,hix5hd2-ir", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, hix5hd2_ir_table);
> +
> +static int hix5hd2_ir_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct rc_dev *rdev;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct hix5hd2_ir_priv *priv;
> +	struct device_node *node = pdev->dev.of_node;
> +
> +	priv = devm_kzalloc(dev, sizeof(struct hix5hd2_ir_priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->regmap = syscon_regmap_lookup_by_phandle(node,
> +						       "hisilicon,power-syscon");
> +	if (IS_ERR(priv->regmap)) {
> +		dev_err(dev, "no power-reg\n");
> +		return -EINVAL;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	priv->irq = platform_get_irq(pdev, 0);
> +	if (priv->irq < 0) {
> +		dev_err(dev, "irq can not get\n");
> +		return priv->irq;
> +	}
> +
> +	if (devm_request_irq(dev, priv->irq, hix5hd2_ir_rx_interrupt,
> +			     IRQF_NO_SUSPEND, pdev->name, priv) < 0) {
> +		dev_err(dev, "IRQ %d register failed\n", priv->irq);
> +		return -EINVAL;
> +	}

You've requested the interrupts too early, if an interrupts arrives before
you've set up all the members in priv it'll go bang in the interrupt handler.

> +
> +	rdev = rc_allocate_device();
> +	if (!rdev)
> +		return -ENOMEM;
> +
> +	priv->clock = devm_clk_get(dev, NULL);
> +	if (IS_ERR(priv->clock)) {
> +		dev_err(dev, "clock not found\n");
> +		return PTR_ERR(priv->clock);
> +	}
> +	clk_prepare_enable(priv->clock);
> +	priv->rate = clk_get_rate(priv->clock);
> +
> +	rdev->driver_type = RC_DRIVER_IR_RAW;
> +	rdev->allowed_protocols = RC_BIT_ALL;
> +	rdev->priv = priv;
> +	rdev->open = hix5hd2_ir_open;
> +	rdev->close = hix5hd2_ir_close;
> +	rdev->driver_name = IR_HIX5HD2_NAME;
> +	priv->map_name = of_get_property(node, "linux,rc-map-name", NULL);
> +	rdev->map_name = priv->map_name ?: RC_MAP_EMPTY;
> +	rdev->input_name = IR_HIX5HD2_NAME;
> +	rdev->input_phys = IR_HIX5HD2_NAME "/input0";
> +	rdev->input_id.bustype = BUS_HOST;
> +	rdev->input_id.vendor = 0x0001;
> +	rdev->input_id.product = 0x0001;
> +	rdev->input_id.version = 0x0100;
> +	rdev->rx_resolution = US_TO_NS(10);
> +	rdev->timeout = US_TO_NS(IR_CFG_SYMBOL_MAXWIDTH * 10);
> +
> +	ret = rc_register_device(rdev);
> +	if (ret < 0)
> +		goto err;
> +
> +	priv->rdev = rdev;
> +	priv->dev = dev;
> +	platform_set_drvdata(pdev, priv);
> +
> +	/**
> +	 * for LIRC_MODE_MODE2 or LIRC_MODE_PULSE or LIRC_MODE_RAW
> +	 * lircd expects a long space first before a signal train to sync.
> +	 */
> +	hix5hd2_ir_send_lirc_timeout(rdev);

I don't know why this is needed, sounds like a lircd oddity.

> +	return ret;
> +
> +err:
> +	clk_disable_unprepare(priv->clock);
> +	rc_free_device(rdev);
> +	dev_err(dev, "Unable to register device (%d)\n", ret);
> +	return ret;
> +}
> +
> +static int hix5hd2_ir_remove(struct platform_device *pdev)
> +{
> +	struct hix5hd2_ir_priv *priv = platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(priv->clock);
> +	rc_unregister_device(priv->rdev);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int hix5hd2_ir_suspend(struct device *dev)
> +{
> +	struct hix5hd2_ir_priv *priv = dev_get_drvdata(dev);
> +
> +	clk_disable_unprepare(priv->clock);
> +	hix5hd2_ir_enable(priv, false);
> +
> +	return 0;
> +}
> +
> +static int hix5hd2_ir_resume(struct device *dev)
> +{
> +	struct hix5hd2_ir_priv *priv = dev_get_drvdata(dev);
> +
> +	hix5hd2_ir_enable(priv, true);
> +	clk_prepare_enable(priv->clock);
> +
> +	writel_relaxed(0x01, priv->base + IR_ENABLE);
> +	writel_relaxed(0x00, priv->base + IR_INTM);
> +	writel_relaxed(0xff, priv->base + IR_INTC);
> +	writel_relaxed(0x01, priv->base + IR_START);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(hix5hd2_ir_pm_ops, hix5hd2_ir_suspend,
> +			 hix5hd2_ir_resume);
> +
> +static struct platform_driver hix5hd2_ir_driver = {
> +	.driver = {
> +		.name = IR_HIX5HD2_NAME,
> +		.of_match_table = hix5hd2_ir_table,
> +		.pm     = &hix5hd2_ir_pm_ops,
> +	},
> +	.probe = hix5hd2_ir_probe,
> +	.remove = hix5hd2_ir_remove,
> +};
> +
> +module_platform_driver(hix5hd2_ir_driver);
> +
> +MODULE_DESCRIPTION("RC Transceiver driver for hix5hd2 platforms");

A transceiver can transmit as well as receive; this driver can only do one.

> +MODULE_AUTHOR("Guoxiong Yan <yanguoxiong@huawei.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:hix5hd2-ir");
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
