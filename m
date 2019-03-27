Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4896C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E5502146F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbfC0MwU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:52:20 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56001 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726319AbfC0MwU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 08:52:20 -0400
Received: from [IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f] ([IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 982OhBJpJUjKf982RhowzY; Wed, 27 Mar 2019 13:52:15 +0100
Subject: Re: [PATCH 2/3] media: platform: meson: Add Amlogic Meson G12A AO CEC
 Controller driver
To:     Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org
Cc:     linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190325173501.22863-1-narmstrong@baylibre.com>
 <20190325173501.22863-3-narmstrong@baylibre.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7a23915b-0696-d884-7f56-309579f67bdd@xs4all.nl>
Date:   Wed, 27 Mar 2019 13:52:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190325173501.22863-3-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLlT92l/trGtN24lnr2VB+dZHQS+Hhd4AgmPNuSgFhJlBB7SPkAXGxdmbgrF5z76+EywCzST2YYJc4GXSyVH6BvnjofyiSqANcTl/f8NZPL3NViv9Yos
 ypZgSiMX9xtYTklbNLJlqUqQv2AbdpyMTzG1R080Julx+P86e3XE91EU96A2Fr8fpf75AGtXMgvt+LnqnK8wEu4VnwJBVqiGGoU/jSiS/I9df9Iun91inQ14
 Aa72IRU7fRoHLjArmZQcuZ9GnKtwUnVXuILLrMw2gq6e64myv7IxBgkl+sLIRzwyYOzSUCeKAd92/Fon9hrRQHw8vW9pRytCYADzaGNAsUwH5vRW4PsBnpKe
 yu7SSaVKLG9xcWZKCgNcEZwIrE33MU38Q/1CW03K+4x7FTpPOtDKysiAe4tIkRIpxdQ9rsaFS1UbOq1HZCzWWZfK6qq+K6554pbhYNQYPX6YXyLERFzlirRC
 BD/invDn2kVS4fthSZ17ahQS4fQFusQd+/kY+A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/25/19 6:35 PM, Neil Armstrong wrote:
> The Amlogic G12A SoC embeds a second CEC controller with a totally
> different design.
> 
> The two controller can work in the same time since the CEC line can
> be set to two different pins on the two controllers.
> 
> This second CEC controller is documented as "AO-CEC-B", thus the
> registers will be named "CECB_" to differenciate with the other
> AO-CEC driver.
> 
> Unlike the other AO-CEC controller, this one takes the Oscillator
> clock as input and embeds a dual-divider to provide a precise
> 32768Hz clock for communication. This is handled by registering
> a clock in the driver.
> 
> Unlike the other AO-CEC controller, this controller supports setting
> up to 15 logical adresses and supports the signal_free_time settings
> in the transmit function.
> 
> Unfortunately, this controller does not support "monitor" mode.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/media/platform/Kconfig             |  13 +
>  drivers/media/platform/meson/Makefile      |   1 +
>  drivers/media/platform/meson/ao-cec-g12a.c | 783 +++++++++++++++++++++
>  3 files changed, 797 insertions(+)
>  create mode 100644 drivers/media/platform/meson/ao-cec-g12a.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 4acbed189644..92ea07ddc609 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -578,6 +578,19 @@ config VIDEO_MESON_AO_CEC
>  	  generic CEC framework interface.
>  	  CEC bus is present in the HDMI connector and enables communication
>  
> +config VIDEO_MESON_G12A_AO_CEC
> +	tristate "Amlogic Meson G12A AO CEC driver"
> +	depends on ARCH_MESON || COMPILE_TEST
> +	select CEC_CORE
> +	select CEC_NOTIFIER
> +	---help---
> +	  This is a driver for Amlogic Meson G12A SoCs AO CEC interface.
> +	  This driver if for the new AO-CEC module found in G12A SoCs,
> +	  usually named AO_CEC_B in documentation.
> +	  It uses the generic CEC framework interface.
> +	  CEC bus is present in the HDMI connector and enables communication
> +	  between compatible devices.
> +
>  config CEC_GPIO
>  	tristate "Generic GPIO-based CEC driver"
>  	depends on PREEMPT || COMPILE_TEST
> diff --git a/drivers/media/platform/meson/Makefile b/drivers/media/platform/meson/Makefile
> index 597beb8f34d1..f611c23c3718 100644
> --- a/drivers/media/platform/meson/Makefile
> +++ b/drivers/media/platform/meson/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_VIDEO_MESON_AO_CEC)	+= ao-cec.o
> +obj-$(CONFIG_VIDEO_MESON_G12A_AO_CEC)	+= ao-cec-g12a.o
> diff --git a/drivers/media/platform/meson/ao-cec-g12a.c b/drivers/media/platform/meson/ao-cec-g12a.c
> new file mode 100644
> index 000000000000..8977ae994164
> --- /dev/null
> +++ b/drivers/media/platform/meson/ao-cec-g12a.c
> @@ -0,0 +1,783 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Driver for Amlogic Meson AO CEC G12A Controller
> + *
> + * Copyright (C) 2017 Amlogic, Inc. All rights reserved
> + * Copyright (C) 2019 BayLibre, SAS
> + * Author: Neil Armstrong <narmstrong@baylibre.com>
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
> +#include <linux/slab.h>
> +#include <linux/regmap.h>
> +#include <media/cec.h>
> +#include <media/cec-notifier.h>
> +#include <linux/clk-provider.h>
> +
> +/* CEC Registers */
> +
> +#define CECB_CLK_CNTL_REG0		0x00
> +
> +#define CECB_CLK_CNTL_N1		GENMASK(11, 0)
> +#define CECB_CLK_CNTL_N2		GENMASK(23, 12)
> +#define CECB_CLK_CNTL_DUAL_EN		BIT(28)
> +#define CECB_CLK_CNTL_OUTPUT_EN		BIT(30)
> +#define CECB_CLK_CNTL_INPUT_EN		BIT(31)
> +
> +#define CECB_CLK_CNTL_REG1		0x04
> +
> +#define CECB_CLK_CNTL_M1		GENMASK(11, 0)
> +#define CECB_CLK_CNTL_M2		GENMASK(23, 12)
> +#define CECB_CLK_CNTL_BYPASS_EN		BIT(24)
> +
> +/*
> + * [14:12] Filter_del. For glitch-filtering CEC line, ignore signal
> + *       change pulse width < filter_del * T(filter_tick) * 3.
> + * [9:8] Filter_tick_sel: Select which periodical pulse for
> + *       glitch-filtering CEC line signal.
> + *  - 0=Use T(xtal)*3 = 125ns;
> + *  - 1=Use once-per-1us pulse;
> + *  - 2=Use once-per-10us pulse;
> + *  - 3=Use once-per-100us pulse.
> + * [3]   Sysclk_en. 0=Disable system clock; 1=Enable system clock.
> + * [2:1] cntl_clk
> + *  - 0 = Disable clk (Power-off mode)
> + *  - 1 = Enable gated clock (Normal mode)
> + *  - 2 = Enable free-run clk (Debug mode)
> + * [0] SW_RESET 1=Apply reset; 0=No reset.
> + */
> +#define CECB_GEN_CNTL_REG		0x08
> +
> +#define CECB_GEN_CNTL_RESET		BIT(0)
> +#define CECB_GEN_CNTL_CLK_DISABLE	0
> +#define CECB_GEN_CNTL_CLK_ENABLE	1
> +#define CECB_GEN_CNTL_CLK_ENABLE_DBG	2
> +#define CECB_GEN_CNTL_CLK_CTRL_MASK	GENMASK(2, 1)
> +#define CECB_GEN_CNTL_SYS_CLK_EN	BIT(3)
> +#define CECB_GEN_CNTL_FILTER_TICK_125NS	0
> +#define CECB_GEN_CNTL_FILTER_TICK_1US	1
> +#define CECB_GEN_CNTL_FILTER_TICK_10US	2
> +#define CECB_GEN_CNTL_FILTER_TICK_100US	3
> +#define CECB_GEN_CNTL_FILTER_TICK_SEL	GENMASK(9, 8)
> +#define CECB_GEN_CNTL_FILTER_DEL	GENMASK(14, 12)
> +
> +/*
> + * [7:0] cec_reg_addr
> + * [15:8] cec_reg_wrdata
> + * [16] cec_reg_wr
> + *  - 0 = Read
> + *  - 1 = Write
> + * [31:24] cec_reg_rddata
> + */
> +#define CECB_RW_REG			0x0c
> +
> +#define CECB_RW_ADDR			GENMASK(7, 0)
> +#define CECB_RW_WR_DATA			GENMASK(15, 8)
> +#define CECB_RW_WRITE_EN		BIT(16)
> +#define CECB_RW_BUS_BUSY		BIT(23)
> +#define CECB_RW_RD_DATA			GENMASK(31, 24)
> +
> +/*
> + * [0] DONE Interrupt
> + * [1] End Of Message Interrupt
> + * [2] Not Acknowlegde Interrupt
> + * [3] Arbitration Loss Interrupt
> + * [4] Initiator Error Interrupt
> + * [5] Follower Error Interrupt
> + * [6] Wake-Up Interrupt
> + */
> +#define CECB_INTR_MASKN_REG		0x10
> +#define CECB_INTR_CLR_REG		0x14
> +#define CECB_INTR_STAT_REG		0x18
> +
> +#define CECB_INTR_DONE			BIT(0)
> +#define CECB_INTR_EOM			BIT(1)
> +#define CECB_INTR_NACK			BIT(2)
> +#define CECB_INTR_ARB_LOSS		BIT(3)
> +#define CECB_INTR_INITIATOR_ERR		BIT(4)
> +#define CECB_INTR_FOLLOWER_ERR		BIT(5)
> +#define CECB_INTR_WAKE_UP		BIT(6)
> +
> +/* CEC Commands */
> +
> +#define CECB_CTRL		0x00
> +
> +#define CECB_CTRL_SEND		BIT(0)
> +#define CECB_CTRL_TYPE		GENMASK(2, 1)
> +#define CECB_CTRL_TYPE_RETRY	0
> +#define CECB_CTRL_TYPE_NEW	1
> +#define CECB_CTRL_TYPE_NEXT	2
> +
> +#define CECB_CTRL2		0x01
> +#define CECB_INTR_MASK		0x02
> +#define CECB_LADD_LOW		0x05
> +#define CECB_LADD_HIGH		0x06
> +#define CECB_TX_CNT		0x07
> +#define CECB_RX_CNT		0x08
> +#define CECB_STAT0		0x09
> +#define CECB_TX_DATA00		0x10
> +#define CECB_TX_DATA01		0x11
> +#define CECB_TX_DATA02		0x12
> +#define CECB_TX_DATA03		0x13
> +#define CECB_TX_DATA04		0x14
> +#define CECB_TX_DATA05		0x15
> +#define CECB_TX_DATA06		0x16
> +#define CECB_TX_DATA07		0x17
> +#define CECB_TX_DATA08		0x18
> +#define CECB_TX_DATA09		0x19
> +#define CECB_TX_DATA10		0x1A
> +#define CECB_TX_DATA11		0x1B
> +#define CECB_TX_DATA12		0x1C
> +#define CECB_TX_DATA13		0x1D
> +#define CECB_TX_DATA14		0x1E
> +#define CECB_TX_DATA15		0x1F
> +#define CECB_RX_DATA00		0x20
> +#define CECB_RX_DATA01		0x21
> +#define CECB_RX_DATA02		0x22
> +#define CECB_RX_DATA03		0x23
> +#define CECB_RX_DATA04		0x24
> +#define CECB_RX_DATA05		0x25
> +#define CECB_RX_DATA06		0x26
> +#define CECB_RX_DATA07		0x27
> +#define CECB_RX_DATA08		0x28
> +#define CECB_RX_DATA09		0x29
> +#define CECB_RX_DATA10		0x2A
> +#define CECB_RX_DATA11		0x2B
> +#define CECB_RX_DATA12		0x2C
> +#define CECB_RX_DATA13		0x2D
> +#define CECB_RX_DATA14		0x2E
> +#define CECB_RX_DATA15		0x2F
> +#define CECB_LOCK_BUF		0x30
> +
> +#define CECB_LOCK_BUF_EN	BIT(0)
> +
> +#define CECB_WAKEUPCTRL		0x31
> +
> +struct meson_ao_cec_g12a_device {
> +	struct platform_device		*pdev;
> +	struct regmap			*regmap;
> +	struct regmap			*regmap_cec;
> +	spinlock_t			cec_reg_lock;
> +	struct cec_notifier		*notify;
> +	struct cec_adapter		*adap;
> +	struct cec_msg			rx_msg;
> +	struct clk			*oscin;
> +	struct clk			*core;
> +};
> +
> +static const struct regmap_config meson_ao_cec_g12a_regmap_conf = {
> +	.reg_bits = 8,
> +	.val_bits = 32,
> +	.reg_stride = 4,
> +	.max_register = CECB_INTR_STAT_REG,
> +};
> +
> +/*
> + * The AO-CECB embeds a dual/divider to generate a more precise
> + * 32,768KHz clock for CEC core clock.
> + *                      ______   ______
> + *                     |      | |      |
> + *         ______      | Div1 |-| Cnt1 |       ______
> + *        |      |    /|______| |______|\     |      |
> + * Xtal-->| Gate |---|  ______   ______  X-X--| Gate |-->
> + *        |______| |  \|      | |      |/  |  |______|
> + *                 |   | Div2 |-| Cnt2 |   |
> + *                 |   |______| |______|   |
> + *                 |_______________________|
> + *
> + * The dividing can be switched to single or dual, with a counter
> + * for each divider to set when the switching is done.
> + * The entire dividing mechanism can be also bypassed.
> + */
> +
> +struct meson_ao_cec_g12a_dualdiv_clk {
> +	struct clk_hw hw;
> +	struct regmap *regmap;
> +};
> +
> +#define hw_to_meson_ao_cec_g12a_dualdiv_clk(_hw)			\
> +	container_of(_hw, struct meson_ao_cec_g12a_dualdiv_clk, hw)	\
> +
> +static unsigned long
> +meson_ao_cec_g12a_dualdiv_clk_recalc_rate(struct clk_hw *hw,
> +					  unsigned long parent_rate)
> +{
> +	struct meson_ao_cec_g12a_dualdiv_clk *dualdiv_clk =
> +		hw_to_meson_ao_cec_g12a_dualdiv_clk(hw);
> +	unsigned long n1;
> +	u32 reg0, reg1;
> +
> +	regmap_read(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0, &reg0);
> +	regmap_read(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0, &reg1);
> +
> +	if (reg1 & CECB_CLK_CNTL_BYPASS_EN)
> +		return parent_rate;
> +
> +	if (reg0 & CECB_CLK_CNTL_DUAL_EN) {
> +		unsigned long n2, m1, m2, f1, f2, p1, p2;
> +
> +		n1 = FIELD_GET(CECB_CLK_CNTL_N1, reg0) + 1;
> +		n2 = FIELD_GET(CECB_CLK_CNTL_N2, reg0) + 1;
> +
> +		m1 = FIELD_GET(CECB_CLK_CNTL_M1, reg1) + 1;
> +		m2 = FIELD_GET(CECB_CLK_CNTL_M1, reg1) + 1;
> +
> +		f1 = DIV_ROUND_CLOSEST(parent_rate, n1);
> +		f2 = DIV_ROUND_CLOSEST(parent_rate, n2);
> +
> +		p1 = DIV_ROUND_CLOSEST(100000000 * m1, f1 * (m1 + m2));
> +		p2 = DIV_ROUND_CLOSEST(100000000 * m2, f2 * (m1 + m2));
> +
> +		return DIV_ROUND_UP(100000000, p1 + p2);
> +	}
> +
> +	n1 = FIELD_GET(CECB_CLK_CNTL_N1, reg0) + 1;
> +
> +	return DIV_ROUND_CLOSEST(parent_rate, n1);
> +}
> +
> +static int meson_ao_cec_g12a_dualdiv_clk_enable(struct clk_hw *hw)
> +{
> +	struct meson_ao_cec_g12a_dualdiv_clk *dualdiv_clk =
> +		hw_to_meson_ao_cec_g12a_dualdiv_clk(hw);
> +
> +
> +	/* Disable Input & Output */
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0,
> +			   CECB_CLK_CNTL_INPUT_EN | CECB_CLK_CNTL_OUTPUT_EN,
> +			   0);
> +
> +	/* Set N1 & N2 */
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0,
> +			   CECB_CLK_CNTL_N1,
> +			   FIELD_PREP(CECB_CLK_CNTL_N1, 733 - 1));
> +
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0,
> +			   CECB_CLK_CNTL_N2,
> +			   FIELD_PREP(CECB_CLK_CNTL_N2, 732 - 1));
> +
> +	/* Set M1 & M2 */
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG1,
> +			   CECB_CLK_CNTL_M1,
> +			   FIELD_PREP(CECB_CLK_CNTL_M1, 8 - 1));
> +
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG1,
> +			   CECB_CLK_CNTL_M2,
> +			   FIELD_PREP(CECB_CLK_CNTL_M2, 11 - 1));
> +
> +	/* Enable Dual divisor */
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0,
> +			   CECB_CLK_CNTL_DUAL_EN, CECB_CLK_CNTL_DUAL_EN);
> +
> +	/* Disable divisor bypass */
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG1,
> +			   CECB_CLK_CNTL_BYPASS_EN, 0);
> +
> +	/* Enable Input & Output */
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0,
> +			   CECB_CLK_CNTL_INPUT_EN | CECB_CLK_CNTL_OUTPUT_EN,
> +			   CECB_CLK_CNTL_INPUT_EN | CECB_CLK_CNTL_OUTPUT_EN);
> +
> +	return 0;
> +}
> +
> +static void meson_ao_cec_g12a_dualdiv_clk_disable(struct clk_hw *hw)
> +{
> +	struct meson_ao_cec_g12a_dualdiv_clk *dualdiv_clk =
> +		hw_to_meson_ao_cec_g12a_dualdiv_clk(hw);
> +
> +	regmap_update_bits(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0,
> +			   CECB_CLK_CNTL_INPUT_EN | CECB_CLK_CNTL_OUTPUT_EN,
> +			   0);
> +}
> +
> +static int meson_ao_cec_g12a_dualdiv_clk_is_enabled(struct clk_hw *hw)
> +{
> +	struct meson_ao_cec_g12a_dualdiv_clk *dualdiv_clk =
> +		hw_to_meson_ao_cec_g12a_dualdiv_clk(hw);
> +	int val;
> +
> +	regmap_read(dualdiv_clk->regmap, CECB_CLK_CNTL_REG0, &val);
> +
> +	return !!(val & (CECB_CLK_CNTL_INPUT_EN | CECB_CLK_CNTL_OUTPUT_EN));
> +}
> +
> +static const struct clk_ops meson_ao_cec_g12a_dualdiv_clk_ops = {
> +	.recalc_rate	= meson_ao_cec_g12a_dualdiv_clk_recalc_rate,
> +	.is_enabled	= meson_ao_cec_g12a_dualdiv_clk_is_enabled,
> +	.enable		= meson_ao_cec_g12a_dualdiv_clk_enable,
> +	.disable	= meson_ao_cec_g12a_dualdiv_clk_disable,
> +};
> +
> +static int meson_ao_cec_g12a_setup_clk(struct meson_ao_cec_g12a_device *ao_cec)
> +{
> +	struct meson_ao_cec_g12a_dualdiv_clk *dualdiv_clk;
> +	struct device *dev = &ao_cec->pdev->dev;
> +	struct clk_init_data init;
> +	const char *parent_name;
> +	struct clk *clk;
> +	char *name;
> +
> +	dualdiv_clk = devm_kzalloc(dev, sizeof(*dualdiv_clk), GFP_KERNEL);
> +	if (!dualdiv_clk)
> +		return -ENOMEM;
> +
> +	name = kasprintf(GFP_KERNEL, "%s#dualdiv_clk", dev_name(dev));
> +	if (!name)
> +		return -ENOMEM;
> +
> +	parent_name = __clk_get_name(ao_cec->oscin);
> +
> +	init.name = name;
> +	init.ops = &meson_ao_cec_g12a_dualdiv_clk_ops;
> +	init.flags = 0;
> +	init.parent_names = &parent_name;
> +	init.num_parents = 1;
> +	dualdiv_clk->regmap = ao_cec->regmap;
> +	dualdiv_clk->hw.init = &init;
> +
> +	clk = devm_clk_register(dev, &dualdiv_clk->hw);
> +	kfree(name);
> +	if (IS_ERR(clk)) {
> +		dev_err(dev, "failed to register clock\n");
> +		return PTR_ERR(clk);
> +	}
> +
> +	ao_cec->core = clk;
> +
> +	return 0;
> +}
> +
> +static int meson_ao_cec_g12a_read(void *context, unsigned int addr,
> +				  unsigned int *data)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = context;
> +	u32 reg = FIELD_PREP(CECB_RW_ADDR, addr);
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&ao_cec->cec_reg_lock, flags);
> +
> +	ret = regmap_write(ao_cec->regmap, CECB_RW_REG, reg);
> +
> +	ret = regmap_read_poll_timeout(ao_cec->regmap, CECB_RW_REG, reg,
> +				       !(reg & CECB_RW_BUS_BUSY),
> +				       5, 1000);
> +	if (ret)
> +		goto read_out;
> +
> +	ret = regmap_read(ao_cec->regmap, CECB_RW_REG, &reg);
> +
> +	*data = FIELD_GET(CECB_RW_RD_DATA, reg);
> +
> +read_out:
> +	spin_unlock_irqrestore(&ao_cec->cec_reg_lock, flags);
> +
> +	return ret;
> +}
> +
> +static int meson_ao_cec_g12a_write(void *context, unsigned int addr,
> +				   unsigned int data)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = context;
> +	unsigned long flags;
> +	u32 reg = FIELD_PREP(CECB_RW_ADDR, addr) |
> +		  FIELD_PREP(CECB_RW_WR_DATA, data) |
> +		  CECB_RW_WRITE_EN;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&ao_cec->cec_reg_lock, flags);
> +
> +	ret = regmap_write(ao_cec->regmap, CECB_RW_REG, reg);
> +
> +	spin_unlock_irqrestore(&ao_cec->cec_reg_lock, flags);
> +
> +	return ret;
> +}
> +
> +static const struct regmap_config meson_ao_cec_g12a_cec_regmap_conf = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.reg_read = meson_ao_cec_g12a_read,
> +	.reg_write = meson_ao_cec_g12a_write,
> +	.max_register = 0xffff,
> +	.fast_io = true,
> +};
> +
> +static inline void
> +meson_ao_cec_g12a_irq_setup(struct meson_ao_cec_g12a_device *ao_cec,
> +			    bool enable)
> +{
> +	u32 cfg = CECB_INTR_DONE | CECB_INTR_EOM | CECB_INTR_NACK |
> +		  CECB_INTR_ARB_LOSS | CECB_INTR_INITIATOR_ERR |
> +		  CECB_INTR_FOLLOWER_ERR;
> +
> +	regmap_write(ao_cec->regmap, CECB_INTR_MASKN_REG,
> +		     enable ? cfg : 0);
> +}
> +
> +static void meson_ao_cec_g12a_irq_rx(struct meson_ao_cec_g12a_device *ao_cec)
> +{
> +	int i, ret = 0;
> +	u32 val;
> +
> +	ret = regmap_read(ao_cec->regmap_cec, CECB_RX_CNT, &val);
> +
> +	ao_cec->rx_msg.len = val;
> +	if (ao_cec->rx_msg.len > CEC_MAX_MSG_SIZE)
> +		ao_cec->rx_msg.len = CEC_MAX_MSG_SIZE;
> +
> +	for (i = 0; i < ao_cec->rx_msg.len; i++) {
> +		ret |= regmap_read(ao_cec->regmap_cec,
> +				   CECB_RX_DATA00 + i, &val);
> +
> +		ao_cec->rx_msg.msg[i] = val & 0xff;
> +	}
> +
> +	ret |= regmap_write(ao_cec->regmap_cec, CECB_LOCK_BUF, 0);
> +	if (ret)
> +		return;
> +
> +	cec_received_msg(ao_cec->adap, &ao_cec->rx_msg);
> +}
> +
> +static irqreturn_t meson_ao_cec_g12a_irq(int irq, void *data)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = data;
> +	u32 stat;
> +
> +	regmap_read(ao_cec->regmap, CECB_INTR_STAT_REG, &stat);
> +	if (stat)
> +		return IRQ_WAKE_THREAD;
> +
> +	return IRQ_NONE;
> +}
> +
> +static irqreturn_t meson_ao_cec_g12a_irq_thread(int irq, void *data)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = data;
> +	u32 stat;
> +
> +	regmap_read(ao_cec->regmap, CECB_INTR_STAT_REG, &stat);
> +	regmap_write(ao_cec->regmap, CECB_INTR_CLR_REG, stat);
> +
> +	if (stat & CECB_INTR_DONE)
> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_OK);
> +
> +	if (stat & CECB_INTR_EOM)
> +		meson_ao_cec_g12a_irq_rx(ao_cec);
> +
> +	if (stat & CECB_INTR_NACK)
> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_NACK);
> +
> +	if (stat & CECB_INTR_ARB_LOSS) {
> +		regmap_write(ao_cec->regmap_cec, CECB_TX_CNT, 0);
> +		regmap_update_bits(ao_cec->regmap_cec, CECB_CTRL,
> +				   CECB_CTRL_SEND | CECB_CTRL_TYPE, 0);
> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_ARB_LOST);
> +	}
> +
> +	if (stat & CECB_INTR_INITIATOR_ERR)
> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_NACK);
> +
> +	if (stat & CECB_INTR_FOLLOWER_ERR) {
> +		regmap_write(ao_cec->regmap_cec, CECB_LOCK_BUF, 0);
> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_NACK);

