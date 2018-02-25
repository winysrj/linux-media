Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51713 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeBYMbw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 07:31:52 -0500
Received: by mail-wm0-f68.google.com with SMTP id h21so12543709wmd.1
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 04:31:51 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 07/12] [media] ngene: add support for DuoFlex S2 V4 addon modules
Date: Sun, 25 Feb 2018 13:31:35 +0100
Message-Id: <20180225123140.19486-8-d.scheller.oss@gmail.com>
In-Reply-To: <20180225123140.19486-1-d.scheller.oss@gmail.com>
References: <20180225123140.19486-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add support for the STV0910/STV6111/LNBH25 based DuoFlex S2 V4 DVB-S2
addon modules by recognizing them from their XO2 type value and using
the auxiliary stv0910, stv6111 and lnbh25 driver to form a complete
DVB frontend.

This also adds autoselection (if MEDIA_SUBDRV_AUTOSELECT) of the STV0910,
STV6111 and LNBH25 demod/tuner/LNB-IC drivers to Kconfig.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/Kconfig       |  3 ++
 drivers/media/pci/ngene/ngene-cards.c | 83 +++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/media/pci/ngene/Kconfig b/drivers/media/pci/ngene/Kconfig
index f717567f54a5..e06d019996f3 100644
--- a/drivers/media/pci/ngene/Kconfig
+++ b/drivers/media/pci/ngene/Kconfig
@@ -11,6 +11,9 @@ config DVB_NGENE
 	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0910 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6111 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBH25 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for Micronas PCI express cards with nGene bridge.
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index cdc8db14c606..00b100660784 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -46,6 +46,9 @@
 #include "stv0367_priv.h"
 #include "tda18212.h"
 #include "cxd2841er.h"
+#include "stv0910.h"
+#include "stv6111.h"
+#include "lnbh25.h"
 
 /****************************************************************************/
 /* I2C transfer functions used for demod/tuner probing***********************/
@@ -152,6 +155,30 @@ static int tuner_attach_stv6110(struct ngene_channel *chan)
 	return 0;
 }
 
+static int tuner_attach_stv6111(struct ngene_channel *chan)
+{
+	struct device *pdev = &chan->dev->pci_dev->dev;
+	struct i2c_adapter *i2c;
+	struct dvb_frontend *fe;
+	u8 adr = 4 + ((chan->number & 1) ? 0x63 : 0x60);
+
+	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
+	if (chan->number < 2)
+		i2c = &chan->dev->channel[0].i2c_adapter;
+	else
+		i2c = &chan->dev->channel[1].i2c_adapter;
+
+	fe = dvb_attach(stv6111_attach, chan->fe, i2c, adr);
+	if (!fe) {
+		fe = dvb_attach(stv6111_attach, chan->fe, i2c, adr & ~4);
+		if (!fe) {
+			dev_err(pdev, "stv6111_attach() failed!\n");
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct ngene_channel *chan = fe->sec_priv;
@@ -283,6 +310,8 @@ static int tuner_attach_probe(struct ngene_channel *chan)
 	case DEMOD_TYPE_SONY_C2T2:
 	case DEMOD_TYPE_SONY_C2T2I:
 		return tuner_attach_tda18212(chan, chan->demod_type);
+	case DEMOD_TYPE_STV0910:
+		return tuner_attach_stv6111(chan);
 	}
 
 	return -EINVAL;
@@ -326,6 +355,54 @@ static int demod_attach_stv0900(struct ngene_channel *chan)
 	return 0;
 }
 
+static struct stv0910_cfg stv0910_p = {
+	.adr      = 0x68,
+	.parallel = 1,
+	.rptlvl   = 4,
+	.clk      = 30000000,
+};
+
+static struct lnbh25_config lnbh25_cfg = {
+	.i2c_address = 0x0c << 1,
+	.data2_config = LNBH25_TEN
+};
+
+static int demod_attach_stv0910(struct ngene_channel *chan,
+				struct i2c_adapter *i2c)
+{
+	struct device *pdev = &chan->dev->pci_dev->dev;
+	struct stv0910_cfg cfg = stv0910_p;
+	struct lnbh25_config lnbcfg = lnbh25_cfg;
+
+	chan->fe = dvb_attach(stv0910_attach, i2c, &cfg, (chan->number & 1));
+	if (!chan->fe) {
+		cfg.adr = 0x6c;
+		chan->fe = dvb_attach(stv0910_attach, i2c,
+				      &cfg, (chan->number & 1));
+	}
+	if (!chan->fe) {
+		dev_err(pdev, "stv0910_attach() failed!\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * attach lnbh25 - leftshift by one as the lnbh25 driver expects 8bit
+	 * i2c addresses
+	 */
+	lnbcfg.i2c_address = (((chan->number & 1) ? 0x0d : 0x0c) << 1);
+	if (!dvb_attach(lnbh25_attach, chan->fe, &lnbcfg, i2c)) {
+		lnbcfg.i2c_address = (((chan->number & 1) ? 0x09 : 0x08) << 1);
+		if (!dvb_attach(lnbh25_attach, chan->fe, &lnbcfg, i2c)) {
+			dev_err(pdev, "lnbh25_attach() failed!\n");
+			dvb_frontend_detach(chan->fe);
+			chan->fe = NULL;
+			return -ENODEV;
+		}
+	}
+
+	return 0;
+}
+
 static struct stv0367_config ddb_stv0367_config[] = {
 	{
 		.demod_address = 0x1f,
@@ -586,6 +663,12 @@ static int cineS2_probe(struct ngene_channel *chan)
 
 				demod_attach_cxd28xx(chan, i2c, sony_osc24);
 				break;
+			case DEMOD_TYPE_STV0910:
+				dev_info(pdev, "%s (XO2) on channel %d\n",
+					 xo2names[xo2_id], chan->number);
+				chan->demod_type = xo2_demodtype;
+				demod_attach_stv0910(chan, i2c);
+				break;
 			default:
 				dev_warn(pdev,
 					 "Unsupported XO2 module on channel %d\n",
-- 
2.16.1
