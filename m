Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:37563 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab3HPIi5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 04:38:57 -0400
Date: Fri, 16 Aug 2013 09:38:53 +0100
From: Sean Young <sean@mess.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Rob Landley <rob@landley.net>,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] media: st-rc: Add ST remote control driver
Message-ID: <20130816083853.GA6844@pequod.mess.org>
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 14, 2013 at 06:27:01PM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch adds support to ST RC driver, which is basically a IR/UHF
> receiver and transmitter. This IP is common across all the ST parts for
> settop box platforms. IRB is embedded in ST COMMS IP block.
> It supports both Rx & Tx functionality.
> 
> In this driver adds only Rx functionality via LIRC codec.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
> Hi Chehab,
> 
> This is a very simple rc driver for IRB controller found in STi ARM CA9 SOCs.
> STi ARM SOC support went in 3.11 recently.
> This driver is a raw driver which feeds data to lirc codec for the user lircd
> to decode the keys.
> 
> This patch is based on git://linuxtv.org/media_tree.git master branch.
> 
> Comments?
> 
> Thanks,
> srini
> 
>  Documentation/devicetree/bindings/media/st-rc.txt |   18 +
>  drivers/media/rc/Kconfig                          |   10 +
>  drivers/media/rc/Makefile                         |    1 +
>  drivers/media/rc/st_rc.c                          |  371 +++++++++++++++++++++
>  4 files changed, 400 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/st-rc.txt
>  create mode 100644 drivers/media/rc/st_rc.c
> 
> diff --git a/Documentation/devicetree/bindings/media/st-rc.txt b/Documentation/devicetree/bindings/media/st-rc.txt
> new file mode 100644
> index 0000000..57f9ee8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/st-rc.txt
> @@ -0,0 +1,18 @@
> +Device-Tree bindings for ST IR and UHF receiver
> +
> +Required properties:
> +	- compatible: should be "st,rc".
> +	- st,uhfmode: boolean property to indicate if reception is in UHF.
> +	- reg: base physical address of the controller and length of memory
> +	mapped  region.
> +	- interrupts: interrupt number to the cpu. The interrupt specifier
> +	format depends on the interrupt controller parent.
> +
> +Example node:
> +
> +	rc: rc@fe518000 {
> +		compatible	= "st,rc";
> +		reg		= <0xfe518000 0x234>;
> +		interrupts	=  <0 203 0>;
> +	};
> +
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 5a79c33..548a705 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -321,4 +321,14 @@ config IR_GPIO_CIR
>  	   To compile this driver as a module, choose M here: the module will
>  	   be called gpio-ir-recv.
>  
> +config RC_ST
> +	tristate "ST remote control receiver"
> +	depends on ARCH_STI && LIRC
> +	help
> +	 Say Y here if you want support for ST remote control driver
> +	 which allows both IR and UHF RX. IR RX receiver is the default mode.
> +	 The driver passes raw pluse and space information to the LIRC decoder.
> +
> +	 If you're not sure, select N here.
> +
>  endif #RC_DEVICES
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 56bacf0..f4eb32c 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
>  obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
>  obj-$(CONFIG_IR_IGUANA) += iguanair.o
>  obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
> +obj-$(CONFIG_RC_ST) += st_rc.o
> diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
> new file mode 100644
> index 0000000..712a2fb
> --- /dev/null
> +++ b/drivers/media/rc/st_rc.c
> @@ -0,0 +1,371 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics Limited
> + * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/kernel.h>
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <media/rc-core.h>
> +#include <linux/pinctrl/consumer.h>
> +
> +struct st_rc_device {
> +	struct device			*dev;
> +	int				irq;
> +	int				irq_wake;
> +	struct clk			*sys_clock;
> +	void				*base;	/* Register base address */
> +	void				*rx_base;/* RX Register base address */
> +	struct rc_dev			*rdev;
> +	bool				overclocking;
> +	int				sample_mult;
> +	int				sample_div;
> +	bool				rxuhfmode;
> +};
> +
> +/* Registers */
> +#define IRB_SAMPLE_RATE_COMM	0x64	/* sample freq divisor*/
> +#define IRB_CLOCK_SEL		0x70	/* clock select       */
> +#define IRB_CLOCK_SEL_STATUS	0x74	/* clock status       */
> +/* IRB IR/UHF receiver registers */
> +#define IRB_RX_ON               0x40	/* pulse time capture */
> +#define IRB_RX_SYS              0X44	/* sym period capture */
> +#define IRB_RX_INT_EN           0x48	/* IRQ enable (R/W)   */
> +#define IRB_RX_INT_STATUS       0x4C	/* IRQ status (R/W)   */
> +#define IRB_RX_EN               0x50	/* Receive enablei    */
> +#define IRB_MAX_SYM_PERIOD      0x54	/* max sym value      */
> +#define IRB_RX_INT_CLEAR        0x58	/* overrun status     */
> +#define IRB_RX_STATUS           0x6C	/* receive status     */
> +#define IRB_RX_NOISE_SUPPR      0x5C	/* noise suppression  */
> +#define IRB_RX_POLARITY_INV     0x68	/* polarity inverter  */
> +
> +/* IRQ set: Enable full FIFO                 1  -> bit  3;
> + *          Enable overrun IRQ               1  -> bit  2;
> + *          Enable last symbol IRQ           1  -> bit  1:
> + *          Enable RX interrupt              1  -> bit  0;
> + */
> +#define IRB_RX_INTS		0x0f
> +#define IRB_RX_OVERRUN_INT	0x04
> + /* maximum symbol period (microsecs),timeout to detect end of symbol train */
> +#define MAX_SYMB_TIME		0x5000
> +#define IRB_SAMPLE_FREQ		10000000
> +#define	IRB_FIFO_NOT_EMPTY	0xff00
> +#define IRB_OVERFLOW		0x4
> +#define IRB_TIMEOUT		0xffff
> +#define IR_ST_NAME "st-rc"
> +
> +static void st_rc_send_lirc_timeout(struct rc_dev *rdev)
> +{
> +	DEFINE_IR_RAW_EVENT(ev);
> +	ev.timeout = true;
> +	ev.pulse = false;
> +	ir_raw_event_store(rdev, &ev);
> +}
> +
> +/**
> + * RX graphical example to better understand the difference between ST IR block
> + * output and standard definition used by LIRC (and most of the world!)
> + *
> + *           mark                                     mark
> + *      |-IRB_RX_ON-|                            |-IRB_RX_ON-|
> + *      ___  ___  ___                            ___  ___  ___             _
> + *      | |  | |  | |                            | |  | |  | |             |
> + *      | |  | |  | |         space 0            | |  | |  | |   space 1   |
> + * _____| |__| |__| |____________________________| |__| |__| |_____________|
> + *
> + *      |--------------- IRB_RX_SYS -------------|------ IRB_RX_SYS -------|
> + *
> + *      |------------- encoding bit 0 -----------|---- encoding bit 1 -----|
> + *
> + * ST hardware returns mark (IRB_RX_ON) and total symbol time (IRB_RX_SYS), so
> + * convert to standard mark/space we have to calculate space=(IRB_RX_SYS-mark)
> + * The mark time represents the amount of time the carrier (usually 36-40kHz)
> + * is detected.The above examples shows Pulse Width Modulation encoding where
> + * bit 0 is represented by space>mark.
> + */
> +
> +static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
> +{
> +	unsigned int symbol, mark = 0;
> +	struct st_rc_device *dev = data;
> +	int last_symbol = 0;
> +	u32 status;
> +	DEFINE_IR_RAW_EVENT(ev);
> +
> +	if (dev->irq_wake)
> +		pm_wakeup_event(dev->dev, 0);
> +
> +	status  = readl(dev->rx_base + IRB_RX_STATUS);
> +
> +	while (status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW)) {
> +		u32 int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
> +		if (unlikely(int_status & IRB_RX_OVERRUN_INT)) {

You should call ir_raw_event_reset() so that the in-kernel decoders 
realise that the IR stream is not contiguous.

> +			/* discard the entire collection in case of errors!  */
> +			dev_info(dev->dev, "IR RX overrun\n");
> +			writel(IRB_RX_OVERRUN_INT,
> +					dev->rx_base + IRB_RX_INT_CLEAR);
> +			continue;
> +		}
> +
> +		symbol = readl(dev->rx_base + IRB_RX_SYS);
> +		mark = readl(dev->rx_base + IRB_RX_ON);
> +
> +		if (symbol == IRB_TIMEOUT)
> +			last_symbol = 1;
> +
> +		 /* Ignore any noise */
> +		if ((mark > 2) && (symbol > 1)) {
> +			symbol -= mark;
> +			if (dev->overclocking) { /* adjustments to timings */
> +				symbol *= dev->sample_mult;
> +				symbol /= dev->sample_div;
> +				mark *= dev->sample_mult;
> +				mark /= dev->sample_div;
> +			}
> +
> +			ev.duration = US_TO_NS(mark);
> +			ev.pulse = true;
> +			ir_raw_event_store(dev->rdev, &ev);
> +
> +			if (!last_symbol) {
> +				ev.duration = US_TO_NS(symbol);
> +				ev.pulse = false;
> +				ir_raw_event_store(dev->rdev, &ev);

Make sure you call ir_raw_event_handle() once a while (maybe every time
the interrupt handler is called?) to prevent the ir kfifo from 
overflowing in case of very long IR. ir_raw_event_store() just adds
new edges to the kfifo() but does not flush them to the decoders or
lirc.

> +			} else  {
> +				st_rc_send_lirc_timeout(dev->rdev);
> +				ir_raw_event_handle(dev->rdev);
> +			}
> +		}
> +		last_symbol = 0;
> +		status  = readl(dev->rx_base + IRB_RX_STATUS);
> +	}
> +
> +	writel(IRB_RX_INTS, dev->rx_base + IRB_RX_INT_CLEAR);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void st_rc_hardware_init(struct st_rc_device *dev)
> +{
> +	int baseclock, freqdiff;
> +	unsigned int rx_max_symbol_per = MAX_SYMB_TIME;
> +	unsigned int rx_sampling_freq_div;
> +
> +	clk_prepare_enable(dev->sys_clock);
> +	baseclock = clk_get_rate(dev->sys_clock);
> +
> +	/* IRB input pins are inverted internally from high to low. */
> +	writel(1, dev->rx_base + IRB_RX_POLARITY_INV);
> +
> +	rx_sampling_freq_div = baseclock / IRB_SAMPLE_FREQ;
> +	writel(rx_sampling_freq_div, dev->base + IRB_SAMPLE_RATE_COMM);
> +
> +	freqdiff = baseclock - (rx_sampling_freq_div * IRB_SAMPLE_FREQ);
> +	if (freqdiff) { /* over clocking, workout the adjustment factors */
> +		dev->overclocking = true;
> +		dev->sample_mult = 1000;
> +		dev->sample_div = baseclock / (10000 * rx_sampling_freq_div);
> +		rx_max_symbol_per = (rx_max_symbol_per * 1000)/dev->sample_div;
> +	}
> +
> +	writel(rx_max_symbol_per, dev->rx_base + IRB_MAX_SYM_PERIOD);
> +}
> +
> +static int st_rc_remove(struct platform_device *pdev)
> +{
> +	struct st_rc_device *rc_dev = platform_get_drvdata(pdev);
> +	clk_disable_unprepare(rc_dev->sys_clock);
> +	rc_unregister_device(rc_dev->rdev);
> +	return 0;
> +}
> +
> +static int st_rc_open(struct rc_dev *rdev)
> +{
> +	struct st_rc_device *dev = rdev->priv;
> +	unsigned long flags;
> +	local_irq_save(flags);
> +	/* enable interrupts and receiver */
> +	writel(IRB_RX_INTS, dev->rx_base + IRB_RX_INT_EN);
> +	writel(0x01, dev->rx_base + IRB_RX_EN);
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}
> +
> +static void st_rc_close(struct rc_dev *rdev)
> +{
> +	struct st_rc_device *dev = rdev->priv;
> +	/* disable interrupts and receiver */
> +	writel(0x00, dev->rx_base + IRB_RX_EN);
> +	writel(0x00, dev->rx_base + IRB_RX_INT_EN);
> +}
> +
> +static int st_rc_probe(struct platform_device *pdev)
> +{
> +	int ret = -EINVAL;
> +	struct rc_dev *rdev;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct st_rc_device *rc_dev;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	rc_dev = devm_kzalloc(dev, sizeof(struct st_rc_device), GFP_KERNEL);
> +	rdev = rc_allocate_device();
> +
> +	if (!rc_dev || !rdev)
> +		return -ENOMEM;
> +
> +	if (np)
> +		rc_dev->rxuhfmode = of_property_read_bool(np, "st,uhfmode");
> +
> +	rc_dev->sys_clock = devm_clk_get(dev, NULL);
> +	if (IS_ERR(rc_dev->sys_clock)) {
> +		dev_err(dev, "System clock not found\n");
> +		ret = PTR_ERR(rc_dev->sys_clock);
> +		goto err;
> +	}
> +
> +	rc_dev->irq = platform_get_irq(pdev, 0);
> +	if (rc_dev->irq < 0) {
> +		ret = rc_dev->irq;
> +		goto clkerr;
> +	}
> +
> +	ret = -ENODEV;
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		goto clkerr;
> +
> +	rc_dev->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(rc_dev->base))
> +		goto clkerr;
> +
> +	if (rc_dev->rxuhfmode)
> +		rc_dev->rx_base = rc_dev->base + 0x40;
> +	else
> +		rc_dev->rx_base = rc_dev->base;
> +
> +	rc_dev->dev = dev;
> +	platform_set_drvdata(pdev, rc_dev);
> +	st_rc_hardware_init(rc_dev);
> +
> +	rdev->driver_type = RC_DRIVER_IR_RAW;
> +	rdev->allowed_protos = RC_TYPE_LIRC;

