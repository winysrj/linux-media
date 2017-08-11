Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39242 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752988AbdHKJ53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:29 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 14/20] adv748x: add module param for virtual channel
Date: Fri, 11 Aug 2017 11:56:57 +0200
Message-Id: <20170811095703.6170-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware can output on any of the 4 (0-3) Virtual Channels of the
CSI-2 bus. Add a module parameter each for TXA and TXB to allow the user
to specify which channel should be used.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 10 ++++++++++
 drivers/media/i2c/adv748x/adv748x-csi2.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      |  1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index aeb6ae80cb184eb4..72ec585f44385b01 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -31,6 +31,9 @@
 
 #include "adv748x.h"
 
+static unsigned int txavc;
+static unsigned int txbvc;
+
 /* -----------------------------------------------------------------------------
  * Register manipulation
  */
@@ -751,6 +754,7 @@ static int adv748x_probe(struct i2c_client *client,
 	}
 
 	/* Initialise TXA */
+	state->txa.vc = txavc;
 	ret = adv748x_csi2_init(state, &state->txa);
 	if (ret) {
 		adv_err(state, "Failed to probe TXA");
@@ -758,6 +762,7 @@ static int adv748x_probe(struct i2c_client *client,
 	}
 
 	/* Initialise TXB */
+	state->txb.vc = txbvc;
 	ret = adv748x_csi2_init(state, &state->txb);
 	if (ret) {
 		adv_err(state, "Failed to probe TXB");
@@ -827,6 +832,11 @@ static struct i2c_driver adv748x_driver = {
 
 module_i2c_driver(adv748x_driver);
 
+module_param(txavc, uint, 0644);
+MODULE_PARM_DESC(txavc, "Virtual Channel for TXA");
+module_param(txbvc, uint, 0644);
+MODULE_PARM_DESC(txbvc, "Virtual Channel for TXB");
+
 MODULE_AUTHOR("Kieran Bingham <kieran.bingham@ideasonboard.com>");
 MODULE_DESCRIPTION("ADV748X video decoder");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 979825d4a419b2da..2bec0cd0a00f1d5c 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -280,7 +280,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
 	}
 
 	/* Initialise the virtual channel */
-	adv748x_csi2_set_virtual_channel(tx, 0);
+	adv748x_csi2_set_virtual_channel(tx, tx->vc);
 
 	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
 			    MEDIA_ENT_F_UNKNOWN,
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index cc4151b5b31e2418..b3ef22e48e04ea37 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -92,6 +92,7 @@ enum adv748x_csi2_pads {
 
 struct adv748x_csi2 {
 	struct adv748x_state *state;
+	unsigned int vc;
 	struct v4l2_mbus_framefmt format;
 	unsigned int page;
 
-- 
2.13.3
