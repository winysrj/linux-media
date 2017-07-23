Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33868 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdGWKNV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:21 -0400
Received: by mail-wm0-f66.google.com with SMTP id 79so1683952wmg.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:20 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 2/7] [media] dvb-frontends/stv0910: implement diseqc_send_burst
Date: Sun, 23 Jul 2017 12:13:10 +0200
Message-Id: <20170723101315.12523-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This implements the diseqc_send_burst frontend op to support sending
mini-DISEQC bursts. Picked up from dddvb's driver package where this
specific block was disabled via #if 0/#endif, but is still working
according to feedback from upstream, so add it.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 4084c142f1e4..bbe609143497 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1638,6 +1638,27 @@ static int send_master_cmd(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int send_burst(struct dvb_frontend *fe, enum fe_sec_mini_cmd burst)
+{
+	struct stv *state = fe->demodulator_priv;
+	u16 offs = state->nr ? 0x40 : 0;
+	u8 value;
+
+	if (burst == SEC_MINI_A) {
+		write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3F);
+		value = 0x00;
+	} else {
+		write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3E);
+		value = 0xFF;
+	}
+	wait_dis(state, 0x40, 0x00);
+	write_reg(state, RSTV0910_P1_DISTXFIFO + offs, value);
+	write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3A);
+	wait_dis(state, 0x20, 0x20);
+
+	return 0;
+}
+
 static int sleep(struct dvb_frontend *fe)
 {
 	struct stv *state = fe->demodulator_priv;
@@ -1673,6 +1694,7 @@ static struct dvb_frontend_ops stv0910_ops = {
 	.set_tone			= set_tone,
 
 	.diseqc_send_master_cmd		= send_master_cmd,
+	.diseqc_send_burst              = send_burst,
 };
 
 static struct stv_base *match_base(struct i2c_adapter  *i2c, u8 adr)
-- 
2.13.0