allowed_protos is a bit field, so you need one of the RC_BIT_ types;
you should use RC_BIT_ALL so that in-kernel IR decoders can be used
for decoding if desired.

> +	rdev->priv = rc_dev;
> +	rdev->open = st_rc_open;
> +	rdev->close = st_rc_close;
> +	rdev->driver_name = IR_ST_NAME;
> +	rdev->map_name = RC_MAP_LIRC;
> +	rdev->input_name = "ST Remote Control Receiver";

Please also set the timeout and rx_resolution according to the hardware.

> +
> +	/* enable wake via this device */
> +	device_set_wakeup_capable(dev, true);
> +	device_set_wakeup_enable(dev, true);
> +
> +	ret = rc_register_device(rdev);
> +	if (ret < 0)
> +		goto clkerr;
> +
> +	rc_dev->rdev = rdev;
> +	if (devm_request_irq(dev, rc_dev->irq, st_rc_rx_interrupt,
> +			IRQF_NO_SUSPEND, IR_ST_NAME, rc_dev) < 0) {
> +		dev_err(dev, "IRQ %d register failed\n", rc_dev->irq);
> +		ret = -EINVAL;
> +		goto rcerr;
> +	}
> +
> +	/* for LIRC_MODE_MODE2 or LIRC_MODE_PULSE or LIRC_MODE_RAW
> +	 * lircd expects a long space first before a signal train to sync. */
> +	st_rc_send_lirc_timeout(rdev);
> +
> +	dev_info(dev, "setup in %s mode\n", rc_dev->rxuhfmode ? "UHF" : "IR");
> +
> +	return ret;
> +rcerr:
> +	rc_unregister_device(rdev);
> +	rdev = NULL;
> +clkerr:
> +	clk_disable_unprepare(rc_dev->sys_clock);
> +err:
> +	rc_free_device(rdev);
> +	dev_err(dev, "Unable to register device (%d)\n", ret);
> +	return ret;
> +}
> +
> +#ifdef CONFIG_PM
> +static int st_rc_suspend(struct device *dev)
> +{
> +	struct st_rc_device *rc_dev = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev)) {
> +		if (!enable_irq_wake(rc_dev->irq))
> +			rc_dev->irq_wake = 1;
> +		else
> +			return -EINVAL;
> +	} else {
> +		pinctrl_pm_select_sleep_state(dev);
> +		writel(0x00, rc_dev->rx_base + IRB_RX_EN);
> +		writel(0x00, rc_dev->rx_base + IRB_RX_INT_EN);
> +		clk_disable_unprepare(rc_dev->sys_clock);
> +	}
> +
> +	return 0;
> +}
> +
> +static int st_rc_resume(struct device *dev)
> +{
> +	struct st_rc_device *rc_dev = dev_get_drvdata(dev);
> +	struct rc_dev	*rdev = rc_dev->rdev;
> +
> +	if (rc_dev->irq_wake) {
> +		disable_irq_wake(rc_dev->irq);
> +		rc_dev->irq_wake = 0;
> +	} else {
> +		pinctrl_pm_select_default_state(dev);
> +		st_rc_hardware_init(rc_dev);
> +		if (rdev->users) {
> +			writel(IRB_RX_INTS, rc_dev->rx_base + IRB_RX_INT_EN);
> +			writel(0x01, rc_dev->rx_base + IRB_RX_EN);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(st_rc_pm_ops, st_rc_suspend, st_rc_resume);
> +#endif
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id st_rc_match[] = {
> +	{ .compatible = "st,rc", },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, st_rc_match);
> +#endif
> +
> +static struct platform_driver st_rc_driver = {
> +	.driver = {
> +		.name = IR_ST_NAME,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(st_rc_match),
> +#ifdef CONFIG_PM
> +		.pm     = &st_rc_pm_ops,
> +#endif
> +	},
> +	.probe = st_rc_probe,
> +	.remove = st_rc_remove,
> +};
> +
> +module_platform_driver(st_rc_driver);
> +
> +MODULE_DESCRIPTION("RC Transceiver driver for STMicroelectronics platforms");
> +MODULE_AUTHOR("STMicroelectronics (R&D) Ltd");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
