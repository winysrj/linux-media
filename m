Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63694 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaDRBZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 21:25:03 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: m.chehab@samsung.com, felipensp@gmail.com, mkrufky@linuxtv.org,
	linux-media@vger.kernel.org
Cc: backports@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 2/2] bt8xx: make driver routines fit into its own namespcae
Date: Thu, 17 Apr 2014 18:24:44 -0700
Message-Id: <1397784284-15946-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1397784284-15946-1-git-send-email-mcgrof@do-not-panic.com>
References: <1397784284-15946-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

There is a few conflicts with older symbols on older kernels so we
have to patch this driver when backporting. Instead just make these
routines specific to the driver.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/media/pci/bt8xx/dst.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 430b3eb..f2261df 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -1544,7 +1544,7 @@ static int dst_send_burst(struct dvb_frontend *fe, fe_sec_mini_cmd_t minicmd)
 }
 
 
-static int dst_init(struct dvb_frontend *fe)
+static int bt8xx_dst_init(struct dvb_frontend *fe)
 {
 	struct dst_state *state = fe->demodulator_priv;
 
@@ -1707,7 +1707,7 @@ static int dst_get_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static void dst_release(struct dvb_frontend *fe)
+static void bt8xx_dst_release(struct dvb_frontend *fe)
 {
 	struct dst_state *state = fe->demodulator_priv;
 	if (state->dst_ca) {
@@ -1776,8 +1776,8 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
 			FE_CAN_GUARD_INTERVAL_AUTO
 	},
 
-	.release = dst_release,
-	.init = dst_init,
+	.release = bt8xx_dst_release,
+	.init = bt8xx_dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
@@ -1801,8 +1801,8 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
 		.caps = FE_CAN_FEC_AUTO | FE_CAN_QPSK
 	},
 
-	.release = dst_release,
-	.init = dst_init,
+	.release = bt8xx_dst_release,
+	.init = bt8xx_dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
@@ -1834,8 +1834,8 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
 			FE_CAN_QAM_256
 	},
 
-	.release = dst_release,
-	.init = dst_init,
+	.release = bt8xx_dst_release,
+	.init = bt8xx_dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
@@ -1857,8 +1857,8 @@ static struct dvb_frontend_ops dst_atsc_ops = {
 		.caps = FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 
-	.release = dst_release,
-	.init = dst_init,
+	.release = bt8xx_dst_release,
+	.init = bt8xx_dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
-- 
1.9.1

