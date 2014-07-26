Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaGZO7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:59:17 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] [media] remove some new warnings on drxj
Date: Sat, 26 Jul 2014 11:59:08 -0300
Message-Id: <1406386748-8874-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406386748-8874-1-git-send-email-m.chehab@samsung.com>
References: <1406386748-8874-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset b601fe5688ae did some cleanup, but didn't remove some
now unused vars:
	drivers/media/dvb-frontends/drx39xyj/drxj.c: In function 'drx39xxj_set_frontend':
	drivers/media/dvb-frontends/drx39xyj/drxj.c:12072:21: warning: unused variable 'uio_data' [-Wunused-variable]
	drivers/media/dvb-frontends/drx39xyj/drxj.c: In function 'drx39xxj_set_lna':
	drivers/media/dvb-frontends/drx39xyj/drxj.c:12230:21: warning: unused variable 'uio_data' [-Wunused-variable]
	drivers/media/dvb-frontends/drx39xyj/drxj.c:12229:20: warning: unused variable 'uio_cfg' [-Wunused-variable]
	drivers/media/dvb-frontends/drx39xyj/drxj.c:12224:6: warning: unused variable 'result' [-Wunused-variable]

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 200554d5f32c..7ca7a21df183 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12069,7 +12069,6 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	enum drx_standard standard = DRX_STANDARD_8VSB;
 	struct drx_channel channel;
 	int result;
-	struct drxuio_data uio_data;
 	static const struct drx_channel def_channel = {
 		/* frequency      */ 0,
 		/* bandwidth      */ DRX_BANDWIDTH_6MHZ,
@@ -12221,13 +12220,10 @@ static int drx39xxj_init(struct dvb_frontend *fe)
 
 static int drx39xxj_set_lna(struct dvb_frontend *fe)
 {
-	int result;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	struct drx_demod_instance *demod = state->demod;
 	struct drxj_data *ext_attr = demod->my_ext_attr;
-	struct drxuio_cfg uio_cfg;
-	struct drxuio_data uio_data;
 
 	if (c->lna) {
 		if (!ext_attr->has_lna) {
-- 
1.9.3

