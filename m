Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:41204 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaBDU1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 15:27:37 -0500
Received: by mail-we0-f176.google.com with SMTP id q58so4625725wes.21
        for <linux-media@vger.kernel.org>; Tue, 04 Feb 2014 12:27:35 -0800 (PST)
Received: from [192.168.1.100] (188.28.136.71.threembb.co.uk. [188.28.136.71])
        by mx.google.com with ESMTPSA id ju6sm55415605wjc.1.2014.02.04.12.27.34
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 04 Feb 2014 12:27:35 -0800 (PST)
Message-ID: <1391545644.11112.26.camel@canaries32-MCP7A>
Subject: [PATCH 2/2] m88rs2000: add m88rs2000_get_tune_settings
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 04 Feb 2014 20:27:24 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add min delay of 2000 ms on symbol rate more than 3000000 and
delay of 3000ms less than this.

This prevents crashing the frontend on continuous transponder scans.

Otherwise other dvb_frontend_tune_settings are the same as default.

This makes very little time difference to good channel scans, but slows down
the set frontend where lock can never be achieved i.e. DVB-S2.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # v3.9+
---
 drivers/media/dvb-frontends/m88rs2000.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index ee2fec8..32cffca 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -715,6 +715,22 @@ static int m88rs2000_get_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int m88rs2000_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *tune)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	if (c->symbol_rate > 3000000)
+		tune->min_delay_ms = 2000;
+	else
+		tune->min_delay_ms = 3000;
+
+	tune->step_size = c->symbol_rate / 16000;
+	tune->max_drift = c->symbol_rate / 2000;
+
+	return 0;
+}
+
 static int m88rs2000_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct m88rs2000_state *state = fe->demodulator_priv;
@@ -766,6 +782,7 @@ static struct dvb_frontend_ops m88rs2000_ops = {
 
 	.set_frontend = m88rs2000_set_frontend,
 	.get_frontend = m88rs2000_get_frontend,
+	.get_tune_settings = m88rs2000_get_tune_settings,
 };
 
 struct dvb_frontend *m88rs2000_attach(const struct m88rs2000_config *config,
-- 
1.9.rc1


