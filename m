Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55935 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2A0UQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 15:16:48 -0500
Received: by wics10 with SMTP id s10so1545993wic.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 12:16:47 -0800 (PST)
Message-ID: <4f23062e.8f4ab40a.4c71.0c56@mx.google.com>
Subject: [PATCH 1/3] m88rs2000 remove unused get/set property from driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Fri, 27 Jan 2012 20:16:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/m88rs2000.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index a614ffe..9d29b40 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -484,20 +484,6 @@ static int m88rs2000_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int m88rs2000_set_property(struct dvb_frontend *fe,
-	struct dtv_property *p)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
-static int m88rs2000_get_property(struct dvb_frontend *fe,
-	struct dtv_property *p)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
 static int m88rs2000_tuner_gate_ctrl(struct m88rs2000_state *state, u8 offset)
 {
 	int ret;
@@ -820,8 +806,6 @@ static struct dvb_frontend_ops m88rs2000_ops = {
 	.set_tone = m88rs2000_set_tone,
 	.set_voltage = m88rs2000_set_voltage,
 
-	.set_property = m88rs2000_set_property,
-	.get_property = m88rs2000_get_property,
 	.set_frontend = m88rs2000_set_frontend,
 	.get_frontend = m88rs2000_get_frontend,
 	.get_tune_settings = m88rs2000_get_tune_settings,
-- 
1.7.5.4



