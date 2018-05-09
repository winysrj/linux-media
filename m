Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:46343 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965000AbeEIUIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 16:08:10 -0400
Received: by mail-wr0-f193.google.com with SMTP id a12-v6so5826071wrn.13
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 13:08:10 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Subject: [PATCH 4/4] [media] ddbridge: conditionally enable fast TS for stv0910-equipped bridges
Date: Wed,  9 May 2018 22:08:03 +0200
Message-Id: <20180509200803.5253-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180509200803.5253-1-d.scheller.oss@gmail.com>
References: <20180509200803.5253-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

CineS2 V7(A) and Octopus CI S2 Pro/Advanced cards support faster TS speeds
on the card's contained stv0910 demodulator when their FPGA was updated
with a recent (>= 1.7, version number applies to all mentioned cards)
vendor firmware. Enable this faster TS speed on card port 0 (contained
demod) and parallel stv0910 connections when the card firmware is at least
1.7 or later.

Note: The mentioned cards and their demods are handled via the STV0910_PR
and STV0910_P tuner types. DuoFlex modules with such demodulators are
handled via the STV0910 (without suffix) types where such TS speed
increase doesn't technically make sense.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
Tested-by: Helmut Auer <post@helmutauer.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 34 +++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 6c2341642017..d5b0d1eaf3ad 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1191,7 +1191,7 @@ static const struct lnbh25_config lnbh25_cfg = {
 	.data2_config = LNBH25_TEN
 };
 
-static int demod_attach_stv0910(struct ddb_input *input, int type)
+static int demod_attach_stv0910(struct ddb_input *input, int type, int tsfast)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
@@ -1204,6 +1204,12 @@ static int demod_attach_stv0910(struct ddb_input *input, int type)
 
 	if (type)
 		cfg.parallel = 2;
+
+	if (tsfast) {
+		dev_info(dev, "Enabling stv0910 higher speed TS\n");
+		cfg.tsspeed = 0x10;
+	}
+
 	dvb->fe = dvb_attach(stv0910_attach, i2c, &cfg, (input->nr & 1));
 	if (!dvb->fe) {
 		cfg.adr = 0x6c;
@@ -1439,7 +1445,25 @@ static int dvb_input_attach(struct ddb_input *input)
 	struct ddb_port *port = input->port;
 	struct dvb_adapter *adap = dvb->adap;
 	struct dvb_demux *dvbdemux = &dvb->demux;
-	int par = 0, osc24 = 0;
+	struct ddb_ids *devids = &input->port->dev->link[input->port->lnr].ids;
+	int par = 0, osc24 = 0, tsfast = 0;
+
+	/*
+	 * Determine if bridges with stv0910 demods can run with fast TS and
+	 * thus support high bandwidth transponders.
+	 * STV0910_PR and STV0910_P tuner types covers all relevant bridges,
+	 * namely the CineS2 V7(A) and the Octopus CI S2 Pro/Advanced. All
+	 * DuoFlex S2 V4(A) have type=DDB_TUNER_DVBS_STV0910 without any suffix
+	 * and are limited by the serial link to the bridge, thus won't work
+	 * in fast TS mode.
+	 */
+	if (port->nr == 0 &&
+	    (port->type == DDB_TUNER_DVBS_STV0910_PR ||
+	     port->type == DDB_TUNER_DVBS_STV0910_P)) {
+		/* fast TS on port 0 requires FPGA version >= 1.7 */
+		if ((devids->hwid & 0x00ffffff) >= 0x00010007)
+			tsfast = 1;
+	}
 
 	dvb->attached = 0x01;
 
@@ -1496,19 +1520,19 @@ static int dvb_input_attach(struct ddb_input *input)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910:
-		if (demod_attach_stv0910(input, 0) < 0)
+		if (demod_attach_stv0910(input, 0, tsfast) < 0)
 			goto err_detach;
 		if (tuner_attach_stv6111(input, 0) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910_PR:
-		if (demod_attach_stv0910(input, 1) < 0)
+		if (demod_attach_stv0910(input, 1, tsfast) < 0)
 			goto err_detach;
 		if (tuner_attach_stv6111(input, 1) < 0)
 			goto err_tuner;
 		break;
 	case DDB_TUNER_DVBS_STV0910_P:
-		if (demod_attach_stv0910(input, 0) < 0)
+		if (demod_attach_stv0910(input, 0, tsfast) < 0)
 			goto err_detach;
 		if (tuner_attach_stv6111(input, 1) < 0)
 			goto err_tuner;
-- 
2.16.1
