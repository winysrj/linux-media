Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbcHNMuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 08:50:16 -0400
From: Colin King <colin.king@canonical.com>
To: Abylay Ospan <aospan@netup.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] helene: fix memory leak when heleno_x_pon fails
Date: Sat, 13 Aug 2016 19:16:54 +0100
Message-Id: <1471112214-19547-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The error return path of failed calls to heleno_x_pon leak
memory because priv is not kfree'd.  Fix this by kfree'ing
priv before returning.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/helene.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index 97a8982..3d1cd5f 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -987,8 +987,10 @@ struct dvb_frontend *helene_attach_s(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	if (helene_x_pon(priv) != 0)
+	if (helene_x_pon(priv) != 0) {
+		kfree(priv);
 		return NULL;
+	}
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -1021,8 +1023,10 @@ struct dvb_frontend *helene_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	if (helene_x_pon(priv) != 0)
+	if (helene_x_pon(priv) != 0) {
+		kfree(priv);
 		return NULL;
+	}
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
-- 
2.8.1

