Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1BAWl3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:41:29 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7348272fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:41:28 -0800 (PST)
Subject: [PATCH 4/9 v2] ds3000: loading firmware during demod init
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:40:36 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020040.36746.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Speed up tuning, as firmware is not necessary to load every attempt to tune

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 02ba759..3373890 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1056,14 +1056,6 @@ static int ds3000_tune(struct dvb_frontend *fe,
 
 	dprintk("%s() ", __func__);
 
-	/* Load the firmware if required */
-	ret = ds3000_firmware_ondemand(fe);
-	if (ret != 0) {
-		printk(KERN_ERR "%s: Unable initialise the firmware\n",
-								__func__);
-		return ret;
-	}
-
 	state->dnxt.delivery = c->modulation;
 	state->dnxt.frequency = c->frequency;
 	state->dnxt.rolloff = 2; /* fixme */
@@ -1353,6 +1345,12 @@ static int ds3000_initfe(struct dvb_frontend *fe)
 	ds3000_tuner_writereg(state, 0x42, 0x73);
 	ds3000_tuner_writereg(state, 0x05, 0x01);
 	ds3000_tuner_writereg(state, 0x62, 0xf5);
+	/* Load the firmware if required */
+	ret = ds3000_firmware_ondemand(fe);
+	if (ret != 0) {
+		printk(KERN_ERR "%s: Unable initialize firmware\n", __func__);
+		return ret;
+	}
 
 	return 0;
 }
-- 
1.7.1

