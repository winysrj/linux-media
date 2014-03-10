Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 15/15] drx-j: enable DVBv5 stats
Date: Mon, 10 Mar 2014 08:59:07 -0300
Message-Id: <1394452747-5426-16-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that everything is set, let's enable DVBv5 stats, for
applications that support it.

DVBv3 apps will still work.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 8098d87cda0b..0c0e9f3b108f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -6200,7 +6200,7 @@ rw_error:
 * \return Error code
 */
 static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr,
-				   u16 *pck_errs, u16 *pck_count)
+				   u32 *pck_errs, u32 *pck_count)
 {
 	int rc;
 	u16 data = 0;
@@ -10664,8 +10664,8 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 	struct dtv_frontend_properties *p = &state->frontend.dtv_property_cache;
 	enum drx_standard standard = ext_attr->standard;
 	int rc;
-	u32 ber, cnt;
-	u16 err, pkt, mer, strength;
+	u32 ber, cnt, err, pkt;
+	u16 mer, strength;
 
 	rc = get_sig_strength(demod, &strength);
 	if (rc < 0) {
@@ -12249,11 +12249,11 @@ static struct dvb_frontend_ops drx39xxj_ops;
 struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 {
 	struct drx39xxj_state *state = NULL;
-
 	struct i2c_device_addr *demod_addr = NULL;
 	struct drx_common_attr *demod_comm_attr = NULL;
 	struct drxj_data *demod_ext_attr = NULL;
 	struct drx_demod_instance *demod = NULL;
+	struct dtv_frontend_properties *p;
 	struct drxuio_cfg uio_cfg;
 	struct drxuio_data uio_data;
 	int result;
@@ -12331,6 +12331,27 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	       sizeof(struct dvb_frontend_ops));
 
 	state->frontend.demodulator_priv = state;
+
+	/* Initialize stats - needed for DVBv5 stats to work */
+	p = &state->frontend.dtv_property_cache;
+	p->strength.len = 1;
+	p->pre_bit_count.len = 1;
+	p->pre_bit_error.len = 1;
+	p->post_bit_count.len = 1;
+	p->post_bit_error.len = 1;
+	p->block_count.len = 1;
+	p->block_error.len = 1;
+	p->cnr.len = 1;
+
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return &state->frontend;
 
 error:
-- 
1.8.5.3

