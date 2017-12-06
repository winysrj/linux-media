Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37281 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752468AbdLFR7U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 12:59:20 -0500
Received: by mail-wr0-f196.google.com with SMTP id k61so4819303wrc.4
        for <linux-media@vger.kernel.org>; Wed, 06 Dec 2017 09:59:19 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 1/2] [media] ddbridge: improve error handling logic on fe attach failures
Date: Wed,  6 Dec 2017 18:59:14 +0100
Message-Id: <20171206175915.20669-2-d.scheller.oss@gmail.com>
In-Reply-To: <20171206175915.20669-1-d.scheller.oss@gmail.com>
References: <20171206175915.20669-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This change makes sure that demod frontends are always detached whenever
a tuner frontend attach failed. Achieve this by moving the detach-on-
failure logic at the end of dvb_input_attach(), and adding a goto to this
block on every tuner attach failure case, so if an error occurs, there are
no stray attached frontends left. As a side effect, this removes some
duplicated code.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 49 ++++++++++++++----------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 348cc8b3d1f9..11c5cae92408 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1449,48 +1449,43 @@ static int dvb_input_attach(struct ddb_input *input)
 		if (demod_attach_stv0900(input, 0) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6110(input, 0) < 0)
-			return -ENODEV;
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_ST_AA:
 		if (demod_attach_stv0900(input, 1) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6110(input, 1) < 0)
-			return -ENODEV;
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910:
 		if (demod_attach_stv0910(input, 0) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6111(input, 0) < 0)
-			return -ENODEV;
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910_PR:
 		if (demod_attach_stv0910(input, 1) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6111(input, 1) < 0)
-			return -ENODEV;
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910_P:
 		if (demod_attach_stv0910(input, 0) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6111(input, 1) < 0)
-			return -ENODEV;
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBCT_TR:
 		if (demod_attach_drxk(input) < 0)
 			return -ENODEV;
 		if (tuner_attach_tda18271(input) < 0)
-			return -ENODEV;
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBCT_ST:
 		if (demod_attach_stv0367(input) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212(input, port->type) < 0) {
-			if (dvb->fe2)
-				dvb_frontend_detach(dvb->fe2);
-			if (dvb->fe)
-				dvb_frontend_detach(dvb->fe);
-			return -ENODEV;
-		}
+		if (tuner_attach_tda18212(input, port->type) < 0)
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBC2T2I_SONY_P:
 		if (input->port->dev->link[input->port->lnr].info->ts_quirks &
@@ -1509,13 +1504,8 @@ static int dvb_input_attach(struct ddb_input *input)
 			par = 1;
 		if (demod_attach_cxd28xx(input, par, osc24) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212(input, port->type) < 0) {
-			if (dvb->fe2)
-				dvb_frontend_detach(dvb->fe2);
-			if (dvb->fe)
-				dvb_frontend_detach(dvb->fe);
-			return -ENODEV;
-		}
+		if (tuner_attach_tda18212(input, port->type) < 0)
+			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBC2T2I_SONY:
 		osc24 = 1;
@@ -1525,13 +1515,8 @@ static int dvb_input_attach(struct ddb_input *input)
 	case DDB_TUNER_ISDBT_SONY:
 		if (demod_attach_cxd28xx(input, 0, osc24) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212(input, port->type) < 0) {
-			if (dvb->fe2)
-				dvb_frontend_detach(dvb->fe2);
-			if (dvb->fe)
-				dvb_frontend_detach(dvb->fe);
-			return -ENODEV;
-		}
+		if (tuner_attach_tda18212(input, port->type) < 0)
+			goto err_tuner;
 		break;
 	default:
 		return 0;
@@ -1554,6 +1539,16 @@ static int dvb_input_attach(struct ddb_input *input)
 
 	dvb->attached = 0x31;
 	return 0;
+
+err_tuner:
+	dev_warn(port->dev->dev, "tuner attach failed!\n");
+
+	if (dvb->fe2)
+		dvb_frontend_detach(dvb->fe2);
+	if (dvb->fe)
+		dvb_frontend_detach(dvb->fe);
+
+	return -ENODEV;
 }
 
 static int port_has_encti(struct ddb_port *port)
-- 
2.13.6
