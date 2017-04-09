Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34888 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbdDITij (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:39 -0400
Received: by mail-wr0-f196.google.com with SMTP id t20so26640453wra.2
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:38 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 07/19] [media] dvb-frontends/cxd2841er: make call to i2c_gate_ctrl optional
Date: Sun,  9 Apr 2017 21:38:16 +0200
Message-Id: <20170409193828.18458-8-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Some cards/bridges wrap i2c_gate_ctrl handling with a mutex_lock(). This is
e.g. done in ddbridge to protect against concurrent tuner access with
regards to the dual tuner HW, where concurrent tuner reconfiguration can
result in tuning fails or bad reception quality. When the tuner driver
additionally tries to open the I2C gate (which e.g. the tda18212 driver
does) when the demod already did this, this will lead to a deadlock. This
makes the calls to i2c_gatectrl from the demod driver optional when the
flag is set, leaving this to the tuner driver. For readability reasons and
to not have the check duplicated multiple times, the setup is factored
into cxd2841er_tuner_set().

This commit also updates the netup card driver (which seems to be the only
consumer of the cxd2841er as of now).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c            | 32 ++++++++++++++--------
 drivers/media/dvb-frontends/cxd2841er.h            |  2 ++
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  3 +-
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index f49a09b..162a0f5 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -327,6 +327,20 @@ static u32 cxd2841er_calc_iffreq(u32 ifhz)
 	return cxd2841er_calc_iffreq_xtal(SONY_XTAL_20500, ifhz);
 }
 
+static int cxd2841er_tuner_set(struct dvb_frontend *fe)
+{
+	struct cxd2841er_priv *priv = fe->demodulator_priv;
+
+	if ((priv->flags & CXD2841ER_USE_GATECTRL) && fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	if (fe->ops.tuner_ops.set_params)
+		fe->ops.tuner_ops.set_params(fe);
+	if ((priv->flags & CXD2841ER_USE_GATECTRL) && fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+}
+
 static int cxd2841er_dvbs2_set_symbol_rate(struct cxd2841er_priv *priv,
 					   u32 symbol_rate)
 {
@@ -3251,12 +3265,9 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
 		dev_dbg(&priv->i2c->dev, "%s(): tune failed\n", __func__);
 		goto done;
 	}
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe);
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	cxd2841er_tuner_set(fe);
+
 	cxd2841er_tune_done(priv);
 	timeout = ((3000000 + (symbol_rate - 1)) / symbol_rate) + 150;
 	for (i = 0; i < timeout / CXD2841ER_DVBS_POLLING_INVL; i++) {
@@ -3376,12 +3387,9 @@ static int cxd2841er_set_frontend_tc(struct dvb_frontend *fe)
 	}
 	if (ret)
 		goto done;
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe);
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	cxd2841er_tuner_set(fe);
+
 	cxd2841er_tune_done(priv);
 	timeout = 2500;
 	while (timeout > 0) {
diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
index 2fb8b38..15564af 100644
--- a/drivers/media/dvb-frontends/cxd2841er.h
+++ b/drivers/media/dvb-frontends/cxd2841er.h
@@ -24,6 +24,8 @@
 
 #include <linux/dvb/frontend.h>
 
+#define CXD2841ER_USE_GATECTRL	1
+
 enum cxd2841er_xtal {
 	SONY_XTAL_20500, /* 20.5 MHz */
 	SONY_XTAL_24000, /* 24 MHz */
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 191bd82..5e6553f 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -122,7 +122,8 @@ static void netup_unidvb_queue_cleanup(struct netup_dma *dma);
 
 static struct cxd2841er_config demod_config = {
 	.i2c_addr = 0xc8,
-	.xtal = SONY_XTAL_24000
+	.xtal = SONY_XTAL_24000,
+	.flags = CXD2841ER_USE_GATECTRL
 };
 
 static struct horus3a_config horus3a_conf = {
-- 
2.10.2
