Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44249 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751071AbdG1M6r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 08:58:47 -0400
Subject: Re: [PATCH v3 1/2] platform: Add Amlogic Meson AO CEC Controller
 driver
To: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1501168830-5308-1-git-send-email-narmstrong@baylibre.com>
 <1501168830-5308-2-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1093ba92-5abd-fe40-96c6-7d2030207644@xs4all.nl>
Date: Fri, 28 Jul 2017 14:58:41 +0200
MIME-Version: 1.0
In-Reply-To: <1501168830-5308-2-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2017 05:20 PM, Neil Armstrong wrote:
> The Amlogic SoC embeds a standalone CEC controller, this patch adds a driver
> for such controller.
> The controller does not need HPD to be active, and could support up to max
> 5 logical addresses, but only 1 is handled since the Suspend firmware can
> make use of this unique logical address to wake up the device.
> 
> The Suspend firmware configuration will be added in an other patchset.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/media/platform/Kconfig        |  11 +
>  drivers/media/platform/Makefile       |   2 +
>  drivers/media/platform/meson/Makefile |   1 +
>  drivers/media/platform/meson/ao-cec.c | 744 ++++++++++++++++++++++++++++++++++
>  4 files changed, 758 insertions(+)
>  create mode 100644 drivers/media/platform/meson/Makefile
>  create mode 100644 drivers/media/platform/meson/ao-cec.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 1313cd5..1e67381 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -536,6 +536,17 @@ menuconfig CEC_PLATFORM_DRIVERS
>  
>  if CEC_PLATFORM_DRIVERS
>  
> +config VIDEO_MESON_AO_CEC
> +	tristate "Amlogic Meson AO CEC driver"
> +	depends on ARCH_MESON || COMPILE_TEST
> +	select CEC_CORE
> +	select CEC_NOTIFIER
> +	---help---
> +	  This is a driver for Amlogic Meson SoCs AO CEC interface. It uses the
> +	  generic CEC framework interface.
> +	  CEC bus is present in the HDMI connector and enables communication
> +	  between compatible devices.
> +
>  config VIDEO_SAMSUNG_S5P_CEC
>         tristate "Samsung S5P CEC driver"
>         depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 9beadc7..a52d7b6 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -86,3 +86,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
>  obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
>  
>  obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
> +
> +obj-y					+= meson/
> diff --git a/drivers/media/platform/meson/Makefile b/drivers/media/platform/meson/Makefile
> new file mode 100644
> index 0000000..597beb8
> --- /dev/null
> +++ b/drivers/media/platform/meson/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_MESON_AO_CEC)	+= ao-cec.o
> diff --git a/drivers/media/platform/meson/ao-cec.c b/drivers/media/platform/meson/ao-cec.c
> new file mode 100644
> index 0000000..5c3607c
> --- /dev/null
> +++ b/drivers/media/platform/meson/ao-cec.c
> @@ -0,0 +1,744 @@
> +/*
> + * Driver for Amlogic Meson AO CEC Controller
> + *
> + * Copyright (C) 2015 Amlogic, Inc. All rights reserved
> + * Copyright (C) 2017 BayLibre, SAS
> + * Author: Neil Armstrong <narmstrong@baylibre.com>
> + *
> + * SPDX-License-Identifier: GPL-2.0+
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/clk.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +#include <linux/reset.h>
> +#include <media/cec.h>
> +#include <media/cec-notifier.h>
> +
> +/* CEC Registers */
> +
> +/*
> + * [2:1] cntl_clk
> + *  - 0 = Disable clk (Power-off mode)
> + *  - 1 = Enable gated clock (Normal mode)
> + *  - 2 = Enable free-run clk (Debug mode)
> + */
> +#define CEC_GEN_CNTL_REG		0x00
> +
> +#define CEC_GEN_CNTL_RESET		BIT(0)
> +#define CEC_GEN_CNTL_CLK_DISABLE	0
> +#define CEC_GEN_CNTL_CLK_ENABLE		1
> +#define CEC_GEN_CNTL_CLK_ENABLE_DBG	2
> +#define CEC_GEN_CNTL_CLK_CTRL_MASK	GENMASK(2, 1)
> +
> +/*
> + * [7:0] cec_reg_addr
> + * [15:8] cec_reg_wrdata
> + * [16] cec_reg_wr
> + *  - 0 = Read
> + *  - 1 = Write
> + * [23] bus free
> + * [31:24] cec_reg_rddata
> + */
> +#define CEC_RW_REG			0x04
> +
> +#define CEC_RW_ADDR			GENMASK(7, 0)
> +#define CEC_RW_WR_DATA			GENMASK(15, 8)
> +#define CEC_RW_WRITE_EN			BIT(16)
> +#define CEC_RW_BUS_BUSY			BIT(23)
> +#define CEC_RW_RD_DATA			GENMASK(31, 24)
> +
> +/*
> + * [1] tx intr
> + * [2] rx intr
> + */
> +#define CEC_INTR_MASKN_REG		0x08
> +#define CEC_INTR_CLR_REG		0x0c
> +#define CEC_INTR_STAT_REG		0x10
> +
> +#define CEC_INTR_TX			BIT(1)
> +#define CEC_INTR_RX			BIT(2)
> +
> +/* CEC Commands */
> +
> +#define CEC_TX_MSG_0_HEADER		0x00
> +#define CEC_TX_MSG_1_OPCODE		0x01
> +#define CEC_TX_MSG_2_OP1		0x02
> +#define CEC_TX_MSG_3_OP2		0x03
> +#define CEC_TX_MSG_4_OP3		0x04
> +#define CEC_TX_MSG_5_OP4		0x05
> +#define CEC_TX_MSG_6_OP5		0x06
> +#define CEC_TX_MSG_7_OP6		0x07
> +#define CEC_TX_MSG_8_OP7		0x08
> +#define CEC_TX_MSG_9_OP8		0x09
> +#define CEC_TX_MSG_A_OP9		0x0A
> +#define CEC_TX_MSG_B_OP10		0x0B
> +#define CEC_TX_MSG_C_OP11		0x0C
> +#define CEC_TX_MSG_D_OP12		0x0D
> +#define CEC_TX_MSG_E_OP13		0x0E
> +#define CEC_TX_MSG_F_OP14		0x0F
> +#define CEC_TX_MSG_LENGTH		0x10
> +#define CEC_TX_MSG_CMD			0x11
> +#define CEC_TX_WRITE_BUF		0x12
> +#define CEC_TX_CLEAR_BUF		0x13
> +#define CEC_RX_MSG_CMD			0x14
> +#define CEC_RX_CLEAR_BUF		0x15
> +#define CEC_LOGICAL_ADDR0		0x16
> +#define CEC_LOGICAL_ADDR1		0x17
> +#define CEC_LOGICAL_ADDR2		0x18
> +#define CEC_LOGICAL_ADDR3		0x19
> +#define CEC_LOGICAL_ADDR4		0x1A
> +#define CEC_CLOCK_DIV_H			0x1B
> +#define CEC_CLOCK_DIV_L			0x1C
> +#define CEC_QUIESCENT_25MS_BIT7_0	0x20
> +#define CEC_QUIESCENT_25MS_BIT11_8	0x21
> +#define CEC_STARTBITMINL2H_3MS5_BIT7_0	0x22
> +#define CEC_STARTBITMINL2H_3MS5_BIT8	0x23
> +#define CEC_STARTBITMAXL2H_3MS9_BIT7_0	0x24
> +#define CEC_STARTBITMAXL2H_3MS9_BIT8	0x25
> +#define CEC_STARTBITMINH_0MS6_BIT7_0	0x26
> +#define CEC_STARTBITMINH_0MS6_BIT8	0x27
> +#define CEC_STARTBITMAXH_1MS0_BIT7_0	0x28
> +#define CEC_STARTBITMAXH_1MS0_BIT8	0x29
> +#define CEC_STARTBITMINTOT_4MS3_BIT7_0	0x2A
> +#define CEC_STARTBITMINTOT_4MS3_BIT9_8	0x2B
> +#define CEC_STARTBITMAXTOT_4MS7_BIT7_0	0x2C
> +#define CEC_STARTBITMAXTOT_4MS7_BIT9_8	0x2D
> +#define CEC_LOGIC1MINL2H_0MS4_BIT7_0	0x2E
> +#define CEC_LOGIC1MINL2H_0MS4_BIT8	0x2F
> +#define CEC_LOGIC1MAXL2H_0MS8_BIT7_0	0x30
> +#define CEC_LOGIC1MAXL2H_0MS8_BIT8	0x31
> +#define CEC_LOGIC0MINL2H_1MS3_BIT7_0	0x32
> +#define CEC_LOGIC0MINL2H_1MS3_BIT8	0x33
> +#define CEC_LOGIC0MAXL2H_1MS7_BIT7_0	0x34
> +#define CEC_LOGIC0MAXL2H_1MS7_BIT8	0x35
> +#define CEC_LOGICMINTOTAL_2MS05_BIT7_0	0x36
> +#define CEC_LOGICMINTOTAL_2MS05_BIT9_8	0x37
> +#define CEC_LOGICMAXHIGH_2MS8_BIT7_0	0x38
> +#define CEC_LOGICMAXHIGH_2MS8_BIT8	0x39
> +#define CEC_LOGICERRLOW_3MS4_BIT7_0	0x3A
> +#define CEC_LOGICERRLOW_3MS4_BIT8	0x3B
> +#define CEC_NOMSMPPOINT_1MS05		0x3C
> +#define CEC_DELCNTR_LOGICERR		0x3E
> +#define CEC_TXTIME_17MS_BIT7_0		0x40
> +#define CEC_TXTIME_17MS_BIT10_8		0x41
> +#define CEC_TXTIME_2BIT_BIT7_0		0x42
> +#define CEC_TXTIME_2BIT_BIT10_8		0x43
> +#define CEC_TXTIME_4BIT_BIT7_0		0x44
> +#define CEC_TXTIME_4BIT_BIT10_8		0x45
> +#define CEC_STARTBITNOML2H_3MS7_BIT7_0	0x46
> +#define CEC_STARTBITNOML2H_3MS7_BIT8	0x47
> +#define CEC_STARTBITNOMH_0MS8_BIT7_0	0x48
> +#define CEC_STARTBITNOMH_0MS8_BIT8	0x49
> +#define CEC_LOGIC1NOML2H_0MS6_BIT7_0	0x4A
> +#define CEC_LOGIC1NOML2H_0MS6_BIT8	0x4B
> +#define CEC_LOGIC0NOML2H_1MS5_BIT7_0	0x4C
> +#define CEC_LOGIC0NOML2H_1MS5_BIT8	0x4D
> +#define CEC_LOGIC1NOMH_1MS8_BIT7_0	0x4E
> +#define CEC_LOGIC1NOMH_1MS8_BIT8	0x4F
> +#define CEC_LOGIC0NOMH_0MS9_BIT7_0	0x50
> +#define CEC_LOGIC0NOMH_0MS9_BIT8	0x51
> +#define CEC_LOGICERRLOW_3MS6_BIT7_0	0x52
> +#define CEC_LOGICERRLOW_3MS6_BIT8	0x53
> +#define CEC_CHKCONTENTION_0MS1		0x54
> +#define CEC_PREPARENXTBIT_0MS05_BIT7_0	0x56
> +#define CEC_PREPARENXTBIT_0MS05_BIT8	0x57
> +#define CEC_NOMSMPACKPOINT_0MS45	0x58
> +#define CEC_ACK0NOML2H_1MS5_BIT7_0	0x5A
> +#define CEC_ACK0NOML2H_1MS5_BIT8	0x5B
> +#define CEC_BUGFIX_DISABLE_0		0x60
> +#define CEC_BUGFIX_DISABLE_1		0x61
> +#define CEC_RX_MSG_0_HEADER		0x80
> +#define CEC_RX_MSG_1_OPCODE		0x81
> +#define CEC_RX_MSG_2_OP1		0x82
> +#define CEC_RX_MSG_3_OP2		0x83
> +#define CEC_RX_MSG_4_OP3		0x84
> +#define CEC_RX_MSG_5_OP4		0x85
> +#define CEC_RX_MSG_6_OP5		0x86
> +#define CEC_RX_MSG_7_OP6		0x87
> +#define CEC_RX_MSG_8_OP7		0x88
> +#define CEC_RX_MSG_9_OP8		0x89
> +#define CEC_RX_MSG_A_OP9		0x8A
> +#define CEC_RX_MSG_B_OP10		0x8B
> +#define CEC_RX_MSG_C_OP11		0x8C
> +#define CEC_RX_MSG_D_OP12		0x8D
> +#define CEC_RX_MSG_E_OP13		0x8E
> +#define CEC_RX_MSG_F_OP14		0x8F
> +#define CEC_RX_MSG_LENGTH		0x90
> +#define CEC_RX_MSG_STATUS		0x91
> +#define CEC_RX_NUM_MSG			0x92
> +#define CEC_TX_MSG_STATUS		0x93
> +#define CEC_TX_NUM_MSG			0x94
> +
> +
> +/* CEC_TX_MSG_CMD definition */
> +#define TX_NO_OP	0  /* No transaction */
> +#define TX_REQ_CURRENT	1  /* Transmit earliest message in buffer */
> +#define TX_ABORT	2  /* Abort transmitting earliest message */
> +#define TX_REQ_NEXT	3  /* Overwrite earliest msg, transmit next */
> +
> +/* tx_msg_status definition */
> +#define TX_IDLE		0  /* No transaction */
> +#define TX_BUSY		1  /* Transmitter is busy */
> +#define TX_DONE		2  /* Message successfully transmitted */
> +#define TX_ERROR	3  /* Message transmitted with error */
> +
> +/* rx_msg_cmd */
> +#define RX_NO_OP	0  /* No transaction */
> +#define RX_ACK_CURRENT	1  /* Read earliest message in buffer */
> +#define RX_DISABLE	2  /* Disable receiving latest message */
> +#define RX_ACK_NEXT	3  /* Clear earliest msg, read next */
> +
> +/* rx_msg_status */
> +#define RX_IDLE		0  /* No transaction */
> +#define RX_BUSY		1  /* Receiver is busy */
> +#define RX_DONE		2  /* Message has been received successfully */
> +#define RX_ERROR	3  /* Message has been received with error */
> +
> +/* RX_CLEAR_BUF options */
> +#define CLEAR_START	1
> +#define CLEAR_STOP	0
> +
> +/* CEC_LOGICAL_ADDRx options */
> +#define LOGICAL_ADDR_MASK	0xf
> +#define LOGICAL_ADDR_VALID	BIT(4)
> +#define LOGICAL_ADDR_DISABLE	0
> +
> +#define CEC_CLK_RATE		32768
> +
> +struct meson_ao_cec_device {
> +	struct platform_device		*pdev;
> +	void __iomem			*base;
> +	struct clk			*core;
> +	spinlock_t			cec_reg_lock;
> +	struct cec_notifier		*notify;
> +	struct cec_adapter		*adap;
> +	struct cec_msg			rx_msg;
> +};
> +
> +#define writel_bits_relaxed(mask, val, addr) \
> +	writel_relaxed((readl_relaxed(addr) & ~(mask)) | (val), addr)
> +
> +static inline int meson_ao_cec_wait_busy(struct meson_ao_cec_device *ao_cec)
> +{
> +	ktime_t timeout = ktime_add_us(ktime_get(), 5000);
> +
> +	while (readl_relaxed(ao_cec->base + CEC_RW_REG) & CEC_RW_BUS_BUSY) {
> +		if (ktime_compare(ktime_get(), timeout) > 0)
> +			return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +
> +static void meson_ao_cec_read(struct meson_ao_cec_device *ao_cec,
> +			     unsigned long address, u8 *data,
> +			     int *res)
> +{
> +	unsigned long flags;
> +	u32 reg = FIELD_PREP(CEC_RW_ADDR, address);
> +	int ret = 0;
> +
> +	if (res && *res)
> +		return;
> +
> +	spin_lock_irqsave(&ao_cec->cec_reg_lock, flags);
> +
> +	ret = meson_ao_cec_wait_busy(ao_cec);
> +	if (ret)
> +		goto read_out;
> +
> +	writel_relaxed(reg, ao_cec->base + CEC_RW_REG);
> +
> +	ret = meson_ao_cec_wait_busy(ao_cec);
> +	if (ret)
> +		goto read_out;
> +
> +	*data = FIELD_GET(CEC_RW_RD_DATA,
> +			  readl_relaxed(ao_cec->base + CEC_RW_REG));
> +
> +read_out:
> +	spin_unlock_irqrestore(&ao_cec->cec_reg_lock, flags);
> +
> +	if (res)
> +		*res = ret;
> +}
> +
> +static void meson_ao_cec_write(struct meson_ao_cec_device *ao_cec,
> +			       unsigned long address, u8 data,
> +			       int *res)
> +{
> +	unsigned long flags;
> +	u32 reg = FIELD_PREP(CEC_RW_ADDR, address) |
> +		  FIELD_PREP(CEC_RW_WR_DATA, data) |
> +		  CEC_RW_WRITE_EN;
> +	int ret = 0;
> +
> +	if (res && *res)
> +		return;
> +
> +	spin_lock_irqsave(&ao_cec->cec_reg_lock, flags);
> +
> +	ret = meson_ao_cec_wait_busy(ao_cec);
> +	if (ret)
> +		goto write_out;
> +
> +	writel_relaxed(reg, ao_cec->base + CEC_RW_REG);
> +
> +write_out:
> +	spin_unlock_irqrestore(&ao_cec->cec_reg_lock, flags);
> +
> +	if (ret)
> +		*res = ret;

smatch error:

drivers/media/platform/meson/ao-cec.c:301 meson_ao_cec_write() error: we previously assumed 'res' could be null (see line 286)

Obvious typo: if (ret) should be if (res). I'll fix that, no need for
a new version of this patch.

Regards,

	Hans
