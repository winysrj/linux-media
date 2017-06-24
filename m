Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35109 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754739AbdFXQDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:03:13 -0400
Received: by mail-wr0-f194.google.com with SMTP id z45so20075898wrb.2
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 09:03:12 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 7/9] [media] ddbridge: return stv09xx id in port_has_stv0900_aa()
Date: Sat, 24 Jun 2017 18:02:59 +0200
Message-Id: <20170624160301.17710-8-d.scheller.oss@gmail.com>
In-Reply-To: <20170624160301.17710-1-d.scheller.oss@gmail.com>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The returned value is required for further evaluation of the exact
demodulator chip (stv090x or stv0910).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9420479bee9a..8c8cea9602de 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1452,10 +1452,9 @@ static int port_has_stv0900(struct ddb_port *port)
 	return 1;
 }
 
-static int port_has_stv0900_aa(struct ddb_port *port)
+static int port_has_stv0900_aa(struct ddb_port *port, u8 *id)
 {
-	u8 val;
-	if (i2c_read_reg16(&port->i2c->adap, 0x68, 0xf100, &val) < 0)
+	if (i2c_read_reg16(&port->i2c->adap, 0x68, 0xf100, id) < 0)
 		return 0;
 	return 1;
 }
@@ -1502,7 +1501,7 @@ static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
 	char *modname = "NO MODULE";
-	u8 xo2_type, xo2_id, cxd_id;
+	u8 xo2_type, xo2_id, cxd_id, stv_id;
 
 	port->class = DDB_PORT_NONE;
 
@@ -1594,7 +1593,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DVBS_ST;
 		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
-	} else if (port_has_stv0900_aa(port)) {
+	} else if (port_has_stv0900_aa(port, &stv_id)) {
 		modname = "DUAL DVB-S2";
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DVBS_ST_AA;
-- 
2.13.0
