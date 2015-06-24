Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33537 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbbFXPLr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 11:11:47 -0400
Received: by wiwl6 with SMTP id l6so98341220wiw.0
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 08:11:46 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 09/12] [media] tsin: c8sectpfe: Add support for various ST NIM cards.
Date: Wed, 24 Jun 2015 16:11:07 +0100
Message-Id: <1435158670-7195-10-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the following 3 NIM cards: -
1) STV0367-NIM (stv0367 demod with Thompson PLL)
2) B2100A (2x stv0367 demods & 2x NXP tda18212 tuners)
3) STV0903-6110NIM (stv0903 demod + 6110 tuner, lnb24)

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.c | 296 +++++++++++++++++++++++++++
 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.h |  20 ++
 2 files changed, 316 insertions(+)
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.c
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.h

diff --git a/drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.c b/drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.c
new file mode 100644
index 0000000..5c4ecb4
--- /dev/null
+++ b/drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.c
@@ -0,0 +1,296 @@
+/*
+ *  c8sectpfe-dvb.c - C8SECTPFE STi DVB driver
+ *
+ * Copyright (c) STMicroelectronics 2015
+ *
+ *  Author Peter Griffin <peter.griffin@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ */
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/version.h>
+
+#include <dt-bindings/media/c8sectpfe.h>
+
+#include "c8sectpfe-common.h"
+#include "c8sectpfe-core.h"
+#include "c8sectpfe-dvb.h"
+
+#include "dvb-pll.h"
+#include "lnbh24.h"
+#include "stv0367.h"
+#include "stv0367_priv.h"
+#include "stv6110x.h"
+#include "stv090x.h"
+#include "tda18212.h"
+
+static inline const char *dvb_card_str(unsigned int c)
+{
+	switch (c) {
+	case STV0367_PLL_BOARD_NIMA:	return "STV0367_PLL_BOARD_NIMA";
+	case STV0367_PLL_BOARD_NIMB:	return "STV0367_PLL_BOARD_NIMB";
+	case STV0367_TDA18212_NIMA_1:	return "STV0367_TDA18212_NIMA_1";
+	case STV0367_TDA18212_NIMA_2:	return "STV0367_TDA18212_NIMA_2";
+	case STV0367_TDA18212_NIMB_1:	return "STV0367_TDA18212_NIMB_1";
+	case STV0367_TDA18212_NIMB_2:	return "STV0367_TDA18212_NIMB_2";
+	case STV0903_6110_LNB24_NIMA:	return "STV0903_6110_LNB24_NIMA";
+	case STV0903_6110_LNB24_NIMB:	return "STV0903_6110_LNB24_NIMB";
+	default:			return "unknown dvb frontend card";
+	}
+}
+
+static struct stv090x_config stv090x_config = {
+	.device                 = STV0903,
+	.demod_mode             = STV090x_SINGLE,
+	.clk_mode               = STV090x_CLK_EXT,
+	.xtal                   = 16000000,
+	.address                = 0x69,
+
+	.ts1_mode               = STV090x_TSMODE_SERIAL_CONTINUOUS,
+	.ts2_mode               = STV090x_TSMODE_SERIAL_CONTINUOUS,
+
+	.repeater_level         = STV090x_RPTLEVEL_64,
+
+	.tuner_init             = NULL,
+	.tuner_set_mode         = NULL,
+	.tuner_set_frequency    = NULL,
+	.tuner_get_frequency    = NULL,
+	.tuner_set_bandwidth    = NULL,
+	.tuner_get_bandwidth    = NULL,
+	.tuner_set_bbgain       = NULL,
+	.tuner_get_bbgain       = NULL,
+	.tuner_set_refclk       = NULL,
+	.tuner_get_status       = NULL,
+};
+
+static struct stv6110x_config stv6110x_config = {
+	.addr                   = 0x60,
+	.refclk                 = 16000000,
+};
+
+#define NIMA 0
+#define NIMB 1
+
+static struct stv0367_config stv0367_pll_config[] = {
+	{
+		.demod_address = 0x1c,
+		.xtal = 27000000,
+		.if_khz = 36166,
+		.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+		.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+		.clk_pol = STV0367_CLOCKPOLARITY_DEFAULT,
+	}, {
+		.demod_address = 0x1d,
+		.xtal = 27000000,
+		.if_khz = 36166,
+		.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+		.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+		.clk_pol = STV0367_CLOCKPOLARITY_DEFAULT,
+	},
+};
+
+static struct stv0367_config stv0367_tda18212_config[] = {
+	{
+		.demod_address = 0x1c,
+		.xtal = 16000000,
+		.if_khz = 4500,
+		.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+		.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+		.clk_pol = STV0367_CLOCKPOLARITY_DEFAULT,
+	}, {
+		.demod_address = 0x1d,
+		.xtal = 16000000,
+		.if_khz = 4500,
+		.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+		.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+		.clk_pol = STV0367_CLOCKPOLARITY_DEFAULT,
+	}, {
+		.demod_address = 0x1e,
+		.xtal = 16000000,
+		.if_khz = 4500,
+		.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+		.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+		.clk_pol = STV0367_CLOCKPOLARITY_DEFAULT,
+	},
+};
+
+static struct tda18212_config tda18212_conf = {
+	.if_dvbt_6 = 4150,
+	.if_dvbt_7 = 4150,
+	.if_dvbt_8 = 4500,
+	.if_dvbc = 5000,
+};
+
+int c8sectpfe_frontend_attach(struct dvb_frontend **fe,
+		struct c8sectpfe *c8sectpfe,
+		struct channel_info *tsin, int chan_num)
+{
+	struct tda18212_config *tda18212;
+	struct stv6110x_devctl *fe2;
+	struct i2c_client *client;
+	struct i2c_board_info tda18212_info = {
+		.type = "tda18212",
+		.addr = 0x60,
+	};
+
+	BUG_ON(!tsin);
+
+	switch (tsin->dvb_card) {
+
+	case STV0367_PLL_BOARD_NIMA:
+	case STV0367_PLL_BOARD_NIMB:
+		if (tsin->dvb_card == STV0367_PLL_BOARD_NIMA)
+			*fe = dvb_attach(stv0367ter_attach,
+				 &stv0367_pll_config[NIMA], tsin->i2c_adapter);
+		else
+			*fe = dvb_attach(stv0367ter_attach,
+				 &stv0367_pll_config[NIMB], tsin->i2c_adapter);
+
+		if (!*fe) {
+			dev_err(c8sectpfe->device,
+				"%s: stv0367ter_attach failed for NIM card %s\n"
+				, __func__, dvb_card_str(tsin->dvb_card));
+			return -ENODEV;
+		};
+
+		/*
+		 * init the demod so that i2c gate_ctrl
+		 * to the tuner works correctly
+		 */
+		(*fe)->ops.init(*fe);
+
+		if (!dvb_attach(dvb_pll_attach, *fe, 0x60,
+			tsin->i2c_adapter, DVB_PLL_THOMSON_DTT7546X)) {
+
+			dev_err(c8sectpfe->device,
+				"%s: DVB_PLL_THOMSON_DTT7546X attach failed\n\t"
+				"for NIM card %s\n",
+				__func__, dvb_card_str(tsin->dvb_card));
+			return -ENODEV;
+		}
+		break;
+
+	case STV0367_TDA18212_NIMA_1:
+	case STV0367_TDA18212_NIMA_2:
+	case STV0367_TDA18212_NIMB_1:
+	case STV0367_TDA18212_NIMB_2:
+		if (tsin->dvb_card == STV0367_TDA18212_NIMA_1)
+			*fe = dvb_attach(stv0367ter_attach,
+				 &stv0367_tda18212_config[0],
+					tsin->i2c_adapter);
+		else if (tsin->dvb_card == STV0367_TDA18212_NIMB_1)
+			*fe = dvb_attach(stv0367ter_attach,
+				 &stv0367_tda18212_config[1],
+					tsin->i2c_adapter);
+		else
+			*fe = dvb_attach(stv0367ter_attach,
+				 &stv0367_tda18212_config[2],
+					tsin->i2c_adapter);
+
+		if (!*fe) {
+			dev_err(c8sectpfe->device,
+				"%s: stv0367ter_attach failed for NIM card %s\n"
+				, __func__, dvb_card_str(tsin->dvb_card));
+			return -ENODEV;
+		};
+
+		/*
+		 * init the demod so that i2c gate_ctrl
+		 * to the tuner works correctly
+		 */
+		(*fe)->ops.init(*fe);
+
+		/* Allocate the tda18212 structure */
+		tda18212 = devm_kzalloc(c8sectpfe->device,
+					sizeof(struct tda18212_config),
+					GFP_KERNEL);
+		if (!tda18212) {
+			dev_err(c8sectpfe->device,
+				"%s: devm_kzalloc failed\n", __func__);
+			return -ENOMEM;
+		}
+
+		memcpy(tda18212, &tda18212_conf,
+			sizeof(struct tda18212_config));
+
+		tda18212->fe = (*fe);
+
+		tda18212_info.platform_data = tda18212;
+
+		/* attach tuner */
+		request_module("tda18212");
+		client = i2c_new_device(tsin->i2c_adapter, &tda18212_info);
+		if (!client || !client->dev.driver) {
+			dvb_frontend_detach(*fe);
+			return -ENODEV;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			dvb_frontend_detach(*fe);
+			return -ENODEV;
+		}
+
+		tsin->i2c_client = client;
+
+		break;
+
+	case STV0903_6110_LNB24_NIMA:
+		*fe = dvb_attach(stv090x_attach,	&stv090x_config,
+				tsin->i2c_adapter, STV090x_DEMODULATOR_0);
+		if (!*fe) {
+			dev_err(c8sectpfe->device, "%s: stv090x_attach failed\n"
+				"\tfor NIM card %s\n",
+				__func__, dvb_card_str(tsin->dvb_card));
+			return -ENODEV;
+		}
+
+		fe2 = dvb_attach(stv6110x_attach, *fe,
+					&stv6110x_config, tsin->i2c_adapter);
+		if (!fe2) {
+			dev_err(c8sectpfe->device,
+				"%s: stv6110x_attach failed for NIM card %s\n"
+				, __func__, dvb_card_str(tsin->dvb_card));
+			return -ENODEV;
+		};
+
+		stv090x_config.tuner_init = fe2->tuner_init;
+		stv090x_config.tuner_set_mode = fe2->tuner_set_mode;
+		stv090x_config.tuner_set_frequency = fe2->tuner_set_frequency;
+		stv090x_config.tuner_get_frequency = fe2->tuner_get_frequency;
+		stv090x_config.tuner_set_bandwidth = fe2->tuner_set_bandwidth;
+		stv090x_config.tuner_get_bandwidth = fe2->tuner_get_bandwidth;
+		stv090x_config.tuner_set_bbgain = fe2->tuner_set_bbgain;
+		stv090x_config.tuner_get_bbgain = fe2->tuner_get_bbgain;
+		stv090x_config.tuner_set_refclk = fe2->tuner_set_refclk;
+		stv090x_config.tuner_get_status = fe2->tuner_get_status;
+
+		dvb_attach(lnbh24_attach, *fe, tsin->i2c_adapter, 0, 0, 0x9);
+		break;
+
+	default:
+		dev_err(c8sectpfe->device,
+			"%s: DVB frontend card %s not yet supported\n",
+			__func__, dvb_card_str(tsin->dvb_card));
+		return -ENODEV;
+	}
+
+	(*fe)->id = chan_num;
+
+	dev_info(c8sectpfe->device,
+			"DVB frontend card %s successfully attached",
+			dvb_card_str(tsin->dvb_card));
+	return 0;
+}
diff --git a/drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.h b/drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.h
new file mode 100644
index 0000000..bd366db
--- /dev/null
+++ b/drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.h
@@ -0,0 +1,20 @@
+/*
+ * c8sectpfe-common.h - C8SECTPFE STi DVB driver
+ *
+ * Copyright (c) STMicroelectronics 2015
+ *
+ *   Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License as
+ *      published by the Free Software Foundation; either version 2 of
+ *      the License, or (at your option) any later version.
+ */
+#ifndef _C8SECTPFE_DVB_H_
+#define _C8SECTPFE_DVB_H_
+
+int c8sectpfe_frontend_attach(struct dvb_frontend **fe,
+			struct c8sectpfe *c8sectpfe, struct channel_info *tsin,
+			int chan_num);
+
+#endif
-- 
1.9.1

