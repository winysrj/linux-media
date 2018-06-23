Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46354 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbeFWPgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:22 -0400
Received: by mail-wr0-f194.google.com with SMTP id l14-v6so4347710wrq.13
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:22 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 03/19] [media] ddbridge: probe for LNBH25 chips before attaching
Date: Sat, 23 Jun 2018 17:35:59 +0200
Message-Id: <20180623153615.27630-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In demod_attach_stv0910(), the LNBH25 IC is being blindly attached and,
if the result is bad, blindly attached on another possible I2C address.
The LNBH25 uses it's set_voltage function to test for the IC and will
print an error to the kernel log on failure. Prevent this by probing
the possible I2C address and use this (and only this) to attach the
LNBH25 I2C driver. This also allows the stv0910 attach function to be
a bit cleaner.

Picked up from the upstream dddvb GIT and adapted for the LNBH25 driver
variant from the kernel tree.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index d5b0d1eaf3ad..3f83415b06c7 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1191,6 +1191,13 @@ static const struct lnbh25_config lnbh25_cfg = {
 	.data2_config = LNBH25_TEN
 };
 
+static int has_lnbh25(struct i2c_adapter *i2c, u8 adr)
+{
+	u8 val;
+
+	return i2c_read_reg(i2c, adr, 0, &val) ? 0 : 1;
+}
+
 static int demod_attach_stv0910(struct ddb_input *input, int type, int tsfast)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
@@ -1224,14 +1231,15 @@ static int demod_attach_stv0910(struct ddb_input *input, int type, int tsfast)
 	/* attach lnbh25 - leftshift by one as the lnbh25 driver expects 8bit
 	 * i2c addresses
 	 */
-	lnbcfg.i2c_address = (((input->nr & 1) ? 0x0d : 0x0c) << 1);
-	if (!dvb_attach(lnbh25_attach, dvb->fe, &lnbcfg, i2c)) {
+	if (has_lnbh25(i2c, 0x0d))
+		lnbcfg.i2c_address = (((input->nr & 1) ? 0x0d : 0x0c) << 1);
+	else
 		lnbcfg.i2c_address = (((input->nr & 1) ? 0x09 : 0x08) << 1);
-		if (!dvb_attach(lnbh25_attach, dvb->fe, &lnbcfg, i2c)) {
-			dev_err(dev, "No LNBH25 found!\n");
-			dvb_frontend_detach(dvb->fe);
-			return -ENODEV;
-		}
+
+	if (!dvb_attach(lnbh25_attach, dvb->fe, &lnbcfg, i2c)) {
+		dev_err(dev, "No LNBH25 found!\n");
+		dvb_frontend_detach(dvb->fe);
+		return -ENODEV;
 	}
 
 	return 0;
-- 
2.16.4
