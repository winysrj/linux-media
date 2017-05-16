Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60083 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751338AbdEPJd2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 05:33:28 -0400
Subject: Re: [PATCH 2/2] cec: add STM32 cec driver
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        yannick.ferte@st.com, alexandre.torgue@st.com,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        robh@kernel.org, hans.verkuil@cisco.com
References: <1494925280-4527-1-git-send-email-benjamin.gaignard@linaro.org>
 <1494925280-4527-3-git-send-email-benjamin.gaignard@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b8a58196-dc86-8ffc-2a3b-77570dd153eb@xs4all.nl>
Date: Tue, 16 May 2017 11:33:25 +0200
MIME-Version: 1.0
In-Reply-To: <1494925280-4527-3-git-send-email-benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

Thanks for the patch! Always nice to see new CEC drivers.

On 16/05/17 11:01, Benjamin Gaignard wrote:
> This patch add cec driver for STM32 platforms.
> cec hardware block isn't not always used with hdmi so
> cec notifier is not implemented. That will be done later
> when STM32 DSI driver will be available.
> 
> Driver compliance has been tested with cec-ctl and cec-compliance
> tools.
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Since Yannick wrote the original driver, shouldn't there be a Signed-off-by
from him as well?

> ---
>  drivers/media/platform/Kconfig           |  11 +
>  drivers/media/platform/Makefile          |   2 +
>  drivers/media/platform/stm32/Makefile    |   1 +
>  drivers/media/platform/stm32/stm32-cec.c | 368 +++++++++++++++++++++++++++++++
>  4 files changed, 382 insertions(+)
>  create mode 100644 drivers/media/platform/stm32/Makefile
>  create mode 100644 drivers/media/platform/stm32/stm32-cec.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index ac026ee..72efe34 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -519,4 +519,15 @@ config VIDEO_STI_HDMI_CEC
>           CEC bus is present in the HDMI connector and enables communication
>           between compatible devices.
>  
> +config VIDEO_STM32_HDMI_CEC
> +       tristate "STMicroelectronics STM32 HDMI CEC driver"
> +       depends on CEC_CORE && (ARCH_STM32 || COMPILE_TEST)
> +       select REGMAP
> +       select REGMAP_MMIO
> +       ---help---
> +         This is a driver for STM32 interface. It uses the
> +         generic CEC framework interface.
> +         CEC bus is present in the HDMI connector and enables communication
> +         between compatible devices.
> +
>  endif #CEC_PLATFORM_DRIVERS
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 63303d6..7cd9965 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -44,6 +44,8 @@ obj-$(CONFIG_VIDEO_STI_HDMI_CEC) 	+= sti/cec/
>  
>  obj-$(CONFIG_VIDEO_STI_DELTA)		+= sti/delta/
>  
> +obj-$(CONFIG_VIDEO_STM32_HDMI_CEC) 	+= stm32/
> +
>  obj-$(CONFIG_BLACKFIN)                  += blackfin/
>  
>  obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
> diff --git a/drivers/media/platform/stm32/Makefile b/drivers/media/platform/stm32/Makefile
> new file mode 100644
> index 0000000..632b04c
> --- /dev/null
> +++ b/drivers/media/platform/stm32/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_STM32_HDMI_CEC) += stm32-cec.o
> diff --git a/drivers/media/platform/stm32/stm32-cec.c b/drivers/media/platform/stm32/stm32-cec.c
> new file mode 100644
> index 0000000..a40a6eb
> --- /dev/null
> +++ b/drivers/media/platform/stm32/stm32-cec.c
> @@ -0,0 +1,368 @@
> +/*
> + * STM32 CEC driver
> + * Copyright (C) STMicroelectronic SA 2017

Isn't it STMicroelectronics instead of STMicroelectronic?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +
> +#include <media/cec.h>
> +
> +#define CEC_NAME	"stm32-cec"
> +
> +/* CEC registers  */
> +#define CEC_CR		0x0000 /* Control Register */
> +#define CEC_CFGR	0x0004 /* ConFiGuration Register */
> +#define CEC_TXDR	0x0008 /* Rx data Register */
> +#define CEC_RXDR	0x000C /* Rx data Register */
> +#define CEC_ISR		0x0010 /* Interrupt and status Register */
> +#define CEC_IER		0x0014 /* Interrupt enable Register */
> +
> +#define TXEOM		BIT(2)
> +#define TXSOM		BIT(1)
> +#define CECEN		BIT(0)
> +
> +#define LSTN		BIT(31)
> +#define OAR		GENMASK(30, 16)
> +#define SFTOP		BIT(8)
> +#define BRDNOGEN	BIT(7)
> +#define LBPEGEN		BIT(6)
> +#define BREGEN		BIT(5)
> +#define BRESTP		BIT(4)
> +#define RXTOL		BIT(3)
> +#define SFT		GENMASK(2, 0)
> +#define FULL_CFG	(LSTN | SFTOP | BRDNOGEN | LBPEGEN | BREGEN | BRESTP \
> +			 | RXTOL | SFT | BRDNOGEN)
> +
> +#define TXACKE		BIT(12)
> +#define TXERR		BIT(11)
> +#define TXUDR		BIT(10)
> +#define TXEND		BIT(9)
> +#define TXBR		BIT(8)
> +#define ARBLST		BIT(7)
> +#define RXACKE		BIT(6)
> +#define RXOVR		BIT(2)
> +#define RXEND		BIT(1)
> +#define RXBR		BIT(0)
> +
> +#define ALL_TX_IT	(TXEND | TXBR | TXACKE | TXERR | TXUDR | ARBLST)
> +#define ALL_RX_IT	(RXEND | RXBR | RXACKE | RXOVR)
> +
> +struct stm32_cec {
> +	struct cec_adapter	*adap;
> +	struct device		*dev;
> +	struct clk		*clk_cec;
> +	struct clk		*clk_hdmi_cec;
> +	struct reset_control	*rstc;
> +	struct regmap		*regmap;
> +	int			irq;
> +	u32			irq_status;
> +	u8			rx_msg[CEC_MAX_MSG_SIZE];
> +	u8			tx_msg[CEC_MAX_MSG_SIZE];
> +	int			rx_len;
> +	int			tx_len;
> +	int			tx_cnt;
> +};
> +
> +static void cec_hw_init(struct stm32_cec *cec)
> +{
> +	regmap_update_bits(cec->regmap, CEC_CR, TXEOM | TXSOM | CECEN, 0);
> +
> +	regmap_update_bits(cec->regmap, CEC_IER, ALL_TX_IT | ALL_RX_IT,
> +			   ALL_TX_IT | ALL_RX_IT);
> +
> +	regmap_update_bits(cec->regmap, CEC_CFGR, FULL_CFG, FULL_CFG);
> +}
> +
> +static void stm32_tx_done(struct stm32_cec *cec, u32 status)
> +{
> +	if (status & (TXERR | TXUDR)) {
> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_ERROR,
> +				  0, 0, 0, 1);
> +		return;
> +	}
> +
> +	if (status & ARBLST) {
> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_ARB_LOST,
> +				  1, 0, 0, 0);
> +		return;
> +	}
> +
> +	if (status & TXACKE) {
> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_NACK,
> +				  0, 1, 0, 0);
> +		return;
> +	}
> +
> +	if (cec->irq_status & TXBR) {
> +		/* send next byte */
> +		if (cec->tx_cnt < cec->tx_len)
> +			regmap_write(cec->regmap, CEC_TXDR,
> +				     cec->tx_msg[cec->tx_cnt++]);
> +
> +		/* TXEOM is set to command transmission of the last byte */
> +		if (cec->tx_cnt == cec->tx_len)
> +			regmap_update_bits(cec->regmap, CEC_CR, TXEOM, TXEOM);
> +	}
> +
> +	if (cec->irq_status & TXEND)
> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
> +}
> +
> +static void stm32_rx_done(struct stm32_cec *cec, u32 status)
> +{
> +	if (cec->irq_status & (RXACKE | RXOVR)) {
> +		cec->rx_len = 0;
> +		return;
> +	}
> +
> +	if (cec->irq_status & RXBR) {
> +		u32 val;
> +
> +		regmap_read(cec->regmap, CEC_RXDR, &val);
> +		cec->rx_msg[cec->rx_len++] = val & 0xFF;

Wouldn't it be safer to handle this IRQ and the TXBR interrupt in
stm32_cec_irq_handler()? This can be done in atomic context and these are
more time-sensitive.

> +	}
> +
> +	if (cec->irq_status & RXEND) {
> +		struct cec_msg msg = {};
> +
> +		msg.len = cec->rx_len;
> +		memcpy(msg.msg, cec->rx_msg, msg.len);

Most drivers just embed a cec_msg struct in the top-level struct (stm32_cec
in this case). That way there is no need to have your own copies of the length
and message data (rx_len and rx_msg in this case).

Actually, the same applies to the tx part, just embed a cec_msg tx_msg.

> +		cec_received_msg(cec->adap, &msg);
> +
> +		cec->rx_len = 0;
> +	}
> +}
> +
> +static irqreturn_t stm32_cec_irq_thread(int irq, void *arg)
> +{
> +	struct stm32_cec *cec = arg;
> +
> +	if (cec->irq_status & ALL_TX_IT)
> +		stm32_tx_done(cec, cec->irq_status);
> +
> +	if (cec->irq_status & ALL_RX_IT)
> +		stm32_rx_done(cec, cec->irq_status);
> +
> +	cec->irq_status = 0;
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t stm32_cec_irq_handler(int irq, void *arg)
> +{
> +	struct stm32_cec *cec = arg;
> +
> +	regmap_read(cec->regmap, CEC_ISR, &cec->irq_status);
> +
> +	regmap_update_bits(cec->regmap, CEC_ISR,
> +			   ALL_TX_IT | ALL_RX_IT,
> +			   ALL_TX_IT | ALL_RX_IT);
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static int stm32_cec_adap_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct stm32_cec *cec = adap->priv;
> +	int ret = 0;
> +
> +	if (enable) {
> +		ret = clk_enable(cec->clk_cec);
> +		if (ret)
> +			dev_err(cec->dev, "fail to enable cec clock\n");
> +
> +		clk_enable(cec->clk_hdmi_cec);
> +		regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
> +	} else {
> +		clk_disable(cec->clk_cec);
> +		clk_disable(cec->clk_hdmi_cec);
> +		regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
> +	}
> +
> +	return ret;
> +}
> +
> +static int stm32_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
> +{
> +	struct stm32_cec *cec = adap->priv;
> +
> +	regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
> +
> +	if (logical_addr == CEC_LOG_ADDR_INVALID)
> +		regmap_update_bits(cec->regmap, CEC_CFGR, OAR, 0);
> +	else
> +		regmap_update_bits(cec->regmap, CEC_CFGR, OAR,
> +				   (1 << logical_addr) << 16);

Since this is a mask I assume that this CEC implementation can handle multiple
logical addresses? In that case you should allow that when you call cec_allocate_adapter:
instead of '1' use CEC_MAX_LOG_ADDRS as the last argument.

> +
> +	regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
> +
> +	return 0;
> +}
> +
> +static int stm32_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
> +				   u32 signal_free_time, struct cec_msg *msg)
> +{
> +	struct stm32_cec *cec = adap->priv;
> +
> +	/* Copy message */
> +	memcpy(cec->tx_msg, msg->msg, msg->len);
> +
> +	cec->tx_len = msg->len;
> +	cec->tx_cnt = 0;
> +
> +	/*
> +	 * If the CEC message consists of only one byte,
> +	 * TXEOM must be set before of TXSOM.
> +	 */
> +	if (cec->tx_len == 1)
> +		regmap_update_bits(cec->regmap, CEC_CR, TXEOM, TXEOM);
> +
> +	/* TXSOM is set to command transmission of the first byte */
> +	regmap_update_bits(cec->regmap, CEC_CR, TXSOM, TXSOM);
> +
> +	/* Write the header (first byte of message) */
> +	regmap_write(cec->regmap, CEC_TXDR, cec->tx_msg[0]);
> +	cec->tx_cnt++;
> +
> +	return 0;
> +}
> +
> +static const struct cec_adap_ops stm32_cec_adap_ops = {
> +	.adap_enable = stm32_cec_adap_enable,
> +	.adap_log_addr = stm32_cec_adap_log_addr,
> +	.adap_transmit = stm32_cec_adap_transmit,
> +};
> +
> +static const struct regmap_config stm32_cec_regmap_cfg = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = sizeof(u32),
> +	.max_register = 0x14,
> +	.fast_io = true,
> +};
> +
> +static int stm32_cec_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct stm32_cec *cec;
> +	void __iomem *mmio;
> +	int ret;
> +
> +	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
> +	if (!cec)
> +		return -ENOMEM;
> +
> +	cec->dev = &pdev->dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	mmio = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(mmio))
> +		return PTR_ERR(mmio);
> +
> +	cec->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "cec", mmio,
> +						&stm32_cec_regmap_cfg);
> +
> +	if (IS_ERR(cec->regmap))
> +		return PTR_ERR(cec->regmap);
> +
> +	cec->irq = platform_get_irq(pdev, 0);
> +	if (cec->irq < 0)
> +		return cec->irq;
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, cec->irq,
> +					stm32_cec_irq_handler,
> +					stm32_cec_irq_thread,
> +					0,
> +					pdev->name, cec);
> +	if (ret)
> +		return ret;
> +
> +	cec->clk_cec = devm_clk_get(&pdev->dev, "cec");
> +	if (IS_ERR(cec->clk_cec)) {
> +		dev_err(&pdev->dev, "Cannot get cec clock\n");
> +		return PTR_ERR(cec->clk_cec);
> +	}
> +
> +	ret = clk_prepare(cec->clk_cec);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to prepare cec clock\n");
> +		return ret;
> +	}
> +
> +	cec->clk_hdmi_cec = devm_clk_get(&pdev->dev, "hdmi-cec");
> +	if (!IS_ERR(cec->clk_hdmi_cec)) {
> +		ret = clk_prepare(cec->clk_hdmi_cec);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Unable to prepare hdmi-cec clock\n");
> +			return ret;
> +		}
> +	}
> +
> +	cec->adap = cec_allocate_adapter(&stm32_cec_adap_ops, cec,
> +			CEC_NAME,
> +			CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
> +			CEC_CAP_PHYS_ADDR | CEC_CAP_TRANSMIT, 1);

