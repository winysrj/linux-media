Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaHMAfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 20:35:53 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] as102-fe: Add a release function
Date: Tue, 12 Aug 2014 21:35:44 -0300
Message-Id: <1407890144-12899-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed to free state and for dvb_detach() to be
called.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/as102_fe.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
index ef4c3c667782..493665899565 100644
--- a/drivers/media/dvb-frontends/as102_fe.c
+++ b/drivers/media/dvb-frontends/as102_fe.c
@@ -407,6 +407,14 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 				      state->elna_cfg);
 }
 
+static void as102_fe_release(struct dvb_frontend *fe)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	kfree(state);
+}
+
+
 static struct dvb_frontend_ops as102_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
@@ -436,6 +444,7 @@ static struct dvb_frontend_ops as102_fe_ops = {
 	.read_signal_strength	= as102_fe_read_signal_strength,
 	.read_ucblocks		= as102_fe_read_ucblocks,
 	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
+	.release		= as102_fe_release,
 };
 
 struct dvb_frontend *as102_attach(const char *name,
-- 
1.9.3

