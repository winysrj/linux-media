Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:54643 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbeBYMbu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 07:31:50 -0500
Received: by mail-wm0-f67.google.com with SMTP id z81so12517639wmb.4
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 04:31:49 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 06/12] [media] ngene: add support for Sony CXD28xx-based DuoFlex modules
Date: Sun, 25 Feb 2018 13:31:34 +0100
Message-Id: <20180225123140.19486-7-d.scheller.oss@gmail.com>
In-Reply-To: <20180225123140.19486-1-d.scheller.oss@gmail.com>
References: <20180225123140.19486-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Recognize (probe) and support (attach) all Sony CXD28xx based DuoFlex
addon modules/cards, namely the DuoFlex CT2 (CXD2837), ISDB-T (CXD2838),
C2T2 (CXD2843) and C2T2I (CXD2854). Since all these modules are equipped
with a MachXO2 interface, that support is required for the hardware to
work. This functionality utilises the auxiliary cxd2841er and tda18212
drivers.

This also adds autoselection (if MEDIA_SUBDRV_AUTOSELECT) of the CXD2841ER
demod driver to Kconfig. The __maybe_unused annotation can now be removed
from the xo2names array.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/Kconfig       |  1 +
 drivers/media/pci/ngene/ngene-cards.c | 63 ++++++++++++++++++++++++++++++++---
 2 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ngene/Kconfig b/drivers/media/pci/ngene/Kconfig
index c3254f9dc8ad..f717567f54a5 100644
--- a/drivers/media/pci/ngene/Kconfig
+++ b/drivers/media/pci/ngene/Kconfig
@@ -9,6 +9,7 @@ config DVB_NGENE
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 05b8e56999ec..cdc8db14c606 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -45,6 +45,7 @@
 #include "stv0367.h"
 #include "stv0367_priv.h"
 #include "tda18212.h"
+#include "cxd2841er.h"
 
 /****************************************************************************/
 /* I2C transfer functions used for demod/tuner probing***********************/
@@ -277,6 +278,10 @@ static int tuner_attach_probe(struct ngene_channel *chan)
 	case DEMOD_TYPE_DRXK:
 		return tuner_attach_tda18271(chan);
 	case DEMOD_TYPE_STV0367:
+	case DEMOD_TYPE_SONY_CT2:
+	case DEMOD_TYPE_SONY_ISDBT:
+	case DEMOD_TYPE_SONY_C2T2:
+	case DEMOD_TYPE_SONY_C2T2I:
 		return tuner_attach_tda18212(chan, chan->demod_type);
 	}
 
@@ -358,6 +363,34 @@ static int demod_attach_stv0367(struct ngene_channel *chan,
 	return 0;
 }
 
+static int demod_attach_cxd28xx(struct ngene_channel *chan,
+				struct i2c_adapter *i2c, int osc24)
+{
+	struct device *pdev = &chan->dev->pci_dev->dev;
+	struct cxd2841er_config cfg;
+
+	/* the cxd2841er driver expects 8bit/shifted I2C addresses */
+	cfg.i2c_addr = ((chan->number & 1) ? 0x6d : 0x6c) << 1;
+
+	cfg.xtal = osc24 ? SONY_XTAL_24000 : SONY_XTAL_20500;
+	cfg.flags = CXD2841ER_AUTO_IFHZ | CXD2841ER_EARLY_TUNE |
+		CXD2841ER_NO_WAIT_LOCK | CXD2841ER_NO_AGCNEG |
+		CXD2841ER_TSBITS | CXD2841ER_TS_SERIAL;
+
+	/* attach frontend */
+	chan->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
+
+	if (!chan->fe) {
+		dev_err(pdev, "CXD28XX attach failed!\n");
+		return -ENODEV;
+	}
+
+	chan->fe->sec_priv = chan;
+	chan->gate_ctrl = chan->fe->ops.i2c_gate_ctrl;
+	chan->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	return 0;
+}
+
 static void cineS2_tuner_i2c_lock(struct dvb_frontend *fe, int lock)
 {
 	struct ngene_channel *chan = fe->analog_demod_priv;
@@ -426,7 +459,7 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 /* XO2 related lists and functions ******************************************/
 /****************************************************************************/
 
-static char __maybe_unused *xo2names[] = {
+static char *xo2names[] = {
 	"DUAL DVB-S2",
 	"DUAL DVB-C/T/T2",
 	"DUAL DVB-ISDBT",
@@ -513,7 +546,8 @@ static int cineS2_probe(struct ngene_channel *chan)
 	struct i2c_adapter *i2c;
 	struct stv090x_config *fe_conf;
 	u8 buf[3];
-	u8 xo2_type, xo2_id;
+	u8 xo2_type, xo2_id, xo2_demodtype;
+	u8 sony_osc24 = 0;
 	struct i2c_msg i2c_msg = { .flags = 0, .buf = buf };
 	int rc;
 
@@ -537,9 +571,28 @@ static int cineS2_probe(struct ngene_channel *chan)
 			else
 				init_xo2(chan, i2c);
 
-			/* TODO: implement support for XO2 module types */
-			dev_warn(pdev, "XO2 not supported\n");
-			return -ENODEV;
+			xo2_demodtype = DEMOD_TYPE_XO2 + xo2_id;
+
+			switch (xo2_demodtype) {
+			case DEMOD_TYPE_SONY_CT2:
+			case DEMOD_TYPE_SONY_ISDBT:
+			case DEMOD_TYPE_SONY_C2T2:
+			case DEMOD_TYPE_SONY_C2T2I:
+				dev_info(pdev, "%s (XO2) on channel %d\n",
+					 xo2names[xo2_id], chan->number);
+				chan->demod_type = xo2_demodtype;
+				if (xo2_demodtype == DEMOD_TYPE_SONY_C2T2I)
+					sony_osc24 = 1;
+
+				demod_attach_cxd28xx(chan, i2c, sony_osc24);
+				break;
+			default:
+				dev_warn(pdev,
+					 "Unsupported XO2 module on channel %d\n",
+					 chan->number);
+				return -ENODEV;
+			}
+			break;
 		case NGENE_XO2_TYPE_CI:
 			dev_info(pdev, "DuoFlex CI modules not supported\n");
 			return -ENODEV;
-- 
2.16.1
