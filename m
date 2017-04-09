Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34740 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdDITig (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:36 -0400
Received: by mail-wm0-f66.google.com with SMTP id x75so6393334wma.1
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:35 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 04/19] [media] dvb-frontends/cxd2841er: support CXD2837/38/43ER demods/Chip IDs
Date: Sun,  9 Apr 2017 21:38:13 +0200
Message-Id: <20170409193828.18458-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Those demods are programmed in the same way as the CXD2841ER/54ER and can
be handled by this driver. Support added in a way matching the existing
code, supported delivery systems are set according to what each demod
supports.

Updates the type string setting used for printing the "attaching..." log
line aswell.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c      | 24 +++++++++++++++++++++++-
 drivers/media/dvb-frontends/cxd2841er_priv.h |  3 +++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 09c25d7..72a27cc 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3733,16 +3733,39 @@ static struct dvb_frontend *cxd2841er_attach(struct cxd2841er_config *cfg,
 		priv->i2c_addr_slvx, priv->i2c_addr_slvt);
 	chip_id = cxd2841er_chip_id(priv);
 	switch (chip_id) {
+	case CXD2837ER_CHIP_ID:
+		snprintf(cxd2841er_t_c_ops.info.name, 128,
+				"Sony CXD2837ER DVB-T/T2/C demodulator");
+		name = "CXD2837ER";
+		type = "C/T/T2";
+		break;
+	case CXD2838ER_CHIP_ID:
+		snprintf(cxd2841er_t_c_ops.info.name, 128,
+				"Sony CXD2838ER ISDB-T demodulator");
+		cxd2841er_t_c_ops.delsys[0] = SYS_ISDBT;
+		cxd2841er_t_c_ops.delsys[1] = SYS_UNDEFINED;
+		cxd2841er_t_c_ops.delsys[2] = SYS_UNDEFINED;
+		name = "CXD2838ER";
+		type = "ISDB-T";
+		break;
 	case CXD2841ER_CHIP_ID:
 		snprintf(cxd2841er_t_c_ops.info.name, 128,
 				"Sony CXD2841ER DVB-T/T2/C demodulator");
 		name = "CXD2841ER";
+		type = "T/T2/C/ISDB-T";
+		break;
+	case CXD2843ER_CHIP_ID:
+		snprintf(cxd2841er_t_c_ops.info.name, 128,
+				"Sony CXD2843ER DVB-T/T2/C/C2 demodulator");
+		name = "CXD2843ER";
+		type = "C/C2/T/T2";
 		break;
 	case CXD2854ER_CHIP_ID:
 		snprintf(cxd2841er_t_c_ops.info.name, 128,
 				"Sony CXD2854ER DVB-T/T2/C and ISDB-T demodulator");
 		cxd2841er_t_c_ops.delsys[3] = SYS_ISDBT;
 		name = "CXD2854ER";
+		type = "C/C2/T/T2/ISDB-T";
 		break;
 	default:
 		dev_err(&priv->i2c->dev, "%s(): invalid chip ID 0x%02x\n",
@@ -3762,7 +3785,6 @@ static struct dvb_frontend *cxd2841er_attach(struct cxd2841er_config *cfg,
 		memcpy(&priv->frontend.ops,
 			&cxd2841er_t_c_ops,
 			sizeof(struct dvb_frontend_ops));
-		type = "T/T2/C/ISDB-T";
 	}
 
 	dev_info(&priv->i2c->dev,
diff --git a/drivers/media/dvb-frontends/cxd2841er_priv.h b/drivers/media/dvb-frontends/cxd2841er_priv.h
index 0bbce45..6a71264 100644
--- a/drivers/media/dvb-frontends/cxd2841er_priv.h
+++ b/drivers/media/dvb-frontends/cxd2841er_priv.h
@@ -25,7 +25,10 @@
 #define I2C_SLVX			0
 #define I2C_SLVT			1
 
+#define CXD2837ER_CHIP_ID		0xb1
+#define CXD2838ER_CHIP_ID		0xb0
 #define CXD2841ER_CHIP_ID		0xa7
+#define CXD2843ER_CHIP_ID		0xa4
 #define CXD2854ER_CHIP_ID		0xc1
 
 #define CXD2841ER_DVBS_POLLING_INVL	10
-- 
2.10.2