Any idea what CECB_INTR_INITIATOR_ERR and CECB_INTR_FOLLOWER_ERR actually
mean? I.e. is returning NACK right here, or would TX_STATUS_ERROR be a
better choice? I invented that status precisely for cases where there is
an error, but we don't know what it means.

Are you sure that CECB_INTR_FOLLOWER_ERR applies to a transmit and not a
receive? 'Follower' suggests that some error occurred while receiving
a message. If I am right, then just ignore it.

Regarding CECB_INTR_INITIATOR_ERR: I suspect that this indicates a LOW
DRIVE error situation, in which case you'd return that transmit status.

> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int
> +meson_ao_cec_g12a_set_log_addr(struct cec_adapter *adap, u8 logical_addr)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = adap->priv;
> +	int ret = 0;
> +
> +	if (logical_addr == CEC_LOG_ADDR_INVALID) {
> +		ret = regmap_write(ao_cec->regmap_cec, CECB_LADD_LOW, 0);
> +		ret = regmap_write(ao_cec->regmap_cec, CECB_LADD_HIGH, 0);

Just ignore the error codes and return 0 here.

The CEC core will WARN if this function returns anything other than 0
when invalidating the logical addresses. It assumes this will always
succeed.

> +	} else if (logical_addr < 8) {
> +		ret = regmap_update_bits(ao_cec->regmap_cec, CECB_LADD_LOW,
> +					 BIT(logical_addr),
> +					 BIT(logical_addr));
> +	} else {
> +		ret = regmap_update_bits(ao_cec->regmap_cec, CECB_LADD_HIGH,
> +					 BIT(logical_addr - 8),
> +					 BIT(logical_addr - 8));
> +	}
> +
> +	/* Always set Broadcast/Unregistered 15 address */
> +	ret |= regmap_update_bits(ao_cec->regmap_cec, CECB_LADD_HIGH,

I'd just do:

	if (!ret)
		ret = regmap_...

Error codes are not a bitmask after all.

I see that elsewhere as well.

It's OK to use |=, but then when you return from the function you
would have to do something like:

	return ret ? -EIO : 0;

Regards,

	Hans

> +				  BIT(CEC_LOG_ADDR_UNREGISTERED - 8),
> +				  BIT(CEC_LOG_ADDR_UNREGISTERED - 8));
> +
> +	return ret;
> +}
> +
> +static int meson_ao_cec_g12a_transmit(struct cec_adapter *adap, u8 attempts,
> +				 u32 signal_free_time, struct cec_msg *msg)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = adap->priv;
> +	unsigned int type;
> +	int ret = 0;
> +	u32 val;
> +	int i;
> +
> +	/* Check if RX is in progress */
> +	ret = regmap_read(ao_cec->regmap_cec, CECB_LOCK_BUF, &val);
> +	if (ret)
> +		return ret;
> +	if (val & CECB_LOCK_BUF_EN)
> +		return -EBUSY;
> +
> +	/* Check if TX Busy */
> +	ret = regmap_read(ao_cec->regmap_cec, CECB_CTRL, &val);
> +	if (ret)
> +		return ret;
> +	if (val & CECB_CTRL_SEND)
> +		return -EBUSY;
> +
> +	switch (signal_free_time) {
> +	case CEC_SIGNAL_FREE_TIME_RETRY:
> +		type = CECB_CTRL_TYPE_RETRY;
> +		break;
> +	case CEC_SIGNAL_FREE_TIME_NEXT_XFER:
> +		type = CECB_CTRL_TYPE_NEXT;
> +		break;
> +	case CEC_SIGNAL_FREE_TIME_NEW_INITIATOR:
> +	default:
> +		type = CECB_CTRL_TYPE_NEW;
> +		break;
> +	}
> +
> +	for (i = 0; i < msg->len; i++)
> +		ret |= regmap_write(ao_cec->regmap_cec, CECB_TX_DATA00 + i,
> +				    msg->msg[i]);
> +
> +	ret |= regmap_write(ao_cec->regmap_cec, CECB_TX_CNT, msg->len);
> +	ret = regmap_update_bits(ao_cec->regmap_cec, CECB_CTRL,
> +				 CECB_CTRL_SEND |
> +				 CECB_CTRL_TYPE,
> +				 CECB_CTRL_SEND |
> +				 FIELD_PREP(CECB_CTRL_TYPE, type));
> +
> +	return ret;
> +}
> +
> +static int meson_ao_cec_g12a_adap_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = adap->priv;
> +
> +	meson_ao_cec_g12a_irq_setup(ao_cec, false);
> +
> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
> +			   CECB_GEN_CNTL_RESET, CECB_GEN_CNTL_RESET);
> +
> +	if (!enable)
> +		return 0;
> +
> +	/* Setup Filter */
> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
> +			   CECB_GEN_CNTL_FILTER_TICK_SEL |
> +			   CECB_GEN_CNTL_FILTER_DEL,
> +			   FIELD_PREP(CECB_GEN_CNTL_FILTER_TICK_SEL,
> +				      CECB_GEN_CNTL_FILTER_TICK_1US) |
> +			   FIELD_PREP(CECB_GEN_CNTL_FILTER_DEL, 7));
> +
> +	/* Enable System Clock */
> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
> +			   CECB_GEN_CNTL_SYS_CLK_EN,
> +			   CECB_GEN_CNTL_SYS_CLK_EN);
> +
> +	/* Enable gated clock (Normal mode). */
> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
> +			   CECB_GEN_CNTL_CLK_CTRL_MASK,
> +			    FIELD_PREP(CECB_GEN_CNTL_CLK_CTRL_MASK,
> +				       CECB_GEN_CNTL_CLK_ENABLE));
> +
> +	/* Release Reset */
> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
> +			   CECB_GEN_CNTL_RESET, 0);
> +
> +	meson_ao_cec_g12a_irq_setup(ao_cec, true);
> +
> +	return 0;
> +}
> +
> +static const struct cec_adap_ops meson_ao_cec_g12a_ops = {
> +	.adap_enable = meson_ao_cec_g12a_adap_enable,
> +	.adap_log_addr = meson_ao_cec_g12a_set_log_addr,
> +	.adap_transmit = meson_ao_cec_g12a_transmit,
> +};
> +
> +static int meson_ao_cec_g12a_probe(struct platform_device *pdev)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec;
> +	struct platform_device *hdmi_dev;
> +	struct device_node *np;
> +	struct resource *res;
> +	void __iomem *base;
> +	int ret, irq;
> +
> +	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
> +	if (!np) {
> +		dev_err(&pdev->dev, "Failed to find hdmi node\n");
> +		return -ENODEV;
> +	}
> +
> +	hdmi_dev = of_find_device_by_node(np);
> +	of_node_put(np);
> +	if (hdmi_dev == NULL)
> +		return -EPROBE_DEFER;
> +
> +	put_device(&hdmi_dev->dev);
> +	ao_cec = devm_kzalloc(&pdev->dev, sizeof(*ao_cec), GFP_KERNEL);
> +	if (!ao_cec)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&ao_cec->cec_reg_lock);
> +	ao_cec->pdev = pdev;
> +
> +	ao_cec->notify = cec_notifier_get(&hdmi_dev->dev);
> +	if (!ao_cec->notify)
> +		return -ENOMEM;
> +
> +	ao_cec->adap = cec_allocate_adapter(&meson_ao_cec_g12a_ops, ao_cec,
> +					    "meson_g12a_ao_cec",
> +					    CEC_CAP_DEFAULTS,
> +					    CEC_MAX_LOG_ADDRS);
> +	if (IS_ERR(ao_cec->adap)) {
> +		ret = PTR_ERR(ao_cec->adap);
> +		goto out_probe_notify;
> +	}
> +
> +	ao_cec->adap->owner = THIS_MODULE;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base)) {
> +		ret = PTR_ERR(base);
> +		goto out_probe_adapter;
> +	}
> +
> +	ao_cec->regmap = devm_regmap_init_mmio(&pdev->dev, base,
> +					       &meson_ao_cec_g12a_regmap_conf);
> +	if (IS_ERR(ao_cec->regmap)) {
> +		ret = PTR_ERR(ao_cec->regmap);
> +		goto out_probe_adapter;
> +	}
> +
> +	ao_cec->regmap_cec = devm_regmap_init(&pdev->dev, NULL, ao_cec,
> +					   &meson_ao_cec_g12a_cec_regmap_conf);
> +	if (IS_ERR(ao_cec->regmap_cec)) {
> +		ret = PTR_ERR(ao_cec->regmap_cec);
> +		goto out_probe_adapter;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_threaded_irq(&pdev->dev, irq,
> +					meson_ao_cec_g12a_irq,
> +					meson_ao_cec_g12a_irq_thread,
> +					0, NULL, ao_cec);
> +	if (ret) {
> +		dev_err(&pdev->dev, "irq request failed\n");
> +		goto out_probe_adapter;
> +	}
> +
> +	ao_cec->oscin = devm_clk_get(&pdev->dev, "oscin");
> +	if (IS_ERR(ao_cec->oscin)) {
> +		dev_err(&pdev->dev, "oscin clock request failed\n");
> +		ret = PTR_ERR(ao_cec->oscin);
> +		goto out_probe_adapter;
> +	}
> +
> +	ret = meson_ao_cec_g12a_setup_clk(ao_cec);
> +	if (ret)
> +		goto out_probe_clk;
> +
> +	ret = clk_prepare_enable(ao_cec->core);
> +	if (ret) {
> +		dev_err(&pdev->dev, "core clock enable failed\n");
> +		goto out_probe_clk;
> +	}
> +
> +	device_reset_optional(&pdev->dev);
> +
> +	platform_set_drvdata(pdev, ao_cec);
> +
> +	ret = cec_register_adapter(ao_cec->adap, &pdev->dev);
> +	if (ret < 0) {
> +		cec_notifier_put(ao_cec->notify);
> +		goto out_probe_core_clk;
> +	}
> +
> +	/* Setup Hardware */
> +	regmap_write(ao_cec->regmap, CECB_GEN_CNTL_REG, CECB_GEN_CNTL_RESET);
> +
> +	cec_register_cec_notifier(ao_cec->adap, ao_cec->notify);
> +
> +	return 0;
> +
> +out_probe_core_clk:
> +	clk_disable_unprepare(ao_cec->core);
> +
> +out_probe_clk:
> +	clk_disable_unprepare(ao_cec->oscin);
> +
> +out_probe_adapter:
> +	cec_delete_adapter(ao_cec->adap);
> +
> +out_probe_notify:
> +	cec_notifier_put(ao_cec->notify);
> +
> +	dev_err(&pdev->dev, "CEC controller registration failed\n");
> +
> +	return ret;
> +}
> +
> +static int meson_ao_cec_g12a_remove(struct platform_device *pdev)
> +{
> +	struct meson_ao_cec_g12a_device *ao_cec = platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(ao_cec->oscin);
> +
> +	cec_unregister_adapter(ao_cec->adap);
> +
> +	cec_notifier_put(ao_cec->notify);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id meson_ao_cec_g12a_of_match[] = {
> +	{ .compatible = "amlogic,meson-g12a-ao-cec-b", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, meson_ao_cec_g12a_of_match);
> +
> +static struct platform_driver meson_ao_cec_g12a_driver = {
> +	.probe   = meson_ao_cec_g12a_probe,
> +	.remove  = meson_ao_cec_g12a_remove,
> +	.driver  = {
> +		.name = "meson-ao-cec-g12a",
> +		.of_match_table = of_match_ptr(meson_ao_cec_g12a_of_match),
> +	},
> +};
> +
> +module_platform_driver(meson_ao_cec_g12a_driver);
> +
> +MODULE_DESCRIPTION("Meson AO CEC G12A Controller driver");
> +MODULE_AUTHOR("Neil Armstrong <narmstrong@baylibre.com>");
> +MODULE_LICENSE("GPL");
> 

Regards,

	Hans