Add CEC_CAP_RC.

Add a comment that CEC_CAP_PHYS_ADDR is temporary until this driver is
switched to using a cec_notifier.

There is no CEC bus monitoring support for this hardware?

> +	ret = PTR_ERR_OR_ZERO(cec->adap);
> +	if (ret)
> +		return ret;
> +
> +	ret = cec_register_adapter(cec->adap, &pdev->dev);
> +	if (ret) {
> +		cec_delete_adapter(cec->adap);
> +		return ret;
> +	}
> +
> +	cec_hw_init(cec);
> +
> +	platform_set_drvdata(pdev, cec);
> +
> +	return 0;
> +}
> +
> +static int stm32_cec_remove(struct platform_device *pdev)
> +{
> +	struct stm32_cec *cec = platform_get_drvdata(pdev);
> +
> +	clk_unprepare(cec->clk_cec);
> +	clk_unprepare(cec->clk_hdmi_cec);
> +
> +	cec_unregister_adapter(cec->adap);
> +
> +	cec_delete_adapter(cec->adap);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id stm32_cec_of_match[] = {
> +	{ .compatible = "st,stm32-cec" },
> +	{ /* end node */ }
> +};
> +MODULE_DEVICE_TABLE(of, stm32_cec_of_match);
> +
> +static struct platform_driver stm32_cec_driver = {
> +	.probe  = stm32_cec_probe,
> +	.remove = stm32_cec_remove,
> +	.driver = {
> +		.name		= CEC_NAME,
> +		.of_match_table = stm32_cec_of_match,
> +	},
> +};
> +
> +module_platform_driver(stm32_cec_driver);
> +
> +MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@st.com>");
> +MODULE_AUTHOR("Yannick Fertre <yannick.fertre@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics STM32 Consumer Electronics Control");
> +MODULE_LICENSE("GPL v2");
> 

Regards,

	Hans
