Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37558 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123AbaKLELg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:11:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/11] mn88472: add small delay to wait DVB-C lock
Date: Wed, 12 Nov 2014 06:11:09 +0200
Message-Id: <1415765477-23153-4-git-send-email-crope@iki.fi>
In-Reply-To: <1415765477-23153-1-git-send-email-crope@iki.fi>
References: <1415765477-23153-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

400ms delay seems to be enough in order to gain DVB-C lock.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472_c.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/mn88472_c.c b/drivers/media/dvb-frontends/mn88472_c.c
index 59d48e7..b5bd326 100644
--- a/drivers/media/dvb-frontends/mn88472_c.c
+++ b/drivers/media/dvb-frontends/mn88472_c.c
@@ -105,6 +105,13 @@ static int mn88472_rreg(struct mn88472_state *s, u16 reg, u8 *val)
 	return mn88472_rregs(s, reg, val, 1);
 }
 
+static int mn88472_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *s)
+{
+	s->min_delay_ms = 400;
+	return 0;
+}
+
 static int mn88472_set_frontend_c(struct dvb_frontend *fe)
 {
 	struct mn88472_state *s = fe->demodulator_priv;
@@ -398,6 +405,8 @@ static struct dvb_frontend_ops mn88472_ops_c = {
 
 	.release = mn88472_release_c,
 
+	.get_tune_settings = mn88472_get_tune_settings,
+
 	.init = mn88472_init_c,
 	.sleep = mn88472_sleep_c,
 
-- 
http://palosaari.fi/

