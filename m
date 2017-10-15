Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53289 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbdJOUwB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:01 -0400
Received: by mail-wm0-f65.google.com with SMTP id q132so30818271wmd.2
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:01 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 1/8] [media] ddbridge: remove unneeded *fe vars from attach functions
Date: Sun, 15 Oct 2017 22:51:50 +0200
Message-Id: <20171015205157.14342-2-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

These are only used in C/T demod attach functions, don't add any real
benefit (ie. line length savings) and in case of cxd28xx_attach aren't
even used consequently. Remove them.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index f4bd4908acdd..653e7986923c 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -848,21 +848,20 @@ static int demod_attach_drxk(struct ddb_input *input)
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct device *dev = input->port->dev->dev;
-	struct dvb_frontend *fe;
 	struct drxk_config config;
 
 	memset(&config, 0, sizeof(config));
 	config.adr = 0x29 + (input->nr & 1);
 	config.microcode_name = "drxk_a3.mc";
 
-	fe = dvb->fe = dvb_attach(drxk_attach, &config, i2c);
-	if (!fe) {
+	dvb->fe = dvb_attach(drxk_attach, &config, i2c);
+	if (!dvb->fe) {
 		dev_err(dev, "No DRXK found!\n");
 		return -ENODEV;
 	}
-	fe->sec_priv = input;
-	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	dvb->fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = dvb->fe->ops.i2c_gate_ctrl;
+	dvb->fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
 
@@ -912,19 +911,18 @@ static int demod_attach_stv0367(struct ddb_input *input)
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct device *dev = input->port->dev->dev;
-	struct dvb_frontend *fe;
 
 	/* attach frontend */
-	fe = dvb->fe = dvb_attach(stv0367ddb_attach,
+	dvb->fe = dvb_attach(stv0367ddb_attach,
 		&ddb_stv0367_config[(input->nr & 1)], i2c);
 
 	if (!dvb->fe) {
 		dev_err(dev, "No stv0367 found!\n");
 		return -ENODEV;
 	}
-	fe->sec_priv = input;
-	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	dvb->fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = dvb->fe->ops.i2c_gate_ctrl;
+	dvb->fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
 
@@ -956,7 +954,6 @@ static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct device *dev = input->port->dev->dev;
-	struct dvb_frontend *fe;
 	struct cxd2841er_config cfg;
 
 	/* the cxd2841er driver expects 8bit/shifted I2C addresses */
@@ -971,15 +968,15 @@ static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 		cfg.flags |= CXD2841ER_TS_SERIAL;
 
 	/* attach frontend */
-	fe = dvb->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
+	dvb->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
 
 	if (!dvb->fe) {
 		dev_err(dev, "No cxd2837/38/43/54 found!\n");
 		return -ENODEV;
 	}
-	fe->sec_priv = input;
-	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	dvb->fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = dvb->fe->ops.i2c_gate_ctrl;
+	dvb->fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
 
-- 
2.13.6
