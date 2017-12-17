Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45200 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbdLQPlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:41:00 -0500
Received: by mail-wr0-f193.google.com with SMTP id h1so11890601wre.12
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:40:59 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 5/8] [media] ddbridge: completely tear down input resources on failure
Date: Sun, 17 Dec 2017 16:40:46 +0100
Message-Id: <20171217154049.1125-6-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In dvb_input_attach(), whenever a demod driver fails to initialise, or if
frontend registration fails, perform a full input/frontend teardown using
dvb_input_detach() (which can safely be done since the current init state
is tracked in the 'attached' struct member). Claimed resources thus are
freed which aren't needed when an input or a port is not functional.

While at it, in ddb_ports_detach(), detach the secondary input first. Also
increase the kernlog severity of TDA18212 errors and tuner failures in
general.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 46 ++++++++++++++++++------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index c2f028152388..07f3e37a0fca 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1032,7 +1032,7 @@ static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 
 	return 0;
 err:
-	dev_notice(dev, "TDA18212 tuner not found. Device is not fully operational.\n");
+	dev_err(dev, "TDA18212 tuner not found. Device is not fully operational.\n");
 	return -ENODEV;
 }
 
@@ -1425,7 +1425,7 @@ static int dvb_input_attach(struct ddb_input *input)
 	dvb->dmxdev.demux = &dvbdemux->dmx;
 	ret = dvb_dmxdev_init(&dvb->dmxdev, adap);
 	if (ret < 0)
-		return ret;
+		goto err_detach;
 	dvb->attached = 0x11;
 
 	dvb->mem_frontend.source = DMX_MEMORY_FE;
@@ -1434,12 +1434,12 @@ static int dvb_input_attach(struct ddb_input *input)
 	dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->hw_frontend);
 	ret = dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, &dvb->hw_frontend);
 	if (ret < 0)
-		return ret;
+		goto err_detach;
 	dvb->attached = 0x12;
 
 	ret = dvb_net_init(adap, &dvb->dvbnet, dvb->dmxdev.demux);
 	if (ret < 0)
-		return ret;
+		goto err_detach;
 	dvb->attached = 0x20;
 
 	dvb->fe = NULL;
@@ -1447,47 +1447,47 @@ static int dvb_input_attach(struct ddb_input *input)
 	switch (port->type) {
 	case DDB_TUNER_MXL5XX:
 		if (ddb_fe_attach_mxl5xx(input) < 0)
-			return -ENODEV;
+			goto err_detach;
 		break;
 	case DDB_TUNER_DVBS_ST:
 		if (demod_attach_stv0900(input, 0) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_stv6110(input, 0) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_ST_AA:
 		if (demod_attach_stv0900(input, 1) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_stv6110(input, 1) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910:
 		if (demod_attach_stv0910(input, 0) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_stv6111(input, 0) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910_PR:
 		if (demod_attach_stv0910(input, 1) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_stv6111(input, 1) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910_P:
 		if (demod_attach_stv0910(input, 0) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_stv6111(input, 1) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBCT_TR:
 		if (demod_attach_drxk(input) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_tda18271(input) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBCT_ST:
 		if (demod_attach_stv0367(input) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_tda18212(input, port->type) < 0)
 			goto err_tuner;
 		break;
@@ -1507,7 +1507,7 @@ static int dvb_input_attach(struct ddb_input *input)
 		else
 			par = 1;
 		if (demod_attach_cxd28xx(input, par, osc24) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_tda18212(input, port->type) < 0)
 			goto err_tuner;
 		break;
@@ -1518,7 +1518,7 @@ static int dvb_input_attach(struct ddb_input *input)
 	case DDB_TUNER_DVBC2T2_SONY:
 	case DDB_TUNER_ISDBT_SONY:
 		if (demod_attach_cxd28xx(input, 0, osc24) < 0)
-			return -ENODEV;
+			goto err_detach;
 		if (tuner_attach_tda18212(input, port->type) < 0)
 			goto err_tuner;
 		break;
@@ -1529,11 +1529,13 @@ static int dvb_input_attach(struct ddb_input *input)
 
 	if (dvb->fe) {
 		if (dvb_register_frontend(adap, dvb->fe) < 0)
-			return -ENODEV;
+			goto err_detach;
 
 		if (dvb->fe2) {
-			if (dvb_register_frontend(adap, dvb->fe2) < 0)
-				return -ENODEV;
+			if (dvb_register_frontend(adap, dvb->fe2) < 0) {
+				dvb_unregister_frontend(dvb->fe);
+				goto err_detach;
+			}
 			dvb->fe2->tuner_priv = dvb->fe->tuner_priv;
 			memcpy(&dvb->fe2->ops.tuner_ops,
 			       &dvb->fe->ops.tuner_ops,
@@ -1545,12 +1547,18 @@ static int dvb_input_attach(struct ddb_input *input)
 	return 0;
 
 err_tuner:
-	dev_warn(port->dev->dev, "tuner attach failed!\n");
+	dev_err(port->dev->dev, "tuner attach failed!\n");
 
 	if (dvb->fe2)
 		dvb_frontend_detach(dvb->fe2);
 	if (dvb->fe)
 		dvb_frontend_detach(dvb->fe);
+err_detach:
+	dvb_input_detach(input);
+
+	/* return error from ret if set */
+	if (ret < 0)
+		return ret;
 
 	return -ENODEV;
 }
@@ -1981,8 +1989,8 @@ void ddb_ports_detach(struct ddb *dev)
 
 		switch (port->class) {
 		case DDB_PORT_TUNER:
-			dvb_input_detach(port->input[0]);
 			dvb_input_detach(port->input[1]);
+			dvb_input_detach(port->input[0]);
 			break;
 		case DDB_PORT_CI:
 		case DDB_PORT_LOOP:
-- 
2.13.6
