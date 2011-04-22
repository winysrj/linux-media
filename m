Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab1DVJAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2011 05:00:30 -0400
Received: by wya21 with SMTP id 21so316042wya.19
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2011 02:00:29 -0700 (PDT)
Subject: [PATCH] IX2505V Keep I2C gate control alive.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 10:00:22 +0100
Message-ID: <1303462822.2525.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Gate could close after first I2C message. On stv0288 it does.
 Keep 2nd and 3rd message I2C gate control alive.
 Remove unnecessary gate closing in this module.
 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/frontends/ix2505v.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
index 6c2e929..9a517a4 100644
--- a/drivers/media/dvb/frontends/ix2505v.c
+++ b/drivers/media/dvb/frontends/ix2505v.c
@@ -218,11 +218,13 @@ static int ix2505v_set_params(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	len = sizeof(data);
-
 	ret |= ix2505v_write(state, data, len);
 
 	data[2] |= 0x4; /* set TM = 1 other bits same */
 
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
 	len = 1;
 	ret |= ix2505v_write(state, &data[2], len); /* write byte 4 only */
 
@@ -233,12 +235,12 @@ static int ix2505v_set_params(struct dvb_frontend *fe,
 
 	deb_info("Data 2=[%x%x]\n", data[2], data[3]);
 
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
 	len = 2;
 	ret |= ix2505v_write(state, &data[2], len); /* write byte 4 & 5 */
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	if (state->config->min_delay_ms)
 		msleep(state->config->min_delay_ms);
 
-- 
1.7.4.1


