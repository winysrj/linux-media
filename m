Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbcBDP6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/7] [media] friio-fe: remove get_frontend() callback
Date: Thu,  4 Feb 2016 13:57:28 -0200
Message-Id: <bf3111ce5de23cbe514967332f4c3656bec0ef33.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver doesn't support getting frontend information and
it only works in automatic mode.

So, let's remove get_frontend() and update the cache at
set_frontend().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/dvb-usb/friio-fe.c | 37 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 8ec92fbeabad..979f05b4b87c 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -283,9 +283,22 @@ static int jdvbt90502_set_property(struct dvb_frontend *fe,
 	return r;
 }
 
-static int jdvbt90502_get_frontend(struct dvb_frontend *fe)
+static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	/**
+	 * NOTE: ignore all the parameters except frequency.
+	 *       others should be fixed to the proper value for ISDB-T,
+	 *       but don't check here.
+	 */
+
+	struct jdvbt90502_state *state = fe->demodulator_priv;
+	int ret;
+
+	deb_fe("%s: Freq:%d\n", __func__, p->frequency);
+
+	/* This driver only works on auto mode */
 	p->inversion = INVERSION_AUTO;
 	p->bandwidth_hz = 6000000;
 	p->code_rate_HP = FEC_AUTO;
@@ -294,26 +307,7 @@ static int jdvbt90502_get_frontend(struct dvb_frontend *fe)
 	p->transmission_mode = TRANSMISSION_MODE_AUTO;
 	p->guard_interval = GUARD_INTERVAL_AUTO;
 	p->hierarchy = HIERARCHY_AUTO;
-	return 0;
-}
-
-static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-
-	/**
-	 * NOTE: ignore all the parameters except frequency.
-	 *       others should be fixed to the proper value for ISDB-T,
-	 *       but don't check here.
-	 */
-
-	struct jdvbt90502_state *state = fe->demodulator_priv;
-	int ret;
-
-	deb_fe("%s: Freq:%d\n", __func__, p->frequency);
-
-	/* for recovery from DTV_CLEAN */
-	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
+	p->delivery_system = SYS_ISDBT;
 
 	ret = jdvbt90502_pll_set_freq(state, p->frequency);
 	if (ret) {
@@ -466,7 +460,6 @@ static struct dvb_frontend_ops jdvbt90502_ops = {
 	.set_property = jdvbt90502_set_property,
 
 	.set_frontend = jdvbt90502_set_frontend,
-	.get_frontend = jdvbt90502_get_frontend,
 
 	.read_status = jdvbt90502_read_status,
 	.read_signal_strength = jdvbt90502_read_signal_strength,
-- 
2.5.0


