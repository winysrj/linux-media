Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53548 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbbGPNLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 09:11:35 -0400
Message-ID: <55A7AD20.3080703@xs4all.nl>
Date: Thu, 16 Jul 2015 15:09:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
CC: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org
Subject: Re: [PATCHv7 14/15] cec: s5p-cec: Add s5p-cec driver
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com> <1435572900-56998-15-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1435572900-56998-15-git-send-email-hans.verkuil@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marek, Kamil,



On 06/29/15 12:14, Hans Verkuil wrote:
> From: Kamil Debski <kamil@wypas.org>
> 
> Add CEC interface driver present in the Samsung Exynos range of
> SoCs.
> 
> The following files were based on work by SangPil Moon:
> - exynos_hdmi_cec.h
> - exynos_hdmi_cecctl.c
> 
> Signed-off-by: Kamil Debski <kamil@wypas.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

<snip>

> diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
> new file mode 100644
> index 0000000..0f16d00
> --- /dev/null
> +++ b/drivers/media/platform/s5p-cec/s5p_cec.c
> @@ -0,0 +1,283 @@
> +/* drivers/media/platform/s5p-cec/s5p_cec.c
> + *
> + * Samsung S5P CEC driver
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This driver is based on the "cec interface driver for exynos soc" by
> + * SangPil Moon.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/timer.h>
> +#include <linux/version.h>
> +#include <linux/workqueue.h>
> +#include <media/cec.h>
> +
> +#include "exynos_hdmi_cec.h"
> +#include "regs-cec.h"
> +#include "s5p_cec.h"
> +
> +#define CEC_NAME	"s5p-cec"
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "debug level (0-2)");
> +
> +static int s5p_cec_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev, adap);
> +	int ret;
> +
> +	if (enable) {
> +		ret = pm_runtime_get_sync(cec->dev);
> +
> +		adap->phys_addr = 0x100b;

This is a bogus physical address. The actual physical address has to be derived
from the EDID that is read by the HDMI transmitter.

I think in the case of this driver it will have to be userspace that assigns
the physical address after reading the EDID from drm/kms?

How did you test this, Kamil?

Regards,

	Hans

> +		s5p_cec_reset(cec);
> +
> +		s5p_cec_set_divider(cec);
> +		s5p_cec_threshold(cec);
> +
> +		s5p_cec_unmask_tx_interrupts(cec);
> +		s5p_cec_unmask_rx_interrupts(cec);
> +		s5p_cec_enable_rx(cec);
> +	} else {
> +		s5p_cec_mask_tx_interrupts(cec);
> +		s5p_cec_mask_rx_interrupts(cec);
> +		pm_runtime_disable(cec->dev);
> +	}
> +
> +	return 0;
> +}
> +
> +static int s5p_cec_log_addr(struct cec_adapter *adap, u8 addr)
> +{
> +	struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev, adap);
> +
> +	s5p_cec_set_addr(cec, addr);
> +	return 0;
> +}
> +
> +static int s5p_cec_transmit(struct cec_adapter *adap, struct cec_msg *msg)
> +{
> +	struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev, adap);
> +
> +	s5p_cec_copy_packet(cec, msg->msg, msg->len);
> +	return 0;
> +}
> +
> +static void s5p_cec_transmit_timed_out(struct cec_adapter *adap)
> +{
> +
> +}
> +
> +static irqreturn_t s5p_cec_irq_handler(int irq, void *priv)
> +{
> +	struct s5p_cec_dev *cec = priv;
> +	u32 status = 0;
> +
> +	status = s5p_cec_get_status(cec);
> +
> +	dev_dbg(cec->dev, "irq received\n");
> +
> +	if (status & CEC_STATUS_TX_DONE) {
> +		if (status & CEC_STATUS_TX_ERROR) {
> +			dev_dbg(cec->dev, "CEC_STATUS_TX_ERROR set\n");
> +			cec->tx = STATE_ERROR;
> +		} else {
> +			dev_dbg(cec->dev, "CEC_STATUS_TX_DONE\n");
> +			cec->tx = STATE_DONE;
> +		}
> +		s5p_clr_pending_tx(cec);
> +	}
> +
> +	if (status & CEC_STATUS_RX_DONE) {
> +		if (status & CEC_STATUS_RX_ERROR) {
> +			dev_dbg(cec->dev, "CEC_STATUS_RX_ERROR set\n");
> +			s5p_cec_rx_reset(cec);
> +			s5p_cec_enable_rx(cec);
> +		} else {
> +			dev_dbg(cec->dev, "CEC_STATUS_RX_DONE set\n");
> +			if (cec->rx != STATE_IDLE)
> +				dev_dbg(cec->dev, "Buffer overrun (worker did not process previous message)\n");
> +			cec->rx = STATE_BUSY;
> +			cec->msg.len = status >> 24;
> +			cec->msg.status = CEC_RX_STATUS_READY;
> +			s5p_cec_get_rx_buf(cec, cec->msg.len,
> +					cec->msg.msg);
> +			cec->rx = STATE_DONE;
> +			s5p_cec_enable_rx(cec);
> +		}
> +		/* Clear interrupt pending bit */
> +		s5p_clr_pending_rx(cec);
> +	}
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t s5p_cec_irq_handler_thread(int irq, void *priv)
> +{
> +	struct s5p_cec_dev *cec = priv;
> +
> +	dev_dbg(cec->dev, "irq processing thread\n");
> +	switch (cec->tx) {
> +	case STATE_DONE:
> +		cec_transmit_done(&cec->adap, CEC_TX_STATUS_OK);
> +		cec->tx = STATE_IDLE;
> +		break;
> +	case STATE_ERROR:
> +		cec_transmit_done(&cec->adap, CEC_TX_STATUS_RETRY_TIMEOUT);
> +		cec->tx = STATE_IDLE;
> +		break;
> +	case STATE_BUSY:
> +		dev_err(cec->dev, "state set to busy, this should not occur here\n");
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	switch (cec->rx) {
> +	case STATE_DONE:
> +		cec_received_msg(&cec->adap, &cec->msg);
> +		cec->rx = STATE_IDLE;
> +	default:
> +		break;
> +	};
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int s5p_cec_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct s5p_cec_dev *cec;
> +	int ret;
> +
> +	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	cec->dev = dev;
> +
> +	cec->irq = platform_get_irq(pdev, 0);
> +	if (IS_ERR_VALUE(cec->irq))
> +		return cec->irq;
> +
> +	ret = devm_request_threaded_irq(dev, cec->irq, s5p_cec_irq_handler,
> +		s5p_cec_irq_handler_thread, 0, pdev->name, cec);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	cec->clk = devm_clk_get(dev, "hdmicec");
> +	if (IS_ERR(cec->clk))
> +		return PTR_ERR(cec->clk);
> +
> +	cec->pmu = syscon_regmap_lookup_by_phandle(dev->of_node,
> +						 "samsung,syscon-phandle");
> +	if (IS_ERR(cec->pmu))
> +		return -EPROBE_DEFER;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	cec->reg = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(cec->reg))
> +		return PTR_ERR(cec->reg);
> +
> +	cec->adap.available_log_addrs = 1;
> +	cec->adap.adap_enable = s5p_cec_enable;
> +	cec->adap.adap_log_addr = s5p_cec_log_addr;
> +	cec->adap.adap_transmit = s5p_cec_transmit;
> +	cec->adap.adap_transmit_timed_out = s5p_cec_transmit_timed_out;
> +	cec_create_adapter(&cec->adap, CEC_NAME, CEC_CAP_STATE |
> +		CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
> +		CEC_CAP_RECEIVE, true, THIS_MODULE, &pdev->dev);
> +
> +	platform_set_drvdata(pdev, cec);
> +	pm_runtime_enable(dev);
> +
> +	dev_dbg(dev, "successfuly probed\n");
> +	return 0;
> +}
> +
> +static int s5p_cec_remove(struct platform_device *pdev)
> +{
> +	struct s5p_cec_dev *cec = platform_get_drvdata(pdev);
> +
> +	cec_delete_adapter(&cec->adap);
> +	pm_runtime_disable(&pdev->dev);
> +	return 0;
> +}
> +
> +static int s5p_cec_runtime_suspend(struct device *dev)
> +{
> +	struct s5p_cec_dev *cec = dev_get_drvdata(dev);
> +
> +	clk_disable_unprepare(cec->clk);
> +	return 0;
> +}
> +
> +static int s5p_cec_runtime_resume(struct device *dev)
> +{
> +	struct s5p_cec_dev *cec = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = clk_prepare_enable(cec->clk);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +
> +static int s5p_cec_suspend(struct device *dev)
> +{
> +	if (pm_runtime_suspended(dev))
> +		return 0;
> +	return s5p_cec_runtime_suspend(dev);
> +}
> +
> +static int s5p_cec_resume(struct device *dev)
> +{
> +	if (pm_runtime_suspended(dev))
> +		return 0;
> +	return s5p_cec_runtime_resume(dev);
> +}
> +
> +static const struct dev_pm_ops s5p_cec_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(s5p_cec_suspend, s5p_cec_resume)
> +	SET_RUNTIME_PM_OPS(s5p_cec_runtime_suspend, s5p_cec_runtime_resume,
> +			   NULL)
> +};
> +
> +static const struct of_device_id s5p_cec_match[] = {
> +	{
> +		.compatible	= "samsung,s5p-cec",
> +	},
> +	{},
> +};
> +
> +static struct platform_driver s5p_cec_pdrv = {
> +	.probe	= s5p_cec_probe,
> +	.remove	= s5p_cec_remove,
> +	.driver	= {
> +		.name		= CEC_NAME,
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= s5p_cec_match,
> +		.pm		= &s5p_cec_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(s5p_cec_pdrv);
> +
> +MODULE_AUTHOR("Kamil Debski <kamil@wypas.org>");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Samsung S5P CEC driver");
> diff --git a/drivers/media/platform/s5p-cec/s5p_cec.h b/drivers/media/platform/s5p-cec/s5p_cec.h
> new file mode 100644
> index 0000000..d6ffd92
> --- /dev/null
> +++ b/drivers/media/platform/s5p-cec/s5p_cec.h
> @@ -0,0 +1,76 @@
> +/* drivers/media/platform/s5p-cec/s5p_cec.h
> + *
> + * Samsung S5P HDMI CEC driver
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef _S5P_CEC_H_
> +#define _S5P_CEC_H_ __FILE__
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/timer.h>
> +#include <linux/version.h>
> +#include <linux/workqueue.h>
> +#include <media/cec.h>
> +
> +#include "exynos_hdmi_cec.h"
> +#include "regs-cec.h"
> +#include "s5p_cec.h"
> +
> +#define CEC_NAME	"s5p-cec"
> +
> +#define CEC_STATUS_TX_RUNNING		(1 << 0)
> +#define CEC_STATUS_TX_TRANSFERRING	(1 << 1)
> +#define CEC_STATUS_TX_DONE		(1 << 2)
> +#define CEC_STATUS_TX_ERROR		(1 << 3)
> +#define CEC_STATUS_TX_BYTES		(0xFF << 8)
> +#define CEC_STATUS_RX_RUNNING		(1 << 16)
> +#define CEC_STATUS_RX_RECEIVING		(1 << 17)
> +#define CEC_STATUS_RX_DONE		(1 << 18)
> +#define CEC_STATUS_RX_ERROR		(1 << 19)
> +#define CEC_STATUS_RX_BCAST		(1 << 20)
> +#define CEC_STATUS_RX_BYTES		(0xFF << 24)
> +
> +#define CEC_WORKER_TX_DONE		(1 << 0)
> +#define CEC_WORKER_RX_MSG		(1 << 1)
> +
> +/* CEC Rx buffer size */
> +#define CEC_RX_BUFF_SIZE		16
> +/* CEC Tx buffer size */
> +#define CEC_TX_BUFF_SIZE		16
> +
> +enum cec_state {
> +	STATE_IDLE,
> +	STATE_BUSY,
> +	STATE_DONE,
> +	STATE_ERROR
> +};
> +
> +struct s5p_cec_dev {
> +	struct cec_adapter	adap;
> +	struct clk		*clk;
> +	struct device		*dev;
> +	struct mutex		lock;
> +	struct regmap           *pmu;
> +	int			irq;
> +	void __iomem		*reg;
> +
> +	enum cec_state		rx;
> +	enum cec_state		tx;
> +	struct cec_msg		msg;
> +};
> +
> +#endif /* _S5P_CEC_H_ */
> 
