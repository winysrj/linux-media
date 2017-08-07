Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752841AbdHGK6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 06:58:07 -0400
Subject: Re: [PATCHv3 3/4] drm/bridge: dw-hdmi: add cec driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20170802184108.7913-1-hverkuil@xs4all.nl>
 <20170802184108.7913-4-hverkuil@xs4all.nl>
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <f25625f5-b51e-2f75-27c6-32312426e296@codeaurora.org>
Date: Mon, 7 Aug 2017 16:28:01 +0530
MIME-Version: 1.0
In-Reply-To: <20170802184108.7913-4-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/03/2017 12:11 AM, Hans Verkuil wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Add a CEC driver for the dw-hdmi hardware.
> 

Queued to drm-misc-next after fixing up some minor
Makefile/Kconfig conflicts.

Thanks,
Archit

> Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> [hans.verkuil: unsigned -> unsigned int]
> [hans.verkuil: cec_transmit_done -> cec_transmit_attempt_done]
> [hans.verkuil: add missing CEC_CAP_PASSTHROUGH]
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>   drivers/gpu/drm/bridge/synopsys/Kconfig       |   9 +
>   drivers/gpu/drm/bridge/synopsys/Makefile      |   1 +
>   drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c | 327 ++++++++++++++++++++++++++
>   drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h |  19 ++
>   drivers/gpu/drm/bridge/synopsys/dw-hdmi.c     |  42 +++-
>   drivers/gpu/drm/bridge/synopsys/dw-hdmi.h     |   1 +
>   6 files changed, 398 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c
>   create mode 100644 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h
> 
> diff --git a/drivers/gpu/drm/bridge/synopsys/Kconfig b/drivers/gpu/drm/bridge/synopsys/Kconfig
> index 351db000599a..d34c3dc04ba9 100644
> --- a/drivers/gpu/drm/bridge/synopsys/Kconfig
> +++ b/drivers/gpu/drm/bridge/synopsys/Kconfig
> @@ -23,3 +23,12 @@ config DRM_DW_HDMI_I2S_AUDIO
>   	help
>   	  Support the I2S Audio interface which is part of the Synopsys
>   	  Designware HDMI block.
> +
> +config DRM_DW_HDMI_CEC
> +	tristate "Synopsis Designware CEC interface"
> +	depends on DRM_DW_HDMI
> +	select CEC_CORE
> +	select CEC_NOTIFIER
> +	help
> +	  Support the CE interface which is part of the Synopsys
> +	  Designware HDMI block.
> diff --git a/drivers/gpu/drm/bridge/synopsys/Makefile b/drivers/gpu/drm/bridge/synopsys/Makefile
> index 17aa7a65b57e..6fe415903668 100644
> --- a/drivers/gpu/drm/bridge/synopsys/Makefile
> +++ b/drivers/gpu/drm/bridge/synopsys/Makefile
> @@ -3,3 +3,4 @@
>   obj-$(CONFIG_DRM_DW_HDMI) += dw-hdmi.o
>   obj-$(CONFIG_DRM_DW_HDMI_AHB_AUDIO) += dw-hdmi-ahb-audio.o
>   obj-$(CONFIG_DRM_DW_HDMI_I2S_AUDIO) += dw-hdmi-i2s-audio.o
> +obj-$(CONFIG_DRM_DW_HDMI_CEC) += dw-hdmi-cec.o
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c
> new file mode 100644
> index 000000000000..6c323510f128
> --- /dev/null
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c
> @@ -0,0 +1,327 @@
> +/*
> + * Designware HDMI CEC driver
> + *
> + * Copyright (C) 2015-2017 Russell King.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +#include <drm/drm_edid.h>
> +
> +#include <media/cec.h>
> +#include <media/cec-notifier.h>
> +
> +#include "dw-hdmi-cec.h"
> +
> +enum {
> +	HDMI_IH_CEC_STAT0	= 0x0106,
> +	HDMI_IH_MUTE_CEC_STAT0	= 0x0186,
> +
> +	HDMI_CEC_CTRL		= 0x7d00,
> +	CEC_CTRL_START		= BIT(0),
> +	CEC_CTRL_FRAME_TYP	= 3 << 1,
> +	CEC_CTRL_RETRY		= 0 << 1,
> +	CEC_CTRL_NORMAL		= 1 << 1,
> +	CEC_CTRL_IMMED		= 2 << 1,
> +
> +	HDMI_CEC_STAT		= 0x7d01,
> +	CEC_STAT_DONE		= BIT(0),
> +	CEC_STAT_EOM		= BIT(1),
> +	CEC_STAT_NACK		= BIT(2),
> +	CEC_STAT_ARBLOST	= BIT(3),
> +	CEC_STAT_ERROR_INIT	= BIT(4),
> +	CEC_STAT_ERROR_FOLL	= BIT(5),
> +	CEC_STAT_WAKEUP		= BIT(6),
> +
> +	HDMI_CEC_MASK		= 0x7d02,
> +	HDMI_CEC_POLARITY	= 0x7d03,
> +	HDMI_CEC_INT		= 0x7d04,
> +	HDMI_CEC_ADDR_L		= 0x7d05,
> +	HDMI_CEC_ADDR_H		= 0x7d06,
> +	HDMI_CEC_TX_CNT		= 0x7d07,
> +	HDMI_CEC_RX_CNT		= 0x7d08,
> +	HDMI_CEC_TX_DATA0	= 0x7d10,
> +	HDMI_CEC_RX_DATA0	= 0x7d20,
> +	HDMI_CEC_LOCK		= 0x7d30,
> +	HDMI_CEC_WKUPCTRL	= 0x7d31,
> +};
> +
> +struct dw_hdmi_cec {
> +	struct dw_hdmi *hdmi;
> +	const struct dw_hdmi_cec_ops *ops;
> +	u32 addresses;
> +	struct cec_adapter *adap;
> +	struct cec_msg rx_msg;
> +	unsigned int tx_status;
> +	bool tx_done;
> +	bool rx_done;
> +	struct cec_notifier *notify;
> +	int irq;
> +};
> +
> +static void dw_hdmi_write(struct dw_hdmi_cec *cec, u8 val, int offset)
> +{
> +	cec->ops->write(cec->hdmi, val, offset);
> +}
> +
> +static u8 dw_hdmi_read(struct dw_hdmi_cec *cec, int offset)
> +{
> +	return cec->ops->read(cec->hdmi, offset);
> +}
> +
> +static int dw_hdmi_cec_log_addr(struct cec_adapter *adap, u8 logical_addr)
> +{
> +	struct dw_hdmi_cec *cec = cec_get_drvdata(adap);
> +
> +	if (logical_addr == CEC_LOG_ADDR_INVALID)
> +		cec->addresses = 0;
> +	else
> +		cec->addresses |= BIT(logical_addr) | BIT(15);
> +
> +	dw_hdmi_write(cec, cec->addresses & 255, HDMI_CEC_ADDR_L);
> +	dw_hdmi_write(cec, cec->addresses >> 8, HDMI_CEC_ADDR_H);
> +
> +	return 0;
> +}
> +
> +static int dw_hdmi_cec_transmit(struct cec_adapter *adap, u8 attempts,
> +				u32 signal_free_time, struct cec_msg *msg)
> +{
> +	struct dw_hdmi_cec *cec = cec_get_drvdata(adap);
> +	unsigned int i, ctrl;
> +
> +	switch (signal_free_time) {
> +	case CEC_SIGNAL_FREE_TIME_RETRY:
> +		ctrl = CEC_CTRL_RETRY;
> +		break;
> +	case CEC_SIGNAL_FREE_TIME_NEW_INITIATOR:
> +	default:
> +		ctrl = CEC_CTRL_NORMAL;
> +		break;
> +	case CEC_SIGNAL_FREE_TIME_NEXT_XFER:
> +		ctrl = CEC_CTRL_IMMED;
> +		break;
> +	}
> +
> +	for (i = 0; i < msg->len; i++)
> +		dw_hdmi_write(cec, msg->msg[i], HDMI_CEC_TX_DATA0 + i);
> +
> +	dw_hdmi_write(cec, msg->len, HDMI_CEC_TX_CNT);
> +	dw_hdmi_write(cec, ctrl | CEC_CTRL_START, HDMI_CEC_CTRL);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t dw_hdmi_cec_hardirq(int irq, void *data)
> +{
> +	struct cec_adapter *adap = data;
> +	struct dw_hdmi_cec *cec = cec_get_drvdata(adap);
> +	unsigned int stat = dw_hdmi_read(cec, HDMI_IH_CEC_STAT0);
> +	irqreturn_t ret = IRQ_HANDLED;
> +
> +	if (stat == 0)
> +		return IRQ_NONE;
> +
> +	dw_hdmi_write(cec, stat, HDMI_IH_CEC_STAT0);
> +
> +	if (stat & CEC_STAT_ERROR_INIT) {
> +		cec->tx_status = CEC_TX_STATUS_ERROR;
> +		cec->tx_done = true;
> +		ret = IRQ_WAKE_THREAD;
> +	} else if (stat & CEC_STAT_DONE) {
> +		cec->tx_status = CEC_TX_STATUS_OK;
> +		cec->tx_done = true;
> +		ret = IRQ_WAKE_THREAD;
> +	} else if (stat & CEC_STAT_NACK) {
> +		cec->tx_status = CEC_TX_STATUS_NACK;
> +		cec->tx_done = true;
> +		ret = IRQ_WAKE_THREAD;
> +	}
> +
> +	if (stat & CEC_STAT_EOM) {
> +		unsigned int len, i;
> +
> +		len = dw_hdmi_read(cec, HDMI_CEC_RX_CNT);
> +		if (len > sizeof(cec->rx_msg.msg))
> +			len = sizeof(cec->rx_msg.msg);
> +
> +		for (i = 0; i < len; i++)
> +			cec->rx_msg.msg[i] =
> +				dw_hdmi_read(cec, HDMI_CEC_RX_DATA0 + i);
> +
> +		dw_hdmi_write(cec, 0, HDMI_CEC_LOCK);
> +
> +		cec->rx_msg.len = len;
> +		smp_wmb();
> +		cec->rx_done = true;
> +
> +		ret = IRQ_WAKE_THREAD;
> +	}
> +
> +	return ret;
> +}
> +
> +static irqreturn_t dw_hdmi_cec_thread(int irq, void *data)
> +{
> +	struct cec_adapter *adap = data;
> +	struct dw_hdmi_cec *cec = cec_get_drvdata(adap);
> +
> +	if (cec->tx_done) {
> +		cec->tx_done = false;
> +		cec_transmit_attempt_done(adap, cec->tx_status);
> +	}
> +	if (cec->rx_done) {
> +		cec->rx_done = false;
> +		smp_rmb();
> +		cec_received_msg(adap, &cec->rx_msg);
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +static int dw_hdmi_cec_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct dw_hdmi_cec *cec = cec_get_drvdata(adap);
> +
> +	if (!enable) {
> +		dw_hdmi_write(cec, ~0, HDMI_CEC_MASK);
> +		dw_hdmi_write(cec, ~0, HDMI_IH_MUTE_CEC_STAT0);
> +		dw_hdmi_write(cec, 0, HDMI_CEC_POLARITY);
> +
> +		cec->ops->disable(cec->hdmi);
> +	} else {
> +		unsigned int irqs;
> +
> +		dw_hdmi_write(cec, 0, HDMI_CEC_CTRL);
> +		dw_hdmi_write(cec, ~0, HDMI_IH_CEC_STAT0);
> +		dw_hdmi_write(cec, 0, HDMI_CEC_LOCK);
> +
> +		dw_hdmi_cec_log_addr(cec->adap, CEC_LOG_ADDR_INVALID);
> +
> +		cec->ops->enable(cec->hdmi);
> +
> +		irqs = CEC_STAT_ERROR_INIT | CEC_STAT_NACK | CEC_STAT_EOM |
> +		       CEC_STAT_DONE;
> +		dw_hdmi_write(cec, irqs, HDMI_CEC_POLARITY);
> +		dw_hdmi_write(cec, ~irqs, HDMI_CEC_MASK);
> +		dw_hdmi_write(cec, ~irqs, HDMI_IH_MUTE_CEC_STAT0);
> +	}
> +	return 0;
> +}
> +
> +static const struct cec_adap_ops dw_hdmi_cec_ops = {
> +	.adap_enable = dw_hdmi_cec_enable,
> +	.adap_log_addr = dw_hdmi_cec_log_addr,
> +	.adap_transmit = dw_hdmi_cec_transmit,
> +};
> +
> +static void dw_hdmi_cec_del(void *data)
> +{
> +	struct dw_hdmi_cec *cec = data;
> +
> +	cec_delete_adapter(cec->adap);
> +}
> +
> +static int dw_hdmi_cec_probe(struct platform_device *pdev)
> +{
> +	struct dw_hdmi_cec_data *data = dev_get_platdata(&pdev->dev);
> +	struct dw_hdmi_cec *cec;
> +	int ret;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	/*
> +	 * Our device is just a convenience - we want to link to the real
> +	 * hardware device here, so that userspace can see the association
> +	 * between the HDMI hardware and its associated CEC chardev.
> +	 */
> +	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
> +	if (!cec)
> +		return -ENOMEM;
> +
> +	cec->irq = data->irq;
> +	cec->ops = data->ops;
> +	cec->hdmi = data->hdmi;
> +
> +	platform_set_drvdata(pdev, cec);
> +
> +	dw_hdmi_write(cec, 0, HDMI_CEC_TX_CNT);
> +	dw_hdmi_write(cec, ~0, HDMI_CEC_MASK);
> +	dw_hdmi_write(cec, ~0, HDMI_IH_MUTE_CEC_STAT0);
> +	dw_hdmi_write(cec, 0, HDMI_CEC_POLARITY);
> +
> +	cec->adap = cec_allocate_adapter(&dw_hdmi_cec_ops, cec, "dw_hdmi",
> +					 CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
> +					 CEC_CAP_RC | CEC_CAP_PASSTHROUGH,
> +					 CEC_MAX_LOG_ADDRS);
> +	if (IS_ERR(cec->adap))
> +		return PTR_ERR(cec->adap);
> +
> +	/* override the module pointer */
> +	cec->adap->owner = THIS_MODULE;
> +
> +	ret = devm_add_action(&pdev->dev, dw_hdmi_cec_del, cec);
> +	if (ret) {
> +		cec_delete_adapter(cec->adap);
> +		return ret;
> +	}
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, cec->irq,
> +					dw_hdmi_cec_hardirq,
> +					dw_hdmi_cec_thread, IRQF_SHARED,
> +					"dw-hdmi-cec", cec->adap);
> +	if (ret < 0)
> +		return ret;
> +
> +	cec->notify = cec_notifier_get(pdev->dev.parent);
> +	if (!cec->notify)
> +		return -ENOMEM;
> +
> +	ret = cec_register_adapter(cec->adap, pdev->dev.parent);
> +	if (ret < 0) {
> +		cec_notifier_put(cec->notify);
> +		return ret;
> +	}
> +
> +	/*
> +	 * CEC documentation says we must not call cec_delete_adapter
> +	 * after a successful call to cec_register_adapter().
> +	 */
> +	devm_remove_action(&pdev->dev, dw_hdmi_cec_del, cec);
> +
> +	cec_register_cec_notifier(cec->adap, cec->notify);
> +
> +	return 0;
> +}
> +
> +static int dw_hdmi_cec_remove(struct platform_device *pdev)
> +{
> +	struct dw_hdmi_cec *cec = platform_get_drvdata(pdev);
> +
> +	cec_unregister_adapter(cec->adap);
> +	cec_notifier_put(cec->notify);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver dw_hdmi_cec_driver = {
> +	.probe	= dw_hdmi_cec_probe,
> +	.remove	= dw_hdmi_cec_remove,
> +	.driver = {
> +		.name = "dw-hdmi-cec",
> +	},
> +};
> +module_platform_driver(dw_hdmi_cec_driver);
> +
> +MODULE_AUTHOR("Russell King <rmk+kernel@armlinux.org.uk>");
> +MODULE_DESCRIPTION("Synopsys Designware HDMI CEC driver for i.MX");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS(PLATFORM_MODULE_PREFIX "dw-hdmi-cec");
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h
> new file mode 100644
> index 000000000000..cf4dc121a2c4
> --- /dev/null
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h
> @@ -0,0 +1,19 @@
> +#ifndef DW_HDMI_CEC_H
> +#define DW_HDMI_CEC_H
> +
> +struct dw_hdmi;
> +
> +struct dw_hdmi_cec_ops {
> +	void (*write)(struct dw_hdmi *hdmi, u8 val, int offset);
> +	u8 (*read)(struct dw_hdmi *hdmi, int offset);
> +	void (*enable)(struct dw_hdmi *hdmi);
> +	void (*disable)(struct dw_hdmi *hdmi);
> +};
> +
> +struct dw_hdmi_cec_data {
> +	struct dw_hdmi *hdmi;
> +	const struct dw_hdmi_cec_ops *ops;
> +	int irq;
> +};
> +
> +#endif
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> index 0ac1e3240cc3..01ad2f6d6476 100644
> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> @@ -35,6 +35,7 @@
>   
>   #include "dw-hdmi.h"
>   #include "dw-hdmi-audio.h"
> +#include "dw-hdmi-cec.h"
>   
>   #include <media/cec-notifier.h>
>   
> @@ -133,6 +134,7 @@ struct dw_hdmi {
>   	unsigned int version;
>   
>   	struct platform_device *audio;
> +	struct platform_device *cec;
>   	struct device *dev;
>   	struct clk *isfr_clk;
>   	struct clk *iahb_clk;
> @@ -1794,7 +1796,6 @@ static void initialize_hdmi_ih_mutes(struct dw_hdmi *hdmi)
>   	hdmi_writeb(hdmi, 0xff, HDMI_AUD_HBR_MASK);
>   	hdmi_writeb(hdmi, 0xff, HDMI_GP_MASK);
>   	hdmi_writeb(hdmi, 0xff, HDMI_A_APIINTMSK);
> -	hdmi_writeb(hdmi, 0xff, HDMI_CEC_MASK);
>   	hdmi_writeb(hdmi, 0xff, HDMI_I2CM_INT);
>   	hdmi_writeb(hdmi, 0xff, HDMI_I2CM_CTLINT);
>   
> @@ -2236,6 +2237,29 @@ static int dw_hdmi_detect_phy(struct dw_hdmi *hdmi)
>   	return -ENODEV;
>   }
>   
> +static void dw_hdmi_cec_enable(struct dw_hdmi *hdmi)
> +{
> +	mutex_lock(&hdmi->mutex);
> +	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_CECCLK_DISABLE;
> +	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
> +	mutex_unlock(&hdmi->mutex);
> +}
> +
> +static void dw_hdmi_cec_disable(struct dw_hdmi *hdmi)
> +{
> +	mutex_lock(&hdmi->mutex);
> +	hdmi->mc_clkdis |= HDMI_MC_CLKDIS_CECCLK_DISABLE;
> +	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
> +	mutex_unlock(&hdmi->mutex);
> +}
> +
> +static const struct dw_hdmi_cec_ops dw_hdmi_cec_ops = {
> +	.write = hdmi_writeb,
> +	.read = hdmi_readb,
> +	.enable = dw_hdmi_cec_enable,
> +	.disable = dw_hdmi_cec_disable,
> +};
> +
>   static const struct regmap_config hdmi_regmap_8bit_config = {
>   	.reg_bits	= 32,
>   	.val_bits	= 8,
> @@ -2258,6 +2282,7 @@ __dw_hdmi_probe(struct platform_device *pdev,
>   	struct device_node *np = dev->of_node;
>   	struct platform_device_info pdevinfo;
>   	struct device_node *ddc_node;
> +	struct dw_hdmi_cec_data cec;
>   	struct dw_hdmi *hdmi;
>   	struct resource *iores = NULL;
>   	int irq;
> @@ -2462,6 +2487,19 @@ __dw_hdmi_probe(struct platform_device *pdev,
>   		hdmi->audio = platform_device_register_full(&pdevinfo);
>   	}
>   
> +	if (config0 & HDMI_CONFIG0_CEC) {
> +		cec.hdmi = hdmi;
> +		cec.ops = &dw_hdmi_cec_ops;
> +		cec.irq = irq;
> +
> +		pdevinfo.name = "dw-hdmi-cec";
> +		pdevinfo.data = &cec;
> +		pdevinfo.size_data = sizeof(cec);
> +		pdevinfo.dma_mask = 0;
> +
> +		hdmi->cec = platform_device_register_full(&pdevinfo);
> +	}
> +
>   	/* Reset HDMI DDC I2C master controller and mute I2CM interrupts */
>   	if (hdmi->i2c)
>   		dw_hdmi_i2c_init(hdmi);
> @@ -2492,6 +2530,8 @@ static void __dw_hdmi_remove(struct dw_hdmi *hdmi)
>   {
>   	if (hdmi->audio && !IS_ERR(hdmi->audio))
>   		platform_device_unregister(hdmi->audio);
> +	if (!IS_ERR(hdmi->cec))
> +		platform_device_unregister(hdmi->cec);
>   
>   	/* Disable all interrupts */
>   	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
> index c59f87e1483e..69644c83a0f8 100644
> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
> @@ -555,6 +555,7 @@ enum {
>   
>   /* CONFIG0_ID field values */
>   	HDMI_CONFIG0_I2S = 0x10,
> +	HDMI_CONFIG0_CEC = 0x02,
>   
>   /* CONFIG1_ID field values */
>   	HDMI_CONFIG1_AHB = 0x01,
> 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
