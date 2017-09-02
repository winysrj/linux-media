Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58191 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752329AbdIBLmv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:51 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/7] media: rc: ensure that protocols are enabled for scancode drivers
Date: Sat,  2 Sep 2017 12:42:45 +0100
Message-Id: <0b1d8d49be94cd2dc4f261725277ba49231f9543.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc scancode drivers without change_protocol should have all
protocols enabled at all time. This was only true for cec and
ir-kbd-i2c.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/cec/cec-core.c   | 1 -
 drivers/media/i2c/ir-kbd-i2c.c | 1 -
 drivers/media/rc/rc-main.c     | 3 +++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 648136e552d5..dc7fd6f80bc0 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -277,7 +277,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->input_id.version = 1;
 	adap->rc->driver_name = CEC_NAME;
 	adap->rc->allowed_protocols = RC_PROTO_BIT_CEC;
-	adap->rc->enabled_protocols = RC_PROTO_BIT_CEC;
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
 	adap->rc->timeout = MS_TO_NS(100);
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index a374e2a0ac3d..8b5f7d0435e4 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -460,7 +460,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 */
 	rc->map_name       = ir->ir_codes;
 	rc->allowed_protocols = rc_proto;
-	rc->enabled_protocols = rc_proto;
 	if (!rc->driver_name)
 		rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 981cccd6b988..8781055ee058 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1638,6 +1638,9 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 
 	rc_proto = BIT_ULL(rc_map->rc_proto);
 
+	if (dev->driver_type == RC_DRIVER_SCANCODE && !dev->change_protocol)
+		dev->enabled_protocols = dev->allowed_protocols;
+
 	if (dev->change_protocol) {
 		rc = dev->change_protocol(dev, &rc_proto);
 		if (rc < 0)
-- 
2.13.5
