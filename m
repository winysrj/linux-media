Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507Ab3DAOnJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:43:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/5] [media] mb86a20s: Use a macro for the number of layers
Date: Mon,  1 Apr 2013 11:41:55 -0300
Message-Id: <1364827319-18332-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364827319-18332-1-git-send-email-mchehab@redhat.com>
References: <20130401072529.GL18466@mwanda>
 <1364827319-18332-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using the magic number "3", use NUM_LAYERS macro
on all places that are related to the ISDB-T layers.

This makes the source code a little more readable.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index d04b52e..80a8ee0 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -20,6 +20,8 @@
 #include "dvb_frontend.h"
 #include "mb86a20s.h"
 
+#define NUM_LAYERS 3
+
 static int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
@@ -48,7 +50,7 @@ struct mb86a20s_state {
 	bool inversion;
 	u32 subchannel;
 
-	u32 estimated_rate[3];
+	u32 estimated_rate[NUM_LAYERS];
 	unsigned long get_strength_time;
 
 	bool need_init;
@@ -666,7 +668,7 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 
 	/* Get per-layer data */
 
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < NUM_LAYERS; i++) {
 		dev_dbg(&state->i2c->dev, "%s: getting data for layer %c.\n",
 			__func__, 'A' + i);
 
@@ -828,7 +830,7 @@ static int mb86a20s_get_pre_ber(struct dvb_frontend *fe,
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
-	if (layer >= 3)
+	if (layer >= NUM_LAYERS)
 		return -EINVAL;
 
 	/* Check if the BER measures are already available */
@@ -962,7 +964,7 @@ static int mb86a20s_get_post_ber(struct dvb_frontend *fe,
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
-	if (layer >= 3)
+	if (layer >= NUM_LAYERS)
 		return -EINVAL;
 
 	/* Check if the BER measures are already available */
@@ -1089,7 +1091,7 @@ static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
 	u32 collect_rate;
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
-	if (layer >= 3)
+	if (layer >= NUM_LAYERS)
 		return -EINVAL;
 
 	/* Check if the PER measures are already available */
@@ -1476,7 +1478,7 @@ static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 	}
 
 	/* Read all layers */
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < NUM_LAYERS; i++) {
 		if (!(c->isdbt_layer_enabled & (1 << i))) {
 			c->cnr.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
 			continue;
@@ -1565,20 +1567,20 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 	c->strength.len = 1;
 
 	/* Per-layer stats - 3 layers + global */
-	c->cnr.len = 4;
-	c->pre_bit_error.len = 4;
-	c->pre_bit_count.len = 4;
-	c->post_bit_error.len = 4;
-	c->post_bit_count.len = 4;
-	c->block_error.len = 4;
-	c->block_count.len = 4;
+	c->cnr.len = NUM_LAYERS + 1;
+	c->pre_bit_error.len = NUM_LAYERS + 1;
+	c->pre_bit_count.len = NUM_LAYERS + 1;
+	c->post_bit_error.len = NUM_LAYERS + 1;
+	c->post_bit_count.len = NUM_LAYERS + 1;
+	c->block_error.len = NUM_LAYERS + 1;
+	c->block_count.len = NUM_LAYERS + 1;
 
 	/* Signal is always available */
 	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
 	c->strength.stat[0].uvalue = 0;
 
 	/* Put all of them at FE_SCALE_NOT_AVAILABLE */
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < NUM_LAYERS + 1; i++) {
 		c->cnr.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->pre_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->pre_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
@@ -1617,7 +1619,7 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe, int status_nr)
 	if (status_nr < 9)
 		return 0;
 
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < NUM_LAYERS; i++) {
 		if (c->isdbt_layer_enabled & (1 << i)) {
 			/* Layer is active and has rc segments */
 			active_layers++;
-- 
1.8.1.4

