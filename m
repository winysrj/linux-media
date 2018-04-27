Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44391 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758477AbeD0NqL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 09:46:11 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: probe zilog transmitter when zilog receiver is found
Date: Fri, 27 Apr 2018 14:46:09 +0100
Message-Id: <20180427134609.11855-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found a Hauppauge WinTV 44981 (bt878) with a Zilog Z8F0811. The
transmitter was not probed. Most likely there are others like this
(e.g. HVR1110).

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index a7e23bcf845c..a14a74e6b986 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -739,6 +739,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	struct rc_dev *rc = NULL;
 	struct i2c_adapter *adap = client->adapter;
 	unsigned short addr = client->addr;
+	bool probe_tx = (id->driver_data & FLAG_TX) != 0;
 	int err;
 
 	if ((id->driver_data & FLAG_HDPVR) && !enable_hdpvr) {
@@ -800,6 +801,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		rc_proto    = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
 							RC_PROTO_BIT_RC6_6A_32;
 		ir_codes    = RC_MAP_HAUPPAUGE;
+		probe_tx = true;
 		break;
 	}
 
@@ -892,7 +894,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	INIT_DELAYED_WORK(&ir->work, ir_work);
 
-	if (id->driver_data & FLAG_TX) {
+	if (probe_tx) {
 		ir->tx_c = i2c_new_dummy(client->adapter, 0x70);
 		if (!ir->tx_c) {
 			dev_err(&client->dev, "failed to setup tx i2c address");
-- 
2.14.3
