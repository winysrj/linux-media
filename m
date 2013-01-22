Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3AVLQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:16:09 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MBG9El006116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 06:16:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/7] [media] mb86a20s: Split status read logic from DVB callback
Date: Tue, 22 Jan 2013 09:15:31 -0200
Message-Id: <1358853333-21554-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
References: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split the logic that reads the status from the DVB callback. That
helps to properly return an error code, if status read fails.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 8f4fff1..03b74d3 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -320,16 +320,14 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	u8 val;
+	int val;
 
 	dprintk("\n");
 	*status = 0;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
 	val = mb86a20s_readreg(state, 0x0a) & 0xf;
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
+	if (val < 0)
+		return val;
 
 	if (val >= 2)
 		*status |= FE_HAS_SIGNAL;
@@ -635,6 +633,25 @@ error:
 
 }
 
+static int mb86a20s_read_status_gate(struct dvb_frontend *fe,
+				     fe_status_t *status)
+{
+	int ret;
+
+	dprintk("\n");
+	*status = 0;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	ret = mb86a20s_read_status(fe, status);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	return ret;
+}
+
 static int mb86a20s_tune(struct dvb_frontend *fe,
 			bool re_tune,
 			unsigned int mode_flags,
@@ -649,7 +666,7 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 		rc = mb86a20s_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
-		mb86a20s_read_status(fe, status);
+		mb86a20s_read_status_gate(fe, status);
 
 	return rc;
 }
@@ -730,7 +747,7 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	.init = mb86a20s_initfe,
 	.set_frontend = mb86a20s_set_frontend,
 	.get_frontend = mb86a20s_get_frontend,
-	.read_status = mb86a20s_read_status,
+	.read_status = mb86a20s_read_status_gate,
 	.read_signal_strength = mb86a20s_read_signal_strength,
 	.tune = mb86a20s_tune,
 };
-- 
1.7.11.7

