Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33165 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755496AbdGCRVQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 13:21:16 -0400
Received: by mail-wm0-f66.google.com with SMTP id j85so21729440wmj.0
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 10:21:15 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v3 07/10] [media] ddbridge: return stv09xx id in port_has_stv0900_aa()
Date: Mon,  3 Jul 2017 19:21:00 +0200
Message-Id: <20170703172104.27283-8-d.scheller.oss@gmail.com>
In-Reply-To: <20170703172104.27283-1-d.scheller.oss@gmail.com>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The returned value is required for further evaluation of the exact
demodulator chip (stv090x or stv0910).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index cd1723e79a07..3fbac7bee2d4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1480,10 +1480,9 @@ static int port_has_stv0900(struct ddb_port *port)
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
@@ -1530,7 +1529,7 @@ static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
 	char *modname = "NO MODULE";
-	u8 xo2_type, xo2_id, cxd_id;
+	u8 xo2_type, xo2_id, cxd_id, stv_id;
 
 	port->class = DDB_PORT_NONE;
 
@@ -1622,7 +1621,7 @@ static void ddb_port_probe(struct ddb_port *port)
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
