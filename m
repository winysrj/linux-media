Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44333 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab3EFPpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 11:45:16 -0400
Received: by mail-ea0-f181.google.com with SMTP id a11so1763066eae.12
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 08:45:14 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 2/3] r820t: remove redundant initializations in r820t_attach()
Date: Mon,  6 May 2013 17:44:36 +0200
Message-Id: <1367855077-6134-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1367855077-6134-1-git-send-email-gennarone@gmail.com>
References: <1367855077-6134-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fe->tuner_priv and fe->ops.tuner_ops are initialized twice in r820t_attach().
Remove the redundant initializations and also move fe->ops.tuner_ops
initialization outside of the mutex lock (as in the xc4000 tuner code for example).

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/tuners/r820t.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 4835021..d8fd16a 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2311,8 +2311,6 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 		break;
 	}
 
-	memcpy(&fe->ops.tuner_ops, &r820t_tuner_ops, sizeof(r820t_tuner_ops));
-
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -2327,15 +2325,14 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 
 	tuner_info("Rafael Micro r820t successfully identified\n");
 
-	fe->tuner_priv = priv;
-	memcpy(&fe->ops.tuner_ops, &r820t_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
-
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	mutex_unlock(&r820t_list_mutex);
 
+	memcpy(&fe->ops.tuner_ops, &r820t_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+
 	return fe;
 err:
 	if (fe->ops.i2c_gate_ctrl)
-- 
1.8.2.2

